import pandas as pd
import matplotlib.pyplot as plt
import os

demographics = pd.DataFrame({
    'Treatment':  ['Placebo', 'Low Dose', 'High Dose'],
    'N':          [86, 84, 84],
    'Age_Mean':   [75.2, 75.7, 74.4],
    'Age_SD':     [8.6, 8.3, 7.9],
    'Female_Pct': [61.6, 59.5, 47.6],
})

colors = ['#1C7293', '#028090', '#02C39A']

# Chart 2 - Age
fig, ax = plt.subplots(figsize=(10, 6))
fig.patch.set_facecolor('#F0F4F8')
x = range(3)
bars = ax.bar(x, demographics['Age_Mean'],
              yerr=demographics['Age_SD'],
              color=colors, width=0.5,
              edgecolor='white', capsize=8)
for bar, mean, sd in zip(bars, demographics['Age_Mean'], demographics['Age_SD']):
    ax.text(bar.get_x() + bar.get_width()/2,
            bar.get_height() + sd + 1,
            f'{mean} yrs', ha='center',
            fontsize=13, fontweight='bold', color='#0D1B40')
ax.set_title('Mean Age by Treatment Group - CDISC Pilot Study 01',
             fontsize=14, fontweight='bold', color='#0D1B40')
ax.set_ylabel('Age (Years)', fontsize=12)
ax.set_xticks(list(x))
ax.set_xticklabels(demographics['Treatment'], fontsize=12)
ax.set_ylim(0, 100)
ax.set_facecolor('white')
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
plt.tight_layout()
plt.savefig('C:/Clinical_Project/tlf/chart2_age.png', dpi=150, bbox_inches='tight')
plt.show()
print("Chart 2 done")

# Table Summary
fig, ax = plt.subplots(figsize=(13, 3))
fig.patch.set_facecolor('#F0F4F8')
ax.axis('off')

table_data = [
    ['Placebo',   '86', '75.2 (8.6)', '61.6%', '80.2%', '20.9%'],
    ['Low Dose',  '84', '75.7 (8.3)', '59.5%', '91.7%', '23.8%'],
    ['High Dose', '84', '74.4 (7.9)', '47.6%', '94.0%', '26.2%'],
]

col_labels = ['Treatment', 'N', 'Age Mean(SD)', 'Female %', 'TEAE %', 'Serious AE %']

table = ax.table(
    cellText=table_data,
    colLabels=col_labels,
    cellLoc='center',
    loc='center',
    bbox=[0, 0, 1, 1]
)

for j in range(6):
    table[0, j].set_facecolor('#0D1B40')
    table[0, j].set_text_props(color='white', fontweight='bold', fontsize=12)

for i in range(1, 4):
    for j in range(6):
        bg = '#EBF4F7' if i % 2 == 0 else 'white'
        table[i, j].set_facecolor(bg)
        table[i, j].set_text_props(fontsize=12)

table.scale(1, 2.5)

ax.set_title(
    'Table 14.1.1 Demographics and Safety Summary - Shruthi Chintalapudi 24099849',
    fontsize=13, fontweight='bold', color='#0D1B40', pad=15
)

plt.tight_layout()
plt.savefig('C:/Clinical_Project/tlf/table_summary.png', dpi=150, bbox_inches='tight')
plt.show()
print("Table done")

# Final Check
print("=" * 40)
files = [
    'C:/Clinical_Project/tlf/chart1_teae.png',
    'C:/Clinical_Project/tlf/chart2_age.png',
    'C:/Clinical_Project/tlf/chart3_sex.png',
    'C:/Clinical_Project/tlf/table_summary.png',
]
for f in files:
    status = "SAVED" if os.path.exists(f) else "MISSING"
    print(status, "-", os.path.basename(f))

print("=" * 40)
print("Python reporting complete!")
print("Shruthi Chintalapudi | 24099849")

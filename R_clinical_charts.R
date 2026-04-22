# Clinical Trial Data Pipeline - R Reporting
# Shruthi Chintalapudi - 24099849
# CDISC Pilot Study 01

# Install packages if needed
install.packages(c("ggplot2", "dplyr", "tidyr", "gridExtra"))

# Load libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(gridExtra)

# ============================================
# DATA - Real numbers from SAS Pipeline
# ============================================

demographics <- data.frame(
  Treatment  = c("Placebo", "Low Dose", "High Dose"),
  N          = c(86, 84, 84),
  Age_Mean   = c(75.2, 75.7, 74.4),
  Age_SD     = c(8.6, 8.3, 7.9),
  Female_N   = c(53, 50, 40),
  Female_Pct = c(61.6, 59.5, 47.6),
  White_Pct  = c(90.7, 92.9, 88.1)
)

teae <- data.frame(
  Treatment   = c("Placebo", "Low Dose", "High Dose"),
  TEAE_Pct    = c(80.2, 91.7, 94.0),
  Serious_Pct = c(20.9, 23.8, 26.2),
  Total_AEs   = c(310, 442, 439)
)

# Treatment as ordered factor
demographics$Treatment <- factor(
  demographics$Treatment,
  levels = c("Placebo", "Low Dose", "High Dose")
)
teae$Treatment <- factor(
  teae$Treatment,
  levels = c("Placebo", "Low Dose", "High Dose")
)

colors <- c("Placebo"    = "#1C7293",
            "Low Dose"   = "#028090",
            "High Dose"  = "#02C39A")

# ============================================
# CHART 1 - TEAE Bar Chart
# ============================================

p1 <- ggplot(teae, aes(x = Treatment, y = TEAE_Pct, fill = Treatment)) +
  geom_bar(stat = "identity", width = 0.5) +
  geom_text(aes(label = paste0(TEAE_Pct, "%")),
            vjust = -0.8, size = 5, fontface = "bold", color = "#0D1B40") +
  scale_fill_manual(values = colors) +
  scale_y_continuous(limits = c(0, 110), expand = c(0, 0)) +
  labs(
    title    = "Subjects with at least 1 Side Effect (%)",
    subtitle = "CDISC Pilot Study 01 - Safety Population (N=254)",
    x        = "Treatment Group",
    y        = "Percentage (%)",
    caption  = "Source: ADAM.ADAE | Shruthi Chintalapudi 24099849"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title    = element_text(face = "bold", color = "#0D1B40", size = 15),
    plot.subtitle = element_text(color = "#64748B", size = 12),
    plot.caption  = element_text(color = "#64748B", size = 10),
    legend.position = "none",
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    axis.text  = element_text(size = 12, color = "#0D1B40"),
    axis.title = element_text(size = 12, color = "#64748B"),
    plot.background = element_rect(fill = "#F0F4F8", color = NA)
  )

ggsave("C:/Clinical_Project/tlf/R_chart1_teae.png",
       p1, width = 10, height = 6, dpi = 150)
print(p1)
cat("R Chart 1 saved!\n")

# ============================================
# CHART 2 - Mean Age with Error Bars
# ============================================

p2 <- ggplot(demographics,
             aes(x = Treatment, y = Age_Mean, fill = Treatment)) +
  geom_bar(stat = "identity", width = 0.5) +
  geom_errorbar(aes(ymin = Age_Mean - Age_SD,
                    ymax = Age_Mean + Age_SD),
                width = 0.15, linewidth = 1, color = "#0D1B40") +
  geom_text(aes(label = paste0(Age_Mean, " yrs")),
            vjust = -2.5, size = 5, fontface = "bold", color = "#0D1B40") +
  scale_fill_manual(values = colors) +
  scale_y_continuous(limits = c(0, 100), expand = c(0, 0)) +
  labs(
    title    = "Mean Age by Treatment Group",
    subtitle = "Error bars show Standard Deviation",
    x        = "Treatment Group",
    y        = "Age (Years)",
    caption  = "Source: ADAM.ADSL | Shruthi Chintalapudi 24099849"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title    = element_text(face = "bold", color = "#0D1B40", size = 15),
    plot.subtitle = element_text(color = "#64748B", size = 12),
    plot.caption  = element_text(color = "#64748B", size = 10),
    legend.position = "none",
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    axis.text  = element_text(size = 12, color = "#0D1B40"),
    axis.title = element_text(size = 12, color = "#64748B"),
    plot.background = element_rect(fill = "#F0F4F8", color = NA)
  )

ggsave("C:/Clinical_Project/tlf/R_chart2_age.png",
       p2, width = 10, height = 6, dpi = 150)
print(p2)
cat("R Chart 2 saved!\n")

# ============================================
# CHART 3 - Sex Distribution Bar
# ============================================

sex_data <- demographics %>%
  mutate(Male_Pct = 100 - Female_Pct) %>%
  select(Treatment, Female_Pct, Male_Pct) %>%
  pivot_longer(cols = c(Female_Pct, Male_Pct),
               names_to  = "Sex",
               values_to = "Percentage") %>%
  mutate(Sex = recode(Sex,
                      "Female_Pct" = "Female",
                      "Male_Pct"   = "Male"))

p3 <- ggplot(sex_data,
             aes(x = Treatment, y = Percentage, fill = Sex)) +
  geom_bar(stat = "identity", width = 0.5) +
  geom_text(aes(label = paste0(round(Percentage, 1), "%")),
            position = position_stack(vjust = 0.5),
            size = 4.5, fontface = "bold", color = "white") +
  scale_fill_manual(values = c("Female" = "#028090",
                               "Male"   = "#CBD5E1")) +
  scale_y_continuous(limits = c(0, 110), expand = c(0, 0)) +
  labs(
    title    = "Sex Distribution by Treatment Group",
    subtitle = "Safety Population (N=254)",
    x        = "Treatment Group",
    y        = "Percentage (%)",
    fill     = "Sex",
    caption  = "Source: ADAM.ADSL | Shruthi Chintalapudi 24099849"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title    = element_text(face = "bold", color = "#0D1B40", size = 15),
    plot.subtitle = element_text(color = "#64748B", size = 12),
    plot.caption  = element_text(color = "#64748B", size = 10),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    axis.text  = element_text(size = 12, color = "#0D1B40"),
    axis.title = element_text(size = 12, color = "#64748B"),
    legend.title = element_text(size = 12),
    legend.text  = element_text(size = 11),
    plot.background = element_rect(fill = "#F0F4F8", color = NA)
  )

ggsave("C:/Clinical_Project/tlf/R_chart3_sex.png",
       p3, width = 10, height = 6, dpi = 150)
print(p3)
cat("R Chart 3 saved!\n")

# ============================================
# CHART 4 - Serious vs Non-Serious AEs
# ============================================

ae_data <- teae %>%
  mutate(NonSerious_Pct = TEAE_Pct - Serious_Pct) %>%
  select(Treatment, Serious_Pct, NonSerious_Pct) %>%
  pivot_longer(cols = c(Serious_Pct, NonSerious_Pct),
               names_to  = "Type",
               values_to = "Percentage") %>%
  mutate(Type = recode(Type,
                       "Serious_Pct"    = "Serious AE",
                       "NonSerious_Pct" = "Non-Serious AE"))

p4 <- ggplot(ae_data,
             aes(x = Treatment, y = Percentage, fill = Type)) +
  geom_bar(stat = "identity", width = 0.5) +
  geom_text(aes(label = paste0(round(Percentage, 1), "%")),
            position = position_stack(vjust = 0.5),
            size = 4.5, fontface = "bold", color = "white") +
  scale_fill_manual(values = c("Serious AE"     = "#C0392B",
                               "Non-Serious AE" = "#028090")) +
  scale_y_continuous(limits = c(0, 110), expand = c(0, 0)) +
  labs(
    title    = "Treatment-Emergent AEs by Severity Type",
    subtitle = "Serious vs Non-Serious by Treatment Group",
    x        = "Treatment Group",
    y        = "Percentage of Subjects (%)",
    fill     = "AE Type",
    caption  = "Source: ADAM.ADAE | Shruthi Chintalapudi 24099849"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title    = element_text(face = "bold", color = "#0D1B40", size = 15),
    plot.subtitle = element_text(color = "#64748B", size = 12),
    plot.caption  = element_text(color = "#64748B", size = 10),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    axis.text  = element_text(size = 12, color = "#0D1B40"),
    axis.title = element_text(size = 12, color = "#64748B"),
    legend.title = element_text(size = 12),
    legend.text  = element_text(size = 11),
    plot.background = element_rect(fill = "#F0F4F8", color = NA)
  )

ggsave("C:/Clinical_Project/tlf/R_chart4_ae_type.png",
       p4, width = 10, height = 6, dpi = 150)
print(p4)
cat("R Chart 4 saved!\n")

# ============================================
# FINAL CHECK
# ============================================

files <- c(
  "C:/Clinical_Project/tlf/R_chart1_teae.png",
  "C:/Clinical_Project/tlf/R_chart2_age.png",
  "C:/Clinical_Project/tlf/R_chart3_sex.png",
  "C:/Clinical_Project/tlf/R_chart4_ae_type.png"
)

cat("\n==========================================\n")
cat("R REPORTING COMPLETE\n")
cat("==========================================\n")
for (f in files) {
  status <- ifelse(file.exists(f), "SAVED", "MISSING")
  cat(status, "-", basename(f), "\n")
}
cat("==========================================\n")
cat("Shruthi Chintalapudi | 24099849\n")
cat("CDISC Pilot Study 01 - R Analysis\n")
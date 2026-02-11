
#stack
library(tidyverse)
library(readr)
library(lintr)
library(docstring)


#identificeren van niet behandelbare waardes uit database
dirty_values <- c("", "NA", "NULL", "Not Set", 
                  "333333", "333333,00", "333333.00", 
                  "888", "888,00", "888.00")

#Inlezen van 'raw' data, caution read_osseo_data is used for european style delimiter;

read_osseo_data <- function(file_path) {
#'@title read the data and clean
#'@description This function helps in cleaning the data for inconsistent values.
#'It is specified for a specific data set, and values can be
#'changed in the dirty values vector.
  read_delim(
    file = file_path,
    delim = ";",
    locale = locale(decimal_mark = ".", grouping_mark = ""),
    trim_ws = TRUE,          # Clean up accidental spaces
    escape_double = FALSE,   # As per your previous snippet
    show_col_types = FALSE,   # Keeps the console output clean
    na = dirty_values
  )
}

qtfa_nl <- read_osseo_data("../../data/raw/synthetic/Osseointegration_NIEUW_QTFA_NL_V2_export_20260107.csv")
qtfa_uk <- read_osseo_data("../../data/raw/synthetic/Osseointegration_NIEUW_QTFA_UK_V2_export_20260107.csv")
func_assessments <- read_osseo_data("../../data/raw/synthetic/Osseointegration_NIEUW_Functional_assessments_export_20260107.csv")

cat("Rows loaded:\n")
cat("QTFA NL:", nrow(qtfa_nl), "\n")
cat("QTFA UK:", nrow(qtfa_uk), "\n")
cat("Functional:", nrow(func_assessments), "\n")

#Clean and standardise functional assessesments
func_clean <- func_assessments %>%
  mutate(
    Height_m_clean = if_else(Height_m >3, Height_m / 100, Height_m), #If hight > 3 it's cm, divide by 100
    BMI = Weight_WP_kg / (Height_m_clean ^ 2)
  )

#Combing all Q-TFA datasets:

colnames(qtfa_uk) <- gsub("^UK_", "", colnames(qtfa_uk))
#track source
qtfa_nl <- qtfa_nl %>% mutate(Source_Country = "NL")
qtfa_uk <- qtfa_uk %>% mutate(Source_Country = "UK")
#combine
qtfa_combined <- bind_rows(qtfa_nl, qtfa_uk) %>%
  mutate(
    Unique_ID = paste(Source_Country, "Castor Participant ID", sep = "_"),
    Assessment_Date = dmy(V2QTFA_date),
    Year = year(Assessment_Date),
    Study_Cohort = case_when(
      Year >= 2009 & Year <= 2023 ~ "Derivation",
      Year >= 2024 & Year <= 2025 ~ "Validation",
      TRUE ~ "Excluded_Date_Range"
    ),#Define "Structural Missing" Stratum (Non-users), data uses 1.0 for Yes and 0.0 for No
    #clear Logical (TRUE/FALSE) column
    Is_Non_User = if_else(V2QTFA_Prosthetic_user == 0, TRUE, FALSE, missing = FALSE)
  )

#check table for users and non prosthetic users

count(qtfa_combined, Study_Cohort)

count(qtfa_combined, Is_Non_User)

#Visual Missingness Diagnosis
```{r}
missing_data_long <- qtfa_combined %>%
  select(Unique_ID, Is_Non_User, 
         starts_with("V2QTFA_PS_P"), #trouble Q
         starts_with("V2QTFA_PS_QoL")) %>% # Qol Q
  pivot_longer(
    cols = starts_with("V2QTFA_PS_"),
    names_to = "Item",
    values_to = "Score"
  ) %>%
  mutate(
    Status = if_else(is.na(Score), "Missing", "Present"),
    Item = factor(Item, levels = str_sort(unique(Item), numeric = TRUE))
  )

#Heatmap

ggplot(missing_data_long, aes(x = Item, y = Unique_ID, fill = Status)) +
  geom_tile() +
  scale_fill_manual(values = c("Present" = "grey80", "Missing" = "firebrick")) +
  facet_grid(Is_Non_User ~ ., scales = "free_y", space = "free_y", 
             labeller = label_both) + # Splits the plot: Users vs Non-Users
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1, size = 6),
    axis.text.y = element_blank(), # Hide Patient IDs to keep it clean
    panel.grid = element_blank()
  ) +
  labs(
    title = "Missingness Map: Structural (Non-Users) vs Random",
    subtitle = "Top Panel: Users (FALSE) | Bottom Panel: Non-Users (TRUE)",
    y = "Patients",
    x = "Questionnaire Items"
  )

#Save Plot
ggsave(
  filename = "Missingness_Heatmap_Analysis.png",
  width = 14,    # Wide enough to read the 60 question labels
  height = 10,   # Tall enough to see the patient rows
  dpi = 300      # High resolution (dots per inch) for zooming in
)

# To find where it was saved, run this command:
getwd()


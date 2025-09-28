# COVID-19 Data Analysis

This repository contains an R project analyzing COVID-19 patient data to explore factors affecting mortality, such as age and gender. The analysis includes statistical tests, effect size measurements, logistic regression modeling, and data visualizations.

---

## Contents

- `covid_script.R` – Main R script performing data cleaning, exploratory data analysis (EDA), statistical tests, effect size calculation, logistic regression modeling, and visualizations.  
- `COVID19_line_list_data.csv` – Original dataset containing patient-level COVID-19 data.

---

## Methodology

1. **Data Cleaning & Preprocessing**
   - Checked for missing values
   - Created a binary death column (`death_dummy`)
   - Removed incomplete records (if necessary)

2. **Exploratory Data Analysis (EDA)**
   - Summary statistics (mean, counts, etc.)
   - Age distribution by survival status
   - Mortality rates by gender

3. **Statistical Testing**
   - T-test for age differences
   - Wilcoxon rank-sum test (non-parametric check)
   - Chi-squared test for gender vs mortality
   - Effect size calculation (Cohen's d)

4. **Multivariate Analysis**
   - Logistic regression: mortality predicted by age and gender
   - Odds ratios with confidence intervals
   - Visualization of predicted death probabilities vs age by gender

---

## Key Findings

- The age difference between deceased and survivors is **large** (Cohen’s d ≈ 1.17, very large effect).  
- Mortality is significantly higher in **men** than in women (Chi-square test and confidence intervals confirm).  
- Logistic regression shows both **age** and **gender** are strong predictors of COVID-19 mortality.  
- Visualizations support the statistical findings and provide an intuitive understanding of the data.

---

## Usage

1. Open `covid_script.R` in RStudio.  
2. Run the script step by step to reproduce the analysis.  
3. Ensure required libraries are installed:
   ```r
   install.packages(c("Hmisc", "ggplot2", "effsize"))

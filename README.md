# Abalone Age Predictor 

This project applies the linear regression machine learning model to predict the age of abalone based on their physical characteristics like length, diameter, whole weight, and more. The final report and presented poster are included from this project. 

---

## Dataset
- **Source**: [UCI Machine Learning Repository - Age of Abalone Prediction Dataset]([https://www.kaggle.com/datasets/fedesoriano/heart-failure-prediction](https://archive.ics.uci.edu/dataset/1/abalone)) 
- **Rows**: 4177 observations
- **Target Variable**: 'Rings' 

**Included Attributes**
- Sex, Length, Diameter, Height, Whole Weight, Shucked Weight, Viscera Weight, Shell Weight, and Rings.

---

## Tools

- RStudio
- Libraries:
    - 'tidyverse', 'knitr', 'lavaan', 'psych', 'MBESS'
      
---

## Model Building

Implemented Linear Regression to build four models: 

- Model 1: Original model without categorical variable
- Model 2: Original model with categorical variable
- Model 3: Log transformed model of the response variable
- Model 4: Log transformed model and influential observations removed 

All models were created from:
- A random sample of 500 abalone from the dataset
- Data with infant abalone removed

---

## Workflow Summary

1. **Data Exploration**
   Used summary statistics, correlations, and various plots to understand the dataset.

2. **Transforming the Model**
   - Perform a log transformation on the response variable
   - Obtain the leverage values
   - Get Cook's distance
   - Remove the influential observations in the model

3. **Model Evaluation**
   R-squared and Adjusted R-squared
   
   Diagnostic Plots:
   - Residuals vs. Fitted
   - Scale-Location
   - Q-Q Residuals
   - Residuals vs. Leverage

---

## Results

- Original models did not do well in terms of linearity and placement of residuals in the plots.
- After the transformations, the diagnostic plots were much better.
- The low R-squared values show the model does not perform the best, but it is certainly a good base model. 



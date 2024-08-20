# Excess Deaths in the United States during the COVID-19 Pandemic

## Introduction
The COVID-19 pandemic reshaped global public health landscapes, leading to unprecedented levels of mortality across the world. While official death counts often focus on those directly confirmed to have died from COVID-19, this project aims to explore the broader impact by analyzing "excess deaths" in the United States during the pandemic. Excess deaths are defined as the difference between observed deaths and expected deaths based on historical trends, providing a more comprehensive picture of the pandemic's mortality impact. To conduct this analysis, various R packages were utilized, including `ggplot2` for data visualization, `forecast` for time series modeling, and `urca` for stationarity testing, providing a robust framework for understanding the pandemic's true mortality toll.

## Purpose
The primary goal of this project is to estimate excess mortality in the United States during the COVID-19 pandemic by applying time series analysis techniques to historical death data. By comparing these estimates to reported COVID-19 deaths, the project seeks to uncover potential underreporting and provide a clearer understanding of the pandemic's true toll.

## Significance
Accurately estimating excess deaths is crucial for understanding the full impact of the COVID-19 pandemic on public health. This analysis not only offers insights into the actual number of deaths that may be attributable to the pandemic but also informs public health policies and strategies for future crisis management. By capturing the broader mortality effects, this project contributes to ongoing efforts to assess and mitigate the impacts of global health emergencies.

## Project Overview
### Data Source:
The analysis is based on weekly all-cause mortality data from the National Center for Health Statistics (NCHS) spanning from October 2009 to February 2022.

### Methodology:
1. Data Preparation: The dataset was divided into a training set (pre-pandemic) and a testing set (pandemic period). Time series analysis was applied to the training set to develop a model for expected deaths.
2. Modeling: A seasonal ARIMA model was selected through extensive model comparison using the Akaike Information Criterion (AIC). The model was then used to predict deaths during the pandemic period.
3. Excess Deaths Calculation: Excess deaths were calculated as the difference between observed deaths and the upper bound of the 95% prediction interval from the ARIMA model. These were compared with reported COVID-19 deaths to assess the relationship between them.

## Findings and Conclusions
### Excess Deaths Estimation: 
The analysis estimated approximately 883,510 excess deaths in the United States during the pandemic period, compared to 981,196 officially reported COVID-19 deaths. This suggests a strong correlation (r = 0.951) between excess deaths and reported COVID-19 deaths.

### Seasonality and Mortality Trends: 
The pandemic significantly disrupted typical seasonal mortality patterns, with deaths peaking at unusual times and at levels far exceeding historical trends.

### Implications: 
The findings underscore the importance of considering excess deaths in pandemic mortality assessments, particularly in the early stages when underreporting and limited testing capacity may obscure the true impact.

## References
This project utilized the NCHS mortality data and employed R for time series analysis. Further details, including code and visualizations, are available within this repository.

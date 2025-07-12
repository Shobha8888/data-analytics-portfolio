# data-analytics-portfolio
Movie Correlation Analysis Project
Overview
This project explores the relationships between various attributes of movies, such as budget, gross earnings, votes, ratings, and more. Using a dataset of over 7,600 movies, the analysis identifies which factors are most strongly correlated with box office success.

Dataset
Source: Kaggle - Movies Dataset
Rows: 7,668
Columns: 15

Features:
name, rating, genre, year, released, score, votes, director, writer, star, country, budget, gross, company, runtime

Tools & Libraries
Python (pandas, numpy)

Data visualization: matplotlib, seaborn
Jupyter Notebook

Key Steps
Data Cleaning
Handled missing values in columns like budget, gross, and votes
Converted data types for numerical analysis
Removed duplicates and standardized column names
Exploratory Data Analysis (EDA)
Inspected distributions of key features
Visualized gross earnings vs. budget and votes
Correlation Analysis
Calculated Pearson correlation coefficients between numeric variables
Visualized the correlation matrix using a heatmap
Insights & Findings
Identified the strongest predictors of box office gross

Main Findings
Budget and votes have the highest positive correlation with gross earnings.
Movies with higher budgets tend to earn more at the box office.
Movies that receive more audience votes (ratings) also tend to have higher gross earnings.
Other features, such as genre or rating, showed weaker correlations with gross.

Visualizations
![Correlation Heatmap](correlation_heatmap.pngrelation heatmap showing relationships between numeric features.*

   

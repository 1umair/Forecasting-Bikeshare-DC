# MGT 6203: Progress Report

#### Team 10

#### Umair Zakir Abowath- Josh Blakely- Daniel Garrison- Eric Loui- Adam Peir

# Table of Contents
I. Introduction
1. Brief Overview of the Project

II. Current Status of the Project
A. Data Cleaning and Preprocessing
B. Exploratory Data Analysis/Visualizations
C. Key Findings/Adjustments
D. Challenges Encountered

III. Ongoing Work
A. Intermediate Data Preparation
B. Preliminary Modeling
C. Expected Milestones and Deliverables

IV. Explanation and Background Information
A. Provide Background on the Statistical Models Used
B. Explain the Methodology and Approach
C. Justify the Selection of Models and Techniques

V. Literature Review Summary

VI. Works Cited

# Introduction


# Current Status of the Project

## Data Cleaning and Preprocessing
The dataset has required minimal cleaning. We had to convert several variables into factor variables (season, holiday, weekday, workingday, weather). Additionally we noted that the data key for our dataset mislabeled the season factor variable, which was trivial to correct.

## EDA / Visualization

Not all of our predictors or response variables are distributed normally. In particular, humidity exhibits leftward skew, and windspeed exhibits rightward skew.

Casual users exhibit rightward skew, while registered users are not too far from the normal distribution.

Preliminary EDA reveals strong seasonality - overall usage on a daily basis is much higher in spring/summer than fall and much more than winter. 

Generally, casual users exhibit vastly different usage patterns from the baseline (registered users), indicating we may want a separate model for casual users.

# Ongoing Work 

Anticipated challenges:

* Distinguishing between the influences of weather and the influence of the season, particularly on casual usage. DC has many visitors in Spring and Summer who would show up under the casual response variable.
* Accounting for the overall increase in usage over the two years spanning our dataset. The dataset was collected towards the beginning of the Capital Bikeshare program, so findings we draw from the overall increasing usage would not necessarily translate directly to mature systems.

# Explanation and Background Information

# Literature Review Summary

Existing literature around bikeshare usage generally emphasizes the following:

* Time of day is typically the most important predictor, but different days of the week have different trends based on time of day
* Specifically, usage is often bimodal on weekdays reflecting commuter patterns
* Usage is not bimodal on weekends, typically with the highest value in mid-afternoon.
* Usage increases as temperature increases, then starts to decrease as temperatures go into the 90s (Fahrenheit), which can be too hot
* Precipitation of any amount discourages cycling
* High humidity has a negative effect on cycling
* High winds can have a negative effect on cycling
* Usage is often higher in spring and summer, and lowest in winter

# Works Cited

Bean, R., Pojani, D., & Corcoran, J. (2021). How does weather affect bikeshare use? A comparative analysis of forty cities across climate zones. _Journal of Transport Geography_, 95. https://doi.org/10.1016/j.jtrangeo.2021.103155.

Eren, E., & Uz, V. E. (2020). A review on bike-sharing: The factors affecting bike-sharing demand. _Sustainable Cities and Society_, 54. https://doi.org/10.1016/j.scs.2019.101882

Ashgar, H. I., Elhenawy, M., & Rakha, H. A. (2019). Modeling bike counts in a bike-sharing system considering the effect of weather conditions. _Case Studies on Transport Policy_, 7(2), 261-268. https://doi.org/10.1016/j.cstp.2019.02.011

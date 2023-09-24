# MGT 6203 Group Project Proposal Template

Please edit the following template to record your responses and provide details on your project plan. 

# TEAM INFORMATION (1 point)

Team #: 10
Team Members: 

* Eric Loui, GT ID 832603. Over a decade of experience in cybersecurity as a cyber threat intelligence analyst and teamlead. Currently a Principal Intelligence Analyst at CrowdStrike. Dayjob involves basic python scripting to automate workflows and data analysis. Occasionally I have experimented with doing basic K-means or linear regression on cybersecurity datasets. I regularly write reports and have in the past made many presentations to communicate findings of research and analysis. Formal education: BA, Political Science, Swarthmore College (2009); MA, International Affairs, American University (2013); Professional Certificate, Data Science, Cal State Fullerton (2021).

[Insert background information: Name, professional background, education background, previous 	analytics related projects you have worked on]

* Daniel Garrison, GT ID 903935213. I graduated December 2022 with a Bachelor of Science in Applied and Computational Mathematics from Kennesaw State University. After graduation, I began employment at Morgan Stanley, and I am in the process of transitioning to a portfolio manager position. I mainly use excel at work; however, I am well-versed in both python and R because of my academic background. I've taken courses in bayesian statistics and regression analysis, and I am proficient in discrete math and linear algebra. My senior year I did research on modeling the movement of C. Elegans (nematodes) using partial differential equations in python.
* Team Member 3 Name; GT Id or EdX username 
* Team Member 4 Name; GT Id or EdX username 
* Team Member 5 Name; GT Id or EdX username 

# OBJECTIVE/PROBLEM (5 points)

#### Project Title: 
#### Background Information on chosen project topic: 
Bikesharing systems are an increasingly popular solution in major urban areas to increase trips taken by bike, which can help people get around without cars, thus improving the lives of both users, as well as non-users, as each bike trip potentially represents a trip that would otherwise have required a car. We hope to use data from DC’s Capital Bikeshare in 2011 and 2012 to predict bikeshare usage system-wide.


### Problem Statement (clear and concise statement explaining purpose of your analysis and investigation): 

### State your Primary Research Question (RQ): 

#### Add some possible Supporting Research Questions (2-4 RQs that support problem statement): 
* What are the main factors influencing bikesharing rates?



### Business Justification: 
(Why is this problem interesting to solve from a business viewpoint? Try to quantify the financial, marketing or operational aspects and implications of this problem, as if you were running a company, non-profit organization, city or government that is encountering this problem.)


Increasing the fraction of trips taken by bike is beneficial to urban planners, as it reduces traffic and consequent pollution on local roads, and helps people get exercise. We want to help future bikeshare programs be able to predict demand, in order to make sure their own bikeshare programs are resourced well for peak times and days. Additionally, knowing when demand is likely to be low is also beneficial, as this helps planners know when to temporarily take bikes or docks out of commission for maintenance or upgrades with minimal impact to users.


# DATASET/PLAN FOR DATA (4 points)
## Data Sources (links, attachments, etc.): 
https://archive.ics.uci.edu/dataset/275/bike+sharing+dataset 

2011 and 2012 historical usage data from Washington, DC’s public Capital Bikeshare program, one of the first large scale bikeshare programs in the nation.

Data Description (describe each of your data sources, include screenshots of a few rows of data): 
* hour.csv : bike sharing counts aggregated on hourly basis. Records: 17379 hours
* day.csv - bike sharing counts aggregated on daily basis. Records: 731 days
* Both hour.csv and day.csv have the following fields, except hr which is not available in day.csv
    
    - instant: record index
    - dteday : date
    - season : season (1:springer, 2:summer, 3:fall, 4:winter)
    - yr : year (0: 2011, 1:2012)
    - mnth : month ( 1 to 12)
    - hr : hour (0 to 23)
    - holiday : weather day is holiday or not (extracted from http://dchr.dc.gov/page/holiday-schedule)
    - weekday : day of the week
    - workingday : if day is neither weekend nor holiday is 1, otherwise is 0.
    + weathersit :
   	 - 1: Clear, Few clouds, Partly cloudy, Partly cloudy
   	 - 2: Mist + Cloudy, Mist + Broken clouds, Mist + Few clouds, Mist
   	 - 3: Light Snow, Light Rain + Thunderstorm + Scattered clouds, Light Rain + Scattered clouds
   	 - 4: Heavy Rain + Ice Pallets + Thunderstorm + Mist, Snow + Fog
    - temp : Normalized temperature in Celsius. The values are divided to 41 (max)
    - atemp: Normalized feeling temperature in Celsius. The values are divided to 50 (max)
    - hum: Normalized humidity. The values are divided to 100 (max)
    - windspeed: Normalized wind speed. The values are divided to 67 (max)
    - casual: count of casual users
    - registered: count of registered users
    - cnt: count of total rental bikes including both casual and registered

![day](dayscreenshot.png)

![hour](hourscreenshot.png)

### Key Variables: (which ones will be considered independent and dependent? Are you going to create new variables? What variables do you hypothesize beforehand to be most important?)
* The dependent variables will likely be one or more of: casual, registered, cnt - since we want to predict usage
* The independent variables will likely be some combination of all the other variables.

# APPROACH/METHODOLOGY (8 points)
## Planned Approach (
    In paragraph(s), describe the approach you will take and what are the models you will try to use? Mention any data transformations that would need to happen. How do you plan to compare your models? How do you plan to train and optimize your model hyper-parameters?))


## Anticipated Conclusions/Hypothesis 
(what results do you expect, how will you approach lead you to determining the final conclusion of your analysis) Note: At the end of the project, you do not have to be correct or have acceptable accuracy, the purpose is to walk us through an analysis that gives the reader insight into the conclusion regarding your objective/problem statement




### What business decisions will be impacted by the results of your analysis? What could be some benefits?




# PROJECT TIMELINE/PLANNING (2 points)
## Project Timeline/Mention key dates you hope to achieve certain milestones by:




## Appendix (any preliminary figures or charts that you would like to include): 
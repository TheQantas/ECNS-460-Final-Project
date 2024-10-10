
# ECNS 460 Term Project
# Nick Hagerty
# Fall 2024

Throughout the rest of the semester, you will pursue an independent project to analyze data in an area of your own interest. This is your chance not only to show off all the skills you’ve learned in this course, but also to challenge yourself to learn at least one new tool not covered in class. There will be two main stages: a Visualization, and an Analysis or Product. The final outputs will consist of a GitHub code repository, a written report, and a short class presentation.

Teams. I strongly encourage you to work in teams of 2 students. The project may also be done alone, but expectations and grading standards will be the same. Teams of more than 2 students are not generally permitted. If you really want to work in a team of 3, you will need to meet with me to ask for special permission, and your team will be held to higher expectations. If you would like me to assign you to a partner, I am happy to play matchmaker – just email me.
## Stage 1: Plan

*Due Thursday, October 10 by class time, on GitHub.*

Agree on a topic for your project with your partner. It can be anything relevant to economics, public policy, or business, but you should both find it interesting! Your topic should be new to you – don’t use the same topic any of your team members have used for another class.

Make a broad plan for the Analysis/Product stage. Read the instructions for Stage 3 below and agree on a tentative plan for what you’re going to do for the Analysis/Product (you can change it later). If you’re going to do an Analysis, write down your research question and the type of analysis you’re planning to conduct. If you’re going to build a Product, write down your goal, intended audience, and what you are thinking of producing.

Decide on a challenge to undertake. Choose a new tool (or more than one!) that you would like to teach yourself on your own and use in your project. It should be related to the tools we are covering in this course, but clearly different, and it must be new to both team members. You can implement the challenge in either the Visualization or the Analysis/Product stage of the project, or both. If you choose to build a Product, your challenge might be the same thing as the product. Here are some possible challenges; you may think of others:

* Webscraping, beyond the examples covered in class.
* Spatial analysis, beyond the examples covered in class.
* Work with raster data (e.g. in Google Earth Engine).
* Use more advanced ML models, such as neural nets/deep learning.
* Use ML models for classification tasks.
* Cloud computing for working with datasets that are too large for your laptop.
* Set up a database, for an appropriate purpose.
* Make a Shiny app (an interactive web app).
* Write a new R package that is useful to others.

Find data from at least two different sources that are related to your topic. Download them and make sure you’re going to able to use them for analysis. The datasets should relate to each other in some way that will allow you to join (merge) them together, but you don’t have to do that yet. All data you use should be publicly available and come from the original (primary) source. They should not be pre-cleaned, which would prevent you from getting experience processing the data. No datasets we’ve used in class, datasets that get automatically loaded in R packages, or datasets posted on Kaggle or similar repositories.

Create a public repository on GitHub for your project. (You can always make your repo private after the semester if you prefer, but past projects on your GitHub account will look great to future employers.) Add a document that describes your topic, your tentative Analysis/Product plan, and the challenge you are choosing. Then, describe your datasets. Include the source URL, what kind of variables are contained in each dataset (no need for a full list), the timespan and spatial coverage of the datasets, and how the datasets are related to each other.

Submit the URL of your GitHub repo to D2L, so I know where to find it. I will provide feedback, but you’re also welcome to discuss your project with me in office hours.
## Stage 2: Visualization

*Due Thursday, October 31 by class time, on GitHub.*

Wrangle, clean, and explore your data: Import your datasets into R, wrangle them into tidy format, and join them into a single data frame. Clean your data, keeping in mind our Data Cleaning Checklist as necessary. Explore your data as necessary to understand it well and to make sound decisions about extreme values and missing data.

Produce a set of compelling visualizations: Using your cleaned data, develop a set of figures that could be interesting or useful to a policymaker, business executive, or other groups of people. There are limitless numbers of cool things you can do with ggplot2 – try to impress me!

Each figure should have a clear purpose. Think carefully about the principles of good data visualization we discuss in class. Ask yourself: Is this figure the very best way of conveying the information I am trying to communicate?
As a very rough guideline, you might aim for 4-6 well-constructed figures, but the appropriate number will depend on your specific circumstances.
Your figures should look professional and include titles and appropriate labels.

Put together a write-up in PDF or HTML format that includes:

* Your topic, motivation, and a brief description of your data and where you got it.
* An explanation of how you processed your data and why you made the choices you did.
* The figures you developed (embedded as images).
* For each figure, explain your intended purpose, why you made the specific visualization choices you did, and how those choices support the figure’s purpose.

This write-up does not need to be long. Unlike the homework assignments, the document should NOT contain R code or raw output. Instead, export your figures as image files and then embed them in your write-up.

Organize your code and project folder, following best practices discussed in class. These include commenting; using relative filepaths instead of absolute ones; using separate R scripts for each phase of your work; saving and loading intermediate outputs as .Rdata files; putting raw data, code, cleaned data, and output in separate folders, and all giving files and folders informative names.

Collaborate on GitHub: If working with a partner, use GitHub as your platform for sharing files throughout the assignment. If working alone, still use it to store and back up your project as you work. Each team member must make at least one substantive commit to the repo, so that everyone gets some practice with GitHub.

Commit and push a complete replication package to your GitHub repository. Make sure your repo includes your raw data, your R scripts, the final cleaned dataset(s), the source code for your write-up, and the final write-up document in HTML or PDF format.
## Stage 3: Analysis or Product

*Due Thursday, December 5 by class time, on GitHub.*

This stage is more open-ended. Basically, I want you to use skills you’ve learned in this course to do something useful with your data. If you prefer some structure, conduct an Analysis. If you have a different idea you’d like to pursue, it is probably a Product. If you’re unsure whether your idea fits within the scope of this project, ask me about it.

**(Option A)** Analysis: Answer a research question. Start by finalizing a well-defined research question that your data can help you answer. Here are a few examples of good research questions:

* **Descriptive:** Has wealth inequality increased in the U.S. faster than in Europe since 2000?
* **Causal:** Does receiving Medicaid coverage reduce the risk of bankruptcy?
* **Predictve:** Can nighttime satellite imagery be used as a real-time indicator of economic activity?

Then conduct an analysis appropriate to the type of question you are asking.

* **Descriptive analysis:** Conduct an exploratory analysis of the variables involved in your research question, investigating their distributions and relationships visually. Then use regression modeling to quantify these relationships and conduct statistical inference on them. Write down the regression models you use and interpret your results in words.

* **Causal analysis:** Conduct a descriptive analysis, but interpret it through the lens of causal inference – how plausible is it, what are the likely sources of bias, what is the likely direction of bias? What is the ideal experiment and how does your situation compare? If you can, see if you can come up with a research design that produces better comparisons / more plausible counterfactuals.

* **Predictive analysis:** Train a machine learning model to predict your outcome variable using other variables in your data. Follow all the correct ML procedures: set aside a test set, tune your model(s) through cross-validation, and evaluate performance in the test set only after finalizing your model. Interpret the model’s performance and its limitations.

**(Option B)** Product: Build something new. Alternatively, you can create an product that makes it easier for other people to ask and answer their own questions using your data. Start with a well-defined goal and intended audience, and then go try to achieve that goal. Here are a few products I can imagine; you may think of others:

* Create a new dataset that adds value to your raw data (such that others might want to use it in their own analysis).
* Use Shiny to build an interactive web dashboard aimed at a specific audience.
* Develop a new R package related to your data.

Then:

Write up a report in PDF or HTML format.

For an Analysis, describe your research question and why it matters, explain why you chose the type of analysis you did, describe your methods and the specific choices you made along the way, and present your results.

For a Product, describe your goal and intended audience and why it matters, explain how your methods and the specific choices you made along the way, and present or document your product.

In either case, explain what challenge you completed (unless you already did so in the Visualization stage).

Focus on quality over quantity. Make your report thorough but succinct. Your report should look neat and professional. Again, this document should not contain R code or raw output, but it can embed images and other files. Use headings to organize the document, write clearly and straightforwardly but not informally, and check your spelling and grammar.

AI disclosure: If you choose to use ChatGPT or other chatbots or AI technology to help you complete your project, give an explanation of how you used AI and for what parts of the project.

Commit and push your project to GitHub. Continue to follow best practices for organizing your project. Ensure your final repo includes all scripts, inputs, outputs, and reports from both the Visualization and Analysis/Product stages.
## Stage 4: Presentation

*Slides due Tuesday, December 10 by 8 am. (Class meets 8:00-9:50 on Dec. 10.) Upload link will be provided.*

During finals week, you will give a short presentation on your project. Oral communication is an absolutely crucial part of being a data scientist or economist. However, the presentation is a small part of the project grade – I’m hoping it will be rewarding to show your classmates what you’ve been working on and in turn to see what they’ve been doing.

Your team’s presentation should last for just 5 to 6 minutes. Prepare a few slides briefly describing whatever you are excited to share about your project. (If unsure, you can briefly describe your topic and motivation; data and any unusual methods you used for acquiring, processing, or analyzing it; key data visualizations; and results of analysis.)
## Stage 5: Team Evaluation

*Due Tuesday, December 10 by 8 am, on D2L.*

Unless you worked individually, submit a short evaluation of whether you and your team member(s) distributed work equally or if the work was unequal. If it was unequal, describe the contributions of each team member and whether you believe you should receive a different grade than the other team member(s).
Grading

Project grades will be based on the following categories:

#### Visualization (40 points)
* Style, coding practices, file organization.
* Data wrangling and cleaning (demonstration of skills and principles).
* Visualizations (demonstration of skills and principles).
* Effectiveness and interpretation.
#### Analysis (40 points)
* Effectiveness (goal is well-defined, chosen tools are appropriate, goal is met).
* Demonstration of analytical skills from this course (show me what can you do).
* Appropriate use of chosen tools (getting the details right and making good judgments).
* Communication (writing is clear, document is professional)
#### Challenge (10+ points)
* Demonstrated use of tools beyond the course material.
#### Presentation (10 points)
* Slides and delivery.

An “A” grade means your project exceeds expectations. It:

* Demonstrates a wide range of skills covered in this course.
* Carefully follows best practices from nearly all topics in this course.
* Challenges yourself in a meaningful way (i.e., you went beyond the assignment minimum expectations).

A “B” grade means your project meets expectations. It fulfills the requirements and shows a range of skills from this course. It may not precisely follow every best practice but gets the job done.

A “C” grade means your project meets some expectations but has problems or omissions that limit its effectiveness. A typical student probably could have submitted most of it before taking this course.

library(shiny)
shinyUI(fluidPage(
  titlePanel("Fun with iris"),
  tabsetPanel(
    tabPanel("iris Flower Species Predictor",fluidPage(
      h5('This tab gives you the predicted species of a flower based 
           on the 4 flower characteristics below. The predictor uses the iris dataset and the random
           forest method to build the model. The iris dataset is split into a training
           and testing set of 60/40 proportion, and the accuracy of the model is also
           given based on how well the model trained by the training set predicts the 
           testing set. Just set the seed and the flower characteristics, and hit "Submit!" to run the results!'),
      hr(),
      sidebarLayout(
        sidebarPanel(
          numericInput("seed","Set the seed for training the model",value=12345),
          sliderInput("Sepal.Length","What is the Sepal Length?",4.3,7.9,5.8,0.1,ticks=FALSE),
          sliderInput("Sepal.Width","What is the Sepal Width?",2,4.4,3,0.1,ticks=FALSE),
          sliderInput("Petal.Length","What is the Petal Length?",1,6.9,4.4,0.1,ticks=FALSE),
          sliderInput("Petal.Width","What is the Petal Width?",0.1,2.5,1.3,0.1,ticks=FALSE),
          submitButton("Submit!")
        ),
        mainPanel(
          h3("Species Prediction (based on Random Forest):"),
          verbatimTextOutput("prediction"),
          h4("Accuracy of Model"),
          verbatimTextOutput("accuracy"),
          br(),
          h4("for your Submitted Inputs:"),
          h5("Seed"),
          verbatimTextOutput("seed"),
          h5("Sepal Length"),
          verbatimTextOutput("Sepal.Length"),
          h5("Sepal Width"),
          verbatimTextOutput("Sepal.Width"),
          h5("Petal Length"),
          verbatimTextOutput("Petal.Length"),
          h5("Petal Width"),
          verbatimTextOutput("Petal.Width")
        )
      )
    )),
    
    tabPanel("iris Comparison by Species",fluidPage(
      h5('This tab allows you to visualize the differences in the 4 flower characteristics
         between the species by plotting a boxplot. Just select which flower characteristic
         you would like to visualize, and click on "Plot Now!" to plot the boxplot once you
         are ready! A table of the means of each variable by species is also given below.'),
      hr(),
      plotOutput("plot1"),
      hr(),
      fluidRow(
        column(7,
          tableOutput('table1')
        ),
        column(3,
          selectInput('y1','y',c('Sepal Length'='Sepal.Length',
                                'Sepal Width'='Sepal.Width',
                                'Petal Length'='Petal.Length',
                                'Petal Width'='Petal.Width')),
          br(),
          submitButton("Plot Now!")       
        )
      )
    )),
    
    tabPanel("iris Regression Visualizer", fluidPage(
      h5('This tab allows you to visualize the regression between any 2 of the 4 flower characteristics
         by plotting a scatter plot of one variable against another. You may visualize the iris
         data as a whole or by species, or choose whether or not to insert a linear regression
         line. You may also select which 2 flower characteristic you want to plot. Once ready,
         click on "Plot Now!" to plot the graph!'),
      hr(),
      plotOutput("plot2"),
      hr(),
      fluidRow(
        column(4,
          checkboxInput('color','Split Data Points by Species',value=TRUE),
          checkboxInput('line','Plot Regression Line(s)',value=TRUE)
        ),
        column(4,
          selectInput('y2','y',c('Sepal Length'='Sepal.Length',
                                'Sepal Width'='Sepal.Width',
                                'Petal Length'='Petal.Length',
                                'Petal Width'='Petal.Width'),
                      selected = 'Sepal Width'),
          selectInput('x','x',c('Sepal Length'='Sepal.Length',
                                'Sepal Width'='Sepal.Width',
                                'Petal Length'='Petal.Length',
                                'Petal Width'='Petal.Width'))
        ),
        column(4,
          br(),
          submitButton("Plot Now!")       
        )
      )
    ))
  )
))
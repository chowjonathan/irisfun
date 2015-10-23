library(shiny)
library(caret)
library(randomForest)
library(ggplot2)
library(plyr)
library(e1071)

data("iris")

partitionData <- function(seed){
  set.seed(seed)
  inTrain <- createDataPartition(y=iris$Species,p=0.6,list=FALSE)
  partData <- list()
  partData$training <- iris[inTrain,]
  partData$testing <- iris[-inTrain,]
  partData
}
fitModel <- function(partData){
  fit <- train(Species~.,partData$training,method="rf")
  fit
}
predictSpecies <- function(fit,input){
  df <- data.frame(
    Sepal.Length = input$Sepal.Length,
    Sepal.Width = input$Sepal.Width,
    Petal.Length = input$Petal.Length,
    Petal.Width = input$Petal.Width      
  )
  predict(fit,df)
}
getConfMat <- function(fit,partData){
  confusionMatrix(partData$testing$Species,predict(fit,partData$testing))$overall[1]
}

shinyServer(
  function(input,output){
    
    output$Sepal.Length <- renderText({input$Sepal.Length})
    output$Sepal.Width <- renderPrint({input$Sepal.Width})
    output$Petal.Length <- renderPrint({input$Petal.Length})
    output$Petal.Width <- renderPrint({input$Petal.Width})
    output$seed <- renderPrint({input$seed})
    
    partData <- reactive({partitionData(input$seed)})
    fit <- reactive(fitModel(partData()))
    prediction <- reactive({predictSpecies(fit(),input)})
    output$prediction <- renderPrint({as.character(prediction())})
    output$accuracy <- renderPrint({getConfMat(fit(),partData())})
    
    
    output$plot1 <- renderPlot({ 
      .e <- environment()
      g <- ggplot(data=iris,aes(x=Species,
                                y=eval(parse(text=input$y1)),
                                color=Species), 
                  environment=.e)
      g <- g + geom_boxplot()
      g <- g + theme(legend.position="top")
      g <- g + ggtitle("Comparison by Species")
      g <- g + ylab(input$y1)
      g
    })
    output$table1 <- renderTable({
      ddply(iris,.(Species),summarize,Sepal.Length=mean(Sepal.Length),
                                      Sepal.Width=mean(Sepal.Width),
                                      Petal.Length=mean(Petal.Length),
                                      Petal.Width=mean(Petal.Width)
      )
    })
    
    output$plot2 <- renderPlot({
      .e <- environment()
      if ({input$color}){
        g <- ggplot(data=iris,aes(x=eval(parse(text={input$x})),
                                  y=eval(parse(text={input$y2})),
                                  color=Species),
                    environment = .e)
      }
      else{
        g <- ggplot(data=iris,aes(x=eval(parse(text={input$x})),
                                  y=eval(parse(text={input$y2}))),
                    environment = .e)
      }
      if ({input$line}){
        g <- g + stat_smooth(method="lm",se=FALSE)
      }
      g <- g + geom_point()
      g <- g + theme(legend.position="top")
      g <- g + ggtitle("Regression Visualizer")
      g <- g + xlab({input$x}) + ylab({input$y2})
      g
    })
  }
)
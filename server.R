




shinyServer(function(input, output) {
  
  ## in the server function we first built a reactive that once we upladed our CSV
  ## read it into a dataframe
  
  mydata <-  reactive ({ xyz <- input$myfile
  
  uploaded <- read.csv(xyz$datapath, 
                       header=TRUE)
  return(uploaded)})
  
  ## Then we modify our main panel creating a new UI featuring nothing
  ## if we dont upload a file and 2 selectInput functions which allows us
  ## to pick the regressors among the names of the columns of our dataframe
  ## and one variable as the outcome...notice how our app permits a multivariate regression
  
  ##  the selectize option allows to use the javascript library
  ## selectize.js which provides a way more flexible interface
  
  ## we add a submit button which is fundamental to trigger a sort of delayed
  ## version of reactive: eventReactive
  
  output$model <- renderUI({
    
    if (is.null(input$myfile))
      return()
    
    ## we use some html to structure our output properly on the rows  
    
    tagList(fluidRow(
      column(4, selectInput("regressors", "Regressors", choices=names(mydata()), selected = NULL, multiple = TRUE,
                            selectize= TRUE)),
      
      
      
      column(4, selectInput("outcome", "Outcome", choices=names(mydata()),
                            selected = NULL, multiple = FALSE,
                            selectize= TRUE))
      
      
      
      
    ),
    
    
    ## This radioButtons allows to pick from  3 different regresion models,
    ## which are elaborated only after we click on Submit
    
    
    fluidRow(radioButtons("reg","Choose your regression",
                          c ("LM" = "LM", "Ridge" = "Ridge", "Loess"="Loess"),
                          inline=T)),
    
    
    
    
    fluidRow(actionButton("submit1", label = "Submit"))
    
    )
    
  })
  
  
  
  ## we now use eventReactive to calculate our regression models: basically
  ## the calculations are triggered only once we choose one of the 3 models available
  ## and only once we clicked on the submit button
  
  
  
  ## reformulate function allows to correctly write the regression formula
  ## in case of a multivariate linear model
  
  reg_lm <- eventReactive ( input$submit1, { lm(reformulate(input$regressors, 
                                                            input$outcome), data=mydata())})
  
  
  ## we print the  summary of our linear model to be dispplayed on the main panel
  
  
  output$lm <- renderPrint({
    
    
    summary(reg_lm())
    
    
    
    
    
  })
  
  
  
  ## same as the linear model using in this case a non-parametric Loess fitting curve
  
  
  reg_loess <- eventReactive ( input$submit1, { loess(reformulate(input$regressors, 
                                                                  input$outcome), data=mydata())})
  
  
  output$loess <- renderPrint({
    
    
    summary(reg_loess())
    
    
    
    
    
  })
  
  ## we elaborate here a Ridge regression, testing for different levels of lambda,
  ## the coefficent of penalization. We use the lm.ridge function available
  ## in the MASS package
  
  
  reg_ridge <- eventReactive ( input$submit1, { lm.ridge(reformulate(input$regressors, 
                                                                     input$outcome), data=mydata(),
                                                         lambda = seq(0.25, .5, .005))})
  
  
  ## thanks to the tidy function available in the broom package
  ## we have  a summary of the estimated coefficents for the regressors and
  ## different levels of lambda
  
  
  output$ridge <- renderPrint({
    
    coef_ridge <- coef(reg_ridge())
    
    return(coef_ridge)
    
    
  })
  
  
  
  ## with renderPlotly   which works together with outputPloty
  ## in the main panel we show a plotly chart for each regression
  
  ## specifically the QQplot of the residuals for the lm model
  
  
  output$plot1 <- renderPlotly ({   first <- quantile(reg_lm()$resid[!is.na(reg_lm()$resid)], c(0.25, 0.75))
  second <- qnorm(c(0.25, 0.75))
  slope <- diff(first)/diff(second)
  int <- first[1L] - slope * second[1L]
  qq1 <- ggplot(reg_lm(), aes(sample=.resid)) +
    stat_qq(alpha = 0.5) +
    geom_abline(slope = slope, intercept = int, color="red")
  
  
  qq1 <- ggplotly(qq1)
  
  return(qq1)  })
  
  
  ## the fitted values vs the residuals for the Loess regression  
  
  
  output$plot2 <- renderPlotly ({  loess_chart <- qplot(fitted(reg_loess()), resid(reg_loess()))
  loess_chart <- loess_chart+geom_hline(yintercept=0, linetype="dashed", color="red")
  
  
  loess_chart <- ggplotly(loess_chart)
  
  return(loess_chart)    })
  
  
  
  

  
  

}
)


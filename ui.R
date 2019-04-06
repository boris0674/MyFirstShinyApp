
library(shiny)

library(shinythemes)



library(MASS)

library(plotly)

library(ggplot2)

## This shiny app I built with the classical 2 files structure, ui.R and server.R

## In the ui.R function we built  a standard structure with a title panel, a sidebar 

## and a mainpanel, I also imported with the shinytheme package some spiffier CSS

## different from the deafault style, I personally think my choice (cyborg)

## has a delicious 80s cyperpunk feel :-)




shinyUI(fluidPage(theme=shinytheme("cyborg"), titlePanel("Test some models on your data"),
                  
                  
                  sidebarLayout(
                    
                    ## in the sidebar we used  the fileinput function which is vital for my model
                    
                    ## as this function allows user to upload their own CSV files to the model 
                    
                    
                    
                    
                    
                    sidebarPanel(
                      
                      
                      fileInput("myfile", "upload a  CSV File",
                                multiple = FALSE,
                                accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
                      
                      
                      
                      tags$hr(),
                      
                      ## The checkboxinput function has the default option of importing the header
                      
                      checkboxInput("header", "Header", TRUE),
                      
                      ## radioButtons function allows use to choose from a few typical signs to
                      ## separate data in csv format, default being the widely used comma
                      
                      radioButtons("sep", "Separator",
                                   choices = c(Comma = ",", Semicolon = ";", Tab = "\t"), selected = ","),
                      
                      ## how to define string data                
                      
                      radioButtons("quote", "Quote", choices = c(None = "","Double Quote" = '"', "Single Quote" = "'"),
                                   selected = '"')
                      
                      
                    ),
                    
                    ## Here's where things get interesting: in the main panel section first of all 
                    ## we have the uiOutput function which displays a change in the main panel
                    ## uploading a new UI elaborated by the server function, specifically the menus
                    ## to select the regressors and the outcome and the submit button
                    
                    mainPanel(tabsetPanel(type="tabs", tabPanel("Our output", uiOutput("model"),
                                                                br(), br(), br(),
                                                                
                                                                ## conditional panel allow us to show on the main panel
                                                                ## underneath the submit button different results according to the
                                                                ## type of regression chosen
                                                                
                                                                ## particularly a text component (verbatimTextOutput) with some
                                                                ## important infos from the regressions and a plotly chart
                                                                
                                                                
                                                                conditionalPanel("input.reg === 'LM'", 
                                                                                 verbatimTextOutput("lm"), plotlyOutput("plot1")),
                                                                conditionalPanel("input.reg === 'Ridge'", verbatimTextOutput("ridge")),
                                                                conditionalPanel("input.reg === 'Loess'", verbatimTextOutput("loess"),plotlyOutput("plot2"))
                                                                
                                                                
                    ), tabPanel("Documentation", tags$br(h5("In this model we decided to build a user interface on the side panel to upload the desired CSV file with the fileInput function.

                                                            Then we can choose among several options depending on the characteristics of our CSV file, thanks to the use of the checkboxInout and radioButtons functions."), 
                                                         
                                                         h5("We can then choose whatever model we prefer among 3 options: thanks to the use of renderUI:
                                                            
                                                            LM
                                                            
                                                            Ridge
                                                            
                                                            Loess "), 
                                                         
                                                         
                                                         h5(" We then have uploaded in our 2 selectInput items the names of the columns of our CSV file column headers in the regressors space  (multiple choices allowed) and the outcome space (only one pick allowed).
                                                            
                                                            
                                                            Then one of the  three models can be chosen through radioButtons, once one is chosen the output is set to mainPanel which displays it thanks to conditionalPanel once Submit button is clicked.
                                                            
                                                            
                                                            The CSV data, thanks to eventReactive is transformed into a dataframe from which the desired columns are selected for our regressions."), 
                                                         
                                                         h5(" Once the Submit button is pressed  some summary data and a Plotly chart are uploaded thanks to the use of eventReactive
                                                            
                                                            Regressions with multiple regressors are supported, reformulate function help us adapting the formulas to a multivariate environment. "))))  
                    
                                                         )))
        
        
        
                    )
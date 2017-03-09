library(shiny)
library(plotly)
library(quantmod)

symbols<-stockSymbols(exchange = "NYSE",quiet = TRUE)
tickers<-symbols[,1]
sectors<-symbols[,6]
sectors<-unique(sectors)
industry<-symbols[,7]
industry<-unique(industry)

choices1 = data.frame(var = tickers, num = 1:length(tickers))
choices2 = data.frame(var = sectors, num = 1:length(sectors))
choices3 = data.frame(var = industry, num = 1:length(industry))

# List of choices for selectInput
mylist1 <- as.list(choices1$num)
mylist2 <- as.list(choices2$num)
mylist3 <- as.list(choices3$num)

# Name it
names(mylist1) <- choices1$var
names(mylist2) <- choices2$var
names(mylist3) <- choices3$var

shinyUI(fluidPage(
        titlePanel("DDP Course Project"),
        
        sidebarLayout(
                sidebarPanel(
                        helpText("Select a NYSE stock to examine. 
                                 Information will be collected from yahoo finance."),
                        selectInput("symb", "Ticker:", choices=names(mylist1)),
                        helpText("If you don't know the ticker, you can search for it in the All Companies tab."), 
                        
                        br(),
                        
                        helpText("Or if you'd like to know which are the companies in a specific industry or sector, just select below."),
                        selectInput("indu", "Industry:", choices=c("Choose one" = "", names(mylist3))),
                        selectInput("sect", "Sector:", choices=c("Choose one" = "", names(mylist2))),
                        
                        br()
                        
                        ),
                
                mainPanel(
                    tabsetPanel(id="inTabset",
                        tabPanel("Quotes",
                                 h2(textOutput("text3")),
                                 plotlyOutput("plot"),
                                 tableOutput("infoComp")),
                        tabPanel("Companies by industry",
                                 h2(textOutput("text2")),
                                 dataTableOutput("compInd")),
                        tabPanel("Companies by sector",
                                 h2(textOutput("text1")),
                                 dataTableOutput("compSect")),
                        tabPanel("All Companies",dataTableOutput("allData"))
                    )
                    )
        )
))
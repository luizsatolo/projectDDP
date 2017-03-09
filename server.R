# server.R

library(quantmod)
library(plotly)
library(forecast)
library(broom)

symbols<-stockSymbols(exchange = "NYSE",quiet = TRUE)

shinyServer(function(input, output, session) {
        
        observeEvent(input$symb, {
                
                data<-data.frame(getSymbols(input$symb,src="yahoo",auto.assign = FALSE))
                
                output$plot <- renderPlotly({
                        plot_ly(data,x=as.Date(row.names.data.frame(data)))%>%
                        add_lines(y=data[,6],name="Quotes")%>%rangeslider()%>%add_lines(y=
                        ~fitted(loess(data[,6]~as.numeric(as.Date(row.names.data.frame(data))),
                        data)),line=list(color='#07A4B5',dash="dot"),name="Trend",
                        showlegend=TRUE)%>%layout(yaxis=list(title=""))
                })
        })

        output$allData <- renderDataTable({
                symbols
        })
        
        output$compSect <- renderDataTable({
                if(input$sect!=""){
                symbols[which(symbols$Sector==input$sect),]}
        })
        
        output$compInd <- renderDataTable({
                if(input$indu!=""){
                        symbols[which(symbols$Industry==input$indu),]}
        })
        
        output$infoComp <- renderTable({
                if(input$symb!=""){
                        symbols[which(symbols$Symbol==input$symb),]}
        })
        
        observeEvent(input$sect, {
                updateTabsetPanel(session, "inTabset", selected = "Companies by sector")
        })
        
        observeEvent(input$indu, {
                updateTabsetPanel(session, "inTabset", selected = "Companies by industry")
        })
        
        observeEvent(input$symb, {
                updateTabsetPanel(session, "inTabset", selected = "Quotes")
        })
        
        output$text1<-renderText(input$sect)
        output$text2<-renderText(input$indu)
        output$text3<-renderText(symbols[which(symbols$Symbol==input$symb),]$Name)
})




shinyServer(function(input, output) {
  
 output$select2 <- renderUI({
    input$go
    selectInput("select", label = h3("Select Portfolio Allocation"), 
                   choices = list("Please select a portfolio allocation"="n",
                     "100 - 0"=1,"90 - 10" = .9,"80 - 20"=.8,"70 - 30"=.7,"60 - 40"=.6,
                                  "50 - 50"=.5,"40 - 60"=.4,"30 - 70"=.3,"20 - 80"=.2,"10 - 90"=.1,"0 - 100"=0), 
                selectize=FALSE, size=12)
  })
  
  if(count == max){
    output$warn <- renderText({
    "Your final selection will be locked in for 400 periods. Please select carefully."
    
  })
    
  }
  
  observeEvent(input$go, {
    if(input$select=="n"){output$selectwarn <- renderText({"Please make a selection"})}
    else{
      output$selectwarn <- renderText({""})
    if(count == max){
      
      time.stamp <<- append(time.stamp,as.character(Sys.time()))
      final.choice <<- as.numeric(input$select)
      final.port.value <<- real.port.value

      
      for(i in 1:400){
        port.split <- c(final.choice, (1-final.choice)) * final.port.value
        s <- s.final.returns[i]
        b <- b.final.returns[i]
        port.split.new <- port.split * exp(c(s,b))
        final.port.value <<- port.split.new[1] + port.split.new[2]
      }
      
      
 
      final.decisions <<- decisions
      final.results <<- c(input$name,input$id,type,final.choice,final.port.value) %>% append(final.decisions) %>%
                          append(time.stamp)
      final.results <<- as.matrix(t(final.results))
      #saveData(final.results)
      output$done <- renderText({
        "Congratulations, you have finished. Final results will not be available until the conclusion of all experiments."
      })
      count <<- ""
    }
    
    else if(count==""){}
    
    else{ 
      
      if(count == max-period){output$warn <- renderText({
        "Your final selection will be locked in for 400 periods. Please select carefully. Your final choice will take
        a few moments to process."
        
      })
      
      }
     
      decisions <<- append(decisions, as.numeric(input$select))
      time.stamp <<- append(time.stamp,as.character(Sys.time()))
      
      if(period > 1){for(i in 1:(period-1)){
        decisions<<-append(decisions,NA) 
        time.stamp <<- append(time.stamp,NA)
      }}
      
      port.change <<- c(0,0)
      
      for(i in (count+1):(count+period)){
      port.split <- isolate(c(as.numeric(input$select), (1-as.numeric(input$select))) * port.value)
      real.port.split <- isolate(c(as.numeric(input$select), (1-as.numeric(input$select))) * real.port.value)
      
      s <- s.returns[i]
      b <- b.returns[i]

      port.split.new <- port.split * c(s,b)
      port.change <<- port.change + port.split * c(s-1,b-1)
#       port.split.new <- port.split * (c(s,b)+.05)
#       port.change <<- port.change + port.split * (c(s,b)-1+.05)
      
      real.port.split.new <- real.port.split * c(s,b)
      
      port.value <<- port.split.new[1] + port.split.new[2]
      real.port.value <<- real.port.split.new[1] + real.port.split.new[2]
      }
      
      
     s.avg <- prod(s.returns[(count+1):(count+period)])^(1/period)
     b.avg <- prod(b.returns[(count+1):(count+period)])^(1/period)
#      s.avg <- prod(s.returns[(count+1):(count+period)]+.05)^(1/period)
#      b.avg <- prod(b.returns[(count+1):(count+period)]+.05)^(1/period)
      performance.data <<- as.data.frame(matrix(c("A","B",(s.avg-1)*100, (b.avg-1)*100),2)) %>%
                                        mutate(V2 = as.numeric(as.character(V2)),sign=ifelse(V2<0,"neg","pos"))
      
    #output$loss <- if(port.change[1]<0){ renderText({"Warning: Portfolio Loss from Allocation to Fund A"})} else{renderText({""})}
                            
      
    output$display <- DT::renderDataTable({
      
      display <<- matrix(c(round(port.change[1],2),round(port.change[2],2),round(port.value,2)),1)
      
      colnames(display) <<- c(
                 "Fund A Portfolio Gain/Loss",
                 "Fund B Portfolio Gain/Loss",
                 "Current Portfolio Value")
                                                                                               
      count <<- count + period
      
     
     datatable(display, options = list(dom = 't')) %>% 
       formatCurrency(c("Current Portfolio Value", "Fund A Portfolio Gain/Loss", 
                        "Fund B Portfolio Gain/Loss"))
    })
    
  
   output$period <- renderText({
      paste("Periods Elapsed:",count)
    })  
  
   output$graph <- renderPlot({
     ggplot(performance.data, aes(x=V1, y=V2)) + 
       geom_bar(stat="identity", aes(fill=sign)) + 
       guides(fill=FALSE) +
       #coord_cartesian(ylim = c(-11, 11)) + 
       coord_cartesian(ylim = c(-16, 16)) + 
       scale_fill_manual(values = c("neg"="red","pos"="green")) +
       geom_text(aes(label=sprintf("%.2f%%",round(V2,2)), vjust=1)) +
       xlab("Fund") + ylab("% Return") + 
       ggtitle(paste("Average Return for Both Funds from Last",period,"Period(s)."))
       
   })
   
   
   
    }
                                  
    }                                  
})
})

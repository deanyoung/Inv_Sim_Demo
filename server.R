shinyServer(function(input, output) {
 
 # Use renderUI on allocation choice menu 
 # (resets default highlighted choice to "Please seelct a portfolio allocation" 
 # which forces user to actively make a choice each time
 output$select2 <- renderUI({
    input$go
    selectInput("select", label = h3("Select Portfolio Allocation"), 
                   choices = list("Please select a portfolio allocation"="n",
                     "100 - 0"=1,"90 - 10" = .9,"80 - 20"=.8,"70 - 30"=.7,"60 - 40"=.6,
                                  "50 - 50"=.5,"40 - 60"=.4,"30 - 70"=.3,"20 - 80"=.2,"10 - 90"=.1,"0 - 100"=0), 
                selectize=FALSE, size=12)
  })
  
  # restrict app to non-reactive in order to allow users to confirm choice
  observeEvent(input$go, {
    
    # if user does not select an allocation, warn them
    if(input$select=="n"){output$selectwarn <- renderText({"Please make a selection"})}
    else{
      # remove warning if allocation choice is selected properly
      output$selectwarn <- renderText({""})
      
    # if simulation is over, record data
    if(count == max){
      
      time.stamp <<- append(time.stamp,as.character(Sys.time()))
      final.choice <<- 1-as.numeric(input$select) # Saves bond (Fund B) allocation
      final.port.value <<- real.port.value

      # compute final 400 periods returns based on final choice
      for(i in 1:400){
        port.split <- c(final.choice, (1-final.choice)) * final.port.value
        s <- s.final.returns[i]
        b <- b.final.returns[i]
        port.split.new <- port.split * c(s,b)
        final.port.value <<- port.split.new[1] + port.split.new[2]
      }
      
      
      # record decisions vector
      final.decisions <<- decisions
      
      # record information
      final.results <<- c(input$name,input$id,type,final.choice,final.port.value) %>% append(final.decisions) %>%
                          append(time.stamp)
      final.results <<- as.matrix(t(final.results))
      
      # send to GoogleSheet: 
      # https://docs.google.com/spreadsheets/d/1EXUyxXv2dRpNK03HkYah79se0J-tcNzWEA_WdSJKTGw/edit?usp=sharing
      saveData(final.results)
      
      # output completion message
      output$done <- renderText({
        "Congratulations, you have finished. Your reward payout will be determined when all experimental sessions have concluded. Thank you for your time."
      })
      
      # change count to "" to halt simulator
      count <<- ""
    }
    
    # if final choice has been made then simulator halts
    else if(count==""){}
    
    else{ 
      
      # if initial 200 periods has elapsed, warn user that their next choice 
      # is the final choice that locks for 400 periods
      if(count == max-period){output$warn <- renderText({
        "Your final selection will be locked in for 400 periods. Please select carefully. Your final choice will take
        a few moments to process."
        
      })
      
      }
     
      decisions <<- append(decisions, 1-as.numeric(input$select)) # Saves bond (Fund B) allocation
      time.stamp <<- append(time.stamp,as.character(Sys.time())) # Saves time stamp of choice
      
      # if elapsed periods per choice is greater than 1 (yearly condition) pad vector with NA's to 
      # properly line up decisions with correct period
      if(period > 1){for(i in 1:(period-1)){
        decisions<<-append(decisions,NA) 
        time.stamp <<- append(time.stamp,NA)
      }}
      
      # initialize values
      port.prev <<- port.value
      port.change <<- c(0,0)
      
      
      for(i in (count+1):(count+period)){
        # split portfolio based on allocation choice
        port.split <- isolate(c(as.numeric(input$select), (1-as.numeric(input$select))) * port.value)
        # used for inflated monthly condition, otherwise real.port.split = port.split
        real.port.split <- isolate(c(as.numeric(input$select), (1-as.numeric(input$select))) * real.port.value)
        
        # stock and bond returns for relevant periods 
        s <- s.returns[i]
        b <- b.returns[i]
        
        # compute new values of investments (line 3-4 is for inflated monthly condition)
        port.split.new <- port.split * c(s,b)
        port.change <<- port.change + port.split * c(s-1,b-1)
  #       port.split.new <- port.split * (c(s,b)+.05)
  #       port.change <<- port.change + port.split * (c(s,b)-1+.05)
        
        real.port.split.new <- real.port.split * c(s,b)
        
        # add up splits to get new total portfolio value
        port.value <<- port.split.new[1] + port.split.new[2]
        real.port.value <<- real.port.split.new[1] + real.port.split.new[2]
      }
      
     # compute geometric mean returns (line 3-4 is for inflated monthly condition)
     s.avg <- prod(s.returns[(count+1):(count+period)])^(1/period)
     b.avg <- prod(b.returns[(count+1):(count+period)])^(1/period)
#      s.avg <- prod(s.returns[(count+1):(count+period)]+.05)^(1/period)
#      b.avg <- prod(b.returns[(count+1):(count+period)]+.05)^(1/period)
     
     all.perf <- (port.value/port.prev)^(1/period)-1
     
     # create df for ggplot2 display
     performance.data <<- as.data.frame(matrix(c("A","B","Your Allocation",(s.avg-1)*100, (b.avg-1)*100, 
                                                 all.perf*100),3)) %>%
       mutate(V2 = as.numeric(as.character(V2)),sign=ifelse(V2<0,"neg","pos")) # 
    
    # datatable showing dollar value gain/loss of investments  
    output$display <- renderDataTable({
      
      display <<- matrix(c(round(port.change[1],2),round(port.change[2],2),round(port.change[1]+port.change[2],2),round(port.value,2)),1)
      
      colnames(display) <<- c(
                 "Fund A Portfolio Gain/Loss",
                 "Fund B Portfolio Gain/Loss",
                 "Total Portfolio Gain/Loss",
                 "Current Portfolio Value")
                                                                                               
      count <<- count + period
      
     
     datatable(display, options = list(dom = 't')) %>% 
       formatCurrency(c("Current Portfolio Value", "Fund A Portfolio Gain/Loss", 
                        "Fund B Portfolio Gain/Loss","Total Portfolio Gain/Loss"))
    })
    
   # current period display  
   output$period <- renderText({
      paste("Periods Elapsed:",count)
    })  
   
   # ggplot showing the percentage return of both funds and allocation average
   output$graph <- renderPlot({
     ggplot(performance.data, aes(x=V1, y=V2)) + 
       geom_bar(stat="identity", aes(fill=sign)) + 
       guides(fill=FALSE) +
       coord_cartesian(ylim = c(-11, 11)) + 
       #coord_cartesian(ylim = c(-16, 16)) + 
       scale_fill_manual(values = c("neg"="red","pos"="green")) +
       geom_text(aes(label=sprintf("%.2f%%",round(V2,2)), vjust=1)) +
       xlab("Fund") + ylab("% Return") + 
       ggtitle("Returns for Last Period")
       
   })
   
   
   
    }
                                  
    }                                  
})
})

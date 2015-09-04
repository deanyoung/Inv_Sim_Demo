shinyUI(fluidPage(
  
  titlePanel("Investment Simulator"),
  p(paste("You have been selected to receive information and change investment options every",period,"period(s).")),
  h3(strong(textOutput("warn"))),
  
  
  sidebarLayout(
    
    
    
    sidebarPanel(
      
      div(textOutput("selectwarn"),style="color:red"),
      textInput("name", label = h3("Name")),
      textInput("id", label = h3("Student ID")),
     # selectInput("select", label = h3("Select Portfolio Split"), 
      #            choices = list(#"Please select an investment split"="n",
       #             "100 - 0"=1,"90 - 10" = .9,"80 - 20"=.8,"70 - 30"=.7,"60 - 40"=.6,
        #            "50 - 50"=.5,"40 - 60"=.4,"30 - 70"=.3,"20 - 80"=.2,"10 - 90"=.1,"0 - 100"=0)),
      uiOutput("select2"),
      br(),
      actionButton("go", "Submit")
      
    ),
    
    mainPanel(
        DT::dataTableOutput("display"),
        #div(h4(strong(textOutput("loss"))),style="color:red"),
        plotOutput("graph"),
        textOutput("period"),
        h3(textOutput("done"))
    )
  )
))
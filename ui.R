shinyUI(fluidPage(
  
  titlePanel("Investment Simulator"),
  p(paste("You have been selected to receive information and change investment options every",period,"period(s).")),
  
  
  
  sidebarLayout(
    
    
    
    sidebarPanel(
      
      div(textOutput("selectwarn"),style="color:red"),
      textInput("name", label = h3("Name")),
      textInput("id", label = h3("Student ID")),
      uiOutput("select2"),
      br(),
      actionButton("go", "Submit")
      
    ),
    
    mainPanel(
        DT::dataTableOutput("display"),
        #div(h4(strong(textOutput("loss"))),style="color:red"),
        plotOutput("graph"),
        textOutput("period"),
        div(h3(strong(textOutput("warn"))),style="color:red"),
        h3(textOutput("done"))
    )
  )
))
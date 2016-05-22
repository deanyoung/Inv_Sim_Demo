shinyUI(fluidPage(
  
  titlePanel("Investment Simulator Demo"),
  
  helpText("Developed by Dean Young (deanyoung168@gmail.com)"),
  helpText("Designed for undergraduate thesis research: Myopic Loss Aversion in Investment Behavior"),
  helpText("With assistance from: Albert Kim, Rich Majerus, and Chester Ismay"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      div(textOutput("selectwarn"),style="color:red"),
      textInput("name", label = h3("Full Name")),
      textInput("id", label = h3("Student ID")),
      uiOutput("select2"),
      br(),
      actionButton("go", "Submit")
      
    ),
    
    mainPanel(
        dataTableOutput("display"),
        plotOutput("graph"),
        textOutput("period"),
        div(h3(strong(textOutput("warn"))),style="color:red"),
        h3(textOutput("done"))
    )
  )
))
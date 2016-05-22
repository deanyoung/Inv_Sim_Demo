library(dplyr)
library(shiny)
library(ggplot2)
library(googlesheets)

type <- 1 # condition assignment (monthly - 1, yearly - 2, inflated monthly - 3)
period <- 1 # elapsed periods per choice (1 for monthly and inflated monthly, 10 for yearly)
count <- 0 # Starting period
port.value <- 100
real.port.value <- 100 # used to track true portfolio value (for inflated monthly)
decisions <- c() # vector of allocation choices
port.change <-c(0,0) # c(change from A, change from B)
time.stamp <- c() # time stamp vector (not used in final analysis)
max <- 10 # max periods

# load returns data
returns.data <- read.csv("demo_returns.csv",header=FALSE)
s.returns <- slice(returns.data,1) %>% as.matrix()
b.returns <- slice(returns.data,2) %>% as.matrix()
s.final.returns <- slice(returns.data,3) %>% as.matrix()
b.final.returns <- slice(returns.data,4) %>% as.matrix()

#Authentication check
gs_key("1EXUyxXv2dRpNK03HkYah79se0J-tcNzWEA_WdSJKTGw")


saveData <- function(data) {
  sheet <- gs_key("1EXUyxXv2dRpNK03HkYah79se0J-tcNzWEA_WdSJKTGw")
  # Add the data as a new row
  gs_add_row(sheet, input = data)
}
library(dplyr)
library(shiny)
library(DT)
library(ggplot2)
library(googlesheets)

type <- 1
period <- 10
count <- 0
port.value <- 100
real.port.value <- 100
decisions <- c()
port.change <-c(0,0)
time.stamp <- c()
max <- 200

returns.data <- read.csv("returns.csv",header=FALSE)
s.returns <- slice(returns.data,1) %>% as.matrix()
b.returns <- slice(returns.data,2) %>% as.matrix()
s.final.returns <- slice(returns.data,3) %>% as.matrix()
b.final.returns <- slice(returns.data,4) %>% as.matrix()

#Authenticate
gs_key("19wV5hqtOJ_gzxLqGevtya7RoGGAfSlPvV2p3YQH92FM")

saveData <- function(data) {
  sheet <- gs_key("19wV5hqtOJ_gzxLqGevtya7RoGGAfSlPvV2p3YQH92FM")
  # Add the data as a new row
  gs_add_row(sheet, input = data)
}
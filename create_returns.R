library(dplyr)
library(truncnorm)
library(psych)

set.seed(76)
s <- rnorm(200,.0093336474,.035038751) %>% t() %>% as.data.frame() 
b <- rtruncnorm(200,a=0,b=Inf,mean=.002495322,sd=.001765501) %>% t() %>% as.data.frame() 
s.2 <- rnorm(400,.0093336474,.035038751) %>% t() %>% as.data.frame() 
b.2 <- rtruncnorm(400,a=0,b=Inf,mean=.00295322,sd=.001765501) %>% t() %>% as.data.frame() 



data <- bind_rows(s,b) %>% bind_rows(s.2) %>% bind_rows(b.2)
max(exp(s)+.05,na.rm=TRUE)
min(exp(s),na.rm=TRUE)
mean(t(exp(s)),na.rm=TRUE)
sd(t(exp(s)))
mean(t(exp(b)),na.rm=TRUE)

mean(t(exp(s.2)))
geometric.mean(t(exp(s.2)))
geometric.mean(t(exp(b.2)))

write.csv(data,"returns.csv", row.names=FALSE)

data2 <- read.csv("returns.csv", header = FALSE)

s <- slice(data2,1)
b <- slice(data2,2)
port <- 100
for (i in 1:200){
  si <- s[i]
bi <- b[i]
port = port * max(exp(bi)+.05,exp(si)+.05)}

sum(exp(t(s))<1,na.rm=TRUE)
sum(exp(t(s))+.05<1,na.rm=TRUE)

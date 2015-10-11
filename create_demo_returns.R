library(dplyr)
library(truncnorm)
library(psych)


set.seed(76)
s <- rnorm(200,1.012,.045) %>% t() %>% as.data.frame() #stock fund 1st 200
b <- rnorm(200,1.012,.045) %>% t() %>% as.data.frame() #bond fund 1st 200
s.2 <- rnorm(400,1.012,.045) %>% t() %>% as.data.frame() #stock fund next 400
b.2 <- rnorm(400,1.012,.045) %>% t() %>% as.data.frame() #bond fund next 400


data <- bind_rows(s,b) %>% bind_rows(s.2) %>% bind_rows(b.2)
max(s,na.rm=TRUE)
min(s,na.rm=TRUE)
mean(t(s),na.rm=TRUE)
sd(t(s),na.rm=TRUE)
mean(t(b),na.rm=TRUE)
sd(t(b),na.rm=TRUE)

mean(t(s.2),na.rm=TRUE)
sd(t(s.2),na.rm=TRUE)
mean(t(b.2),na.rm=TRUE)
sd(t(b.2),na.rm=TRUE)

geometric.mean(t(s.2),na.rm=TRUE)
geometric.mean(t(b.2),na.rm=TRUE)

write.csv(data,"demo_returns.csv", row.names=FALSE) # will have to edit out top row in excel

# check how extreme portfolio values can be under inflated condition
port <- 100
for (i in 1:200){
si <- s[i]
bi <- b[i]
port = port * max(bi+.05,si+.05)}

sum(s<1,na.rm=TRUE) # how many are losses?
sum(s+.05<1,na.rm=TRUE) # how many are losses (inflated condition)?

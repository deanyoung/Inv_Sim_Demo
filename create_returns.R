library(dplyr)
library(truncnorm)
dat = read.csv("returns.csv", header = FALSE)
dat <- dat %>% slice()
s <- rnorm(200,.01,.0354) %>% t() %>% as.data.frame() 
b <- rtruncnorm(200,a=0,b=Inf,mean=.0025,sd=.00177) %>% t() %>% as.data.frame() 
s.2 <- rnorm(400,.01,.0354) %>% t() %>% as.data.frame() 
b.2 <- rtruncnorm(400,a=0,b=Inf,mean=.0025,sd=.00177) %>% t() %>% as.data.frame() 



data <- bind_rows(s,b) %>% bind_rows(s.2) %>% bind_rows(b.2)
max(s)
max(b)
min(s)
mean(s,na.rm=TRUE)
mean(t(s.2))
mean(t(s))
mean(t(b))
mean(t(b.2))

exp(.122)

write.csv(data,"returns.csv",col.names=FALSE, row.names=FALSE)


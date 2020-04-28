

# 세팅 ----------------------------------------------------------------------


data_vis<-read.csv("ER_exam.csv")

library(dplyr)
library(simputation)
library(naniar)

data_vis$DISEASE_CLASS %>% table()

data_vis2<-data_vis %>% 
  filter(DISEASE_CLASS=="질병") %>% 
  filter(AGE>=18) %>% 
  mutate(OUTCOME=ifelse(ER_RESULT=="사망"|ADMISSION=="중환자실로 입원",1,0)) %>% 
  group_by(SEX) %>% 
  impute_mean_all()

# plot --------------------------------------------------------------------

#기본 plot
plot(data_vis2$TEMP,data_vis2$PR,
     xlab="Temperature",ylab="Purse Rate",
     main = "Scatterplot of Temp & PR",
     col="blue", cex=2,pch=5)

par(mfrow=c(1,1))

#abline
plot(data_vis2$TEMP,data_vis2$PR)
abline(lm_result, col="red")
abline(v=mean(data_vis2$TEMP),col="blue",lty=2)
abline(h=mean(data_vis2$PR),col="green",lty=2)

lm_result<-lm(PR~TEMP,data = data_vis2)
summary(lm_result)

#산점도 행렬
pairs(~AGE+SBP+TEMP+SPO2,data=data_vis2)

install.packages("mycor")
library(mycor)

plot(mycor(~AGE+SBP+TEMP+SPO2,data=data_vis2),type=1) #기존꺼와 같음
plot(mycor(~AGE+SBP+TEMP+SPO2,data=data_vis2),type=2)
plot(mycor(~AGE+SBP+TEMP+SPO2,data=data_vis2),type=3)


# ggplot2 -----------------------------------------------------------------

#
library(ggplot2)

ggplot(data_vis2,aes(TEMP,PR)) + 
  geom_point() + 
  facet_grid(SEX~.)

ggplot(data_vis2,aes(TEMP,PR)) + 
  geom_point() + 
  facet_grid(.SEX~)

ggplot(data_vis2,aes(TEMP,PR)) + 
  geom_point() + 
  facet_grid(AVPU~SEX)

ggplot_result<-ggplot(data_vis2,aes(TEMP,PR)) + 
  geom_point(aes(col=SEX,size=TEMP,shape=ER_RESULT)) 

#interaction
install.packages("plotly")
library(plotly)

ggplotly(ggplot_result)

#3dplot
install.packages("scatterplot3d")
library(scatterplot3d)

scatterplot3d(data_vis2$SBP,data_vis2$DBP,data_vis2$TEMP)


install.packages("rgl")
library(rgl)

plot3d(data_vis2$SBP,data_vis2$DBP,data_vis2$TEMP)



# shiny -------------------------------------------------------------------

library(shiny)

runExample("01_hello")

runApp()


# 기초통계분석 ------------------------------------------------------------------

str(data_vis2)

data_cor<-data_vis2[,c(4,6:11)]

#pearson
cor_matrix<-round(cor(data_cor),2)

install.packages("corrplot")
library(corrplot)

corrplot(cor_matrix, method = "square")

#spearman, 타우


# 카이제곱 --------------------------------------------------------------------

table(data_vis2$SEX)
table(data_vis2$OUTCOME)

chisq.test(table(data_vis2$SEX, data_vis2$OUTCOME))






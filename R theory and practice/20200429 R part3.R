
head(cars)

plot(cars)

lm_result<-lm(dist~speed,data=cars)

abline(lm_result,col="red")

summary(lm_result)


# 데이터 세팅 ------------------------------------------------------------------

library(dplyr)

ER_data<-read.csv("ER_exam.csv")

ER_data2<-ER_data %>% 
  filter(DISEASE_CLASS=="질병") %>% 
  filter(AGE>=18)

ER_data3<-ER_data2 %>% 
  mutate(OUTCOME=ifelse(ER_RESULT=="사망"| ADMISSION=="중환자실로 입원",1,0))

ER_data4<-na.omit(ER_data3)


#데이터 나누기
set.seed(100)
ind<-sample(1:nrow(ER_data4),nrow(ER_data4)*0.7)

train<-ER_data4[ind,]
test<-ER_data4[-ind,]

ER_data4$OUTCOME %>% table()


#모형 적용
glm_result<-glm(OUTCOME~SEX+AGE+AVPU+TEMP+SPO2+F_KTAS+RR,data=train,
                family = binomial) #로지스틱 회귀 분석

summary(glm_result)

exp(glm_result$coefficients)

#
library(moonBook)

ORplot(glm_result)

#평가
pred<-predict(glm_result,newdata=test,type = "response")
head(pred)

pred2<-ifelse(pred>0.5,1,0)
head(pred2)
head(test$OUTCOME)

table(test$OUTCOME,pred2)

install.packages("caret")
library(caret)

confusionMatrix(factor(test$OUTCOME),factor(pred2))

#
library(pROC)

plot.roc(test$OUTCOME,pred,print.auc=T)


# 머신러닝 --------------------------------------------------------------------

#k-means

ER_clus<-ER_data4 %>% 
  select(AGE,SBP,DBP,TEMP,PR,RR)

kmeans_result<-kmeans(ER_clus,3)

ER_clus$cluster<-kmeans_result$cluster

library(ggplot2)

ggplot(ER_clus,aes(TEMP,SBP))+
  geom_point(aes(col=factor(cluster)))





#decison tree

install.packages("tree")
library(tree)

tree_result<-tree(OUTCOME~SEX+AGE+AVPU+TEMP+SPO2+F_KTAS+RR,data=train)

plot(tree_result)
text(tree_result)

pred_tree<-predict(tree_result,newdata=test)
head(pred_tree)

pred_tree2<-ifelse(pred_tree>0.5,1,0)

confusionMatrix(factor(test$OUTCOME),factor(pred_tree2))





#svm

library(e1071)

svm_result<-svm(as.factor(OUTCOME)~SEX+AGE+AVPU+TEMP+SPO2+F_KTAS+RR,data=train,probability=TRUE)
svm_pred<-predict(svm_result,newdata=test,probability = TRUE)

pred_svm<-attr(svm_pred,"probabilities")[,1]
head(pred_svm)
pred_svm2<-ifelse(pred_svm>0.5,1,0)
head(pred_svm2)

confusionMatrix(factor(test$OUTCOME),factor(pred_svm2))




##random forest

install.packages("randomForest")
library(randomForest)

train$SEX<-as.factor(train$SEX)
train$AVPU<-as.factor(train$AVPU)

test$SEX<-as.factor(test$SEX)
test$AVPU<-as.factor(test$AVPU)

rf_result<-randomForest(as.factor(OUTCOME)~SEX+AGE+AVPU+TEMP+SPO2+F_KTAS+RR,data=train)

varImpPlot(rf_result)

pred_rf<-predict(rf_result,newdata = test,type = "prob")[,2]

pred_rf2<-ifelse(pred_rf>0.5,1,0)

confusionMatrix(factor(test$OUTCOME),factor(pred_rf2))


plot.roc(test$OUTCOME,pred)
plot.roc(test$OUTCOME,pred_tree,add=T,col="blue")
plot.roc(test$OUTCOME,pred_svm,add=T,col="green")
plot.roc(test$OUTCOME,pred_rf,add=T,col="red")


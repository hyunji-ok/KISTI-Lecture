a <- c(1,2,3,10)
mean(a) #mean은 평균을 구해주는 함수
max(a)
min(a)

boxplot(a,horizontal = TRUE)

#함수 설명
?boxplot


#현재 파일 위치
getwd()


# 파일 불러오기 -----------------------------------------------------------------


#txt파일 불러오기
data1 <- read.table("txt_data.txt",header = T)

head(data1)
str(data1)
names(data1)
summary(data1)
sum(is.na(data1))
colSums(is.na(data1))

#csv파일
data2<-read.csv("ER_exam.csv",header = T)

head(data2)
str(data2)
names(data2)
summary(data2)
colSums(is.na(data2))




# moonbook 패키지 ------------------------------------------------------------


#install.packages("moonBook")

library(moonBook)

table_result<-mytable(SEX~AGE+TEMP+DISEASE_CLASS+AVPU+F_KTAS+RR+PR,data=data2)
mycsv(table_result,file="20200427.csv")

mylatex(table_result)




# 인덱싱 ---------------------------------------------------------------------

a<-c(1,2,3,10)

a
a[2]
a[1:3]
a[c(3,4)]
a[-1] #1만 뺴라는 것

data1[1:3,]
data1[,2:3]
data1[5:8,c("gender","age")]
data1[c(3,4,6,8),]

data_Female<-data1[data1$gender=="F",] #$는 특정 변수에 접근하는 것, female만 뽑기

data_40<-data1[data1$age>=40,]

data_a<-data1[data1$group=="a",]

data_a_40<-data1[data1$group=="a"&data1$age>=40,]



# dplyr 사용 ----------------------------------------------------------------

library(dplyr)
#변수 다루기
head(select(data2, TEMP,AVPU))
head(select(data2, starts_with("ER")))
#행 다루기
head(filter(data2, TEMP>40))
head(filter(data2, TEMP>40&SEX=="M"))
#오름차순, 내림차순
arrange(data2,TEMP)
arrange(data2,desc(TEMP))
#파생변수 만들기
mutate(data2, new_val=(SBP+DBP)/2)
mutate(data2,icu=ifelse(ER_RESULT=="입원"&ADMISSION=="중환자실로 입원",1,0))
#요약통계량
summarise(group_by(data2,AVPU,SEX), 
          mean_AGE=mean(AGE),
          median_AGE=median(AGE),
          mean_TEMP=mean(TEMP, na.rm=T)
          )
#파이프 라인 ctrl+shift+m
data2 %>% 
  filter(AGE>=18) %>% 
  group_by(SEX) %>% 
  summarise(mean(TEMP, na.rm=TRUE))




# 이상치 ---------------------------------------------------------------------

#이상치 확인 by 빈도수를 사용  
table(data2$SEX,data2$DISEASE_CLASS)
  
data2$SEX %>% table()  



# 결측치 ---------------------------------------------------------------------

install.packages("VIM")
library(VIM)

#
data2$DISEASE_CLASS %>% table()

data3<-data2 %>% 
  filter(DISEASE_CLASS=="질병") %>% 
  filter(AGE>=18) %>% 
  mutate(OUTCOME=ifelse(ER_RESULT=="사망"|ADMISSION=="중환자실로 입원",1,0))

data3$OUTCOME %>% table()

colSums(is.na(data3))

#결측치 채우기
install.packages("naniar")
install.packages("simputation")
library(naniar)
library(simputation)

#그냥 평균으로
data4 <- data3 %>% impute_mean_all()
colSums(is.na(data4))

#성별에 따른 평균으로
data5 <- data3 %>% 
  group_by(SEX) %>% 
  impute_mean_all()

colSums(is.na(data5))

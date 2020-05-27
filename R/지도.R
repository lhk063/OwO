# 지도 사전 준비
# R 최신버전
# ggplot2 최신버전
# ggmap 패키지 설치
# 구글맵을 사용하기 위한 API 키 얻기 
# 방법 :  구글맵 플랫폼에 접속 
# http://cloud.google.com/maps-platform/#get-started
# 지도,경로,지역정보 체크 하시고 계속 버튼을 누른다.
# Enable Google Maps Platform 페이지가 나오면 2번 Select a project를 선택하고
# Create a new project클릭 

# 서울시 강남구 근방의 지도 보기
library(ggplot2)
library(ggmap)
register_google(key='AIzaSyAyHMvE2CUe1gj88vj3SJU8KREXXrA-Saw') # 구글키 등록

gc <- geocode(enc2utf8("강남구")) # 지점의 경도 위도
gc

cen <- as.numeric(gc) # 경도 위도를 숫자로
cen
map <- get_googlemap(center=cen, zoom=14, size=c(640,640), maptype = 'roadmap') # 지도 생성
 # terrain(기본값), roadmap, satellite, hybrid
ggmap(map) # 지도 화면에 보이기 

# 경도와 위도 값을 입력하여 지도 보기
# L.A
cen <- c(-118.233248,34.085015)
map <- get_googlemap(center = cen)
ggmap(map)

# 우리학원
cen <- c(127.029078,37.493864)
map <- get_googlemap(center = cen, zoom = 17)
ggmap(map)

## 지도위에 마커와 텍스트 표시
gc <- geocode(enc2utf8('용인'))
cen <- as.numeric(gc)
map <- get_googlemap(center=cen, maptype='roadmap', marker=gc)
ggmap(map)


# 마커 여러개와 텍스트
names <- c('용두암','성산일출봉','정방폭포','중문관광단지','한라산1100고지','차귀도')
addr <- c('제주도 용두암길15',
         '서귀포시 성산읍 성산리',
         '서귀포시 동홍동 299-3',
         '서귀포시 중문도 2624-1',
         '서귀포시 색달동 산1-2',
         '제주시 한경면 고산리 125')
gc <- geocode(enc2utf8(addr))

# 관광지 명칭과 좌표값으로 datagrame 생성
df <- data.frame(name=names,
                 lon=gc$lon,
                 lat=gc$lat)
df

cen <- c(mean(df$lon), mean(df$lat)) # 지도의 중심점
map <- get_googlemap(center = cen,
                     maptype = 'roadmap',
                     zoom = 10,
                     size = c(640,640),
                     marker=gc)
ggmap(map)

# 명소 이름 지도 위에 표시하기 
gmap <- ggmap(map)
gmap+geom_text(data=df,
               aes(x=lon, y=lat),
               size=5,
               label=df$name)


## 지도 위에 데이터 표시 
# 데이터 준비
head(wind) # 미국 루이지애나 주 부근의 여러지점에서 측정한 바람 정보 
nrow(wind)
sp <- sample(1:nrow(wind), 50)
df <- wind[sp,]
head(df)

cen <- c(mean(df$lon), mean(df$lat))
gc <- data.frame(lon=df$lon, lat=df$lat)
head(gc)

# 측정위치에 마커 표시
map <- get_googlemap(center=cen,
                     maptype='roadmap',
                     zoom= 6,
                     marker= gc)
ggmap(map)

# 풍속을 원의 크기로 표시하기 
gmap <- ggmap(map)
gmap+geom_point(data=df,
                aes(x=lon, y=lat, size=spd), # spd 열의 값
                alpha=0.5, # alpha : 색의 투명도. 0.5(반투명)
                col='blue')+
  scale_size_continuous(range=c(1,14)) # 원의 크기 조절, 1(min크기), 14(Max크기)






[지도 연습문제]

1. R을 이용하여 서울시 한강 이남의 구청들의 위치에 마커와 구청 이름을 지도 위에 표시하시오.

## 지도위에 마커와 텍스트 표시
gc <- geocode(enc2utf8('용인'))
cen <- as.numeric(gc)
map <- get_googlemap(center=cen, maptype='roadmap', marker=gc)
ggmap(map)


# 마커 여러개와 텍스트
names <- c('강서구청','양천구청','영등포구청','구로구청','동작구청','금천구청',
           '관악구청','서초구청','강남구청','강동구청','송파구청')
addr <- c('서울시 강서구 화곡로302',
          '서울시 양천구 목동동로 105',
          '서울시 영등포구 당산로 123 ',
          '서울시 구로구 가마산로 245',
          '서울시 동작구 장승배기로 161',
          '서울시 금천구 시흥대로73길 70',
          '서울시 관악구 관악로145',
          '서울시 서초구 남부순환로2584 ','서울시 강남구 학동로 426',
          '서울시 강동구 성내로 25','서울시 송파구 올림픽로 326')
gc <- geocode(enc2utf8(addr))

# 관광지 명칭과 좌표값으로 datagrame 생성
df <- data.frame(name=names,
                 lon=gc$lon,
                 lat=gc$lat)
df

cen <- c(mean(df$lon), mean(df$lat)) # 지도의 중심점
map <- get_googlemap(center = cen,
                     maptype = 'roadmap',
                     zoom = 11,
                     size = c(640,640),
                     marker=gc,
                     path=gc)
gmap <- ggmap(map)
gmap+geom_text(data=df,
               aes(x=lon, y=lat),
               size=5,
               label=df$name)





2. '2018년도 시국구별 월별 교통사고 자료'로부터 서울시의 각 구별 1년 교통사고 발생건수를 지도상에 원의 크기로 나타내시오.
- Sonar 원의 위치는 구의 위치로 하시오.
- 원의 색은 red로 하고 투명도를 .05로 하시오.
- 자료에는 월별로 데이터가 기록되어 있는데 1년 데이터를 합산하여 이용하시오.
- 서울 지역이 모두 지도에 나도오록 하시오.
* 데이터출처: 공동데이터포털(https://www.data.go.kr)에서 '교통사고통계' 검색 후 '도로교통공단_시도_시군구별_교통사고_통계(2019)'를 다운받아 사용한다.

data <- read.csv('도로교통공단_시도_시군구별_월별_교통사고(2018).csv',header=T )
head(data)
nrow(data)
table(data['시도'])
data1 <- subset(data, 시도=='서울' )
data1[1:12,]
colSums(data1[1:12,4:9])
agg<- aggregate(data1[,4:9], by=list(data1$시군구), FUN = sum)
head(agg)

gc <- geocode(enc2utf8(agg$Group.1))
gc
cen <- geocode(enc2utf8("서울시"))
cen <- as.numeric(cen)
cen
map <- get_googlemap(center = cen,
                     maptype = 'roadmap',
                     zoom = 11)
gmap <- ggmap(map)

df <- data.frame(agg,gc)
head(df)

gmap+geom_point(data=df,
                aes(x=lon, y=lat, size=발생건수), # spd 열의 값
                alpha=0.5, # alpha : 색의 투명도. 0.5(반투명)
                col='#d24999')+
  scale_size_continuous(range=c(1,14)) # 원의 크기 조절, 1(min크기), 14(Max크기)


3. 2번과 동일한 자료를 이용하여 광역시도별 1년 사망자수를 지도상에 원의 크기로 나타내시오.
- 세종시는 데이터에서 삭제하시오.
- 원의 색은 black으로 하고 투명도를 .05로 하시오.
- 남한 지역이 모두 지도에 나오도록 하시오.
data2 <- data
agg1 <- aggregate(data2[,4:9], by=list(data2$시도), FUN = sum)
agg1 <- agg1[-10,] # drop(agg1[-10,])
agg1

gc <- geocode(enc2utf8(agg1$Group.1))
gc
cen <- geocode(enc2utf8("충주시"))
cen <- as.numeric(cen)
cen
map <- get_googlemap(center = cen,
                     maptype = 'roadmap',
                     zoom = 6)
#ggmap(map)
gmap <- ggmap(map)

df <- data.frame(agg1,gc)
head(df)

gmap+geom_point(data=df,
                aes(x=lon, y=lat, size=사망자수), # spd 열의 값
                alpha=0.5, # alpha : 색의 투명도. 0.5(반투명)
                col='black')+
  scale_size_continuous(range=c(1,14)) # 원의 크기 조절, 1(min크기), 14(Max크기)


4. 2.번과 동일한 자료를 이용하여 광역시도별 7, 8월 부상자수를 지도상에 원의 크기로 나타내시오.
- 세종시는 데이터에서 삭제하시오.
- 원의 색은 black으로 하고 투명도를 .05로 하시오.
- 남한 지역이 모두 지도에 나오도록 하시오.
head(data)
data3 <- subset(data, 월 == "07월" | 월 == "08월")


  
data3
agg2 <- aggregate(data3[,4:9], by=list(data3$시도), FUN = sum)
agg2 <- agg2[-10,]
agg2

gc <- geocode(enc2utf8(agg2$Group.1))
gc
cen <- geocode(enc2utf8("충주시"))
cen <- as.numeric(cen)
cen
map <- get_googlemap(center = cen,
                     maptype = 'roadmap',
                     zoom = 6)
#ggmap(map)
gmap <- ggmap(map)

df <- data.frame(agg2,gc)
head(df)

gmap+geom_point(data=df,
                aes(x=lon, y=lat, size=부상자수), # spd 열의 값
                alpha=0.5, # alpha : 색의 투명도. 0.5(반투명)
                col='black')+
  scale_size_continuous(range=c(1,14)) # 원의 크기 조절, 1(min크기), 14(Max크기)
agg2









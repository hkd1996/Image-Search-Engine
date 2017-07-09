library(png)
library(raster)
library(lsa)
library(shiny)
system("make")
system("ls")
#calculate mean rgb for all elements in the dataset 
for(i in 1:805){
  x<-get("i")
  y<-paste(x,'.png',sep = '')
  path<-paste('/home/secret95/Desktop/image_search_engine/dataset/',y,sep = '')
  path
  img <- readPNG(path)
  r<-as.data.frame(raster(img[,,1]), row.names=NULL, optional=FALSE)
  g<-as.data.frame(raster(img[,,2]), row.names=NULL, optional=FALSE)
  b<-as.data.frame(raster(img[,,3]), row.names=NULL, optional=FALSE)
  r_mean=sapply(r,mean)
  g_mean=sapply(g,mean)
  b_mean=sapply(b,mean)
  q<-cbind(y,r_mean,g_mean,b_mean)
  write.table(q, file = "/home/secret95/Desktop/image_search_engine/avg.csv", sep = ",", col.names = FALSE,row.names = FALSE,na="NA",append = TRUE)
}
# run input image query
runApp("/home/secret95/Desktop/image_search_engine/App")

df1<-read.csv('/home/secret95/Desktop/image_search_engine/avg.csv',header = FALSE)
rgb_vals<-cbind(df1$V2,df1$V3,df1$V4)
df2<-read.csv('/home/secret95/Desktop/image_search_engine/query_avg.csv',header = FALSE)
query_rgb<-cbind(df2$V1,df2$V2,df2$V3)
cs=c()
for(i in 1:nrow(df1)){
  x=query_rgb[1,]
  y=rgb_vals[i,]
  cs[i]<-cosine(x,y)
}

csa<-as.data.frame(cs,row.names=NULL, optional=FALSE)
csb<-cbind(csa,1:nrow(df1))
sorted<-csb[order(-cs),]
colnames(sorted)<-c("csvalue","imgno")
relevant_image=c()
for(i in 1:5){
  relevant_image[i]<-sorted[i,]$imgno
}
paths <- c()
z <- '/home/secret95/Desktop/image_search_engine/dataset/'
for(i in 1:length(relevant_image)){
  x <- relevant_image[i]
  y <-paste(x,'.png',sep = '')
  paths[i] <- paste(z, y, sep = '')
}
for(i in 1:5){
  val<-paths[i]
  dest<-'/home/secret95/Desktop/image_search_engine/App-1/www/'
  file.copy(val,dest)
}
dir='/home/secret95/Desktop/image_search_engine/App-1/www/'
filez<-list.files(dir,pattern="*.png")
too<-paste(1:5,".png",sep='')
file.rename(from=file.path(dir,filez),to=file.path(dir,too))

val<-'/home/secret95/Desktop/image_search_engine/0'
dest<-'/home/secret95/Desktop/image_search_engine/App-1/www/'
file.copy(val,dest)
write.table(paths, file = "/home/secret95/Desktop/image_search_engine/paths.csv", sep = ",", col.names = FALSE,row.names = FALSE,na="NA",append = TRUE)

#run results display
runApp("/home/secret95/Desktop/image_search_engine/App-1")

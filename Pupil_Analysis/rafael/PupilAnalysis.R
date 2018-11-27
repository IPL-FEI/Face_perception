###########################################################################################
#                                                                                         #  
# Title: "PupilAnalysis"                                                                  #
# Version: 3.0                                                                            #
# Date of last update: "October 20, 2018"                                                 #
# Author: "Rafael Nobre Orsi"                                                             #
# Maintainer: Rafael Nobre Orsi <rafaelorsi@fei.edu.br>                                   #
# License: Free (but don't forget to cite the reference)                                  #
#                                                                                         #
###########################################################################################
#                                                                                         #
# Description: Algorithm for pupillary signal processing                                  #
# This algorithm has 4 steps                                                              #
#                                                                                         #    
# In step 1 the original database is loaded                                               #
# In step 2 the database is filtered and only the signal of interest is extracted (base.0)#
#         Additional to this step: Signal loss analysis                                   #                                                         #
# In step 3 is done the pre-processing of the signal (base.1)                             #
#         Pre-processing steps                                                            #                      
#         1) Remove outliers (base.2)                                                     #
#         2) Data interpolation to fill signal loss (base.3)                              #
#         3) Smoothing filter to remove noise (base.4)                                    #
# In step 4 presents the final results (final report)                                     #
#                                                                                         #
###########################################################################################

# Libraries require (uncomment the lines below to use) 
# install.packages("stats") # Library to statistical alnalysis
# library(stats)

###########################################################################################
#                                                                                         #
#                            Step 1: Loading original database                            #
#                                                                                         #
###########################################################################################

getwd() # To view the current working directory
setwd('C:/Users/Rafa/Desktop/Varela') # Set working directory
pupil <- read.csv("Pupils_PA.tsv", header = TRUE, sep = "\t") # Read the database 1

###########################################################################################
#                                                                                         #
#             Step 2 - filter to extract only the signal of interest (base.0)             #
#                                                                                         #
###########################################################################################

base.0 <- pupil
# First it is evaluated which eye has greater signal loss
dim(base.0) #  = 5977680 5
length(base.0[!is.na(base.0$PupilLeft),][,3]) # = 4140790
length(base.0[!is.na(base.0$PupilRight),][,4]) # = 4104221

# In this case the PupilRight has greater loss, then it was only the PupilLeft  
base.0$PupilRight <- NULL # Remove PupilRigth to decrease processing
base.0$RecordingDuration <- NULL
base.0$RecordingTimestamp <- NULL
base.0$KeyPressEventIndex <- NULL
base.0$KeyPressEvent <- NULL

base.0$X <- NULL #Remove the X column that dos not use
base.0 <- base.0[!is.na(base.0$MediaName),] #Filters MediaName = NA
base.0 <- base.0[base.0$MediaName!="", ] #Filters MediaName = empty
base.0 <- base.0[base.0$MediaName!="Experimental GFTM.jpg", ] #Filters MediaName = empty

names(base.0)[1:1] <- c("RecordingName") # Rename the column because the load  changed the name

# Individual -  # Rec 08, 34 and 42 was excluded

rec <- c("P01","P02","P03","P04","P05","P06","P07","P09","P10","P11",
       "P12","P13","P14","P15","P16","P17","P18","P19","P20","P21",
       "P22","P23","P24","P25","P26","P27","P28","P29","P30","P31",
       "P32","P33","P35","P36","P37","P38","P39","P40","P41")


        #################################################################
        #                                                               #
        #                 Divide rec into smaler groups                 #
        #                                                               #
        #################################################################

          # Worst case scenario = Prosopagnosics:
      rec_Prosop <- c("P30","P07","P27","P20","P06","P38","P15","P14","P33","P41")
          # Intermediate group one:
      rec_Inter.1 <- c("P31","P25","P29","P32","P11","P37","P02","P17","P24")
          # Intermediate group two:
      rec_Inter.2 <- c("P26","P40","P12","P10","P05","P22","P28","P01","P04","P39")
          # Best case scenario = Super-Recognizers:
      rec_SuperR <- c("P19","P23","P13","P35","P36","P16","P21","P18","P09","P03")


# Test application sequence
slidet <- c("1.jpg","2.jpg","3.jpg","4.jpg","5.jpg","6.jpg","7.jpg","8.jpg","9.jpg","10.jpg",
            "11.jpg","12.jpg","13.jpg","14.jpg","15.jpg","16.jpg","17.jpg","18.jpg","19.jpg","20.jpg",
            "21.jpg","22.jpg","23.jpg","24.jpg","25.jpg","26.jpg","27.jpg","28.jpg","29.jpg","30.jpg",
            "31.jpg","32.jpg","33.jpg","34.jpg","35.jpg","36.jpg","37.jpg","38.jpg","39.jpg","40.jpg")

###########################################################################################
#                                                                                         #
#                                 SIGNAL LOSS ANALYSIS                                    #
#                                                                                         #
###########################################################################################

validsignal <- base.0[!is.na(base.0$PupilLeft),] #Filters PupilLeft = NA
signallength <- matrix(0,length(rec),3) #Matrix of signal length
index = 1
for (j in c(rec)){
  x1 <- base.0[base.0$RecordingName==j,] # Filters individual base.0
  x2 <- validsignal[validsignal$RecordingName==j,] # Filters individual original base
  signallength[index,1] = length(x1$PupilLeft) # Measures the length of the signal
  signallength[index,2] = length(x2$PupilLeft) # Measures the length of the original signal
  signallength[index,3] = length(x2$PupilLeft)/length(x1$PupilLeft) # Valid signal
  index = index + 1
}

###########################################################################################
#                                                                                         #
#                       FUNCTION TO EXTRACT INTERVAL OF INTEREST                          #
#                                                                                         #
###########################################################################################
#      # This step also serves to assemble the matrix of individuals (rows)               #
# Note # by variables (columns), so if the number of samples in the database is           #
#      # the same for all individuals, simply indicate the number of samples.             #
###########################################################################################
# Input 1: base<-("database")
# Input 2: RecordingName <- Column used to filter
# Input 3: MediaName <- Column used to filter
# Input 4: PupilLeft <- Column used to filter
# Input 5: rec<-c("set of individual")
# Input 6: slide<-c("set of slides")
# Input 7: window.cut <-("quantity of samples before decision making")
# Input 8: position <- receive the position of the cut - "pre" or "end" 
#          (write end if you want to observe the decision-making process)
# Output: clipping of database with same size signal
f.window.cut = function(base,RecordingName,MediaName,PupilLeft,rec,slide,window.cut,position){
  lr <- length(rec) 
  lc <- length(slide) 
  list <- matrix(0,lr,(lc*window.cut)) # Sets the size of the clipping matrix
  r <- 1
  for (j in c(rec)){
    d <- 0
    for(i in c(slide)){
      x1 <- base[base$RecordingName==j & base$MediaName==i,] # Filters signal base.1
      s2 <- length(x1$PupilLeft)
      if(position=="pre"){
        if(s2 < window.cut){
          window.seg <- x1$PupilLeft[ (1:s2)]
          for(k in c(1:s2)){
            list[r,d+k] <- window.seg[k]
          }
        }
        else{
          window.seg <- x1$PupilLeft[ (1:window.cut)]
          for(k in c(1:window.cut)){
            list[r,d+k] <- window.seg[k]
          }
        }
      }
      if(position=="end"){
        if(s2 < window.cut){
          s1 <- window.cut-s2+1
          window.seg <- matrix(NA,1,length(window.cut))
          window.seg[s1:window.cut] <- x1$PupilLeft[ (1:s2)]
          for(k in c(1:window.cut)){
            list[r,d+k] <- window.seg[k]
          }
        }
        else{
          s1 <- s2-window.cut+1
          window.seg <- x1$PupilLeft[ (s1:s2)]
          for(k in c(1:window.cut)){
            list[r,d+k] <- window.seg[k]
          }
        }
      }
      d <- d+window.cut
    }
    r <- r+1
  }
  return(list)
}
# base.1 - data matrix with clipping of interest
base.1 <- f.window.cut(base.0,RecordingName,MediaName,PupilLeft,rec,slidet,1800,"pre") 

###########################################################################################
#                                                                                         #
#                                Step 3 - Pre-processing                                  #
#                                                                                         #
###########################################################################################

###########################################################################################
#                                                                                         #
#                               REMOVE OUTILIER (base.2)                                  #
#                                                                                         #
###########################################################################################

base.2 = base.1
factor = 0.03
base.2[is.na(base.2)] <- 0 # Replace NA to 0
lr <- nrow(base.2)
lc <- ncol(base.2)
for(j in 1:lr){
  for(i in 2:lc-1){
    if(abs(base.2[j,i] - base.2[j,i+1]) > factor){
      base.2[j,i] = 0
    }
  }
  for(k in lc:2){
    if(abs(base.2[j,i] - base.2[j,i+1]) > factor){
      base.2[j,i+1] = 0
    }
  }
}
# Pre-view of the result
plot(base.2[1,],type="l")

###########################################################################################
#                                                                                         #
#   RECONSTRUCTION OF THE SIGNAL LOSS INTERVAL BY DATA LINEAR INTERPOLATION (base.3)      #
#                                                                                         #
###########################################################################################

base.3 = base.2
for(t in 1:lr){
  if(base.3[t,1]==0){
    base.3[t,1] <- mean(base.3[t,])
  }
  if(base.3[t,length(base.3[t,])]==0){
    base.3[t,length(base.3[t,])] <- mean(base.3[t,])
  }
  for(i in 1:length(base.3[t,])){
    if(base.3[t,i]== 0){
      va = base.3[t,i-1]
      pa = i-1
      pi = i
      for(k in i:length(base.3[t,])){
        if(base.3[t,k]!=0){
          vp = base.3[t,k]
          pp = k
          while(i<k){
            base.3[t,i] = va*(1-(i-pa)/(pp-pa))+vp*((1-(pp-i)/(pp-pa)))
            i = i+1
          }
          break
        }
      }
    }
  }
}
# Pre-view of the result
lines(base.3[1,],type="l", col = "red")

###########################################################################################
#                                                                                         #
#                     SMOOTHING FILTER TO REMOVE NOISE (base.4)                           #
#                                                                                         #
###########################################################################################

base.4 = base.3
# Smoothing filter
for(i in 1:lr){
  x = smooth.spline(base.4[i,])
  base.4[i,]<-x$y
}
# Pre-view of the result
# Signal before
plot(base.3[1,1:400],type="l") # Zoom to see detail (base.3)
# Signal after
lines(base.4[1,1:400],type="l",col="red") # Signal Smoothed (base.4)

###########################################################################################
#                                                                                         #
#                          RESULTS OF THE PRE-PROCESSING                                  #
#                                                                                         #
###########################################################################################

passo <- c(30,60,90,120,150,180,210,240,270,300)
min.passo <- c(30,60,90,120,150,180,210,240,270,300)
t.passo <- c(30,60,90,120,150,180,210,240,270,300)

pdf("0_pre_processamento_do_sinal.pdf",width = 4, height = 5)
par(mfrow=c(3,1),mar=c(4,4,2,1),bty="l",cex.axis=0.7,cex.lab=0.7,cex.main=0.7)
plot(x = base.2[1,500:800],type="l",ylim=c(3.7,4.3),xaxt = "n",main="ORIGINAL SIGNAL",
     xlab="Samples in 1 second interval", ylab="Pupil diameter (mm)")
axis(1,at=min.passo,labels=t.passo)
plot(x = base.3[1,500:800],type="l",ylim=c(3.7,4.3),xaxt = "n",main="RECONSTRUCTED SIGNAL",
     xlab="Samples in 1 second interval", ylab="Pupil diameter (mm)")
axis(1,at=min.passo,labels=t.passo)
plot(x = base.4[1,500:800],type="l",ylim=c(3.7,4.3),xaxt = "n",main="SMOOTHED SIGNAL (NO NOISE)",
     xlab="Samples in 1 second interval", ylab="Pupil diameter (mm)")
axis(1,at=min.passo,labels=t.passo)
dev.off()

###########################################################################################
#                                                                                         #
#                                       AVERAGE CURVE                                    #
#                                                                                         #
###########################################################################################

curva.media <- matrix(0,1,32400)
for(j in 1:length(base.4[1,])){   
  curva.media[,j] <- mean(base.4[,j])
}
cm.positive <- rbind(curva.media[,1:1800],curva.media[,10801:12600],curva.media[,12601:14400],
                     curva.media[,16201:18000],curva.media[,18001:19800],curva.media[,21601:23400],
                     curva.media[,25201:27000],curva.media[,27001:28800],curva.media[,30601:32400])
cm.negative <- rbind(curva.media[,1801:3600],curva.media[,3601:5400],curva.media[,5401:7200],
                     curva.media[,7201:9000],curva.media[,9001:10800],curva.media[,14401:16200],
                     curva.media[,19801:21600],curva.media[,23401:25200],curva.media[,28801:30600])

mean.positive <- matrix(0,1,1800)
mean.negative <- matrix(0,1,1800)
for(j in 1:1800){
  mean.positive[1,j] <- mean(cm.positive[,j])
  mean.negative[1,j] <- mean(cm.negative[,j])
}
#pre-view
par(mfrow=c(1,1),mar=c(4,4,2,1),bty="l",cex.axis=0.7,cex.lab=0.7,cex.main=0.7)
plot(mean.positive[1,],ylim=c(3.55,4.45),type = "l", col = "blue")
lines(mean.negative[1,],type = "l", col = "red")


###########################################################################################
#                                                                                         #
#                                     REPORT OF RESULTS                                   #
#                                                                                         #
###########################################################################################

pace <- c(150,300,450,600,750,900,1050,1200,1350,1500,1650,1800)
min.pace <- c(1,300,600,900,1200,1500,1800)
t.pace <- c(0,1,2,3,4,5,6)
p.positive <- matrix(0,12,2)
for(j in 1:12){
  p.positive[j,1] <- pace[j]
  p.positive[j,2] <- mean.positive[1,pace[j]]
}
p.negative <- matrix(0,12,2)
for(j in 1:12){
  p.negative[j,1] <- pace[j]
  p.negative[j,2] <- mean.negative[1,pace[j]]
}

pdf("1_curva_media.pdf",width = 5, height = 5)
par(mfrow=c(1,1),mar=c(4,4,1,1),bty="l",cex.axis=0.7,cex.lab=0.7,cex.main=0.7)
plot(x = c(0,1800), y = c(3.5,4.5), xaxt = "n", col = "white", 
     xlab="Time(s)", ylab="Pupil diameter (mm)")
lines(mean.positive[1,],  type = "l", col = "blue")
points(p.positive, cex = 1 , pch = 15)
lines(mean.negative[1,],type = "l", col = "red")
points(p.negative, cex = 1 , pch = 22, bg = "white")
legend("bottomright", legend=c("Positive stimuli","Negative stimuli"),
       cex = 0.85, col=c("blue","red"),lty=1,lwd=1, bty="n")
axis(1,at=min.pace,labels=t.pace)
dev.off()

###############################################################################
#                                                                             #
#              REPORT 2 - TEST WITH CUT SIGNAL - 1 PRE AND 1 END              #
#                                                                             #
###############################################################################

# Signal Cut
st1<-base.4[,(1*300+1):(5*300)];
st2<-base.4[,(7*300+1):(11*300)];
st3<-base.4[,(13*300+1):(17*300)];
st4<-base.4[,(19*300+1):(23*300)];
st5<-base.4[,(25*300+1):(29*300)];
st6<-base.4[,(31*300+1):(35*300)];
st7<-base.4[,(37*300+1):(41*300)];
st8<-base.4[,(43*300+1):(47*300)];
st9<-base.4[,(49*300+1):(53*300)];
st10<-base.4[,(55*300+1):(59*300)];
st11<-base.4[,(61*300+1):(65*300)];
st12<-base.4[,(67*300+1):(71*300)];
st13<-base.4[,(73*300+1):(77*300)];
st14<-base.4[,(79*300+1):(83*300)];
st15<-base.4[,(85*300+1):(89*300)];
st16<-base.4[,(91*300+1):(95*300)];
st17<-base.4[,(97*300+1):(101*300)];
st18<-base.4[,(103*300+1):(107*300)];
stt <- cbind(st1,st2,st3,st4,st5,st6,st7,st8,st9,st10,
             st11,st12,st13,st14,st15,st16,st17,st18)

# Identidad test
plot(base.4[1,2101:3300])
lines(stt[1,1201:2400], col="red")

curva.media.cut <- matrix(0,1,21600)
for(j in 1:length(stt[1,])){
  curva.media.cut[,j] <- mean(stt[,j])
}
cm.positive.cut <- rbind(curva.media.cut[,1:1200],curva.media.cut[,7201:8400],
                         curva.media.cut[,8401:9600],curva.media.cut[,10801:12000],
                         curva.media.cut[,12001:13200],curva.media.cut[,14401:15600],
                         curva.media.cut[,16801:18000],curva.media.cut[,18001:19200],
                         curva.media.cut[,20401:21600])

cm.negative.cut <- rbind(curva.media.cut[,1201:2400],curva.media.cut[,2401:3600],
                         curva.media.cut[,3601:4800],curva.media.cut[,4801:6000],
                         curva.media.cut[,6001:7200],curva.media.cut[,9601:10800],
                         curva.media.cut[,13201:14400],curva.media.cut[,15601:16800],
                         curva.media.cut[,19201:20400])

mean.positive.cut <- matrix(0,1,1200)
mean.negative.cut <- matrix(0,1,1200)
for(j in 1:1200){
  mean.positive.cut[1,j] <- mean(cm.positive.cut[,j])
  mean.negative.cut[1,j] <- mean(cm.negative.cut[,j])
}
#pre-view
par(mfrow=c(1,1),mar=c(4,4,1,1),bty="l",cex.axis=0.5,cex.lab=0.7,cex.main=0.7)
plot(mean.positive.cut[1,],type = "l", col = "blue")
lines(mean.negative.cut[1,],type = "l", col = "red")

pace.cut <- c(1,150,300,450,600,750,900,1050,1200)
min.pace.cut <- c(1,300,600,900,1200)
t.pace.cut <- c(1,2,3,4,5)
p.positive.cut <- matrix(0,9,2)
for(j in 1:9){
  p.positive.cut[j,1] <- pace.cut[j]
  p.positive.cut[j,2] <- mean.positive.cut[1,pace.cut[j]]
}
p.negative.cut <- matrix(0,9,2)
for(j in 1:9){
  p.negative.cut[j,1] <- pace.cut[j]
  p.negative.cut[j,2] <- mean.negative.cut[1,pace.cut[j]]
}

vazio = matrix(NA,1,300)
new.positive.cut = cbind(vazio,mean.positive.cut)
new.negative.cut = cbind(vazio,mean.negative.cut)
new.p.positive.cut = p.positive.cut
new.p.negative.cut = p.negative.cut
pace.cut2 <- c(300,450,600,750,900,1050,1200,1350,1500)
for(j in 1:9){
  new.p.positive.cut[j,1] <- pace.cut2[j]
  new.p.negative.cut[j,1] <- pace.cut2[j]
}

pdf("2_curva_media_cortada.pdf",width = 5, height = 5)
par(mfrow=c(1,1),mar=c(4,4,1,1),bty="l",cex.axis=0.7,cex.lab=0.7,cex.main=0.7)
plot(x = c(0,1800), y = c(3.5,4.5), xaxt = "n", col = "white", 
     xlab="Time(s)", ylab="Pupil diameter (mm)")
lines(mean.positive[1,],  type = "l", col = "gray50")
lines(mean.negative[1,],type = "l", col = "gray50")
abline(v=300, lty = 3)
abline(v=1500, lty = 3)
lines(new.positive.cut[1,],  type = "l", col = "blue")
lines(new.negative.cut[1,],  type = "l", col = "red")
points(new.p.positive.cut, cex = 1 , pch = 15)
points(new.p.negative.cut, cex = 1 , pch = 22, bg = "white")
legend("bottom", legend=c("Positive stimuli","Negative stimuli"),
       cex = 0.85, col=c("blue","red"),lty=1,lwd=1, bty="n")
axis(1,at=min.pace,labels=t.pace)
dev.off()

# Test of relevance statistical
t.test(mean.positive.cut,mean.negative.cut)

base.7<-matrix(0,1,21600)
for(j in 1:21600){
  base.7[1,j] <- mean(stt[,j])
}
base.7 <- rbind(base.7[,1:1200],base.7[,1201:2400],base.7[,2401:3600],
                base.7[,3601:4800],base.7[,4801:6000],base.7[,6001:7200],
                base.7[,7201:8400],base.7[,8401:9600],base.7[,9601:10800],
                base.7[,10801:12000],base.7[,12001:13200],base.7[,13201:14400],
                base.7[,14401:15600],base.7[,15601:16800],base.7[,16801:18000],
                base.7[,18001:19200],base.7[,19201:20400],base.7[,20401:21600])
base.7 = t(base.7)
boxplot(base.7) #Pré view

# Parameters to boxplot below
xl = c(1,18); yl = c(3.4,4.37); pc = "steelblue3"; nc = "indianred1";

pdf("3_boxplot.pdf",width = 5, height = 5)
par(mfrow=c(1,1),mar=c(4,4,1,1),bty="l",cex.axis=0.7,cex.lab=0.7,cex.main=0.7)
boxplot(base.7[,1], axes = FALSE, outline = FALSE,col = pc, ylim =yl ,xlim = xl,at = 1:1)
boxplot(base.7[,2], axes = FALSE, outline = FALSE,col = nc, ylim =yl ,xlim = xl,at = 1:1+1,add = TRUE)
boxplot(base.7[,3], axes = FALSE, outline = FALSE,col = nc, ylim =yl ,xlim = xl,at = 1:1+2,add = TRUE)
boxplot(base.7[,4], axes = FALSE, outline = FALSE,col = nc, ylim =yl ,xlim = xl,at = 1:1+3,add = TRUE)
boxplot(base.7[,5], axes = FALSE, outline = FALSE,col = nc, ylim =yl ,xlim = xl,at = 1:1+4,add = TRUE)
boxplot(base.7[,6], axes = FALSE, outline = FALSE,col = nc, ylim =yl ,xlim = xl,at = 1:1+5,add = TRUE)
boxplot(base.7[,7], axes = FALSE, outline = FALSE,col = pc, ylim =yl ,xlim = xl,at = 1:1+6,add = TRUE)
boxplot(base.7[,8], axes = FALSE, outline = FALSE,col = pc, ylim =yl ,xlim = xl,at = 1:1+7,add = TRUE)
boxplot(base.7[,9], axes = FALSE, outline = FALSE,col = nc, ylim =yl ,xlim = xl,at = 1:1+8,add = TRUE)
boxplot(base.7[,10], axes = FALSE, outline = FALSE,col = pc, ylim =yl ,xlim = xl,at = 1:1+9,add = TRUE)
boxplot(base.7[,11], axes = FALSE, outline = FALSE,col = pc, ylim =yl ,xlim = xl,at = 1:1+10,add = TRUE)
boxplot(base.7[,12], axes = FALSE, outline = FALSE,col = nc, ylim =yl ,xlim = xl,at = 1:1+11,add = TRUE)
boxplot(base.7[,13], axes = FALSE, outline = FALSE,col = pc, ylim =yl ,xlim = xl,at = 1:1+12,add = TRUE)
boxplot(base.7[,14], axes = FALSE, outline = FALSE,col = nc, ylim =yl ,xlim = xl,at = 1:1+13,add = TRUE)
boxplot(base.7[,15], axes = FALSE, outline = FALSE,col = pc, ylim =yl ,xlim = xl,at = 1:1+14,add = TRUE)
boxplot(base.7[,16], axes = FALSE, outline = FALSE,col = pc, ylim =yl ,xlim = xl,at = 1:1+15,add = TRUE)
boxplot(base.7[,17], axes = FALSE, outline = FALSE,col = nc, ylim =yl ,xlim = xl,at = 1:1+16,add = TRUE)
boxplot(base.7[,18], outline = FALSE,col = pc, ylim =yl ,xlim = xl,at = 1:1+17,add = TRUE, 
        xlab="Stimuli", ylab="Pupil diameter (mm)")
legend("topright", legend=c("Positive stimuli","Negative stimuli"),
       cex = 0.85, col=c(pc,nc),lty=1,lwd=1, bty="n")
axis(1,at=c(1:18))
dev.off()


base.p <- as.vector(cbind(base.7[,1],base.7[,7],base.7[,8],base.7[,10],base.7[,11],
                          base.7[,13],base.7[,15],base.7[,16],base.7[,18]))
base.n <- as.vector(cbind(base.7[,2],base.7[,3],base.7[,4],base.7[,5],base.7[,6],
                          base.7[,9],base.7[,12],base.7[,14],base.7[,17]))
base.8 <- cbind(base.p,base.n)
dim(base.8)
boxplot(base.8,col = pc) #Pré view

# Parameters to boxplot below
xl = c(1,18); yl = c(3.4,4.37); pc = "steelblue3"; nc = "indianred1";

pdf("4_boxplot.pdf",width = 5, height = 5)
par(mfrow=c(1,1),mar=c(4,4,1,1),bty="l",cex.axis=0.7,cex.lab=0.7,cex.main=0.7)
boxplot(base.8[,1], outline = FALSE,col = pc, ylim =yl ,xlim = c(1,2),at = 1:1+0.25)
boxplot(base.8[,2], outline = FALSE,col = nc, ylim =yl ,xlim = c(1,2),at = 1:1+0.75,add = TRUE, 
        ylab="Pupil diameter (mm)")
axis(1,at=c(1.25,1.75),labels=c("Positive stimuli","Negative Stimuli"))
dev.off()

pdf("5_boxplot.pdf",width = 5, height = 5)
par(mfrow=c(1,1),mar=c(4,4,1,1),bty="l",cex.axis=0.7,cex.lab=0.7,cex.main=0.7)
boxplot(base.8[,1], outline = FALSE,col = pc, ylim =yl ,xlim = c(1,3),at = 1:1+0.5)
boxplot(base.8[,2], outline = FALSE,col = nc, ylim =yl ,xlim = c(1,3),at = 1:1+1.5,add = TRUE, 
        ylab="Pupil diameter (mm)")
axis(1,at=c(1.5,2.5),labels=c("Positive stimuli","Negative Stimuli"))
dev.off()



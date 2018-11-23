##
#=============
# Rafael Nobre and Víctor Varela
# Pupil Dilation - GFMT
#=============
##

#================Step one: =============
#=Read data and atribute it to a variable

pupil <- read.csv("Pupils_PA.tsv", header = TRUE, sep = "\t") 

#================Step two================
#======Filter and data organization======

# Filters
pupil <- pupil[!is.na(pupil$MediaName),] #-----------------#Filter where MediaName = NA
#pupil <- pupil[!is.na(pupil$PupilLeft),] #----------------#Filter where PupilLeft = NA
#pupil <- pupil[!is.na(pupil$PupilRight),] #---------------#Filter where PupilLeft = NA
pupil <- pupil[pupil$MediaName!="", ] #--------------------#Filter where MediaName = "empty" ("")
pupil <- pupil[pupil$MediaName!="Experimental GFTM.jpg", ] #Filter test slide (Experimental GFTM.jpg)

# Organization
pupil$X <- NULL #------------------------------------------# Remove column X (blank column inserted by TSV file)
pupil$Participante <- pupil$ParticipantName #--------------# Copy column named ParticipantName to Participante
pupil$Slide <- pupil$MediaName #---------------------------# Copy column named MediaName to Slide
pupil$Diametro <- (pupil$PupilLeft + pupil$PupilRight) / 2 # Create column Diameter, equals to the mean between two pupils
pupil$ParticipantName <- NULL #----------------------------# ParticipantName excluded for processing reduction
pupil$MediaName <- NULL #----------------------------------# MediaName excluded for processing reduction
pupild <- pupil #------------------------------------------# Copy data base to preserve pupil diameter for PCA analysis
pupil <- pupil[!is.na(pupil$Diametro),] #------------------# Filter where Diameter = NA
pupil$PupilLeft <- NULL #----------------------------------# PupilLeft excluded for processing reduction
pupil$PupilRight <- NULL #---------------------------------# PupilLeft excluded for processing reduction

# Store Data Base. 
write.csv(pupild, "DadosDiametro.csv") #-------------------# Comando para gravar arquivo filtrado e organizado.
write.csv(pupil, "Dadosfiltrados.csv") #-------------------# Comando para gravar arquivo filtrado e organizado.

#================Step Three==============
#==============Data Processing===========

# Participants ---- Removed participants named "P08" and "P34" . Reason: low signal
participante<-c("P01","P02","P03","P04","P05","P06","P07","P09","P10","P11",
                "P12","P13","P14","P15","P16","P17","P18","P19","P20","P21",
                "P22","P23","P24","P25","P26","P27","P28","P29","P30","P31",
                "P32","P33","P35","P36","P37","P38","P39","P40","P41","P42")


levels(pupil$RecordingName)


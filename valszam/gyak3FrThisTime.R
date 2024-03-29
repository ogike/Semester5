##########################################
###   3. Laboros gyakorlat (6-7. h�t)   ###
##########################################

#####################
# Le�r� statisztika #
#####################

# 1. Egy szab�lyos dob�kock�val n�gyszer dobtunk �s a k�vetkez�ket kaptuk: 1, 3, 6, 1.

x <- c(1,3,6,1)

# (a) Sz�molja ki a minta�tlagot, tapasztalati sz�r�st �s 
#     korrig�lt tapasztalati sz�r�st, a sz�r�si egy�tthat�t (a korrig�lt sz�r�st
#     haszn�lva), valamint a m�sodik tapasztalati momentumot!

mean(x)                     # minta�tlag



sqrt(mean((x-mean(x))^2))   # tapasztalati sz�r�s
# sqrt( ((1-mean(x))^2+(3-mean(x))^2+(6-mean(x))^2+(1-mean(x))^2) / 4 )

sd(x)                       # korrig�lt tapasztalati sz�r�s ( = sqrt(var(x)) ) 
                              # "torz�tatlan becsl�se a val�s�gos sz�r�snak"

var(x)                      # korrig�lt sz�r�sn�gyzet ( = sd(x)^2 )

sd(x)/mean(x)               # sz�r�si egy�tthat� (vagy relat�v sz�r�s, CV) (�tlaghoz viszony�tott sz�r�s)

mean(x^2)                   # tapasztalati m�sodik momentum

cat("�tlag:", mean(x),
    "\nsz�r�s:", sqrt(mean((x-mean(x))^2)),
    "\nkorrig�lt sz�r�s:", sd(x),
    "\nsz�r�si egy�tthat�:", sd(x)/mean(x),
    "\ntapasztalati m�sodik momentum:", mean(x^2),'\n')

# (b) Tekints�k a 101, 103, 106, 101 adatokat, melyeket az eloz�ekb�l
#     100-zal val� eltol�ssal kaptunk. Mennyi lesz most a minta�tlag �s 
#     a tapasztalati sz�r�s?

x_new <- x + 100 
cat('�tlag:',mean(x_new),
    'r�gi �tlag:',mean(x),
    '\nsz�r�s:',sd(x_new),
    'r�gi sz�r�s:',sd(x),'\n')


# (c) Az (a)-pontbeli adatokat szorozzuk meg -3-mal: -3, -9, -18, -3. 
#     Hogyan v�ltozik ekkor a minta�tlag �s a tapasztalati sz�r�s?

x_new <- -3*x
cat('�tlag:',mean(x_new),
    'r�gi �tlag:',mean(x),
    '\nsz�r�s:',sd(x_new),
    'r�gi sz�r�s:',sd(x),'\n')

# Ahogy v�rtuk, az �tlag �s a sz�r�s szorz�dik, az �tlag -3-mal, a sz�r�s 3-mal.


# 2. Egy csoportban a hallgat�k magass�ga (cm):
#   180, 163, 1500, 157, 165, 165, 174, 191, 172, 165, 1-68, 186

radatok <- c(180,163,1500,157,165,165,174,191,172,165,1-68,186)


# (a) N�zzen r� az adatokra! Re�lisak? Jav�tsa az esetleges adathib�kat!
#     Hib�snak t�nik k�t adat, azokat jelen esetben �rtelemszer�en 
#     jav�thatjuk. De ilyesmivel vigy�zni kell, "cs�nya" adatokat 
#     nem szabad csak �gy jav�tani...

# Magass�gi adatok:
radatok
n <- length(radatok); n       # mintanagys�g

plot(radatok)
summary(radatok)      # statisztik�k: min, max, �tlag, kvartilisek
                        # kvartilis: medi�n �ltal�nos�t�sa
data.entry(radatok)

# Jav�tott magass�gi adatok:
adatok <- radatok
adatok[3] <- 150	# ellen�r�zve: 1500 helyett 150
adatok[11] <- 168	# ellen�r�zve: 1-68 helyett 168
adatok

plot(adatok)
summary(adatok)


# (b) Elemezze a hallgat�k testmagass�g�t alapstatisztik�k: �tlag, 
#     korrig�lt tapasztalati sz�r�s, sz�r�si egy�tthat�, kvartilisek,
#     terjedelem, interkvartilis terjedelem
min(adatok)
max(adatok)
max(adatok) - min(adatok)           # terjedelem

which(adatok == max(adatok))

mean(adatok)                        # �tlag
sd(adatok)                  				# korrig�lt tapasztalati sz�r�s
sd(adatok)/mean(adatok)             # sz�r�si egy�tthat�

sum( adatok >= 160 )                # h�ny adat >= 160

# kvartilisek kisz�m�t�sa, 6-os t�pus: (elm�leti le�r�sban szerepl� k�plet alapj�n) 
kvart <- quantile(adatok, probs = c(1/4, 1/2, 3/4), type = 6)
kvart

kvart[3] - kvart[1]                 # interkvartilis terjedelem


# (c) Adja meg a rendezett mint�t!

x <- sort(adatok); x


# (d) Rajzolja fel a tapasztalati eloszl�sf�ggv�nyt! Mennyi a tapasztalati 
#     eloszl�sf�ggv�ny �rt�ke a 180 helyen? �rtelmezze sz�vegesen!

Fn <- ecdf(adatok)
plot(Fn, do.points = FALSE, ylab='Fn(x)',		   # x a rendezett minta
     main = "Tapasztalati eloszl�s f�ggv�ny")
points(unique(x), unique(c(0, Fn(x)))[1:length(unique(x))], pch=19)
points(unique(x), unique(Fn(x)), pch=21)

# ecdf tapasztalati eloszl�sf�ggv�ny jobbr�l folytonos:
Fn(180)
# �talak�tva balr�l folytonos:
Fn_bf <- function(x) { mean(adatok<x) }
Fn_bf(180)

abline(v = 180, lty = 3)
abline(h = Fn_bf(180), lty = 3)


# (e) K�sz�tsen boxplot �br�t!

boxplot(adatok)
boxplot(adatok, horizontal=TRUE)

# dev.new()
library(ggplot2)
df <- data.frame(adatok)
ggplot(data = df, aes(x = "", y = adatok)) + 
  geom_boxplot(fill="cyan") #+
# coord_cartesian(ylim = c(150, 195)) 


# (f) K�sz�tsen hisztogramot!

ggplot(data=df, aes(x=adatok)) + 
  geom_histogram(breaks=seq(150, 200, by = 10), 
                 col="blue", 
                 fill="cyan", 
                 alpha = .2) + 
  labs(title="Magass�gi adatok hisztogramja (ggplot)", x="Magass�g", y="Gyakoris�g") 

hisz <- hist(adatok, #breaks=5,
             xlab="Magass�g", 
             ylab="Gyakoris�g", 
             main="Magass�gi adatok hisztogramja (hist)", 
             col="cyan", 
             border="blue")
hisz$counts				# gyakoris�gok az egyes oszt�lyokban

hist(adatok, breaks=c(min(adatok), 160, 170, 180, max(adatok)),
     xlab="Magass�g", 
     ylab="Gyakoris�g", 
     main="Magass�gi adatok hisztogramja (hist, breaks)", 
     col="cyan", 
     border="blue")


#############
## Boxplot ##
#############

# built-in datasets
# https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/00Index.html

boxplot(Temp ~ Month,
        data=airquality,
        main="Boxplotok havonta",
        xlab="H�nap",
        ylab="H�m�rs�klet (Fahrenheit)",
        col="orange",
        border="brown")

###    Hisztogram: Airquality adathalmaz  ###
############################################
# be�p�tett adathalmazok, p�lda: airquality$Temp
# https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/00Index.html
head(airquality)
h <- hist(airquality$Temp, #breaks=seq(50,100,2), #breaks=seq(50,100,10),
          col="red",
          xlab="h�m�rs�klet (F)", 
          ylab="gyakoris�g", 
          main="H�m�rs�klet hisztogram (airquality)")
h$breaks
h$counts
hist(airquality$Temp, freq=FALSE,
     col="red",
     xlab="h�m�rs�klet (F)",
     ylab="s�r�s�g", 
     main="H�m�rs�klet hisztogram (airquality)")
lines(density(airquality$Temp), lwd = 2, col = "blue")
############################################
############################################
#k�zel�t�s norm�lis eloszl�ssal
hist(airquality$Temp, freq=FALSE,
     col="red",
     xlab="h�m�rs�klet (F)",
     ylab="s�r�s�g", 
     main="H�m�rs�klet hisztogram (airquality)")
x <- seq(55,100,1)
dn <- dnorm(x, mean = mean(airquality$Temp), sd = sd(airquality$Temp))
lines(x, dn,type="l", lwd=2, col="blue")

# 3. Legyen

adat <- c(2,0,1,0,8,3,5,7,8,2,3,5,1,7,8,3,5,3,2,8)

# (a) Mit sz�mol az al�bbi R program?

sum(adat<3)

########## MEGOLD�S ##########
# Az adat<3 kifejez�s �rt�ke egy logikai t�mb, ennek �sszege az 
# igaz �rt�kek sz�ma, azaz az eredm�ny a 3-n�l kisebb adatok sz�ma.
##############################

t_adat <- table(adat)
names(t_adat)[t_adat==max(t_adat)] 

########## MEGOLD�S ##########
# A table f�ggv�ny el�sz�r az adat vektorb�l k�sz�t kontigencia t�bl�t. 
# Azaz az el�fordul� �rt�kek mindegyik�re megadja az el�fordul�sok sz�m�t. 
# Ezut�n ki�rja a leggyakrabban el�fordul� �rt�keket (string-k�nt).
##############################

rep <- rep(c("A","B"), c(10,10))
df <- data.frame(adat = adat,rep=rep)
ggplot(df, aes(x = rep, y = adat)) +
  geom_boxplot(fill = "gold") +
  scale_x_discrete (name = "A  �s  B csoport") 

########## MEGOLD�S ##########
# Az els� k�t sor egy data.frame-et k�sz�t. Az adatok els� fele A, 
# m�g a m�sodik fele a B csoportba ker�l. Ezut�n boxplot-ot k�sz�t�nk 
# mindk�t csoport adataib�l, �s ezeket egym�s mellett �br�zoljuk.
##############################

# (b) Az al�bbi �rt�k TRUE vagy FALSE?

sd(adat) == sqrt(sum((adat-mean(adat))^2)/(length(adat)))

# Amennyiben hamis az �ll�t�s, hogyan lehet igazz� tenni?

########## MEGOLD�S ##########
# A bal oldal a korrig�lt tapasztalati sz�r�st, m�g a jobboldal 
# a korrig�latlan v�ltozatot sz�molja, �gy ezek �ltal�ban k�l�nb�z�ek 
# (kiv�ve, ha az adat minden eleme azonos).

sd(adat) == sqrt(sum((adat-mean(adat))^2)/(length(adat)-1))
##############################



###################################
## Tapasztalati eloszl�sf�ggv�ny ##  
###################################  


# Minta: X_1,...,X_n val�sz�n�s�gi v�ltoz� sorozat.  
# A tov�bbiakban feltessz�k, hogy f�ggetlenek �s azonos eloszl�s�ak. 
# Realiz�ci�ja: x_1,...,x_n
# Statisztika: A minta valamely f�ggv�nye, pl. �tlag,
# tapasztalati eloszl�sf�ggv�ny: 
#   F_n(x) = 1/n sum_{i=1}^n  I(X_i<x), 
#   ahol I(X_i<x)= 1, ha X_i < x, 0 ha X_i >= x indik�tor f�ggv�ny

# Glivenko-Cantelli t�tel: Az F_n(x) tapasztalati eloszl�sf�ggv�ny �s 
# az F(x) elm�leti eloszl�sf�ggv�ny k�z�tti elt�r�s maximuma 1 val�sz�n�s�ggel 
# egyenletesen 0-hoz konverg�l, ami azt jelenti, hogy el�g nagy minta 
# eset�n F_n(x) �rt�ke minden x-re k�zel van F(x) �rt�k�hez.


# 1. Gener�ljon 100 kockadob�st �s �br�zolja annak a tapasztalati eloszl�sf�ggv�ny�t!

n_values <- 100
x_sample<- sample(1:6, size = n_values, replace = TRUE)
table(x_sample)

barplot(table(x_sample),
        col="red",
        xlab="�rt�k",
        ylab="Gyakoris�g",
        main="Dob�kocka dob�sok")

plot(ecdf(x_sample), 
     do.points=FALSE, 
     col="red", 
     lwd=2,
     xlim=c(1, 6),
     main='Tapasztalati eloszl�sf�ggv�ny')


# eloszl�s elm�leti �s tapasztalati eloszl�sf�ggv�nye - szimul�ci�

x <- 1:6
trueF <- ecdf(x)
n_values <- 100
x_sample <- sample(1:6, size = n_values, replace = TRUE) #floor(runif(n_values, min=1, max=7))

plot(trueF, 
     do.points=FALSE, 
     lwd=3, 
     ylab = "F(x)",
     main='Elm�leti �s tapasztalati eloszl�sf�ggv�ny \n (diszkr�t egyenletes az {1,2,3,4,5,6}-on)')
plot(ecdf(x_sample), add=TRUE,
     do.points=FALSE, 
     xlim=c(1, 6),  
     col="red", 
     lwd=2)
legend(x='topleft', 
       bty='n', 
       legend = c('elm�leti', 'tapasztalati'), 
       col = c("black", "red"), 
       lwd = 2)
#points(unique(x), unique(c(0, trueF(x)))[1:length(unique(x))], pch=19)
#points(unique(x), unique(trueF(x)), pch=21)

# egy �br�n t�bb szimul�ci�

n_values <- c(10,100,1000)
cols <- c("black", "yellow", "orange", "red2")  #colorspace::diverge_hsv(length(n_values)+1)

i<-0
plot(trueF,
     do.points=FALSE,
     col=cols[i<-i+1],
     lwd=3,
     main='Tapasztalati �s elm�leti eloszl�sf�ggv�ny')
for(n in n_values){
  x_sample <- sample(1:6, size = n, replace = TRUE)
  plot(ecdf(x_sample),
       add=TRUE,
       do.points=FALSE,
       col=cols[i<-i+1],lwd=2)
}
legend(x='topleft',
       bty='n',
       col = cols,
       lwd = 2,
       legend = c('elm�leti', paste('n',n_values,sep='=')))



# 2. Norm�lis eloszl�s elm�leti �s tapasztalati eloszl�sf�ggv�nye - szimul�ci�

n <- 12
x <- rnorm(n)

plot(ecdf(x), 
     do.points=FALSE, 
     xlim=c(-3.2,3.2), 
     col="red", 
     lwd=2, 
     main='Elm�leti �s tapasztalati eloszl�sf�ggv�ny \n (abszol�t folytonos v.v.: standard norm�lis)', ylab = " ")

x_sample <- seq(-3.2, 3.2, 0.01)
lines(x_sample, pnorm(x_sample), lw=2) # ez a kek az elm�leti
legend(x='topleft', 
       bty='n', 
       col = c("black", "red"), 
       lwd = 2, 
       legend = c('elm�leti', 'tapasztalati') )


szamok <- c(4.96,  4.52,  4.13,  4.2, 4.48);
#szamok <- c(4.53, 4.3, 4.63, 4.09, 4.81);
szamok
#Masodfoku egyenlet szamolo stackoverflowrol xd
result <- function(a,b,c){
  if(delta(a,b,c) > 0){
    x_1 = (-b+sqrt(delta(a,b,c)))/(2*a)
    x_2 = (-b-sqrt(delta(a,b,c)))/(2*a)
    result = c(x_1,x_2)
  }
  else if(delta(a,b,c) == 0){
    x = -b/(2*a)
  }
  else {"There are no real roots."}
}
delta<-function(a,b,c){
  b^2-4*a*c
}

atlag <- mean(szamok)
c <- 2*atlag - 1

ElsoFeladatEredmeny <- round(max(result(1,2,-c)),2);
ElsoFeladatEredmeny

#2. feladat
szamok2 <- c(1.189, 0.135, 0.2, 1.239)
  
MasodikFeladatEredmeny <- round(max(szamok2),3) 
MasodikFeladatEredmeny


n <- 16;
szoras <- 2
mu0 <- 6;
u <- sqrt(n)*( 7 - mu0) / 2
u

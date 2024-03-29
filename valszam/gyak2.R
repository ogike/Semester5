##########################################
###   1. Laboros gyakorlat (1-2 h�t)   ###
##########################################


## K�S�RLET 1 ##

# Dobjunk fel egy szab�lyos �rm�t egym�s ut�n sokszor, �s jegyezz�k fel 
# a kapott fej-�r�s sorozatot. P�ld�ul az F I I F I F F F . . . sorozatot 
# kaphatjuk. Ha n dob�sb�l k fejet kapunk, akkor k-t a fej dob�sok 
# gyakoris�g�nak, m�g k/n-et a fej dob�sok relat�v gyakoris�g�nak nevezz�k. 
# A fenti p�ld�ban e relat�v gyakoris�gok sorozata: 
# 1/1 , 1/2 , 1/3 , 2/4 , 2/5 , 3/6 , 4/7 , 5/8 , . . . 
# Az �gy kapott sorozat nem "szab�lyos" sorozat, a hagyom�nyos matematikai 
# �rtelemben (egyel�re) nem �ll�thatjuk r�la, hogy konvergens. Csup�n annyi 
# l�that�, hogy "szab�lytalan", "v�letlen ingadoz�sokat" mutat� sorozat, �s 
# a k�s�rlet �jabb v�grehajt�sakor egy m�sik "szab�lytalan" sorozat j�n ki. 
# Csup�n annyit rem�lhet�nk, hogy k/n valamilyen hom�lyos �rtelemben 1/2 k�r�l 
# ingadozik (l�v�n az �rme szab�lyos). A t�nylegesen elv�gzett k�s�rletek ezt 
# igazolj�k is (pl. Buffon 4040 dob�sb�l 2048-szor kapott fejet (0,5069 relat�v 
# gyakoris�g), m�g Pearson 24000 dob�sb�l 0,5005 relat�v gyakoris�got kapott). 
# (Fazekas: Val�sz�n�s�gsz�m�t�s �s statisztika)
# Figyelje meg az al�bbi sz�m�t�g�pen szimul�lt 100 hossz�s�g� dob�ssorozat 
# lefoly�s�t: 

ndobas <- 10  # �rmedob�sok sz�ma

erme <- c('F', 'I')   # �rmedob�s szimul�ci�
dobasok <- sample(erme, size = ndobas, replace = TRUE)   #, prob=c(1, 1))
dobasok # ez egy vektor

freqs <- table(dobasok)   # fejek �s �r�sok gyakoris�ga n dob�s eset�n
                          #  table(): excel pivot t�bla megfelel�je
freqs

fejgyak <- cumsum(dobasok == 'F') / 1:ndobas  # fejek �s �r�sok gyakoris�ga minden n-re
              # ez a h�nyados maga a relat�v gyakoris�g

# help a plot funkciora: ?plot
plot(fejgyak,
     type = 'l', lwd = 2, col = 'red',  
     ylim = c(0, 1),
     ylab = "fej dob�sok relativ gyakoris�ga",
     xlab = "dob�sok",
     main = paste(ndobas, "szab�lyos �rme feldob�sa"))
abline(h = 1/2, col = 'blue')




##################################################################################
######################## Diszkr�t val�sz�n�s�gi v�ltoz�k #########################
##################################################################################


##########################
## Binomi�lis eloszl�s: ##
## Binom(n, p)          ##
## �rt�kei: 0,1,2,...,n ##
##########################

# N�gy egyforma �rm�t feldobva a megfigyelhet� kimenetelek: 
# 4 fej,   3 fej �s 1 �r�s,   2 fej �s 2 �r�s,   1 fej �s 3 �r�s,   4 �r�s
# Ezek val�sz�n�sege a 16-elem� esem�nyt�ren kombinatorikus val�sz�n�seggel 
# sz�molva (az �rm�ket k�pzeletben megk�l�nb�ztetve) k�nnyen kisz�molhat�:
# P(4F) = 1/16 = 0,0625
# P(3F �s 1�) = 4/16 = 0,25
# P(2F �s 2�) = 6/16 = 0,375
# P(1F �s 3�) = 4/16 = 0,25
# P(4�r�s)=1/16 = 0,0625

#k kimenetelk, aminek val�sz�n�s�g�t akarjuk kisz�molni (0,1,2,3,4)
dbinom(0:4, size=4, prob=0.5)

dbinom(0, size=20, prob=1/50)

## Bernoulli k�s�rlet ##

# Tfh. a vizsg�lt k�s�rletnek 2 lehets�ges kimenetele van (pl. F �s I),
# bek�vetkez�s�k val�sz�n�s�ge p ill. 1-p. 
# Ezt a k�s�rletet (�rmedob�s) egym�st�l f�ggetlen�l n-szer v�grehajtjuk. Ha csak F gyakoris�g�t 
# figyelj�k (jel�lje ezt X), akkor (n+1)-f�le eredm�nyt kaphatunk, amelynek val�sz�n�s�ge
# P(X = k) = (n alatt k) p^k (1-p)^(n-k), ahol k=0,1,...,n
# => kaptunk egy (n+1)-elem� esem�nyteret a fenti eloszl�ssal: binomi�lis eloszl�s

## P�lda: n = 5, p = 0,3

# P(X = k) = ?, k = 0,1,2,3,4,5
dbinom(0, size=5, prob=0.3)     # ezek �sszege = 1
dbinom(1, size=5, prob=0.3)
dbinom(2, size=5, prob=0.3)
dbinom(3, size=5, prob=0.3)
dbinom(4, size=5, prob=0.3)
dbinom(5, size=5, prob=0.3)

dbinom(0:5, 5, 0.3)

plot(0:5, dbinom(0:5, 5, 0.3), 
     type = "h", col = 2, lwd = 3,
     xlab = "�rt�k", 
     ylab = "Val�sz�n�s�g", 
     main = paste("Binomi�lis eloszl�s (n = 5, p = 0,3)"))
abline(h = 0, col = 3)

barplot(dbinom(0:5, 5, 0.3), 
        col="red",
        xlab="�rt�k",
        ylab="Val�sz�n�s�g",
        main="Binomi�lis eloszl�s (n = 5, p = 0,3)",
        names.arg = 0:5)

# P(2 < X < 5) = P(3 <= X <= 4) = ?
sum(dbinom(3:4, 5, 0.3))

# P(X <= k) = ?, k = 0,1,2,3,4,5
pbinom(0, size=5, prob=0.3)   # = dbinom(0, size=5, prob=0.3)
pbinom(1, size=5, prob=0.3)   # = dbinom(0, size=5, prob=0.3) + dbinom(1, size=5, prob=0.3)
pbinom(2, size=5, prob=0.3)   
pbinom(3, size=5, prob=0.3)   
pbinom(4, size=5, prob=0.3)   
pbinom(5, size=5, prob=0.3)   # = 1

pbinom(0:5, 5, 0.3)

plot(0:5, pbinom(0:5, 5, 0.3), 
     type = "s", col = 2, lwd = 3,
     xlab = "�rt�k", ylim = c(0, 1),
     ylab = "Kumul�lt val�sz�n�s�g", 
     main = paste("Binomi�lis eloszl�s (n = 5, p = 0,3)"))
lines(0:5, pbinom(0:5, 5, 0.3), type = "h", col = 2, lwd = 3)
abline(h = 0, col = 3)

barplot(pbinom(0:5, 5, 0.3), 
        col="red",
        xlab="�rt�k",
        ylab="Kumul�lt val�sz�n�s�g",
        main="Binomi�lis eloszl�s (n = 5, p = 0,3)",
        names.arg = 0:5)

# Gener�ljunk binomi�lis (n = 5, p = 0,3) eloszl�sb�l 10 �rt�ket:
rbinom(10, 5, 0.3)

# P�lda: n, p
n = 200
p = 0.3
barplot(dbinom(0:n, n, p), 
        col="red",
        xlab="�rt�k",
        ylab="Val�sz�n�s�g",
        main= paste("Binomi�lis eloszl�s ( n = ", n,", p =", p, ")"),
        names.arg = 0:n)
abline(h = 0, col = 3)


## Speci�lis eset: n = 1
##########################
## Indik�tor eloszl�s:  ##
##########################
# bin�ris esem�nyek jellemz�s�re 
# k�s�rlet: �rmedob�s, fejek ill. �r�sok val�sz�n�s�ge
# P(X = 1) = p, P(X = 0) = 1 - p 


#pl.: van egy adott m�ret� pocsoly�nk, adott id� alatt h�ny csepp esik bele

##########################
## Poisson eloszl�s:    ##
## Poisson(lambda)      ##
## �rt�kei: 0,1,2,...   ##
##########################
lambda = 1
vmeddig = 10

# P(X = k) = ?, k = 0,1.... (most csak vmeddig-ig)
barplot(dpois(0:vmeddig,lambda),
        col="blue",
        xlab="�rt�k",
        ylab="Val�sz�n�s�g",
        main="Poisson eloszl�s",
        names.arg=0:vmeddig)

#######################################
## Binomi�lis k�zel�t�se Poissonnal: ##
## (ha n el�g nagy)                  ##
#######################################
vmeddig = 10
lambda = 2
n = 100
p = lambda/n

vszbin = dbinom(0:vmeddig, n, p)
vszpoi = dpois(0:vmeddig, lambda)

egyutt = rbind(vszbin[1:(vmeddig+1)],vszpoi)
rownames(egyutt)=c("Binomi�lis","Poisson")

barplot(egyutt, 
        col = c("red","blue"),
        xlab = "�rt�k",
        ylab = "Val�sz�n�s�g",
        main = "Binomi�lis vs Poisson eloszl�s",
        legend = rownames(egyutt), 
        beside = TRUE,
        names.arg = 0:vmeddig)

###############################
## Hipergeometriai eloszl�s: ##
## Hipergeometriai(M, N, n)  ##
## �rt�kei: 0,1,2,....n      ##
###############################
N = 30
M = 25
n = 10

dhyper(0:n, M, N-M, n)

barplot(dhyper(0:n, M, N-M, n),
        col = "green",
        xlab = "�rt�k",
        ylab = "Val�sz�n�s�g",
        main = "Hipergeometriai eloszl�s",
        names.arg = 0:n)

#k�sz�ts�nk az el�z� �br�hoz hasonl�t, ahol a binomi�list
#�s a hipergeometriait hasonl�tjuk �ssze

##################################################################################
################################### FELADATOK ####################################
##################################################################################


1. ### T�bl�s gyakorlat 1.16 Feladat ###

# Tegy�k fel, hogy az �j internet-el�fizet�k v�letlenszer�en v�lasztott 20%-a 
# speci�lis kedvezm�nyt kap. Mi a val�sz�n�s�ge, hogy 10 ismer�s�nk k�z�l, 
# akik most fizettek el�, legal�bb n�gyen r�szes�lnek a kedvezm�nyben?

n = 10
p = 0.2


# X ~ Binom(n = 10, p = 0.20), P( X >= 4 ) = ?


########## MEGOLD�S ##########
sum(dbinom(4:n, n, p))

# vagy

1-pbinom(3, n, p)
##############################



# 2. 
# Egy b�kk�sben a b�kkmagoncok n�gyzetm�terenk�nti sz�ma Poisson-eloszl�s�, 
# lambda = 2,5 db / m^2 param�terrel.
# Mi a val�sz�n�s�ge annak, hogy egy 1 m^2-es mint�ban
# a) legfeljebb egy ill.
# b) t�bb, mint h�rom magoncot tal�lunk?

# X ~ Poisson(lambda=2.5)
lambda = 2.5

# a)

########## MEGOLD�S ##########
sum(dpois(0:1, lambda))

# vagy

ppois(1, lambda)
##############################

# b)

########## MEGOLD�S ##########
1 - sum(dpois(0:3, lambda))

dpois(0:10, lambda)

# vagy

1 - ppois(3, lambda)
##############################



##########################################
###   2. Laboros gyakorlat (3-4. h�t)   ###
##########################################

###########################################
# Nevezetes abszol�t folytonos eloszl�sok #
###########################################
##################################################################################
################## Abszol�t folytonos val�sz�n�s�gi v�ltoz�k #####################
##################################################################################

# P�lda: egyenletes eloszl�s
# V�letlenszer�en kiv�lasztunk egy pontot az [a,b] intervallumb�l.
# Annak a val�sz�n�s�ge, hogy a kiv�lasztott pont az E r�sze [a,b] halmazba esik:
# P(E) = E hossza / [a, b] hossza       (ha az E halmaznak van hossza)
# 
# A val�sz�n�s�geloszl�s jellemezhet� az f: R -> R, D(f) = R,
# f(x) = 1/(b-a), ha x eleme [a,b] �s  
#         0,      ha x nem eleme [a,b]
# f�ggv�nnyel �gy, hogy P(E) = integral f (az E halmazon).
#
# Vagyis ha egy v�ges intervallumra �gy dobunk egy pontot, hogy az intervallum b�rmely 
# r�szintervallum�ra annak hossz�val ar�nyos val�sz�n�s�ggel essen, akkor a pont 
# �rt�ke (x-koordin�t�ja) egyenletes eloszl�s� val�sz�n�s�gi v�ltoz�, 
# s�r�s�gf�ggv�nye a fenti f, eloszl�sf�ggv�nye:
# F(x) =  0,          ha x<a
#        (x-a)/(b-a), ha x eleme [a,b] 
#         1,          ha x>b


# Abszol�t folytonos val�sz�n�s�gi v�ltoz�: 
#
# Ha l�tezik olyan f(x) f�ggv�ny, amelyre F(x) = integr�l_{-Inf to x} f(t) dt.
# Ilyenkor f(x)-et s�r�s�gf�ggv�nynek h�vjuk. 



#############################################################################
### Abszol�t folytonos val�sz�n�s�gi v�ltoz�k eset�n az eloszl�sf�ggv�ny: ###

# p bet� + val�sz�n�s�gi v�ltoz� neve, pl. pnorm, punif, pt, ...

############################################################################# 

##########################
## Egyenletes eloszl�s: ##
## Egyenletes[a,b]      ##
##########################

# Egyenletes[1,6] eloszl�sf�ggv�nye
xegyen <- seq(0, 7, by = 1)
yegyen <- punif(xegyen, min = 1, max = 6)
plot(yegyen, type = "l", lwd=2, col="red", xaxt = "n",
     xlab="x", ylab="F(x)",
     main="Egyenletes[1,6] eloszl�sf�ggv�nye")
axis(1, at=1:8, labels=c(0:7))
abline(h = 0, col = "grey", lty = 2); abline(h = 1, col = "grey", lty = 2)

# Egyenletes[1,6] s�r�s�gf�ggv�nye
x <- seq(0,7,length=200)
y <- dunif(x,min=1,max=6)
plot(x,y,
     lwd=2, col="blue",
     ylim=c(0, 0.4),
     ylab="f(x)",
     main="Egyenletes[1,6] s�r�s�gf�ggv�nye")

# Egyenletes[1,6] s�r�s�gf�ggv�nye (szebb grafika)
x <- seq(1,6,length=200)
y <- dunif(x,min=1,max=6)
plot(x,y, type="l", lwd=2, col="blue",
     xlim=c(0, 7), ylim=c(0, 0.4),
     ylab="f(x)",
     main="Egyenletes[1,6] s�r�s�gf�ggv�nye")
xe <- c(seq(0,1,length=100))
ye <- seq(0,0,length=100)
lines(xe,ye,type="l",lwd=2,col="blue")
xe <- c(seq(6,7,length=100))
ye <- seq(0,0,length=100)
lines(xe,ye,type="l",lwd=2,col="blue")

# fv. alatti ter�let = 1
polygon(c(1,x,6),c(0,y,0),col="lightgray",border=NA)
lines(x,y,type="l",lwd=2,col="blue")

# P(1 < X < 3) = ?
polygon(c(1,x,6),c(0,y,0),col="white",border=NA)
lines(x,y,type="l",lwd=2,col="blue")
xvsz <- seq(1,3,length=100)
yvsz <- dunif(xvsz, min=1, max=6)
polygon(c(1,xvsz,3),c(0,yvsz,0),col="lightgray",border=NA)
lines(xvsz,yvsz,type="l",lwd=2,col="blue")

punif(3,  min=1,max=6)

# P(3 < X < 4.5) = ?
polygon(c(1,xvsz,3),c(0,yvsz,0),col="white",border=NA)
lines(x,y,type="l",lwd=2,col="blue")
xvsz <- seq(3,4.5,length=100)
yvsz <- dunif(xvsz,min=1, max=6)
polygon(c(3,xvsz,4.5),c(0,yvsz,0),col="lightgray",border=NA)
lines(x,y,type="l",lwd=2,col="blue")

punif(4.5,  min=1,max=6) - punif(3, min=1, max=6)


#############################
## Exponenci�lis eloszl�s: ##
## Exp(lambda)             ##
#############################
# lambda>0 param�ter� exponenci�lis eloszl�s
# s�r�s�gf�ggv�nye: f(x) = lambda*e^{-lambda*x} ha x > 0 �s
#                           0       k�l�nben
# pl. radioakt�v r�szecske boml�si ideje, �lettarmtam, v�rakoz�si id�
?pexp


##########################
## Norm�lis eloszl�s:   ##
## N(mu, szigma)        ##
##########################
# m v�rhat� �rt�k�, szigma sz�r�s� norm�lis eloszl�s
# s�r�s�gf�ggv�nye: f(x) = 1/(sqrt(2Pi)*szigma) e^(-(x-mu)^2/2*szigma^2)
# Pl. testm�rt�kek, term�shozam, IQ score
# https://en.wikipedia.org/wiki/Intelligence_quotient
# 0 v�rhat� �rt�k�, szigma=1 sz�r�s� norm�lis eloszl�s = standard norm�lis eloszl�s,
# eloszl�sf�ggv�nye Fi(x) = integr�l_(-Inf to x) f(x)  nem elemi fv.

# 3.  # set.seed(2)
xseq <- seq(-4,4, 0.01)

# a) �br�zolja a standard norm�ls eloszl�sf�ggv�ny�tgv�ny�t!
# X ~ N(0, 1) eloszl�sf�ggv�nye: Fi(x) = P(X < x) = pnorm(x)

plot(xseq, pnorm(xseq, 0, 1), col="red", type="l",lwd=2,
     xlab="x", ylab="Fi(x)", 
     main="Standard norm�lis eloszl�sf�ggv�nye\n (�rt�ke pl. 1-ben: Fi(1) = P(X < 1) =\n pnorm(1) = 0.8413447)")
abline(h = c(0,1), lty = 2)

abline(v = 1, lty = 3)
abline(h = pnorm(1), lty = 3)



# b) �br�zolja a standard norm�ls s�r�s�gf�ggv�ny�t!

suruseg <- dnorm(xseq, 0,1)
plot(xseq, suruseg, type="l",lwd=2, col="blue", # cex.axis=0.8,
     xlab="x", ylab="f(x)",  
     main="Standard norm�lis s�r�s�gf�ggv�nye")

# c) Norm�lis(mu, szigma) eloszl�s s�r�s�gf�ggv�nye

x <- seq(-6,6,1/1000)
dnorm <- dnorm(x)

plot(x, dnorm, type="l", col="green", lwd=2, ylab='', xlab='', 
     main = "Norm�lis eloszl�s s�r�s�gf�ggv�nye")
legend(x='topleft', bty='n', 
       legend = c("N(0,1)", "N(2,1)", "N(0,2)", "N(0,3)"),
       col = c("green","yellow", "blue","red"), lwd = 2 )

lines(x, dnorm, type="l", col="black", lty=2)

dn2 <- dnorm(x, mean = 2, sd = 1)
lines(x, dn2, type="l", col="yellow", lwd=2)

dn3 <- dnorm(x, mean = 0, sd = 2)
lines(x, dn3, type="l", col="blue", lwd=2)

dn4 <- dnorm(x, mean = 0, sd = 3)
lines(x, dn4,type="l", col="red", lwd=2)


# d) Szinuml�ljon adatokat standard norm�lis eloszl�sb�l, majd �br�zolja hisztogrammal.
# Rajzolja fel a standard norm�lis s�r�s�gf�ggv�nyt is az �br�ra!

szim <- rnorm(10000, 0, 1)
hist(szim, freq=FALSE,
     xlab=" ", 
     ylab="s�r�s�g", 
     main="Standard norm�lis szimul�ci�")
curve(dnorm(x, 0, 1), add=TRUE, col="blue", lwd=2)
# curve(dnorm(x, mean(szim), sd(szim)), add=TRUE, col="darkblue", lwd=2)


##

## Egyenletes eloszl�s / Egyenletes[a, b] /

x <- seq(1,6,length=200)
y <- dunif(x,min=1,max=6)
plot(x,y, type="l", lwd=2, col="blue",
     xlim=c(0, 7), ylim=c(0, 0.4),
     ylab="f(x)",
     main="Egyenletes[1,6] s�r�s�gf�ggv�nye")
xe <- c(seq(0,1,length=100))
ye <- seq(0,0,length=100)
lines(xe,ye,type="l",lwd=2,col="blue")
xe <- c(seq(6,7,length=100))
ye <- seq(0,0,length=100)
lines(xe,ye,type="l",lwd=2,col="blue")

polygon(c(1,x,6),c(0,y,0),col="white",border=NA)
lines(x,y,type="l",lwd=2,col="blue")
xvsz <- seq(1,3,length=100)
yvsz <- dunif(xvsz, min=1, max=6)
polygon(c(1,xvsz,3),c(0,yvsz,0),col="lightgray",border=NA)
lines(xvsz,yvsz,type="l",lwd=2,col="blue")


## Stadard norm�lis eloszl�s / N(0, 1) /

xseq <- seq(-4,4, 0.01)
plot(xseq, dnorm(xseq, 0,1), 
     type = "l",
     lwd = 2, 
     col = "blue", 
     #cex.axis = 0.8,
     xlab = "x", 
     ylab = "f(x)",  
     main = "Standard norm�lis s�r�s�gf�ggv�nye")
text(-2.5, 0.3, expression(f(x) == 
                             paste(frac(1, sqrt(2*pi)*sigma)," ",e^{frac(-(x - mu)^2, 2 * sigma^2)})), 
     cex = 1.2)
# curve(dnorm, from=-4, to=4, n=41000, main="Standard norm�lis s�r�s�gf�ggv�nye")


## Norm�lis eloszl�s / N(m, szigma) /

x <- seq(-6,6,1/1000)

plot(x, dnorm(x), type="l", col="yellow", lwd=2, ylab='', xlab='', 
     main = "Norm�lis eloszl�s s�r�s�gf�ggv�nye")
lines(x, dnorm(x), type="l", col="black", lty=2)    # N(m = 0, szigma = 1)

dn2 <- dnorm(x, mean = 2, sd = 1)
lines(x, dn2, type="l", col="purple", lwd=2)     # N(m = 2, szigma = 1)

dn3 <- dnorm(x, mean = 0, sd = 2)
lines(x, dn3, type="l", col="blue", lwd=2)       # N(m = 0, szigma = 2)

dn4 <- dnorm(x, mean = 0, sd = 3)
lines(x, dn4,type="l", col="red", lwd=2)         # N(m = 0, szigma = 3)

legend(x='topleft',bty='n',
       legend = c(paste( 
         c("N(0, 1)","N(2, 1)", "N(0, 2^2)","N(0, 3^2)"), sep='=')), 
       col = c("yellow", "purple", "blue", "red"), lwd = 2 )


## Norm�lis val�sz�n�s�gi v�ltoz� standardiz�l�sa
# X ~ N(m, szigma)  =>  (X - m)/szigma ~ N(0, 1)
x <- rnorm(1000, mean = 5, sd = 3)
hist(x, freq=FALSE)
curve(dnorm(x, 5, 3), add=TRUE, col="blue", lwd=2)

nx <- ( x - 5 ) / 3
hist(nx, freq=FALSE)
curve(dnorm(x, 0, 1), add=TRUE, col="blue", lwd=2)

# P�lda:
# X ~ N(3,2^2)
# P(X < 4) = P(X-3 < 4-3) = P((x-3)/2 < (4-3)/2)
pnorm(4, mean = 3, sd = 2) == pnorm(1/2)

# 1. Feladat:  Legyen X ~ N(7, 3^2) val�sz�n�s�gi v�ltoz�.  Sz�molja ki 
# P(X > 8) - at standardiz�l�ssal is!

1 - pnorm(8, mean = 7, sd = 3)
# vagy   
pnorm(8, mean = 7, sd = 3, lower.tail = FALSE)

1 - pnorm((8-7)/3)
# vagy   
pnorm((8-7)/3, lower.tail = FALSE)


## F�ggv�ny alatti ter�let: 
x <- seq(-4, 4,length=200)
y <- dnorm(x, mean=0, sd=1)
plot(x,y,type="l",lwd=3,col="black", 
     main = "Standard norm�lis")
x <- seq(-4, -1, length=100)
y <- dnorm(x, mean=0, sd=1)
polygon(c(-4, x, -1),c(0,y,0),col="red")


## t eloszl�s / t_n / 

x <- seq(-6,6,1/1000)

dt4 <- dt(x, 30)
plot(x, dt4, type="l", col="yellow", lwd=2, ylab='', xlab='', 
     main = "t eloszl�s s�r�s�gf�ggv�nye")

dt1 <- dt(x, 0.5)
lines(x, dt1, type="l", col="cyan", lwd=2)

dt2 <- dt(x, 1.5)
lines(x, dt2, type="l", col="purple", lwd=2)

dt3 <- dt(x, 5)
lines(x, dt3, type="l", col="red", lwd=2)

dnorm <- dnorm(x)
lines(x, dnorm ,type="l", col="black", lty=2)

legend(x='topleft',bty='n',
       legend = c(paste('sz.f.',
                        c(0.5, 1.5, 5, 30), sep='=')), 
       col = c("cyan", "purple", "red", "yellow"), lwd = 2 )

legend(x='topright',bty='n',
       legend = c(paste('N(0,1)', sep='=')), 
       col = c("black"), lwd = 2, lty = 3)


## Exponenci�lis / Exp(lambda) / eloszl�s

x <- seq(0, 1, 1/1000)

dt1 <-  dexp(x, rate = 2.5)
plot(x, dt1, type="l", col="red", lwd=2, ylab='', xlab='', 
     main = "Exponenci�lis eloszl�s s�r�s�gf�ggv�nye")

dt2 <-  dexp(x, rate = 2)
lines(x, dt2, type="l", col="purple", lwd=2)

dt3 <-  dexp(x, rate = 1)
lines(x, dt3, type="l", col="blue", lwd=2)

de4 <- dexp(x, rate = 1/2)
lines(x, de4, type="l", col="orange", lwd=2)

legend(x='topright',bty='n',
       legend = c(paste('lambda', c(2.5, 2, 1, 1/2),sep='=')), 
       col = c("red", "purple", "blue", "orange"), lwd = 2 )


## Kh�-n�gyzet / Chi-square(df) / eloszl�s 

x <- seq(0, 15, 1/1000)

dchisq1 <-  dchisq(x, df = 2)
plot(x, dchisq1, type="l", col="red", lwd=2, ylab='', xlab='', 
     main = "Kh�-n�gyzet eloszl�s s�r�s�gf�ggv�nye")

dchisq2 <-  dchisq(x, df = 3)
lines(x, dchisq2, type="l", col="purple", lwd=2)

dchisq3 <-  dchisq(x, df = 4)
lines(x, dchisq3, type="l", col="blue", lwd=2)

dchisq4 <-  dchisq(x, df = 5)
lines(x, dchisq4, type="l", col="orange", lwd=2)

legend(x='topright',bty='n',
       legend = c(paste('df', c(2, 3, 4, 5),sep='=')), 
       col = c("red", "purple", "blue", "orange"), lwd = 2 )


## F / F(df1,df2) / eloszl�s 

x <- seq(0, 5, 1/1000)

df1 <-  df(x, df1 = 2, df2=1)
plot(x, df1, type="l", col="red", lwd=2, ylab='', xlab='', 
     main = "F eloszl�s s�r�s�gf�ggv�nye")

df2 <-  df(x, df1 = 5, df2=2)
lines(x, df2, type="l", col="purple", lwd=2)

df3 <-  df(x, df1 = 5, df2=5)
lines(x, df3, type="l", col="blue", lwd=2)

df4 <-  df(x, df1 = 20, df2=20)
lines(x, df4, type="l", col="orange", lwd=2)

legend(x='topright',bty='n',
       legend = c(paste('df1, df2', c("2, 1", "5, 2", "5, 5", "20, 20"),sep=' = ')), 
       col = c("red", "purple", "blue", "orange"), lwd = 2 )



## Nevezetes abszol�t folytonos eloszl�sf�ggv�nyek

par(mfrow=c(2,2))
x_sample <- seq(-3.2, 3.2, 0.001)

plot(x_sample, pnorm(x_sample), 
     type="l", col="red", lwd=2, main="Eloszl�sf�ggv�ny: N(0,1)", ylab='', xlab='')
plot(x_sample, pt(x_sample, 5),
     type="l", col="red", lwd=2, main="t_5", ylab='', xlab='')
plot(x_sample, pexp(x_sample, 5),
     type="l", col="red", lwd=2, main="Exp(5)", ylab='', xlab='')
plot(x_sample, punif(x_sample, -2,2),
     type="l", col="red", lwd=2, main="Egyenletes[-2,2]", ylab='', xlab='')
par(mfrow=c(1,1))


## Nevezetes abszol�t folytonos s�r�s�gf�ggv�nyek

par(mfrow=c(2,2))
x_sample <- seq(-3.2, 3.2, 0.001)

plot(x_sample, dnorm(x_sample), 
     type="l", col="blue", lwd=2, main="S�r�s�gf�ggv�ny: N(0,1)", ylab='', xlab='')

plot(x_sample, dt(x_sample, 5),
     type="l", col="blue", lwd=2, main="t_5", ylab='', xlab='')

x_sample <- c(seq(0.01,1.5, 0.001))
plot(x_sample, dexp(x_sample, 5), xlim=c(-0.5, 1.5),
     type="l", col="blue", lwd=2, main="Exp(5)", ylab='', xlab='')
xe <- c(seq(-3,0,length=100))
ye <- seq(0,0,length=100)
lines(xe,ye,type="l",lwd=2,col="blue")

x <- seq(1,6,length=200)
y <- dunif(x,min=1,max=6)
plot(x,y, type="l", lwd=2, col="blue", main="Egyenletes[1,6]",
     xlim=c(0, 7), ylim=c(0, 0.4), ylab='', xlab='')
xe <- c(seq(0,1,length=100))
ye <- seq(0,0,length=100)
lines(xe,ye,type="l",lwd=2,col="blue")
xe <- c(seq(6,7,length=100))
ye <- seq(0,0,length=100)
lines(xe,ye,type="l",lwd=2,col="blue")
par(mfrow=c(1,1))


# 2. Feladat: Mit rajzol ki az al�bbi program? MUtassa meg, hogy az al�bbi f�ggv�ny s�r�s�gf�ggv�ny!
# Mit jel�l a besat�rozott ter�let? Sz�molja ki �s �br�zolja az eloszl�sf�ggv�nyt!

x <- seq(0, 2, 1/100);  y <- 1/4*(2-x)^3 

xa <- seq(-1, 0, 1/100);  ya <- rep(0,length(xa))
xb <- seq( 2, 3, 1/100);  yb <- rep(0,length(xb))

plot(x, y, type="l", col="black", lwd=3, ylab='', xlab='', xlim=c(-0.5,2.5), xaxt = "n", main = " ")
axis(1, cex.axis = 1.5)
lines(xb, yb, type="l", col="black", lwd=3)
lines(xa, ya, type="l", col="black", lwd=3)
abline(h = 0, lty = 2)
x1 <- seq(0, 0.5, 1/100)
y1 <- 1/4*(2-x1)^3
polygon(c(0,x1,0.5),c(0,y1,0),col="yellow")


########## MEGOLD�S ##########

# s�r�s�gfv: nemnegat�v �s integr�l_{0-t�l 3-ig} 1/4*(2-x)^3 = 1
# besat�rozott ter�let: P(0 < X < 0.5)
# eloszl�sfv: 0, ha x<=0; 
#             integr�l_{0-t�l x-ig}  1/4*(2-x)^3 = 1-(2-x)^4/16, ha 0<x<=2
#             1, ha x>2

x <- seq(0, 2, 1/100);  y <- 1-(2-x)^4/16 

xa <- seq(-1, 0, 1/100);  ya <- rep(0,length(xa))
xb <- seq( 2, 3, 1/100);  yb <- rep(1,length(xb))

plot(x, y, type="l", col="black", lwd=3, ylab='', xlab='', xlim=c(-0.5,2.5), xaxt = "n", main = " ")
axis(1, cex.axis = 1.5)
lines(xb, yb, type="l", col="black", lwd=3)
lines(xa, ya, type="l", col="black", lwd=3)
abline(h = 0, lty = 2)

##############################



########################
# Nagy sz�mok t�rv�nye #
########################


##############
# Kockadob�s #
##############
kocka <- 1:6
n <- 1000   # mintanagys�g: dob�sok sz�ma

dobasok <- sample(kocka, size = n, replace = TRUE)
atlagok <- cumsum(dobasok) / 1:n
plot(atlagok, 
     xlab = "kockadob�sok sz�ma", 
     ylab = "�tlag",
     ylim = c(1,6),
     type = "l",
     main = paste("Szimul�lt kockadob�sok �tlaga (", n, "dob�sig )"))
abline(h = 3.5, col = "blue")


##################################
# Binomi�lis elosz�s: Bin(n1, p) #
##################################
n1 <- 8
p <- 0.3
n <- 1000

x <- rbinom(n, n1, p)
atlagok <- cumsum(x) / 1:n
plot(atlagok,
     xlab = "k�s�rletek sz�ma", 
     ylab = "�tlagok",
     #ylim = c(0, 1),
     type = "l",
     main = paste("Szimul�lt binomi�lis ( Bin(",n1,",",p,") ) �tlaga"))
abline(h = n1*p, col = "blue")


###################################
# Norm�lis elosz�s: N(mu, szigma) #
###################################
mu <- 46
szigma <- 2
n <- 1000

x <- rnorm(n, mu, szigma)
atlagok <- cumsum(x) / 1:n
plot(atlagok,
     xlab = "k�s�rletek sz�ma", 
     ylab = "�tlagok",
     #ylim = c(mu-2*szigma, mu+2*szigma),
     type = "l",
     main = paste("Szimul�lt norm�lis ( N(",mu,",",szigma,"^2) ) �tlaga"))
abline(h = mu, col = "blue")

# plot(x, pch = ".")
# points(1:n, atlagok, type = "l", col = "red")



#################################
# Centr�lis hat�reloszl�s t�tel #
#################################

##############
# Kockadob�s #
##############

# CHT alapj�n n kockadob�s �tlag�nak eloszl�sa:
n <- 100
x1 <- seq(1,6,0.001)
plot(x1,dnorm(x1,mean=3.5,sd=1.707825/sqrt(n)),
     type='l', col="red", lwd=2, ylab="", xlab="",
     main='n kockadob�s �tlag�nak eloszl�sa a CHT alapj�n')
lines(x1, dnorm(x1,mean=3.5,sd=1.707825/sqrt(5)), type="l", col="green", lwd=2)
lines(x1, dnorm(x1,mean=3.5,sd=1.707825/sqrt(10)), type="l", col="yellow", lwd=2)
lines(x1, dnorm(x1,mean=3.5,sd=1.707825/sqrt(30)), type="l", col="orange", lwd=2)
legend(x='topleft',bty='n',
       legend = c(paste(c("n = 5","n = 10", "n = 30","n = 100"), sep='=')), 
       col = c("green", "yellow", "orange", "red"), lwd = 2 )

# szimu�ci�:
x <- 1:6
ndobas <- 30   # dob�sok sz�ma
rep <- 1000    # ism�tl�sek sz�ma

A <- matrix(sample(x, ndobas*rep, replace=T), ncol=ndobas, byrow=TRUE)
xbar<-apply(A,1,mean)   # ndobas �tlaga   

head(cbind(A,xbar))
tail(cbind(A,xbar))

hist(xbar, col="blue", freq=F, xlab="", ylab="s�r�s�g", 
     ylim=range(0,max(hist(xbar)$density, dnorm(x1,mean=3.5,sd=1.707825/sqrt(ndobas)))),
     main = paste(ndobas, "kockadob�s �tlaga (", rep, "- szer szimul�lva )"))
lines(x1, dnorm(x1,mean=3.5,sd=1.707825/sqrt(ndobas)), type="l", col="orange", lwd=2)


par(mfrow=c(2,2)) 
hist(apply(matrix(sample(x, 5*rep, replace=T), ncol=5, byrow=T),1,mean), 
     col="blue", freq=F, xlim=c(1,6), xlab="", ylab="s�r�s�g",
     main = "5 kockadob�s �tlaga")
lines(x1, dnorm(x1,mean=3.5,sd=1.707825/sqrt(5)), type="l", col="green", lwd=2)

hist(apply(matrix(sample(x, 10*rep, replace=T), ncol=10, byrow=T),1,mean), 
     col="blue", freq=F, xlim=c(1,6), xlab="", ylab="s�r�s�g",
     main = "10 kockadob�s �tlaga")
lines(x1, dnorm(x1,mean=3.5,sd=1.707825/sqrt(10)), type="l", col="yellow", lwd=2)

hist(apply(matrix(sample(x, 30*rep, replace=T), ncol=30, byrow=T),1,mean), 
     col="blue", freq=F, xlim=c(1,6), xlab="", ylab="s�r�s�g",
     main = "30 kockadob�s �tlaga")
lines(x1, dnorm(x1,mean=3.5,sd=1.707825/sqrt(30)), type="l", col="orange", lwd=2)

hist(apply(matrix(sample(x, 100*rep, replace=T), ncol=100, byrow=T),1,mean), 
     col="blue", freq=F, xlim=c(1,6), xlab="", ylab="s�r�s�g",
     main = "100 kockadob�s �tlaga")
lines(x1, dnorm(x1,mean=3.5,sd=1.707825/sqrt(100)), type="l", col="red", lwd=2)
par(mfrow=c(1,1)) 

##################################################################################
################################### FELADATOK ####################################
##################################################################################

# 4) 
# a) Legyen Z ~ N(0, 1).

# P(Z < 1.645) = ?
pnorm(1.645)

# P(Z < z) = 0,95, z = ?
qnorm(0.95)

# P(Z < -1.645) = ?
pnorm(-1.645)

# P(Z < z) = 0,05, z = ?
qnorm(0.05)

# P(Z > 1,96) = ?
1-pnorm(1.96)
pnorm(1.96, lower.tail = FALSE)

# b) Legyen X ~ N(25, 3^2).

# P(X < 33) = ?
pnorm(33, mean = 25, sd = 3)

# P(X < x) = 0,95, x = ?
qnorm(0.95, mean = 25, sd = 3)

# P(X < 21) = ?
pnorm(21, mean = 25, sd = 3)

# P(X < x) = 0,05, x = ?
qnorm(0.05, mean = 25, sd = 3)

# P(X > 22) = ?
1-pnorm(22, mean = 25, sd = 3)
pnorm(22, mean = 25, sd = 3, lower.tail = FALSE)

# P(23 < X < 25) = ?
pnorm(25, mean = 25, sd = 3) - pnorm(23, mean = 25, sd = 3)


# 5. ### T�bl�s gyakorlat 3.8 a) Feladat ###
# Egy teh�n napi tejhozam�t norm�lis elosz�s� val�sz�n�s�gi v�ltoz�val, 
# m = 22,1 liter v�rhat� �rt�kkel �s szigma = 1,5 liter sz�r�ssal modellezz�k.
# Mi annak a val�sz�n�s�ge, hogy egy adott napon a tejhozam 23 �s 25 liter k�z� esik?

########## MEGOLD�S ##########
pnorm(25, mean = 22.1, sd = 1.5) - pnorm(23, mean = 22.1, sd = 1.5)
##############################


# 6. ### T�bl�s gyakorlat 3.10 Feladat ###
# Tegy�k fel, hogy egy popul�ci�ban az intelligenciah�nyados (IQ) norm�lis eloszl�s� 
# 110 v�rhat� �rt�kkel �s 10 sz�r�ssal. Mi a val�sz�n�s�ge, hogy egy v�letlenszer�en 
# kiv�lasztott ember IQ-ja 120 feletti?

########## MEGOLD�S ##########
1-pnorm(120, mean = 110, sd = 10)

# vagy

pnorm(120, mean = 110, sd = 10, lower.tail = FALSE)
##############################


# 7. ### T�bl�s gyakorlat 3.9 Feladat ###
# Mennyi garanci�t adjunk, ha azt szeretn�nk, hogy term�keink legfeljebb 10%-�t kelljen 
# garanciaid�n bel�l jav�tani, ha a k�sz�l�k �lettartama 10 �v v�rhat� �rt�k� �s 
# 2 �v sz�r�s� norm�lis eloszl�ssal k�zel�thet�.

########## MEGOLD�S ##########
qnorm(0.1, mean = 10, sd = 2)
##############################



# 8. Magyarorsz�gon 2017 tavasz�n a 16 �ves �s id�sebb n�pess�gen bel�l a f�rfiak 
# �tlagos magass�ga 176 cm, 9 cm sz�r�ssal.

# a) Mennyi annak a val�sz�n�s�ge, hogy egy v�letlenszer�en kiv�lasztott f�rfi 
# testmagass�ga 165 �s 185 cm k�z� esik?
########## MEGOLD�S ##########
pnorm(185, mean = 176, sd = 9) - pnorm(165, mean = 176, sd = 9)
##############################

# b) Mennyi a val�sz�n�s�ge, hogy egy f�rfi magasabb 2 m�tern�l?
########## MEGOLD�S ##########
1 - pnorm(200, mean = 176, sd = 9)
##############################

# c) H�ny cm-es testmagass�g alatt van a f�rfiak 90%-a? 
########## MEGOLD�S ##########
round(qnorm(0.9, mean = 176, sd = 9), 1)
##############################

# d) Mekkora testmagass�g felett van a f�rfiak 80%-a?
########## MEGOLD�S ##########
round(qnorm(0.2, mean = 176, sd = 9), 1)
##############################


# 9. ### T�bl�s gyakorlat 3.7 Feladat ###
# Tapasztalatok szerint az �t hossza, amit egy bizonyos t�pus� robog� megtesz az els�
# meghib�sod�s�ig exponenci�lis eloszl�s� val�sz�n�s�gi v�ltoz�. Ez a t�vols�g 
# �tlagosan 6000 km. Mi a val�sz�n�s�ge annak, hogy egy v�letlenszer�en
# kiv�lasztott robog�

# a) kevesebb, mint 4000 km megt�tele ut�n meghib�sodik?
########## MEGOLD�S ##########
pexp(4000, rate = 1/6000) 
##############################

# b) t�bb, mint 6500 km megt�tele ut�n hib�sodik meg?
########## MEGOLD�S ##########
1 - pexp(6500, rate = 1/6000) 
##############################

# c) 4000 km-n�l t�bb, de 6000 km-n�l kevesebb �t megt�tele ut�n hib�sodik meg?
########## MEGOLD�S ##########
pexp(6000, rate = 1/6000) - pexp(4000, rate = 1/6000) 
##############################

# d) Legfeljebb mekkora utat tesz meg az elso meghib�sod�sig a robog�k leghamarabb meghib�sod� 20%-a?
########## MEGOLD�S ##########
qexp(0.2, rate = 1/6000)
##############################


##################################
# Binomi�lis elosz�s: Bin(m, p) #
##################################

n <- 100
m <- 10
p <- 0.3
x1 <- seq(0,10,0.001)
plot(x1,dnorm(x1,mean=m*p,sd=sqrt(m*p*(1-p))/sqrt(n)),
     type='l', col="red", lwd=2, ylab="", xlab="",
     main='n Binom(10, 0.3) �tlag�nak eloszl�sa a CHT alapj�n')
lines(x1, dnorm(x1,mean=m*p,sd=sqrt(m*p*(1-p))/sqrt(5)), type="l", col="green", lwd=2)
lines(x1, dnorm(x1,mean=m*p,sd=sqrt(m*p*(1-p))/sqrt(10)), type="l", col="yellow", lwd=2)
lines(x1, dnorm(x1,mean=m*p,sd=sqrt(m*p*(1-p))/sqrt(30)), type="l", col="orange", lwd=2)
legend(x='topright',bty='n',
       legend = c(paste(c("n = 5","n = 10", "n = 30","n = 100"), sep='=')), 
       col = c("green", "yellow", "orange", "red"), lwd = 2 )

# szimu�ci�:
n <- 30
m <- 10
p <- 0.3
rep <- 1000    # ism�tl�sek sz�ma

A <- matrix(rbinom(n*rep,m,p), ncol=n, byrow=TRUE)
xbar<-apply(A,1,mean)   # n db �tlaga   

head(cbind(A,xbar))
tail(cbind(A,xbar))

hist(xbar, col="blue", freq=F, xlab="", ylab="s�r�s�g", 
     main = paste(n, "Binom(10, 0.3) �tlaga (", rep, "- szer szimul�lva )"))
lines(x1, dnorm(x1,mean=m*p,sd=sqrt(m*p*(1-p))/sqrt(n)), type="l", col="orange", lwd=2)


par(mfrow=c(2,2)) 
hist(apply(matrix(rbinom(n*rep,m,p), ncol=5, byrow=T),1,mean), 
     col="blue", freq=F, xlim=c(1,6), xlab="", ylab="s�r�s�g",
     main = "5 Binom(10, 0.3) �tlaga")
lines(x1, dnorm(x1,mean=m*p,sd=sqrt(m*p*(1-p))/sqrt(5)), type="l", col="green", lwd=2)

hist(apply(matrix(rbinom(n*rep,m,p), ncol=10, byrow=T),1,mean), 
     col="blue", freq=F, xlim=c(1,6), xlab="", ylab="s�r�s�g",
     main = "10 Binom(10, 0.3) �tlaga")
lines(x1, dnorm(x1,mean=m*p,sd=sqrt(m*p*(1-p))/sqrt(10)), type="l", col="yellow", lwd=2)

hist(apply(matrix(rbinom(n*rep,m,p), ncol=30, byrow=T),1,mean), 
     col="blue", freq=F, xlim=c(1,6), xlab="", ylab="s�r�s�g",
     main = "30 Binom(10, 0.3) �tlaga")
lines(x1, dnorm(x1,mean=m*p,sd=sqrt(m*p*(1-p))/sqrt(30)), type="l", col="orange", lwd=2)

hist(apply(matrix(rbinom(n*rep,m,p), ncol=100, byrow=T),1,mean), 
     col="blue", freq=F, xlim=c(1,6), xlab="", ylab="s�r�s�g",
     main = "100 Binom(10, 0.3) �tlaga")
lines(x1, dnorm(x1,mean=m*p,sd=sqrt(m*p*(1-p))/sqrt(100)), type="l", col="red", lwd=2)
par(mfrow=c(1,1)) 




##################################################################################
################  Gyakorl� feladatok (3. t�bl�s gyakorlat ut�nra) ################
##################################################################################

### T�bl�s gyakorlat 3.18 Feladat ###

# Tegy�k fel, hogy egy t�bla csokol�d� t�mege norm�lis eloszl�s� 100g v�rhat� 
# �rt�kkel �s 3g sz�r�ssal. Legal�bb h�ny csokol�d�t csomagoljunk egy dobozba, 
# hogy a dobozban levo t�bl�k �tlagos t�mege legal�bb 0,9 val�sz�n�s�ggel nagyobb
# legyen 99,5 g-n�l, ha felt�telezz�k, hogy az egyes t�bl�k t�mege egym�st�l 
# f�ggetlen? 

# Legyen X = egy t�bla csokol�d� t�mege  ~ N(100, 3^2)

# X_�tlag  ~ N(100, (3/sqrt(n))^2) 
# 0,9 = P(X_�tlag > 99.5) = 1- P(X_�tlag < 99,5) = 1 - P( std. normal < (99,5-100)/(3/sqrt(n) ) = 
# = 1 - Fi(-sqrt(n)/6) = Fi(sqrt(n)/6)) vagyis qnorm(0.9) = sqrt(n)/6

########## MEGOLD�S ##########

ceiling( (qnorm(0.9)*6)^2 )

##############################


### T�bl�s gyakorlat 3.19 Feladat ###

# Egy scannelt k�p �tlagos m�rete 600KB, 100KB sz�r�ssal. Mi a val�sz�n�s�ge, 
# hogy 80 ilyen k�p egy�ttesen 47 �s 48MB k�z�tti t�rhelyet foglal el, ha felt�telezz�k, 
# hogy a k�pek m�rete egym�st�l f�ggetlen?

# Legyen X = egy szkennelt k�p m�rete  ~ N(600, 100^2)

########## MEGOLD�S ##########

nmu <- 80*600
sqrtnszigma <- sqrt(80)*100

pnorm(48000, mean = nmu, sd = sqrtnszigma) - pnorm(47000, mean = nmu, sd = sqrtnszigma) 

##############################


### T�bl�s gyakorlat 3.20 Feladat ###

# Egy szoftver friss�t�s�hez 68 file-t kell install�lni, amik egym�st�l f�ggetlen�l 
# 10mp v�rhat� �rt�k� �s 2mp sz�r�s� ideig t�lt�dnek.
# a) Mi a val�sz�n�s�ge, hogy a teljes friss�t�s lezajlik 12 percen bel�l?
# b) A c�g a k�vetkezo friss�t�sn�l azt �g�ri, hogy az m�r 95% val�sz�n�s�ggel 10
#    percen bel�l bet�lt�dik. H�ny file-b�l �llhat ez a friss�t�s?

# Legyen X = egy f�jl telep�t�si ideje  ~ N(10, 2^2)

# a) P(S_n < 12 perc) = P(S_n < 12*60 mp) = P( std. normal < (720 - n*10)/(sqrt(n)*2) )

########## MEGOLD�S ##########

nmu <- 680
sqrtnszigma <- sqrt(68)*2

pnorm(720, mean = nmu, sd = sqrtnszigma) 

##############################

# b) 0.95 < P(S_n < 600) = P( std. normal < (600-10n)/(2sqrt(n)) )

########## MEGOLD�S ##########

floor( ( ( -2*qnorm(0.95) + sqrt( (2*qnorm(0.95))^2 + 4*10*600 ) ) / (2*10) )^2 )

##############################

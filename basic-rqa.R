library(entropy)
library(qdap)
library(crqa)

plotRP = function(RP) {
  ij = which(RP==1,arr.ind=T)
  plot(ij[,1],ij[,2],cex=.25)
}
library(entropy)
library(qdap)
library(crqa)

# N^2 * RR = sum of squared frequencies * 100
ws = as.character(paste(lapply(1:30,function(x) {
  return(as.character(chr(round(runif(1)*5)+65)))
}),collapse=' ')) # get a string of letters

ngs = ngrams(ws,n=length(unlist(strsplit(ws,' '))))$all
letterFqs = table(unlist(strsplit(ws,' ')))
sumSqFq = sum(letterFqs^2) # sum of squared frequencies of letters

words = unlist(strsplit(ws,' '))
uniqWords = unique(words)
wordSeries = apply(data.frame(words),1,function(x) which(x==uniqWords)) 
res = crqa(wordSeries, wordSeries, 1, 1, 1, .00000001, F, 2, 2, 0, F, F)     

res$RR * length(wordSeries)^2
sumSqFq * 100

# theiler window of 1 changes sampling from co-occurrences
# N^2 * RR = sum(fq * (fq-1)) * 100
sumSqFq = sum(letterFqs * (letterFqs-1)) # sum of squared frequencies of letters
res = crqa(wordSeries, wordSeries, 1, 1, 1, .00000001, F, 2, 2, 1, F, F)     
res$RR * length(wordSeries)^2
sumSqFq * 100



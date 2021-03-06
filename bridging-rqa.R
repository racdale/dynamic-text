library(entropy)
library(qdap)
library(crqa)

#http://datadebrief.blogspot.com/2011/03/ascii-code-table-in-r.html
asc <- function(x) { strtoi(charToRaw(x),16L) }
chr <- function(n) { rawToChar(as.raw(n)) }

# N^2 * RR = sum of squared frequencies * 100
ws = as.character(paste(lapply(1:50,function(x) {
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

# entropy = Shannon entropy of n-gram distribution
ents = c(); tents = c()
for (i in 1:100) {
  ws = as.character(paste(lapply(1:40,function(x) {
    return(as.character(chr(round(runif(1)*5)+65)))
  }),collapse=' ')) # get a string of letters
  
  ngs = ngrams(ws,n=length(unlist(strsplit(ws,' '))))$all
  letterFqs = table(unlist(strsplit(ws,' ')))
  sumSqFq = sum(letterFqs^2) # sum of squared frequencies of letters
  
  words = unlist(strsplit(ws,' '))
  uniqWords = unique(words)
  wordSeries = apply(data.frame(words),1,function(x) which(x==uniqWords)) 
  res = crqa(wordSeries, wordSeries, 1, 1, 1, .00000001, F, 2, 2, 1, F, F)     
  nGramList = table(ngrams(ws,n=40)$all)
  nGramList = nGramList[nGramList>1 & nchar(names(nGramList))>1]
  
  for (i in sort(nchar(names(nGramList)),decreasing=T,index=T)$ix) {
    nm = names(nGramList)[i]
    ixes = grep(nm,names(nGramList))
    ixes = ixes[ixes!=i]
    for (ix in ixes) {
      nGramList[i] = nGramList[i] - nGramList[ix]
    }
  }
  
  nGramList = nGramList * (nGramList)
  nGramList = nGramList[nGramList>0]
  
  ents = c(ents,res$ENT)
  distrib = table(nchar(gsub(' ', '',names(nGramList))))
  distrib = hist(nchar(gsub(' ', '',names(nGramList))),plot=F)$counts
  distrib = distrib / sum(distrib)  
  distrib = distrib[distrib>0]
  randDistrib = (rep(1/length(distrib),length(distrib)))
  maxEnt = -1*sum(randDistrib*log2(randDistrib))
  #thisEnt = entropy::entropy(distrib, unit='nats')
  thisEnt = -1*sum(distrib*log2(distrib))
  #tents = c(tents,thisEnt/maxEnt)
  tents = c(tents,thisEnt)
  #tents = c(tents,entropy::entropy(hist(nchar(gsub(' ', '',names(nGramList))),plot=F)$counts,unit='log2'))

}
plot(ents,tents)
cor.test(ents,tents)



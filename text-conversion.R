# convert into sequence of numeric identifiers (for words)
dataText = readChar('textfile', file.info('textfile')$size) 
# optional: do some stripping
dataText = gsub('\n',' ',dataText)
words = unlist(strsplit(dataText,' '))
uniqWords = unique(words)
wordSeries = apply(data.frame(words),1,function(x) which(x==uniqWords)) 

#http://datadebrief.blogspot.com/2011/03/ascii-code-table-in-r.html
asc <- function(x) { strtoi(charToRaw(x),16L) }
chr <- function(n) { rawToChar(as.raw(n)) }

# convert into sequence of numeric identifiers (for characters)
dataText = readChar('textfile', file.info('textfile')$size) 
# optional: do some stripping
dataText = gsub('\n',' ',dataText)
chars = unlist(strsplit(dataText,'')) 
uniqChars = unique(chars)
charSeries = apply(data.frame(chars),1,function(x) which(x==uniqChars))

# use tm to do some cleaning (some effort from Prof. Harish Bhat)
library(tm)
dataText = gsub('\n',' ',dataText)
dataText = tolower(dataText)
ts = Corpus(dataText)
ts = tm_map(ts, removeWords, stopwords("english"))
removepunct = function(x) { return(gsub("[[:punct:]]","",x)) }
ts = tm_map(ts, removepunct)
removequotes = function(x) { return(gsub("\"","",x)) }
ts = tm_map(ts, removequotes)
removenum = function(x) { return(gsub("[0-9]","",x)) }
ts = tm_map(ts, removenum)
doublespace = function(x) { return(gsub("  "," ",x)) }
ts = tm_map(ts, doublespace)
dataText = PlainTextDocument(ts)

# doing some quick stemming
library(qdap)
dataText = stem_words(dataText)




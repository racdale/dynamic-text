# convert into sequence of numeric identifiers (for words)
dataText = readChar('textfile', file.info('textfile')$size) 
# optional: do some stripping
dataText = gsub('\n',' ',dataText)
words = unlist(strsplit(dataText,' ')) # palabras utilisan 'space' para cada palabra
uniqWords = unique(words)
wordSeries = apply(data.frame(words),1,function(x) which(x==uniqWords)) # rebuilding the word 

# convert into sequence of numeric identifiers (for characters)
dataText = readChar('textfile', file.info('textfile')$size) 
# optional: do some stripping
dataText = gsub('\n',' ',dataText)
words = unlist(strsplit(dataText,'')) # palabras utilisan 'space' para cada palabra
uniqWords = unique(words)
wordSeries = apply(data.frame(words),1,function(x) which(x==uniqWords)) # rebuilding the word 

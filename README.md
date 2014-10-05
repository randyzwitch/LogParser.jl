# LogParser

[![Build Status](https://travis-ci.org/randyzwitch/LogParser.jl.svg?branch=master)](https://travis-ci.org/randyzwitch/LogParser.jl)

LogParser is a package for parsing server logs. Currently, only server logs having the Apache Combined format are supported (although Apache Common may parse as well). Additional types of logs may be added in the future as well.

##Code examples

The API for this package is straightforward: 

	#Read in gzipped file
	jbapachecombined = readdlm(gzopen("/Users/randyzwitch/Downloads/juliabloggers.com-Sep-2014.gz"), '\t')

	#Parse file
	jbparsed = parseapachecombined(jbapachecombined)

	#Convert to DataFrame if desired
	jbparsed_df = DataFrame(jbparsed)

##Licensing

LogParser.jl is licensed under the [MIT "Expat" license](https://github.com/randyzwitch/LogParser.jl/blob/master/LICENSE.md)


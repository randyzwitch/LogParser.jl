# LogParser

OSX/Linux: [![Build Status](https://travis-ci.org/randyzwitch/LogParser.jl.svg?branch=master)](https://travis-ci.org/randyzwitch/LogParser.jl) </br>
pkg.julialang.org: [![LogParser](http://pkg.julialang.org/badges/LogParser_0.3.svg)](http://pkg.julialang.org/?pkg=LogParser) </br>
pkg.julialang.org: [![LogParser](http://pkg.julialang.org/badges/LogParser_0.4.svg)](http://pkg.julialang.org/?pkg=LogParser) </br>
pkg.julialang.org: [![LogParser](http://pkg.julialang.org/badges/LogParser_0.5.svg)](http://pkg.julialang.org/?pkg=LogParser) </br>

LogParser.jl is a package for parsing server logs. Currently, only server logs having the [Apache Combined](http://httpd.apache.org/docs/2.2/logs.html#combined) format are supported (although [Apache Common](http://httpd.apache.org/docs/2.2/logs.html#common) may parse as well). Additional types of logs may be added in the future as well.

LogParser.jl will attempt to handle the log format even if it is mangled, returning partial matches as best as possible. For example, if the end of the log entry is mangled, you may still get an IP address returned, timestamp and other parts that were able to be parsed.

##Code examples

The API for this package is straightforward: 

	using LogParser, GZip
	
	#Read in gzipped file
	jbapachecombined = readdlm(gzopen(Pkg.dir("LogParser", "test", "data", "juliabloggers-apachecombined.gz")), '\t')

	#Parse file
	jbparsed = parseapachecombined(vec(jbapachecombined))

	#Convert to DataFrame if desired
	jbparsed_df = DataFrame(jbparsed)

##Licensing

LogParser.jl is licensed under the [MIT "Expat" license](https://github.com/randyzwitch/LogParser.jl/blob/master/LICENSE.md)


module LogParser

###############################################################################
#
#
#	Imports and Exports
#
#
###############################################################################

export 
apachecombinedregex,
apachecombined,
ApacheLog

###############################################################################
#
#
#	Types
#
#
###############################################################################

immutable ApacheLog
	ip
	rfc1413
	userid
	requesttime
	resource
	statuscode
	bytecount
	referrer
	useragent
end


###############################################################################
#
#
#	Constants
#
#
###############################################################################

#Regex for Apache Combined Log File Format:
#http://httpd.apache.org/docs/2.4/logs.html

const apachecombinedregex = r"""([\d\.]+)\s([\w.-]+)\s([\w.-]+)\s(\[.+\])\s"([^"]*)"\s(\d{3})\s(\d+|-)\s"((?:[^"]|\”)+)"\s"((?:[^"]|\”)+)"\s"""

###############################################################################
#
#
#	Functions
#
#
###############################################################################

function apachecombined(logline::ASCIIString)
    m = match(apachecombinedregex, logline)
    return ApacheLog(
					m.captures[1],
					m.captures[2],
					m.captures[3],
					m.captures[4],
					m.captures[5],
					m.captures[6],
					m.captures[7],
					m.captures[8],
					m.captures[9]
    				)
end




end # module

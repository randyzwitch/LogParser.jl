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
	ip::String
	rfc1413::String
	userid::String
	requesttime::String
	resource::String
	statuscode::Integer
	bytecount::Integer
	referrer::String
	useragent::String
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

function apachecombined(logline::String)
    m = match(apachecombinedregex, logline)
    return ApacheLog(
					utf8(m.captures[1]), #IP
					utf8(m.captures[2]), #RFC1413
					utf8(m.captures[3]), #userid
					utf8(m.captures[4]), #requesttime
					utf8(m.captures[5]), #resource
					int(m.captures[6]),  #Status Code
					int(m.captures[7]),  #Request Size
					utf8(m.captures[8]), #Referrer
					utf8(m.captures[9])  #User-Agent
    				)
end




end # module

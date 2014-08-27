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
	nonmatchstring
end


###############################################################################
#
#
#	Constants
#
#
###############################################################################

#Regex for Apache Combined Log File Format:
#Format specified at http://httpd.apache.org/docs/2.4/logs.html

const apachecombinedregex = r"""([\d\.]+)\s([\w.-]+)\s([\w.-]+)\s(\[.+\])\s"([^"]*)"\s(\d{3})\s(\d+|-)\s"((?:[^"]|\")+)"\s"((?:[^"]|\")+)"$"""

###############################################################################
#
#
#	Functions
#
#
###############################################################################

function apachecombined(logline::String)
    m = match(apachecombinedregex, logline)
    
    #Check for no match
    isa(m, Nothing)? 

    #Return non-matching string if m <: Nothing
    #ApacheLog("", "", "", "", "", "", "", "", "", logline) :
    println(logline): 
    
    #Else return fully-parsed ApacheLog
   	ApacheLog(
			utf8(m.captures[1]), #IP
			utf8(m.captures[2]), #RFC1413
			utf8(m.captures[3]), #userid
			utf8(m.captures[4]), #requesttime
			utf8(m.captures[5]), #resource
			int(m.captures[6]),  #Status Code
			int(m.captures[7]),  #Request Size
			utf8(m.captures[8]), #Referrer
			utf8(m.captures[9]),  #User-Agent
			""
    		)
end




end # module

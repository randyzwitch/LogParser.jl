module LogParser

###############################################################################
#
#
#	Imports and Exports
#
#
###############################################################################

export 
apachecombined,
apachecombinedregex

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
#Format specified at http://httpd.apache.org/docs/2.4/logs.html

#Stict Mode - Works 99.9% of time on Juliabloggers and randyzwitch.com August test files
const apachecombinedregex = r"""([\d\.]+) ([\w.-]+) ([\w.-]+) (\[.+\]) "([^"\r\n]*|[^"\r\n\[]*\[.+\][^"]+|[^"\r\n]+.[^"]+)" (\d{3}) (\d+|-) ("(?:[^"]|\")+)"? ("(?:[^"]|\")+)"?"""

#Non-strict mode: Capture as much info as possible
	const firsteightregex = r"""([\d\.]+) ([\w.-]+) ([\w.-]+) (\[.+\]) "([^"\r\n]*|[^"\r\n\[]*\[.+\][^"]+|[^"\r\n]+.[^"]+)" (\d{3}) (\d+|-) ("(?:[^"]|\")+)"?"""
	const firstsevenregex = r"""([\d\.]+) ([\w.-]+) ([\w.-]+) (\[.+\]) "([^"\r\n]*|[^"\r\n\[]*\[.+\][^"]+|[^"\r\n]+.[^"]+)" (\d{3}) (\d+|-)"""
	 const firstsixregex  = r"""([\d\.]+) ([\w.-]+) ([\w.-]+) (\[.+\]) "([^"\r\n]*|[^"\r\n\[]*\[.+\][^"]+|[^"\r\n]+.[^"]+)" (\d{3})"""
	 const firstfiveregex = r"""([\d\.]+) ([\w.-]+) ([\w.-]+) (\[.+\]) "([^"\r\n]*|[^"\r\n\[]*\[.+\][^"]+|[^"\r\n]+.[^"]+)"?"""
	 const firstfourregex = r"""([\d\.]+) ([\w.-]+) ([\w.-]+) (\[.+\])"""
	const firstthreeregex = r"""([\d\.]+) ([\w.-]+) ([\w.-]+)""" 
	  const firsttworegex = r"""([\d\.]+) ([\w.-]+)"""
	const firstfieldregex = r"""([\d\.]+)"""

###############################################################################
#
#
#	Functions
#
#
###############################################################################

function apachecombined(logline::String; strict = true)
    
    #Strict mode only allows for comparison against valid Apache Common Log format
    strict? regexarray = [apachecombinedregex]: 
    		regexarray = [apachecombinedregex, firstsevenregex, firstsixregex, firstfiveregex, firstfourregex, firstthreeregex, firsttworegex, firstfieldregex]  


    #Declare variable defaults up front for less coding later
    ip = rfc1413 = userid = requesttime = resource = referrer = useragent = utf8("")
    statuscode = requestsize = int(0)

 	for regex in regexarray   
    	if (m = match(regex, logline)) != nothing

    	#Use try since we don't know how many matches actually happened
	    	try ip 			= utf8(m.captures[1]) end
	    	try rfc1413 	= utf8(m.captures[2]) end
	    	try userid		= utf8(m.captures[3]) end
	    	try requesttime	= utf8(m.captures[4]) end
	    	try resource	= utf8(m.captures[5]) end
	    	try statuscode	= int(m.captures[6]) end
	    	try requestsize	= int(m.captures[7]) end
	    	try referrer	= utf8(m.captures[8]) end
	    	try useragent	= utf8(m.captures[9]) end

			return ApacheLog(ip, rfc1413, userid, requesttime,	resource, statuscode, requestsize, referrer, useragent)
		end

   	end #End for loop
    
    #If all else fails, return "nomatch" as referrer and logline as useragent field 
    return ApacheLog(ip, rfc1413, userid, requesttime,	resource, statuscode, requestsize, "nomatch", logline) 

end #End apachecombined

end # module
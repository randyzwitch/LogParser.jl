VERSION >= v"0.4-" && __precompile__()
module LogParser

###############################################################################
#
#
#	Imports and Exports
#
#
###############################################################################

export
parseapachecombined,
DataFrame,
ApacheLog

import DataFrames: DataFrame

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
	requestsize
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

function parseapachecombined(logline::AbstractString)

    regexarray = [apachecombinedregex, firstsevenregex, firstsixregex, firstfiveregex, firstfourregex, firstthreeregex, firsttworegex, firstfieldregex]


    #Declare variable defaults up front for less coding later
    ip = rfc1413 = userid = requesttime = resource = referrer = useragent = utf8("")
    statuscode = requestsize = Int(0)

 	for regex in regexarray

    	if (m = match(regex, logline)) != nothing

    	#Use try since we don't know how many matches actually happened
	    	try ip 			= utf8(m.captures[1]) end
	    	try rfc1413 	= utf8(m.captures[2]) end
	    	try userid		= utf8(m.captures[3]) end
	    	try requesttime	= utf8(m.captures[4]) end
	    	try resource	= utf8(m.captures[5]) end
	    	try statuscode	= parse(Int, m.captures[6]) end
	    	try requestsize	= parse(Int, m.captures[7]) end
	    	try referrer	= utf8(m.captures[8]) end
	    	try useragent	= utf8(m.captures[9]) end

			return ApacheLog(ip, rfc1413, userid, requesttime,	resource, statuscode, requestsize, referrer, useragent)
		end

   	end #End for loop

    #If all else fails, return "nomatch" as referrer and logline as useragent field
    return ApacheLog(ip, rfc1413, userid, requesttime,	resource, statuscode, requestsize, "nomatch", logline)

end #End parseapachecombined::String

#Vectorized version of parseapachecombined
#Use custom version instead of base macro to control return Array type
parseapachecombined(logarray::Array) = ApacheLog[parseapachecombined(x) for x in logarray]


###############################################################################
#
#
#	DataFrame parser
#
#
###############################################################################

function DataFrame(logarray::Array{ApacheLog,1})

       #fields to parse
    sym = [:ip, :rfc1413, :userid, :requesttime, :resource, :referrer, :useragent, :statuscode, :requestsize]

    #Allocate Arrays
    for value in sym[1:7]
        @eval $value = UTF8String[]
    end

    for value in sym[8:end]
        @eval $value = Int[]
    end

    #For each value in array, parse into individual arrays
    for apachelog in logarray
        for val in sym
            push!(eval(val), getfield(apachelog, val))
        end
    end

    #Append arrays into dataframe
    _df = DataFrame()

    for value in sym
    _df[value] = eval(value)
    end

    return _df

end

DataFrame(logline::ApacheLog) = DataFrame([logline])


end # module
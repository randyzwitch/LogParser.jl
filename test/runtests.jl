using LogParser
using Base.Test
using GZip


testfile = Pkg.dir("LogParser", "test", "data", "juliabloggers-apachecombined.gz")

#Read in gzipped file
jbapachecombined = readdlm(gzopen(Pkg.dir("LogParser", "test", "data", "juliabloggers-apachecombined.gz")), '\t')

#Parse file
jbparsed = parseapachecombined(jbapachecombined)

#Test that array is 122,143 elements long
@test size(jbparsed)[1] == 122143

#Test that array is of type Array{ApacheLog,1}
@test typeof(jbparsed) == Array{ApacheLog,1}

#Test DataFrame method
jbparsed_df = DataFrame(jbparsed)

#Test that a DataFrame was returned
@test typeof(jbparsed_df) <: DataFrame

#Test that DataFrame is 122143x9
@test size(jbparsed_df) == (122143,9)

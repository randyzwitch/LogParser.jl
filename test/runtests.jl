using LogParser
using Base.Test
using GZip

#Read in gzipped file
jbapachecombined = readdlm(gzopen(joinpath(dirname(@__FILE__), "data", "juliabloggers-apachecombined.gz")), '\t')

#Parse file
jbparsed = parseapachecombined(vec(jbapachecombined))

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

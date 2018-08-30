module BiobakeryUtils

export
    import_abundance_tables,
    import_abundance_table,
    clean_abundance_tables,
    taxfilter,
    taxfilter!,
    rm_strat!,
    permanova

using DataFrames
using Statistics
using CSV
using RCall
using Microbiome

include("general.jl")
include("metaphlan.jl")

end

module BiobakeryUtils

export
    metaphlan_v3_table,
    rm_strat!,
    permanova,
    humann2_regroup,
    humann2_rename

using Reexport
@reexport using Microbiome
import Microbiome: _clades
using SparseArrays
using CSV
using Tables
using RCall

include("general.jl")
include("metaphlan.jl")
include("humann.jl")

end

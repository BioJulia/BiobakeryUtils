"""
    function humann2_regroup(tbl, return_type=typeof(tbl); inkind="uniref90", outkind::String="ec", version=3)

Wrapper for `humann_regroup_table` script.
Accepts any Tables-compatible input, and by default returns a table of the same type.

The `humann_regroup_table` script must be in your `\$PATH`, 
but note that the julia shell is different from your normal shell.
You may need to modify `ENV["PATH"]` to point to your executable.

!!! compat "HUMANn2"
    If you're using HUMANn2, you can pass `version=2` to use the legacy script
"""
function humann_regroup(tbl, return_func=typeof(tbl); inkind::String="uniref90", outkind::String="ec", version=3)
    in_path = tempname()
    out_path = tempname()
    CSV.write(in_path, tbl)
    func = version == 3 ? "humann_regroup_table" :
           version == 2 ? "humann2_regroup_table" : throw(ArgumentError("Only accepts versions 2 and 3"))
    run(```
        $func -i $in_path -g $(inkind)_$outkind -o $out_path
        ```)

    return CSV.read(out_path, return_func)
end

"""
    humann_rename(tbl; kind::String="ec")

Wrapper for `humann_regroup_table` script.
Accepts any Tables-compatible input, and by default returns a table of the same type.

The `humann_rename_table` script must be in your `\$PATH`, 
but note that the julia shell is different from your normal shell.
You may need to modify `ENV["PATH"]` to point to your executable.
    
!!! compat "HUMANn2"
    If you're using HUMANn2, you can pass `version=2` to use the legacy script
"""
function humann2_rename(tbl, return_func=typeof(tbl); kind::String="ec", version=3)
    in_path = tempname()
    out_path = tempname()
    CSV.write(in_path, tbl)
    func = version == 3 ? "humann_rename_table" :
           version == 2 ? "humann2_rename_table" : throw(ArgumentError("Only accepts versions 2 and 3"))
    run(```
        $func -i $in_path -n $kind -o $out_path
        ```)

    return CSV.read(out_path, return_func)
end


# function humann2_barplots(df::DataFrame, metadata::AbstractArray{<:AbstractString,1}, outpath::String)
#     length(metadata) == size(df, 2) - 1 || @error "Must have metadata for each column"
#     nostrat = df[map(x-> !occursin(r"\|", x), df[!,1]), 1]
#     for p in nostrat
#         pwy = match(r"^[\w.]+", p).match
#         @debug pwy
#         filt = [occursin(Regex("^$pwy\\b"), x) for x in df[!,1]]
#         current = df[filt, :]
#         @debug "Size of $p dataframe" size(current)
#         if size(current, 1) < 3
#             @info "Only 1 classified species for $p, skipping"
#             continue
#         end
#         @info "plotting $p"

#         BiobakeryUtils.humann2_barplot(current, metadata, outpath)
#     end
# end

# function humann2_barplot(df::AbstractDataFrame, metadata::AbstractArray{<:AbstractString,1}, outpath::AbstractString)
#     sum(x-> !occursin(r"\|", x), df[!,1]) == 1 || @error "Multipl unstratified rows in dataframe"
#     matches = map(x-> match(r"^([^:|]+):?([^|]+)?", x),  df[!,1])
#     all(x-> !isa(x, Nothing), matches) || @error "something is wrong!"
#     @debug "Getting unique"
#     ecs = unique([String(x.captures[1]) for x in matches])
#     length(ecs) == 1 || @error "Multiple ecs found in df"
#     ec = ecs[1]

#     metadf = DataFrame(metadata=["metadatum"])
#     metadf = hcat(metadf, DataFrame([names(df)[2:end][i]=>metadata[i] for i in eachindex(metadata)]...))
#     @debug "opening file"
#     fl_path = tempname()
#     outfl = open(fl_path, "w")
#     CSV.write(outfl, metadf, delim='\t')
#     CSV.write(outfl, df, append=true, delim='\t')
#     close(outfl)
#     @debug "file closed"

#     out = joinpath(outpath, "$ec.png")
#     @debug "humann2_barplot --i $fl_path -o $out --focal-feature $ec --focal-metadatum metadatum --last-metadatum metadatum --sort sum metadata"
#     run(```
#         humann2_barplot --i $fl_path -o "$out" --focal-feature "$ec" --focal-metadatum metadatum --last-metadatum metadatum --sort sum metadata
#         ```)

# end

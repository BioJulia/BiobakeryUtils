#==============
MetaPhlAn Utils
==============#
const _shortclades = (
    d = :domain,
    k = :kingdom,
    p = :phylum,
    c = :class,
    o = :order,
    f = :family,
    g = :genus,
    s = :species,
    t = :subspecies)

function _split_clades(clade_string)
    clades = split(clade_string, '|')
    taxa = Taxon[]
    for clade in clades
        (level, name) = split(clade, "__")
        push!(taxa, Taxon(name, _shortclades[Symbol(level)]))
    end
    return taxa
end

function metaphlan_profile(path::AbstractString; sample=basename(first(splitext(path))), level=:all)
    profile = CSV.read(path, datarow=5, header=["clade", "NCBI_taxid", "abundance", "additional_species"], Tables.columntable)
    taxa = [last(_split_clades(c)) for c in profile.clade]
    mat = sparse(reshape(profile.abundance, length(profile.abundance), 1))
    sample = sample isa Microbiome.AbstractSample ? sample : MicrobiomeSample(sample)
    keep = level == :all ? Colon() : [ismissing(c) || c == level for c in clade.(taxa)]
    return CommunityProfile(mat[keep, :], taxa[keep], [sample])
end

function metaphlan_profiles(table)
end
using BiobakeryUtils
# using DataFrames
using Test

@testset "Biobakery Utilities" begin
    p1 = metaphlan_profile("metaphlan3_test1.tsv")
    @test p1 isa CommunityProfile
    @test name(first(samples(p1))) == "metaphlan3_test1"
    @test nfeatures(p1) == 129
    p1_spec = metaphlan_profile("metaphlan3_test1.tsv", level = :species)
    @test nfeatures(p1_spec) == 57
    @test all(t-> clade(t) == :species, features(p1_spec))
end

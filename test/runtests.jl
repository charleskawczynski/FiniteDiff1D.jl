# Temporary hack:
# Run file with
#=
julia --project] test
julia --project
using TestEnv; TestEnv.activate();
using Revise; include(joinpath("test","runtests.jl"))
=#
# import Pkg
# import Logging
# test_manifest = joinpath(@__DIR__, "Manifest.toml")
# if !isfile(test_manifest)
#     Pkg.add(Pkg.PackageSpec(; url="https://github.com/mossr/TeX.jl"))
# end
# Conditionally dev:
# if !occursin("path = \"", join(readlines(test_manifest; keep=true)))
#     Pkg.develop(Pkg.PackageSpec(; path=dirname(@__DIR__)))
# end

# using TeX
using Test
using FiniteDiff1D
using Symbolics
import Latexify
using LaTeXStrings

function post_process(sol, fʲ_i, k_range, n_unknowns)
    sol = fʲ_i ~ sol
    s = Latexify.latexify(sol)

    s = LaTeXStrings.LaTeXString(s)
    # for (i, k) in enumerate(k_range)
    #     str_to = if k==0
    #         "_{i}"
    #     elseif k > 0
    #         "_{i+$k}"
    #     elseif k < 0
    #         "_{i$k}"
    #     end

    #     str_from = if k==0 || k > 0
    #         "_{k{_$k}}"
    #     elseif k < 0
    #         "_{k\\_-{_$(abs(k))}}"
    #     end

    #     # Fixup k-subscripts
    #     s = replace(s, str_from => str_to)
    # end

    # for j in 1:n_unknowns
    #     # Fixup j-subscripts / unicode superscripts
    #     s = replace(s, "f\\^j_{i{_$j}}" => "f$(repeat("'", j))_{i}")
    # end

    s = LaTeXStrings.LaTeXString(s)
    return s
end

# @testset "Test" begin
    n_left, n_right = -1, 1
    solns, f_k, fʲ_i, α_k, k_range, n_unknowns =
        FiniteDiff1D.generate_stencil(n_left, n_right)
    @show solns
    s = post_process.(solns, fʲ_i, Ref(k_range), Ref(n_unknowns))
# end

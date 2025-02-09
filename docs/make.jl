#=
julia --project=docs
julia --project=docs] dev . from FiniteDiff1D.jl/
using Revise; include("docs/make.jl")
=#
import Documenter, DocumenterCitations
import FiniteDiff1D

include("generate_stencils.jl") # generates stencils .md files, used for pages

bib = DocumenterCitations.CitationBibliography(joinpath(@__DIR__, "refs.bib"))

mathengine = Documenter.MathJax(
    Dict(:TeX => Dict(:equationNumbers => Dict(:autoNumber => "AMS"), :Macros => Dict())),
)

format = Documenter.HTML(
    prettyurls = !isempty(get(ENV, "CI", "")),
    mathengine = mathengine,
    collapselevel = 1,
)

generated_stencil_pages = get_all_generated_files(".")
generated_stencil_pairs = map(generated_stencil_pages) do page
    name = basename(first(splitext(page)))
    navname = replace(name, "generated_stencil_" => "")
    Pair(navname, "solutions/$name.md")
end
@show generated_stencil_pairs

Documenter.makedocs(;
    plugins = [bib],
    sitename = "FiniteDiff1D.jl",
    format = format,
    checkdocs = :exports,
    clean = true,
    doctest = true,
    modules = [FiniteDiff1D],
    pages = Any[
        "Home" => "index.md",
        "API" => "api.md",
        "Generated Stencil Solutions" => Any[
            generated_stencil_pairs...,
        ],
        "References" => "references.md"
    ],
)

Documenter.deploydocs(
    repo = "github.com/charleskawczynski/FiniteDiff1D.jl.git",
    target = "build",
    push_preview = true,
    devbranch = "main",
    forcepush = true,
)

module FiniteDiff1D

import Symbolics

struct OffsetVariable{ET, T} <: Symbolics.DenseVector{ET}
    var::T
    inds::Vector{Int}
    ind_dict::Dict{Int,Int}
end
function OffsetVariable(var, inds)
    ind_dict = Dict{Int,Int}()
    # @show inds
    # @show length(inds)
    # @show 1:length(inds)
    for i in 1:length(inds)
        # @show inds[i]
        # ind_dict[inds[i]] = i
        ind_dict[i] = i
    end
    OffsetVariable{eltype(var), typeof(var)}(var, inds, ind_dict)
end
Base.size(v::OffsetVariable) = Base.size(v.var)
Base.getindex(v::OffsetVariable, i) = Base.getindex(v.var, i)
eq_index(v::OffsetVariable, i) = Base.getindex(v.var, v.ind_dict[i])
function Base.show(io::IO, ov::OffsetVariable)
    for i in 1:length(ov.var)
        print(io, ov.var[i])
        i ≠ length(ov.var) && print(io, ", ")
    end
end

# Generates a method
# ∇(f_stencil, Δx_stencil, i)
function generate_stencil(n_left, n_right;staggered=false)
    @assert n_left < 0
    @assert n_right > 0
    @assert !(n_left == 0 && n_right == 0)
    staggered && error("staggered not yet supported")

    eqs = []
    k_range = n_left:n_right
    k_eqs = filter(x->x≠0, k_range)
    n_unknowns = length(k_range)
    j_range = 0:(n_unknowns-1)
    k_center = 1-n_left # example: n_left = 2: -2, -1, 0, 1, 2
    Symbolics.@variables α_k[1:length(k_eqs)], f_k[1:length(k_range)], fʲ_i[1:n_unknowns-1]
    fʲ_i = Symbolics.scalarize(fʲ_i)
    f_k = Symbolics.scalarize(f_k)
    α_k = Symbolics.scalarize(α_k)
    f_k = OffsetVariable(f_k, k_range)
    α_k = OffsetVariable(α_k, k_eqs)
    @info "User input: (n_left, n_right, n_unknowns) = ($n_left, $n_right, $n_unknowns)"
    @info "k_center = $k_center"
    @info "k_range = $k_range"
    @info "k_eqs = $k_eqs"
    @info "Unknowns: $fʲ_i"
    @info "Knowns (α_k): $α_k"
    @info "Knowns (f_k): $f_k"

    # Construct equations:

    # For example: n_left = -2, n_right = 2
    #     k_range:  -2, -1, 0, 1, 2
    #     k_offset:  1,  2, 4, 5
    #     k_eqs:    -2, -1, 1, 2
    #     k_enum:    1,  2, 3, 4
    f_k0 = eq_index(f_k, k_center)
    # @show f_k0
    # @show k_eqs
    # @show typeof(k_eqs)
    for (k_enum, k_eq) in enumerate(k_eqs)
        k_offset = k_eq < 0 ? k_enum : k_enum+1
        # @show k_enum
        # @show fʲ_i
        # @show α_k
        # @show typeof(α_k)
        # @show typeof(α_k[k_enum])
        # @show α_k[k_enum]
        arr = map(j_range) do j
            fʲ_i_temp = j==0 ? f_k0 : fʲ_i[j]
            α_k[k_enum]^j/factorial(j)*fʲ_i_temp
        end
        ∑_jk = sum(arr)
        push!(eqs, f_k[k_offset] ~ ∑_jk)
    end
    # solns = Symbolics.solve_for(eqs, fʲ_i)
    solns = Symbolics.symbolic_linear_solve(eqs, fʲ_i)

    solns = map(solns) do sol
        factor(sol, f_k)
        # Symbolics.simplify(factor(sol, f_k))
    end

    return solns, f_k, fʲ_i, α_k, k_range, n_unknowns
end

# Typically, `f_k` is factoried:
function factor(eq, vars)
    f = []
    for v in vars
        d = Dict(u => (isequal(v,u) ? 1 : 0) for u in vars)
        @show v
        # push!(f, v * Symbolics.substitute(eq, d))
        s = Symbolics.substitute(eq, d)
        push!(f, v * Symbolics.simplify(s; expand = true))
        # push!(f, v * Symbolics.simplify(Symbolics.substitute(eq, d)))
        # @show Symbolics.simplify(Symbolics.substitute(eq, d))
    end
    +(f...)
end

function stencil_name(config)
    name = if abs(config[1]) == abs(config[2])
        "Centered"
    elseif abs(config[1]) > abs(config[2])
        "LeftBiased"
    elseif abs(config[1]) < abs(config[2])
        "RightBiased"
    end
    n = (config[2]-config[1])
    name *= "_Order$(n)"
    name *= if config[3]
        "_Staggered"
    else
        "_Collocated"
    end
    return name
end

end # module

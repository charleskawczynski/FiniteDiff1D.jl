module FiniteDiff1D

using Symbolics

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
    @variables α_k[k_eqs], f_k[k_range], fʲ_i[1:n_unknowns-1]
    @info "User input: (n_left, n_right, n_unknowns) = ($n_left, $n_right, $n_unknowns)"
    @info "Unknowns: $fʲ_i"
    @info "Knowns:\n$(join((α_k, f_k), "\n"))"

    # Construct equations:

    # For example: n_left = -2, n_right = 2
    #     k_range:  -2, -1, 0, 1, 2
    #     k_offset:  1,  2, 4, 5
    #     k_eqs:    -2, -1, 1, 2
    #     k_enum:    1,  2, 3, 4
    for (k_enum, k_eq) in enumerate(k_eqs)
        k_offset = k_eq < 0 ? k_enum : k_enum+1
        f_k0 = f_k[k_center]
        ∑_jk = sum(j_range) do j
            fʲ_i_temp = j==0 ? f_k0 : fʲ_i[j]

            α_k[k_enum]^j/factorial(j)*fʲ_i_temp
        end
        push!(eqs, f_k[k_offset] ~ ∑_jk)
    end
    solns = Symbolics.solve_for(eqs, fʲ_i)

    solns = map(solns) do sol
        factor(sol, f_k)
    end

    return solns, f_k, fʲ_i, k_range, n_unknowns
end

# Typically, `f_k` is factoried:
function factor(eq, vars)
    f = []
    for v in vars
        d = Dict(u => (isequal(v,u) ? 1 : 0) for u in vars)
        push!(f, v * substitute(eq, d))
    end
    +(f...)
end

end # module

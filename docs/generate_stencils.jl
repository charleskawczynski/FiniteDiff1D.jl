
using FiniteDiff1D: generate_stencil, stencil_name
import Latexify

function get_all_generated_files(root_dir)
	all_files = String[]
  for (root, dirs, files) in walkdir(root_dir)
      for file in files
       	if startswith(file, "generated_stencil_") && endswith(file, ".md")
          push!(all_files, joinpath(root, file)) # path to files
      end
      end
  end
  return all_files
end

configs = [
	(-1,1,false),
	(-1,2,false),
]
solutions = map(configs) do (n_left, n_right, staggered)
		generate_stencil(n_left, n_right;staggered=false) # staggered not yet supported
end

function terms_str(solns, f_k, fʲ_i, α_k, k_range, n_unknowns, eq_i)
	s = ""
	k_eqs = filter(x->x≠0, k_range)
	for k in 1:length(k_eqs)
		s *= "$(α_k[k])"
	end
	return s
end
offsetted_k(k, k_range) = filter(x->!iszero(x), k_range)[k]

for (config, sol) in zip(configs, solutions)
	sname = stencil_name(config)
	doc_file = joinpath(@__DIR__, "src", "solutions", "generated_stencil_$sname.md")
	mkpath(dirname(doc_file))
	template = join(readlines(joinpath(@__DIR__, "src", "template.md")), "\n")


	# SYSTEM_OF_EQUATIONS
	(solns, f_k, fʲ_i, α_k, k_range, n_unknowns) = sol
	@show k_range
	@show α_k
	@show typeof(α_k)
	SYSTEM_OF_EQUATIONS = ""
	@show n_unknowns
	@show length(solns)
	eq_strings = map(1:n_unknowns) do eq_i
		terms_str(solns, f_k, fʲ_i, α_k, k_range, n_unknowns, eq_i)
	end
	SYSTEM_OF_EQUATIONS = join(eq_strings, "\n")
	@show SYSTEM_OF_EQUATIONS
	STENCIL_SOLUTION = map(1:(n_unknowns-1)) do eq_i
		sol_eq = fʲ_i[eq_i] ~ solns[eq_i]
		Latexify.latexify(sol_eq)
	end
	STENCIL_SOLUTION = join(STENCIL_SOLUTION, "", "")

	# Combine equations
	STENCIL_SOLUTION = replace(STENCIL_SOLUTION, "\n\\end{equation}\n\\begin{equation}\n" => "\\\\\n")

	# prettify:
	@show k_range
	for (kfrom, kto) in enumerate(k_range)
		# alpha
		STENCIL_SOLUTION = replace(STENCIL_SOLUTION, "mathtt{f^j\\_i}_{$kfrom}" => "mathtt{f^{($kfrom)}_{i}}")
		if kto == 0
			STENCIL_SOLUTION = replace(STENCIL_SOLUTION, "mathtt{f\\_k}_{$kfrom}" => "mathtt{f_{i}}")
		elseif kto < 0
			STENCIL_SOLUTION = replace(STENCIL_SOLUTION, "mathtt{f\\_k}_{$kfrom}" => "mathtt{f_{i$kto}}")
		elseif kto > 0
			STENCIL_SOLUTION = replace(STENCIL_SOLUTION, "mathtt{f\\_k}_{$kfrom}" => "mathtt{f_{i+$kto}}")
		end
	end
	for (kfrom, kto) in enumerate(filter(x->!iszero(x), k_range))
		k_off = offsetted_k(kfrom, k_range)
		if kto == 0
			STENCIL_SOLUTION = replace(STENCIL_SOLUTION, "mathtt{\\alpha\\_k}_{$kfrom}" => "mathtt{\\alpha_{$k_off}}")
		elseif kto < 0
			STENCIL_SOLUTION = replace(STENCIL_SOLUTION, "mathtt{\\alpha\\_k}_{$kfrom}" => "mathtt{\\alpha_{i$k_off}}")
		elseif kto > 0
			STENCIL_SOLUTION = replace(STENCIL_SOLUTION, "mathtt{\\alpha\\_k}_{$kfrom}" => "mathtt{\\alpha_{i+$k_off}}")
		end
	end

	# KNOWNS
	f_str = "$f_k"
	alpha_str = "$α_k"
	KNOWNS = string(alpha_str, ",", f_str)

	STENCIL_CONFIGURATION = sname
	# STENCIL_SOLUTION = ""
	SYSTEM_OF_EQUATIONS = ""
	EQUATIONS_SOLVED = ""
	EQUATIONS_SOLVED_WITH_TRUNC = ""
	# KNOWNS = ""
	UNKNOWNS = string(fʲ_i)
	FIRST_DERIVATIVE = ""
	FIRST_DERIVATIVE_TRUNCATION = ""
	SEOND_DERIVATIVE = ""
	SEOND_DERIVATIVE_TRUNCATION = ""

# Note: order is important to avoid replacements of subwords
replacements = [
	Pair("STENCIL_CONFIGURATION", STENCIL_CONFIGURATION),
	Pair("STENCIL_SOLUTION", STENCIL_SOLUTION),
	Pair("SYSTEM_OF_EQUATIONS", SYSTEM_OF_EQUATIONS),
	Pair("EQUATIONS_SOLVED_WITH_TRUNC", EQUATIONS_SOLVED_WITH_TRUNC),
	Pair("EQUATIONS_SOLVED", EQUATIONS_SOLVED),
	Pair("KNOWNS", KNOWNS),
	Pair("UNKNOWNS", UNKNOWNS),
	Pair("FIRST_DERIVATIVE_TRUNCATION", FIRST_DERIVATIVE_TRUNCATION),
	Pair("FIRST_DERIVATIVE", FIRST_DERIVATIVE),
	Pair("SEOND_DERIVATIVE_TRUNCATION", SEOND_DERIVATIVE_TRUNCATION),
	Pair("SEOND_DERIVATIVE", SEOND_DERIVATIVE),
]
	template = replace(template, replacements...)
	open(io->println(io, template), doc_file, "w")
end



# FiniteDiff1D.jl

This package symbollically solves for equations for finite difference
approximations, derived from Taylor expansions. The resulting system of
equations are in the form of a Vandermonde matrix:

```math
f_{i+k} = ∑_{j=0}^n α_{i+k}^j \frac{f_i^{(j)}}{(j)!}, k = n_{left}...,n_{right}.
```

Expanded out, this is:

```math
f_{i+k} = ∑_{j=0}^n \frac{α_{i+k}^j f_i^(j)}{(j)!}, k = n_{left} \\
f_{i+k} = ∑_{j=0}^n \frac{α_{i+k}^j f_i^(j)}{(j)!}, k = n_{left}+1 \\
f_{i+k} = ∑_{j=0}^n \frac{α_{i+k}^j f_i^(j)}{(j)!}, k = n_{left}+2 \\
f_{i+k} = ∑_{j=0}^n \frac{α_{i+k}^j f_i^(j)}{(j)!}, k = -1 \\
f_{i+k} = ∑_{j=0}^n \frac{α_{i+k}^j f_i^(j)}{(j)!}, k = 1 \\
... \\
f_{i+k} = ∑_{j=0}^n \frac{α_{i+k}^j f_i^(j)}{(j)!}, k = n_{right}
```

Where the unknowns are the ``j``-th derivatives, ``f_i^(j)`` (a vector of size
``n = n_R - n_L + 1``) of the function ``f_i`` at location ``i``. The input
arguments `n_{left}`, and `n_{right}` are assumed to be known. The distance
between ``f_i`` and ``f_{i+k}`` is

``
α_i = Δx_i = x_{i+k} - x_{i}
``

In matrix form, this is:

``
β f_i_j = f_ik
``

Where

```math
β = [
    1  α_{-n_L}/1!   α_{-n_L}^2/2!   ... α_{-n_L}^j/j!   ... α_{-n_L}^n/n!   \\ (row 1)
    1  α_{-n_L+1}/1! α_{-n_L+1}^2/2! ... α_{-n_L+1}^j/j! ... α_{-n_L+1}^n/n! \\ (row 2)
    ... \\
    1  α_{n_R}/1!    α_{n_R}^2/2!    ... α_{n_R}^j/j!    ... α_{n_R}^n/n!     \\ (row n)
],
```

```math
f_i_j = [
    f^{(0)} \\
    f^{(1)} \\
    ... \\
    f^{(j)} \\
    ... \\
    f^{(n)} \\
]
```

And
```math
f_ik = [
    f_{-n_L} \\
    f_{-n_L+1} \\
    ... \\
    f_{0} \\
    ... \\
    f_{-n_R}
]
```

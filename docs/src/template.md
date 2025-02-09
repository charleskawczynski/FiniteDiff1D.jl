# Generated stencil for STENCIL_CONFIGURATION

This is a generated file, created from `docs/generate_stencils.jl`

The linear system is a set of Taylor expansions about a point
    in space and is of the form of a Vandermonde matrix:

```math
STENCIL_SOLUTION
```

Where the unknowns are the derivatives $f_i^{(j)}$. The input arguments, $n_{left}$ and $n_{right}$, are the number of points to the left and right of $i$ respectively. $f_{i+k}\forall k$ is assumed to be known. From the figure:

```
 f_{i}                    f_{i+k}
   ├─────────────────────────○
   ├─────── α_{i+k} ────────>|
```

The distance between `$f_{i}$` and `$f_{i+k}$` is

```math
  \alpha_{i+k}
  =
  h_{i+k} - h_{i}
```

Assuming $\Delta h_1 = h_2 - h_1$, we can relate $\Delta h$ and $\alpha$ as follows

```math
  \Delta h_{i} = h_{i+1} - h_{i} = \alpha_{i+1}
  ,\qquad \qquad
  \Delta h_{i} + \Delta h_{i+1} = h_{i+2} - h_{i} = \alpha_{i+2}
```

In general, we may write this as

```math
  \alpha_{i+k} = h_{i+k} - h_{i}
  ,\qquad \qquad
  \alpha_{i+k} = \sum_{j=0}^{k-1} \Delta h_{i+j}
```

Again, to reiterate, the indexing convention is:

```math
  \boxed{
  \Delta h_{i}
  =
  h_{i+1} - h_{i}
  }
```

## Equations Solved (Without Truncation Error)

EQUATIONS_SOLVED

## Equations Solved (With Truncation Error)

EQUATIONS_SOLVED_WITH_TRUNC

## Knowns

KNOWNS

## Unknowns

UNKNOWNS

## First derivative

FIRST_DERIVATIVE

## First derivative Truncation

FIRST_DERIVATIVE_TRUNCATION

## Second derivative

SEOND_DERIVATIVE

## Second derivative Truncation

SEOND_DERIVATIVE_TRUNCATION

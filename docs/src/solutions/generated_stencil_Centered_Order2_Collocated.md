# Generated stencil for Centered_Order2_Collocated

This is a generated file, created from `docs/generate_stencils.jl`

The linear system is a set of Taylor expansions about a point
    in space and is of the form of a Vandermonde matrix:

```math
\begin{equation}
\mathtt{f^{(1)}_{i}} = \frac{2 \mathtt{f_{i}} \left(  - \frac{1}{2} \mathtt{\alpha_{i-1}} - \frac{1}{2} \mathtt{\alpha_{i+1}} \right)}{\mathtt{\alpha_{i-1}} \mathtt{\alpha_{i+1}}} + \frac{ - \frac{1}{2} \mathtt{f_{i+1}} \mathtt{\alpha_{i-1}}}{ - \frac{1}{2} \mathtt{\alpha_{i-1}} \mathtt{\alpha_{i+1}} + \frac{1}{2} \left( \mathtt{\alpha_{i+1}} \right)^{2}} + \frac{\mathtt{f_{i-1}} \mathtt{\alpha_{i+1}}}{2 \left(  - \frac{1}{2} \mathtt{\alpha_{i-1}} + \frac{1}{2} \mathtt{\alpha_{i+1}} \right) \mathtt{\alpha_{i-1}}}\\
\mathtt{f^{(2)}_{i}} = \frac{2 \mathtt{f_{i}}}{\mathtt{\alpha_{i-1}} \mathtt{\alpha_{i+1}}} + \frac{\mathtt{f_{i+1}}}{ - \frac{1}{2} \mathtt{\alpha_{i-1}} \mathtt{\alpha_{i+1}} + \frac{1}{2} \left( \mathtt{\alpha_{i+1}} \right)^{2}} + \frac{ - 2 \mathtt{f_{i-1}}}{ - \left( \mathtt{\alpha_{i-1}} \right)^{2} + \mathtt{\alpha_{i-1}} \mathtt{\alpha_{i+1}}}
\end{equation}

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



## Equations Solved (With Truncation Error)



## Knowns

α_k[1], α_k[2],f_k[1], f_k[2], f_k[3]

## Unknowns

Symbolics.Num[fʲ_i[1], fʲ_i[2]]

## First derivative



## First derivative Truncation



## Second derivative



## Second derivative Truncation



import Base.kron

# (A ⊗ B)×vec(X) = vec(BXAᵀ)
function kron(A :: AbstractLinearOperator, B :: AbstractLinearOperator)
  m, n = size(A)
  p, q = size(B)
  T = promote_type(eltype(A), eltype(B))
  function prod(x)
    X = reshape(x, q, n)
    return full(B * X * A.')[:]
  end
  function tprod(x)
    X = reshape(x, p, m)
    return full(B.' * X * A)[:]
  end
  function ctprod(x)
    X = reshape(x, p, m)
    return full(B' * X * conj(A))[:]
  end
  symm = issymmetric(A) && issymmetric(B)
  herm = ishermitian(A) && ishermitian(B)
  return LinearOperator{T}(m * p, n * q, symm, herm, prod, tprod, ctprod)
end

kron(A :: AbstractMatrix, B :: AbstractLinearOperator) =
    kron(LinearOperator(A), B)

kron(A :: AbstractLinearOperator, B :: AbstractMatrix) =
    kron(A, LinearOperator(B))

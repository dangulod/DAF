#' Compute the Internal Rate of Return (IRR) of a bond
#'
#' @param n nominal
#' @param y years to maturity
#' @param c coupn
#' @param d days after the issue
#' @param p Net present value
#'
#' @return
#' @export
#'
#' @examples
tir  = function(n = n, y = y, c = c, d = d, p = p) {

  # funcion que calcula la tir en tanto por ciento de un bono (el valor de i que hace 0 el van)
  # n es el nomial del bono
  # y el numero de años del bono, se considera act / 365
  # cupon del bono en tanto por uno
  # dias desde que se pago/emitio el cupon
  # precio del bono

  van = function(i = i, n = n, y = y, c = c, d = d, p = p) {

    days = c(0, seq(from = 365 - d, by = 365, length.out = y) / 365)
    flows = c(-p, rep(n * c, y - 1), n * c + n)

    van = abs(sum(flows / (1 + i) ^ days))

    return(van)
  }

  tir = optimize(van, c(-1, 1), n = n, y = y, c = c, d = d, p = p, tol = 1e-9)$minimum * 100

  return(tir)
}

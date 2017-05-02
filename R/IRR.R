#' Compute the Internal Rate of Return (IRR) of an annual coupon payment bond
#'
#' @param nominal nominal of the bond
#' @param Mat_Date maturity date
#' @param coupon coupon in percentage of nominal
#' @param Buy_Date Date of buy, with %Y-%m-%d format
#' @param price bond price at the buy date
#'
#' @return IRR of the bond
#' @export
#'
#' @examples
irr = function(nominal = nominal, Mat_Date = Mat_Date, coupon = coupon, Buy_Date = Buy_Date, price = price) {

  if (all(is.na(as.Date(as.character(Mat_Date),format="%Y-%m-%d")))) {

    stop("Mat_Date argument should be a Date with %Y-%m-%d format")

  }

  if (all(is.na(as.Date(as.character(Buy_Date),format="%Y-%m-%d")))) {

    stop("Buy_Date argument should be a Date with %Y-%m-%d format")

  }

  Mat_Date = as.Date(Mat_Date)
  Buy_Date = as.Date(Buy_Date)

  van = function(i = i, n = n, Buy_Date = Buy_Date, c = c, Mat_Date = Mat_Date, p = p) {

    y = as.numeric(floor((Mat_Date - Buy_Date) / 365.25))
    Cou_Date = seq(from = Mat_Date, by = paste("-", y, " years", sep = ""), length.out = 2)[2]
    d = as.numeric(Cou_Date - Buy_Date) / 365

    if (y != 1) {

      for (j in 1:(y - 1)) {
        d[length(d) + 1] = j + d[1]
      }
    } else {
      for (j in 1:1) {
        d[length(d) + 1] = j + d[1]
      }
    }

    if(d[1] != 0) {d = c(0, d)}

    flows = c(-p, rep(c * n, length(d) - 1))
    flows[length(flows)] = flows[length(flows)] + n

    van = abs(sum(flows / ((1 + i) ^ d)))

    return(van)
  }

  irr = optimize(van, c(-1, 1), n = nominal, Buy_Date = Buy_Date, c = coupon, Mat_Date = Mat_Date, p = price, tol = 1e-16)$minimum * 100
  irr = round(irr, 6)

  return(irr)
}

#
#
# nominal = 1e4
# coupon = 0.08
# price = 10000
#
# i = irr(nominal = 1e4,
#     Mat_Date = "2004-12-31",
#     Buy_Date = "2003-12-31",
#     coupon = 0.09,
#     price = 10000) / 100
#
# n = nominal
# c = coupon
# p = price
#
# Mat_Date = "2004-12-31"
# Buy_Date = "2003-09-30"
#
# Mat_Date = as.Date(Mat_Date)
# Buy_Date = as.Date(Buy_Date)
#
# y = as.numeric(floor((Mat_Date - Buy_Date) / 365.25))
# Cou_Date = seq(from = Mat_Date, by = paste("-", y, " years", sep = ""), length.out = 2)[2]
# d = as.numeric(Cou_Date - Buy_Date) / 365
#
# for (i in 1:(y-1)) {
#   d[length(d) + 1] = i + d[1]
# }
#
# if(d[1] != 0) {d = c(0, d)}
#
# flows = c(-p, rep(c * n, length(d) - 1))
# flows[length(flows)] = flows[length(flows)] + n

#' Compute the Internal Rate of Return (IRR) of an annual coupon payment bond
#'
#' @param nominal nominal of the bond
#' @param Mat_Date maturity date
#' @param coupon coupon in percentage of nominal
#' @param Buy_Date Date of buy, with %Y-%m-%d format
#' @param price bond price at the buy date
#'
#' @return
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

  Mat_Date = as.Date(Buy_Date)
  Buy_Date = as.Date(Buy_Date)
  y = as.numeric(floor((Mat_Date - Buy_Date) / 365.25))
  Cou_Date = seq(from = Mat_Date, by = paste("-", y + 1, " years", sep = ""), length.out = 2)[2]
  d = as.numeric(Buy_Date - Cou_Date)

  van = function(i = i, n = n, y = y, c = c, d = d, p = p) {

    days = c(0, seq(from = 365 - d, by = 365, length.out = y) / 365)
    flows = c(-p, rep(n * c, y - 1), n * c + n)

    van = abs(sum(flows / (1 + i) ^ days))

    return(van)
  }

  irr = optimize(van, c(-1, 1), n = nominal, y = y, c = coupon, d = d, p = price, tol = 1e-9)$minimum * 100

  return(irr)
}

sr <- function() {
  pass
}

rad_to_deg <- function(x) {
  x * 180 / pi
}

slice <- function(theta, points = 100, gp_top = NULL, gp_bottom = NULL,
                  gp_arc = NULL, gp_fill = NULL) {
  thetas <- seq(0, theta, length.out = points)
  x <- cos(thetas)
  y <- sin(thetas)
  arc <- polylineGrob(x = x, y = y, gp = gp_arc)
  bottom_line <- polylineGrob(x = c(0, 1), y = c(0, 0), gp = gp_bottom)
  top_line <- polylineGrob(x = c(0, x[points]), y = c(0, y[points]),
                           gp = gp_top)
  fill <- polygonGrob(x = c(0, x), y = c(0, y), gp = gp_fill)
  gTree(children = gList(arc, bottom_line, top_line, fill))
}



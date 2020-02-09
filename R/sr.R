sr <- function() {
  pass
}

rad_to_deg <- function(x) {
  x * 180 / pi
}

slice2 <- function(theta, theta_0 = 0, points = 100, gp_top = NULL, gp_bottom = NULL,
                  gp_arc = NULL, gp_fill = NULL) {

  thetas <- seq(theta_0, theta + theta_0, length.out = points)
  x <- cos(thetas)
  y <- sin(thetas)
  arc <- polylineGrob(x = x, y = y, gp = gp_arc)
  bottom_line <- polylineGrob(x = c(0, x[1]), y = c(0, y[1]), gp = gp_bottom)
  top_line <- polylineGrob(x = c(0, x[points]), y = c(0, y[points]),
                           gp = gp_top)
  fill <- polygonGrob(x = c(0, x), y = c(0, y), gp = gp_fill)
  gTree(children = gList(arc, bottom_line, top_line, fill))
}

slice_1poly <- function(theta, theta_0 = 0, gp = NULL) {

  thetas <- seq(theta_0, theta + theta_0, length.out = points)
  x <- cos(thetas)
  y <- sin(thetas)
  arc <- polylineGrob(x = x, y = y, gp = gp_arc)
  bottom_line <- polylineGrob(x = c(0, x[1]), y = c(0, y[1]), gp = gp_bottom)
  top_line <- polylineGrob(x = c(0, x[points]), y = c(0, y[points]),
                           gp = gp_top)
  fill <- polygonGrob(x = c(0, x), y = c(0, y), gp = gp_fill)
  gTree(children = gList(arc, bottom_line, top_line, fill))
}

centered_slice <- function(theta, theta_0 = 0, radius = 0.5, gp = NULL,
                           n_points = 100) {
  thetas <- seq(theta_0, theta + theta_0, length.out = n_points)
  x <- radius * cos(thetas) + 0.5
  y <- radius * sin(thetas) + 0.5
  x_0 <- 0.5  # tip of the slice
  y_0 <- 0.5  # tip of the slice
  polygonGrob(x = c(x_0, x), y = c(y_0, y), gp = gp)
}

#' Draw a slice
#'
#' @param theta
#' @param theta_0
#' @param x_0
#' @param y_0
#' @param radius
#' @param gp
#' @param n_points
#'
#' @return
#' @export
#'
#' @import ggplot2
#' @import grid
pie_slice <- function(theta, theta_0 = 0, x_0 = 0.5, y_0 = 0.5, radius = 0.5, gp = NULL,
                           n_points = 100) {
  # browser()
  thetas <- seq(theta_0, theta + theta_0, length.out = n_points)
  x <- radius * cos(thetas) + x_0
  y <- radius * sin(thetas) + y_0
  polygonGrob(x = c(x_0, x), y = c(y_0, y), gp = gp)
}

pie_slices <- function(data, gp = NULL, n_points = 100) {
  # browser()
  slice_list <- do.call(gList, apply(data, 1, function(x)  {
    pie_slice(as.numeric(x[["theta"]]), as.numeric(x[["theta_0"]]),
      gp = gpar(col = x[["colour"]], fill = x[["fill"]],
                alpha = x[["alpha"]], lwd = x[["size"]]),
      radius = as.numeric(x[["radius"]]), n_points = n_points)
  }))
  gTree(children = slice_list)
}

setup_pie_data <- function(data, params) {
  if (nrow(data) == 1) {
    data$theta_0 <- 0
    return(data)
  }

  data <- transform(data, theta_0 = c(0, cumsum(theta[1:(nrow(data)-1)])))
  data
}

GeomPie <- ggproto("GeomPie", Geom,
   required_aes = c("theta"),
   default_aes = aes(x = 0, y = 0, colour = 'black', alpha = 1, size = 1,
                     radius = .45, fill = "#EDB270"),  # fill is pie crust
   setup_data = setup_pie_data,
   draw_key = draw_key_rect,
   draw_group = function(data, panel_params, coord) {
     # browser()
     coords <- coord$transform(data, panel_params)
     out <- pie_slices(coords)
     out
   }
)

#' Draw a pie chart
#'
#' @param mapping
#' @param data
#' @param stat
#' @param position
#' @param na.rm
#' @param show.legend
#' @param inherit.aes
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
geom_pie <- function(mapping = NULL, data = NULL, stat = "pie_rescale",
                    position = "identity", na.rm = FALSE, show.legend = NA,
                    inherit.aes = TRUE, ...) {
  layer(
    geom = GeomPie, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

StatPieRescale <- ggproto(
  "StatPieRescale",
  Stat,
  required_aes = "theta",
  compute_panel = function(data, scales) {
    data$theta = data$theta * 2*pi / sum(data$theta)
    data
  }
)

stat_pie_rescale <- function(mapping = NULL, data = NULL,
                             position = "identity", na.rm = FALSE, show.legend = NA,
                             inherit.aes = TRUE, ...) {
  layer()
}


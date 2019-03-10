StatMeanLine <- ggproto("StatMeanLine", Stat,
  compute_group = function(data, scales) {
    transform(data, yintercept=mean(y))
  },
  required_aes = c("x", "y")
)

stat_mean_line <- function(mapping = NULL, data = NULL, geom = "hline",
  position = "identity", na.rm = FALSE, show.legend = NA, 
  inherit.aes = TRUE, ...) {
  layer(
    stat = StatMeanLine, data = data, mapping = mapping, geom = geom, 
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}
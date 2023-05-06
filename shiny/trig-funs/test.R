library(tidyverse)
library(ggforce)

theme_set(theme_bw())

# axes limits
xlim = 1.5
ylim = 1.5
step = .5

# funcs
funcs = c("sin", "cos", "sec", "csc", "tan", "cot")

# set colors
colors = list(
  sin = "red",
  cos = "blue",
  sec = "magenta",
  csc = "cyan",
  tan = "gold",
  cot = "orange"
)


# calculate trig funs
input = 300
phi = NISTunits::NISTdegTOradian(input)
cosphi = cos(phi)
sinphi = sin(phi)
secphi = 1 / cos(phi)
cscphi = 1 / sin(phi)
tanphi = tan(phi)
cotphi = 1 / tan(phi)

# set coords
coords = tibble(func = factor(rep(funcs, each = 2),
                              ordered = TRUE,
                              levels = funcs),
                point = rep(c("start", "end"), times = 6),
       x = c(cosphi, cosphi, 0, cosphi, 0, 1, 0, 0, 1, 1, 0, cosphi),
       y = c(0, sinphi, 0, 0, 0, tanphi, 0, cscphi, 0, tanphi, cscphi, sinphi))

# plot circle
ggplot() +
  # axes
  geom_hline(yintercept = 0, color = "gray") +
  geom_vline(xintercept = 0, color = "gray") +
  # circle
  geom_circle(data = NULL,
              aes(x0 = 0, y0 = 0, r = 1)) +
  # raduis vector
  geom_line(data = NULL,
            aes(x = c(0, cosphi),
                y = c(0, sinphi))) +
  # sin
  geom_line(data = coords,
            aes(x = x,
                y = y,
                color = func)) +
  # dot
  geom_point(data = NULL,
             aes(x = cosphi,
                 y = sinphi)) +
  scale_x_continuous(breaks = seq(-xlim, xlim, by = step)) +
  scale_y_continuous(breaks = seq(-ylim, ylim, by = step)) +
  labs(x = NULL, y = NULL) +
  coord_fixed(xlim = c(-xlim, xlim),
                  ylim = c(-ylim, ylim)) +
  theme(legend.position = "bottom") +
  scale_color_manual(values = unlist(colors))


# plot graphs
tibble(x = seq(-5, 5, by = 0.01),
      sin = sin(x),
      cos = cos(x),
      sec = ifelse(abs(cos) < 1e-3, NA, 1/cos),
      csc = ifelse(abs(sin) < 1e-3, NA, 1/sin),
      tan = ifelse(abs(cos) < 1e-3, NA, sin/cos),
      cot = ifelse(abs(sin) < 1e-3, NA, cos/sin)) |> 
  pivot_longer(cols = -x) -> graphs

ggplot(data = graphs,
       aes(x)) +
  geom_vline(xintercept = 0, color = "gray") +
  geom_hline(yintercept = 0, color = "gray") +
  geom_line(aes(y = value, color = name)) +
  xlim(-5, 5) +
  coord_cartesian(ylim = c(-3, 3)) +
  scale_color_manual(values = unlist(colors)) +
  theme(legend.position = "bottom")
  
  
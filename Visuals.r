# ============================================
# Bipartite (user-item) 5-core visualization
# 3 colors, circles only, zoomed to core
# ============================================

library(igraph)
library(tidygraph)
library(ggraph)
library(ggplot2)
library(dplyr)

set.seed(42)

# ---- 1) Simulate bipartite user-item graph ----
n_users <- 80
n_items <- 70

# Sparse bipartite backbone
p_sparse <- 0.02
g <- sample_bipartite(n1 = n_users, n2 = n_items, p = p_sparse, directed = FALSE)

# Label node types
V(g)$type <- c(rep("user", n_users), rep("item", n_items))

# Add a denser pocket so a visible 5-core exists (for demo)
dense_users <- 1:25
dense_items <- (n_users + 1):(n_users + 25)

extra_edges <- 250
for(i in 1:extra_edges){
  u <- sample(dense_users, 1)
  v <- sample(dense_items, 1)
  if(!are.connected(g, u, v)){
    g <- add_edges(g, c(u, v))
  }
}

# ---- 2) Coreness + 5-core membership ----
core_num <- coreness(g)
V(g)$core_num <- core_num
V(g)$in_k5 <- core_num >= 5

# ---- 3) 3-way grouping for node colors ----
V(g)$group <- ifelse(
  V(g)$in_k5 == FALSE, "Sparse nodes (k < 5)",
  ifelse(V(g)$type == "user",
         "Users in 5-core (k ≥ 5)",
         "Items in 5-core (k ≥ 5)")
)

# ---- 4) Convert to tidygraph ----
tg_full <- as_tbl_graph(g)

# ---- 5) Create layout ONCE so we can zoom ----
layout_fn <- "fr"
lay <- create_layout(tg_full, layout = layout_fn)

# Identify k-core nodes in the layout
core_idx <- which(lay$in_k5)

# Bounding box around k-core nodes
x_core <- lay$x[core_idx]
y_core <- lay$y[core_idx]

# Padding controls zoom level
pad <- 5   # smaller = tighter zoom, larger = more context
xlim_core <- range(x_core) + c(-pad, pad)
ylim_core <- range(y_core) + c(-pad, pad)

# ---- 6) Node sizes + edge styling ----
NODE_SIZE_SPARSE <- 3.0
NODE_SIZE_CORE   <- 4.2

EDGE_ALPHA <- 0.25
EDGE_WIDTH <- 0.25
EDGE_COLOR <- "grey40"

# ---- 7) Plot (zoomed to core) ----
p_bipartite_colored_zoom <- ggraph(lay) +
  geom_edge_link(
    alpha = EDGE_ALPHA,
    linewidth = EDGE_WIDTH,
    colour = EDGE_COLOR
  ) +
  geom_node_point(
    aes(
      colour = group,
      size   = ifelse(in_k5, NODE_SIZE_CORE, NODE_SIZE_SPARSE)
    )
  ) +
  scale_size_identity() +
  scale_colour_manual(
    values = c(
      "Sparse nodes (k < 5)"        = "#A9D6E5",  # light blue
      "Users in 5-core (k ≥ 5)"     = "#F4A261",  # light orange
      "Items in 5-core (k ≥ 5)"     = "#B7E4C7"   # light green
    )
  ) +
  coord_cartesian(xlim = xlim_core, ylim = ylim_core) +
  theme_void(base_size = 14) +
  theme(
    legend.position   = "right",
    legend.title      = element_blank(),
    legend.text       = element_text(size = 12),
    legend.key        = element_rect(fill = "white", colour = NA),
    legend.key.size   = unit(0.8, "cm"),
    legend.spacing.y  = unit(0.3, "cm"),
    panel.background  = element_rect(fill = "white", colour = NA),
    plot.background   = element_rect(fill = "white", colour = NA)
  ) +
  guides(
    colour = guide_legend(override.aes = list(size = 5, alpha = 1))
  ) +
  ggtitle("Zoomed View: Dense (5,5)-Core Region")

# Show in RStudio
p_bipartite_colored_zoom

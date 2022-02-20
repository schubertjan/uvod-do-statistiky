source("../scr/battleship.r")

# data shell
set.seed(42)
S <- 5e5
dims <- c(8, 8)
G <- matrix(NA, nrow = S, ncol = dims[1] * dims[2])
colnames(G) <- as.vector(sapply(LETTERS[1:8], function(i) paste0(i, 1:8)))
no_converge <- 0

start_t <- Sys.time()
# play
for (s in 1:S) {
  tryCatch(
    {
      g <- game()
      g_flat <- as.vector(t(g))
      G[s, ] <- g_flat
    },
    error = function(e) {
      no_converge <<- no_converge + 1
    }
  )
}
end_t <- Sys.time()
end_t - start_t
no_converge / S
G <- G[complete.cases(G), ]
# write.csv(G, "../dats/battleship.csv", row.names = FALSE)


# binarize
G_bin <- G
G_bin[G_bin > 0] <- 1

s <- nrow(G_bin)
cetnost <- colSums(G_bin)
rel_cetnost <- cetnost / s

# to tidy
df <- as.data.frame(rel_cetnost)
df$cell <- rownames(df)
df$y <- substr(df$cell, start = 0, stop = 1)
df$y <- sort(rep(which(LETTERS %in% df$y), dims[1]))
df$x <- substr(df$cell, start = 2, stop = 3)
df$y <- as.numeric(df$y)
df$x <- as.numeric(df$x)

# plot
library(ggplot2)
ggplot(df) +
  geom_tile(aes(x = x, y = y, fill = rel_cetnost)) +
  scale_fill_distiller(palette = "Spectral")
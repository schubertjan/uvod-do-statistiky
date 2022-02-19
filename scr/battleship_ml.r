source("../scr/battleship.r")

# data shell
set.seed(42)
S <- 20000
dims <- c(8, 8)
G <- matrix(NA, nrow = S, ncol = dims[1] * dims[2])
colnames(G) <- as.vector(sapply(LETTERS[1:8], function(i) paste0(i, 1:8)))

# play
for(s in 1:S) {
  tryCatch({
    g <- game()
    g_flat <- as.vector(t(g))
    G[s, ] <- g_flat 
  }, error = function(e) {})  
}
# throw away games that did not converge
G <- G[complete.cases(G), ]
# binarize
G_bin <- data.table::as.data.table(G)
G_bin[G_bin > 0] <- 1

# fit a model
m1 <- glm(A1 ~ ., data = G_bin, family = binomial(link = "logit"))
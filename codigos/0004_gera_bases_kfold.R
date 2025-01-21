################################################################################
############# cria base para k-fold cross validation ###########################
################################################################################
library(dplyr)
library(ggplot2)
#setwd("../Subcooled_CHF/dados/")

dados_modelagem = read.csv("dados_modelagem_2.csv")

# Number of folds for cross-validation
k <- 10

bases_dados_treino = list()
bases_dados_teste = list()

# Create indices for k-fold cross-validation
set.seed(123) # Set seed for reproducibility
folds <- cut(seq(1, nrow(dados_modelagem)), breaks = k, labels = FALSE)

# Perform k-fold cross-validation
for (i in 1:k) {
  # Create training and testing sets for this fold
  test_indices <- which(folds == i)
  
  dados_treino <- dados_modelagem[-test_indices, ]
  dados_teste <-  dados_modelagem[test_indices, ]
  
  bases_dados_treino[[i]] = dados_treino
  bases_dados_teste[[i]] = dados_teste
}


saveRDS(bases_dados_treino,"dados_treinamento_2.rds")
saveRDS(bases_dados_teste,"dados_teste_2.rds")

library(dplyr)
library(ggplot2)

# dados groeneveld
dados_groenveld = read.csv("codigos/base_modelagem_groenveld.csv")
dados_groenveld = dados_groenveld %>%
  select(
    P_kpa,
    G,
    X_chf,
    D_mm,
    L_mm,
    CHF
  )

colnames(dados_groenveld) = c("P","G","X","D","L","CHF")

# dados zhao

dados_zhao = read.csv("codigos/dados_modelagem_zhao.csv")

dados_zhao = dados_zhao %>%
  select(P_kpa,
         mass_flux_kg_m2_s,
         x_e_out,
         d_h_mm,
         length_mm,
         CHF
         )

colnames(dados_zhao) = c("P","G","X","D","L","CHF")

# dados inasaka

dados_inasaka = read.csv("codigos/dados_modelagem_inasaka.csv")

dados_inasaka = dados_inasaka %>%
  select(
    P_kpa,
    G_kg_m2s,
    X_o,
    D_mm,
    L_mm,
    CHF
  )

colnames(dados_inasaka) = c("P","G","X","D","L","CHF")

# dados mudawar

dados_mudawar = read.csv("codigos/dados_modelagem_mudawar.csv")

dados_mudawar = dados_mudawar %>%
  select(
    P_kpa,
    G,
    X_o,
    D_mm,
    L_mm,
    CHF
  )

colnames(dados_mudawar) = c("P","G","X","D","L","CHF")


# junta as bases de dados

dados_modelagem = rbind(dados_groenveld,
                        dados_inasaka,
                        dados_mudawar,
                        dados_zhao)

# reordena a base aleatoriamente
set.seed(123)
dados_modelagem = sample(dados_modelagem,replace = FALSE)

write.csv(dados_modelagem,"dados_modelagem.csv",row.names = FALSE)

# separa base em treino e teste

dados_modelagem["id"] = seq(1,nrow(dados_modelagem))

set.seed(123)

base_treino = dados_modelagem %>%
  dplyr::slice_sample(prop = 0.9)

base_teste = dplyr::anti_join(dados_modelagem,
                              base_treino,
                              by = "id") 


write.csv(base_treino,"base_treino.csv",row.names = FALSE)
write.csv(base_teste,"base_teste.csv",row.names = FALSE)


base_treino = read.csv("dados/base_treino.csv")
base_teste = read.csv("dados/base_teste.csv")
base_modelagem = rbind(base_treino,base_teste)

# Number of folds for cross-validation
k <- 10

bases_dados_treino = list()
bases_dados_teste = list()

# Create indices for k-fold cross-validation
set.seed(123) # Set seed for reproducibility
folds <- cut(seq(1, nrow(base_modelagem)), breaks = k, labels = FALSE)

# Perform k-fold cross-validation
for (i in 1:k) {
  # Create training and testing sets for this fold
  test_indices <- which(folds == i)
  
  dados_treino <- base_modelagem[-test_indices, ]
  dados_teste <-  base_modelagem[test_indices, ]
  
  bases_dados_treino[[i]] = dados_treino
  bases_dados_teste[[i]] = dados_teste
}

saveRDS(bases_dados_treino,"dados/dados_treinamento.rds")
saveRDS(bases_dados_teste,"dados/dados_teste.rds")

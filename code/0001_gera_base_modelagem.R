################################################################################
######### GERA BASE DE MODELAGEM PARA OS ESTUDOS  ##############################
################################################################################

#setwd("../Subcooled_CHF/dados/")

library(dplyr)
library(ggplot2)

# dados groeneveld

dados_groenveld = read.csv("../dados/base_modelagem_groenveld.csv")

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



dados_groenveld["fonte"] = "groeneveld"

# dados zhao

dados_zhao = read.csv("../dados/dados_modelagem_zhao.csv")

dados_zhao = dados_zhao %>%
  select(P_kpa,
         mass_flux_kg_m2_s,
         x_e_out,
         d_h_mm,
         length_mm,
         CHF
         )

colnames(dados_zhao) = c("P","G","X","D","L","CHF")

dados_zhao["fonte"] = "zhao"

# dados inasaka

dados_inasaka = read.csv("../dados/dados_modelagem_inasaka.csv")

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

dados_inasaka["fonte"] = "inasaka"



# junta as bases de dados

dados_modelagem = rbind(dados_groenveld,
                        dados_inasaka,
                        dados_zhao)

# remove duplicatas da base 

duplicates <- dados_modelagem |>
  group_by(CHF,P,G,X,D,L) |>
  filter(n() > 1) |>
  ungroup()

duplicate_counts <- dados_modelagem |>
  add_count(CHF,P,G,X,D,L) |>
  filter(n > 1) |>
  distinct()


dados_modelagem = dados_modelagem[!(dados_modelagem %>% 
  select(CHF,P,G,X,D,L) %>%
  duplicated()),]

# seleciona base de validacao

dados_out_groen = dados_modelagem %>%
  filter(fonte != "groeneveld")

set.seed(123)

indices_dados_validacao = sample(x =seq(1,nrow(dados_out_groen)),size = 100, replace = FALSE)

dados_validacao = dados_out_groen[indices_dados_validacao,]

dados_modelagem_out_groen  = dados_out_groen[-indices_dados_validacao,]

dados_modelagem_inicial = rbind(dados_modelagem %>% filter(fonte == "groeneveld"),
                              dados_modelagem_out_groen)


# reordena a base aleatoriamente
set.seed(123)
dados_modelagem_inicial = sample(dados_modelagem_inicial,replace = FALSE)


# salva bases
write.csv(dados_modelagem_inicial,"dados_modelagem_inicial.csv",row.names = FALSE)
write.csv(dados_validacao,"dados_validacao.csv",row.names = FALSE)




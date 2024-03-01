#install.packages("pdftools")
#install.packages("stringr")

library(pdftools)
library(stringr)
library(dplyr)

# pdf com dados groeneveld
dados_m <- pdf_text("../Subcooled_CHF/dados/dados_mudawar.pdf")

# numero de paginas no pdf
length(dados_m)

dados_pagina = dados_m[10]
dados_pagina <- strsplit(dados_pagina, "\n")
dados_pagina <- dados_pagina[[1]]
dados_pagina <- trimws(dados_pagina)
dados_pagina = dados_pagina[4:length(dados_pagina)]

tabela_pagina <- str_split_fixed(dados_pagina, " {1,}", 11)
df_groeneveld = data.frame(tabela_pagina)
colnames(df_groeneveld) = c("Number","Data","D_m","L_m","P_kpa","G","X_chf","DH_in","CHF","T_in","Reference")


# faz limpeza dos dados transformando as paginas em um data.frame


for (pagina in seq(1,length(dados_groeneveld))){
  
  if(pagina == 1){
    
    dados_pagina <- dados_groeneveld[pagina]
    dados_pagina <- strsplit(dados_pagina, "\n")
    dados_pagina <- dados_pagina[[1]]
    dados_pagina <- trimws(dados_pagina)
    dados_pagina = dados_pagina[4:length(dados_pagina)]
    
    tabela_pagina <- str_split_fixed(dados_pagina, " {1,}", 11)
    df_groeneveld = data.frame(tabela_pagina)
    colnames(df_groeneveld) = c("Number","Data","D_m","L_m","P_kpa","G","X_chf","DH_in","CHF","T_in","Reference")
    
    
  } 
  
  if ((pagina > 1) & (pagina <= 263)) {
    
    dados_pagina <- dados_groeneveld[pagina]
    dados_pagina <- strsplit(dados_pagina, "\n")
    dados_pagina <- dados_pagina[[1]]
    dados_pagina <- trimws(dados_pagina)
    
    tabela_pagina <- str_split_fixed(dados_pagina, " {1,}", 11)
    df_pagina_2 = data.frame(tabela_pagina)
    colnames(df_pagina_2) = c("Number","Data","D_m","L_m","P_kpa","G","X_chf","DH_in","CHF","T_in","Reference")
    
    
    df_groeneveld = rbind(df_groeneveld,df_pagina_2)
    
    
  }
  
  if ((pagina >= 264) & (pagina < 269)) {
    
    dados_pagina <- dados_groeneveld[pagina]
    dados_pagina <- strsplit(dados_pagina, "\n")
    dados_pagina <- dados_pagina[[1]]
    dados_pagina <- trimws(dados_pagina)
    dados_pagina = gsub(" 0 ","",dados_pagina)
    
    tabela_pagina <- str_split_fixed(dados_pagina, " {1,}", 11)
    df_pagina_2 = data.frame(tabela_pagina)
    colnames(df_pagina_2) = c("Number","Data","D_m","L_m","P_kpa","G","X_chf","DH_in","CHF","T_in","Reference")
    
    
    df_groeneveld = rbind(df_groeneveld,df_pagina_2)
    
    
  }
  
  if ((pagina == 269)) {
    dados_pagina <- dados_groeneveld[pagina]
    dados_pagina <- strsplit(dados_pagina, "\n")
    dados_pagina <- dados_pagina[[1]]
    dados_pagina <- trimws(dados_pagina)
    dados_pagina = dados_pagina[1:30]
    dados_pagina = gsub(" 0 "," ",dados_pagina)
    tabela_pagina_1 <- str_split_fixed(dados_pagina, " {1,}", 11)
    
    dados_pagina <- dados_groeneveld[pagina]
    dados_pagina <- strsplit(dados_pagina, "\n")
    dados_pagina <- dados_pagina[[1]]
    dados_pagina <- trimws(dados_pagina)
    dados_pagina = dados_pagina[31:length(dados_pagina)]
    tabela_pagina_2 <- str_split_fixed(dados_pagina, " {1,}", 11)
    
    tabela_pagina = rbind(tabela_pagina_1,tabela_pagina_2)
    
    df_pagina_2 = data.frame(tabela_pagina)
    colnames(df_pagina_2) = c("Number","Data","D_m","L_m","P_kpa","G","X_chf","DH_in","CHF","T_in","Reference")
    
    
    df_groeneveld = rbind(df_groeneveld,df_pagina_2)
    
    
  }
  
  
  if ((pagina > 269) ) {
    
    dados_pagina <- dados_groeneveld[pagina]
    dados_pagina <- strsplit(dados_pagina, "\n")
    dados_pagina <- dados_pagina[[1]]
    dados_pagina <- trimws(dados_pagina)
    
    tabela_pagina <- str_split_fixed(dados_pagina, " {1,}", 11)
    df_pagina_2 = data.frame(tabela_pagina)
    colnames(df_pagina_2) = c("Number","Data","D_m","L_m","P_kpa","G","X_chf","DH_in","CHF","T_in","Reference")
    
    
    df_groeneveld = rbind(df_groeneveld,df_pagina_2)
    
    
  }
  
  
  
}

#numero de linhas

nrow(df_groeneveld)

# remove NA na linha
df_groeneveld = na.omit(df_groeneveld)
nrow(df_groeneveld)


# transforma coluna de numero de linha em numerico

df_groeneveld = transform(df_groeneveld, Number = as.numeric(Number))


# substitui "" das colunas por NA para identificar dados restritos

df_groeneveld[df_groeneveld == ""] = NA

# confirma dados proprietarios indisponiveis 

restritos = df_groeneveld[!complete.cases(df_groeneveld), ]
restritos

# remove dados restritos

df_groeneveld = df_groeneveld[complete.cases(df_groeneveld), ]

# remove coluna Data nao é necessario

df_groeneveld = df_groeneveld %>%
  select(-Data)


# descritivo de dados por referencia para verificar se a tratativa deu certo

referencias = df_groeneveld %>%
  group_by(Reference) %>%
  count() %>%
  arrange(desc(n))

# converte strings em numerico

df_groeneveld = df_groeneveld %>%
  mutate_at(c("Number","D_m","L_m","P_kpa","G","X_chf","DH_in","CHF","T_in"),as.numeric)


# converte dimensoes em milimetros

df_groeneveld["D_mm"] = df_groeneveld$D_m*1000
df_groeneveld["L_mm"] = df_groeneveld$L_m*1000


# gera csv com base tratada

write.csv2(df_groeneveld,file = "dados_groeneveld.csv")











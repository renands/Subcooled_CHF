dados = read.csv("../dados/dados_modelagem_inicial.csv")
library(GGally)

summary(dados)

sd(dados$P)
sd(dados$G)
sd(dados$X)
sd(dados$D)
sd(dados$L)
sd(dados$CHF)

# plot 2 a 2 das variaveis
plot_pair = dados %>%
  dplyr::select(D,
                L,
                P,
                G,
                X,
                CHF
  ) %>%
  ggpairs(upper = list(continuous = wrap(ggally_cor, display_grid = FALSE)),
          lower = list(continuous = wrap("points",
                                         color = "navy",
                                         alpha = 1/10,
                                         size = 0.1)),
          proportions = "auto") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

plot_pair


jpeg("../dados/dados_pares_modelagem.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
plot_pair
dev.off()


dados$Source = dados$fonte
dados[dados$fonte == "groeneveld","Source"] = "Groeneveld"
dados[dados$fonte == "inasaka","Source"] = "Inasaka"
dados[dados$fonte == "zhao","Source"] = "Zhao"

  


# pressao



p = ggplot(dados,aes(x = P,y = CHF,groups = Source)) +
  facet_wrap(~Source,
             scales = "free") +
  geom_point() +
  geom_smooth(aes(group=Source),method = "gam",se = FALSE)  +
  theme(legend.position="none") 


jpeg("../dados/dados_modelagem_p.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
p
dev.off()

# fluxo

g = ggplot(dados,aes(x = G,y = CHF,groups = Source)) +
  facet_wrap(~Source,
             scales = "free") +
  geom_point() +
  geom_smooth(aes(group=Source),method = "gam",se = FALSE)  +
  theme(legend.position="none") 

jpeg("../dados/dados_modelagem_g.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
g
dev.off()

# X

x = ggplot(dados,aes(x = X,y = CHF,groups = Source)) +
  facet_wrap(~Source,
             scales = "free") +
  geom_point() +
  geom_smooth(aes(group=Source),method = "gam",se = FALSE)  +
  theme(legend.position="none") 


jpeg("../dados/dados_modelagem_x.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
x
dev.off()

# diametro

d = ggplot(dados,aes(x = D,y = CHF,groups = Source)) +
  facet_wrap(~Source,
             scales = "free") +
  geom_point() +
  geom_smooth(aes(group=Source),method = "gam",se = FALSE)  +
  theme(legend.position="none") 


jpeg("../dados/dados_modelagem_d.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
d
dev.off()

# L comprimento

l = ggplot(dados,aes(x = L,y = CHF,groups = Source)) +
  facet_wrap(~Source,
             scales = "free") +
  geom_point() +
  geom_smooth(aes(group=Source),method = "gam",se = FALSE)  +
  theme(legend.position="none") 


jpeg("../dados/dados_modelagem_l.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
l
dev.off()

# grafico de densidade

library(ggplot2)
library(hrbrthemes)
library(dplyr)
library(tidyr)
library(viridis)


plot_chf = ggplot(data=dados, aes(x=CHF, group=Source, fill=Source)) +
  geom_density(adjust=1.5, alpha=.4) +
  facet_wrap(~Source,
             scales = "free") +
  theme_ipsum()   +
  scale_x_continuous(labels = scales::comma)  +
  theme(legend.position="none")  +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

plot_chf

jpeg("../dados/dados_modelagem_chf_fonte.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
plot_chf
dev.off()

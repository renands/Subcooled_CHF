dados = read.csv("../dados/dados_modelagem_2.csv")
library(GGally)
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

jpeg("../Subcooled_CHF/dados/dados_pares_modelagem.jpeg",width = 17,height = 10.51,units = "cm",res = 300)
plot_pair
dev.off()


ggplot(dados) +
  geom_density(aes(x = CHF))

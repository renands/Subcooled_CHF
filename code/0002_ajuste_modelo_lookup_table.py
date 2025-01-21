################################################################################
######### CODIGO PARA APLICAÇÃO DA LOOK UP TABLE DE PREDICAO CHF ###############
################################################################################

reticulate::repl_python()


from scipy.interpolate import LinearNDInterpolator
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import math

# leitura da base contendo a lookup table
base_chf = pd.read_csv("DADOS_CHF - CHFS_LOOK_UP_TABLE_GROENVELD.csv",
                       sep = ",",
                       decimal = ",")

base_chf.columns = ["CHF_kwm2","P_mpa","G_kgm2s1","Xchf","P_kpa"]

base_chf.drop(columns = "P_mpa",inplace = True)
# cria interpolador linear

interpolador = LinearNDInterpolator(list(zip(base_chf["P_kpa"],
base_chf["Xchf"],
base_chf["G_kgm2s1"])),                                 
base_chf["CHF_kwm2"])

# escoragem base de modelagem
base_modelagem = pd.read_csv("dados_modelagem_inicial.csv")


preds_interpolador_modelagem = interpolador(base_modelagem.P,
base_modelagem.X,
base_modelagem.G)

base_modelagem["predicoes_lookup_table"] = (
  preds_interpolador_modelagem/np.sqrt((base_modelagem.D/8))
)

base_modelagem["predicoes_lookup_table_0312"] = (
  preds_interpolador_modelagem/((base_modelagem.D/8)**(0.312))
)

base_modelagem.to_csv("dados_modelagem_2.csv",index = False)



# escoragem base de validacao
base_validacao = pd.read_csv("dados_validacao.csv")

preds_interpolador_validacao = interpolador(base_validacao.P,
base_validacao.X,
base_validacao.G)

base_validacao["predicoes_lookup_table"] = (
  preds_interpolador_validacao/np.sqrt((base_validacao.D/8))
)

base_validacao["predicoes_lookup_table_0312"] = (
  preds_interpolador_validacao/((base_validacao.D/8)**(0.312))
)

base_validacao.to_csv("dados_validacao_2.csv",index = False)


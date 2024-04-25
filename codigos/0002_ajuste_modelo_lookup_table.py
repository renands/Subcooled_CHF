################################################################################
######### CODIGO PARA APLICAÇÃO DA LOOK UP TABLE DE PREDICAO CHF ###############
################################################################################

reticulate::repl_python()


from scipy.interpolate import LinearNDInterpolator
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import math

base_chf = pd.read_csv("DADOS_CHF - CHFS_LOOK_UP_TABLE_GROENVELD.csv",
                       sep = ",",
                       decimal = ",")

base_chf.columns = ["CHF_kwm2","P_mpa","G_kgm2s1","Xchf","P_kpa"]

base_chf.drop(columns = "P_mpa",inplace = True)

interpolador = LinearNDInterpolator(list(zip(base_chf["P_kpa"],
base_chf["Xchf"],
base_chf["G_kgm2s1"])),                                 
base_chf["CHF_kwm2"])

base_modelagem = pd.read_csv("dados_modelagem_2.csv")

preds_interpolador = interpolador(base_modelagem.P,
base_modelagem.X,
base_modelagem.G)

base_modelagem["predicoes_lookup_table"] = (
  preds_interpolador/np.sqrt((base_modelagem.D/8))
)

base_modelagem["predicoes_lookup_table_0312"] = (
  preds_interpolador/((base_modelagem.D/8)**(0.312))
)

base_modelagem.to_csv("dados_modelagem_2.csv",index = False)




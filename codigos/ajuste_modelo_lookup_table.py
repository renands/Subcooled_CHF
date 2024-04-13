reticulate::repl_python()


from scipy.interpolate import LinearNDInterpolator
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import math

base_chf = pd.read_csv("dados/DADOS_CHF - CHFS_LOOK_UP_TABLE_GROENVELD.csv",
                       sep = ",",
                       decimal = ",")

base_chf.columns = ["CHF_kwm2","P_mpa","G_kgm2s1","Xchf","P_kpa"]

base_chf.drop(columns = "P_mpa",inplace = True)

interpolador = LinearNDInterpolator(list(zip(base_chf["P_kpa"],
base_chf["Xchf"],
base_chf["G_kgm2s1"])),                                 
base_chf["CHF_kwm2"])

base_treino = pd.read_csv("dados/base_treino.csv")
base_teste = pd.read_csv("dados/base_teste.csv")

preds_interpolador_treino = interpolador(base_treino.P,
base_treino.X,
base_treino.G)

preds_interpolador_teste = interpolador(base_teste.P,
base_teste.X,
base_teste.G)


base_treino["predicoes_lookup_table"] = (
  preds_interpolador_treino/np.sqrt((base_treino.D/8))
)


base_teste["predicoes_lookup_table"] = (
  preds_interpolador_teste/np.sqrt((base_teste.D/8))
)

base_treino.to_csv("dados/base_treino.csv",index = False)
base_teste.to_csv("dados/base_teste.csv",index = False)



def predict_lookup_table(data):
  
  
  from scipy.interpolate import LinearNDInterpolator
  import numpy as np
  #import matplotlib.pyplot as plt
  import pandas as pd
  import math
  
  # leitura da base contendo a lookup table
  base_chf = pd.read_csv("data/DADOS_CHF - CHFS_LOOK_UP_TABLE_GROENVELD.csv",
                         sep = ",",
                         decimal = ",")
  
  base_chf.columns = ["CHF_kwm2","P_mpa","G_kgm2s1","Xchf","P_kpa"]
  
  base_chf.drop(columns = "P_mpa",inplace = True)
  
  # cria interpolador linear
  
  interpolador = LinearNDInterpolator(list(zip(base_chf["P_kpa"],
  base_chf["Xchf"],
  base_chf["G_kgm2s1"])),                                 
  base_chf["CHF_kwm2"])
  
  preds_interpolador_modelagem = interpolador(data.P,
  data.X,
  data.G)
  
  data["CHF_PREDITO_LOOKUP_05"] = (
    preds_interpolador_modelagem/np.sqrt((data.D/8))
  )
  
  data["CHF_PREDITO_LOOKUP_0312"] = (
    preds_interpolador_modelagem/((data.D/8)**(0.312))
  )
  
  return data

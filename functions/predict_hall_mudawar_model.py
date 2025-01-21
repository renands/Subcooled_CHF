def predict_hall_mudawar_correlation(data):
  
  #!pip install pyXSteam
  #!pip install iapws
  
  from iapws import IAPWS97 as iap
  from pyXSteam.XSteam import XSteam as steam
  import pandas as pd
  import numpy as np

  steamTable = steam(steam.UNIT_SYSTEM_MKS) # m/kg/sec/°C/bar/W
  
  # constantes da correlacao de mudawar
  c1 = 0.0722
  c2 = -0.312
  c3 = -0.644
  c4 = 0.900
  c5 = 0.724
  
  data_cols = list(data.columns.values)

  print(data_cols)
  
  # converte unidades pressao kpa para bar, fluxo para 
  data["P_bar"] = (data.P/100)
  data["P_bar_mud"] = (data.P*1000)/100000
  data["G_mud"] = data.G/1000
  data["D_m"] = data.D/1000
  data["L_m"] = data.L/1000
  
  
  # calcula superficie de tensao
  data["surface_tension"] = data.P_bar.apply(lambda x: steamTable.st_p(x))
  
  # calcula densidade do liquido em saturacao
  
  data["densidade_liquido"] = data.P_bar.apply(lambda x: steamTable.rhoL_p(x))
  
  # calcula densidade do gas em saturacao
  
  data["densidade_vapor"] = data.P_bar.apply(lambda x: steamTable.rhoV_p(x))
  
  # calcula numero de weber
  
  data["weber"] = ((data.D_m) * (data.G**2)) / (data.surface_tension*data.densidade_liquido)
  
  # calcula boiling number na saida
  
  data["bo_saida"] = (
    
      c1*(data.weber**c2)*((data.densidade_liquido/data.densidade_vapor)**c3) *
      (1 - c4*((data.densidade_liquido/data.densidade_vapor)**c5)*data.X)
  
  
  )
  
  data["entapia_liquido"] = data.P_bar.apply(lambda x: steamTable.hL_p(x))
  data["entapia_vapor"] = data.P_bar.apply(lambda x: steamTable.hV_p(x))
  
  
  data["chf_saida"] = data.bo_saida*data.G*(data.entapia_vapor - data.entapia_liquido)
  
  
  data["quality_start"] = data.X - data.bo_saida*(data.L_m/data.D_m)
  
  
  
  data["bo_entrada"] = (
  
  # numerador  
  ( c1*(data.weber**c2)*((data.densidade_liquido/data.densidade_vapor)**c3) *
      (1 - c4*((data.densidade_liquido/data.densidade_vapor)**c5)*data.quality_start) )/
  
  # denominador
  (1 + 4 * c1 * c4 * (data.weber**c2) * 
  ((data.densidade_liquido/data.densidade_vapor)**(c3+c5)) * (data.D_m/data.L_m))
    
    
  )
  
  data["chf_entrada"] = data.bo_entrada*data.G*(data.entapia_vapor - data.entapia_liquido)
  
  data["l_d"] = data.L/data.D
   
  data = data[data_cols + ["chf_entrada","chf_saida"]]
  
  data = data.rename(columns = {"chf_entrada":"CHF_PREDITO_MODELO_INPUT","chf_saida":"CHF_PREDITO_MODELO_OUTPUT"})

  return data

!pip install pyXSteam
!pip install iapws

from iapws import IAPWS97 as iap
from pyXSteam.XSteam import XSteam as steam
import pandas as pd
import numpy as np

#steamTable = XSteam(XSteam.UNIT_SYSTEM_FLS) # ft/lb/sec/°F/psi/btu
#steamTable = XSteam(XSteam.UNIT_SYSTEM_BARE) # m/kg/sec/K/MPa/W


steamTable = steam(steam.UNIT_SYSTEM_MKS) # m/kg/sec/°C/bar/W

# constantes da correlacao de mudawar
c1 = 0.0722
c2 = -0.312
c3 = -0.644
c4 = 0.900
c5 = 0.724


base_treino_2 = read.csv("dados/base_treino.csv")
base_teste_2 = read.csv("dados/base_teste.csv")
base_modelagem = rbind(base_treino_2,base_teste_2)

base_treino_2 = pd.read_csv("dados/base_treino.csv",sep = ",",decimal = ".")
base_teste_2 = pd.read_csv("dados/base_teste.csv",sep = ",",decimal = ".")

df_gro = base_treino_2.append(base_teste_2)


# converte unidades pressao kpa para bar, fluxo para 
df_gro["P_bar"] = (df_gro.P/100)
df_gro["P_bar_mud"] = (df_gro.P*1000)/100000
df_gro["G_mud"] = df_gro.G/1000
df_gro["D_m"] = df_gro.D/1000
df_gro["L_m"] = df_gro.L/1000


# calcula superficie de tensao
df_gro["surface_tension"] = df_gro.P_bar.apply(lambda x: steamTable.st_p(x))

# calcula densidade do liquido em saturacao

df_gro["densidade_liquido"] = df_gro.P_bar.apply(lambda x: steamTable.rhoL_p(x))

# calcula densidade do gas em saturacao

df_gro["densidade_vapor"] = df_gro.P_bar.apply(lambda x: steamTable.rhoV_p(x))

# calcula numero de weber

df_gro["weber"] = ((df_gro.D_m) * (df_gro.G**2)) / (df_gro.surface_tension*df_gro.densidade_liquido)

# calcula boiling number na saida

df_gro["bo_saida"] = (
  
    c1*(df_gro.weber**c2)*((df_gro.densidade_liquido/df_gro.densidade_vapor)**c3) *
    (1 - c4*((df_gro.densidade_liquido/df_gro.densidade_vapor)**c5)*df_gro.X)


)

df_gro["entapia_liquido"] = df_gro.P_bar.apply(lambda x: steamTable.hL_p(x))
df_gro["entapia_vapor"] = df_gro.P_bar.apply(lambda x: steamTable.hV_p(x))


df_gro["chf_saida"] = df_gro.bo_saida*df_gro.G*(df_gro.entapia_vapor - df_gro.entapia_liquido)


df_gro["quality_start"] = df_gro.X - df_gro.bo_saida*(df_gro.L_m/df_gro.D_m)



df_gro["bo_entrada"] = (

# numerador  
( c1*(df_gro.weber**c2)*((df_gro.densidade_liquido/df_gro.densidade_vapor)**c3) *
    (1 - c4*((df_gro.densidade_liquido/df_gro.densidade_vapor)**c5)*df_gro.quality_start) )/

# denominador
(1 + 4 * c1 * c4 * (df_gro.weber**c2) * 
((df_gro.densidade_liquido/df_gro.densidade_vapor)**(c3+c5)) * (df_gro.D_m/df_gro.L_m))
  
  
)

df_gro["chf_entrada"] = df_gro.bo_entrada*df_gro.G*(df_gro.entapia_vapor - df_gro.entapia_liquido)

df_gro["l_d"] = df_gro.L/df_gro.D
 
resultados = df_gro[["CHF","chf_saida","chf_entrada","bo_entrada","bo_saida","X","quality_start","l_d","P_bar"]]







!pip install pyXSteam
!pip install iapws

from iapws import IAPWS97 as iap
from pyXSteam.XSteam import XSteam as steam
import pandas as pd
import numpy as np


steamTable = XSteam(XSteam.UNIT_SYSTEM_BARE)

# constantes da correlacao de mudawar
c1 = 0.0722
c2 = -0.312
c3 = -0.644
c4 = 0.900
c5 = 0.724


# dados groeneveld
df_gro = pd.read_csv("dados/dados_groeneveld.csv",sep = ";",decimal = ",")
df_gro = df_gro[df_gro.X_chf < 0]

# converte pressao kpa para mpa
df_gro["P_mpa"] = df_gro.P_kpa/1000


# calcula superficie de tensao
df_gro["surface_tension"] = df_gro.P_mpa.apply(lambda x: steamTable.st_p(x))

# calcula densidade do liquido em saturacao

df_gro["densidade_liquido"] = df_gro.P_mpa.apply(lambda x: steamTable.rhoL_p(x))

# calcula densidade do gas em saturacao

df_gro["densidade_vapor"] = df_gro.P_mpa.apply(lambda x: steamTable.rhoV_p(x))

# calcula numero de weber

df_gro["weber"] = ((df_gro.D_mm/1000) * (df_gro.G**2)) / (df_gro.surface_tension*df_gro.densidade_liquido)

# calcula boiling number na saida

df_gro["bo_saida"] = (
  
    c1*(df_gro.weber**c2)*((df_gro.densidade_liquido/df_gro.densidade_vapor)**c3) *
    (1 - c4*((df_gro.densidade_liquido/df_gro.densidade_vapor)**c5)*df_gro.X_chf)


)

df_gro["entapia_liquido"] = df_gro.P_mpa.apply(lambda x: steamTable.hL_p(x))
df_gro["entapia_vapor"] = df_gro.P_mpa.apply(lambda x: steamTable.hV_p(x))




df_gro["chf_saida"] = df_gro.bo_saida*df_gro.G*(df_gro.entapia_vapor - df_gro.entapia_liquido)

df_gro["quality_start"] = df_gro.X_chf - df_gro.bo_saida*(df_gro.L_mm/df_gro.D_mm)



df_gro["bo_entrada"] = (

# numerador  
( c1*(df_gro.weber**c2)*((df_gro.densidade_liquido/df_gro.densidade_vapor)**c3) *
    (1 - c4*((df_gro.densidade_liquido/df_gro.densidade_vapor)**c5)*df_gro.X_chf) )/

# denominador
(1 + 4 * c1 * c4 * (df_gro.weber**c2) * 
((df_gro.densidade_liquido/df_gro.densidade_vapor)**(c3+c5)) * (df_gro.D_mm/df_gro.L_mm))
  
  
)

df_gro["chf_entrada"] = df_gro.bo_entrada*df_gro.G*(df_gro.entapia_vapor - df_gro.entapia_liquido)

df_gro["l_d"] = df_gro.L_mm/df_gro.D_mm
 
resultados = df_gro[["CHF","chf_saida","chf_entrada","bo_entrada","bo_saida","X_chf","quality_start","l_d","P_mpa"]]

resultados.head(1)

k2 = 0.6
k3 = 0.75
k1 = 1

q_out = (10**4) * (df_gro.G.values[0]**(0.376)) * ((df_gro.D_mm.values[0]/1000)**(-0.312)) * k1 * (1 + 10*k2 * df_gro.X_chf.values[0]) 
q_out

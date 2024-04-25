################################################################################
######### CODIGO PARA APLICAÇÃO DA CORRELACAO HALL MUDAWAR #####################
################################################################################




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


base_modelagem = pd.read_csv("dados_modelagem_2.csv",sep = ",",decimal = ".")

# converte unidades pressao kpa para bar, fluxo para 
base_modelagem["P_bar"] = (base_modelagem.P/100)
base_modelagem["P_bar_mud"] = (base_modelagem.P*1000)/100000
base_modelagem["G_mud"] = base_modelagem.G/1000
base_modelagem["D_m"] = base_modelagem.D/1000
base_modelagem["L_m"] = base_modelagem.L/1000


# calcula superficie de tensao
base_modelagem["surface_tension"] = base_modelagem.P_bar.apply(lambda x: steamTable.st_p(x))

# calcula densidade do liquido em saturacao

base_modelagem["densidade_liquido"] = base_modelagem.P_bar.apply(lambda x: steamTable.rhoL_p(x))

# calcula densidade do gas em saturacao

base_modelagem["densidade_vapor"] = base_modelagem.P_bar.apply(lambda x: steamTable.rhoV_p(x))

# calcula numero de weber

base_modelagem["weber"] = ((base_modelagem.D_m) * (base_modelagem.G**2)) / (base_modelagem.surface_tension*base_modelagem.densidade_liquido)

# calcula boiling number na saida

base_modelagem["bo_saida"] = (
  
    c1*(base_modelagem.weber**c2)*((base_modelagem.densidade_liquido/base_modelagem.densidade_vapor)**c3) *
    (1 - c4*((base_modelagem.densidade_liquido/base_modelagem.densidade_vapor)**c5)*base_modelagem.X)


)

base_modelagem["entapia_liquido"] = base_modelagem.P_bar.apply(lambda x: steamTable.hL_p(x))
base_modelagem["entapia_vapor"] = base_modelagem.P_bar.apply(lambda x: steamTable.hV_p(x))


base_modelagem["chf_saida"] = base_modelagem.bo_saida*base_modelagem.G*(base_modelagem.entapia_vapor - base_modelagem.entapia_liquido)


base_modelagem["quality_start"] = base_modelagem.X - base_modelagem.bo_saida*(base_modelagem.L_m/base_modelagem.D_m)



base_modelagem["bo_entrada"] = (

# numerador  
( c1*(base_modelagem.weber**c2)*((base_modelagem.densidade_liquido/base_modelagem.densidade_vapor)**c3) *
    (1 - c4*((base_modelagem.densidade_liquido/base_modelagem.densidade_vapor)**c5)*base_modelagem.quality_start) )/

# denominador
(1 + 4 * c1 * c4 * (base_modelagem.weber**c2) * 
((base_modelagem.densidade_liquido/base_modelagem.densidade_vapor)**(c3+c5)) * (base_modelagem.D_m/base_modelagem.L_m))
  
  
)

base_modelagem["chf_entrada"] = base_modelagem.bo_entrada*base_modelagem.G*(base_modelagem.entapia_vapor - base_modelagem.entapia_liquido)

base_modelagem["l_d"] = base_modelagem.L/base_modelagem.D
 
base_modelagem = base_modelagem[["dados_mudawar","X","CHF","G","D","L","P","predicoes_lookup_table","predicoes_lookup_table_0312","chf_saida","chf_entrada"]]

base_modelagem = base_modelagem.rename(columns = {"chf_entrada":"predicoes_mudawar_entrada","chf_saida":"predicoes_mudawar_saida"})

base_modelagem.to_csv("dados_modelagem_2.csv",index = False)





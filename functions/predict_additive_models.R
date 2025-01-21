################################################################################
##################### predicoes modelo lm ######################################
################################################################################

predict_best_lm <- function(data){
  
  modelo_lm = readRDS("data/modelos_lm.rds")
  
  melhor_modelo = modelo_lm[[6]]
  
  predicoes = exp(predict(melhor_modelo, newdata =data))
  
  data['CHF_PREDITO'] = predicoes

  return(data)
}

################################################################################
##################### predicoes modelo glm #####################################
################################################################################


predict_best_glm = function(data,model = 1){
  
  if(model == 1){
    
    modelo_glm = readRDS("data/modelos_glm_gauss_log.rds")
    
    melhor_glm = modelo_glm[[6]]
    
    predicoes = exp(predict(melhor_glm, newdata =data))
    
  } else if (model == 2){
    
    modelo_glm = readRDS("data/modelos_glm_gamma_log.rds")
    
    melhor_glm = modelo_glm[[3]]
    
    predicoes = exp(predict(melhor_glm, newdata =data))
    
  }
  

  data['CHF_PREDITO'] = predicoes
  
  return(data)
  
}

################################################################################
##################### predicoes modelo gam #####################################
################################################################################


predict_best_gam = function(data,model = 1){
  
  if(model == 1){
    
    modelo_gam = readRDS("data/modelos_gam_normal_log_ad_simples.rds")
    
    melhor_gam = modelo_gam[[2]]
    
    predicoes = exp(predict(melhor_gam, newdata =data))
    
  } else if (model == 2){
    
    modelo_gam = readRDS("data/modelos_gam_gamma_log_ad_simples.rds")
    
    melhor_gam = modelo_gam[[1]]
    
    predicoes = exp(predict(melhor_gam, newdata =data))
    
  } else if (model == 3){
    
    modelo_gam = readRDS("data/modelos_gam_normal_log_tp_simples.rds")
    
    melhor_gam = modelo_gam[[6]]
    
    predicoes = exp(predict(melhor_gam, newdata =data))
    
  } else if (model == 4){
    
    modelo_gam = readRDS("data/modelos_gam_gamma_log_tp_simples.rds")
    
    melhor_gam = modelo_gam[[6]]
    
    predicoes = exp(predict(melhor_gam, newdata =data))
    
  } else if (model == 5){
    
    modelo_gam = readRDS("data/modelos_gam_normal_log_cr_simples.rds")
    
    melhor_gam = modelo_gam[[6]]
    
    predicoes = exp(predict(melhor_gam, newdata =data))
    
  } else if (model == 6){
    
    modelo_gam = readRDS("data/modelos_gam_gamma_log_cr_simples.rds")
    
    melhor_gam = modelo_gam[[5]]
    
    predicoes = exp(predict(melhor_gam, newdata =data))
    
  } else if (model == 7){
    
    modelo_gam = readRDS("data/modelos_gam_cr_inter.rds")
    
    melhor_gam = modelo_gam[[6]]
    
    predicoes = exp(predict(melhor_gam, newdata =data))
    
  }
  
  data['CHF_PREDITO'] = predicoes
  
  return(data)
  
}


################################################################################
##################### predicoes modelo qgam ####################################
################################################################################


predict_best_qgam = function(data,model = 7){
  
  if(model == 1){
    
    modelo_qgam = readRDS("data/modelos_qgam_50_ad.rds")
    
    melhor_qgam = modelo_qgam[[6]]
    
    predicoes = predict(melhor_qgam, newdata = data)
    
  } else if (model == 2){
    
    modelo_qgam = readRDS("data/modelos_qgam_50_tp.rds")
    
    melhor_qgam = modelo_qgam[[6]]
    
    predicoes = predict(melhor_qgam, newdata = data)
    
  } else if (model == 3){
    
    modelo_qgam = readRDS("data/modelos_qgam_50_cr.rds")
    
    melhor_qgam = modelo_qgam[[6]]
    
    predicoes = predict(melhor_qgam, newdata = data)
    
  }
  
  data['CHF_PREDITO'] = predicoes
  
  return(data)
  
}

################################################################################
##################### predicoes modelo QGAM TAU = 0.95 #########################
################################################################################


predict_qgam_095 = function(data){
  
    modelo_qgam = readRDS("data/modelos_qgam_95_inter_2.rds")
    
    predicoes = predict(modelo_qgam, newdata = data)
    
    data['CHF_PREDITO_QTL95'] = predicoes
    
    return(data)

}


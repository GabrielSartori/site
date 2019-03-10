# Função stacked_wrap -----------------------------------------------------
stacked_wrap <- function(data, classe, legenda, cores = c("#41ab5d", '#fb6a4a', '#252525')){
  
  # Split_variable
  
  # data <- aggr_class_bacia$data[[id_od]]
  
  complete_data <-
    data %>% 
    droplevels() %>%
    tidyr::complete(bacia, tidyr::nesting(class, resposta)) %>%
    tidyr::replace_na(list(n = 0, perc = 0)) %>%
    ungroup() %>%
    mutate(class = paste0("Classe ", class)) %>% 
    group_by(class) %>%
    arrange(class) %>% 
    tidyr::nest()
  
  
  # Ordenando dados pela classe do rio
  ordem_data <- complete_data$data[[classe]] %>%
    ungroup() %>% 
    group_by(resposta) %>%
    mutate(bacia = fct_reorder2(bacia,
      .x = resposta,
      .y = perc,
      .desc = FALSE))
  
  class <- complete_data$class[[classe]] %>% as.factor()

  # Gráfico 
  
  gg_bar_stacked <- ggplot(ordem_data, 
    mapping = aes(
      x = bacia,
      y = perc,
      fill = resposta)) +  
    geom_bar(
      stat = "identity",
      colour = "black",
      position = position_fill(reverse = TRUE)) +
    facet_wrap(class, scales = "free_y") +
    labs(fill = "") + 
    scale_y_continuous(labels = scales::percent) +
    geom_hline(yintercept = 0.5,  linetype = "dotted", col = "gray25", size = 1) +
    coord_flip() +
    labs(x = "", y =  "", fill = "") +
    theme_bw()  
    
    if(legenda == FALSE) {
      
      gg_bar_stacked <- gg_bar_stacked + 
        theme(
          legend.text = element_text(colour = "white"),
          legend.position = "bottom",
          legend.direction = "horizontal",
          strip.text.x = element_text(size = 10, face = "bold"),
          axis.ticks.length = unit(1, "mm")
        ) +
        scale_fill_manual(
          values = cores) + 
        guides(fill = guide_legend(override.aes = 
            list(
              colour = "white",
              fill = "white")))

    } else{
      
      gg_bar_stacked <- gg_bar_stacked + 
        theme(
          legend.position = "bottom",
          legend.direction = "horizontal",
          strip.text.x = element_text(size = 10, face = "bold"),
          axis.ticks.length = unit(1, "mm"),
          legend.key.size = unit(1.1, "line")
        ) +
        scale_fill_manual(
          values = cores) +
        guides(fill = guide_legend(ncol = 2))
      
    }
    
  return(gg_bar_stacked)
}



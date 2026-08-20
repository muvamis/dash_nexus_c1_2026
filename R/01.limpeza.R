############################################
## 1. PACOTES
############################################
packages <- c(
  "dplyr","tidyr","stringr","lubridate",
  "writexl","gtools","tibble", "glue", "httr2"
)

instalar <- packages[!sapply(packages, requireNamespace, quietly = TRUE)]
if (length(instalar) > 0) install.packages(instalar)

lapply(packages, library, character.only = TRUE)


## PACOTES
############################################
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(scales)
library(DT)
library(tidyr)
library(stringr)
library(gtools)
library(tibble)
library(readxl)
library(writexl)
library(glue)
library(httr2)
library(lubridate)
library(shinycssloaders)

library(ggthemes)
############################################
## DADOS NEXUS
############################################



# devtools::install_github('muvamis/RZohoCreator')

############### PRESENCAS COLECTIVAS
# carrega as variaveis do ficheiro .env
dotenv::load_dot_env()

Presencas_Nexus <- read_excel("Presencas_Nexus.xlsx")

table(Presencas_Nexus$Situacao_Participante, Presencas_Nexus$Sexo)
# 
# Presencas_Nexus <- Presencas_Nexus %>%
#   select(-c(2, 3, 19))
# 
# 
# Presencas_Nexus <- Presencas_Nexus %>%
#   rename(
#     Nome_participante = Nome_Participante.Nome_Participante,
#     Sexo = Nome_Participante.Sexo,
#     Idade   = Nome_Participante.Idade,
#     Estado_Civil = Nome_Participante.Estado_Civil,
#     Nivil_Educacao   = Nome_Participante.Nivil_Educacao,
#     Faz_Poupanca  = Nome_Participante.Faz_Poupanca,
#     Tem_Negocio = Nome_Participante.Tem_Negocio,
#     Situacao_Participante = Nome_Participante.Situacao_Participante,
#     Distrito = Nome_Participante.Distrito,
#     Comunidade = Nome_Participante.Comunidade,
#     Status = Nome_Participante.STATUS1,
#     Facilitadores = Control_Facilitador,
#     ID_MUVA = Nome_Participante.ID_Projecto,
#     Tipo_Sessao = Control_Sessao,
#     Nome_Sessao = Nome_da_Sess_o,
#     Presenca = Presen_a,
#     Turma = Nome_Participante.Turmas
#   )
# 
# 
# Presencas_Nexus <- Presencas_Nexus %>%
#   pivot_wider(
#     names_from = Nome_Sessao,  
#     values_from = Presenca,     
#     values_fn = first          
#   )
# 
# 
# Presencas_Nexus <- Presencas_Nexus %>%
#   mutate(Facilitadores = str_to_title(Facilitadores))
# 
# 
# sessao_cols <- names(Presencas_Nexus)[grepl("^Sessão_?\\d+$", names(Presencas_Nexus))]
# 
# 
# sessao_cols_ordenadas <- sessao_cols[order(as.numeric(gsub("Sessão_?", "", sessao_cols)))]
# 
# sessao_cols_ordenadas
# 
# # writexl::write_xlsx(Presencas_Nexus, path = "PRESENCAS_NEXUS.xlsx")
# 

Perfil_NEXUS <- Presencas_Nexus



############### QUALIDADE DAS SESSOES NEXUS


Qualidade_Sessoes <- read_excel("Qualidade_Sessoes.xlsx")

Qualidade_Sessoes <- Qualidade_Sessoes %>%
  select(-c(9))


Qualidade_Sessoes <- Qualidade_Sessoes %>%
  rename(
    Nome_Sessao = Numero_da_Sess_o 
   
  )


Qualidade_Sessoes <- Qualidade_Sessoes %>%
  select(
    Data, Distrito, Comunidade, Facilitadores, Nome_Sessao,
    Quantos_Participantes_responderam_Muito_Mau, 
    Quantos_Participantes_responderam_Mau,
    Quantos_Participantes_responderam_Neutro,
    Quantos_Participantes_responderam_Bom,
    Quantos_Participantes_responderam_Muito_Bom,
    everything()
  ) %>%
  arrange(Data, Distrito, Comunidade)

Qualidade_Sessoes <- Qualidade_Sessoes %>%
  mutate(
    across(
      starts_with("Quantos_Participantes_responderam"),
      ~ as.numeric(.)
    )
  )

Qualidade_Sessoes <- Qualidade_Sessoes %>%
  rename(
   Muito_Mau = Quantos_Participantes_responderam_Muito_Mau, 
   Mau = Quantos_Participantes_responderam_Mau,
    Neutro = Quantos_Participantes_responderam_Neutro,
    Bom = Quantos_Participantes_responderam_Bom,
    Muito_Bom = Quantos_Participantes_responderam_Muito_Bom
    
  )

# Calcular Total_Participantes usando os novos nomes
Qualidade_Sessoes <- Qualidade_Sessoes %>%
  mutate(
    Total_Participantes = rowSums(
      select(., Muito_Mau, Mau, Neutro, Bom, Muito_Bom),
      na.rm = TRUE
    )
  )

# Criar linha de totais
totais <- Qualidade_Sessoes %>%
  summarise(
    Data = NA,  # ou "" se preferir
    Distrito = "TOTAL",
    Comunidade = "",
    Facilitadores = "",
    Nome_Sessao = "",
    Muito_Mau = sum(Muito_Mau, na.rm = TRUE),
    Mau = sum(Mau, na.rm = TRUE),
    Neutro = sum(Neutro, na.rm = TRUE),
    Bom = sum(Bom, na.rm = TRUE),
    Muito_Bom = sum(Muito_Bom, na.rm = TRUE),
    Total_Participantes = sum(Total_Participantes, na.rm = TRUE)
  )

# Adicionar a linha de totais no final
Qualidade_Sessoes <- bind_rows(Qualidade_Sessoes, totais)



##################### DADOS DE MENTORIA

Lista_Grants_Mentoria <- read_excel("Lista_Grants_Mentoria.xlsx")

Perfil_NEXUS_GERAL <- read_excel("Perfil_NEXUS_GERAL.xlsx")

Lista_Grants_Mentoria <- Lista_Grants_Mentoria %>%
     select(-c(2, 4, 5, 6, 7))


Lista_Grants_Mentoria <- Lista_Grants_Mentoria %>%
     filter(Elegivel_Grant == "Elegível")

Perfil_Mentoria <- Lista_Grants_Mentoria %>%
  inner_join(
    Perfil_NEXUS_GERAL,
    by = c("Nome_Participante", "Distrito")
  ) %>%
  filter(Mentoria == "Sim")


Perfil_Mentoria <- Perfil_Mentoria %>%
  rename(
    Tem_Negocio_Antes = Tem_Negocio
  )


Perfil_Mentoria <- Perfil_Mentoria %>%
  mutate(Tem_Negocio = "Sim")



nao_encontrados <- Lista_Grants_Mentoria %>%
     anti_join(Perfil_NEXUS_GERAL, by = c("Nome_Participante", "Distrito"))

# writexl::write_xlsx(Perfil_Mentoria, path = "Perfil_Mentoria.xlsx")


Perfil_Mentoria <- Perfil_Mentoria %>%
  mutate(
    Tipo_Negocio = case_when(

      Tipo_Negocio %in% c(
          "Carvao vegetal",
          "Carvao vegetsl",
          "carvao vegetal"
        ) ~ "Carvão vegetal",

      Tipo_Negocio %in% c(
        "roupa",
        "Roupa",
        "Roupa da loja"
      ) ~ "Roupa",

      Tipo_Negocio %in% c(
        "Refeiçoes",
        "Refeições"
      ) ~ "Refeições",

        TRUE ~  Tipo_Negocio
      )
    )





table(Perfil_Mentoria$Tipo_Negocio)



Perfil_Mentoria_clean <- Perfil_Mentoria %>%
  
  # 1. separar múltiplos negócios (se estiverem na mesma célula)
  separate_rows(Tipo_Negocio, sep = ",") %>%
  
  # 2. limpeza de texto
  mutate(
    tipo_negocio_lc = str_to_lower(str_squish(Tipo_Negocio))
  ) %>%
  
  # 3. categorização
  mutate(
    categoria = case_when(
      str_detect(tipo_negocio_lc, "tomate|cebola|frutas|banana|ananás|coco|cocos|legumes|vegetais|quiabo|ovos|galinha|peixe fresco|peixe seco|carvao|carv[oó]es?") ~ "Al.Perecível",
      
      str_detect(tipo_negocio_lc, "açucar|acucar|arroz|feijao|óleo|oleo|sal|produtos de primeira necessidade") ~ "Al.N.Perecível",
      
      str_detect(tipo_negocio_lc, "milho|mandioca|gergelim|ra[ií]zes|raizes|tuberculos|tubérculos") ~ "Agricultura",
      
      str_detect(tipo_negocio_lc, "arrufad|badjia|chamussa|bolinho|p[aã]o|papinha|refei|maheu") ~ "Al.Confec.",
      
      str_detect(tipo_negocio_lc, "sabao|sabonete|pomada|cosmet|higiene|len[çc]o") ~ "Higiene e Cosméticos",
      
      str_detect(tipo_negocio_lc, "roupa|capulana|chinelo|calçado|calcado|alfaiataria") ~ "Vestuário e Calçado",
      
      str_detect(tipo_negocio_lc, "carv[aã]o|gasolina|combustivel|combustível") ~ "Energia e Combustível",
      
      str_detect(tipo_negocio_lc, "carteira movel|taxi|mota") ~ "Serviços",
      
      str_detect(tipo_negocio_lc, "celulares|acessorios") ~ "Comércio Diverso",
      
      str_detect(tipo_negocio_lc, "peixe seco|camar[aã]o") ~ "Pescas",
      
      str_detect(tipo_negocio_lc, "aguardente|cerveja|vinho|bebidas") ~ "Bebidas",
      
      str_detect(tipo_negocio_lc, "palha|serralharia|marfim") ~ "Artesanato",
      
      TRUE ~ "Outros"
    )
  ) %>%
  select(-tipo_negocio_lc)

Perfil_Mentoria_clean$Tipo_Negocio

Presencas_Nexus_Mentoria <- read_excel("Presencas_Nexus_Mentoria.xlsx")


Presencas_Nexus_Mentoria <- Presencas_Nexus_Mentoria %>%
  select(-c(2, 3, 19))


Presencas_Nexus_Mentoria <- Presencas_Nexus_Mentoria %>%
  rename(
    Nome_participante = Nome_Participante.Nome_Participante,
    Sexo = Nome_Participante.Sexo,
    Idade   = Nome_Participante.Idade,
    Estado_Civil = Nome_Participante.Estado_Civil,
    Nivil_Educacao   = Nome_Participante.Nivil_Educacao,
    Faz_Poupanca  = Nome_Participante.Faz_Poupanca,
    Tem_Negocio = Nome_Participante.Tem_Negocio,
    Situacao_Participante = Nome_Participante.Situacao_Participante,
    Distrito = Nome_Participante.Distrito,
    Comunidade = Nome_Participante.Comunidade,
    Status = Nome_Participante.STATUS1,
    Facilitadores = Control_Facilitador,
    ID_MUVA = Nome_Participante.ID_Projecto,
    Tipo_Sessao = Control_Sessao,
    Nome_Sessao = Nome_da_Sess_o,
    Presenca = Presen_a,
    Turma = Nome_Participante.Turmas
  )


Presencas_Nexus_Mentoria <- Presencas_Nexus_Mentoria %>%
  pivot_wider(
    names_from = Nome_Sessao,  
    values_from = Presenca,     
    values_fn = first          
  )


Presencas_Nexus_Mentoria <- Presencas_Nexus_Mentoria %>%
  mutate(Facilitadores = str_to_title(Facilitadores))

Lista_Situacao_Apos_Grants <- read_excel("Lista_Situacao_Apos_Grants.xlsx") %>%
  rename(
    Nome_participante = Nome_participante,
    Situacao_Pos_Grants = Situacao_Pos_Grants
  ) %>%
  mutate(
    Nome_participante = str_to_upper(str_trim(Nome_participante))
  )


Presencas_Nexus_Mentoria <- Presencas_Nexus_Mentoria %>%
  mutate(
    Nome_participante = str_to_upper(str_trim(Nome_participante))
  ) %>%
  left_join(
    Lista_Situacao_Apos_Grants,
    by = c("Distrito", "Nome_participante")
  )

sum(!is.na(Presencas_Nexus_Mentoria$Situacao_Pos_Grants))

Presencas_Nexus_Mentoria <- Presencas_Nexus_Mentoria %>%
  mutate(
    Estado_Apos_Grant = case_when(
      !is.na(Situacao_Pos_Grants) ~ Situacao_Pos_Grants,
      TRUE ~ "IMPLEMENTOU/EM ACOMPANHAMENTO"
    )
  )

sessao_cols <- names(Presencas_Nexus_Mentoria)[grepl("^Sessão_?\\d+$", names(Presencas_Nexus_Mentoria))]


sessao_cols_ordenadas <- sessao_cols[order(as.numeric(gsub("Sessão_?", "", sessao_cols)))]



table(Presencas_Nexus_Mentoria$Estado_Apos_Grant)

Voz_Participante <- Presencas_Nexus_Mentoria %>%
  filter(
    (Distrito == "Nacala Porto" & Comunidade %in% c(
      "ONTUPAIA",
      "MATHAPUE",
      "NAHERENQUE",
      "NAUAIA",
      "TRIANGULO"
    )) |
      (Distrito == "Monapo" & Comunidade %in% c(
        "RAMIANE",
        "TOPELANE",
        "MESEREPANE"
      ))
  )

# Nomes_Faltantes <- Perfil_Mentoria %>%
#   anti_join(
#     Presencas_Nexus_Mentoria,
#     by = c("Nome_Participante" = "Nome_participante")
#   )

# writexl::write_xlsx(Voz_Participante, path = "Voz_Participante.xlsx")

####################### Acompanhamento Individual dos Negocios


# =====================================================
# IMPORTAR BASE
# =====================================================

Acompanhamento_Individuais_Nexus <- read_excel(
  "Acompanhamento_Sessoes_Nexus.xlsx"
)



# =====================================================
# RENOMEAR VARIÁVEIS
# =====================================================

Acompanhamento_Individuais_Nexus <- Acompanhamento_Individuais_Nexus %>%
  rename(
    Comunidade = Comunidade,
    Nome_participante = Nome_Participantes.Nome_Participante,
    ID_Participante = Nome_Participantes.ID,
    Sexo = Nome_Participantes.Sexo,
    Distrito = Distrito,
    Facilitador = Nome_do_a_Facilitador_a,
    Presenca = Presen_as,
    Nome_Sessao = N_mero_da_sess_o,
    Data_Sessao = Data_da_Sess_o,
    Tipo_Sessao = Tipo_De_Sess_o,
    Situacao_Participante = Classifica_o_do_a_participante.zc_display_value,
    Observacoes_Gerais = Observa_es_Gerais,
    Proximos_Passos = Pr_ximo_passo_combinado,
    Acoes_Iniciadas = Ac_es_j_iniciadas,
    Dificuldades_Mencionadas_Resolucao = Dificuldades_mencionadas_e_como_ultrapassou
  )



# =====================================================
# PADRONIZAR CAMPOS
# =====================================================

Acompanhamento_Individuais_Nexus <- Acompanhamento_Individuais_Nexus %>%
  mutate(
    Nome_participante = str_to_upper(
      str_trim(Nome_participante)
    ),
    
    Facilitador = str_to_title(
      Facilitador
    ),
    
    Nome_Sessao = str_to_title(
      str_trim(Nome_Sessao)
    ),
    
    Presenca = str_to_title(
      Presenca
    )
  )



# =====================================================
# CRIAR BASE DE PRESENÇAS
# APENAS CAMPOS NECESSÁRIOS
# =====================================================

Presencas_Individuais_Nexus <- Acompanhamento_Individuais_Nexus %>%
  
  select(
    Distrito,
    Comunidade,
    Nome_participante,
    ID_Participante,
    Sexo,
    Facilitador,
    Nome_Sessao,
    Presenca
  )



# =====================================================
# GARANTIR UMA LINHA POR PARTICIPANTE + SESSÃO
# =====================================================

Presencas_Individuais_Nexus <- Presencas_Individuais_Nexus %>%
  
  group_by(
    Distrito,
    Comunidade,
    Nome_participante,
    ID_Participante,
    Sexo,
    Facilitador,
    Nome_Sessao
  ) %>%
  
  summarise(
    Presenca = first(Presenca),
    .groups = "drop"
  )



# =====================================================
# TRANSFORMAR SESSÕES EM COLUNAS
# =====================================================

Presencas_Individuais_Nexus <- Presencas_Individuais_Nexus %>%
  
  pivot_wider(
    names_from = Nome_Sessao,
    values_from = Presenca
  )



# =====================================================
# ORDENAR COLUNAS DAS SESSÕES
# =====================================================

col_sessoes_ind <- names(Presencas_Individuais_Nexus)[
  grepl(
    "^Sessão Individual",
    names(Presencas_Individuais_Nexus)
  )
]


col_sessoes_ind <- col_sessoes_ind[
  order(
    as.numeric(
      str_extract(
        col_sessoes_ind,
        "\\d+"
      )
    )
  )
]



# =====================================================
# ORGANIZAR BASE FINAL
# =====================================================

Presencas_Individuais_Nexus <- Presencas_Individuais_Nexus %>%
  
  select(
    Distrito,
    Comunidade,
    Nome_participante,
    ID_Participante,
    Sexo,
    Facilitador,
    all_of(col_sessoes_ind)
  )



# =====================================================
# VERIFICAR DUPLICADOS
# =====================================================

Presencas_Individuais_Nexus %>%
  count(
    Nome_participante
  ) %>%
  filter(n > 1)


################### 

Qualidade_Mentoria <- read_excel("Qualidade_Mentoria.xlsx")


Qualidade_Mentoria <- Qualidade_Mentoria %>%
  select(-c(9))


Qualidade_Mentoria <- Qualidade_Mentoria %>%
  rename(
    Nome_Sessao = Numero_da_Sess_o 
    
  )


Qualidade_Mentoria <- Qualidade_Mentoria %>%
  select(
    Data, Distrito, Comunidade, Facilitadores, Nome_Sessao,
    Quantos_Participantes_responderam_Muito_Mau, 
    Quantos_Participantes_responderam_Mau,
    Quantos_Participantes_responderam_Neutro,
    Quantos_Participantes_responderam_Bom,
    Quantos_Participantes_responderam_Muito_Bom,
    everything()
  ) %>%
  arrange(Data, Distrito, Comunidade)

Qualidade_Mentoria <- Qualidade_Mentoria %>%
  mutate(
    across(
      starts_with("Quantos_Participantes_responderam"),
      ~ as.numeric(.)
    )
  )

Qualidade_Mentoria <- Qualidade_Mentoria %>%
  rename(
    Muito_Mau = Quantos_Participantes_responderam_Muito_Mau, 
    Mau = Quantos_Participantes_responderam_Mau,
    Neutro = Quantos_Participantes_responderam_Neutro,
    Bom = Quantos_Participantes_responderam_Bom,
    Muito_Bom = Quantos_Participantes_responderam_Muito_Bom
    
  )

# Calcular Total_Participantes usando os novos nomes
Qualidade_Mentoria<- Qualidade_Mentoria %>%
  mutate(
    Total_Participantes = rowSums(
      select(., Muito_Mau, Mau, Neutro, Bom, Muito_Bom),
      na.rm = TRUE
    )
  )

# Criar linha de totais
totais <- Qualidade_Mentoria %>%
  summarise(
    Data = NA,  # ou "" se preferir
    Distrito = "TOTAL",
    Comunidade = "",
    Facilitadores = "",
    Nome_Sessao = "",
    Muito_Mau = sum(Muito_Mau, na.rm = TRUE),
    Mau = sum(Mau, na.rm = TRUE),
    Neutro = sum(Neutro, na.rm = TRUE),
    Bom = sum(Bom, na.rm = TRUE),
    Muito_Bom = sum(Muito_Bom, na.rm = TRUE),
    Total_Participantes = sum(Total_Participantes, na.rm = TRUE)
  )

# Adicionar a linha de totais no final
Qualidade_Mentoria <- bind_rows(Qualidade_Mentoria, totais)


# ============================================================
# PARTICIPANTES POR SESSÃO E DISTRITO
# ============================================================

total_sessao_distrito <- Qualidade_Sessoes %>%
  filter(Distrito != "TOTAL") %>%
  group_by(
    Distrito,
    Nome_Sessao
  ) %>%
  summarise(
    Total_Participantes = sum(
      Total_Participantes,
      na.rm = TRUE
    ),
    .groups = "drop"
  ) %>%
  arrange(
    Distrito,
    Nome_Sessao
  )

total_sessao_distrito


###################### FEIRAS 

Ficha_Monitoria_Feiras <- read_excel("Ficha_Monitoria_Feiras.xlsx")

# table(Ficha_Monitoria_Feiras$`Evidência de aplicação_de habilidades_no_negócio?_OUT1_01`)



# ============================================================
# BASE DOS GRANTS - NEXUS
# ============================================================

Nexus_Grants <- read_excel("Monapo_Participantes_Nexus_Negocios_Grants.xlsx")

table(Nexus_Grants$`Desistentes pos-grants`)


# Nexus_Grants <- tibble(
#   
#   Distrito = c(
#     rep("Nacala Porto",7),
#     rep("Monapo",7)
#   ),
#   
#   
#   Comunidade = c(
#     "ONTUPAIA",
#     "NAHERENQUE",
#     "MURRUPELANE",
#     "MOCONE",
#     "MATHAPUE",
#     "NAUAIA",
#     "TRIANGULO",
#     "MESEREPANE",
#     "MONAPO RIO",
#     "RAMIANE",
#     "MUELEGE",
#     "TOPELANE",
#     "28 DE SETEMBRO",
#     "MICOLENE"
#   ),
#   
#   
#   Total_Receberam_Grant = c(
#     33,27,14,22,43,25,34,
#     30,25,24,21,27,24,26
#   ),
#   
#   
#   Recuperou_Investimento = c(
#     12,8,4,15,4,5,11,
#     3,4,5,6,9,2,2
#   ),
#   
#   
#   Sucesso_Negocio = c(
#     14,10,4,15,20,12,15,
#     18,23,19,21,19,18,15
#   ),
#   
#   
#   Dificuldades_Negocio = c(
#     1,5,0,3,12,4,2,
#     2,4,2,3,0,2,4
#   ),
#   
#   
#   Possiveis_Desistentes = c(
#     6,4,10,2,6,4,6,
#     8,7,3,0,2,3,6
#   )
#   
# )
# 
# Nexus_Grants <- Nexus_Grants %>%
#   
#   mutate(
#     
#     Taxa_Recuperacao = round(
#       Recuperou_Investimento /
#         Total_Receberam_Grant * 100,
#       1
#     ),
#     
#     
#     Taxa_Sucesso = round(
#       Sucesso_Negocio /
#         Total_Receberam_Grant * 100,
#       1
#     ),
#     
#     
#     Taxa_Dificuldade = round(
#       Dificuldades_Negocio /
#         Total_Receberam_Grant * 100,
#       1
#     ),
#     
#     
#     Taxa_Desistencia = round(
#       Possiveis_Desistentes /
#         Total_Receberam_Grant * 100,
#       1
#     )
#     
#   )

###################################### REFLEXÃO

# table(Presencas_Nexus$Situacao_Participante)
# library(dplyr)
# library(ggplot2)
# library(ggthemes)
# 
# # ============================================================
# # Distrito x Sexo - número e percentagem
# # ============================================================
# 
# dados_distrito_sexo <- Perfil_NEXUS_GERAL %>%
#   count(Distrito, Sexo) %>%
#   group_by(Distrito) %>%
#   mutate(
#     Percentual = n / sum(n) * 100,
#     Label = paste0(n, " (", round(Percentual, 1), "%)")
#   ) %>%
#   ungroup()
# 
# # ============================================================
# # Gráfico empilhado - Percentagem
# # ============================================================
# 
# ggplot(
#   dados_distrito_sexo,
#   aes(
#     x = Distrito,
#     y = Percentual,
#     fill = Sexo
#   )
# ) +
#   
#   geom_col(
#     position = "stack",
#     width = 0.65
#   ) +
#   
#   geom_text(
#     aes(label = Label),
#     position = position_stack(vjust = 0.5),
#     color = "white",
#     fontface = "bold",
#     size = 7
#   ) +
#   
#   scale_y_continuous(
#     limits = c(0, 100),
#     breaks = seq(0, 100, 20),
#     labels = function(x) paste0(x, "%")
#   ) +
#   
#   scale_fill_manual(
#     values = c(
#       "Feminino" = "#9942D4",
#       "Masculino" = "#F77333"
#     )
#   ) +
#   
#   labs(
#     title = "Participantes selecionados por distrito",
#     subtitle = "",
#     x = "Distrito",
#     y = "Percentagem",
#     fill = "Sexo"
#   ) +
#   
#   theme_stata(base_size = 14) +
#   
#   theme(
#     plot.title = element_text(
#       face = "bold",
#       size = 18
#     ),
#     plot.subtitle = element_text(
#       size = 14
#     ),
#     legend.position = "bottom"
#   )

# 
# # ============================================================
# # GRANDE FUNIL — PROJECTO LINK | CICLO 1 2026
# # ============================================================
# library(dplyr)
# library(plotly)
# # ============================================================
# # GRANDE FUNIL — PROJECTO LINK | CICLO 1 2026
# # ============================================================
# 
# library(dplyr)
# library(plotly)
# 
# # ============================================================
# # 1. DADOS DO FUNIL
# # ============================================================
# 
# dados_funil <- data.frame(
#   
#   Etapa = c(
#     "Selecionados",
#     "Iniciaram FH",
#     "Concluíram FH",
#     "Avaliados para empregabilidade",
#     "Empregáveis",
#     "Inseridos"
#   ),
#   
#   N = c(
#     409,
#     352,
#     284,
#     244,
#     198,
#     30
#   )
# )
# 
# # ============================================================
# # 2. CALCULAR PERCENTAGENS
# # ============================================================
# 
# dados_funil <- dados_funil %>%
#   mutate(
#     
#     # Percentagem em relação aos selecionados
#     Percentagem = round(
#       (N / first(N)) * 100,
#       1
#     ),
#     
#     # Texto apresentado no gráfico
#     Label = paste0(
#       N,
#       "  |  ",
#       Percentagem,
#       "%"
#     )
#   )
# 
# # ============================================================
# # 3. COR ROXA
# # ============================================================
# 
# cor_roxo <- "#6A1B9A"
# 
# # ============================================================
# # 4. GRÁFICO DE FUNIL
# # ============================================================
# 
# grafico_funil <- plot_ly(
#   
#   data = dados_funil,
#   
#   type = "funnel",
#   
#   # Funil vertical
#   orientation = "v",
#   
#   x = ~Etapa,
#   y = ~N,
#   
#   # Valores apresentados
#   text = ~Label,
#   textinfo = "text",
#   
#   # Dados para o hover
#   customdata = ~Percentagem,
#   
#   # Cor
#   marker = list(
#     color = cor_roxo,
#     line = list(
#       color = "white",
#       width = 2
#     )
#   ),
#   
#   # Hover
#   hovertemplate = paste0(
#     "<b>%{x}</b><br>",
#     "Participantes: %{y}<br>",
#     "Dos selecionados: %{customdata}%<extra></extra>"
#   )
#   
# ) %>%
#   
#   # ============================================================
# # 5. LAYOUT
# # ============================================================
# 
# layout(
#   
#   title = list(
#     text = "Grande Funil do Ciclo 1 — Projecto LINK 2026",
#     x = 0.5,
#     xanchor = "center",
#     
#     font = list(
#       family = "Arial",
#       size = 20
#     )
#   ),
#   
#   # ----------------------------------------------------------
#   # EIXO X
#   # ----------------------------------------------------------
#   
#   xaxis = list(
#     title = "",
#     
#     categoryorder = "array",
#     
#     categoryarray = c(
#       "Selecionados",
#       "Iniciaram FH",
#       "Concluíram FH",
#       "Avaliados para empregabilidade",
#       "Empregáveis",
#       "Inseridos"
#     ),
#     
#     tickfont = list(
#       size = 14
#     )
#   ),
#   
#   # ----------------------------------------------------------
#   # EIXO Y
#   # ----------------------------------------------------------
#   
#   yaxis = list(
#     title = "Número de participantes",
#     
#     rangemode = "tozero",
#     
#     tickfont = list(
#       size = 15
#     )
#   ),
#   
#   # ----------------------------------------------------------
#   # MARGENS
#   # ----------------------------------------------------------
#   
#   margin = list(
#     l = 80,
#     r = 80,
#     t = 100,
#     b = 100
#   ),
#   
#   # ----------------------------------------------------------
#   # FONTE
#   # ----------------------------------------------------------
#   
#   font = list(
#     family = "Arial",
#     size = 16
#   ),
#   
#   # ----------------------------------------------------------
#   # FUNDO
#   # ----------------------------------------------------------
#   
#   plot_bgcolor = "white",
#   paper_bgcolor = "white"
# )
# 
# # ============================================================
# # 6. MOSTRAR GRÁFICO
# # ============================================================
# 
# grafico_funil


# ============================================================
# 1. Dados
# ============================================================

# ============================================================
# GRÁFICO DE PARTICIPAÇÃO POR PERFIL E SESSÃO
# ============================================================
# ============================================================
# PARTICIPAÇÃO POR PERFIL, SEXO E SESSÃO
# 3 GRÁFICOS SEPARADOS
# ============================================================
# ============================================================
# PARTICIPAÇÃO POR PERFIL, SEXO E SESSÃO
# 3 GRÁFICOS SEPARADOS
# FEMININO E MASCULINO LADO A LADO
# ============================================================
# 
# library(dplyr)
# library(tidyr)
# library(ggplot2)
# 
# 
# # ============================================================
# # 1. DADOS
# # ============================================================
# 
# df <- Presencas_Nexus
# 
# 
# # ============================================================
# # 2. IDENTIFICAR E ORDENAR AS SESSÕES
# # ============================================================
# 
# sessao_cols <- names(df)[
#   grepl("^Sessão_?\\d+$", names(df))
# ]
# 
# sessao_cols_ordenadas <- sessao_cols[
#   order(
#     as.numeric(
#       gsub("Sessão_?", "", sessao_cols)
#     )
#   )
# ]
# 
# print(sessao_cols_ordenadas)
# 
# 
# # ============================================================
# # 3. PADRONIZAR SEXO
# # ============================================================
# 
# df <- df %>%
#   mutate(
#     
#     Sexo = case_when(
#       
#       trimws(as.character(Sexo)) %in% c(
#         "Feminino",
#         "F",
#         "Female",
#         "FEMALE"
#       ) ~ "Feminino",
#       
#       trimws(as.character(Sexo)) %in% c(
#         "Masculino",
#         "M",
#         "Male",
#         "MALE"
#       ) ~ "Masculino",
#       
#       TRUE ~ NA_character_
#     )
#   )
# 
# 
# # ============================================================
# # 4. CRIAR OS PERFIS
# # ============================================================
# 
# df <- df %>%
#   mutate(
#     
#     Perfil = case_when(
#       
#       Situacao_Participante == "Deslocado" ~
#         "Pessoas deslocadas",
#       
#       Situacao_Participante == "Familia acolhedora" ~
#         "Famílias acolhedoras",
#       
#       Situacao_Participante %in% c(
#         "Deslocado VBG",
#         "VBG Interno"
#       ) ~
#         "Sobreviventes de VBG",
#       
#       TRUE ~ NA_character_
#     )
#   ) %>%
#   
#   filter(
#     !is.na(Perfil),
#     !is.na(Sexo)
#   )
# 
# 
# # ============================================================
# # 5. UNIVERSO POR PERFIL E SEXO
# # ============================================================
# 
# universo <- df %>%
#   
#   count(
#     Perfil,
#     Sexo,
#     name = "Previsto"
#   )
# 
# 
# # ============================================================
# # 6. PRESENÇAS POR SESSÃO
# # ============================================================
# 
# presencas <- df %>%
#   
#   pivot_longer(
#     
#     cols = all_of(
#       sessao_cols_ordenadas
#     ),
#     
#     names_to = "Sessao",
#     
#     values_to = "Presenca"
#   ) %>%
#   
#   filter(
#     Presenca == "Presente"
#   ) %>%
#   
#   count(
#     Sessao,
#     Perfil,
#     Sexo,
#     name = "Presentes"
#   )
# 
# 
# # ============================================================
# # 7. CRIAR TODAS AS COMBINAÇÕES
# # ============================================================
# 
# combinacoes <- expand_grid(
#   
#   Sessao = sessao_cols_ordenadas,
#   
#   Perfil = c(
#     "Pessoas deslocadas",
#     "Famílias acolhedoras",
#     "Sobreviventes de VBG"
#   ),
#   
#   Sexo = c(
#     "Feminino",
#     "Masculino"
#   )
# )
# 
# 
# # ============================================================
# # 8. JUNTAR UNIVERSO + PRESENÇAS
# # ============================================================
# 
# df_long <- combinacoes %>%
#   
#   left_join(
#     universo,
#     by = c(
#       "Perfil",
#       "Sexo"
#     )
#   ) %>%
#   
#   left_join(
#     presencas,
#     by = c(
#       "Sessao",
#       "Perfil",
#       "Sexo"
#     )
#   ) %>%
#   
#   mutate(
#     
#     Previsto = coalesce(
#       Previsto,
#       0
#     ),
#     
#     Presentes = coalesce(
#       Presentes,
#       0
#     ),
#     
#     Porcentagem = case_when(
#       
#       Previsto > 0 ~
#         Presentes / Previsto * 100,
#       
#       TRUE ~ 0
#     )
#   )
# 
# 
# # ============================================================
# # 9. ORGANIZAR FATORES
# # ============================================================
# 
# df_long <- df_long %>%
#   
#   mutate(
#     
#     Sessao = factor(
#       Sessao,
#       levels = sessao_cols_ordenadas
#     ),
#     
#     Perfil = factor(
#       Perfil,
#       levels = c(
#         "Pessoas deslocadas",
#         "Famílias acolhedoras",
#         "Sobreviventes de VBG"
#       )
#     ),
#     
#     Sexo = factor(
#       Sexo,
#       levels = c(
#         "Feminino",
#         "Masculino"
#       )
#     ),
#     
#     Label = ifelse(
#       
#       Porcentagem > 0,
#       
#       paste0(
#         round(
#           Porcentagem,
#           1
#         ),
#         "%"
#       ),
#       
#       ""
#     )
#   )
# 
# 
# # ============================================================
# # 10. VERIFICAR UNIVERSO
# # ============================================================
# 
# print(
#   universo %>%
#     arrange(
#       Perfil,
#       Sexo
#     )
# )
# 
# 
# # ============================================================
# # 11. CORES
# # ============================================================
# 
# cores_sexo <- c(
#   
#   "Feminino" = "#9942D4",
#   
#   "Masculino" = "#F77333"
# )
# 
# 
# # ============================================================
# # 12. FUNÇÃO PARA CRIAR GRÁFICO
# # ============================================================
# 
# criar_grafico_perfil <- function(
#     perfil_nome
# ) {
#   
#   
#   dados <- df_long %>%
#     filter(
#       Perfil == perfil_nome
#     )
#   
#   
#   ggplot(
#     
#     dados,
#     
#     aes(
#       x = Sessao,
#       y = Porcentagem,
#       fill = Sexo
#     )
#   ) +
#     
#     
#     # ========================================================
#   # BARRAS LADO A LADO
#   # ========================================================
#   
#   geom_col(
#     
#     position = position_dodge(
#       width = 0.8
#     ),
#     
#     width = 0.7
#   ) +
#     
#     
#     # ========================================================
#   # PERCENTAGEM NO CENTRO DAS BARRAS
#   # ========================================================
#   
#   geom_text(
#     
#     aes(
#       label = Label
#     ),
#     
#     position = position_dodge(
#       width = 0.8
#     ),
#     
#     vjust = 0.1,
#     
#     size = 5,
#     
#     colour = "black",
#     
#     fontface = "bold"
#   ) +
#     
#     
#     # ========================================================
#   # CORES
#   # ========================================================
#   
#   scale_fill_manual(
#     
#     values = cores_sexo
#   ) +
#     
#     
#     # ========================================================
#   # EIXO Y
#   # ========================================================
#   
#   scale_y_continuous(
#     
#     limits = c(
#       0,
#       100
#     ),
#     
#     breaks = seq(
#       0,
#       100,
#       20
#     ),
#     
#     labels = function(x) {
#       
#       paste0(
#         x,
#         "%"
#       )
#       
#     },
#     
#     expand = expansion(
#       mult = c(
#         0,
#         0.02
#       )
#     )
#   ) +
#     
#     
#     # ========================================================
#   # TÍTULOS
#   # ========================================================
#   
#   labs(
#     
#     title = perfil_nome,
#     
#     x = "Sessão",
#     
#     y = "Participação (%)",
#     
#     fill = "Sexo"
#   ) +
#     
#     
#     # ========================================================
#   # TEMA
#   # ========================================================
#   
#   theme_minimal() +
#     
#     theme(
#       
#       plot.background = element_rect(
#         fill = "#f5f3f4",
#         colour = NA
#       ),
#       
#       panel.background = element_rect(
#         fill = "#f5f3f4",
#         colour = NA
#       ),
#       
#       panel.grid.major.x = element_blank(),
#       
#       panel.grid.minor.x = element_blank(),
#       
#       axis.text.x = element_text(
#         size = 14,
#         colour = "black"
#       ),
#       
#       axis.text.y = element_text(
#         size = 12,
#         colour = "black"
#       ),
#       
#       axis.title.x = element_text(
#         size = 13,
#         colour = "black"
#       ),
#       
#       axis.title.y = element_text(
#         size = 13,
#         colour = "black"
#       ),
#       
#       plot.title = element_text(
#         size = 16,
#         face = "bold",
#         hjust = 0.5
#       ),
#       
#       legend.position = "bottom",
#       
#       legend.title = element_text(
#         size = 14,
#         face = "bold"
#       ),
#       
#       legend.text = element_text(
#         size = 14
#       )
#     )
# }
# 
# 
# # ============================================================
# # 13. CRIAR OS 3 GRÁFICOS
# # ============================================================
# 
# grafico_deslocados <- criar_grafico_perfil(
#   "Pessoas deslocadas"
# )
# 
# grafico_familias <- criar_grafico_perfil(
#   "Famílias acolhedoras"
# )
# 
# grafico_vbg <- criar_grafico_perfil(
#   "Sobreviventes de VBG"
# )
# 
# 
# # ============================================================
# # 14. MOSTRAR OS 3 GRÁFICOS
# # ============================================================
# 
# grafico_deslocados
# 
# grafico_familias
# 
# grafico_vbg
# 
# # ============================================================
# # 1. Usar os dados diretamente
# # ============================================================
# 
# df <- Presencas_Nexus
# 
# 
# # ============================================================
# # 2. Sessões
# # ============================================================
# 
# sessao_cols <- names(df)[
#   grepl("^Sessão_?\\d+$", names(df))
# ]
# 
# sessao_cols_ordenadas <- sessao_cols[
#   order(
#     as.numeric(
#       gsub("Sessão_?", "", sessao_cols)
#     )
#   )
# ]
# 
# 
# # ============================================================
# # 3. Criar perfis
# # ============================================================
# 
# df <- df %>%
#   mutate(
#     Perfil = case_when(
#       
#       Situacao_Participante == "Deslocado" ~
#         "Pessoas deslocadas",
#       
#       Situacao_Participante == "Familia acolhedora" ~
#         "Famílias acolhedoras",
#       
#       Situacao_Participante %in% c(
#         "Deslocado VBG",
#         "VBG Interno"
#       ) ~
#         "Mulheres sobreviventes de VBG",
#       
#       TRUE ~ NA_character_
#     )
#   ) %>%
#   filter(
#     !is.na(Perfil)
#   )
# 
# 
# # ============================================================
# # 4. Total previsto por perfil
# # ============================================================
# 
# previstos <- df %>%
#   count(
#     Perfil,
#     name = "Previsto"
#   )
# 
# 
# # ============================================================
# # 5. Transformar sessões para formato longo
# # ============================================================
# 
# df_long <- df %>%
#   
#   tidyr::pivot_longer(
#     cols = all_of(
#       sessao_cols_ordenadas
#     ),
#     
#     names_to = "Sessao",
#     
#     values_to = "Presenca"
#   ) %>%
#   
#   filter(
#     Presenca == "Presente"
#   ) %>%
#   
#   count(
#     Sessao,
#     Perfil,
#     name = "Count"
#   ) %>%
#   
#   left_join(
#     previstos,
#     by = "Perfil"
#   ) %>%
#   
#   mutate(
#     Porcentagem =
#       Count / Previsto * 100
#   )
# 
# 
# # ============================================================
# # 6. Completar combinações
# # ============================================================
# 
# df_long <- df_long %>%
#   
#   tidyr::complete(
#     
#     Sessao = sessao_cols_ordenadas,
#     
#     Perfil = c(
#       "Pessoas deslocadas",
#       "Famílias acolhedoras",
#       "Mulheres sobreviventes de VBG"
#     ),
#     
#     fill = list(
#       Count = 0,
#       Porcentagem = 0
#     )
#   ) %>%
#   
#   mutate(
#     
#     Sessao = factor(
#       Sessao,
#       levels = sessao_cols_ordenadas
#     ),
#     
#     Perfil = factor(
#       Perfil,
#       levels = c(
#         "Pessoas deslocadas",
#         "Famílias acolhedoras",
#         "Mulheres sobreviventes de VBG"
#       )
#     ),
#     
#     Label = paste0(
#       round(
#         Porcentagem,
#         1
#       ),
#       "%"
#     )
#   )
# 
# 
# # ============================================================
# # 7. Cores
# # ============================================================
# 
# cores_perfil <- c(
#   
#   "Pessoas deslocadas" =
#     "#69C7BE",
#   
#   "Famílias acolhedoras" =
#     "#ffc107",
#   
#   "Mulheres sobreviventes de VBG" =
#     "#9942D4"
# )
# 
# 
# # ============================================================
# # 8. Gráfico
# # ============================================================
# 
# ggplot(
#   
#   df_long,
#   
#   aes(
#     x = Sessao,
#     y = Porcentagem,
#     fill = Perfil
#   )
# ) +
#   
#   
#   # ==========================================================
# # Barras
# # ==========================================================
# 
# geom_col(
#   
#   position = position_dodge(
#     width = 0.8
#   ),
#   
#   width = 0.7
# ) +
#   
#   
#   # ==========================================================
# # PERCENTAGENS NO TOPO DAS BARRAS
# # ==========================================================
# 
# geom_text(
#   
#   aes(
#     label = Label
#   ),
#   
#   position = position_dodge(
#     width = 0.8
#   ),
#   
#   vjust = -0.3,
#   
#   angle = 90,
#   
#   size = 6,
#   
#   colour = "black",
#   
#   fontface = "bold"
# ) +
#   
#   
#   # ==========================================================
# # Cores
# # ==========================================================
# 
# scale_fill_manual(
#   values = cores_perfil
# ) +
#   
#   
#   # ==========================================================
# # Eixo Y
# # ==========================================================
# 
# scale_y_continuous(
#   
#   limits = c(
#     0,
#     100
#   ),
#   
#   breaks = seq(
#     0,
#     100,
#     20
#   ),
#   
#   labels = function(x) {
#     paste0(
#       x,
#       "%"
#     )
#   },
#   
#   expand = expansion(
#     mult = c(
#       0,
#       0.12
#     )
#   )
# ) +
#   
#   
#   # ==========================================================
# # Títulos
# # ==========================================================
# 
# labs(
#   
#   x = "Sessão",
#   
#   y = "Participação (%)",
#   
#   fill = "Perfil"
# ) +
#   
#   
#   # ==========================================================
# # Tema
# # ==========================================================
# 
# theme_minimal() +
#   
#   theme(
#     
#     plot.background = element_rect(
#       fill = "#f5f3f4",
#       colour = NA
#     ),
#     
#     panel.background = element_rect(
#       fill = "#f5f3f4",
#       colour = NA
#     ),
#     
#     panel.grid.major.x = element_blank(),
#     
#     panel.grid.minor.x = element_blank(),
#     
#     axis.text.x = element_text(
#       size = 14,
#       colour = "black"
#     ),
#     
#     axis.text.y = element_text(
#       size = 12,
#       colour = "black"
#     ),
#     
#     axis.title = element_text(
#       size = 13
#     ),
#     
#     legend.position = "bottom",
#     
#     legend.title = element_text(
#       size = 13,
#       face = "bold"
#     ),
#     
#     legend.text = element_text(
#       size = 12
#     )
#   )
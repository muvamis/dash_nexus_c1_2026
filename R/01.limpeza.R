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

############################################
## DADOS NEXUS
############################################

# Seleccionados_Monapo <- read_excel("Seleccionados Monapo.xlsx")
# 
# Seleccionados_Nacala_Porto <- read_excel("Seleccionados Nacala Porto.xlsx")
# 
# Perfil <- rbind(Seleccionados_Monapo,Seleccionados_Nacala_Porto)
# 
# Perfil <- Perfil %>%
#   rename(
#     Nome_participante = nome ,
#     Sexo = sexo,
#     Ano_Nascimento = yob,
#     Idade   = idade,
#     Estado_Civil = estado_civil,
#     Nivil_Educacao   = ed_maisalt,
#     Faz_Poupanca  = Act_poupanca,
#     Tem_Negocio = Act_negocio,
#     Situacao_Participante = Categ
#   )
# 
# ############ ORGANIZAR O PERFIL DE NACALA PORTO
# Lista_Nacala_Porto_Turmas <- read_excel("Lista_Nacala_Porto_Turmas.xlsx")

# duplicados_todas_colunas <- Lista_Nacala_Porto_Turmas %>%
#   filter(duplicated(.))
#
# duplicados <- Lista_Nacala_Porto_Turmas %>%
#   group_by(nome) %>%
#   filter(n() > 1) %>%
#   arrange(nome)
#
# nomes_duplicados1 <- Lista_Nacala_Porto_Turmas %>%
#   count(nome) %>%
#   filter(n > 1)
#
# Perfil_Nacala_Porto <- Perfil %>%
#   filter(Distrito == "Nacala Porto")
# #
# resultado <- Lista_Nacala_Porto_Turmas %>%
#   inner_join(Perfil_Nacala_Porto, by = c("nome" = "Nome_participante"))
# 
# nao_encontrados <- Lista_Nacala_Porto_Turmas %>%
#   anti_join(Perfil_Nacala_Porto, by = c("nome" = "Nome_participante"))
# 
# 
# duplicados_todas <- resultado %>%
#   filter(duplicated(.))
# 
# duplicados_2 <- resultado %>%
#   group_by(nome) %>%
#   filter(n() > 1) %>%
#   arrange(nome)
# 
# Perfil_NEXUS_NACALA <- resultado
# 
# # write_xlsx(
# #   Perfil_NEXUS_NACALA,
# #   path = "Perfil_NEXUS_NACALA.xlsx"
# # )
# 
# ########### MONAPO PERFIL
# Lista_Monapo_Turmas <- read_excel("Lista_Monapo_Turmas.xlsx")
# 
# Duplicados_Monapo <- Lista_Monapo_Turmas %>%
#   filter(duplicated(.))
# 
# duplicados_Monapo <- Lista_Monapo_Turmas %>%
#   group_by(nome) %>%
#   filter(n() > 1) %>%
#   arrange(nome)
# 
# Perfil_Monapo <- Perfil %>%
#   filter(Distrito == "Monapo")
# 
# Duplicados_Perfi <- Perfil_Monapo %>%
#   group_by(Nome_participante) %>%
#   filter(n() > 1) %>%
#   arrange(Nome_participante)
# 
# Perfil_Monapo_unico <- Perfil_Monapo %>%
#   group_by(Nome_participante) %>%
#   slice(1) %>%
#   ungroup() %>%
#   arrange(Nome_participante)
# 
# Perfil_Monapo_Geral <- Lista_Monapo_Turmas %>%
#   inner_join(Perfil_Monapo_unico, by = c("nome" = "Nome_participante"))
# 
# 
# # write_xlsx(
# #   Perfil_Monapo_Geral,
# #   path = "Perfil_Monapo_Geral.xlsx"
# # )
# 
# 
# Perfil_Nao_Encontrado <- Lista_Monapo_Turmas %>%
#   anti_join(Perfil_Monapo_unico, by = c("nome" = "Nome_participante"))
# 
# Perfil_NEXUS <- rbind(Perfil_NEXUS_NACALA, Perfil_Monapo_Geral)
# 
# 
# Perfil_NEXUS <- Perfil_NEXUS %>%
#   rename(
#     Distrito = Distrito.x,
#     Comunidade = Comunidade.x,
#     Nome_Participante = nome
#   )
# 
# Perfil_NEXUS <- Perfil_NEXUS %>%
#   mutate(
#     Comunidade = recode(Comunidade,
#                         "MATHUPE" = "MATHAPUE",
#                         "ONPUTAIA" = "ONTUPAIA",
#                         "MUATHAPUE"  = "MATHAPUE",
#                         "MORRUPELANE"  = "MURRUPELANE",
#                         "MURRUPELENE" = "MURRUPELANE"
#     )
#   )
# 
# Perfil_NEXUS <- Perfil_NEXUS %>%
#   select(-c(4, 11, 13, 14, 15, 16, 18, 22,74, 75, 76, 77, 79, 80, 81, 82))
# 
# table(Perfil_NEXUS$Comunidade)
# 

# write_xlsx(
#   Perfil_NEXUS,
#   path = "Perfil_NEXUS_GERAL.xlsx"
# )


# devtools::install_github('muvamis/RZohoCreator')

############### PRESENCAS COLECTIVAS
# carrega as variaveis do ficheiro .env
dotenv::load_dot_env()

# # Autenticação com Zoho
# client_id <- Sys.getenv("CLIENT_ID")
# client_secret <- Sys.getenv("CLIENT_SECRET")
# refresh_token <- Sys.getenv("REFRESH_TOKEN")
# 
# access_token <- RZohoCreator::refresh_access_token(
#   client_id, client_secret, refresh_token
# )$access_token
# 
# ## 1. Presenças Coletivas
# dados <- RZohoCreator::get_records(
#   "associacaomuva", "monitoria", "PRESENCAS_NEXUS_Report", access_token
# ) %>%
#   data.frame()
# 
# # Baixar
# writexl::write_xlsx(dados, path = "Presencas_Nexus.xlsx")

Presencas_Nexus <- read_excel("Presencas_Nexus.xlsx")

Presencas_Nexus <- Presencas_Nexus %>%
  select(-c(2, 3, 19))


Presencas_Nexus <- Presencas_Nexus %>%
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


Presencas_Nexus <- Presencas_Nexus %>%
  pivot_wider(
    names_from = Nome_Sessao,  
    values_from = Presenca,     
    values_fn = first          
  )


Presencas_Nexus <- Presencas_Nexus %>%
  mutate(Facilitadores = str_to_title(Facilitadores))


sessao_cols <- names(Presencas_Nexus)[grepl("^Sessão_?\\d+$", names(Presencas_Nexus))]


sessao_cols_ordenadas <- sessao_cols[order(as.numeric(gsub("Sessão_?", "", sessao_cols)))]


Perfil_NEXUS <- Presencas_Nexus

# Duplicados_Perfi <- Perfil_NEXUS %>%
#   group_by(Nome_participante) %>%
#   filter(n() > 1) %>%
#   arrange(Nome_participante)

# table(Perfil_NEXUS$tipo_neg)
# # 
# Perfil <- Perfil_NEXUS %>%
#   mutate(
#     tipo_neg = case_when(
# 
#       # Grupo 1
#       tipo_neg %in% c(
#         "AGENTE DE CARTEIRA MOVEL (EMOLA)",
#         "AGENTE DE CONTA MOVEL(MPESA E EMOLA)",
#         "AGENTE E-MOLA",
#         "AGENTE EMOLA",
#         "AGENTES E-MOLA"
#       ) ~ "AGENTE DE CARTEIRA MÓVEL",
# 
#       tipo_neg %in% c(
#         "VENDA DE ARTIGO DE ROUPA",
#         "VENDA DE ROUPAS USADAS ( CALAMIDADE)",
#          "VENDA DE ROUPA ( CAPULANA)"
#         # "AGENTE EMOLA",
#         # "AGENTES E-MOLA"
#       ) ~ "VENDA DE ROUPA DA CALAMIDADE",
# 
#       # # Grupo 2
#       tipo_neg %in% c(
#         "MERCEARIA ( VENDA DE PRODUTOS DIVERSOS)",
#         "MERCEARIA E VENDA E PRODUTOS ALIMENTAR",
#         "PRODUTOS ALIMENTARES DE PRIMEIRA NECESSIDADE",
#         "VENDE PRODUTOS DE PRIMAVERA NECESSIDADE:PEIXINHO, OLEO, CIGARO,ENTE OUTROS.",
#         "VENDE PRODUTOS ALIMENTARES DIVERSOS E DE PRIMEIRA NECESSIDADE.",
#         "VENDA PRODUTOS DE PRIMEIRA NECESSIDADE (ARROZ, FARINHA)",
#         "VENDA DE PRODUTOS ALIMENTARES",
#         "VENDA DE DIVERSOS PRODUTOS ALIMENTARES",
#         "VENDO ALIMENTARES.",
#          "VENDA DE ALIMENTOS."
#       ) ~ "VENDA DE PRODUTOS NA MERCEARIA",
# 
#       tipo_neg %in% c(
#         "VENDA DE BADJIAS",
#         "VENDE BADJIAS",
#         "VENDA PRODUTOS ALIMENTARES (BADJIAS",
#         "VENDA DE BADJIA E MAHEU"
#       ) ~ "VENDA DE BADJIA",
# 
#       tipo_neg %in% c(
#         "VENDA DE PEIXE E BOLINHOS",
#         "VENDA DE PEIXES FRESCOS.",
#         "VENDA DE PEIXE (NICUSE)",
#         "VENDA DE PEIXE FRESCO E SECO"
#       ) ~ "VENDA DE PEIXE",
# 
#       tipo_neg %in% c(
#         "VENDAS DE REFEICOES",
#         "VENDA DE COMIDA COZIDA",
#         "VENDA DE COMIDA"
#       ) ~ "VENDA DE REFEIÇÕES",
# 
#       tipo_neg %in% c(
#         "VENDA DE FEIJAO BUERE",
#         "VENDA DE FEIJAO FAVA",
#         "VENDA DE FEIJAO"
#       ) ~ "VENDA DE FEIJAO",
# 
#       tipo_neg %in% c(
#         "VENDA DE BEBIDAS CASEIRAS /TRADITIONAL",
#         "VENDE CERVEJA",
#         "FACO TAXI MOTA E VENDO BEBIDAS NO BAR"
#       ) ~ "VENDA DE BEBIDAS",
# 
#       tipo_neg %in% c(
#         "BOLINHOS",
#         "VENDO BOLINHOS",
#         "VENDA DE BOLINHOS E MAHEU",
#         "VENDAS DE BOLINHOS.",
#         "VENDA DE BOLINHOS E BADJIA",
#         "VENDO BOLINHOS E CHINELOS",
#         "VENDA DE PRODUTOS ALIMENTARES (BOLINHOS)"
#       ) ~ "VENDA DE BOLINHOS",
# 
#       tipo_neg %in% c(
#         "VENDE ROFADAS E FAZ BISCATOS NAS MACHAMBAS",
#          "VENDO ROFADAS",
#          "VENDA DE ROFODAS"
#       ) ~ "VENDA DE ARRUFADAS",
# 
#       tipo_neg %in% c(
#         # "VENDA DE CARVAO , BOLINHOS, ARROZ",
#         "VENDA DE CARVAO",
#         "PRODUCAO E VENDA DE CARVAO VEGETAL"
#       ) ~ "VENDA DE CARVAO",
# 
#       tipo_neg %in% c(
#         "PRESTO SERVICOS EM CAPINAR MACHAMBAS DAS PESSOAS."
#       ) ~ "SERVICO DE CAPINAR",
# 
#       tipo_neg %in% c(
#         "TAXI"
#       ) ~ "SERVICO DE TAXI",
# 
#       tipo_neg %in% c(
#         "VENDA DE CARVAO , BOLINHOS, ARROZ",
#         "VENDA DE REFRESCOS",
#         "VENDA DE FROZY E AGUA"
#       ) ~ "VENDA DE REFREGERANTES",
# 
# 
#       # Grupo 3
#       tipo_neg %in% c(
#         "COSTURQ",
#         # "CORTE E COSTURA PRESTO SERVICOS EM CAPINAR MACHAMBAS DAS PESSOAS.",
#         "CORTE E COSTURA.",
#         "ALFAIATE"
#       ) ~ "CORTE E COSTURA",
# 
#       TRUE ~ tipo_neg
#     )
#   )
# 
# table(Perfil_NEXUS$tipo_neg)
# 




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
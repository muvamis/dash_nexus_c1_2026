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

Seleccionados_Monapo <- read_excel("Seleccionados Monapo.xlsx")

Seleccionados_Nacala_Porto <- read_excel("Seleccionados Nacala Porto.xlsx")

Perfil <- rbind(Seleccionados_Monapo,Seleccionados_Nacala_Porto)

Perfil <- Perfil %>%
  rename(
    Nome_participante = nome ,
    Sexo = sexo,
    Ano_Nascimento = yob,
    Idade   = idade,
    Estado_Civil = estado_civil,
    Nivil_Educacao   = ed_maisalt,
    Faz_Poupanca  = Act_poupanca,
    Tem_Negocio = Act_negocio,
    Situacao_Participante = Categ
  )

############ ORGANIZAR O PERFIL DE NACALA PORTO
Lista_Nacala_Porto_Turmas <- read_excel("Lista_Nacala_Porto_Turmas.xlsx")
 
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
Perfil_Nacala_Porto <- Perfil %>%
  filter(Distrito == "Nacala Porto")
#
resultado <- Lista_Nacala_Porto_Turmas %>%
  inner_join(Perfil_Nacala_Porto, by = c("nome" = "Nome_participante"))

nao_encontrados <- Lista_Nacala_Porto_Turmas %>%
  anti_join(Perfil_Nacala_Porto, by = c("nome" = "Nome_participante"))


duplicados_todas <- resultado %>%
  filter(duplicated(.))

duplicados_2 <- resultado %>%
  group_by(nome) %>%
  filter(n() > 1) %>%
  arrange(nome)

Perfil_NEXUS_NACALA <- resultado

# write_xlsx(
#   Perfil_NEXUS_NACALA,
#   path = "Perfil_NEXUS_NACALA.xlsx"
# )

########### MONAPO PERFIL
Lista_Monapo_Turmas <- read_excel("Lista_Monapo_Turmas.xlsx")

Duplicados_Monapo <- Lista_Monapo_Turmas %>%
  filter(duplicated(.))

duplicados_Monapo <- Lista_Monapo_Turmas %>%
  group_by(nome) %>%
  filter(n() > 1) %>%
  arrange(nome)

Perfil_Monapo <- Perfil %>%
  filter(Distrito == "Monapo")

Duplicados_Perfi <- Perfil_Monapo %>%
  group_by(Nome_participante) %>%
  filter(n() > 1) %>%
  arrange(Nome_participante)

Perfil_Monapo_unico <- Perfil_Monapo %>%
  group_by(Nome_participante) %>%
  slice(1) %>%  
  ungroup() %>%
  arrange(Nome_participante)

Perfil_Monapo_Geral <- Lista_Monapo_Turmas %>%
  inner_join(Perfil_Monapo_unico, by = c("nome" = "Nome_participante"))


# write_xlsx(
#   Perfil_Monapo_Geral,
#   path = "Perfil_Monapo_Geral.xlsx"
# )


Perfil_Nao_Encontrado <- Lista_Monapo_Turmas %>%
  anti_join(Perfil_Monapo_unico, by = c("nome" = "Nome_participante"))

Perfil_NEXUS <- rbind(Perfil_NEXUS_NACALA, Perfil_Monapo_Geral)


Perfil_NEXUS <- Perfil_NEXUS %>%
  rename(
    Distrito = Distrito.x,
    Comunidade = Comunidade.x,
    Nome_Participante = nome
  )

Perfil_NEXUS <- Perfil_NEXUS %>%
  select(-c(4, 11, 13, 14, 15, 16, 18, 22,74, 75, 76, 77, 79, 80, 81, 82))

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


sessao_cols <- names(Presencas_Nexus)[grepl("^Sessão_?\\d+$", names(Presencas_Nexus))]


sessao_cols_ordenadas <- sessao_cols[order(as.numeric(gsub("Sessão_?", "", sessao_cols)))]

table(Perfil_NEXUS$tipo_neg)

library(dplyr)
library(stringr)

Perfil_NEXUS <- Perfil_NEXUS %>%
  mutate(tipo_neg_pad = str_to_upper(tipo_neg)) %>%  # transforma tudo em maiúsculas
  mutate(tipo_neg_pad = str_trim(tipo_neg_pad)) %>%  # remove espaços extras
  # padronização por palavras-chave
  mutate(tipo_neg_pad = case_when(
    
    str_detect(tipo_neg_pad, "AGENTE.*EMOLA|AGENTE.*CONTA MOVEL|AGENTE E-MOLA|AGENTES E-MOLA") ~ "AGENTE EMOLA",
    
    str_detect(tipo_neg_pad, "ALFAIATE") ~ "ALFAIATE",
    
    str_detect(tipo_neg_pad, "BOLINHOS") ~ "VENDA BOLINHOS",
    
    str_detect(tipo_neg_pad, "COMERCIANTE") ~ "COMERCIANTE",
    
    str_detect(tipo_neg_pad, "CORTE.*COSTURA|COSTURQ") ~ "CORTE E COSTURA",
    
    str_detect(tipo_neg_pad, "TAXI") ~ "TAXI",
    
    str_detect(tipo_neg_pad, "MERCEARIA") ~ "MERCEARIA",
    
    str_detect(tipo_neg_pad, "CARVAO") ~ "VENDA CARVÃO",
    
    str_detect(tipo_neg_pad, "BADJIA") ~ "VENDA BADJIA",
    
    str_detect(tipo_neg_pad, "MAHEU") ~ "VENDA MAHEU",
    
    str_detect(tipo_neg_pad, "ALIMENTOS|PRODUTOS ALIMENTARES|COMIDA") ~ "VENDA ALIMENTOS",
    
    str_detect(tipo_neg_pad, "ROPA|ROUPAS|ROFODAS|CAPULANA") ~ "VENDA ROUPAS",
    
    str_detect(tipo_neg_pad, "PEIXE") ~ "VENDA PEIXE",
    
    str_detect(tipo_neg_pad, "REFRESCOS|BEBIDAS|GELINHO|FROZY|BEBIDAS CASEIRAS") ~ "VENDA BEBIDAS",
    
    TRUE ~ tipo_neg_pad # mantém os restantes sem mudança
  ))

table(Perfil_NEXUS$tipo_neg)
# Presencas_Nexus <- Presencas_Nexus %>%
#   select(
#     Distrito,
#     Comunidade,
#     Sexo,
#     Nome_participante,
#     Facilitadores,
#     all_of(sessao_cols_ordenadas)
#   )

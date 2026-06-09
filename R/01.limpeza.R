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



# devtools::install_github('muvamis/RZohoCreator')

############### PRESENCAS COLECTIVAS
# carrega as variaveis do ficheiro .env
dotenv::load_dot_env()

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





# table(Perfil_Mentoria$Tipo_Negocio)


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


sessao_cols <- names(Presencas_Nexus_Mentoria)[grepl("^Sessão_?\\d+$", names(Presencas_Nexus_Mentoria))]


sessao_cols_ordenadas <- sessao_cols[order(as.numeric(gsub("Sessão_?", "", sessao_cols)))]

####################### Acompanhamento Individual dos Negocios

Acompanhamento_Individuais_Nexus <- read_excel("Acompanhamento_Sessoes_Nexus.xlsx")


Acompanhamento_Individuais_Nexus <- Acompanhamento_Individuais_Nexus %>%
  select(-c(5,6,13,14,19))


Acompanhamento_Individuais_Nexus <- Acompanhamento_Individuais_Nexus %>%
  rename(
    Nome_participante = Nome_Participantes.Nome_Participante,
    Sexo = Nome_Participantes.Sexo,
    Facilitador = Nome_do_a_Facilitador_a,
    Presenca = Presen_as,
    Tipo_Sessao = Tipo_De_Sess_o,
    Observacoes_Gerais = Observa_es_Gerais,
    Data_Sessao = Data_da_Sess_o,
    Situacao_Participante = Classifica_o_do_a_participante.zc_display_value,
    Proximos_Passos = Pr_ximo_passo_combinado,
    Nome_Sessao = N_mero_da_sess_o,
    Acoes_Iniciadas = Ac_es_j_iniciadas,
    Dificuldades_Mencionadas_Resolucao = Dificuldades_mencionadas_e_como_ultrapassou
  )

Acompanhamento_Individuais_Nexus <- Acompanhamento_Individuais_Nexus %>%
  pivot_wider(
    names_from = Nome_Sessao,
    values_from = Presenca,
    values_fn = first
  )


Acompanhamento_Individuais_Nexus <- Acompanhamento_Individuais_Nexus %>%
  mutate(Facilitador = str_to_title(Facilitador))


sessao_cols <- names(Acompanhamento_Individuais_Nexus)[grepl("^Sessão_?\\d+$", names(Acompanhamento_Individuais_Nexus))]


sessao_cols_ordenadas <- sessao_cols[order(as.numeric(gsub("Sessão_?", "", sessao_cols)))]


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



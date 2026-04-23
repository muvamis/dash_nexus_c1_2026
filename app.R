
############################################
## UI
############################################
ui <- navbarPage(
  title = "Fazer_Prosperar",
  
  ############################################
  ## ESTILO E TEMA
  ############################################
  header = tags$head(
    tags$style(HTML("
      .navbar { background-color: #9442d4; }
      .navbar-default .navbar-nav > li > a { color: white; font-weight: bold; }
      .navbar-default .navbar-nav > li > a:hover { color: #5cd6c7; }
      .navbar-default .navbar-brand { color: white; font-weight: bold; }
      .navbar-default .navbar-brand:hover { color: #5cd6c7 !important; }

      .tab-content {
        background: #ffffff;
        padding: 15px;
        border-radius: 10px;
      }

      .value-box-container {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 15px;
      }

      .value-box {
        min-width: 150px;
        max-width: 220px;
        padding: 15px;
        border-radius: 12px;
        color: white;
        font-weight: bold;
        text-align: center;
        box-shadow: 2px 2px 6px rgba(0,0,0,0.2);
      }

      .blue   { background-color: #5cd6c7; }
      .green  { background-color: #6a1b9a; }
      .orange { background-color: #f77333; }
    "))
  ),
  
  ############################################
  ## PÁGINA 1 – VISÃO GERAL
  ############################################
  tabPanel(
    title = tagList(icon("chart-line"), "Visão Geral"),
    
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "filtro_distrito",
          "Selecionar Distrito:",
          choices = c("Todos", unique(Perfil_NEXUS$Distrito)),
          selected = "Todos"
        ),
        selectInput(
          "filtro_comunidade",
          "Selecionar Comunidade:",
          choices = c("Todas", unique(Perfil_NEXUS$Comunidade)),
          selected = "Todas"
        )
      ),
      
      mainPanel(
        uiOutput("texto_resumo"),
        div(
          class = "value-box-container",
          
          div(class = "value-box blue",
              textOutput("total_part"),
              div("Total de Participantes")),
          
          div(class = "value-box green",
              textOutput("total_mul"),
              div("Mulheres")),
          
          div(class = "value-box orange",
              textOutput("total_hom"),
              div("Homens"))
        ),
        
        br(),
        
        fluidRow(
          column(
            6,
            uiOutput("texto_grafico_ativo"),
            plotlyOutput("grafico_sexo")
          ),
          column(
            6,
            div(
              style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
              tags$p(
                style = "margin: 0; text-align: justify;",
                tags$b("Distribuição dos Beneficiários:"),
                "O gráfico apresenta a distribuição dos beneficiários por categoria:nomeadamente Pessoas Deslocadas Internamente (IDP), sobreviventes de Violência Baseada no Género (VBG) e Agregados Familiares (FA)."
              )
            ),
            plotlyOutput("grafico_distrito")
          )
        ),
        
        br(),
        
        fluidRow(
          column(
            6,
            div(
              style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
              tags$p(
                style = "margin: 0; text-align: justify;",
                tags$b("Número de Participantes Engajados em Actividades de Negócio:"),
                "O gráfico apresenta o número de participantes envolvidos em actividades de negócio, evidenciando o nível de engajamento económico no programa."
              )
            ),
            plotlyOutput("grafico_Negocio")
          ),
          column(
            6,
            div(
              style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
              tags$p(
                style = "margin: 0; text-align: justify;",
                tags$b("Distribuição de Participantes com Poupança:"),
                "O gráfico mostra a proporção de participantes que possuem poupança, permitindo avaliar a inclusão financeira e hábitos de economia dentro do programa."
              )
            ),
            plotlyOutput("grafico_Poupa")
          )
        ),
        
        br(),
        
        fluidRow(
          column(
            6,
            div(
              style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
              tags$p(
                style = "margin: 0; text-align: justify;",
                tags$b("Nível de Escolaridade:"),
                "O gráfico apresenta a distribuição dos participantes segundo o seu nível de escolaridade, permitindo compreender o perfil educativo do público-alvo do programa."
              )
            ),
            plotlyOutput("grafico_Escolaridade")
          ),
          column(
            6,
            div(
              style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
              tags$p(
                style = "margin: 0; text-align: justify;",
                tags$b("Estado Civil dos Participantes:"),
                "O gráfico apresenta a distribuição dos participantes de acordo com o seu estado civil, permitindo analisar a composição familiar e social do público-alvo."
              )
            ),
            plotlyOutput("grafico_Estado_Civil")
          )
        # ),
        # br(),
        # fluidRow(
        #   column(
        #     12,
        #     div(
        #       style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
        #       tags$p(
        #         style = "margin: 0; text-align: justify;",
        #         tags$b("Tipo de Negócios:"),
        #         "O gráfico apresenta a distribuição dos participantes segundo o tipo de negócio em que estão envolvidos, permitindo compreender a diversidade de actividades económicas no programa."
        #       )
        #     ),
        #     plotlyOutput("grafico_Negocios")
        #   )
          
        )
        
      )
    )
  ),
  
  ############################################
  ## PÁGINA 2 – PRESENÇAS COLECTIVAS
  ############################################
  tabPanel(
    title = "📋 Presenças_Colectivas",
    
    tabsetPanel(
      tabPanel(
        tagList(icon("users"), "Presenças Gerais"),
        
        sidebarLayout(
          sidebarPanel(
            selectInput(
              "distritoInput_namp_pi",
              "Distrito:",
              choices = c("TODOS", unique(Presencas_Nexus$Distrito))
            ),
            selectInput(
              "comunidadeInput_namp_pi",
              "Comunidade:",
              choices = c("TODAS", unique(Presencas_Nexus$Comunidade))
            )
          ),
          
          mainPanel(
            uiOutput("texto_participacao_sessoes"),
            br(),
            # downloadButton("baixarBasePresencasExcel", "Baixar Presenças"),
            withSpinner(plotlyOutput("graficoParticipacaoGlobal", height = "500px")),
            br(), br(),
       
            uiOutput("texto_participacao_sexo"),
            br(),
            withSpinner(plotlyOutput("graficoParticipacaoSexo", height = "400px"))
          )
        )
      ),
      
      tabPanel(
        tagList(icon("user-check"), "Presenças Individuais"),
        
        sidebarLayout(
          sidebarPanel(
            selectInput(
              "distritoInput_",
              "Distrito:",
              choices = c("TODOS", unique(Presencas_Nexus$Distrito))
            ),
            selectInput(
              "comunidadeAcompanhamento",
              "Comunidade:",
              choices = c("TODAS", unique(Presencas_Nexus$Comunidade))
            ),
            selectInput(
              "facilitadorInput",
              "Facilitador/a:",
              choices = c("TODOS", unique(Presencas_Nexus$Facilitadores))
            )
          ),
          
          mainPanel(
            fluidRow(
              column(
                6,
                uiOutput("texto_grafico_N"),
                br(),
                plotlyOutput("grafico_N")
              ),
              column(
                6,
                uiOutput("texto_situacao_interpretacao"),
                br(),
                plotlyOutput("grafico_situacao_C")
              )
            ),
            br(),
            div(
              style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
              tags$p(
                style = "margin: 0; text-align: justify;",
                tags$b(""),
                "A tabela a seguir ilustra a participação nas sessões colectivas: Os pontos roxos indicam a presença dos participantes em cada sessão, os pontos vermelhos indicam a ausência e cinzas 
                                                indicam dados faltantes/Não Preenchidos."
              )
            ),
            uiOutput("pontosPresenca"),
            dataTableOutput("tabelaPresencas")
          )
        )
      )
    )
  ),
  
  ############################################
  ## PÁGINA QUALIDADE DAS SESSOES
  ############################################
  tabPanel(
    title = tagList(icon("clipboard-check"), "Avaliação_Sessões"),

    sidebarLayout(
      sidebarPanel(
        selectInput("filtro_distrito_Qual", "Escolher Distrito",
                    choices = c("TODOS", unique(Qualidade_Sessoes$Distrito))
        ),
        selectInput("filtro_comunidade_Qual", "Escolher Comunidade",
                    choices = c("TODAS", unique(Qualidade_Sessoes$Comunidade))
        ),
        selectInput("filtro_facilitador_Qual", "Escolher Facilitador",
                    choices = c("TODOS", unique(Qualidade_Sessoes$Facilitadores))
        )
      ),

      mainPanel(
        div(
          style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
          tags$p(
            style = "margin: 0; text-align: justify;",
            tags$b("Qualidade das Sessões:"),
            "As sessões do projeto foram avaliadas pelos participantes considerando diferentes níveis de satisfação, desde Muito Mau até Muito Bom. 
      A avaliação reflete a experiência dos participantes, o engajamento e a relevância do conteúdo. 
      Esta análise permite identificar áreas de sucesso e oportunidades de melhoria, contribuindo para fortalecer a eficácia das futuras sessões e garantir maior impacto nas comunidades."
          )),
        DTOutput("tabela_qualidade")
      )
    )
  ),
  
  # Página 3 - Grants
  tabPanel(
    tagList(icon("hand-holding-usd"), "Grants"),
    
    sidebarLayout(
      sidebarPanel(
        
        selectInput("filtro_grants_distrito",  "Selecionar Distrito:",
                    choices = c("Todos", unique(Presencas_Nexus$Distrito)),
                    selected = "Todos"),
        
        selectInput("filtro_grants_facilitador", "Selecionar Facilitador:",
                    choices = c("Todos", unique(Presencas_Nexus$Facilitadores)),
                    selected = "Todos")
      ),
      
      mainPanel(
        
        div(
          style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
          tags$p(
            style = "margin: 0; text-align: justify;",
            "A elegibilidade para atribuição do grants foi definida com base na assiduidade, sendo considerados elegíveis apenas os participantes com pelo menos 66.7% de participação nas sessões (equivalente a um mínimo de 8 presenças em 12 sessões). Participantes com 4 ou mais faltas não são elegíveis."
          )
        ),
      
        plotlyOutput("grafico_percentagem_grants", height = "400px"),
        br(),
        div(
          style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
          tags$p(
            style = "margin: 0; text-align: justify;",
            "A tabela apresenta os participantes e respetivo estado de elegibilidade para atribuição do grants, com base na assiduidade registada. São considerados elegíveis os participantes com menor nível de faltas (menos de 4 ausencias), sendo esta informação refletida na coluna 'Elegivel_Grant'. Os participantes elegíveis são identificados a roxo, enquanto os não elegíveis são apresentados a laranja."
          )
        ),
        downloadButton("baixar_grants", "Baixar Lista (Excel)"),
        DT::dataTableOutput("tabela_grants")
      )
    )
  ), 
  
  ############################################
  ## PÁGINA 4 – ADMIN
  ############################################
  
  tabPanel(
    title = tagList(icon("piggy-bank"), "Poupança"),
    
    # sidebarLayout(
    #   sidebarPanel(
    #     # actionButton(
    #       # "botao_atualizar",
    #       # "📥 Carregar / Atualizar Dados",
    #       # class = "btn btn-warning"
    #     )
    #   ),
      
      mainPanel(
        verbatimTextOutput("stat"),
        dataTableOutput("tabela_")
      )
    ),
  
  tabPanel(
    title = tagList(icon("user-shield"), "Admin"),
    
    sidebarLayout(
      sidebarPanel(
        actionButton(
          "botao_atualizar",
          "📥 Carregar / Atualizar Dados",
          class = "btn btn-warning"
        )
      ),
      
      mainPanel(
        verbatimTextOutput("status_atualizacao"),
        dataTableOutput("tabela_admin_usuarios")
      )
    )
  )
)

############################################
## SERVER
############################################
server <- function(input, output, session){
  
  # VISÃO GERAL
  observeEvent(input$filtro_distrito, {
    
    if (input$filtro_distrito == "Todos") {
      comunidades <- sort(unique(Perfil_NEXUS$Comunidade))
    } else {
      comunidades <- Perfil_NEXUS %>%
        filter(Distrito == input$filtro_distrito) %>%
        pull(Comunidade) %>%
        unique() %>%
        sort()
    }
    
    updateSelectInput(
      session,
      inputId = "filtro_comunidade",
      choices = c("Todas", comunidades),
      selected = "Todas"
    )
  })
  
  
  dados_filtrados <- reactive({
    df <- Perfil_NEXUS
    
    if (input$filtro_distrito != "Todos") {
      df <- df %>% filter(Distrito == input$filtro_distrito)
    }
    
    if (input$filtro_comunidade != "Todas") {
      df <- df %>% filter(Comunidade == input$filtro_comunidade)
    }
    
    df
  })
  
  output$total_part <- renderText({
    nrow(dados_filtrados())
  })
  
  output$total_mul <- renderText({
    sum(dados_filtrados()$Sexo == "Feminino", na.rm = TRUE)
  })
  
  output$total_hom <- renderText({
    sum(dados_filtrados()$Sexo == "Masculino", na.rm = TRUE)
  })
  
  output$texto_resumo <- renderUI({
    
    df <- dados_filtrados()
    
    total <- nrow(df)
    mulheres <- sum(df$Sexo == "Feminino", na.rm = TRUE)
    homens <- sum(df$Sexo == "Masculino", na.rm = TRUE)
    
    distrito_sel <- input$filtro_distrito
    
    # Dados base por distrito
    monapo <- Perfil_NEXUS %>% filter(Distrito == "Monapo")
    mon_total <- nrow(monapo)
    mon_mul <- sum(monapo$Sexo == "Feminino", na.rm = TRUE)
    mon_hom <- sum(monapo$Sexo == "Masculino", na.rm = TRUE)
    
    nacala <- Perfil_NEXUS %>% filter(Distrito == "Nacala Porto")
    nac_total <- nrow(nacala)
    nac_mul <- sum(nacala$Sexo == "Feminino", na.rm = TRUE)
    nac_hom <- sum(nacala$Sexo == "Masculino", na.rm = TRUE)
    
    # 🎨 UI
    div(
      style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
      
      tags$p(
        style = "margin: 0; text-align: justify;",
        
        tags$b("Fazer Prosperar:"),
        "O projeto visa dar uma resposta transformadora às barreiras estruturais que limitam o acesso das pessoas deslocadas – particularmente mulheres e sobreviventes de violência baseada no género (VBG) – a oportunidades de geração de rendimento e inclusão económica sustentável.",
        
        br(), br(),
        
        # 🧠 TEXTO CONDICIONAL COM NEGRITO
        if (distrito_sel == "Todos") {
          
          tagList(
            "No total, foram selecionados ", tags$b(total),
            " participantes, dos quais ", tags$b(mulheres),
            " são mulheres e ", tags$b(homens), " homens. ",
            
            "No distrito de ", tags$b("Monapo"), ", registam-se ",
            tags$b(mon_total), " participantes (",
            tags$b(mon_mul), " mulheres e ",
            tags$b(mon_hom), " homens). ",
            
            "Em ", tags$b("Nacala Porto"), ", foram selecionados ",
            tags$b(nac_total), " participantes (",
            tags$b(nac_mul), " mulheres e ",
            tags$b(nac_hom), " homens), valores que se encontram refletidos nas caixas de indicadores abaixo."
          )
          
        } else {
          
          tagList(
            "No distrito de ", tags$b(distrito_sel), ", foram selecionados ",
            tags$b(total), " participantes, dos quais ",
            tags$b(mulheres), " são mulheres e ",
            tags$b(homens), " homens, valores que se encontram refletidos nas caixas de indicadores abaixo."
          )
        }
      )
    )
  })
  
  ### PERFIL DOS QUE INICIARAM A FORMACAO
  
  
  participantes_ativos <- reactive({
    
    df <- Perfil_NEXUS
    
    if (input$filtro_distrito != "Todos") {
      df <- df %>% filter(Distrito == input$filtro_distrito)
    }
    
    if (input$filtro_comunidade != "Todas") {
      df <- df %>% filter(Comunidade == input$filtro_comunidade)
    }
    
    df %>%
      filter(if_any(starts_with("Sessão"), ~ . == "Presente"))
  })
  
  output$grafico_sexo <- renderPlotly({
    
    df <- participantes_ativos() %>%
      count(Sexo) %>%
      mutate(
        Sexo = factor(Sexo, levels = c("Feminino", "Masculino"))
      )
    
    plot_ly(
      data   = df,
      labels = ~Sexo,
      values = ~n,
      type   = "pie",
      hole   = 0.5,
      textinfo = "label+percent",
      marker = list(
        colors = c("#9442d4", "#f77333")
      )
    ) %>%
      layout(
        title = "",
        showlegend = TRUE,
        paper_bgcolor = "#f5f3f4",
        plot_bgcolor  = "#f5f3f4"
      )
  })
  
  output$texto_grafico_ativo <- renderUI({
    
    df <- participantes_ativos()
    
    total <- nrow(df)
    mulheres <- sum(df$Sexo == "Feminino", na.rm = TRUE)
    homens <- sum(df$Sexo == "Masculino", na.rm = TRUE)
    
    perc_mul <- round(mulheres / total * 100, 1)
    perc_hom <- round(homens / total * 100, 1)
    
    distrito_sel <- input$filtro_distrito
    
    # 🧠 TEXTO DINÂMICO
    div(
      style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
      
      tags$p(
        style = "margin: 0; text-align: justify;",
        
        tags$b("Distribuição por sexo: "),
        
        if (distrito_sel == "Todos") {
          
          tagList(
            "O gráfico apresenta a proporção de participantes que iniciaram a formação e participaram em pelo menos uma sessão. ",
            
            "No total, ", tags$b(total), " participantes estão ativos, dos quais ",
            tags$b(mulheres), " (", tags$b(paste0(perc_mul, "%")), ") são mulheres e ",
            tags$b(homens), " (", tags$b(paste0(perc_hom, "%")), ") homens."
          )
          
        } else {
          
          tagList(
            "No distrito de ", tags$b(distrito_sel), ", o gráfico apresenta a proporção de participantes que participaram em pelo menos uma sessão. ",
            
            "Registam-se ", tags$b(total), " participantes ativos, dos quais ",
            tags$b(mulheres), " (", tags$b(paste0(perc_mul, "%")), ") são mulheres e ",
            tags$b(homens), " (", tags$b(paste0(perc_hom, "%")), ") homens."
          )
        }
      )
    )
  })
  
  # GRÁFICO DISTRITO – PERCENTUAL GERAL
  output$grafico_distrito <- renderPlotly({
    
    df <- participantes_ativos() %>%
      count(Situacao_Participante, Sexo) %>%
      ungroup() %>%
      mutate(
        total_geral = sum(n),  # soma geral de todos os participantes
        perc = round(n / total_geral * 100, 1),
        label = paste0(n, " (", perc, "%)"),
        Sexo = factor(Sexo, levels = c("Feminino","Masculino"))
      )
    
    plot_ly(
      df,
      x = ~Situacao_Participante,
      y = ~n,
      color = ~Sexo,
      colors = c("Feminino" = "#9442d4", "Masculino" = "#f77333"),
      type = "bar",
      text = ~label,
      textposition = "auto",           
      textfont = list(size=14, color="white"),
      hoverinfo = "y+text+name"
    ) %>%
      layout(
        barmode = "stack",
        title = "",
        showlegend = TRUE,
        paper_bgcolor = "#f5f3f4",
        plot_bgcolor  = "#f5f3f4",
        xaxis = list(title = ""),
        yaxis = list(title = "Número de participantes", range = c(0, 300))
      )
  })
  
  # GRÁFICO NEGÓCIO – PERCENTUAL GERAL
  output$grafico_Negocio <- renderPlotly({
    
    df <- participantes_ativos() %>%
      count(Tem_Negocio, Sexo) %>%
      ungroup() %>%
      mutate(
        total_geral = sum(n),  # soma geral de todos os participantes
        perc = round(n / total_geral * 100, 1),
        label = paste0(n, " (", perc, "%)"),
        Sexo = factor(Sexo, levels = c("Feminino","Masculino"))
      )
    
    plot_ly(
      df,
      x = ~Tem_Negocio,
      y = ~n,
      color = ~Sexo,
      colors = c("Feminino" = "#9442d4", "Masculino" = "#f77333"),
      type = "bar",
      text = ~label,
      textposition = "auto",           
      textfont = list(size=14, color="white"),
      hoverinfo = "y+text+name"
    ) %>%
      layout(
        barmode = "stack",
        title = "",
        showlegend = TRUE,
        paper_bgcolor = "#f5f3f4",
        plot_bgcolor  = "#f5f3f4",
        xaxis = list(title = ""),
        yaxis = list(title = "Número de participantes", range = c(0, 400))
      )
  })
  
  # GRÁFICO POUPANÇA – PERCENTUAL GERAL
  output$grafico_Poupa <- renderPlotly({
    
    df <- participantes_ativos() %>%
      count(Faz_Poupanca, Sexo) %>%
      ungroup() %>%
      mutate(
        total_geral = sum(n),
        perc = round(n / total_geral * 100, 1),
        label = paste0(n, " (", perc, "%)"),
        Sexo = factor(Sexo, levels = c("Feminino","Masculino"))
      )
    
    plot_ly(
      df,
      x = ~Faz_Poupanca,
      y = ~n,
      color = ~Sexo,
      colors = c("Feminino" = "#9442d4", "Masculino" = "#f77333"),
      type = "bar",
      text = ~label,
      textposition = "auto",
      textfont = list(size=14, color="white"),
      hoverinfo = "y+text+name"
    ) %>%
      layout(
        barmode = "stack",
        title = "",
        showlegend = TRUE,
        paper_bgcolor = "#f5f3f4",
        plot_bgcolor  = "#f5f3f4",
        xaxis = list(title = ""),
        yaxis = list(title = "Número de participantes", range = c(0, 400))
      )
  })
  
  # GRÁFICO ESCOLARIDADE – PERCENTUAL GERAL
  output$grafico_Escolaridade <- renderPlotly({
    
    req(participantes_ativos())
    
    df <- participantes_ativos() %>%
      filter(!is.na(Nivil_Educacao), !is.na(Sexo)) %>%
      count(Nivil_Educacao, Sexo) %>%
      ungroup() %>%
      mutate(
        total_geral = sum(n),
        perc  = round(n / total_geral * 100, 1),
        label = paste0(n, " (", perc, "%)"),
        Sexo = factor(Sexo, levels = c("Feminino", "Masculino")),
        Nivil_Educacao = factor(
          Nivil_Educacao,
          levels = c(
            "Nenhum","Ensino primário","7a classe","8a classe","9a classe",
            "10a classe","11a classe","12a classe","Ensino técnico médio"
          )
        )
      )
    
    validate(need(nrow(df) > 0, "Sem dados de escolaridade para os filtros selecionados."))
    
    plot_ly(
      df,
      x = ~Nivil_Educacao,
      y = ~n,
      color = ~Sexo,
      colors = c("Feminino"  = "#9442d4", "Masculino" = "#f77333"),
      type = "bar",
      text = ~label,
      textposition = "auto",
      textfont = list(size = 14, color = "black"),
      hovertemplate = paste(
        "<b>%{x}</b><br>",
        "Sexo: %{color}<br>",
        "Participantes: %{y}<br>",
        "Percentagem: %{text}<extra></extra>"
      )
    ) %>%
      layout(
        barmode = "stack",
        title = "",
        showlegend = TRUE,
        paper_bgcolor = "#f5f3f4",
        plot_bgcolor  = "#f5f3f4",
        xaxis = list(title = "", tickangle = -20),
        yaxis = list(title = "Número de participantes", range = c(0, 150))
      )
  })
  
  # GRÁFICO ESTADO CIVIL – PERCENTUAL GERAL
  output$grafico_Estado_Civil <- renderPlotly({
    
    req(participantes_ativos())
    
    df <- participantes_ativos() %>%
      filter(!is.na(Estado_Civil), !is.na(Sexo)) %>%
      count(Estado_Civil, Sexo) %>%
      ungroup() %>%
      mutate(
        total_geral = sum(n),
        perc = round(n / total_geral * 100, 1),
        label = paste0(n, " (", perc, "%)"),
        Estado_Civil = factor(
          Estado_Civil,
          levels = c("Solteria/o","Casada/o","União marital","Divorciada/Separado(a)","Viuva")
        ),
        Sexo = factor(Sexo, levels = c("Feminino", "Masculino"))
      )
    
    plot_ly(
      df,
      x = ~Estado_Civil,
      y = ~n,
      color = ~Sexo,
      colors = c("Feminino" = "#9442d4", "Masculino" = "#f77333"),
      type = "bar",
      text = ~label,
      textposition = "auto",
      textfont = list(size = 14, color = "black"),
      hovertemplate = paste(
        "<b>%{x}</b><br>",
        "Sexo: %{color}<br>",
        "Participantes: %{y}<br>",
        "Percentagem: %{text}<extra></extra>"
      )
    ) %>%
      layout(
        barmode = "stack",
        title = "",
        showlegend = TRUE,
        paper_bgcolor = "#f5f3f4",
        plot_bgcolor  = "#f5f3f4",
        xaxis = list(title = ""),
        yaxis = list(title = "Número de participantes", range = c(0, 200))
      )
  })
 
  
## GRAFICO DE NEGOCIOS
  
  output$grafico_Negocios <- renderPlotly({
    
    dados_negocios <- participantes_ativos %>%
      group_by(tipo_neg) %>%
      summarise(Quantidade = n(), .groups = "drop") %>%
      arrange(desc(Quantidade)) %>%  
      mutate(tipo_neg = factor(tipo_neg, levels = tipo_neg))  
    
    plot_ly(
      data = dados_negocios,
      x = ~tipo_neg,
      y = ~Quantidade,
      type = 'bar',
      text = ~Quantidade,
      textposition = 'auto'
    ) %>%
      layout(
        barmode = "stack",
        title = "",
        showlegend = TRUE,
        paper_bgcolor = "#f5f3f4",
        plot_bgcolor  = "#f5f3f4",
        xaxis = list(title = "", tickangle = -45),
        yaxis = list(title = "Número de participantes")
      )
  })
  
#   
#   # SESSÕES COLECTIVAS

   
    observe({
      req(input$distritoInput_namp_pi)
      
      df <- Presencas_Nexus
      if (input$distritoInput_namp_pi != "TODOS") {
        df <- df %>% filter(Distrito == input$distritoInput_namp_pi)
      }
      
      comunidades <- c("TODAS", sort(unique(df$Comunidade)))
      
      updateSelectInput(
        session,
        "comunidadeInput_namp_pi",
        choices = comunidades,
        selected = "TODAS"
      )
    })
  
    observe({
      req(input$comunidadeInput_namp_pi)
      
      df <- Presencas_Nexus
      if (input$distritoInput_namp_pi != "TODOS") df <- df %>% filter(Distrito == input$distritoInput_namp_pi)
      if (input$comunidadeInput_namp_pi != "TODAS") df <- df %>% filter(Comunidade == input$comunidadeInput_namp_pi)
      
      facilitadores <- c("TODOS", sort(unique(df$Facilitadores)))
      
      updateSelectInput(
        session,
        "facilitadorInput_namp_pi",
        choices = facilitadores,
        selected = "TODOS"
      )
    })
    
 
    dados_filtrados_presencas <- reactive({
      df <- Presencas_Nexus
      if (input$distritoInput_namp_pi != "TODOS") df <- df %>% filter(Distrito == input$distritoInput_namp_pi)
      if (input$comunidadeInput_namp_pi != "TODAS") df <- df %>% filter(Comunidade == input$comunidadeInput_namp_pi)
      if (!is.null(input$facilitadorInput_namp_pi) && input$facilitadorInput_namp_pi != "TODOS") df <- df %>% filter(Facilitadores == input$facilitadorInput_namp_pi)
      df
    })
    
  
    output$graficoParticipacaoGlobal <- renderPlotly({
      df <- dados_filtrados_presencas() 
      
      if (nrow(df) == 0) {
        showNotification("Nenhum dado disponível para os filtros selecionados.", type = "warning")
        return(NULL)
      }
      
     
      sessao_cols <- names(df)[grepl("^Sessão_?\\d+$", names(df))]
      sessao_cols_ordenadas <- sessao_cols[order(as.numeric(gsub("Sessão_?", "", sessao_cols)))]
      
      df_long <- df %>%
        tidyr::pivot_longer(
          cols = all_of(sessao_cols_ordenadas),
          names_to = "Sessao",
          values_to = "Presenca"
        ) %>%
        filter(Presenca == "Presente") %>%
        group_by(Sessao, Sexo) %>%
        summarise(Count = n(), .groups = "drop") %>%
        mutate(
          Count = as.numeric(Count),
          Sessao_Num = as.numeric(gsub("Sessão_?", "", Sessao))
        ) %>%
        arrange(Sessao_Num) %>%
        mutate(Sessao = factor(Sessao, levels = sessao_cols_ordenadas))
      
      totais_sessao <- df_long %>%
        group_by(Sessao) %>%
        summarise(total = sum(Count), .groups = "drop")
      
      linha_referencia <- if (input$distritoInput_namp_pi == "TODOS") 400 else 200
      
      df_long <- df_long %>%
        group_by(Sessao) %>%
        arrange(Sexo) %>%
        mutate(
          y0 = cumsum(lag(Count, default = 0)),
          y_center = y0 + Count / 2
        )
      
      annotations_segmentos <- lapply(1:nrow(df_long), function(i) {
        list(
          x = df_long$Sessao[i],
          y = df_long$y_center[i],
          text = as.character(df_long$Count[i]),
          showarrow = FALSE,
          font = list(size = 12, color = "white")
        )
      })
      
      annotations_totais <- lapply(1:nrow(totais_sessao), function(i) {
        list(
          x = totais_sessao$Sessao[i],
          y = totais_sessao$total[i] + 10,
          text = paste("", totais_sessao$total[i]),
          showarrow = FALSE,
          font = list(size = 12, color = "black")
        )
      })
      
      all_annotations <- c(annotations_segmentos, annotations_totais)
    
      plot_ly(
        data = df_long,
        x = ~Sessao,
        y = ~Count,
        color = ~Sexo,
        colors = c("Feminino" = "#9942D4", "Masculino" = "#F77333"),
        type = "bar",
        hovertemplate = "%{x}<br>Sexo: %{color}<br>Presenças: %{y}<extra></extra>"
      ) %>%
        layout(
          title = "",
          barmode = "stack",
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor = "#f5f3f4",
          xaxis = list(title = ""),
          yaxis = list(title = "Número de Presenças"),
          shapes = list(
            list(
              type = "line",
              x0 = 0,
              x1 = length(unique(df_long$Sessao)) + 1,
              y0 = linha_referencia,
              y1 = linha_referencia,
              line = list(color = "purple", dash = "dash", width = 2)
            )
          ),
          annotations = all_annotations
        )
    })
    
    output$texto_participacao_sessoes <- renderUI({
      
      df <- dados_filtrados_presencas()
      
      # ================================
      # 🎯 META DINÂMICA
      # ================================
      meta_total <- if (input$distritoInput_namp_pi == "TODOS") 400 else 200
      
      sessoes_cols <- names(df)[grepl("^Sessão_?\\d+$", names(df))]
      
      sessoes_data <- df[, sessoes_cols]
      
      presencas_por_sessao <- colSums(sessoes_data == "Presente", na.rm = TRUE)
      
      sessao_max <- names(which.max(presencas_por_sessao))
      valor_max <- max(presencas_por_sessao)
      
      sessao_min <- names(which.min(presencas_por_sessao))
      valor_min <- min(presencas_por_sessao)
      
      sessoes_atingiram <- names(presencas_por_sessao[presencas_por_sessao >= meta_total])
      
      media_sessoes <- mean(presencas_por_sessao)
      
      # ================================
      # 📌 CASO 1: TODOS
      # ================================
      if (input$distritoInput_namp_pi == "TODOS") {
        
        texto <- paste0(
          
          "A análise global do programa, considerando todos os distritos, ",
          "define uma meta de <b>", meta_total, "</b> participantes por sessão. ",
          
          "A sessão com maior participação foi <b>", sessao_max, "</b> com <b>", valor_max, "</b> presenças, ",
          "enquanto a menor participação ocorreu na <b>", sessao_min, "</b> com <b>", valor_min, "</b> presenças. ",
          
          if (length(sessoes_atingiram) > 0) {
            paste0("A(s) sessão(ões) que atingiu(aram) a meta foram: <b>",
                   paste(sessoes_atingiram, collapse = ", "),
                   "</b>. ")
          } else {
            "Nenhuma sessão atingiu a meta estabelecida. "
          },
          
          "Em média, as sessões registaram <b>", round(media_sessoes, 1), "</b> presenças."
        )
        
      } else {
        
        # ================================
        # 📌 CASO 2: DISTRITO SELECIONADO
        # ================================
        
        distrito <- input$distritoInput_namp_pi
        
        total_participantes <- nrow(df)
        
        texto <- paste0(
          
          "No distrito de <b>", distrito, "</b>, a análise das sessões ",
          "considera uma meta de <b>", meta_total, "</b> participantes por sessão. ",
          
          "Registam-se <b>", total_participantes, "</b> participantes no universo filtrado. ",
          
          "A sessão com maior participação foi <b>", sessao_max, "</b> com <b>", valor_max, "</b> presenças, ",
          "enquanto a menor participação ocorreu na <b>", sessao_min, "</b> com <b>", valor_min, "</b> presenças. ",
          
          if (length(sessoes_atingiram) > 0) {
            paste0("A(s) sessão(ões) que atingiu(aram) a meta foram: <b>",
                   paste(sessoes_atingiram, collapse = ", "),
                   "</b>. ")
          } else {
            "Nenhuma sessão atingiu a meta estabelecida. "
          },
          
          "Em média, as sessões registaram <b>", round(media_sessoes, 1), "</b> presenças no distrito."
        )
      }
      
      HTML(paste0(
        "<div style='background:#f5f3f4; padding:12px; border-radius:6px;'>",
        texto,
        "</div>"
      ))
    })
    ###################### PARTICIPACAO POR SEXO ##################  
  
    output$graficoParticipacaoSexo <- renderPlotly({
      
      df <- dados_filtrados_presencas()  
      
      if (nrow(df) == 0) {
        showNotification("Nenhum dado disponível para os filtros selecionados.", type = "warning")
        return(NULL)
      }
  
      sessao_cols <- names(df)[grepl("^Sessão_?\\d+$", names(df))]
      sessao_cols_ordenadas <- sessao_cols[order(as.numeric(gsub("Sessão_?", "", sessao_cols)))]
    
      previstos <- df %>%
        group_by(Sexo) %>%
        summarise(Previsto = n(), .groups = "drop")
    
      df_long <- df %>%
        tidyr::pivot_longer(
          cols = all_of(sessao_cols_ordenadas),
          names_to = "Sessao",
          values_to = "Presenca"
        ) %>%
        filter(Presenca == "Presente") %>%
        group_by(Sessao, Sexo) %>%
        summarise(Count = n(), .groups = "drop") %>%
        left_join(previstos, by = "Sexo") %>%
        mutate(
          Porcentagem = Count / Previsto * 100
        )
      
      df_long <- df_long %>%
        mutate(
          Sessao_Num = as.numeric(gsub("Sessão_?", "", Sessao)),
          Sessao = factor(Sessao, levels = sessao_cols_ordenadas)
        ) %>%
        arrange(Sessao_Num)
     
      df_long <- df_long %>%
        mutate(textpos = ifelse(Sexo == "Feminino", "top center", "bottom center"))
      
      
      cores_legenda <- c("Feminino" = "#9942D4", "Masculino" = "#F77333")
     
      max_porcentagem <- max(df_long$Porcentagem, na.rm = TRUE)
      limite_y <- ifelse(max_porcentagem + 10 > 100, max_porcentagem + 10, 110)  
     
      plot_ly(
        data = df_long,
        x = ~Sessao,
        y = ~Porcentagem,
        type = 'scatter',
        mode = 'lines+markers+text',
        color = ~Sexo,
        colors = cores_legenda,
        text = ~paste0(round(Porcentagem,1), "%"),
        textposition = ~textpos,
        marker = list(size = 10),
        line = list(width = 3),
        hovertemplate = "%{x}<br>Sexo: %{color}<br>Percentual: %{y:.1f}%<extra></extra>"
      ) %>%
        layout(
          title = list(
            text = "",
            font = list(size = 16, face = "bold")
          ),
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor = "#f5f3f4",
          xaxis = list(title = "Sessão", tickfont = list(size = 12)),
          yaxis = list(title = "Percentual (%)", range = c(0, limite_y), tickfont = list(size = 12)),
          legend = list(title = list(text = "<b>Sexo</b>"))
        )
    })
    
    output$texto_participacao_sexo <- renderUI({
      
      df <- dados_filtrados_presencas()
      
      sessoes_cols <- names(df)[grepl("^Sessão_?\\d+$", names(df))]
      
      previstos <- df %>%
        dplyr::count(Sexo) %>%
        dplyr::rename(Previsto = n)
      
      df_long <- df %>%
        tidyr::pivot_longer(
          cols = all_of(sessoes_cols),
          names_to = "Sessao",
          values_to = "Presenca"
        ) %>%
        dplyr::filter(Presenca == "Presente") %>%
        dplyr::group_by(Sessao, Sexo) %>%
        dplyr::summarise(Count = n(), .groups = "drop") %>%
        dplyr::left_join(previstos, by = "Sexo") %>%
        dplyr::mutate(Porcentagem = (Count / Previsto) * 100)
      
      # médias por sexo ao longo das sessões
      media_sexo <- df_long %>%
        dplyr::group_by(Sexo) %>%
        dplyr::summarise(media = mean(Porcentagem, na.rm = TRUE))
      
      sessoes_medias <- df_long %>%
        dplyr::group_by(Sessao) %>%
        dplyr::summarise(total = sum(Count), .groups = "drop")
      
      sessao_max <- sessoes_medias %>% dplyr::slice_max(total, n = 1)
      sessao_min <- sessoes_medias %>% dplyr::slice_min(total, n = 1)
      
      texto <- paste0(
        
        "O gráfico apresenta a evolução da participação por sessão, desagregada por sexo, ",
        "permitindo analisar o comportamento de adesão ao longo do processo formativo. ",
        
        "Em média, as mulheres registam <b>", round(media_sexo$media[media_sexo$Sexo == "Feminino"], 1), "%</b> ",
        "de participação e os homens <b>", round(media_sexo$media[media_sexo$Sexo == "Masculino"], 1), "%</b>. ",
        
        "A sessão com maior participação global é <b>", sessao_max$Sessao, "</b>, ",
        "enquanto a menor participação ocorre na <b>", sessao_min$Sessao, "</b>, ",
        "indicando variações no nível de engajamento ao longo das sessões."
      )
      
      HTML(paste0(
        "<div style='background:#f5f3f4; padding:12px; border-radius:6px;'>",
        texto,
        "</div>"
      ))
    })
    
    ################################ ACOMPANHAMENTO ################################## 
    # 🔹 Atualizar COMUNIDADE a partir do DISTRITO
    observeEvent(input$distritoInput_, {
      df <- Presencas_Nexus
      
      comunidades_filtradas <- if (input$distritoInput_ == "TODOS") {
        sort(unique(df$Comunidade))
      } else {
        sort(unique(df$Comunidade[df$Distrito == input$distritoInput_]))
      }
      
      updateSelectInput(
        session,
        "comunidadeAcompanhamento",
        choices = c("TODAS", comunidades_filtradas),
        selected = "TODAS"
      )
    })
    
    # 🔹 Atualizar FACILITADOR a partir de DISTRITO + COMUNIDADE
    observeEvent(
      list(input$distritoInput_, input$comunidadeAcompanhamento),
      {
        df <- Presencas_Nexus
        
        if (input$distritoInput_ != "TODOS") {
          df <- df %>% filter(Distrito == input$distritoInput_)
        }
        
        if (input$comunidadeAcompanhamento != "TODAS") {
          df <- df %>% filter(Comunidade == input$comunidadeAcompanhamento)
        }
        
        facilitadores_filtrados <- sort(unique(df$Facilitadores))
        
        updateSelectInput(
          session,
          "facilitadorInput",
          choices = c("TODOS", facilitadores_filtrados),
          selected = "TODOS"
        )
      },
      ignoreInit = TRUE
    )
    
    # 🔹 Função para formatar presença
    formatar_pontos <- function(x) {
      sapply(x, function(valor) {
        if (is.na(valor) || valor == "") {
          '<span style="color: grey; font-size: 40px;">&#9679;</span>'
        } else if (valor == "Presente") {
          '<span style="color: purple; font-size: 40px;">&#9679;</span>'
        } else if (valor == "Ausente") {
          '<span style="color: red; font-size: 40px;">&#9679;</span>'
        } else {
          '<span style="color: grey; font-size: 40px;">&#9679;</span>'
        }
      })
    }
    
    # 🔹 Detectar e ordenar colunas de sessões
    col_sessoes <- names(Presencas_Nexus)[grepl("^Sessão_?\\d+$", names(Presencas_Nexus))]
    col_sessoes_ordenadas <- col_sessoes[order(as.numeric(gsub("Sessão_?", "", col_sessoes)))]
    
    # 🔹 Dados filtrados
    dados_filtered <- reactive({
      df <- Presencas_Nexus
      
      if (input$distritoInput_ != "TODOS") {
        df <- df %>% filter(Distrito == input$distritoInput_)
      }
      
      if (input$comunidadeAcompanhamento != "TODAS") {
        df <- df %>% filter(Comunidade == input$comunidadeAcompanhamento)
      }
      
      if (input$facilitadorInput != "TODOS") {
        df <- df %>% filter(Facilitadores == input$facilitadorInput)
      }
      
      df <- df[, c(setdiff(names(df), col_sessoes_ordenadas), col_sessoes_ordenadas)]
      
      df <- df[rowSums(df[col_sessoes_ordenadas] == "Presente", na.rm = TRUE) > 0, ]
      
      df
    })
    
    # 🔹 Legenda visual
    output$pontosPresenca <- renderUI({
      HTML(
        paste0(
          '<span style="color: purple; font-size: 25px;">&#9679;</span> Presente &nbsp;&nbsp;',
          '<span style="color: red; font-size: 25px;">&#9679;</span> Ausente &nbsp;&nbsp;',
          '<span style="color: grey; font-size: 25px;">&#9679;</span> Não Preenchido'
        )
      )
    })
    
    # 🔹 Tabela
    output$tabelaPresencas <- renderDataTable({
      df <- dados_filtered()
      
      df[col_sessoes_ordenadas] <- lapply(df[col_sessoes_ordenadas], as.character)
      df[col_sessoes_ordenadas] <- lapply(df[col_sessoes_ordenadas], formatar_pontos)
      
      datatable(
        df[, c("Comunidade", "Nome_participante", col_sessoes_ordenadas)],
        escape = FALSE,
        rownames = FALSE,
        options = list(
          pageLength = 10,
          dom = "lfrtip",
          columnDefs = list(list(className = "dt-center", targets = "_all"))
        )
      )
    })
    
   ####### Participantes que concluiram a formacao PI 
    
    # ================================
    # 📊 BASE FILTRADA
    # ================================
    dados_filtrados <- reactive({
      
      df <- Presencas_Nexus
      
      if (input$distritoInput_ != "TODOS") {
        df <- df %>% dplyr::filter(Distrito == input$distritoInput_)
      }
      
      if (input$comunidadeAcompanhamento != "TODAS") {
        df <- df %>% dplyr::filter(Comunidade == input$comunidadeAcompanhamento)
      }
      
      if (input$facilitadorInput != "TODOS") {
        df <- df %>% dplyr::filter(Facilitadores == input$facilitadorInput)
      }
      
      df
    })
    
    # ================================
    # 📊 CLASSIFICAÇÃO DE CONCLUSÃO
    # ================================
    participantes_concluintes <- reactive({
      
      df <- dados_filtrados()
      
      sessoes <- df %>% 
        dplyr::select(starts_with("Sessão"))
      
      df$total_presencas <- rowSums(sessoes == "Presente", na.rm = TRUE)
      
      df$concluiu <- ifelse(df$total_presencas >= 8, "Concluiu", "Não concluiu")
      
      df
    })
    
    # =====================================================
    # 📊 GRÁFICO 1 — CONCLUINTES POR DISTRITO E SEXO
    # =====================================================
    dados_grafico <- reactive({
      
      participantes_concluintes() %>%
        dplyr::filter(concluiu == "Concluiu") %>%
        dplyr::count(Distrito, Sexo) %>%
        dplyr::group_by(Distrito) %>%
        dplyr::mutate(
          percent = (n / sum(n)) * 100,
          label = paste0(n, "<br>", round(percent, 1), "%")
        ) %>%
        dplyr::ungroup()
    })
    
    limite_y <- reactive({
      max(dados_grafico()$percent, na.rm = TRUE) * 1.2
    })
    
    output$grafico_N <- renderPlotly({
      
      plot_ly(
        data = dados_grafico(),
        x = ~Distrito,
        y = ~percent,
        color = ~Sexo,
        colors = c("Feminino" = "#9942D4", "Masculino" = "#F77333"),
        type = "bar",
        text = ~label,
        textposition = "outside",
        cliponaxis = FALSE
      ) %>%
        layout(
          title = list(
            text = "",
            font = list(size = 16)
          ),
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor = "#f5f3f4",
          xaxis = list(
            title = "Distrito",
            tickfont = list(size = 12)
          ),
          yaxis = list(
            title = "Percentual (%)",
            range = c(0, limite_y()),
            tickfont = list(size = 12)
          ),
          legend = list(title = list(text = "<b>Sexo</b>")),
          barmode = "group"
        )
    })
    
    output$texto_grafico_N <- renderUI({
      
      df_base <- participantes_concluintes() %>%
        dplyr::filter(concluiu == "Concluiu")
      
      distrito_sel <- input$distritoInput_
      
      # ================================
      # 📌 CASO 1: TODOS
      # ================================
      if (distrito_sel == "TODOS") {
        
        total_geral <- nrow(df_base)
        
        distritos <- df_base %>%
          dplyr::count(Distrito) %>%
          dplyr::mutate(percent = (n / sum(n)) * 100) %>%
          dplyr::arrange(desc(n))
        
        top <- distritos %>% dplyr::slice(1)
        
        sexo_geral <- df_base %>%
          dplyr::count(Sexo) %>%
          dplyr::mutate(percent = (n / sum(n)) * 100)
        
        fem <- sexo_geral$percent[sexo_geral$Sexo == "Feminino"]
        masc <- sexo_geral$percent[sexo_geral$Sexo == "Masculino"]
        
        texto <- paste0(
          "Consideram-se concluintes todos os participantes que participaram em pelo menos 8 das 12 sessões previstas. ",
          "No total, registam-se <b>", total_geral, "</b> concluintes (",
          round(sexo_geral$n[sexo_geral$Sexo == "Feminino"]), " mulheres e ",
          round(sexo_geral$n[sexo_geral$Sexo == "Masculino"]), " homens). ",
          
          "O distrito com maior representação é <b>", top$Distrito, "</b> com <b>", round(top$percent, 1), "%</b>."
        )
        
      } else {
        
        # ================================
        # 📌 CASO 2: DISTRITO SELECIONADO
        # ================================
        
        df_dist <- df_base %>%
          dplyr::filter(Distrito == distrito_sel)
        
        total_dist <- nrow(df_dist)
        
        sexo_dist <- df_dist %>%
          dplyr::count(Sexo) %>%
          dplyr::mutate(percent = (n / sum(n)) * 100)
        
        fem <- sexo_dist$percent[sexo_dist$Sexo == "Feminino"]
        masc <- sexo_dist$percent[sexo_dist$Sexo == "Masculino"]
        
        texto <- paste0(
          "No total, registam-se <b>", total_dist, "</b> concluintes do distrito de <b>", distrito_sel, "</b>, ",
          "com <b>", round(fem, 1), "%</b> feminino e <b>", round(masc, 1), "%</b> masculino."
        )
      }
      
      HTML(paste0(
        "<div style='background:#f5f3f4; padding:12px; border-radius:6px;'>",
        texto,
        "</div>"
      ))
    })
    
    
    # =====================================================
    # 📊 GRÁFICO 2 — SITUAÇÃO DOS CONCLUINTES
    # =====================================================
    dados_situacao <- reactive({
      
      df <- participantes_concluintes() %>%
        dplyr::filter(concluiu == "Concluiu")
      
      total_geral <- nrow(df)
      
      df %>%
        dplyr::count(Situacao_Participante, Sexo) %>%
        dplyr::mutate(
          percent_global = (n / total_geral) * 100,
          label = paste0(n, " (", round(percent_global, 1), "%)")
        )
    })
    
    limite_y_situacao <- reactive({
      100
    })
    
    output$grafico_situacao_C <- renderPlotly({
      
      plot_ly(
        data = dados_situacao(),
        x = ~Situacao_Participante,
        y = ~n,   # ✔ valores reais
        color = ~Sexo,
        colors = c("Feminino" = "#9942D4", "Masculino" = "#F77333"),
        type = "bar",
        
        text = ~label,
        
        textposition = "inside",
        insidetextanchor = "middle",
        
        textfont = list(
          size = 12,
          color = "white"
        ),
        
        hovertemplate = paste(
          "<b>Situação:</b> %{x}<br>",
          "<b>Sexo:</b> %{color}<br>",
          "<b>Valor:</b> %{y}<br>",
          "<b>% do total geral:</b> %{customdata:.1f}%<extra></extra>"
        ),
        
        customdata = ~percent_global
      ) %>%
        layout(
          title = list(text = ""),
          
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor = "#f5f3f4",
          
          xaxis = list(
            title = "Situação do Participante",
            tickangle = -25
          ),
          
          yaxis = list(
            title = "Número de Participantes"
          ),
          
          legend = list(title = list(text = "<b>Sexo</b>")),
          barmode = "stack"
        )
    })
    
    output$texto_situacao_interpretacao <- renderUI({
      
      df_base <- participantes_concluintes() %>%
        dplyr::filter(concluiu == "Concluiu")
      
      distrito_sel <- input$distritoInput_
      
      # ================================
      # 📌 CASO 1: TODOS
      # ================================
      if (distrito_sel == "TODOS") {
        
        total_geral <- nrow(df_base)
        
        sexo_geral <- df_base %>%
          dplyr::count(Sexo)
        
        situacao_geral <- df_base %>%
          dplyr::count(Situacao_Participante) %>%
          dplyr::mutate(percent = (n / sum(n)) * 100)
        
        texto <- paste0(
          "No total, registam-se <b>", total_geral, "</b> concluintes ",
          "(<b>", sexo_geral$n[sexo_geral$Sexo == "Feminino"], "</b> mulheres e ",
          "<b>", sexo_geral$n[sexo_geral$Sexo == "Masculino"], "</b> homens). ",
          
          "Em termos de situação dos concluintes, observa-se a seguinte distribuição: ",
          paste0(
            situacao_geral$Situacao_Participante,
            " (", round(situacao_geral$percent, 1), "%)",
            collapse = ", "
          ),
          "."
        )
        
      } else {
        
        # ================================
        # 📌 CASO 2: DISTRITO SELECIONADO
        # ================================
        
        df_dist <- df_base %>%
          dplyr::filter(Distrito == distrito_sel)
        
        total_dist <- nrow(df_dist)
        
        sexo_dist <- df_dist %>%
          dplyr::count(Sexo)
        
        situacao_dist <- df_dist %>%
          dplyr::count(Situacao_Participante) %>%
          dplyr::mutate(percent = (n / sum(n)) * 100)
        
        texto <- paste0(
          "No distrito de <b>", distrito_sel, "</b>, registam-se <b>", total_dist, "</b> concluintes ",
          "(<b>", sexo_dist$n[sexo_dist$Sexo == "Feminino"], "</b> mulheres e ",
          "<b>", sexo_dist$n[sexo_dist$Sexo == "Masculino"], "</b> homens). ",
          
          "Em termos de situação dos concluintes, observa-se a seguinte distribuição: ",
          paste0(
            situacao_dist$Situacao_Participante,
            " (", round(situacao_dist$percent, 1), "%)",
            collapse = ", "
          ),
          "."
        )
      }
      
      HTML(paste0(
        "<div style='background:#f5f3f4; padding:12px; border-radius:6px;'>",
        texto,
        "</div>"
      ))
    })
    ############# GRANTS
    
    ### 🔹 1. Preparar dados (fora do server ou no início)
    Presencas_Nexus <- Presencas_Nexus %>%
      mutate(
        # Contar presenças
        Total_Presencas = rowSums(
          across(matches("^Sessão_\\d+$"), ~ . == "Presente"),
          na.rm = TRUE
        ),
        
        # Contar AUSENTES
        Total_Ausentes = rowSums(
          across(matches("^Sessão_\\d+$"), ~ . == "Ausente"),
          na.rm = TRUE
        ),
        
        # Contar PROBLEMÁTICOS (NA ou Ausente)
        Total_Problematico = rowSums(
          across(matches("^Sessão_\\d+$"), ~ is.na(.) | . == "Ausente")
        ),
        
        # Total sessões
        Total_Sessoes = length(grep("^Sessão_\\d+$", names(Presencas_Nexus))),
        
        # Percentagem (continua útil)
        Percentual_Presenca = (Total_Presencas / Total_Sessoes) * 100,
        
        # REGRA FINAL (baseada em problemáticos)
        Elegivel_Grant = ifelse(Total_Problematico < 4, "Elegível", "Não Elegível")
      )
    
    ### 🔹 2. Reactive para filtros
    dados_grants <- reactive({
      
      df <- Presencas_Nexus
      
      if (input$filtro_grants_distrito != "Todos") {
        df <- df %>% filter(Distrito == input$filtro_grants_distrito)
      }
      
      if (input$filtro_grants_facilitador != "Todos") {
        df <- df %>% filter(Facilitadores == input$filtro_grants_facilitador)
      }
      
      df
    })
    
    
    ### 🔹 3. Tabela Grants
    output$tabela_grants <- DT::renderDataTable({
      
      df <- dados_grants()
      
      DT::datatable(
        df %>%
          select(
            Distrito,
            Comunidade,
            Facilitadores,
            Nome_participante,
            Total_Presencas,
            Total_Ausentes,
            Total_Problematico,
            Percentual_Presenca,
            Elegivel_Grant
          ),
        rownames = FALSE,
        options = list(
          pageLength = 10,
          dom = "lfrtip"
        )
      ) %>%
        
        DT::formatRound("Percentual_Presenca", 1) %>%
        
        DT::formatStyle(
          "Elegivel_Grant",
          target = "row",
          backgroundColor = DT::styleEqual(
            c("Elegível", "Não Elegível"),
            c("#9942D4", "#F77333")
          ),
          color = "white"
        )
    })
    
    output$baixar_grants <- downloadHandler(
      
      filename = function() {
        paste0("lista_grants_", Sys.Date(), ".xlsx")
      },
      
      content = function(file) {
        
        library(openxlsx)
        
        df <- dados_grants()
        
        # Selecionar colunas relevantes
        df_export <- df %>%
          select(
            Distrito,
            Facilitadores,
            Nome_participante,
            Total_Presencas,
            Total_Ausentes,
            Total_Problematico,
            Percentual_Presenca,
            Elegivel_Grant
          )
        
        # Criar ficheiro Excel
        write.xlsx(df_export, file)
      }
    )
    
    output$grafico_percentagem_grants <- renderPlotly({
      
      df <- Presencas_Nexus
      
      # ================================
      # 🔹 Filtros
      # ================================
      if (input$filtro_grants_distrito != "Todos") {
        df <- df %>% filter(Distrito == input$filtro_grants_distrito)
      }
      
      if (input$filtro_grants_facilitador != "Todos") {
        df <- df %>% filter(Facilitadores == input$filtro_grants_facilitador)
      }
      
      # ================================
      # 🔹 Agregação
      # ================================
      df <- df %>%
        group_by(Distrito, Sexo) %>%
        summarise(
          Total = n(),
          Elegiveis = sum(Elegivel_Grant == "Elegível"),
          Percentagem = (Elegiveis / Total) * 100,
          .groups = "drop"
        ) %>%
        arrange(desc(Percentagem))
      
      df$Sexo <- factor(df$Sexo, levels = c("Feminino", "Masculino"))
      
      # 🔹 Limite dinâmico
      limite_y <- max(df$Percentagem, na.rm = TRUE) + 15
      
      # ================================
      # 🔹 Gráfico
      # ================================
      plot_ly(
        df,
        x = ~Distrito,
        y = ~Percentagem,
        color = ~Sexo,
        colors = c("#9942D4", "#F77333"),
        type = "bar",
        
        # ✔️ Texto nas barras (AGORA COMPLETO)
        text = ~paste0(
          round(Percentagem,1), "%<br>(",
          Elegiveis, "/", Total, ")"
        ),
        textposition = "outside",
        
        # ✔️ Tooltip
        hoverinfo = "text",
        hovertext = ~paste0(
          "Distrito: ", Distrito,
          "<br>Sexo: ", Sexo,
          "<br>Elegíveis: ", Elegiveis,
          "<br>Total: ", Total,
          "<br>Taxa: ", round(Percentagem,1), "%"
        )
        
      ) %>%
        layout(
          barmode = "group",
          
          title = list(
            text = "",
            font = list(size = 16)
          ),
          
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor = "#f5f3f4",
          
          xaxis = list(
            title = "Distrito",
            tickfont = list(size = 12)
          ),
          
          yaxis = list(
            title = "Percentual (%)",
            range = c(0, limite_y),
            tickfont = list(size = 12)
          ),
          
          legend = list(
            title = list(text = "<b>Sexo</b>")
          ),
          
          annotations = list(
            list(
              text = "O gráfico apresenta a taxa de elegibilidade por distrito e sexo, incluindo percentagem e valores (Elegíveis/Total).",
              x = 0,
              y = 1.08,
              xref = "paper",
              yref = "paper",
              showarrow = FALSE,
              align = "left",
              font = list(size = 12)
            )
          )
        )
    })
    
################# PAGINA QUALIDADE DAS SESSOES
    
    # =========================
    # 1. Inicializa Distritos com "TODOS"
    observe({
      updateSelectInput(
        session, 
        "filtro_distrito_Qual",
        choices = c("TODOS", sort(unique(Qualidade_Sessoes$Distrito))),
        selected = "TODOS"
      )
    })
    
    # =========================
    # 2. Comunidades dependem do Distrito
    observeEvent(input$filtro_distrito_Qual, {
      dados <- Qualidade_Sessoes
      if (!is.null(input$filtro_distrito_Qual) && input$filtro_distrito_Qual != "TODOS") {
        dados <- dados %>% filter(Distrito %in% input$filtro_distrito_Qual)
      }
      updateSelectInput(
        session,
        "filtro_comunidade_Qual",
        choices = c("TODAS", sort(unique(dados$Comunidade))),
        selected = "TODAS"
      )
    })
    
    # =========================
    # 3. Facilitadores dependem da Comunidade
    observeEvent(c(input$filtro_distrito_Qual, input$filtro_comunidade_Qual), {
      dados <- Qualidade_Sessoes
      
      if (!is.null(input$filtro_distrito_Qual) && input$filtro_distrito_Qual != "TODOS") {
        dados <- dados %>% filter(Distrito %in% input$filtro_distrito_Qual)
      }
      
      if (!is.null(input$filtro_comunidade_Qual) && input$filtro_comunidade_Qual != "TODAS") {
        dados <- dados %>% filter(Comunidade %in% input$filtro_comunidade_Qual)
      }
      
      updateSelectInput(
        session,
        "filtro_facilitador_Qual",
        choices = c("TODOS", sort(unique(dados$Facilitadores))),
        selected = "TODOS"
      )
    })
    
    # =========================
    # 4. Dados filtrados
    dados_filtrados_Qual <- reactive({
      dados <- Qualidade_Sessoes
      
      if (!is.null(input$filtro_distrito_Qual) && input$filtro_distrito_Qual != "TODOS") {
        dados <- dados %>% filter(Distrito %in% input$filtro_distrito_Qual)
      }
      
      if (!is.null(input$filtro_comunidade_Qual) && input$filtro_comunidade_Qual != "TODAS") {
        dados <- dados %>% filter(Comunidade %in% input$filtro_comunidade_Qual)
      }
      
      if (!is.null(input$filtro_facilitador_Qual) && input$filtro_facilitador_Qual != "TODOS") {
        dados <- dados %>% filter(Facilitadores %in% input$filtro_facilitador_Qual)
      }
      
      dados
    })
    
    # =========================
    # 5. Renderizar tabela
    output$tabela_qualidade <- renderDT({
      # Remove nomes de colunas/linhas extras e garante data.frame
      df <- as.data.frame(dados_filtrados_Qual(), stringsAsFactors = FALSE)
      rownames(df) <- NULL   # remove nomes de linha que podem gerar warning
      
      datatable(df, options = list(pageLength = 10))
    })
    

#   
  # ADMIN
  # Função principal de atualização
  atualiza_dados <- function() {
    tryCatch({
      # Autenticação com Zoho
      client_id <- Sys.getenv("CLIENT_ID")
      client_secret <- Sys.getenv("CLIENT_SECRET")
      refresh_token <- Sys.getenv("REFRESH_TOKEN")
      
      access_token <- RZohoCreator::refresh_access_token(
        client_id, client_secret, refresh_token
      )$access_token
      
      ## 1. Presenças Coletivas
      dados <- RZohoCreator::get_records(
        "associacaomuva", "monitoria", "PRESENCAS_NEXUS_Report", access_token
      ) %>%
        data.frame()
      
      # Baixar
      writexl::write_xlsx(dados, path = "Presencas_Nexus.xlsx")
      
      ## 1. Presenças Coletivas
      Qualidade_Sessoes <- RZohoCreator::get_records(
        "associacaomuva", "monitoria", "Qualidade_Sess_es_Fazer_Prosperar_Report", access_token
      ) %>%
        data.frame()
      
      # Baixar
      writexl::write_xlsx(Qualidade_Sessoes, path = "Qualidade_Sessoes.xlsx")
      
      return(list(
        dados = dados,
        Qualidade_Sessoes = Qualidade_Sessoes
      ))
    }, error = function(e) {
      message("Erro ao atualizar dados: ", e$message)
      return(NULL)
    })
  }
  
  # Evento ao clicar no botão
  dados_atualizados <- eventReactive(input$botao_atualizar, {
    # Criar log da ação
    log_entry <- data.frame(
      usuario = "admin",  # como não há mais login, colocar fixo
      acao = "Atualizou os dados",
      hora = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
      stringsAsFactors = FALSE
    )
    
    # Ler e combinar com logs antigos
    if (file.exists("log_acoes.xlsx")) {
      log_existente <- readxl::read_excel("log_acoes.xlsx")
      log_total <- dplyr::bind_rows(log_existente, log_entry)
    } else {
      log_total <- log_entry
    }
    
    # Salvar o novo log
    writexl::write_xlsx(log_total, path = "log_acoes.xlsx")
    
    # Rodar atualização
    atualiza_dados()
  })
  
  # Mensagem de status
  output$status_atualizacao <- renderText({
    if (input$botao_atualizar > 0) {
      if (!is.null(dados_atualizados())) {
        paste0(
          "✅ Dados actualizados com sucesso em ",
          format(Sys.time(), "%d/%m/%Y %H:%M:%S"),
          ". Por favor, actualize (refresh) a página no navegador para ver as mudanças."
        )
      } else {
        "⚠️ Erro ao actualizar os dados. Verifique o log."
      }
    } else {
      "⏳ Aguardando actualização..."
    }
  })
}

############################################
## RUN APP
############################################
shinyApp(ui, server)

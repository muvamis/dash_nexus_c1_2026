
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
            uiOutput("pontosPresenca"),
            br(),
            uiOutput("texto_presencas"),
            br(),
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
        
        fluidRow(
          column(
            6,
            div(
              style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
              tags$p(
                style = "margin: 0; text-align: justify;",
                "A elegibilidade para atribuição do grants foi definida com base na assiduidade, sendo considerados elegíveis apenas os participantes com pelo menos 66.7% de participação nas sessões (equivalente a um mínimo de 8 presenças em 12 sessões)."
              )
            ),
            
            plotlyOutput("grafico_percentagem_grants", height = "400px"),
          ),
          column(
            6,
            uiOutput("texto_Receberam_grant"),
            
            br(),
            plotlyOutput("grafico_Receberam_grants")
          )
        ),
        br(),
        fluidRow(
          column(
            12,
            uiOutput("texto_Receberam_grants"),
          plotlyOutput("grafico_Receberam_Estado")
        )
      ),
        br(),
        div(
          style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
          tags$p(
            style = "margin: 0; text-align: justify;",
            "A tabela apresenta os participantes e respetivo estado de elegibilidade para atribuição do grants, com base na assiduidade registada. Não são considerados elegíveis os participantes com mais de 4 ausencias, sendo esta informação refletida na coluna 'Elegivel_Grant'. Os participantes elegíveis são identificados a roxo, enquanto os não elegíveis são apresentados a laranja."
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
    title = tagList(icon("hands-helping"), "Mentoria"),
    
    tabsetPanel(
      tabPanel(
        title = tagList(icon("chart-line"), "Overview"),
        
        sidebarLayout(
          
          sidebarPanel(
            
            selectInput(
              "overview_distrito_mentoria",
              "Distrito:",
              choices = c("TODOS", unique(Perfil_Mentoria$Distrito)),
              selected = "TODOS"
            ),
            
            selectInput(
              "overview_comunidade_mentoria",
              "Comunidade:",
              choices = c("TODAS", unique(Perfil_Mentoria$Comunidade)),
              selected = "TODAS"
            ),
            
            selectInput(
              "overview_facilitador_mentoria",
              "Facilitador:",
              choices = c("TODOS", unique(Perfil_Mentoria$Facilitadores_Mentoria)),
              selected = "TODOS"
            )
            
          ),
          
          mainPanel(
            
            uiOutput("texto_resumo_mentoria"),
            # 
            # div(
            #   class = "value-box-container",
            #   
            #   div(
            #     class = "value-box blue",
            #     textOutput("total_participantes_mentoria"),
            #     div("Participantes")
            #   ),
            #   
            #   div(
            #     class = "value-box green",
            #     textOutput("total_sessoes_mentoria"),
            #     div("Sessões Realizadas")
            #   ),
            #   
            #   div(
            #     class = "value-box orange",
            #     textOutput("total_acompanhamentos"),
            #     div("Acompanhamentos")
            #   ),
            #   
            #   div(
            #     class = "value-box red",
            #     textOutput("taxa_presenca"),
            #     div("Taxa Média de Presença")
            #   )
            # ),
            
            br(),
            
            fluidRow(
              
              column(
                6,
                
                div(
                  style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
                  tags$p(
                    style = "margin:0; text-align:justify;",
                    tags$b("Participantes da Mentoria:"),
                    "O gráfico apresenta a distribuição dos participantes registados na componente de mentoria de acordo com os filtros seleccionados."
                  )
                ),
                
                plotlyOutput("overview_participantes_mentoria")
                ),
              
              column(
                6,
                
                div(
                  style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
                  tags$p(
                    style = "margin:0; text-align:justify;",
                    tags$b("Participantes com Negócio:"),
                    "Apresenta a distribuição dos participantes que já possuem ou não possuem um negócio (Tem_Negocio)."
                  )
                ),
                
                plotlyOutput("overview_tem_negocio")
              )
              
            ),
            
            br(),
            
            fluidRow(
              
              column(
                12,
                div(
                  style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
                  tags$p(
                    style = "margin:0; text-align:justify;",
                    tags$b("Tipos de Negócio dos Participantes:"),
                    "O gráfico apresenta a distribuição dos participantes da mentoria por categoria de negócio, permitindo identificar as principais actividades económicas desenvolvidas e os sectores com maior concentração de empreendedores."
                  )
                ),
                
                plotlyOutput("overview_tipo_negocio")
              )
              
              # column(
              #   6,
              #   
              #   div(
              #     style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
              #     tags$p(
              #       style = "margin:0; text-align:justify;",
              #       tags$b("Acompanhamentos Individuais:"),
              #       "Mostra a distribuição dos acompanhamentos realizados pelos facilitadores."
              #     )
              #   ),
              #   
              #   plotlyOutput("overview_acompanhamentos")
              # )
              
            )
            
          )
        )
      ),
      
      
      # ==========================
      # 🟢 SESSÕES
      # ==========================
      tabPanel(
        title = tagList(icon("chalkboard-teacher"), "Sessões de Mentoria"),
        
        sidebarLayout(
          sidebarPanel(
            selectInput(
              "distritoInput_mentoria",
              "Distrito:",
              choices = c("TODOS", unique(Presencas_Nexus_Mentoria$Distrito))
            ),
            selectInput(
              "comunidade_mentoria",
              "Comunidade:",
              choices = c("TODAS", unique(Presencas_Nexus_Mentoria$Comunidade))
            ),
            selectInput(
              "facilitador_mentoria",
              "Facilitadores:",
              choices = c("TODOS", unique(Presencas_Nexus_Mentoria$Facilitadores))
            )
          ),
          
          mainPanel(
            uiOutput("texto_participacao_Mentoria"),
            br(),
            withSpinner(plotlyOutput("grafico_Participacao_Mentoria", height = "500px")),
            br(), br(),
            
            uiOutput("texto_participa_sexo"),
            br(),
            withSpinner(plotlyOutput("grafico_Participacao_Sexo", height = "400px")),
            br(),
            
            uiOutput("pontosPresenca_mentoria"),
            br(),
            uiOutput("texto_presencas_mentoria"),
            br(),
            
            dataTableOutput("tabelaPresencas_mentoria")
          )
        )
      ),
      
      tabPanel(
        title = tagList(icon("clipboard-check"), "Avaliação da Mentoria"),
        
        sidebarLayout(
          
          sidebarPanel(
            
            selectInput(
              "filtro_distrito_mentoria_qual",
              "Escolher Distrito",
              choices = c("TODOS", unique(Qualidade_Mentoria$Distrito))
            ),
            
            selectInput(
              "filtro_comunidade_mentoria_qual",
              "Escolher Comunidade",
              choices = c("TODAS", unique(Qualidade_Mentoria$Comunidade))
            ),
            
            selectInput(
              "filtro_facilitador_mentoria_qual",
              "Escolher Facilitador",
              choices = c("TODOS", unique(Qualidade_Mentoria$Facilitadores))
            )
            
          ),
          
          mainPanel(
            
            div(
              style = "background-color:#f5f3f4; padding:12px; border-radius:6px; margin-bottom:20px;",
              tags$p(
                style = "margin: 0; text-align: justify;",
                tags$b("Avaliação das Sessões de Mentoria: "),
                "Esta secção apresenta os resultados da avaliação das sessões de mentoria realizada pelos participantes. As avaliações refletem o nível de satisfação em relação à qualidade da facilitação, relevância dos conteúdos, utilidade prática dos temas abordados e participação durante as sessões. A análise permite monitorar a qualidade da mentoria, identificar pontos fortes e oportunidades de melhoria, contribuindo para o fortalecimento do processo de aprendizagem e desenvolvimento dos participantes."
              )
            ),
            
            DTOutput("tabela_qualidade_mentoria")
            
          )
        )
      ),
      
      # ==========================
      # 🔵 ACOMPANHAMENTO
      # ==========================
      tabPanel(
        title = tagList(icon("route"), "Acompanhamento"),
        
        sidebarLayout(
          sidebarPanel(
            selectInput(
              "distritoInput_mentoria_Acomp",
              "Distrito:",
              choices = c("TODOS", unique(Acompanhamento_Individuais_Nexus$Distrito))
            ),
            selectInput(
              "comunidade_mentoria_Acomp",
              "Comunidade:",
              choices = c("TODAS", unique(Acompanhamento_Individuais_Nexus$Comunidade))
            ),
            selectInput(
              "facilitador_mentoria_Acomp",
              "Facilitadores:",
              choices = c("TODOS", unique(Acompanhamento_Individuais_Nexus$Facilitador))
            )
          ),
          
          mainPanel(
            
            fluidRow(
              column(
                12,
                withSpinner(
                  plotlyOutput("grafico_acompanhamento_geral", height = "420px")
                )
              )
            ),
            
            br(),
            
            fluidRow(
              column(
                12,
                withSpinner(
                  dataTableOutput("tabelaAcompanhamento_Ind")
                )
              )
            ),
            
            br(),
            
            fluidRow(
              column(12, uiOutput("stat_visitas"))
            ),
            
            br(),
            
            fluidRow(
              column(12, dataTableOutput("tabela_visitas"))
            )
            
          )
        )
      ),
      
      # ==========================
      # 👤 ADMIN
      # ==========================
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
            
            "No total, ", tags$b(total), " participantes iniciaram a formação, dos quais ",
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
        total_geral = sum(n),  
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
    
    
    # =====================================================
    # 🎨 FUNÇÃO PONTOS
    # =====================================================
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
    
    # =====================================================
    # 🔁 UPDATE COMUNIDADE
    # =====================================================
    observeEvent(input$distritoInput_, {
      
      df <- Presencas_Nexus
      
      comunidades <- if (input$distritoInput_ == "TODOS") {
        sort(unique(df$Comunidade))
      } else {
        sort(unique(df$Comunidade[df$Distrito == input$distritoInput_]))
      }
      
      updateSelectInput(
        session,
        "comunidadeAcompanhamento",
        choices = c("TODAS", comunidades),
        selected = "TODAS"
      )
    })
    
    # =====================================================
    # 🔁 UPDATE FACILITADOR
    # =====================================================
    observeEvent(
      list(input$distritoInput_, input$comunidadeAcompanhamento),
      {
        
        df <- Presencas_Nexus
        
        if (input$distritoInput_ != "TODOS") {
          df <- df %>% dplyr::filter(Distrito == input$distritoInput_)
        }
        
        if (input$comunidadeAcompanhamento != "TODAS") {
          df <- df %>% dplyr::filter(Comunidade == input$comunidadeAcompanhamento)
        }
        
        facilitadores <- sort(unique(df$Facilitadores))
        
        updateSelectInput(
          session,
          "facilitadorInput",
          choices = c("TODOS", facilitadores),
          selected = "TODOS"
        )
      },
      ignoreInit = TRUE
    )
    
    # =====================================================
    # 📊 COLUNAS DE SESSÕES
    # =====================================================
    col_sessoes <- names(Presencas_Nexus)[grepl("^Sessão_?\\d+$", names(Presencas_Nexus))]
    col_sessoes <- col_sessoes[order(as.numeric(gsub("Sessão_?", "", col_sessoes)))]
    
    # =====================================================
    # 📊 DADOS FILTRADOS + QUALIDADE (OPÇÃO 2)
    # =====================================================
    dados_filtered <- reactive({
      
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
      
      total_sessoes <- length(col_sessoes)
      
      df <- df %>%
        dplyr::mutate(
          
          sessoes_preenchidas = rowSums(
            dplyr::across(all_of(col_sessoes), ~ !is.na(.) & . != ""),
            na.rm = TRUE
          ),
          
          score = round((sessoes_preenchidas / total_sessoes) * 100, 1),
          score = ifelse(score > 100, 100, score),
          
          # =========================
          # 🚦 QUALIDADE (OPÇÃO 2)
          # =========================
          qualidade = dplyr::case_when(
            score == 100 ~ "Excelente",
            score >= 80 ~ "Bom",
            score >= 60 ~ "Médio",
            TRUE ~ "Crítico"
          )
        )
      
      df <- df[rowSums(df[col_sessoes] == "Presente", na.rm = TRUE) > 0, ]
      
      df
    })
    
    # =====================================================
    # 🎨 LEGENDA
    # =====================================================
    output$pontosPresenca <- renderUI({
      
      HTML(paste0(
        '<span style="color: purple; font-size: 25px;">&#9679;</span> Presente &nbsp;&nbsp;',
        '<span style="color: red; font-size: 25px;">&#9679;</span> Ausente &nbsp;&nbsp;',
        '<span style="color: grey; font-size: 25px;">&#9679;</span> Não Preenchido'
      ))
    })
    
    # =====================================================
    # 🧠 TEXTO EXPLICATIVO
    # =====================================================
    output$texto_presencas <- renderUI({
      
      df <- dados_filtered()
      
      total <- nrow(df)
      media <- round(mean(df$score, na.rm = TRUE), 1)
      
      criticos <- sum(df$qualidade == "Crítico")
      excelentes <- sum(df$qualidade == "Excelente")
      
      facilitadores_criticos <- df %>%
        dplyr::group_by(Facilitadores) %>%
        dplyr::summarise(media = mean(score, na.rm = TRUE), .groups = "drop") %>%
        dplyr::filter(media < 60) %>%
        dplyr::pull(Facilitadores)
      
      txt_fac <- if (length(facilitadores_criticos) == 0) {
        "Nenhum facilitador crítico identificado."
      } else {
        paste(facilitadores_criticos, collapse = ", ")
      }
      
      div(
        style = "background-color:#f5f3f4; padding:12px; border-radius:6px;",
        
        tags$p(
          style = "margin:0; text-align:justify;",
          
          tags$b("📊 Qualidade de Dados — Presenças Individuais: "),
          
          "Foram analisados ", tags$b(total), " participantes. ",
          "A taxa média de qualidade é de ", tags$b(paste0(media, "%")), ". ",
          
          tags$br(), tags$br(),
          
          "🟢 Excelentes: ", tags$b(excelentes),
          " | 🟡 Bom/Médio/Crítico distribuídos no sistema. ",
          
          tags$br(), tags$br(),
          
          "🔴 Críticos: ", tags$b(criticos),
          
          tags$br(), tags$br(),
          
          tags$b("⚠️ Facilitadores com baixa qualidade de registo: "),
          txt_fac,
          
          tags$br(), tags$br(),
          
          "O indicador de qualidade segue uma escala de desempenho: ",
          "Excelente (100%), Bom (≥80%), Médio (≥60%) e Crítico (<60%). ",
          "Este painel permite monitoria contínua da qualidade dos dados e identificação de riscos operacionais."
        )
      )
    })
    
    # =====================================================
    # 📋 TABELA (CRÍTICOS PRIMEIRO)
    # =====================================================
    output$tabelaPresencas <- renderDataTable({
      
      df <- dados_filtered()
      
      df[col_sessoes] <- lapply(df[col_sessoes], as.character)
      df[col_sessoes] <- lapply(df[col_sessoes], formatar_pontos)
      
      df$qualidade <- factor(
        df$qualidade,
        levels = c("Crítico", "Médio", "Bom", "Excelente")
      )
      
      datatable(
        df[order(df$qualidade), c(
          "Comunidade",
          "Nome_participante",
          "score",
          "qualidade",
          col_sessoes
        )],
        
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
        Elegivel_Grant = ifelse(Total_Problematico <= 4, "Elegível", "Não Elegível")
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
              text = "",
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
    
    output$grafico_Receberam_grants <- renderPlotly({
      
      df <- Perfil_Mentoria
      
      # ================================
      # 🔹 Filtros (se quiseres manter consistência)
      # ================================
      if (input$filtro_grants_distrito != "Todos") {
        df <- df %>% filter(Distrito == input$filtro_grants_distrito)
      }
      
      if (input$filtro_grants_facilitador != "Todos") {
        df <- df %>% filter(Facilitadores == input$filtro_grants_facilitador)
      }
      
      # ================================
      # 🔹 Filtrar apenas quem recebeu grants
      # ================================
      df <- df %>%
        filter(Recebeu_Grants == "Sim")
      
      # ================================
      # 🔹 Agregação
      # ================================
      df <- df %>%
        group_by(Distrito, Sexo) %>%
        summarise(
          Total = n(),
          .groups = "drop"
        ) %>%
        arrange(desc(Total))
      
      df$Sexo <- factor(df$Sexo, levels = c("Feminino", "Masculino"))
      
      # 🔹 Limite dinâmico
      limite_y <- max(df$Total, na.rm = TRUE) + 15
      
      # ================================
      # 🔹 Gráfico
      # ================================
      plot_ly(
        df,
        x = ~Distrito,
        y = ~Total,
        color = ~Sexo,
        colors = c("#9942D4", "#F77333"),
        type = "bar",
        
        text = ~Total,
        textposition = "outside",
        
        hoverinfo = "text",
        hovertext = ~paste0(
          "Distrito: ", Distrito,
          "<br>Sexo: ", Sexo,
          "<br>Total que receberam Grants: ", Total
        )
        
      ) %>%
        layout(
          
          barmode = "group",
          
          title = list(
            text = "",
            font = list(size = 16)
          ),
          
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor  = "#f5f3f4",
          
          xaxis = list(
            title = "Distrito",
            tickfont = list(size = 12)
          ),
          
          yaxis = list(
            title = "Número de Participantes",
            range = c(0, limite_y),
            tickfont = list(size = 12)
          ),
          
          legend = list(
            title = list(text = "<b>Sexo</b>")
          )
        )
    })
    
    output$texto_Receberam_grant <- renderUI({
      
      df <- Perfil_Mentoria
      
      # =================================
      # FILTROS
      # =================================
      if (input$filtro_grants_distrito != "Todos") {
        
        df <- df %>%
          filter(Distrito == input$filtro_grants_distrito)
      }
      
      if (input$filtro_grants_facilitador != "Todos") {
        
        df <- df %>%
          filter(Facilitadores == input$filtro_grants_facilitador)
      }
      
      # =================================
      # ELEGÍVEIS
      # =================================
      elegiveis <- df %>%
        filter(Elegivel_Grant == "Elegível")
      
      # =================================
      # RECEBERAM
      # =================================
      receberam <- elegiveis %>%
        filter(Recebeu_Grants == "Sim")
      
      # =================================
      # RESUMO POR DISTRITO
      # =================================
      resumo <- elegiveis %>%
        
        group_by(Distrito, Sexo) %>%
        
        summarise(
          Elegiveis = n(),
          Receberam = sum(Recebeu_Grants == "Sim"),
          Percentagem = round((Receberam / Elegiveis) * 100, 1),
          .groups = "drop"
        )
      
      # =================================
      # TEXTO AUTOMÁTICO
      # =================================
      texto_final <- resumo %>%
        
        group_by(Distrito) %>%
        
        summarise(
          
          texto = paste0(
            
            "Em ", first(Distrito),
            
            ", dos ",
            
            sum(Elegiveis),
            
            " elegíveis (",
            
            Elegiveis[Sexo == "Feminino"],
            " feminino e ",
            
            Elegiveis[Sexo == "Masculino"],
            " masculino), receberam o grants ",
            
            sum(Receberam),
            
            " participantes (",
            
            Receberam[Sexo == "Feminino"],
            " feminino e ",
            
            Receberam[Sexo == "Masculino"],
            " masculino), correspondendo a ",
            
            round((sum(Receberam) / sum(Elegiveis)) * 100, 1),
            
            "% no total (",
            
            Percentagem[Sexo == "Feminino"],
            "% feminino e ",
            
            Percentagem[Sexo == "Masculino"],
            "% masculino)."
            
          ),
          
          .groups = "drop"
        )
      
      HTML(
        
        paste0(
          
          "<div style='background-color:#f5f3f4;
      padding:12px;
      border-radius:6px;
      margin-bottom:20px;
      text-align:justify;'>",
          
          paste(texto_final$texto, collapse = " "),
          
          "</div>"
        )
      )
      
    })
    
    # ==========================================
    # DADOS - SITUAÇÃO DOS QUE RECEBERAM GRANTS
    # ==========================================
    dados_situacao_grants <- reactive({
      
      df <- Perfil_Mentoria %>%
        
        dplyr::filter(
          Recebeu_Grants == "Sim"
        )
      
      # ----------------------------
      # FILTRO DISTRITO
      # ----------------------------
      if (input$filtro_grants_distrito != "Todos") {
        
        df <- df %>%
          dplyr::filter(
            Distrito == input$filtro_grants_distrito
          )
      }
      
      total_geral <- nrow(df)
      
      df %>%
        
        dplyr::count(Situacao_Participante, Sexo) %>%
        
        dplyr::mutate(
          
          percent_global = (n / total_geral) * 100,
          
          label = paste0(
            n,
            " (",
            round(percent_global, 1),
            "%)"
          )
        )
      
    })
    
    
    # ==========================================
    # GRÁFICO
    # ==========================================
    output$grafico_Receberam_Estado <- renderPlotly({
      
      plot_ly(
        
        data = dados_situacao_grants(),
        
        x = ~Situacao_Participante,
        y = ~n,
        
        color = ~Sexo,
        
        colors = c(
          "Feminino" = "#9942D4",
          "Masculino" = "#F77333"
        ),
        
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
          "<b>Participantes:</b> %{y}<br>",
          "<b>% do total:</b> %{customdata:.1f}%<extra></extra>"
        ),
        
        customdata = ~percent_global
        
      ) %>%
        
        layout(
          
          title = list(
            text = ""
          ),
          
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor  = "#f5f3f4",
          
          xaxis = list(
            title = "Situação do Participante",
            tickangle = -20
          ),
          
          yaxis = list(
            title = "Número de Participantes"
          ),
          
          legend = list(
            title = list(
              text = "<b>Sexo</b>"
            )
          ),
          
          barmode = "stack"
          
        )
      
    })
    
    
    # ==========================================
    # TEXTO INTERPRETATIVO
    # ==========================================
    output$texto_Receberam_grants <- renderUI({
      
      df <- Perfil_Mentoria %>%
        
        dplyr::filter(
          Recebeu_Grants == "Sim"
        )
      
      # ----------------------------
      # FILTRO DISTRITO
      # ----------------------------
      distrito_sel <- input$filtro_grants_distrito
      
      if (distrito_sel != "Todos") {
        
        df <- df %>%
          dplyr::filter(
            Distrito == distrito_sel
          )
      }
      
      # ----------------------------
      # TOTAIS
      # ----------------------------
      total_geral <- nrow(df)
      
      sexo_geral <- df %>%
        dplyr::count(Sexo)
      
      situacao_geral <- df %>%
        dplyr::count(Situacao_Participante) %>%
        dplyr::mutate(
          percent = (n / sum(n)) * 100
        )
      
      feminino <- ifelse(
        "Feminino" %in% sexo_geral$Sexo,
        sexo_geral$n[sexo_geral$Sexo == "Feminino"],
        0
      )
      
      masculino <- ifelse(
        "Masculino" %in% sexo_geral$Sexo,
        sexo_geral$n[sexo_geral$Sexo == "Masculino"],
        0
      )
      
      # ----------------------------
      # TEXTO
      # ----------------------------
      texto <- paste0(
        
        "Dos participantes que receberam grants, registam-se <b>",
        total_geral,
        "</b> beneficiários (<b>",
        feminino,
        "</b> mulheres e <b>",
        masculino,
        "</b> homens). ",
        
        "Em termos de situação dos participantes, observa-se a seguinte distribuição: ",
        
        paste0(
          situacao_geral$Situacao_Participante,
          " (",
          round(situacao_geral$percent, 1),
          "%)",
          collapse = ", "
        ),
        
        "."
      )
      
      HTML(
        
        paste0(
          
          "<div style='background:#f5f3f4;
      padding:12px;
      border-radius:6px;
      margin-bottom:20px;
      text-align:justify;'>",
          
          texto,
          
          "</div>"
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
    ########################### PAGINA DE MENTORIA ##################
    # 
    dados_overview_mentoria <- reactive({
      
      df <- Perfil_Mentoria %>%
        filter(Mentoria != "Não")   
      
      if(input$overview_distrito_mentoria != "TODOS"){
        df <- df %>%
          filter(Distrito == input$overview_distrito_mentoria)
      }
      
      if(input$overview_comunidade_mentoria != "TODAS"){
        df <- df %>%
          filter(Comunidade == input$overview_comunidade_mentoria)
      }
      
      if(input$overview_facilitador_mentoria != "TODOS"){
        df <- df %>%
          filter(Facilitadores_Mentoria == input$overview_facilitador_mentoria)
      }
      
      df
    })

    output$overview_participantes_mentoria <- renderPlotly({
      
      dados <- dados_overview_mentoria() %>%
        count(Distrito, Sexo) %>%
        group_by(Distrito) %>%
        mutate(
          total_distrito = sum(n),
          perc = round((n / total_distrito) * 100, 1),
          label = paste0(n, " (", perc, "%)")
        ) %>%
        ungroup()
      
      plot_ly(
        dados,
        x = ~Distrito,
        y = ~n,
        color = ~Sexo,
        colors = c(
          "Feminino" = "#9942D4",
          "Masculino" = "#F77333"
        ),
        type = "bar",
        text = ~label  
      ) %>%
        layout(
          barmode = "group",
          title = "",
          showlegend = TRUE,
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor  = "#f5f3f4",
          xaxis = list(title = "", tickangle = -45),
          yaxis = list(title = "Número de participantes")
        ) %>%
        config(displayModeBar = FALSE) %>%
        style(textposition = "outside")
      
    })

    output$overview_tem_negocio <- renderPlotly({
      
      dados <- dados_overview_mentoria() %>%
        count(Distrito, Sexo, Tem_Negocio) %>%
        group_by(Distrito, Sexo) %>%
        mutate(
          total_grupo = sum(n),
          perc = round(n / total_grupo * 100, 1),
          label = paste0(n, " (", perc, "%)")
        ) %>%
        ungroup()
      
      plot_ly(
        dados,
        x = ~Distrito,
        y = ~n,
        color = ~Sexo,
        colors = c(
          "Feminino" = "#9942D4",
          "Masculino" = "#F77333"
        ),
        type = "bar",
        text = ~label
      ) %>%
        layout(
          barmode = "group",
          title = "",
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor  = "#f5f3f4",
          xaxis = list(title = "", tickangle = -45),
          yaxis = list(title = "Número de participantes")
        ) %>%
        config(displayModeBar = FALSE) %>%
        style(textposition = "outside")
      
    })
    
    
    
    
    output$overview_tipo_negocio <- renderPlotly({
      
      dados <- Perfil_Mentoria %>%
        count(Tipo_Negocio) %>%
        arrange(desc(n))
      
      plot_ly(
        dados,
        x = ~reorder(Tipo_Negocio, n),
        y = ~n,
        type = "bar"
      ) %>%
        layout(
          title = "Tipos de Negócio",
          xaxis = list(title = ""),
          yaxis = list(title = "Número de participantes"),
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor = "#f5f3f4"
        )
      
    })
    
    
    observe({
      
      req(input$distritoInput_mentoria)
      
      df <- Presencas_Nexus_Mentoria
      
      if (input$distritoInput_mentoria != "TODOS") {
        df <- df %>%
          filter(Distrito == input$distritoInput_mentoria)
      }
      
      comunidades <- c("TODAS", sort(unique(df$Comunidade)))
      
      updateSelectInput(
        session,
        "comunidade_mentoria",
        choices = comunidades,
        selected = "TODAS"
      )
      
    })
    
    dados_filtrados_mentoria <- reactive({
      
      df <- Presencas_Nexus_Mentoria
      
      if (input$distritoInput_mentoria != "TODOS") {
        df <- df %>%
          filter(Distrito == input$distritoInput_mentoria)
      }
      
      if (input$comunidade_mentoria != "TODAS") {
        df <- df %>%
          filter(Comunidade == input$comunidade_mentoria)
      }
      
      if (input$facilitador_mentoria != "TODOS") {
        df <- df %>%
          filter(Facilitadores == input$facilitador_mentoria)
      }
      
      df
      
    })
    
    output$grafico_Participacao_Mentoria <- renderPlotly({
      
      df <- dados_filtrados_mentoria()
      
      validate(
        need(nrow(df) > 0, "Nenhum dado disponível.")
      )
      
      sessao_cols <- names(df)[grepl("^Sessão_?\\d+$", names(df))]
      
      sessao_cols_ordenadas <- sessao_cols[
        order(as.numeric(gsub("Sessão_?", "", sessao_cols)))
      ]
      
      df_long <- df %>%
        pivot_longer(
          cols = all_of(sessao_cols_ordenadas),
          names_to = "Sessao",
          values_to = "Presenca"
        ) %>%
        filter(Presenca == "Presente") %>%
        group_by(Sessao, Sexo) %>%
        summarise(Count = n(), .groups = "drop") %>%
        mutate(
          Sessao_Num = as.numeric(gsub("Sessão_?", "", Sessao))
        ) %>%
        arrange(Sessao_Num)
      
      totais_sessao <- df_long %>%
        group_by(Sessao) %>%
        summarise(total = sum(Count), .groups = "drop")
      
      df_long <- df_long %>%
        group_by(Sessao) %>%
        arrange(Sexo) %>%
        mutate(
          y0 = cumsum(lag(Count, default = 0)),
          y_center = y0 + Count / 2
        )
      
      annotations_segmentos <- lapply(seq_len(nrow(df_long)), function(i) {
        list(
          x = df_long$Sessao[i],
          y = df_long$y_center[i],
          text = df_long$Count[i],
          showarrow = FALSE,
          font = list(color = "white")
        )
      })
      
      annotations_totais <- lapply(seq_len(nrow(totais_sessao)), function(i) {
        list(
          x = totais_sessao$Sessao[i],
          y = totais_sessao$total[i] + 5,
          text = totais_sessao$total[i],
          showarrow = FALSE
        )
      })
      
      plot_ly(
        data = df_long,
        x = ~Sessao,
        y = ~Count,
        color = ~Sexo,
        colors = c(
          "Feminino" = "#9942D4",
          "Masculino" = "#F77333"
        ),
        type = "bar"
      ) %>%
        layout(
          barmode = "stack",
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor = "#f5f3f4",
          xaxis = list(title = ""),
          yaxis = list(title = "Número de Presenças"),
          annotations = c(
            annotations_segmentos,
            annotations_totais
          )
        )
      
    })
    
    output$texto_participacao_Mentoria <- renderUI({
      
      df <- dados_filtrados_mentoria()
      
      sessoes_cols <- names(df)[grepl("^Sessão_?\\d+$", names(df))]
      
      presencas_por_sessao <- colSums(
        df[, sessoes_cols] == "Presente",
        na.rm = TRUE
      )
      
      sessao_max <- names(which.max(presencas_por_sessao))
      valor_max <- max(presencas_por_sessao)
      
      sessao_min <- names(which.min(presencas_por_sessao))
      valor_min <- min(presencas_por_sessao)
      
      media_sessoes <- mean(presencas_por_sessao)
      
      texto <- paste0(
        "A sessão com maior participação foi <b>",
        sessao_max,
        "</b> com <b>",
        valor_max,
        "</b> presenças. A menor participação ocorreu na <b>",
        sessao_min,
        "</b> com <b>",
        valor_min,
        "</b> presenças. Em média as sessões registaram <b>",
        round(media_sessoes,1),
        "</b> participantes."
      )
      
      HTML(
        paste0(
          "<div style='background:#f5f3f4;padding:12px;border-radius:6px;'>",
          texto,
          "</div>"
        )
      )
      
    })
    
    output$grafico_Participacao_Sexo <- renderPlotly({
      
      df <- dados_filtrados_mentoria()
      
      sessao_cols <- names(df)[grepl("^Sessão_?\\d+$", names(df))]
      
      previstos <- df %>%
        count(Sexo) %>%
        rename(Previsto = n)
      
      df_long <- df %>%
        pivot_longer(
          cols = all_of(sessao_cols),
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
      
      plot_ly(
        data = df_long,
        x = ~Sessao,
        y = ~Porcentagem,
        type = "scatter",
        mode = "lines+markers+text",
        color = ~Sexo,
        colors = c(
          "Feminino" = "#9942D4",
          "Masculino" = "#F77333"
        ),
        text = ~paste0(round(Porcentagem,1), "%"),
        textposition = "top center"
      ) %>%
        layout(
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor = "#f5f3f4",
          xaxis = list(title = "Sessão"),
          yaxis = list(
            title = "Percentual (%)",
            range = c(0,110)
          )
        )
      
    })
    
    output$texto_participa_sexo <- renderUI({
      
      df <- dados_filtrados_mentoria()
      
      sessoes_cols <- names(df)[grepl("^Sessão_?\\d+$", names(df))]
      
      previstos <- df %>%
        count(Sexo) %>%
        rename(Previsto = n)
      
      df_long <- df %>%
        pivot_longer(
          cols = all_of(sessoes_cols),
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
      
      medias <- df_long %>%
        group_by(Sexo) %>%
        summarise(
          media = mean(Porcentagem),
          .groups = "drop"
        )
      
      texto <- paste0(
        "As mulheres apresentam uma participação média de <b>",
        round(medias$media[medias$Sexo == "Feminino"],1),
        "%</b> e os homens <b>",
        round(medias$media[medias$Sexo == "Masculino"],1),
        "%</b> ao longo das sessões de mentoria."
      )
      
      HTML(
        paste0(
          "<div style='background:#f5f3f4;padding:12px;border-radius:6px;'>",
          texto,
          "</div>"
        )
      )
      
    })
    
    # =====================================================
    # 🎨 FUNÇÃO PONTOS
    # =====================================================
    
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
    
    # =====================================================
    # 🔁 UPDATE COMUNIDADE
    # =====================================================
    
    observeEvent(input$distritoInput_mentoria, {
      
      df <- Presencas_Nexus_Mentoria
      
      comunidades <- if (input$distritoInput_mentoria == "TODOS") {
        
        sort(unique(df$Comunidade))
        
      } else {
        
        sort(unique(
          df$Comunidade[
            df$Distrito == input$distritoInput_mentoria
          ]
        ))
        
      }
      
      updateSelectInput(
        session,
        "comunidade_mentoria",
        choices = c("TODAS", comunidades),
        selected = "TODAS"
      )
      
    })
    
    # =====================================================
    # 🔁 UPDATE FACILITADOR
    # =====================================================
    
    observeEvent(
      
      list(
        input$distritoInput_mentoria,
        input$comunidade_mentoria
      ),
      
      {
        
        df <- Presencas_Nexus_Mentoria
        
        if (input$distritoInput_mentoria != "TODOS") {
          
          df <- df %>%
            filter(Distrito == input$distritoInput_mentoria)
          
        }
        
        if (input$comunidade_mentoria != "TODAS") {
          
          df <- df %>%
            filter(Comunidade == input$comunidade_mentoria)
          
        }
        
        facilitadores <- sort(unique(df$Facilitadores))
        
        updateSelectInput(
          session,
          "facilitador_mentoria",
          choices = c("TODOS", facilitadores),
          selected = "TODOS"
        )
        
      },
      
      ignoreInit = TRUE
      
    )
    
    # =====================================================
    # 📊 COLUNAS DE SESSÕES
    # =====================================================
    
    col_sessoes_mentoria <- names(Presencas_Nexus_Mentoria)[
      grepl("^Sessão_?\\d+$", names(Presencas_Nexus_Mentoria))
    ]
    
    col_sessoes_mentoria <- col_sessoes_mentoria[
      order(
        as.numeric(
          gsub("Sessão_?", "", col_sessoes_mentoria)
        )
      )
    ]
    
    # =====================================================
    # 📊 DADOS FILTRADOS
    # =====================================================
    
    dados_filtered_mentoria <- reactive({
      
      df <- Presencas_Nexus_Mentoria
      
      if (input$distritoInput_mentoria != "TODOS") {
        
        df <- df %>%
          filter(Distrito == input$distritoInput_mentoria)
        
      }
      
      if (input$comunidade_mentoria != "TODAS") {
        
        df <- df %>%
          filter(Comunidade == input$comunidade_mentoria)
        
      }
      
      if (input$facilitador_mentoria != "TODOS") {
        
        df <- df %>%
          filter(Facilitadores == input$facilitador_mentoria)
        
      }
      
      total_sessoes <- length(col_sessoes_mentoria)
      
      df <- df %>%
        
        mutate(
          
          sessoes_preenchidas = rowSums(
            
            across(
              all_of(col_sessoes_mentoria),
              ~ !is.na(.) & . != ""
            ),
            
            na.rm = TRUE
            
          ),
          
          score = round(
            (sessoes_preenchidas / total_sessoes) * 100,
            1
          ),
          
          score = ifelse(score > 100, 100, score),
          
          qualidade = case_when(
            
            score == 100 ~ "Excelente",
            
            score >= 80 ~ "Bom",
            
            score >= 60 ~ "Médio",
            
            TRUE ~ "Crítico"
            
          )
          
        )
      
      df <- df[
        rowSums(
          df[col_sessoes_mentoria] == "Presente",
          na.rm = TRUE
        ) > 0,
      ]
      
      df
      
    })
    
    # =====================================================
    # 🎨 LEGENDA
    # =====================================================
    
    output$pontosPresenca_mentoria <- renderUI({
      
      HTML(
        
        paste0(
          
          '<span style="color: purple; font-size: 25px;">&#9679;</span> Presente &nbsp;&nbsp;',
          
          '<span style="color: red; font-size: 25px;">&#9679;</span> Ausente &nbsp;&nbsp;',
          
          '<span style="color: grey; font-size: 25px;">&#9679;</span> Não Preenchido'
          
        )
        
      )
      
    })
    
    # =====================================================
    # 🧠 TEXTO EXPLICATIVO
    # =====================================================
    
    output$texto_presencas_mentoria <- renderUI({
      
      df <- dados_filtered_mentoria()
      
      total <- nrow(df)
      
      media <- round(
        mean(df$score, na.rm = TRUE),
        1
      )
      
      criticos <- sum(df$qualidade == "Crítico")
      
      excelentes <- sum(df$qualidade == "Excelente")
      
      facilitadores_criticos <- df %>%
        
        group_by(Facilitadores) %>%
        
        summarise(
          media = mean(score, na.rm = TRUE),
          .groups = "drop"
        ) %>%
        
        filter(media < 60) %>%
        
        pull(Facilitadores)
      
      txt_fac <- if (length(facilitadores_criticos) == 0) {
        
        "Nenhum facilitador crítico identificado."
        
      } else {
        
        paste(
          facilitadores_criticos,
          collapse = ", "
        )
        
      }
      
      div(
        
        style = "background-color:#f5f3f4;
             padding:12px;
             border-radius:6px;",
        
        tags$p(
          
          style = "margin:0;
               text-align:justify;",
          
          tags$b(
            "📊 Qualidade de Dados — Sessões de Mentoria: "
          ),
          
          "Foram analisados ",
          tags$b(total),
          " participantes. ",
          
          "A taxa média de qualidade é de ",
          tags$b(
            paste0(media, "%")
          ),
          ".",
          
          tags$br(),
          tags$br(),
          
          "🟢 Excelentes: ",
          tags$b(excelentes),
          
          tags$br(),
          tags$br(),
          
          "🔴 Críticos: ",
          tags$b(criticos),
          
          tags$br(),
          tags$br(),
          
          tags$b(
            "⚠️ Facilitadores com baixa qualidade de registo: "
          ),
          
          txt_fac,
          
          tags$br(),
          tags$br(),
          
          "O indicador de qualidade segue a classificação: ",
          "Excelente (100%), Bom (≥80%), Médio (≥60%) e Crítico (<60%)."
          
        )
        
      )
      
    })
    
    # =====================================================
    # 📋 TABELA DE PRESENÇAS
    # =====================================================
    
    output$tabelaPresencas_mentoria <- renderDataTable({
      
      df <- dados_filtered_mentoria()
      
      df[col_sessoes_mentoria] <- lapply(
        df[col_sessoes_mentoria],
        as.character
      )
      
      df[col_sessoes_mentoria] <- lapply(
        df[col_sessoes_mentoria],
        formatar_pontos
      )
      
      df$qualidade <- factor(
        
        df$qualidade,
        
        levels = c(
          "Crítico",
          "Médio",
          "Bom",
          "Excelente"
        )
        
      )
      
      datatable(
        
        df[
          order(df$qualidade),
          
          c(
            "Comunidade",
            "Nome_participante",
            "score",
            "qualidade",
            col_sessoes_mentoria
          )
          
        ],
        
        escape = FALSE,
        
        rownames = FALSE,
        
        options = list(
          
          pageLength = 10,
          
          scrollX = TRUE,
          
          dom = "lfrtip",
          
          columnDefs = list(
            list(
              className = "dt-center",
              targets = "_all"
            )
          )
          
        )
        
      )
      
    })
 ######################## ACOMPANHAMENTO
    dados_filtrados_acomp <- reactive({
      
      df <- Acompanhamento_Individuais_Nexus
      
      if (input$distritoInput_mentoria_Acomp != "TODOS") {
        df <- df %>%
          filter(Distrito == input$distritoInput_mentoria_Acomp)
      }
      
      if (input$comunidade_mentoria_Acomp != "TODAS") {
        df <- df %>%
          filter(Comunidade == input$comunidade_mentoria_Acomp)
      }
      
      if (input$facilitador_mentoria_Acomp != "TODOS") {
        df <- df %>%
          filter(Facilitador == input$facilitador_mentoria_Acomp)
      }
      
      df
      
    })
    
    output$grafico_acompanhamento_geral <- renderPlotly({
      
      df <- dados_filtrados_acomp()
      
      validate(
        need(nrow(df) > 0, "Nenhum dado disponível.")
      )
      
      # Identificar colunas das sessões individuais
      sessao_cols <- names(df)[
        grepl("^Sessão Individual", names(df))
      ]
      
      # Ordenar as sessões corretamente
      sessao_cols_ordenadas <- sessao_cols[
        order(
          as.numeric(
            stringr::str_extract(sessao_cols, "\\d+")
          )
        )
      ]
      
      # Transformar para formato longo
      df_long <- df %>%
        pivot_longer(
          cols = all_of(sessao_cols_ordenadas),
          names_to = "Sessao",
          values_to = "Presenca"
        ) %>%
        filter(Presenca == "Presente") %>%
        group_by(Sessao, Sexo) %>%
        summarise(
          Count = n(),
          .groups = "drop"
        )
      
      # Totais por sessão
      totais_sessao <- df_long %>%
        group_by(Sessao) %>%
        summarise(
          total = sum(Count),
          .groups = "drop"
        )
      
      # Posição dos rótulos dentro das barras
      df_long <- df_long %>%
        group_by(Sessao) %>%
        arrange(Sexo) %>%
        mutate(
          y0 = cumsum(lag(Count, default = 0)),
          y_center = y0 + Count / 2
        )
      
      # Rótulos dentro das barras
      annotations_segmentos <- lapply(
        seq_len(nrow(df_long)),
        function(i){
          
          list(
            x = df_long$Sessao[i],
            y = df_long$y_center[i],
            text = df_long$Count[i],
            showarrow = FALSE,
            font = list(color = "white")
          )
          
        }
      )
      
      # Rótulos dos totais
      annotations_totais <- lapply(
        seq_len(nrow(totais_sessao)),
        function(i){
          
          list(
            x = totais_sessao$Sessao[i],
            y = totais_sessao$total[i] + 2,
            text = totais_sessao$total[i],
            showarrow = FALSE,
            font = list(size = 12)
          )
          
        }
      )
      
      plot_ly(
        data = df_long,
        x = ~Sessao,
        y = ~Count,
        color = ~Sexo,
        colors = c(
          "Feminino" = "#9942D4",
          "Masculino" = "#F77333"
        ),
        type = "bar"
      ) %>%
        layout(
          barmode = "stack",
          paper_bgcolor = "#f5f3f4",
          plot_bgcolor = "#f5f3f4",
          xaxis = list(
            title = ""
          ),
          yaxis = list(
            title = "Número de Presenças"
          ),
          annotations = c(
            annotations_segmentos,
            annotations_totais
          )
        )
      
    })
    
    # =====================================================
    # 📊 COLUNAS DE SESSÕES - ACOMPANHAMENTO
    # =====================================================
    
    col_sessoes_ind <- names(Acompanhamento_Individuais_Nexus)[
      grepl("^Sessão Individual", names(Acompanhamento_Individuais_Nexus))
    ]
    
    col_sessoes_ind <- col_sessoes_ind[
      order(
        as.numeric(stringr::str_extract(col_sessoes_ind, "\\d+"))
      )
    ]
    
    # =====================================================
    # 📊 DADOS FILTRADOS + SCORE QUALIDADE
    # =====================================================
    
    dados_filtered_ind <- reactive({
      
      df <- Acompanhamento_Individuais_Nexus
      
      if (input$distritoInput_mentoria_Acomp != "TODOS") {
        df <- df %>% filter(Distrito == input$distritoInput_mentoria_Acomp)
      }
      
      if (input$comunidade_mentoria_Acomp != "TODAS") {
        df <- df %>% filter(Comunidade == input$comunidade_mentoria_Acomp)
      }
      
      if (input$facilitador_mentoria_Acomp != "TODOS") {
        df <- df %>% filter(Facilitador == input$facilitador_mentoria_Acomp)
      }
      
      total_sessoes <- length(col_sessoes_ind)
      
      df <- df %>%
        mutate(
          
          sessoes_preenchidas = rowSums(
            across(all_of(col_sessoes_ind), ~ !is.na(.) & . != ""),
            na.rm = TRUE
          ),
          
          score = round((sessoes_preenchidas / total_sessoes) * 100, 1),
          
          score = ifelse(score > 100, 100, score),
          
          qualidade = case_when(
            score == 100 ~ "Excelente",
            score >= 80 ~ "Bom",
            score >= 60 ~ "Médio",
            TRUE ~ "Crítico"
          )
        )
      
      df
    })
    
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
    output$tabelaAcompanhamento_Ind <- renderDataTable({
      
      df <- dados_filtered_ind()
      
      # transformar colunas em HTML bolinhas
      df[col_sessoes_ind] <- lapply(df[col_sessoes_ind], as.character)
      df[col_sessoes_ind] <- lapply(df[col_sessoes_ind], formatar_pontos)
      
      # ordenar qualidade
      df$qualidade <- factor(
        df$qualidade,
        levels = c("Crítico", "Médio", "Bom", "Excelente")
      )
      
      datatable(
        df[
          order(df$qualidade),
          c(
            "Comunidade",
            "Nome_participante",
            "score",
            "qualidade",
            col_sessoes_ind
          )
        ],
        escape = FALSE,
        rownames = FALSE,
        options = list(
          pageLength = 10,
          scrollX = TRUE,
          dom = "lfrtip",
          columnDefs = list(
            list(className = "dt-center", targets = "_all")
          )
        )
      )
      
    })
    
    # =========================
    # 1. Atualizar Distritos
    # =========================
    observe({
      
      updateSelectInput(
        session,
        "filtro_distrito_mentoria_qual",
        choices = c("TODOS", sort(unique(Qualidade_Mentoria$Distrito))),
        selected = "TODOS"
      )
      
    })
    
    # =========================
    # 2. Comunidades dependem do Distrito
    # =========================
    observeEvent(input$filtro_distrito_mentoria_qual, {
      
      dados <- Qualidade_Mentoria
      
      if (
        !is.null(input$filtro_distrito_mentoria_qual) &&
        input$filtro_distrito_mentoria_qual != "TODOS"
      ) {
        
        dados <- dados %>%
          filter(Distrito %in% input$filtro_distrito_mentoria_qual)
        
      }
      
      updateSelectInput(
        session,
        "filtro_comunidade_mentoria_qual",
        choices = c("TODAS", sort(unique(dados$Comunidade))),
        selected = "TODAS"
      )
      
    })
    
    # =========================
    # 3. Facilitadores dependem da Comunidade
    # =========================
    observeEvent(
      c(
        input$filtro_distrito_mentoria_qual,
        input$filtro_comunidade_mentoria_qual
      ),
      {
        
        dados <- Qualidade_Mentoria
        
        if (
          !is.null(input$filtro_distrito_mentoria_qual) &&
          input$filtro_distrito_mentoria_qual != "TODOS"
        ) {
          
          dados <- dados %>%
            filter(Distrito %in% input$filtro_distrito_mentoria_qual)
          
        }
        
        if (
          !is.null(input$filtro_comunidade_mentoria_qual) &&
          input$filtro_comunidade_mentoria_qual != "TODAS"
        ) {
          
          dados <- dados %>%
            filter(Comunidade %in% input$filtro_comunidade_mentoria_qual)
          
        }
        
        updateSelectInput(
          session,
          "filtro_facilitador_mentoria_qual",
          choices = c("TODOS", sort(unique(dados$Facilitadores))),
          selected = "TODOS"
        )
        
      }
    )
    
    # =========================
    # 4. Dados filtrados
    # =========================
    dados_filtrados_mentoria_qual <- reactive({
      
      dados <- Qualidade_Mentoria
      
      if (
        !is.null(input$filtro_distrito_mentoria_qual) &&
        input$filtro_distrito_mentoria_qual != "TODOS"
      ) {
        
        dados <- dados %>%
          filter(Distrito %in% input$filtro_distrito_mentoria_qual)
        
      }
      
      if (
        !is.null(input$filtro_comunidade_mentoria_qual) &&
        input$filtro_comunidade_mentoria_qual != "TODAS"
      ) {
        
        dados <- dados %>%
          filter(Comunidade %in% input$filtro_comunidade_mentoria_qual)
        
      }
      
      if (
        !is.null(input$filtro_facilitador_mentoria_qual) &&
        input$filtro_facilitador_mentoria_qual != "TODOS"
      ) {
        
        dados <- dados %>%
          filter(Facilitadores %in% input$filtro_facilitador_mentoria_qual)
        
      }
      
      dados
      
    })
    
    # =========================
    # 5. Renderizar tabela
    # =========================
    output$tabela_qualidade_mentoria <- renderDT({
      
      df <- as.data.frame(
        dados_filtrados_mentoria_qual(),
        stringsAsFactors = FALSE
      )
      
      rownames(df) <- NULL
      
      datatable(
        df,
        options = list(
          pageLength = 10,
          scrollX = TRUE
        )
      )
      
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
      
      # ## 1. Presenças Mentoria
      dados <- RZohoCreator::get_records(
        "associacaomuva", "monitoria", "PRESENCAS_NEXUS_Report", access_token
      ) %>%
        data.frame()

      # Baixar
      writexl::write_xlsx(dados, path = "Presencas_Nexus_Mentoria.xlsx")
      
      # 1. Presenças Coletivas
      Acompanhamento <- RZohoCreator::get_records(
        "associacaomuva", "monitoria", "NEXUS_ACOMPANHAMENTO_Report", access_token
      ) %>%
        data.frame()

      # Baixar
      writexl::write_xlsx(Acompanhamento , path = "Acompanhamento_Sessoes_Nexus.xlsx")
      
      Qualidade_Mentoria <- RZohoCreator::get_records(
        "associacaomuva", "monitoria", "Qualidade_Sess_es_Fazer_Prosperar_Report", access_token
      ) %>%
        data.frame()
      
      # Baixar
      writexl::write_xlsx(Qualidade_Mentoria, path = "Qualidade_Mentoria.xlsx")
      
      return(list(
         dados = dados,
         Acompanhamento = Acompanhamento,
         Qualidade_Mentoria = Qualidade_Mentoria 
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

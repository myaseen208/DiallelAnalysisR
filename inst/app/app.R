#-------------------------------------------------------------------------------------------------------------------
# DiallelAnalysisR: interactive analysis of diallel and related mating designs. Started by DiallelApp().
#-------------------------------------------------------------------------------------------------------------------
library(shiny)
library(DiallelAnalysisR)

analyses <- c(
    "Griffing"                       = "Griffing"
  , "Griffing over environments"     = "GriffingEnv"
  , "Heterosis"                      = "Heterosis"
  , "Hayman"                         = "Hayman"
  , "Gardner and Eberhart"           = "GardnerEberhart"
  , "Partial diallel"                = "PartialDiallel"
  , "Line x tester"                  = "LineTester"
  , "North Carolina design"          = "NCDesign"
  )

examples <- list(
    GriffingData1      = list(data = GriffingData1, analysis = "Griffing", method = 1)
  , GriffingData2      = list(data = GriffingData2, analysis = "Griffing", method = 2)
  , GriffingData3      = list(data = GriffingData3, analysis = "Griffing", method = 3)
  , GriffingData4      = list(data = GriffingData4, analysis = "Griffing", method = 4)
  , HaymanData         = list(data = HaymanData, analysis = "Hayman", method = 1)
  , PartialDiallelData = list(data = PartialDiallelData, analysis = "PartialDiallel", method = 1)
  , LineTesterData     = list(data = LineTesterData, analysis = "LineTester", method = 1)
  , NCData             = list(data = NCData[NCData$Design == 2, ], analysis = "NCDesign", method = 1)
  )

plot_choices <- list(
    griffing     = c("gca", "sca", "biplot", "residuals", "qq")
  , griffingenv  = c("gca", "gcaenv", "sca", "residuals", "qq")
  , heterosis    = c("MP", "BP", "SH", "residuals", "qq")
  , hayman       = c("WrVr", "residuals", "qq")
  , gardner      = c("effects", "specific", "residuals", "qq")
  , partial      = c("gca", "sca", "residuals", "qq")
  , linetester   = c("gca", "sca", "contribution", "biplot", "residuals", "qq")
  , ncdesign     = c("components", "residuals", "qq")
  )

# the roles of the columns for each analysis
roles <- function(analysis) {
  switch(
      analysis
    , LineTester  = c(y = "Response", Rep = "Replicate", a = "Line", b = "Tester")
    , NCDesign    = c(y = "Response", Rep = "Replicate", a = "Male", b = "Female")
    , GriffingEnv = c(y = "Response", Rep = "Replicate", a = "Female parent (Cross1)", b = "Male parent (Cross2)",
                      Env = "Environment")
    , c(y = "Response", Rep = "Replicate", a = "Female parent (Cross1)", b = "Male parent (Cross2)")
    )
}

guess <- function(nm, role) {
  pat <- switch(role, y = "^(y|yield|response)$", Rep = "^(rep|replicate|block)$", a = "^(cross1|line|male|female1)$",
                b = "^(cross2|tester|female)$", Env = "^(env|environment|location|loc|year|site)$")
  hit <- grep(pat, nm, ignore.case = TRUE, value = TRUE)
  if (length(hit)) hit[1L] else nm[1L]
}

ui <- bslib::page_sidebar(
    title   = "DiallelAnalysisR"
  , theme   = bslib::bs_theme(version = 5, bootswatch = "flatly")
  , sidebar = bslib::sidebar(
        width = 330
      , radioButtons("source", "Data", c("Example data set" = "example", "Upload a CSV file" = "upload"))
      , conditionalPanel("input.source == 'example'", selectInput("example", NULL, names(examples), selectize = FALSE))
      , conditionalPanel("input.source == 'upload'",
                         fileInput("file", NULL, accept = c(".csv", "text/csv")),
                         helpText("One row per plot; the parents, replicates and response in columns."))
      , selectInput("analysis", "Analysis", analyses, selectize = FALSE)
      , uiOutput("columns")
      , uiOutput("options")
      , actionButton("run", "Analyse", class = "btn-primary w-100")
      )
  , bslib::navset_card_tab(
        bslib::nav_panel("Data", tableOutput("data"))
      , bslib::nav_panel("Results", verbatimTextOutput("printed"), uiOutput("tables"))
      , bslib::nav_panel("Plots", uiOutput("plot_which"), plotOutput("plot", height = "560px"))
      , bslib::nav_panel(
            "Export"
          , p("Download the main tables of the analysis for a paper or report.")
          , radioButtons("format", "Format", c("Word (.docx)" = "docx", "LaTeX (.tex)" = "latex", "HTML" = "html",
                                                "Markdown" = "markdown"), inline = TRUE)
          , numericInput("digits", "Decimal places", 3, min = 0, max = 8, width = "160px")
          , downloadButton("download", "Download tables")
          , tags$hr()
          , p("The R code of the analysis, to repeat it in a script:")
          , verbatimTextOutput("code")
          )
      )
  )

server <- function(input, output, session) {
  dat <- reactive({
    if (input$source == "example") return(examples[[input$example]]$data)
    req(input$file)
    data.table::fread(input$file$datapath, data.table = FALSE)
  })

  observeEvent(input$example, {
    ex <- examples[[input$example]]
    updateSelectInput(session, "analysis", selected = ex$analysis)
  })

  output$data <- renderTable(utils::head(dat(), 200L), striped = TRUE, digits = 3)

  output$columns <- renderUI({
    nm <- names(dat())
    r <- roles(input$analysis)
    lapply(names(r), function(k) selectInput(paste0("col_", k), r[[k]], nm, selected = guess(nm, k), selectize = FALSE))
  })

  output$options <- renderUI({
    a <- input$analysis
    ex <- if (input$source == "example") examples[[input$example]]$method else 1
    switch(
        a
      , Griffing = tagList(
            selectInput("method", "Method", c("1: parents, F1 and reciprocals" = 1, "2: parents and F1" = 2,
                                             "3: F1 and reciprocals" = 3, "4: F1 only" = 4), selected = ex,
                        selectize = FALSE)
          , radioButtons("model", "Model", c("Fixed" = 1, "Random" = 2), inline = TRUE)
          , checkboxInput("split", "Split reciprocals into maternal and non-maternal parts", FALSE)
          )
      , GriffingEnv = tagList(
            selectInput("method", "Method", c("1" = 1, "2" = 2, "3" = 3, "4" = 4), selected = ex, selectize = FALSE)
          , radioButtons("model", "Model", c("Fixed" = 1, "Random" = 2), inline = TRUE)
          )
      , Heterosis = tagList(
            textInput("check", "Check (standard) variety, if any", "")
          , radioButtons("better", "Better parent", c("higher" = "higher", "lower" = "lower"), inline = TRUE)
          )
      , GardnerEberhart = tagList(
            radioButtons("ge", "Analysis", c("II" = 2, "III" = 3), inline = TRUE)
          , radioButtons("model", "Model", c("Fixed" = 1, "Random" = 2), inline = TRUE)
          )
      , LineTester = numericInput("inbreeding", "Inbreeding coefficient of the parents", 0, min = 0, max = 1, step = 0.25)
      , NCDesign = tagList(
            radioButtons("design", "Design", c("I" = 1, "II" = 2, "III" = 3), selected = 2, inline = TRUE)
          , numericInput("inbreeding", "Inbreeding coefficient of the parents", 0, min = 0, max = 1, step = 0.25)
          )
      , NULL
      )
  })

  call_text <- reactive({
    a <- input$analysis
    cols <- c(y = input$col_y, Rep = input$col_Rep, a = input$col_a, b = input$col_b)
    an <- switch(a, LineTester = c("Line", "Tester"), NCDesign = c("Male", "Female"), c("Cross1", "Cross2"))
    args <- c(y = cols[["y"]], Rep = cols[["Rep"]], stats::setNames(c(cols[["a"]], cols[["b"]]), an))
    if (a == "GriffingEnv") args <- c(args, Env = input$col_Env)
    args <- c(args, data = "data")
    extra <- switch(
        a
      , Griffing = c(Method = input$method, Model = input$model,
                     Reciprocal = if (isTRUE(input$split)) "\"split\"" else "\"combined\"")
      , GriffingEnv = c(Method = input$method, Model = input$model)
      , Heterosis = c(Check = if (nzchar(trimws(input$check))) sprintf("\"%s\"", trimws(input$check)) else "NULL",
                      Better = sprintf("\"%s\"", input$better))
      , GardnerEberhart = c(Analysis = input$ge, Model = input$model)
      , LineTester = c(Inbreeding = input$inbreeding)
      , NCDesign = c(Design = input$design, Inbreeding = input$inbreeding)
      , NULL
      )
    args <- c(args, extra)
    w <- max(nchar(names(args)))
    paste0("fit <-\n  ", a, "(\n", paste0("    ", c(" ", rep(",", length(args) - 1L)), " ",
           formatC(names(args), width = -w), " = ", args, collapse = "\n"), "\n    )")
  })

  fit <- eventReactive(input$run, {
    data <- dat()
    validate(need(all(c(input$col_y, input$col_Rep, input$col_a, input$col_b) %in% names(data)),
                  "Choose the columns of the analysis."))
    tryCatch(eval(parse(text = call_text())), error = function(e) validate(need(FALSE, conditionMessage(e))))
  })

  output$printed <- renderPrint(print(fit()))

  output$tables <- renderUI({
    tb <- da_tables(fit(), digits = 4)
    lapply(seq_along(tb), function(k) {
      id <- paste0("tab_", k)
      output[[id]] <- renderTable(tb[[k]], striped = TRUE, rownames = FALSE, na = "")
      tagList(h5(names(tb)[k]), tableOutput(id))
    })
  })

  output$plot_which <- renderUI({
    cls <- sub("^da_", "", class(fit())[1L])
    ch <- plot_choices[[cls]]
    if (cls == "griffing" && attr(fit(), "meta")$model == 2L) ch <- c("components" = "gca", ch[-(1:2)])
    radioButtons("which", NULL, ch, inline = TRUE)
  })

  output$plot <- renderPlot({
    req(input$which)
    print(plot(fit(), which = input$which))
  }, res = 110)

  output$code <- renderText(call_text())

  output$download <- downloadHandler(
      filename = function() paste0("diallel-tables.", c(docx = "docx", latex = "tex", html = "html",
                                                        markdown = "md")[[input$format]])
    , content  = function(file) da_export(fit(), file = file, format = input$format, digits = input$digits)
    )
}

shinyApp(ui, server)

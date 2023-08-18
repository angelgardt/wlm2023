#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(# Application title
  titlePanel("k-means"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "phi_slider",
        label = "φ",
        min = -360,
        max = 360,
        value = 45
      ),
      textInput(
        inputId = "phi_text",
        label = NULL,
        value = 45
      ),
      checkboxInput(inputId = "showsin", label = "sin", value = TRUE),
      checkboxInput(inputId = "showcos", label = "cos", value = TRUE),
      checkboxInput(inputId = "showsec", label = "sec", value = TRUE),
      checkboxInput(inputId = "showcsc", label = "csc", value = TRUE),
      checkboxInput(inputId = "showtan", label = "tan", value = TRUE),
      checkboxInput(inputId = "showcot", label = "cot", value = TRUE),
    ),
    
    # Show a plot of the generated distribution
    mainPanel(plotOutput("circlePlot"))
  ))

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  observeEvent(input$phi_text, {
    if (as.numeric(input$phi_text) != input$phi_slider)
    {
      updateSliderInput(
        session = session,
        inputId = 'phi_slider',
        value = input$phi_text
      ) # updateSliderInput
    }# if
  })
  
  observeEvent(input$phi_slider, {
    if (as.numeric(input$phi_text) != input$phi_slider)
    {
      updateTextInput(
        session = session,
        inputId = 'phi_text',
        value = input$phi_slider
      ) # updateTextInput
    }# if
  })
  
  output$circlePlot <- renderPlot({
    library(ggplot2)
    library(ggforce)
    
    theme_set(theme_bw())
    
    # axes limits
    xlim <- 1.5
    ylim <- 1.5
    step <- .5
    
    # funcs
    funcs <-c("sin", "cos", "sec", "csc", "tan", "cot")
    
    # get checkboxes
    showfuncs <- c(input$showsin, 
                   input$showcos, 
                   input$showsec, 
                   input$showcsc, 
                   input$showtan, 
                   input$showcot)
    
    # set colors
    colors <- list(
      sin = "red",
      cos = "blue",
      sec = "magenta",
      csc = "cyan",
      tan = "gold",
      cot = "orange"
    )[showfuncs]
    
    
    # calculate trig funs
    phi_deg <- as.numeric(input$phi_text)
    phi <- NISTunits::NISTdegTOradian(phi_deg)
    cosphi <- cos(phi)
    sinphi <- sin(phi)
    secphi <- 1 / cos(phi)
    cscphi <- 1 / sin(phi)
    tanphi <- tan(phi)
    cotphi <- 1 / tan(phi)
    
    # set coords
    coords <- tibble::tibble(
      func = factor(rep(funcs, each = 2),
                    ordered = TRUE,
                    levels = funcs),
      point = rep(c("start", "end"), times = 6),
      x = c(cosphi, cosphi, 0, cosphi, 0, 1, 0, 0, 1, 1, 0, cosphi),
      y = c(0, sinphi, 0, 0, 0, tanphi, 0, cscphi, 0, tanphi, cscphi, sinphi)
    ) |> dplyr::filter(func %in% funcs[showfuncs])
    
    # plot
    ggplot() +
      # axes
      geom_hline(yintercept = 0, color = "gray") +
      geom_vline(xintercept = 0, color = "gray") +
      # circle
      geom_circle(data = NULL,
                  aes(x0 = 0, y0 = 0, r = 1)) +
      # raduis vector
      geom_line(data = NULL,
                aes(x = c(0, cosphi),
                    y = c(0, sinphi))) +
      # sin
      geom_line(data = coords,
                aes(x = x,
                    y = y,
                    color = func)) +
      # dot
      geom_point(data = NULL,
                 aes(x = cosphi,
                     y = sinphi)) +
      scale_x_continuous(breaks = seq(-xlim, xlim, by = step)) +
      scale_y_continuous(breaks = seq(-ylim, ylim, by = step)) +
      labs(x = NULL, y = NULL) +
      coord_fixed(xlim = c(-xlim, xlim),
                  ylim = c(-ylim, ylim)) +
      labs(color = NULL) +
      theme(legend.position = "bottom") +
      scale_color_manual(values = unlist(colors))
    
  })
}

# Run the application
shinyApp(ui = ui, server = server)
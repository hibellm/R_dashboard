
#' Car Add & info Module
#'
#' Module to add & info cars in the mtcars database file
#'
#' @importFrom shiny observeEvent showModal modalDialog removeModal fluidRow column textInput numericInput selectInput modalButton actionButton reactive eventReactive
#' @importFrom shinyFeedback showFeedbackDanger hideFeedback
#' @importFrom shinyjs enable disable
#' @importFrom lubridate with_tz
#' @importFrom uuid UUIDgenerate
#' @importFrom DBI dbExecute
#' @importFrom shinytoastr toastr_success toastr_error
#'
#' @param modal_title string - the title for the modal
#' @param car_to_info reactive returning a 1 row data frame of the car to info
#' from the "mt_cars" table
#' @param modal_trigger reactive trigger to open the modal (Add or info buttons)
#'
#' @return None

car_info_module <- function(input, output, session, modal_title, car_to_info, modal_trigger) {
  ns <- session$ns
  
  # THE INFO MODAL
  observeEvent(modal_trigger(), {
    hold <- car_to_info()
    
    showModal(
      modalDialog(
        fluidRow(
          column(
            width = 6,
            textInput(
              ns("Sepal_Width"),
              'Model',
              value = ifelse(is.null(hold), "", hold$Sepal_Width)
            ),
            numericInput(
              ns('Sepal_Length'),
              'Miles/Gallon',
              value = ifelse(is.null(hold), "", hold$Sepal_Length),
              min = 0,
              step = 0.1
            ),
            textInput(
              ns('Petal_Width'),
              'Transmission',
              # choices = c('Automatic', 'Manual'),
              value = ifelse(is.null(hold), "", hold$Petal_Width)
            ),
            numericInput(
              ns('Petal_Length'),
              'Displacement (cu.in.)',
              value = ifelse(is.null(hold), "", hold$Petal_Length),
              min = 0,
              step = 0.1
            ),
            numericInput(
              ns('Species'),
              'Horsepower',
              value = ifelse(is.null(hold), "", hold$Species),
              min = 0,
              step = 1
            ))
        ),
        title = modal_title,
        size = 'm',
        footer = list(
          modalButton('close')
        )
      )
    )
    
    # Observe event for "Model" text input in Add/info Car Modal
    # `shinyFeedback`
    observeEvent(input$model, {
      if (input$model == "") {
        shinyFeedback::showFeedbackDanger(
          "model",
          text = "Must enter model of car!"
        )
        shinyjs::disable('submit')
      } else {
        shinyFeedback::hideFeedback("model")
        shinyjs::enable('submit')
      }
    })
    
  })
  
  
  
  
  
  info_car_dat <- reactive({
    hold <- car_to_info()
    
    out <- list(
      uid = if (is.null(hold)) NA else hold$uid,
      data = list(
        "Sepal Width" = input$Sepal.Width,
        "mpg" = input$Sepal.Length,
        "cyl" = input$Petal.Width,
        "disp" = input$Petal.Length,
        "hp" = input$Species
      )
    )
    
    time_now <- as.character(lubridate::with_tz(Sys.time(), tzone = "UTC"))
    
    if (is.null(hold)) {
      # adding a new car
      out$data$created_at <- time_now
      out$data$created_by <- session$userData$email
    } else {
      # infoing existing car
      out$data$created_at <- as.character(hold$created_at)
      out$data$created_by <- hold$created_by
    }
    out$data$modified_at <- time_now
    out$data$modified_by <- session$userData$email
    out
  })
  
  validate_info <- eventReactive(input$submit, {
    dat <- info_car_dat()
    
    # Logic to validate inputs...
    dat
  })
  
  observeEvent(validate_info(), {
    removeModal()
    dat <- validate_info()
    
    tryCatch({
      
      if (is.na(dat$uid)) {
        # creating a new car
        uid <- uuid::UUIDgenerate()
        
        dbExecute(
          conn,
          "INSERT INTO mtcars (uid, model, mpg, cyl, disp, hp, drat, wt, qsec, vs, am,
          gear, carb, created_at, created_by, modified_at, modified_by) VALUES
          ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)",
          params = c(
            list(uid),
            unname(dat$data)
          )
        )
      } else {
        # infoing an existing car
        dbExecute(
          conn,
          "UPDATE mtcars SET model=$1, mpg=$2, cyl=$3, disp=$4, hp=$5, drat=$6,
          wt=$7, qsec=$8, vs=$9, am=$10, gear=$11, carb=$12, created_at=$13, created_by=$14,
          modified_at=$15, modified_by=$16 WHERE uid=$17",
          params = c(
            unname(dat$data),
            list(dat$uid)
          )
        )
      }
      
      session$userData$mtcars_trigger(session$userData$mtcars_trigger() + 1)
      showToast("success", paste0(modal_title, " Successs"))
    }, error = function(error) {
      
      showToast("error", paste0(modal_title, " Error"))
      
      print(error)
    })
  })
  
}

#' Car Add & down Module
#'
#' Module to add & down cars in the mtcars database file
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
#' @param car_to_down reactive returning a 1 row data frame of the car to down
#' from the "mt_cars" table
#' @param modal_trigger reactive trigger to open the modal (Add or down buttons)
#'
#' @return None

car_down_module <- function(input, output, session, modal_title, car_to_down, modal_trigger) {
  ns <- session$ns
  
  
  # DOWNLOAD DATA
  observeEvent(modal_trigger(), {
    hold <- car_to_down()
    
    showModal(
      modalDialog(
        fluidRow(
          column(width = 6,
                 textInput(ns("model"),'Model',value = ifelse(is.null(hold), "", hold$model)),
                 numericInput(ns('mpg'),'Miles/Gallon',value = ifelse(is.null(hold), "", hold$mpg),min = 0,step = 0.1),
                 selectInput(ns('am'),'Transmission',choices = c('Automatic', 'Manual'),selected = ifelse(is.null(hold), "", hold$am)),
                 numericInput(ns('disp'),'Displacement (cu.in.)',value = ifelse(is.null(hold), "", hold$disp),min = 0,step = 0.1),
                 numericInput(ns('hp'),'Horsepower',value = ifelse(is.null(hold), "", hold$hp),min = 0,step = 1),
                 numericInput(ns('drat'),'Rear Axle Ratio',value = ifelse(is.null(hold), "", hold$drat),min = 0,step = 0.01)
          )
        ),
        title = modal_title,
        size = 'm',
        footer = list(
          modalButton('Cancel'),
          actionButton(
            ns('submit'),
            'Submit',
            class = "btn btn-primary",
            style = "color: white"
          )
        )
      )
    )
    
    # Observe event for "Model" text input in Add/down Car Modal
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
  
  
  down_car_dat <- reactive({
    hold <- car_to_down()
    
    out <- list(
      uid = if (is.null(hold)) NA else hold$uid,
      data = list(
        "model" = input$model,
        "mpg" = input$mpg,
        "cyl" = input$cyl,
        "disp" = input$disp,
        "hp" = input$hp,
        "drat" = input$drat,
        "wt" = input$wt,
        "qsec" = input$qsec,
        "vs" = input$vs,
        "am" = input$am,
        "gear" = input$gear,
        "carb" = input$carb
      )
    )
    
    time_now <- as.character(lubridate::with_tz(Sys.time(), tzone = "UTC"))
    
    if (is.null(hold)) {
      # adding a new car
      
      out$data$created_at <- time_now
      out$data$created_by <- session$userData$email
    } else {
      # downing existing car
      
      out$data$created_at <- as.character(hold$created_at)
      out$data$created_by <- hold$created_by
    }
    
    out$data$modified_at <- time_now
    out$data$modified_by <- session$userData$email
    
    out
  })
  
  validate_down <- eventReactive(input$submit, {
    dat <- down_car_dat()
    
    # Logic to validate inputs...
    
    dat
  })
  
  observeEvent(validate_down(), {
    removeModal()
    dat <- validate_down()

    tryCatch({
      toexport<-list(dat$data,list("uid"=dat$uid))
      write.csv(toexport, file.path('.',"dat_mjh.csv"), row.names = FALSE)

      session$userData$mtcars_trigger(session$userData$mtcars_trigger() + 1)
      showToast("success", paste0(modal_title, " Successs"))
    }, error = function(error) {
      
      showToast("error", paste0(modal_title, " Error"))
      
      print(error)
    })
  })

}
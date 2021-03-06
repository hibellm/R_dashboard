#' Cars Table Module UI
#'
#' The UI portion of the module for displaying the mtcars datatable
#'
#' @importFrom shiny NS tagList fluidRow column actionButton tags
#' @importFrom DT DTOutput
#' @importFrom shinycssloaders withSpinner
#'
#' @param id The id for this module
#'
#' @return a \code{shiny::\link[shiny]{tagList}} containing UI elements

cars_table_module_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(div(class="ui segment teal inverted",h2(class="ui icon header",tags$i(class="ui icon rocket")))),
    fluidRow(
      column(
        width = 2,
        actionButton(
          ns("add_car"),
          "Add",
          class = "btn-success",
          style = "color: #fff;",
          icon = icon('plus'),
          width = '100%'
        ),
        tags$br(),
        tags$br()
      )
    ),
    fluidRow(
      column(
        width = 12,
        title = "Motor Trend Car Road Tests",
        DTOutput(ns('car_table')) %>%
          withSpinner(),
        tags$br(),
        tags$br()
      )
    ),
    tags$script(src = "./myassets/js/cars_table_module.js"),
    tags$script(paste0("cars_table_module_js('", ns(''), "')"))
  )
}

#' Cars Table Module Server
#'
#' The Server portion of the module for displaying the mtcars datatable
#'
#' @importFrom shiny reactive reactiveVal observeEvent req callModule eventReactive
#' @importFrom DT renderDT datatable replaceData dataTableProxy
#' @importFrom dplyr tbl collect mutate arrange select filter pull
#' @importFrom purrr map_chr
#' @importFrom tibble tibble
#'
#' @param None
#'
#' @return None

cars_table_module <- function(input, output, session) {

  # trigger to reload data from the "mtcars" table
  session$userData$mtcars_trigger <- reactiveVal(0)

  # Read in "mtcars" table from the database
  cars <- reactive({
    session$userData$mtcars_trigger()

    out <- NULL
    tryCatch({
      out <- conn$find() %>%
        dplyr::mutate(created_at = as.POSIXct(Sys.Date(), tz = "UTC"),
                      modified_at = as.POSIXct(Sys.Date(), tz = "UTC"),
                      created_by = 'Me',
                      modifed_by = '') %>%
            collect() %>%
        arrange(desc(modified_at))
    }, error = function(err) {
      print(err)
      showToast("error", "Database Connection Error")
    })
    out
  })


  #FUNCTION TO PREPARE THE DATA
  car_table_prep <- reactiveVal(NULL)

  observeEvent(cars(), {
    out <- cars()

    ids <- out$uid

    actions <- purrr::map_chr(ids, function(id_) {
      paste0(
        '<div class="ui icon buttons" style="width: 100px;" role="group" aria-label="Basic example">
          <button class="ui button icon mini circular teal edit_btn" data-toggle="tooltip" data-placement="top" title="Edit" id = ', id_, ' style="margin: 0"><i class="fa fa-pencil-square-o"></i></button>
          <button class="ui button icon mini circular red delete_btn" data-toggle="tooltip" data-placement="top" title="Delete" id = ', id_, ' style="margin: 0"><i class="fa fa-trash-o"></i></button>
          <button class="ui button icon mini circular blue info_btn" data-toggle="tooltip" data-placement="top" title="Info" id = ', id_, ' style="margin: 0"><i class="fa fa-info-circle"></i></button>
          <button class="ui button icon mini circular green down_btn" data-toggle="tooltip" data-placement="top" title="download" id = ', id_, ' style="margin: 0"><i class="fa fa-download"></i></button>
        </div>'
      )
    })

    # Remove the `uid` column. We don't want to show this column to the user
    out <- out %>%
      select(-uid)

    # Set the Action Buttons row to the first column of the `mtcars` table
    out <- cbind(
      tibble(" " = actions),
      out
    )

    if (is.null(car_table_prep())) {
      # loading data into the table for the first time, so we render the entire table
      # rather than using a DT proxy
      car_table_prep(out)
    } else {
      # manually hide the tooltip from the row so that it doesn't get stuck
      # when the row is deleted
      shinyjs::runjs("$('.btn-sm').tooltip('hide')")
      # table has already rendered, so use DT proxy to update the data in the
      # table without rerendering the entire table
      replaceData(car_table_proxy, out, resetPaging = FALSE, rownames = FALSE)
    }
  })

  # RENDERS THE TABLE
  output$car_table <- renderDT({
    req(car_table_prep())
    out <- car_table_prep()

    print(out[5,])
    datatable(
      out,
      rownames = FALSE,
      # colnames = c('Model', 'Miles/Gallon', 'Cylinders', 'Displacement (cu.in.)',
      #              'Horsepower', 'Rear Axle Ratio', 'Weight (lbs)', '1/4 Mile Time',
      #              'Engine', 'Transmission', 'Forward Gears', 'Carburetors', 'Created At',
      #              'Created By', 'Modified At', 'Modified By'),
      colnames = c('Sepal Length', 'Sepal Width', 'Petal Length', 'Petal Width', 'Species', 'mjh','test','id_','Created At',
                   'Modified At', 'Created By', 'Modified By'),
      selection = "none",
      class = "compact stripe row-border nowrap",
      # Escape the HTML in all except 1st column (which has the buttons)
      escape = -1,
      extensions = c("Buttons"),
      options = list(
        scrollX = TRUE,
        dom = 'Bftip',
        buttons = list(
          list(
            extend = "excel",
            text = "Download",
            title = paste0("mtcars-", Sys.Date()),
            exportOptions = list(
              columns = 1:(length(out) - 1)
            )
          )
        ),
        columnDefs = list(
          list(targets = 0, orderable = FALSE)
        )
      )
    ) %>%
       formatDate(c("created_at", "modified_at"), 'toDateString')

  })

  car_table_proxy <- DT::dataTableProxy('car_table')

  #EDIT
  callModule(
    car_edit_module,
    "add_car",
    modal_title = "Add Car",
    car_to_edit = function() NULL,
    modal_trigger = reactive({input$add_car})
  )

  car_to_edit <- eventReactive(input$car_id_to_edit, {
    cars() %>%
      filter(uid == input$car_id_to_edit)
  })

  callModule(
    car_edit_module,
    "edit_car",
    modal_title = "Edit Car",
    car_to_edit = car_to_edit,
    modal_trigger = reactive({input$car_id_to_edit})
  )

  #DOWN
  callModule(
    car_down_module,
    "dl_car",
    modal_title = "Downlload Car",
    car_to_down = function() NULL,
    modal_trigger = reactive({input$add_car})
  )

  car_to_down <- eventReactive(input$car_id_to_down, {
    cars() %>%
      filter(uid == input$car_id_to_down)
  })

  callModule(
    car_down_module,
    "edit_car",
    modal_title = "Download Car",
    car_to_down = car_to_down,
    modal_trigger = reactive({input$car_id_to_down})
  )

  #INFO
  callModule(
    car_info_module,
    "info_car",
    modal_title = "Information Car",
    car_to_info = function() NULL,
    modal_trigger = reactive({input$add_car})
  )

  car_to_info <- eventReactive(input$car_id_to_info, {
    cars() %>%
      filter(uid == input$car_id_to_info)
  })

  callModule(
    car_info_module,
    "info_car",
    modal_title = "Information details",
    car_to_info = car_to_info,
    modal_trigger = reactive({input$car_id_to_info})
  )

  #DELETE
  car_to_delete <- eventReactive(input$car_id_to_delete, {
    out <- cars() %>%
      filter(uid == input$car_id_to_delete) %>%
      as.list()
  })

  callModule(
    car_delete_module,
    "delete_car",
    modal_title = "Delete Car",
    car_to_delete = car_to_delete,
    modal_trigger = reactive({input$car_id_to_delete})
  )

}
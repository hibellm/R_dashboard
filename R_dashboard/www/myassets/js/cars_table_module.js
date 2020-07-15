


function cars_table_module_js(ns_prefix) {

  $("#" + ns_prefix + "car_table").on("click", ".delete_btn", function() {
    Shiny.setInputValue(ns_prefix + "car_id_to_delete", this.id, { priority: "event"});
    $(this).tooltip('hide');
  });

  $("#" + ns_prefix + "car_table").on("click", ".edit_btn", function() {
    Shiny.setInputValue(ns_prefix + "car_id_to_edit", this.id, { priority: "event"});
    $(this).tooltip('hide');
  });
  
  $("#" + ns_prefix + "car_table").on("click", ".info_btn", function() {
    Shiny.setInputValue(ns_prefix + "car_id_to_info", this.id, { priority: "event"});
    $(this).tooltip('hide');
  });
  
  $("#" + ns_prefix + "car_table").on("click", ".down_btn", function() {
    Shiny.setInputValue(ns_prefix + "car_id_to_down", this.id, { priority: "event"});
    $(this).tooltip('hide');
  });  
}


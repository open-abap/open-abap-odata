INTERFACE /iwbep/if_mgw_req_filter PUBLIC.

  METHODS get_filter_select_options
    RETURNING
      VALUE(rt_filter_select_options) TYPE /iwbep/t_mgw_select_option.

  METHODS get_filter_string
    RETURNING
      VALUE(rv_filter_string) TYPE string.

  METHODS convert_select_option
    IMPORTING
      is_select_option            TYPE /iwbep/s_mgw_select_option
    EXPORTING
      et_select_option            TYPE table
      ev_no_matching_values_found TYPE abap_bool
    RAISING
      /iwbep/cx_mgw_tech_exception.

ENDINTERFACE.
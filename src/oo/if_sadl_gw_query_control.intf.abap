INTERFACE if_sadl_gw_query_control PUBLIC.

  METHODS set_query_options
    IMPORTING
      iv_entity_set    TYPE string
      io_query_options TYPE REF TO if_sadl_gw_query_options
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

ENDINTERFACE.
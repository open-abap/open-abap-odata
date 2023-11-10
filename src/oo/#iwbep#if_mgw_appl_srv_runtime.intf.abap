INTERFACE /iwbep/if_mgw_appl_srv_runtime PUBLIC.

  TYPES ty_s_mgw_response_entity_cntxt TYPE string.
  TYPES ty_s_mgw_response_context      TYPE string.

  METHODS get_stream
    IMPORTING
      iv_entity_name          TYPE string
      iv_entity_set_name      TYPE string
      iv_source_name          TYPE string
      it_key_tab              TYPE string
      it_navigation_path      TYPE string
      io_tech_request_context TYPE string
    EXPORTING
      er_stream               TYPE string
      es_response_context     TYPE string.

  METHODS update_stream
    IMPORTING
      iv_entity_name          TYPE string
      iv_entity_set_name      TYPE string
      iv_source_name          TYPE string
      is_media_resource       TYPE string
      it_key_tab              TYPE string
      it_navigation_path      TYPE string
      io_tech_request_context TYPE string.

  METHODS create_deep_entity
    IMPORTING
      iv_entity_name          TYPE string OPTIONAL
      iv_entity_set_name      TYPE string OPTIONAL
      iv_source_name          TYPE string OPTIONAL
      io_data_provider        TYPE REF TO /iwbep/if_mgw_entry_provider
      it_key_tab              TYPE /iwbep/t_mgw_name_value_pair OPTIONAL
      it_navigation_path      TYPE /iwbep/t_mgw_navigation_path OPTIONAL
      io_expand               TYPE REF TO /iwbep/if_mgw_odata_expand
      io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_c OPTIONAL
    EXPORTING
      er_deep_entity          TYPE REF TO data
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS create_entity
    IMPORTING
      iv_entity_name          TYPE string OPTIONAL
      iv_entity_set_name      TYPE string OPTIONAL
      iv_source_name          TYPE string OPTIONAL
      io_data_provider        TYPE REF TO /iwbep/if_mgw_entry_provider
      it_key_tab              TYPE /iwbep/t_mgw_name_value_pair OPTIONAL
      it_navigation_path      TYPE /iwbep/t_mgw_navigation_path OPTIONAL
      io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_c OPTIONAL
    EXPORTING
      er_entity               TYPE REF TO data
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS delete_entity
    IMPORTING
      iv_entity_name          TYPE string OPTIONAL
      iv_entity_set_name      TYPE string OPTIONAL
      iv_source_name          TYPE string OPTIONAL
      it_key_tab              TYPE /iwbep/t_mgw_name_value_pair OPTIONAL
      it_navigation_path      TYPE /iwbep/t_mgw_navigation_path OPTIONAL
      io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_d OPTIONAL
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS get_entity
    IMPORTING
      iv_entity_name          TYPE string OPTIONAL
      iv_entity_set_name      TYPE string OPTIONAL
      iv_source_name          TYPE string OPTIONAL
      it_key_tab              TYPE /iwbep/t_mgw_name_value_pair OPTIONAL
      it_navigation_path      TYPE /iwbep/t_mgw_navigation_path OPTIONAL
      io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity OPTIONAL
    EXPORTING
      er_entity               TYPE REF TO data
      es_response_context     TYPE ty_s_mgw_response_entity_cntxt
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS get_entityset
    IMPORTING
      iv_entity_name           TYPE string OPTIONAL
      iv_entity_set_name       TYPE string OPTIONAL
      iv_source_name           TYPE string OPTIONAL
      it_filter_select_options TYPE /iwbep/t_mgw_select_option OPTIONAL
      it_order                 TYPE /iwbep/t_mgw_sorting_order OPTIONAL
      is_paging                TYPE /iwbep/s_mgw_paging OPTIONAL
      it_navigation_path       TYPE /iwbep/t_mgw_navigation_path OPTIONAL
      it_key_tab               TYPE /iwbep/t_mgw_name_value_pair OPTIONAL
      iv_filter_string         TYPE string OPTIONAL
      iv_search_string         TYPE string OPTIONAL
      io_tech_request_context  TYPE REF TO /iwbep/if_mgw_req_entityset OPTIONAL
    EXPORTING
      er_entityset             TYPE REF TO data
      es_response_context      TYPE ty_s_mgw_response_context
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS update_entity
    IMPORTING
      iv_entity_name          TYPE string OPTIONAL
      iv_entity_set_name      TYPE string OPTIONAL
      iv_source_name          TYPE string OPTIONAL
      io_data_provider        TYPE REF TO /iwbep/if_mgw_entry_provider
      it_key_tab              TYPE /iwbep/t_mgw_name_value_pair OPTIONAL
      it_navigation_path      TYPE /iwbep/t_mgw_navigation_path OPTIONAL
      io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_u OPTIONAL
    EXPORTING
      er_entity               TYPE REF TO data
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS execute_action
    IMPORTING
      iv_action_name          TYPE string OPTIONAL
      it_parameter            TYPE /iwbep/t_mgw_name_value_pair OPTIONAL
      io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_func_import OPTIONAL
    EXPORTING
      er_data                 TYPE REF TO data
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS get_expanded_entity
    IMPORTING
      iv_entity_name          TYPE string OPTIONAL
      iv_entity_set_name      TYPE string OPTIONAL
      iv_source_name          TYPE string OPTIONAL
      it_key_tab              TYPE /iwbep/t_mgw_name_value_pair OPTIONAL
      it_navigation_path      TYPE /iwbep/t_mgw_navigation_path OPTIONAL
      io_expand               TYPE REF TO /iwbep/if_mgw_odata_expand OPTIONAL
      io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity OPTIONAL
    EXPORTING
      er_entity                TYPE REF TO data
      es_response_context      TYPE ty_s_mgw_response_entity_cntxt
      et_expanded_clauses      TYPE string_table
      et_expanded_tech_clauses TYPE string_table
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS get_expanded_entityset
    IMPORTING
      iv_entity_name           TYPE string OPTIONAL
      iv_entity_set_name       TYPE string OPTIONAL
      iv_source_name           TYPE string OPTIONAL
      it_filter_select_options TYPE /iwbep/t_mgw_select_option OPTIONAL
      it_order                 TYPE /iwbep/t_mgw_sorting_order OPTIONAL
      is_paging                TYPE /iwbep/s_mgw_paging OPTIONAL
      it_navigation_path       TYPE /iwbep/t_mgw_navigation_path OPTIONAL
      it_key_tab               TYPE /iwbep/t_mgw_name_value_pair OPTIONAL
      iv_filter_string         TYPE string OPTIONAL
      iv_search_string         TYPE string OPTIONAL
      io_expand                TYPE REF TO /iwbep/if_mgw_odata_expand OPTIONAL
      io_tech_request_context  TYPE REF TO /iwbep/if_mgw_req_entityset OPTIONAL
    EXPORTING
      er_entityset             TYPE REF TO data
      et_expanded_clauses      TYPE string_table
      et_expanded_tech_clauses TYPE string_table
      es_response_context      TYPE ty_s_mgw_response_context
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS patch_entity
    IMPORTING
      iv_entity_name          TYPE string OPTIONAL
      iv_entity_set_name      TYPE string OPTIONAL
      iv_source_name          TYPE string OPTIONAL
      io_data_provider        TYPE REF TO /iwbep/if_mgw_entry_provider
      it_key_tab              TYPE /iwbep/t_mgw_name_value_pair OPTIONAL
      it_navigation_path      TYPE /iwbep/t_mgw_navigation_path OPTIONAL
      io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_p OPTIONAL
    EXPORTING
      er_entity TYPE REF TO data
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

ENDINTERFACE.
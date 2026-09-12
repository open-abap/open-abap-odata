INTERFACE if_sadl_gw_dpc PUBLIC.

  METHODS get_entity
    IMPORTING
      io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity
    EXPORTING
      es_data                 TYPE data
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS create_entity
    IMPORTING
      io_data_provider        TYPE REF TO /iwbep/if_mgw_entry_provider
      io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_c
    EXPORTING
      es_data                 TYPE data
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS delete_entity
    IMPORTING
      io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_d
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS get_entityset
    IMPORTING
      io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entityset
    EXPORTING
      et_data                 TYPE data
      es_response_context     TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_context
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS update_entity
    IMPORTING
      io_data_provider        TYPE REF TO /iwbep/if_mgw_entry_provider
      io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_u
    EXPORTING
      es_data                 TYPE data
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS execute_action
    IMPORTING
      io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_func_import
    EXPORTING
      er_data                 TYPE REF TO data
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS get_expanded_entityset
    IMPORTING
      io_expand_node           TYPE REF TO /iwbep/if_mgw_odata_expand
      io_tech_request_context  TYPE REF TO /iwbep/if_mgw_req_entityset
    EXPORTING
      er_entityset             TYPE REF TO data
      et_expanded_tech_clauses TYPE string_table
      es_response_context      TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_context
      ev_entity_mapped_by_sadl TYPE abap_bool
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS get_expanded_entity
    IMPORTING
      io_expand_node           TYPE REF TO /iwbep/if_mgw_odata_expand
      io_tech_request_context  TYPE REF TO /iwbep/if_mgw_req_entity
    EXPORTING
      er_entity                TYPE REF TO data
      et_expanded_tech_clauses TYPE string_table
      es_response_context      TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_entity_cntxt
      ev_entity_mapped_by_sadl TYPE abap_bool
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS begin_changeset
    IMPORTING
      it_operation_info TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_t_operation_info
    CHANGING
      cv_defer_mode     TYPE abap_bool
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS process_changeset
    IMPORTING
      it_changeset_request  TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_t_changeset_request
    CHANGING
      ct_changeset_response TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_t_changeset_response
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

ENDINTERFACE.
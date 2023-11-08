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

ENDINTERFACE.
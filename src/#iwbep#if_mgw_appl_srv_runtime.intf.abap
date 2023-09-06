INTERFACE /iwbep/if_mgw_appl_srv_runtime PUBLIC.

  TYPES ty_s_mgw_response_entity_cntxt TYPE string.
  TYPES ty_s_mgw_response_context TYPE string.

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
      iv_entity_name          TYPE string
      iv_entity_set_name      TYPE string
      iv_source_name          TYPE string
      io_data_provider        TYPE string
      it_key_tab              TYPE string
      it_navigation_path      TYPE string
      io_expand               TYPE string
      io_tech_request_context TYPE string
    EXPORTING
      er_deep_entitity        TYPE string.

ENDINTERFACE.
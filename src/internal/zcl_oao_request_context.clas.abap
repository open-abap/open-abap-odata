CLASS zcl_oao_request_context DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_req_entityset.

    METHODS constructor
      IMPORTING
        iv_entity_set_name TYPE string.
  PRIVATE SECTION.
    DATA mv_entity_set_name TYPE string.
ENDCLASS.

CLASS zcl_oao_request_context IMPLEMENTATION.

  METHOD constructor.
    mv_entity_set_name = iv_entity_set_name.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entityset~get_entity_set_name.
    rv_entity_set = mv_entity_set_name.
  ENDMETHOD.

ENDCLASS.
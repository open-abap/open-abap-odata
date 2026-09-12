CLASS /iwbep/cl_mgw_msg_container DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS get_mgw_msg_container
      RETURNING
        VALUE(ro_msg_container) TYPE REF TO /iwbep/if_message_container.

* a new container for the next request, the DPC keeps the current one
    CLASS-METHODS reset.
  PRIVATE SECTION.
    CLASS-DATA go_container TYPE REF TO /iwbep/if_message_container.
ENDCLASS.

CLASS /iwbep/cl_mgw_msg_container IMPLEMENTATION.

  METHOD get_mgw_msg_container.
    IF go_container IS NOT BOUND.
      CREATE OBJECT go_container TYPE zcl_oao_msg_container.
    ENDIF.
    ro_msg_container = go_container.
  ENDMETHOD.

  METHOD reset.
    CLEAR go_container.
  ENDMETHOD.

ENDCLASS.

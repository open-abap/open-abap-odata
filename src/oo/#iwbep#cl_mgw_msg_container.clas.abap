CLASS /iwbep/cl_mgw_msg_container DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS get_mgw_msg_container
      RETURNING
        VALUE(ro_msg_container) TYPE REF TO /iwbep/if_message_container.
ENDCLASS.

CLASS /iwbep/cl_mgw_msg_container IMPLEMENTATION.
  METHOD get_mgw_msg_container.
    ASSERT 1 = 2.
  ENDMETHOD.
ENDCLASS.
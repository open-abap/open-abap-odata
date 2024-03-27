INTERFACE /iwbep/if_message_container PUBLIC.

  METHODS add_message_from_bapi
    IMPORTING
      is_bapi_message   TYPE bapiret2
      iv_message_target TYPE string.

  METHODS add_message_text_only
    IMPORTING
      iv_msg_type               TYPE symsgty
      iv_msg_text               TYPE bapi_msg
      iv_add_to_response_header TYPE abap_bool DEFAULT abap_false.

ENDINTERFACE.
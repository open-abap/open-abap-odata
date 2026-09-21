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

  METHODS add_messages_from_bapi
    IMPORTING
      it_bapi_messages          TYPE any
      iv_add_to_response_header TYPE abap_bool DEFAULT abap_false.

  METHODS add_message
    IMPORTING
      iv_msg_type   TYPE symsgty
      iv_msg_id     TYPE symsgid
      iv_msg_number TYPE symsgno
      iv_msg_text   TYPE bapi_msg OPTIONAL
      iv_msg_v1     TYPE symsgv OPTIONAL
      iv_msg_v2     TYPE symsgv OPTIONAL
      iv_msg_v3     TYPE symsgv OPTIONAL
      iv_msg_v4     TYPE symsgv OPTIONAL.

ENDINTERFACE.
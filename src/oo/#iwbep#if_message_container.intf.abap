INTERFACE /iwbep/if_message_container PUBLIC.

  METHODS add_message_from_bapi
    IMPORTING
      is_bapi_message   TYPE bapiret2
      iv_message_target TYPE string.

ENDINTERFACE.
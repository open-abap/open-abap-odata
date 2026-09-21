CLASS zcl_oao_msg_container DEFINITION PUBLIC.
* The message container of a request: BAPI return messages and plain texts
* the DPC adds while processing, read by the error response
  PUBLIC SECTION.
    INTERFACES /iwbep/if_message_container.

    METHODS get_messages
      RETURNING
        VALUE(rt_messages) TYPE bapirettab.

    METHODS has_errors
      RETURNING
        VALUE(rv_errors) TYPE abap_bool.
  PRIVATE SECTION.
    DATA mt_messages TYPE bapirettab.
ENDCLASS.

CLASS zcl_oao_msg_container IMPLEMENTATION.
  METHOD /iwbep/if_message_container~add_message.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD /iwbep/if_message_container~add_message_from_bapi.
    APPEND is_bapi_message TO mt_messages.
  ENDMETHOD.

  METHOD /iwbep/if_message_container~add_message_text_only.
    DATA ls_message TYPE bapiret2.

    ls_message-type    = iv_msg_type.
    ls_message-message = iv_msg_text.
    APPEND ls_message TO mt_messages.
  ENDMETHOD.

  METHOD /iwbep/if_message_container~add_messages_from_bapi.
    DATA ls_message TYPE bapiret2.
    FIELD-SYMBOLS <ls_row> TYPE any.

    LOOP AT it_bapi_messages ASSIGNING <ls_row>.
      CLEAR ls_message.
      MOVE-CORRESPONDING <ls_row> TO ls_message.
      APPEND ls_message TO mt_messages.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_messages.
    rt_messages = mt_messages.
  ENDMETHOD.

  METHOD has_errors.
    DATA ls_message TYPE bapiret2.

    LOOP AT mt_messages INTO ls_message WHERE type CA 'EAX'.
      rv_errors = abap_true.
      RETURN.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

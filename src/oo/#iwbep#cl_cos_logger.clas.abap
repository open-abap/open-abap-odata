CLASS /iwbep/cl_cos_logger DEFINITION PUBLIC.
* The application log of the Gateway: here a table in memory, read back
* with get_messages, so a generated DPC's log_message calls land somewhere
  PUBLIC SECTION.
    CONSTANTS success TYPE c LENGTH 1 VALUE 'S'.
    CONSTANTS info    TYPE c LENGTH 1 VALUE 'I'.
    CONSTANTS warning TYPE c LENGTH 1 VALUE 'W'.
    CONSTANTS error   TYPE c LENGTH 1 VALUE 'E'.
    CONSTANTS abort   TYPE c LENGTH 1 VALUE 'A'.

    TYPES: BEGIN OF ty_message,
             msg_type   TYPE symsgty,
             msg_id     TYPE symsgid,
             msg_number TYPE symsgno,
             text       TYPE string,
             agent      TYPE string,
           END OF ty_message.
    TYPES ty_messages TYPE STANDARD TABLE OF ty_message WITH DEFAULT KEY.

    METHODS log_message
      IMPORTING
        iv_msg_type          TYPE symsgty
        iv_msg_id            TYPE symsgid OPTIONAL
        iv_msg_number        TYPE symsgno OPTIONAL
        iv_msg_text          TYPE clike OPTIONAL
        iv_msg_v1            TYPE any OPTIONAL
        iv_msg_v2            TYPE any OPTIONAL
        iv_msg_v3            TYPE any OPTIONAL
        iv_msg_v4            TYPE any OPTIONAL
        iv_agent             TYPE any
        iv_condense          TYPE abap_bool DEFAULT abap_true
      RETURNING
        VALUE(rv_msg_handle) TYPE string.

    METHODS get_messages
      RETURNING
        VALUE(rt_messages) TYPE ty_messages.

    METHODS clear.
  PRIVATE SECTION.
    DATA mt_messages TYPE ty_messages.
ENDCLASS.

CLASS /iwbep/cl_cos_logger IMPLEMENTATION.

  METHOD log_message.
    DATA ls_message TYPE ty_message.

    ls_message-msg_type   = iv_msg_type.
    ls_message-msg_id     = iv_msg_id.
    ls_message-msg_number = iv_msg_number.
    ls_message-agent      = iv_agent.
    IF iv_msg_text IS NOT INITIAL.
      ls_message-text = iv_msg_text.
    ELSEIF iv_msg_id IS NOT INITIAL.
      MESSAGE ID iv_msg_id TYPE 'S' NUMBER iv_msg_number
        WITH iv_msg_v1 iv_msg_v2 iv_msg_v3 iv_msg_v4 INTO ls_message-text.
    ENDIF.
    IF iv_condense = abap_true.
      CONDENSE ls_message-text.
    ENDIF.
    APPEND ls_message TO mt_messages.
    rv_msg_handle = |{ lines( mt_messages ) }|.
  ENDMETHOD.

  METHOD get_messages.
    rt_messages = mt_messages.
  ENDMETHOD.

  METHOD clear.
    CLEAR mt_messages.
  ENDMETHOD.

ENDCLASS.

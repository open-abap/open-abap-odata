CLASS /iwbep/cl_cos_logger DEFINITION PUBLIC.
  PUBLIC SECTION.

    CONSTANTS success TYPE c LENGTH 1 VALUE 'S'.

    METHODS log_message
      IMPORTING
        iv_msg_type         TYPE symsgty
        iv_msg_id           TYPE symsgid OPTIONAL
        iv_msg_number       TYPE symsgno OPTIONAL
        iv_msg_text         TYPE clike OPTIONAL
        iv_msg_v1           TYPE any OPTIONAL
        iv_msg_v2           TYPE any OPTIONAL
        iv_msg_v3           TYPE any OPTIONAL
        iv_msg_v4           TYPE any OPTIONAL
        iv_agent            TYPE any
        iv_condense         TYPE abap_bool DEFAULT abap_true
      RETURNING
        VALUE(rv_msg_handle) TYPE string.

ENDCLASS.

CLASS /iwbep/cl_cos_logger IMPLEMENTATION.

  METHOD log_message.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
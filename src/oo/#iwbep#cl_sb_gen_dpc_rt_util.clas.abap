CLASS /iwbep/cl_sb_gen_dpc_rt_util DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS rfc_save_log
      IMPORTING
        is_return            TYPE any OPTIONAL
        it_return            TYPE ANY TABLE OPTIONAL
        iv_entity_type       TYPE string OPTIONAL
        it_key_tab           TYPE any OPTIONAL
        io_logger            TYPE REF TO /iwbep/cl_cos_logger
        io_message_container TYPE REF TO /iwbep/if_message_container
      RAISING
        /iwbep/cx_mgw_busi_exception.

    CLASS-METHODS rfc_exception_handling
      IMPORTING
        iv_subrc            TYPE sy-subrc
        iv_exp_message_text TYPE any
        io_logger           TYPE REF TO /iwbep/cl_cos_logger OPTIONAL
      RAISING
        /iwbep/cx_mgw_busi_exception
        /iwbep/cx_mgw_tech_exception.

    CLASS-METHODS get_rfc_destination
      IMPORTING
        io_dp_facade              TYPE REF TO /iwbep/if_mgw_dp_facade
      RETURNING
        VALUE(rv_rfc_destination) TYPE rfcdest
      RAISING
        /iwbep/cx_mgw_tech_exception.

ENDCLASS.

CLASS /iwbep/cl_sb_gen_dpc_rt_util IMPLEMENTATION.

  METHOD get_rfc_destination.
* the RFC destination of the service's system alias; off the stack the
* function modules live in this process
    rv_rfc_destination = 'NONE'.
  ENDMETHOD.

  METHOD rfc_save_log.
* what the generated DPC does after every RFC: the BAPI return messages go
* to the log and the message container, an error ends the request
    DATA ls_message TYPE bapiret2.
    DATA lv_error   TYPE string.
    DATA lt_return  TYPE bapirettab.
    FIELD-SYMBOLS <ls_row> TYPE any.

    IF is_return IS SUPPLIED AND is_return IS NOT INITIAL.
      MOVE-CORRESPONDING is_return TO ls_message.
      APPEND ls_message TO lt_return.
    ENDIF.
    IF it_return IS SUPPLIED.
      LOOP AT it_return ASSIGNING <ls_row>.
        CLEAR ls_message.
        MOVE-CORRESPONDING <ls_row> TO ls_message.
        APPEND ls_message TO lt_return.
      ENDLOOP.
    ENDIF.

    LOOP AT lt_return INTO ls_message.
      IF io_logger IS BOUND.
        io_logger->log_message(
          iv_msg_type   = ls_message-type
          iv_msg_id     = ls_message-id
          iv_msg_number = ls_message-number
          iv_msg_text   = ls_message-message
          iv_agent      = iv_entity_type ).
      ENDIF.
      IF io_message_container IS BOUND.
        io_message_container->add_message_from_bapi(
          is_bapi_message   = ls_message
          iv_message_target = iv_entity_type ).
      ENDIF.
      IF ls_message-type CA 'EAX' AND lv_error IS INITIAL.
        lv_error = ls_message-message.
      ENDIF.
    ENDLOOP.

    IF lv_error IS NOT INITIAL.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message           = lv_error
          message_container = io_message_container.
    ENDIF.
  ENDMETHOD.

  METHOD rfc_exception_handling.
* 1000 communication failure and 1001 system failure are technical, every
* other sy-subrc of the RFC is an error of the called function
    DATA lv_text TYPE string.

    lv_text = iv_exp_message_text.
    IF io_logger IS BOUND.
      io_logger->log_message(
        iv_msg_type = /iwbep/cl_cos_logger=>error
        iv_msg_text = lv_text
        iv_agent    = 'RFC' ).
    ENDIF.
    IF iv_subrc = 1000 OR iv_subrc = 1001.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
        EXPORTING
          textid = /iwbep/cx_mgw_tech_exception=>internal_error.
    ENDIF.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING
        textid  = /iwbep/cx_mgw_busi_exception=>business_error
        message = lv_text.
  ENDMETHOD.

ENDCLASS.
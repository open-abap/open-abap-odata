CLASS /iwbep/cl_sb_gen_dpc_rt_util DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS rfc_save_log
      IMPORTING
        is_return      TYPE any OPTIONAL
        it_return      TYPE ANY TABLE OPTIONAL
        iv_entity_type TYPE string OPTIONAL
        it_key_tab     TYPE any OPTIONAL
        io_logger      TYPE REF TO /iwbep/cl_cos_logger
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

ENDCLASS.

CLASS /iwbep/cl_sb_gen_dpc_rt_util IMPLEMENTATION.

  METHOD rfc_save_log.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD rfc_exception_handling.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
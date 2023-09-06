INTERFACE /iwbep/if_sb_dpc_comm_services PUBLIC.

  METHODS commit_work
    IMPORTING
      iv_rfc_dest TYPE any OPTIONAL
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS get_generation_strategy
    RETURNING
      VALUE(rv_generation_strategy) TYPE i.

  METHODS log_message
    IMPORTING
      iv_msg_type TYPE symsgty
      iv_msg_id TYPE symsgid OPTIONAL
      iv_msg_number TYPE symsgno OPTIONAL
      iv_msg_v1 TYPE any OPTIONAL
      iv_msg_v2 TYPE any OPTIONAL
      iv_msg_v3 TYPE any OPTIONAL
      iv_msg_v4 TYPE any OPTIONAL.

  METHODS rfc_exception_handling
    IMPORTING
      iv_subrc            TYPE sy-subrc
      iv_exp_message_text TYPE any
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

  METHODS rfc_save_log
    IMPORTING
      is_return      TYPE any OPTIONAL
      it_return      TYPE ANY TABLE OPTIONAL
      iv_entity_type TYPE string OPTIONAL
      it_key_tab     TYPE any OPTIONAL
    RAISING
      /iwbep/cx_mgw_busi_exception.

  METHODS set_injection
    IMPORTING
      io_unit TYPE REF TO /iwbep/if_sb_gen_dpc_injection.

ENDINTERFACE.
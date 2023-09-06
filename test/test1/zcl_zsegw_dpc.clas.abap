CLASS zcl_zsegw_dpc DEFINITION PUBLIC INHERITING FROM /iwbep/cl_mgw_push_abs_data ABSTRACT CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES /iwbep/if_sb_dpc_comm_services .
    INTERFACES /iwbep/if_sb_gen_dpc_injection .

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_entityset REDEFINITION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~get_entity REDEFINITION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~update_entity REDEFINITION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~create_entity REDEFINITION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~delete_entity REDEFINITION.

  PROTECTED SECTION.

    DATA mo_injection TYPE REF TO /iwbep/if_sb_gen_dpc_injection .

    METHODS zsegwset_create_entity
      IMPORTING
      !iv_entity_name TYPE string
      !iv_entity_set_name TYPE string
      !iv_source_name TYPE string
      !it_key_tab TYPE /iwbep/t_mgw_name_value_pair
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_c OPTIONAL
      !it_navigation_path TYPE /iwbep/t_mgw_navigation_path
      !io_data_provider TYPE REF TO /iwbep/if_mgw_entry_provider OPTIONAL
      EXPORTING
      !er_entity TYPE zcl_zsegw_mpc=>ts_zsegw
      RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
    METHODS zsegwset_delete_entity
      IMPORTING
      !iv_entity_name TYPE string
      !iv_entity_set_name TYPE string
      !iv_source_name TYPE string
      !it_key_tab TYPE /iwbep/t_mgw_name_value_pair
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_d OPTIONAL
      !it_navigation_path TYPE /iwbep/t_mgw_navigation_path
      RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
    METHODS zsegwset_get_entity
      IMPORTING
      !iv_entity_name TYPE string
      !iv_entity_set_name TYPE string
      !iv_source_name TYPE string
      !it_key_tab TYPE /iwbep/t_mgw_name_value_pair
      !io_request_object TYPE REF TO /iwbep/if_mgw_req_entity OPTIONAL
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity OPTIONAL
      !it_navigation_path TYPE /iwbep/t_mgw_navigation_path
      EXPORTING
      !er_entity TYPE zcl_zsegw_mpc=>ts_zsegw
      !es_response_context TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_entity_cntxt
      RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
    METHODS zsegwset_get_entityset
      IMPORTING
      !iv_entity_name TYPE string
      !iv_entity_set_name TYPE string
      !iv_source_name TYPE string
      !it_filter_select_options TYPE /iwbep/t_mgw_select_option
      !is_paging TYPE /iwbep/s_mgw_paging
      !it_key_tab TYPE /iwbep/t_mgw_name_value_pair
      !it_navigation_path TYPE /iwbep/t_mgw_navigation_path
      !it_order TYPE /iwbep/t_mgw_sorting_order
      !iv_filter_string TYPE string
      !iv_search_string TYPE string
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entityset OPTIONAL
      EXPORTING
      !et_entityset TYPE zcl_zsegw_mpc=>tt_zsegw
      !es_response_context TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_context
      RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
    METHODS zsegwset_update_entity
      IMPORTING
      !iv_entity_name TYPE string
      !iv_entity_set_name TYPE string
      !iv_source_name TYPE string
      !it_key_tab TYPE /iwbep/t_mgw_name_value_pair
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_u OPTIONAL
      !it_navigation_path TYPE /iwbep/t_mgw_navigation_path
      !io_data_provider TYPE REF TO /iwbep/if_mgw_entry_provider OPTIONAL
      EXPORTING
      !er_entity TYPE zcl_zsegw_mpc=>ts_zsegw
      RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .

    METHODS check_subscription_authority
      REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zsegw_dpc IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_entity.
*&----------------------------------------------------------------------------------------------*
*&  Include           /IWBEP/DPC_TEMP_CRT_ENTITY_BASE
*&* This class has been generated on 06.09.2023 14:18:59 in client 001
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside the DPC provider subclass - ZCL_ZSEGW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

    DATA zsegwset_create_entity TYPE zcl_zsegw_mpc=>ts_zsegw.
    DATA lv_entityset_name TYPE string.

    lv_entityset_name = io_tech_request_context->get_entity_set_name( ).

    CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  zsegwSet
*-------------------------------------------------------------------------*
      WHEN 'zsegwSet'.
*     Call the entity set generated method
        zsegwset_create_entity(
          EXPORTING iv_entity_name         = iv_entity_name
                   iv_entity_set_name      = iv_entity_set_name
                   iv_source_name          = iv_source_name
                   io_data_provider        = io_data_provider
                   it_key_tab              = it_key_tab
                   it_navigation_path      = it_navigation_path
                   io_tech_request_context = io_tech_request_context
          IMPORTING er_entity              = zsegwset_create_entity ).
*     Send specific entity data to the caller interfaces
        copy_data_to_ref(
          EXPORTING
          is_data = zsegwset_create_entity
          CHANGING
          cr_data = er_entity ).

      WHEN OTHERS.
        super->/iwbep/if_mgw_appl_srv_runtime~create_entity(
          EXPORTING
          iv_entity_name     = iv_entity_name
          iv_entity_set_name = iv_entity_set_name
          iv_source_name     = iv_source_name
          io_data_provider   = io_data_provider
          it_key_tab         = it_key_tab
          it_navigation_path = it_navigation_path
          IMPORTING
          er_entity          = er_entity ).
    ENDCASE.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~delete_entity.
*&----------------------------------------------------------------------------------------------*
*&  Include           /IWBEP/DPC_TEMP_DEL_ENTITY_BASE
*&* This class has been generated on 06.09.2023 14:18:59 in client 001
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside the DPC provider subclass - ZCL_ZSEGW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

    DATA lv_entityset_name TYPE string.

    lv_entityset_name = io_tech_request_context->get_entity_set_name( ).

    CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  zsegwSet
*-------------------------------------------------------------------------*
      WHEN 'zsegwSet'.
*     Call the entity set generated method
        zsegwset_delete_entity(
          iv_entity_name                    = iv_entity_name
                    iv_entity_set_name      = iv_entity_set_name
                    iv_source_name          = iv_source_name
                    it_key_tab              = it_key_tab
                    it_navigation_path      = it_navigation_path
                    io_tech_request_context = io_tech_request_context ).

      WHEN OTHERS.
        super->/iwbep/if_mgw_appl_srv_runtime~delete_entity(
          iv_entity_name     = iv_entity_name
          iv_entity_set_name = iv_entity_set_name
          iv_source_name     = iv_source_name
          it_key_tab         = it_key_tab
          it_navigation_path = it_navigation_path ).
    ENDCASE.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_entity.
*&-----------------------------------------------------------------------------------------------*
*&  Include           /IWBEP/DPC_TEMP_GETENTITY_BASE
*&* This class has been generated  on 06.09.2023 14:18:59 in client 001
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside the DPC provider subclass - ZCL_ZSEGW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

    DATA zsegwset_get_entity TYPE zcl_zsegw_mpc=>ts_zsegw.
    DATA lv_entityset_name TYPE string.
    DATA lr_entity TYPE REF TO data.       "#EC NEEDED

    lv_entityset_name = io_tech_request_context->get_entity_set_name( ).

    CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  zsegwSet
*-------------------------------------------------------------------------*
      WHEN 'zsegwSet'.
*     Call the entity set generated method
        zsegwset_get_entity(
               EXPORTING iv_entity_name          = iv_entity_name
                         iv_entity_set_name      = iv_entity_set_name
                         iv_source_name          = iv_source_name
                         it_key_tab              = it_key_tab
                         it_navigation_path      = it_navigation_path
                         io_tech_request_context = io_tech_request_context
               IMPORTING er_entity               = zsegwset_get_entity
                         es_response_context     = es_response_context ).

        IF zsegwset_get_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = zsegwset_get_entity
            CHANGING
              cr_data = er_entity ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.

      WHEN OTHERS.
        super->/iwbep/if_mgw_appl_srv_runtime~get_entity(
           EXPORTING
             iv_entity_name     = iv_entity_name
             iv_entity_set_name = iv_entity_set_name
             iv_source_name     = iv_source_name
             it_key_tab         = it_key_tab
             it_navigation_path = it_navigation_path
          IMPORTING
            er_entity           = er_entity ).
    ENDCASE.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_entityset.
*&----------------------------------------------------------------------------------------------*
*&  Include           /IWBEP/DPC_TMP_ENTITYSET_BASE
*&* This class has been generated on 06.09.2023 14:18:59 in client 001
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside the DPC provider subclass - ZCL_ZSEGW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*
    DATA zsegwset_get_entityset TYPE zcl_zsegw_mpc=>tt_zsegw.
    DATA lv_entityset_name TYPE string.

    lv_entityset_name = io_tech_request_context->get_entity_set_name( ).

    CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  zsegwSet
*-------------------------------------------------------------------------*
      WHEN 'zsegwSet'.
*     Call the entity set generated method
        zsegwset_get_entityset(
          EXPORTING
          iv_entity_name           = iv_entity_name
          iv_entity_set_name       = iv_entity_set_name
          iv_source_name           = iv_source_name
          it_filter_select_options = it_filter_select_options
          it_order                 = it_order
          is_paging                = is_paging
          it_navigation_path       = it_navigation_path
          it_key_tab               = it_key_tab
          iv_filter_string         = iv_filter_string
          iv_search_string         = iv_search_string
          io_tech_request_context  = io_tech_request_context
          IMPORTING
          et_entityset             = zsegwset_get_entityset
          es_response_context      = es_response_context ).
*     Send specific entity data to the caller interface
        copy_data_to_ref(
          EXPORTING
          is_data = zsegwset_get_entityset
          CHANGING
          cr_data = er_entityset ).

      WHEN OTHERS.
        super->/iwbep/if_mgw_appl_srv_runtime~get_entityset(
          EXPORTING
          iv_entity_name           = iv_entity_name
          iv_entity_set_name       = iv_entity_set_name
          iv_source_name           = iv_source_name
          it_filter_select_options = it_filter_select_options
          it_order                 = it_order
          is_paging                = is_paging
          it_navigation_path       = it_navigation_path
          it_key_tab               = it_key_tab
          iv_filter_string         = iv_filter_string
          iv_search_string         = iv_search_string
          io_tech_request_context  = io_tech_request_context
          IMPORTING
          er_entityset             = er_entityset ).
    ENDCASE.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~update_entity.
*&----------------------------------------------------------------------------------------------*
*&  Include           /IWBEP/DPC_TEMP_UPD_ENTITY_BASE
*&* This class has been generated on 06.09.2023 14:18:59 in client 001
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside the DPC provider subclass - ZCL_ZSEGW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

    DATA zsegwset_update_entity TYPE zcl_zsegw_mpc=>ts_zsegw.
    DATA lv_entityset_name TYPE string.
    DATA lr_entity TYPE REF TO data. "#EC NEEDED

    lv_entityset_name = io_tech_request_context->get_entity_set_name( ).

    CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  zsegwSet
*-------------------------------------------------------------------------*
      WHEN 'zsegwSet'.
*     Call the entity set generated method
        zsegwset_update_entity(
               EXPORTING iv_entity_name          = iv_entity_name
                         iv_entity_set_name      = iv_entity_set_name
                         iv_source_name          = iv_source_name
                         io_data_provider        = io_data_provider
                         it_key_tab              = it_key_tab
                         it_navigation_path      = it_navigation_path
                         io_tech_request_context = io_tech_request_context
               IMPORTING er_entity               = zsegwset_update_entity ).
        IF zsegwset_update_entity IS NOT INITIAL.
*     Send specific entity data to the caller interface
          copy_data_to_ref(
            EXPORTING
              is_data = zsegwset_update_entity
            CHANGING
              cr_data = er_entity ).
        ELSE.
*         In case of initial values - unbind the entity reference
          er_entity = lr_entity.
        ENDIF.
      WHEN OTHERS.
        super->/iwbep/if_mgw_appl_srv_runtime~update_entity(
           EXPORTING
             iv_entity_name     = iv_entity_name
             iv_entity_set_name = iv_entity_set_name
             iv_source_name     = iv_source_name
             io_data_provider   = io_data_provider
             it_key_tab         = it_key_tab
             it_navigation_path = it_navigation_path
          IMPORTING
            er_entity           = er_entity ).
    ENDCASE.
  ENDMETHOD.


  METHOD /iwbep/if_sb_dpc_comm_services~commit_work.
* Call RFC commit work functionality
    DATA lt_message      TYPE bapiret2. "#EC NEEDED
    DATA lv_message_text TYPE bapi_msg.
    DATA lo_logger       TYPE REF TO /iwbep/cl_cos_logger.
    DATA lv_subrc        TYPE syst-subrc.

    lo_logger = /iwbep/if_mgw_conv_srv_runtime~get_logger( ).

    IF iv_rfc_dest IS INITIAL OR iv_rfc_dest = 'NONE'.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait   = abap_true
        IMPORTING
          return = lt_message.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        DESTINATION iv_rfc_dest
        EXPORTING
          wait                  = abap_true
        IMPORTING
          return                = lt_message
        EXCEPTIONS
          communication_failure = 1000 MESSAGE lv_message_text
          system_failure        = 1001 MESSAGE lv_message_text
          OTHERS                = 1002.
      IF sy-subrc <> 0.
        lv_subrc = sy-subrc.
        /iwbep/cl_sb_gen_dpc_rt_util=>rfc_exception_handling(
          iv_subrc            = lv_subrc
          iv_exp_message_text = lv_message_text
          io_logger           = lo_logger ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_sb_dpc_comm_services~get_generation_strategy.
* Get generation strategy
    rv_generation_strategy = '1'.
  ENDMETHOD.


  METHOD /iwbep/if_sb_dpc_comm_services~log_message.
* Log message in the application log
    DATA lo_logger TYPE REF TO /iwbep/cl_cos_logger.
    DATA lv_text TYPE /iwbep/sup_msg_longtext.

    MESSAGE ID iv_msg_id TYPE iv_msg_type NUMBER iv_msg_number
      WITH iv_msg_v1 iv_msg_v2 iv_msg_v3 iv_msg_v4 INTO lv_text.

    lo_logger = mo_context->get_logger( ).
    lo_logger->log_message(
      iv_msg_type   = iv_msg_type
      iv_msg_id     = iv_msg_id
      iv_msg_number = iv_msg_number
      iv_msg_text   = lv_text
      iv_msg_v1     = iv_msg_v1
      iv_msg_v2     = iv_msg_v2
      iv_msg_v3     = iv_msg_v3
      iv_msg_v4     = iv_msg_v4
      iv_agent      = 'DPC' ).
  ENDMETHOD.


  METHOD /iwbep/if_sb_dpc_comm_services~rfc_exception_handling.
* RFC call exception handling
    DATA lo_logger  TYPE REF TO /iwbep/cl_cos_logger.

    lo_logger = /iwbep/if_mgw_conv_srv_runtime~get_logger( ).

    /iwbep/cl_sb_gen_dpc_rt_util=>rfc_exception_handling(
      iv_subrc            = iv_subrc
      iv_exp_message_text = iv_exp_message_text
      io_logger           = lo_logger ).
  ENDMETHOD.


  METHOD /iwbep/if_sb_dpc_comm_services~rfc_save_log.
    DATA lo_logger  TYPE REF TO /iwbep/cl_cos_logger.
    DATA lo_message_container TYPE REF TO /iwbep/if_message_container.

    lo_logger = /iwbep/if_mgw_conv_srv_runtime~get_logger( ).
    lo_message_container = /iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

  " Save the RFC call log in the application log
    /iwbep/cl_sb_gen_dpc_rt_util=>rfc_save_log(
      is_return            = is_return
      iv_entity_type       = iv_entity_type
      it_return            = it_return
      it_key_tab           = it_key_tab
      io_logger            = lo_logger
      io_message_container = lo_message_container ).
  ENDMETHOD.


  METHOD /iwbep/if_sb_dpc_comm_services~set_injection.
* Unit test injection
    IF io_unit IS BOUND.
      mo_injection = io_unit.
    ELSE.
      mo_injection = me.
    ENDIF.
  ENDMETHOD.


  METHOD check_subscription_authority.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'CHECK_SUBSCRIPTION_AUTHORITY'.
  ENDMETHOD.


  METHOD zsegwset_create_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZSEGWSET_CREATE_ENTITY'.
  ENDMETHOD.


  METHOD zsegwset_delete_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'ZSEGWSET_DELETE_ENTITY'.
  ENDMETHOD.


  METHOD zsegwset_get_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'ZSEGWSET_GET_ENTITY'.
  ENDMETHOD.


  METHOD zsegwset_get_entityset.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'ZSEGWSET_GET_ENTITYSET'.
  ENDMETHOD.


  METHOD zsegwset_update_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'ZSEGWSET_UPDATE_ENTITY'.
  ENDMETHOD.
ENDCLASS.

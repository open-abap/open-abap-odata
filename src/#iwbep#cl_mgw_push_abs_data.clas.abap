CLASS /iwbep/cl_mgw_push_abs_data DEFINITION PUBLIC ABSTRACT CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_core_srv_runtime.
    INTERFACES /iwbep/if_mgw_conv_srv_runtime.
    INTERFACES /iwbep/if_mgw_appl_srv_runtime.
  PROTECTED SECTION.
    DATA mo_context TYPE REF TO /iwbep/if_mgw_context.
    METHODS check_subscription_authority
      IMPORTING
        is_subscription_data TYPE /iwbep/s_mgw_db_sub_data
      RAISING
        /iwbep/cx_mgw_busi_exception
        /iwbep/cx_mgw_tech_exception.
  PRIVATE SECTION.

ENDCLASS.

CLASS /iwbep/cl_mgw_push_abs_data IMPLEMENTATION.

  METHOD check_subscription_authority.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~update_stream.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_core_srv_runtime~init.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_conv_srv_runtime~get_message_container.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_conv_srv_runtime~set_header.
    RETURN.
  ENDMETHOD.

ENDCLASS.
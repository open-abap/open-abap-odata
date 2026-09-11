CLASS /iwbep/cl_mgw_push_abs_data DEFINITION PUBLIC ABSTRACT CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_core_srv_runtime.
    INTERFACES /iwbep/if_mgw_conv_srv_runtime.
    INTERFACES /iwbep/if_mgw_appl_srv_runtime.

    ALIASES copy_data_to_ref FOR /iwbep/if_mgw_conv_srv_runtime~copy_data_to_ref.

    TYPES BEGIN OF ty_s_media_resource.
    INCLUDE TYPE /iwbep/if_mgw_core_srv_runtime=>ty_s_media_resource.
    TYPES END OF ty_s_media_resource.

  PROTECTED SECTION.
    DATA mo_context TYPE REF TO /iwbep/if_mgw_context.
    DATA mr_request_details TYPE REF TO /iwbep/if_mgw_core_srv_runtime=>ty_s_mgw_request_context.

    METHODS check_subscription_authority
      IMPORTING
        is_subscription_data TYPE any
      RAISING
        /iwbep/cx_mgw_busi_exception
        /iwbep/cx_mgw_tech_exception.

ENDCLASS.

CLASS /iwbep/cl_mgw_push_abs_data IMPLEMENTATION.
  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

* Default of the framework base: no own expansion, read the plain entity
* (set) and leave the navigation properties to the framework. A DPC that
* wants the fast path redefines these and lists what it filled in
* et_expanded_tech_clauses.
  METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entity.
    CLEAR et_expanded_tech_clauses.
    /iwbep/if_mgw_appl_srv_runtime~get_entity(
      EXPORTING
        iv_entity_name          = iv_entity_name
        iv_entity_set_name      = iv_entity_set_name
        iv_source_name          = iv_source_name
        it_key_tab              = it_key_tab
        it_navigation_path      = it_navigation_path
        io_tech_request_context = io_tech_request_context
      IMPORTING
        er_entity               = er_entity
        es_response_context     = es_response_context ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset.
    CLEAR et_expanded_tech_clauses.
    /iwbep/if_mgw_appl_srv_runtime~get_entityset(
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
        er_entityset             = er_entityset
        es_response_context      = es_response_context ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~patch_entity.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_conv_srv_runtime~copy_data_to_ref.
    GET REFERENCE OF is_data INTO cr_data.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_conv_srv_runtime~get_dp_facade.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_conv_srv_runtime~get_logger.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~create_entity.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~delete_entity.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~get_entity.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~get_entityset.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_appl_srv_runtime~update_entity.
    RETURN.
  ENDMETHOD.

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
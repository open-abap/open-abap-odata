INTERFACE /iwbep/if_mgw_core_srv_runtime PUBLIC.

  TYPES ty_s_media_resource TYPE /iwbep/if_mgw_core_types=>ty_s_media_resource.

  TYPES: BEGIN OF function_import_s,
           name        TYPE string,
           return_type TYPE string,
           entity_set  TYPE string,
           http_method TYPE string,
         END OF function_import_s.

  TYPES: BEGIN OF ty_s_mgw_paging,
           top  TYPE string,
           skip TYPE string,
         END OF ty_s_mgw_paging.

  TYPES: BEGIN OF ty_s_placeholder_valuation,
           placeholder   TYPE string,
           value         TYPE string,
           pattern_value TYPE string,
         END OF ty_s_placeholder_valuation.
  TYPES ty_t_placeholder_valuation TYPE STANDARD TABLE OF ty_s_placeholder_valuation WITH KEY placeholder.

  TYPES ty_s_runtime_features TYPE /iwbep/if_mgw_appl_types=>ty_s_runtime_features.

  TYPES: BEGIN OF parameter_values_s,
           name  TYPE string,
           value TYPE string,
         END OF parameter_values_s.
  TYPES parameter_values_t TYPE STANDARD TABLE OF parameter_values_s WITH DEFAULT KEY.

  TYPES: BEGIN OF technical_request_s,
      action_name                TYPE /iwbep/mgw_tech_name,
      action_parameters          TYPE /iwbep/t_mgw_name_value_pair,
      action_return_type         TYPE /iwbep/mgw_tech_name,
      " batch_info                 TYPE ty_batch_info,
      " co_deployment_info         TYPE ty_co_deployment_info,
      " components                 TYPE string_table,
      " components_h               TYPE string_table,
      " conditions                 TYPE /iwbep/if_mgw_core_types=>ty_s_conditions,
      " expand                     TYPE string,
      " expand_root                TYPE REF TO object,
      " filter_expressions         TYPE tt_expressions,
      " filter_functions           TYPE tt_functions,
      " filter_select_options      TYPE /iwbep/t_mgw_select_option,
      " filter_select_placeholders TYPE /iwbep/t_mgw_select_option,
      " filter_string              TYPE string,
      " is_csrf_token_protected    TYPE abap_bool,
      " is_ral_relevant            TYPE abap_bool,
      " is_strict_handling         TYPE abap_bool,
      " key                        TYPE string,
      " key_converter              TYPE REF TO object,
      " key_tab                    TYPE /iwbep/t_mgw_tech_pairs,
      " navigation_path            TYPE /iwbep/t_mgw_tech_navi,
      " operation_type             TYPE /iwbep/mgw_operation_type,
      " order                      TYPE /iwbep/t_mgw_tech_order,
      " parameters                 TYPE /iwbep/t_mgw_name_value_pair,
      " request_header             TYPE tihttpnvp,
      " select                     TYPE /iwbep/t_mgw_tech_field_names,
      " select_navis               TYPE string_table,
      " select_strings             TYPE string_table,
      " select_strings_h           TYPE string_table,
      " service_name               TYPE /iwbep/med_grp_technical_name,
      " service_version            TYPE /iwbep/med_grp_version,
      " source_entity_set          TYPE /iwbep/mgw_tech_name,
      " source_entity_type         TYPE /iwbep/mgw_tech_name,
      " target_entity_set          TYPE /iwbep/mgw_tech_name,
      " target_entity_type         TYPE /iwbep/mgw_tech_name,
      " totals                     TYPE /iwbep/t_mgw_tech_field_names,
      " verbose_metadata           TYPE /iwbep/mgw_verbose_metadata,
      " message_scope              TYPE /iwbep/t_mgw_message_scope,
      " message_scope_error        TYPE string,
      " is_partial_busi_data       TYPE abap_bool,
    END OF technical_request_s.

  TYPES: BEGIN OF ty_s_mgw_request_context,
      service_doc_name           TYPE string,
      version                    TYPE n LENGTH 4,
      base_url                   TYPE string,
      cache_timestamp            TYPE tzntstmps,
      context_params             TYPE /iwbep/t_mgw_name_value_pair,
      crp_on_hub_allowed         TYPE abap_bool,
      filter_select_options      TYPE /iwbep/t_mgw_select_option,
      format                     TYPE string,
      function                   TYPE function_import_s,
      http_method                TYPE string,
      icf_root_node              TYPE c LENGTH 15,
      if_modified_since          TYPE tzntstmps,
      incoming_message           TYPE xstring,
      key                        TYPE string,
      key_tab                    TYPE /iwbep/t_mgw_name_value_pair,
      namespace                  TYPE string,
      navigation_path            TYPE /iwbep/t_mgw_navigation_path,
      operation                  TYPE string,
      order                      TYPE /iwbep/t_mgw_sorting_order,
      paging                     TYPE ty_s_mgw_paging,
      parameters                 TYPE /iwbep/t_mgw_name_value_pair,
      placeholder_valuation      TYPE ty_t_placeholder_valuation,
      property_path              TYPE string_table,
      request_service_name       TYPE string,
      reset_dp                   TYPE abap_bool,
      resource_from_uri          TYPE string,
      select_params              TYPE string_table,
      softstate_before           TYPE abap_bool,
      softstate_enabled          TYPE abap_bool,
      softstate_mode             TYPE abap_bool,
      source_entity              TYPE string,
      source_entity_set          TYPE string,
      supported_runtime_features TYPE ty_s_runtime_features,
      t_uri_query_parameter      TYPE parameter_values_t,
      target_entity              TYPE string,
      target_entity_set          TYPE string,
      technical_request          TYPE technical_request_s,
      termination_reason         TYPE i,
      type                       TYPE string,
      uri_parameters             TYPE /iwbep/t_mgw_name_value_pair,
    END OF ty_s_mgw_request_context.

  METHODS init
    IMPORTING
      iv_service_document_name TYPE string
      iv_namespace             TYPE string
      iv_version               TYPE string
      io_context               TYPE string.

ENDINTERFACE.
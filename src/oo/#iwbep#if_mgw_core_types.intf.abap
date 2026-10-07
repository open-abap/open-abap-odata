INTERFACE /iwbep/if_mgw_core_types PUBLIC.

  TYPES ty_s_media_resource TYPE /iwbep/if_mgw_appl_types=>ty_s_media_resource.

  TYPES ty_placeholder_kind TYPE c LENGTH 1.
  TYPES:
    BEGIN OF ty_s_placeholder_info,
      kind               TYPE ty_placeholder_kind,
      placeholder        TYPE string,
      int_abap_type_kind TYPE abap_typekind,
      int_abap_length    TYPE i,
      int_abap_decimals  TYPE i,
      pro_abap_type_kind TYPE abap_typekind,
      pro_abap_length    TYPE i,
      pro_abap_decimals  TYPE i,
      edm_type_name      TYPE string,
      conversion_type    TYPE /iwbep/if_mgw_odata_fw_prop=>ty_conversion_type,
      conversion_exit    TYPE c LENGTH 5,
      function           TYPE c LENGTH 1,
      is_uppercase       TYPE abap_bool,
      ref_placeholder    TYPE string,
    END OF ty_s_placeholder_info.
  TYPES ty_t_placeholder_info TYPE SORTED TABLE OF ty_s_placeholder_info WITH UNIQUE KEY placeholder.

  TYPES: BEGIN OF ty_s_mgw_response_context_comm,
      is_ral_relevant TYPE boolean,
      key_tab         TYPE /iwbep/t_mgw_tech_pairs,
    END OF ty_s_mgw_response_context_comm.

  TYPES: BEGIN OF ty_s_cached_service_info,
      service_technical_name TYPE c LENGTH 35,
      service_version        TYPE n LENGTH 4,
      data_provider_class    TYPE c LENGTH 30,
      model_provider_class   TYPE c LENGTH 30,
      metadata_last_modified TYPE timestamp,
    END OF ty_s_cached_service_info.

  TYPES:
    BEGIN OF ty_s_mgw_frw_response_context,
      auto_add_selected_props TYPE string_table,
      crp_placeholder_info    TYPE ty_t_placeholder_info,
      crp_service_info        TYPE ty_s_cached_service_info,
      entity_set_crp_usage    TYPE abap_bool,
      is_cache_hit            TYPE boolean,
      is_cache_hit_shm        TYPE boolean,
      is_target_format        TYPE abap_bool,
      st_entityset_count      TYPE i,
      st_response_size        TYPE i.
      INCLUDE TYPE ty_s_mgw_response_context_comm AS common_response_context.
  TYPES END OF ty_s_mgw_frw_response_context.

  TYPES BEGIN OF ty_s_mgw_response_context.
      INCLUDE TYPE /iwbep/if_mgw_appl_types=>ty_s_mgw_response_context AS appl_response_context.
      INCLUDE TYPE ty_s_mgw_frw_response_context AS frw_response_context.
  TYPES END OF ty_s_mgw_response_context.

ENDINTERFACE.
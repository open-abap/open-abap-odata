INTERFACE /iwbep/if_mgw_appl_types PUBLIC.

  TYPES: BEGIN OF ty_s_media_resource,
           mime_type TYPE string,
           value     TYPE xstring,
         END OF ty_s_media_resource.

  TYPES: BEGIN OF ty_s_mgw_response_context,
           count                         TYPE string,
           inlinecount                   TYPE string,
           skiptoken                     TYPE string,
           deltatoken                    TYPE string,
           expand_skiptokens             TYPE string_table,
           last_modified                 TYPE tzntstmps,
           max_age                       TYPE int4,
           is_not_modified               TYPE abap_bool,
           do_not_cache_on_client        TYPE abap_bool,
           do_cache_and_page_on_hub      TYPE abap_bool,
           age                           TYPE i,
           crp_provider_request          TYPE string,
           is_sap_data_exists_calculated TYPE abap_bool,
           document_description          TYPE REF TO object,
         END OF ty_s_mgw_response_context.

  TYPES: BEGIN OF ty_s_runtime_features,
           initial_for_null_in_filter  TYPE abap_bool,
           provided_properties         TYPE abap_bool,
           technical_properties        TYPE abap_bool,
           transient_flag_for_messages TYPE abap_bool,
         END OF ty_s_runtime_features.

ENDINTERFACE.
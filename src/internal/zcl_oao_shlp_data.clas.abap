CLASS zcl_oao_shlp_data DEFINITION PUBLIC.
* The search help runtime a generated DPC reaches through
* /iwbep/cl_sb_shlp_data_factory. There are no search helps here, so an
* application registers a provider per search help name; an unknown name
* comes back as an error message, the way the Gateway reports one
  PUBLIC SECTION.
    INTERFACES /iwbep/if_sb_shlp_data.

    CLASS-METHODS register
      IMPORTING
        iv_shlp_name TYPE csequence
        io_provider  TYPE REF TO /iwbep/if_sb_gendpc_shlp_data.

    CLASS-METHODS clear.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_provider,
             name     TYPE string,
             provider TYPE REF TO /iwbep/if_sb_gendpc_shlp_data,
           END OF ty_provider.
    CLASS-DATA gt_providers TYPE STANDARD TABLE OF ty_provider WITH DEFAULT KEY.
ENDCLASS.

CLASS zcl_oao_shlp_data IMPLEMENTATION.

  METHOD register.
    DATA ls_provider TYPE ty_provider.

    ls_provider-name     = to_upper( iv_shlp_name ).
    ls_provider-provider = io_provider.
    DELETE gt_providers WHERE name = ls_provider-name.
    APPEND ls_provider TO gt_providers.
  ENDMETHOD.

  METHOD clear.
    CLEAR gt_providers.
  ENDMETHOD.

  METHOD /iwbep/if_sb_gendpc_shlp_data~get_search_help_values.
    DATA ls_provider TYPE ty_provider.
    DATA lv_name     TYPE string.

    CLEAR: et_return_list, es_message.
    lv_name = to_upper( iv_shlp_name ).
    READ TABLE gt_providers INTO ls_provider WITH KEY name = lv_name.
    IF sy-subrc <> 0.
      es_message-type    = 'E'.
      es_message-message = |Search help { lv_name } is not available here, register a provider with zcl_oao_shlp_data=>register|.
      RETURN.
    ENDIF.
    ls_provider-provider->get_search_help_values(
      EXPORTING
        iv_shlp_name      = iv_shlp_name
        iv_maxrows        = iv_maxrows
        iv_sort           = iv_sort
        iv_call_shlt_exit = iv_call_shlt_exit
        it_selopt         = it_selopt
      IMPORTING
        et_return_list    = et_return_list
        es_message        = es_message ).
  ENDMETHOD.

ENDCLASS.

INTERFACE /iwbep/if_sb_gendpc_shlp_data PUBLIC.
* what a generated DPC needs from the search help runtime for an operation
* mapped to a search help: the values as record / field / value rows
  TYPES: BEGIN OF ty_s_result_list,
           record_number TYPE i,
           field_name    TYPE string,
           field_value   TYPE string,
         END OF ty_s_result_list.
  TYPES tt_result_list TYPE STANDARD TABLE OF ty_s_result_list WITH DEFAULT KEY.

  METHODS get_search_help_values
    IMPORTING
      iv_shlp_name      TYPE csequence
      iv_maxrows        TYPE i OPTIONAL
      iv_sort           TYPE abap_bool DEFAULT abap_false
      iv_call_shlt_exit TYPE abap_bool DEFAULT abap_false
      it_selopt         TYPE ddshselops OPTIONAL
    EXPORTING
      et_return_list    TYPE tt_result_list
      es_message        TYPE bapiret2.

ENDINTERFACE.

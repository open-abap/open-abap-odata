CLASS zcl_oao_property DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_odata_property.

    DATA mv_abap_fieldname TYPE string.
    DATA mv_is_key         TYPE abap_bool.
    DATA mv_filterable     TYPE abap_bool.
    DATA mv_nullable       TYPE abap_bool.
    DATA mv_sortable       TYPE abap_bool.
    DATA mv_updatable      TYPE abap_bool.
    DATA mv_creatable      TYPE abap_bool.
    DATA mv_maxlength      TYPE i.
    DATA mv_precision      TYPE i.
    DATA mv_edm_type       TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_edm_type.
    DATA mv_conv_exit      TYPE string.
    DATA mv_conversion     TYPE abap_bool VALUE abap_true.
    DATA mv_content_type   TYPE abap_bool.
    DATA mv_text_symbol    TYPE textpoolky.
    DATA mv_text_container TYPE string.
    DATA mv_label          TYPE string.
    DATA mo_annotation     TYPE REF TO zcl_oao_annotation.
ENDCLASS.

CLASS zcl_oao_property IMPLEMENTATION.
  METHOD /iwbep/if_mgw_odata_property~set_type_edm_string.
    mv_edm_type = /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-string.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_type_edm_byte.
    mv_edm_type = /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-byte.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_type_edm_int16.
    mv_edm_type = /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-int16.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_type_edm_int32.
    mv_edm_type = /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-int32.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_type_edm_boolean.
    mv_edm_type = /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-boolean.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_type_edm_decimal.
    mv_edm_type = /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-decimal.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_type_edm_datetime.
    mv_edm_type = /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-datetime.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_type_edm_time.
    mv_edm_type = /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-time.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_precison.
    mv_precision = iv_precision.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_conversion_exit.
    mv_conv_exit = iv_conv_exit.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~disable_conversion.
    mv_conversion = abap_false.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_as_content_type.
    mv_content_type = abap_true.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_item~set_label_from_text_element.
    mv_text_symbol    = iv_text_element_symbol.
    mv_text_container = iv_text_element_container.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_maxlength.
    mv_maxlength = iv_max_length.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_creatable.
    mv_creatable = iv_creatable.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_updatable.
    mv_updatable = iv_updatable.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_sortable.
    mv_sortable = iv_sortable.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_nullable.
    mv_nullable = iv_nullable.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_filterable.
    mv_filterable = iv_filterable.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_property~set_is_key.
    mv_is_key = iv_key.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_annotatabl~create_annotation.
    IF mo_annotation IS NOT BOUND.
      CREATE OBJECT mo_annotation.
    ENDIF.
    ro_annotation = mo_annotation.
  ENDMETHOD.

ENDCLASS.

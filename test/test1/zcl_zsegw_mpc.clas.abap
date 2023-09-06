CLASS zcl_zsegw_mpc DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_mgw_push_abs_model
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES ts_zsegw TYPE zsegw.
    TYPES tt_zsegw TYPE STANDARD TABLE OF ts_zsegw.
    TYPES: BEGIN OF ts_text_element,
            artifact_name  TYPE c LENGTH 40,
            artifact_type  TYPE c LENGTH 4,
            parent_artifact_name TYPE c LENGTH 40,
            parent_artifact_type TYPE c LENGTH 4,
            text_symbol    TYPE textpoolky,
          END OF ts_text_element .
    TYPES tt_text_elements TYPE STANDARD TABLE OF ts_text_element WITH KEY text_symbol.

    CONSTANTS gc_zsegw TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name VALUE 'zsegw' ##NO_TEXT.

    METHODS load_text_elements FINAL
      RETURNING
        VALUE(rt_text_elements) TYPE tt_text_elements
      RAISING
        /iwbep/cx_mgw_med_exception .

    METHODS define REDEFINITION.
    METHODS get_last_modified REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS gc_incl_name TYPE string VALUE 'ZCL_ZSEGW_MPC=================CP' ##NO_TEXT.

    METHODS define_zsegw
      RAISING
      /iwbep/cx_mgw_med_exception .
ENDCLASS.



CLASS zcl_zsegw_mpc IMPLEMENTATION.


  METHOD define.
    model->set_schema_namespace( 'ZSEGW_SRV' ).

    define_zsegw( ).
  ENDMETHOD.


  METHOD define_zsegw.

    DATA:
        lo_annotation     TYPE REF TO /iwbep/if_mgw_odata_annotation,                "#EC NEEDED
        lo_entity_type    TYPE REF TO /iwbep/if_mgw_odata_entity_typ,                "#EC NEEDED
        lo_complex_type   TYPE REF TO /iwbep/if_mgw_odata_cmplx_type,                "#EC NEEDED
        lo_property       TYPE REF TO /iwbep/if_mgw_odata_property,                  "#EC NEEDED
        lo_entity_set     TYPE REF TO /iwbep/if_mgw_odata_entity_set.                "#EC NEEDED

***********************************************************************************************************************************
*   ENTITY - zsegw
***********************************************************************************************************************************

    lo_entity_type = model->create_entity_type( iv_entity_type_name = 'zsegw'
                                                iv_def_entity_set   = abap_false ). "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

    lo_property = lo_entity_type->create_property( iv_property_name  = 'Something1'
                                                   iv_abap_fieldname = 'SOMETHING1' ). "#EC NOTEXT
    lo_property->set_label_from_text_element( iv_text_element_symbol    = '001'
                                              iv_text_element_container = gc_incl_name ).  "#EC NOTEXT
    lo_property->set_is_key( ).
    lo_property->set_type_edm_string( ).
    lo_property->set_maxlength( 10 ).
    lo_property->set_creatable( abap_false ).
    lo_property->set_updatable( abap_false ).
    lo_property->set_sortable( abap_false ).
    lo_property->set_nullable( abap_false ).
    lo_property->set_filterable( abap_false ).
    lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      iv_key     = 'unicode'
        iv_value = 'false' ).
    lo_property = lo_entity_type->create_property( iv_property_name  = 'Something2'
                                                   iv_abap_fieldname = 'SOMETHING2' ). "#EC NOTEXT
    lo_property->set_label_from_text_element( iv_text_element_symbol    = '002'
                                              iv_text_element_container = gc_incl_name ).  "#EC NOTEXT
    lo_property->set_type_edm_string( ).
    lo_property->set_maxlength( 10 ).
    lo_property->set_creatable( abap_false ).
    lo_property->set_updatable( abap_false ).
    lo_property->set_sortable( abap_false ).
    lo_property->set_nullable( abap_false ).
    lo_property->set_filterable( abap_false ).
    lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
        iv_key   = 'unicode'
        iv_value = 'false' ).

    lo_entity_type->bind_structure(
      iv_structure_name   = 'ZSEGW'
      iv_bind_conversions = 'X' ). "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
    lo_entity_set = lo_entity_type->create_entity_set( 'zsegwSet' ). "#EC NOTEXT

    lo_entity_set->set_creatable( abap_false ).
    lo_entity_set->set_updatable( abap_false ).
    lo_entity_set->set_deletable( abap_false ).

    lo_entity_set->set_pageable( abap_false ).
    lo_entity_set->set_addressable( abap_true ).
    lo_entity_set->set_has_ftxt_search( abap_false ).
    lo_entity_set->set_subscribable( abap_false ).
    lo_entity_set->set_filter_required( abap_false ).
  ENDMETHOD.


  METHOD get_last_modified.
    CONSTANTS lc_gen_date_time TYPE timestamp VALUE '20230906141857'.                  "#EC NOTEXT
    rv_last_modified = super->get_last_modified( ).
    IF rv_last_modified < lc_gen_date_time.
      rv_last_modified = lc_gen_date_time.
    ENDIF.
  ENDMETHOD.


  METHOD load_text_elements.

    DATA ls_text_element TYPE ts_text_element.                                 "#EC NEEDED

    CLEAR ls_text_element.
    ls_text_element-artifact_name          = 'Something1'.                 "#EC NOTEXT
    ls_text_element-artifact_type          = 'PROP'.                                       "#EC NOTEXT
    ls_text_element-parent_artifact_name   = 'zsegw'.                            "#EC NOTEXT
    ls_text_element-parent_artifact_type   = 'ETYP'.                                       "#EC NOTEXT
    ls_text_element-text_symbol            = '001'.              "#EC NOTEXT
    APPEND ls_text_element TO rt_text_elements.

    CLEAR ls_text_element.
    ls_text_element-artifact_name          = 'Something2' ##NO_TEXT.
    ls_text_element-artifact_type          = 'PROP'.                                       "#EC NOTEXT
    ls_text_element-parent_artifact_name   = 'zsegw'.                            "#EC NOTEXT
    ls_text_element-parent_artifact_type   = 'ETYP'.                                       "#EC NOTEXT
    ls_text_element-text_symbol            = '002'.              "#EC NOTEXT
    APPEND ls_text_element TO rt_text_elements.
  ENDMETHOD.
ENDCLASS.

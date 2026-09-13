CLASS zcl_oao_entity_typ DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_odata_entity_typ.

* sap: annotations of the entity type (semantics="aggregate", label, ...)
    DATA mo_annotation TYPE REF TO zcl_oao_annotation.
* a media entity: its content is a stream, read and written at <entity>/$value
    DATA mv_is_media   TYPE abap_bool.

    TYPES: BEGIN OF ty_entity_set,
             name       TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name,
             entity_set TYPE REF TO zcl_oao_entity_set,
           END OF ty_entity_set.
    TYPES ty_entity_sets TYPE STANDARD TABLE OF ty_entity_set WITH DEFAULT KEY.

    TYPES ty_nav_props TYPE STANDARD TABLE OF REF TO zcl_oao_nav_prop WITH DEFAULT KEY.

    METHODS get_entity_sets
      RETURNING
        VALUE(rt_entity_sets) TYPE ty_entity_sets.

    METHODS get_navigation_properties
      RETURNING
        VALUE(rt_nav_props) TYPE ty_nav_props.

* the model this type belongs to, complex properties look their type up there
    DATA mo_model TYPE REF TO /iwbep/if_mgw_odata_model.
  PRIVATE SECTION.
    DATA mv_structure_name TYPE string.
    DATA mt_properties  TYPE /iwbep/if_mgw_med_odata_types=>ty_t_mgw_odata_properties.
    DATA mt_entity_sets TYPE ty_entity_sets.
    DATA mt_nav_props   TYPE ty_nav_props.
ENDCLASS.

CLASS zcl_oao_entity_typ IMPLEMENTATION.

  METHOD /iwbep/if_mgw_odata_item~set_label_from_text_element.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_annotatabl~create_annotation.
    IF mo_annotation IS NOT BOUND.
      CREATE OBJECT mo_annotation.
    ENDIF.
    ro_annotation = mo_annotation.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_entity_typ~create_navigation_property.
    DATA lo_nav TYPE REF TO zcl_oao_nav_prop.

    CREATE OBJECT lo_nav.
    lo_nav->mv_name           = iv_property_name.
    lo_nav->mv_association    = iv_association_name.
    lo_nav->mv_abap_fieldname = iv_abap_fieldname.
    APPEND lo_nav TO mt_nav_props.
    ro_navigation_property = lo_nav.
  ENDMETHOD.

  METHOD get_navigation_properties.
    rt_nav_props = mt_nav_props.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_entity_typ~create_entity_set.
    DATA ls_row LIKE LINE OF mt_entity_sets.

    CREATE OBJECT ro_entity_set TYPE zcl_oao_entity_set.

    ls_row-name = iv_entity_set_name.
    ls_row-entity_set ?= ro_entity_set.
    APPEND ls_row TO mt_entity_sets.
  ENDMETHOD.

  METHOD get_entity_sets.
    rt_entity_sets = mt_entity_sets.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_entity_typ~set_is_media.
    mv_is_media = iv_is_media.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_entity_typ~bind_structure.
* what the Gateway derives from the bound structure's DDIC types: a date
* field behind Edm.DateTime is shown as a date (sap:display-format="Date")
    DATA lo_descr    TYPE REF TO cl_abap_typedescr.
    DATA lo_struct   TYPE REF TO cl_abap_structdescr.
    DATA ls_prop     LIKE LINE OF mt_properties.
    DATA lo_property TYPE REF TO zcl_oao_property.
    DATA lt_comp     TYPE abap_component_tab.
    DATA ls_comp     LIKE LINE OF lt_comp.

    mv_structure_name = iv_structure_name.
    cl_abap_typedescr=>describe_by_name( EXPORTING p_name = iv_structure_name
                                         RECEIVING type   = lo_descr
                                         EXCEPTIONS type_not_found = 1 OTHERS = 2 ).
    IF sy-subrc <> 0 OR lo_descr IS NOT BOUND OR lo_descr->kind <> cl_abap_typedescr=>kind_struct.
      RETURN.
    ENDIF.
    lo_struct ?= lo_descr.
    lt_comp = lo_struct->get_components( ).

    LOOP AT mt_properties INTO ls_prop.
      lo_property ?= ls_prop-property.
      READ TABLE lt_comp INTO ls_comp WITH KEY name = lo_property->mv_abap_fieldname.
      IF sy-subrc = 0 AND ls_comp-type IS BOUND AND ls_comp-type->type_kind = cl_abap_typedescr=>typekind_date.
        lo_property->mv_display_format = 'Date'.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_entity_typ~create_property.
    DATA ls_row      LIKE LINE OF mt_properties.
    DATA lo_property TYPE REF TO zcl_oao_property.

    CREATE OBJECT lo_property.
    lo_property->mv_abap_fieldname = iv_abap_fieldname.
    ro_property = lo_property.

    ls_row-name = iv_property_name.
    ls_row-property = ro_property.
    INSERT ls_row INTO TABLE mt_properties.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_entity_typ~create_complex_property.
    DATA ls_row      LIKE LINE OF mt_properties.
    DATA lo_property TYPE REF TO zcl_oao_property.

    CREATE OBJECT lo_property.
    lo_property->mv_abap_fieldname = iv_abap_fieldname.
    lo_property->mv_complex_type   = iv_complex_type_name.

    ls_row-name = iv_property_name.
    ls_row-property = lo_property.
    INSERT ls_row INTO TABLE mt_properties.

    IF mo_model IS BOUND.
      ro_complex_type = mo_model->get_complex_type( iv_complex_type_name ).
    ENDIF.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_entity_typ~get_property.
    DATA ls_row LIKE LINE OF mt_properties.

    READ TABLE mt_properties INTO ls_row WITH KEY name = iv_property_name.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_med_exception.
    ENDIF.
    ro_property = ls_row-property.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_entity_typ~get_properties.
    rt_properties = mt_properties.
  ENDMETHOD.

ENDCLASS.
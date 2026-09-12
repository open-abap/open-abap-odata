CLASS zcl_oao_http_handler DEFINITION PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_data,
             content_type TYPE string,
             data         TYPE string,
           END OF ty_data.

    CLASS-METHODS handle
      IMPORTING iv_path        TYPE string
      RETURNING VALUE(rs_data) TYPE ty_data
      RAISING cx_static_check.

    CLASS-METHODS property_xml
      IMPORTING
        iv_name       TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
        io_property   TYPE REF TO zcl_oao_property
        iv_namespace  TYPE string OPTIONAL
      RETURNING
        VALUE(rv_xml) TYPE string.

* <ComplexType> elements of the model, printed after the entity types
    CLASS-METHODS complex_types_xml
      IMPORTING
        io_model      TYPE REF TO zcl_oao_model
        iv_namespace  TYPE string
      RETURNING
        VALUE(rv_xml) TYPE string.

  PRIVATE SECTION.
    CONSTANTS gc_host TYPE string VALUE 'http://localhost:8080'.

    CLASS-METHODS metadata
      IMPORTING
        iv_service    TYPE string
      RETURNING
        VALUE(rv_xml) TYPE string
      RAISING
        /iwbep/cx_mgw_med_exception
        /iwbep/cx_mgw_tech_exception.

    CLASS-METHODS data
      IMPORTING
        iv_service     TYPE string
        iv_entity_set  TYPE string
      RETURNING
        VALUE(rv_json) TYPE string
      RAISING
        /iwbep/cx_mgw_busi_exception
        /iwbep/cx_mgw_tech_exception.

    CLASS-METHODS map_boolean
      IMPORTING iv_boolean       TYPE abap_bool
      RETURNING VALUE(rv_string) TYPE string.

* sap:searchable, printed only when set_has_ftxt_search said so (as the Gateway does)
    CLASS-METHODS searchable_xml
      IMPORTING io_set        TYPE REF TO zcl_oao_entity_set
      RETURNING VALUE(rv_xml) TYPE string.

    CLASS-METHODS multiplicity
      IMPORTING
        iv_card          TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_cardinality
      RETURNING
        VALUE(rv_string) TYPE string.

    CLASS-METHODS association_xml
      IMPORTING
        io_association TYPE REF TO zcl_oao_association
        iv_namespace   TYPE string
      RETURNING
        VALUE(rv_xml)  TYPE string.

    CLASS-METHODS function_import_xml
      IMPORTING
        io_action     TYPE REF TO zcl_oao_action
        iv_namespace  TYPE string
      RETURNING
        VALUE(rv_xml) TYPE string.

    CLASS-METHODS custom_annotations_xml
      IMPORTING
        io_annotation TYPE REF TO zcl_oao_annotation
        it_builtin    TYPE string_table
      RETURNING
        VALUE(rv_xml) TYPE string.

ENDCLASS.

CLASS zcl_oao_http_handler IMPLEMENTATION.

  METHOD handle.

    DATA lv_service    TYPE string.
    DATA lv_entity_set TYPE string.

* /sap/opu/odata/sap/<service>/<entity set or $metadata>...
    FIND REGEX '/sap/opu/odata/sap/([^/]+)/?([^/(?]*)' IN iv_path
      SUBMATCHES lv_service lv_entity_set.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.

* todo, verb + key + query options
    IF lv_entity_set = '$metadata'.
      rs_data-content_type = 'text/xml'.
      rs_data-data = metadata( lv_service ).
    ELSE.
      rs_data-content_type = 'application/json'.
      rs_data-data = data( iv_service    = lv_service
                           iv_entity_set = lv_entity_set ).
    ENDIF.

  ENDMETHOD.

  METHOD complex_types_xml.
    DATA lt_complex_types TYPE zcl_oao_model=>ty_complex_types.
    DATA ls_complex_type  LIKE LINE OF lt_complex_types.
    DATA lt_properties    TYPE /iwbep/if_mgw_med_odata_types=>ty_t_mgw_odata_properties.
    DATA ls_property      LIKE LINE OF lt_properties.
    DATA lo_property      TYPE REF TO zcl_oao_property.

    lt_complex_types = io_model->get_complex_types( ).
    LOOP AT lt_complex_types INTO ls_complex_type.
      rv_xml = rv_xml && |      <ComplexType Name="{ ls_complex_type-name }">\n|.
      lt_properties = ls_complex_type-complex_type->/iwbep/if_mgw_odata_cmplx_type~get_properties( ).
      LOOP AT lt_properties INTO ls_property.
        lo_property ?= ls_property-property.
        rv_xml = rv_xml && property_xml( iv_name      = ls_property-name
                                         io_property  = lo_property
                                         iv_namespace = iv_namespace ).
      ENDLOOP.
      rv_xml = rv_xml && |      </ComplexType>\n|.
    ENDLOOP.
  ENDMETHOD.

  METHOD searchable_xml.
    IF io_set->mv_fsearch = abap_true.
      rv_xml = ` sap:searchable="true"`.
    ENDIF.
  ENDMETHOD.

  METHOD map_boolean.
    CASE iv_boolean.
      WHEN abap_true.
        rv_string = 'true'.
      WHEN abap_false.
        rv_string = 'false'.
      WHEN OTHERS.
        ASSERT 1 = 2.
    ENDCASE.
  ENDMETHOD.

  METHOD multiplicity.
    CASE iv_card.
      WHEN '1'.
        rv_string = '1'.
      WHEN '0' OR 'O'.
        rv_string = '0..1'.
      WHEN OTHERS.
* 'N', 'M', '*'
        rv_string = '*'.
    ENDCASE.
  ENDMETHOD.

  METHOD association_xml.
    DATA ls_pair TYPE zcl_oao_ref_constraint=>ty_pair.
    DATA lv_principal_role TYPE string.
    DATA lv_dependent_role TYPE string.

    rv_xml =
      |      <Association Name="{ io_association->mv_name }" sap:content-version="1">\n| &&
      |        <End Type="{ iv_namespace }.{ io_association->mv_left_type }" Multiplicity="{ multiplicity( io_association->mv_left_card ) }" Role="FromRole_{ io_association->mv_name }"/>\n| &&
      |        <End Type="{ iv_namespace }.{ io_association->mv_right_type }" Multiplicity="{ multiplicity( io_association->mv_right_card ) }" Role="ToRole_{ io_association->mv_name }"/>\n|.
    IF io_association->mo_ref_constraint IS BOUND AND io_association->mo_ref_constraint->mt_pairs IS NOT INITIAL.
      IF io_association->mo_ref_constraint->mv_principal_is_left = abap_true.
        lv_principal_role = |FromRole_{ io_association->mv_name }|.
        lv_dependent_role = |ToRole_{ io_association->mv_name }|.
      ELSE.
        lv_principal_role = |ToRole_{ io_association->mv_name }|.
        lv_dependent_role = |FromRole_{ io_association->mv_name }|.
      ENDIF.
      rv_xml = rv_xml && |        <ReferentialConstraint>\n          <Principal Role="{ lv_principal_role }">\n|.
      LOOP AT io_association->mo_ref_constraint->mt_pairs INTO ls_pair.
        rv_xml = rv_xml && |            <PropertyRef Name="{ ls_pair-principal }"/>\n|.
      ENDLOOP.
      rv_xml = rv_xml && |          </Principal>\n          <Dependent Role="{ lv_dependent_role }">\n|.
      LOOP AT io_association->mo_ref_constraint->mt_pairs INTO ls_pair.
        rv_xml = rv_xml && |            <PropertyRef Name="{ ls_pair-dependent }"/>\n|.
      ENDLOOP.
      rv_xml = rv_xml && |          </Dependent>\n        </ReferentialConstraint>\n|.
    ENDIF.
    rv_xml = rv_xml && |      </Association>\n|.
  ENDMETHOD.

  METHOD function_import_xml.
    DATA lo_parameter TYPE REF TO zcl_oao_parameter.
    DATA lv_return    TYPE string.
    DATA lv_facets    TYPE string.

    IF io_action->mv_return_entity_type IS NOT INITIAL.
      lv_return = |{ iv_namespace }.{ io_action->mv_return_entity_type }|.
    ELSEIF io_action->mv_return_complex_type IS NOT INITIAL.
      lv_return = |{ iv_namespace }.{ io_action->mv_return_complex_type }|.
    ELSE.
      lv_return = ''.
    ENDIF.
    IF lv_return IS NOT INITIAL AND io_action->mv_return_multiplicity <> '1' AND io_action->mv_return_multiplicity <> '0'.
      lv_return = |Collection({ lv_return })|.
    ENDIF.
    rv_xml = rv_xml && |        <FunctionImport Name="{ io_action->mv_name }"|.
    IF lv_return IS NOT INITIAL.
      rv_xml = rv_xml && | ReturnType="{ lv_return }"|.
    ENDIF.
    IF io_action->mv_return_entity_set IS NOT INITIAL.
      rv_xml = rv_xml && | EntitySet="{ io_action->mv_return_entity_set }"|.
    ENDIF.
    rv_xml = rv_xml && | m:HttpMethod="{ io_action->mv_http_method }"|.
    IF io_action->mv_action_for IS NOT INITIAL.
      rv_xml = rv_xml && | sap:action-for="{ iv_namespace }.{ io_action->mv_action_for }"|.
    ENDIF.
    IF io_action->mt_parameters IS INITIAL.
      rv_xml = rv_xml && |/>\n|.
    ELSE.
      rv_xml = rv_xml && |>\n|.
      LOOP AT io_action->mt_parameters INTO lo_parameter.
        IF lo_parameter->mv_edm_type IS INITIAL.
          lo_parameter->mv_edm_type = /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-string.
        ENDIF.
        lv_facets = ''.
        IF lo_parameter->mv_edm_type = /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-string AND lo_parameter->mv_maxlength > 0.
          lv_facets = | MaxLength="{ lo_parameter->mv_maxlength }"|.
        ENDIF.
        rv_xml = rv_xml &&
          |          <Parameter Name="{ lo_parameter->mv_name }" Type="{ lo_parameter->mv_edm_type }" Mode="{ lo_parameter->mv_mode }"{ lv_facets }/>\n|.
      ENDLOOP.
      rv_xml = rv_xml && |        </FunctionImport>\n|.
    ENDIF.
  ENDMETHOD.

  METHOD custom_annotations_xml.
    DATA lt_annotations TYPE zcl_oao_annotation=>ty_annotations.
    DATA ls_annotation  LIKE LINE OF lt_annotations.
    DATA lv_key         TYPE string.

    IF io_annotation IS NOT BOUND.
      RETURN.
    ENDIF.
    lt_annotations = io_annotation->get_all( ).
    LOOP AT lt_annotations INTO ls_annotation.
      lv_key = ls_annotation-key.
      READ TABLE it_builtin WITH KEY table_line = lv_key TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        CONTINUE.
      ENDIF.
      rv_xml = rv_xml && | sap:{ lv_key }="{ ls_annotation-value }"|.
    ENDLOOP.
  ENDMETHOD.

  METHOD property_xml.
    DATA lv_facets  TYPE string.
    DATA lv_semantics TYPE string.
    DATA lv_label   TYPE string.
    DATA lt_builtin TYPE string_table.

* label: an explicit one (CDS @EndUserText.label via SADL), else the ABAP
* field name, which is what SEGW puts into the text element by default
    lv_label = io_property->mv_label.
    IF lv_label IS INITIAL.
      lv_label = io_property->mv_abap_fieldname.
    ENDIF.
    IF io_property->mv_complex_type IS NOT INITIAL.
      rv_xml = |        <Property Name="{ iv_name }" Type="{ iv_namespace }.{ io_property->mv_complex_type }" Nullable="{
        map_boolean( io_property->mv_nullable ) }"/>\n|.
      RETURN.
    ENDIF.
    IF lv_label IS INITIAL.
      lv_label = iv_name.
    ENDIF.
    APPEND 'unicode' TO lt_builtin.
    APPEND 'label' TO lt_builtin.
    APPEND 'creatable' TO lt_builtin.
    APPEND 'updatable' TO lt_builtin.
    APPEND 'sortable' TO lt_builtin.
    APPEND 'filterable' TO lt_builtin.
    APPEND 'semantics' TO lt_builtin.

    CASE io_property->mv_edm_type.
      WHEN /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-string.
        IF io_property->mv_maxlength > 0.
          lv_facets = | MaxLength="{ io_property->mv_maxlength }"|.
        ENDIF.
      WHEN /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-decimal.
* SEGW: set_maxlength = total digits, set_precison = decimal places
        lv_facets = | Precision="{ io_property->mv_maxlength }" Scale="{ io_property->mv_precision }"|.
      WHEN /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-binary.
        IF io_property->mv_maxlength > 0.
          lv_facets = | MaxLength="{ io_property->mv_maxlength }"|.
        ENDIF.
      WHEN /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-datetime
          OR /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-datetimeoffset.
        lv_facets = | Precision="{ io_property->mv_precision }"|.
        IF io_property->mv_display_format IS NOT INITIAL.
          lv_facets = |{ lv_facets } sap:display-format="{ io_property->mv_display_format }"|.
        ENDIF.
      WHEN OTHERS.
        lv_facets = ``.
    ENDCASE.
    IF io_property->mv_etag = abap_true.
      lv_facets = |{ lv_facets } ConcurrencyMode="Fixed"|.
    ENDIF.
    IF io_property->mv_semantic IS NOT INITIAL.
      lv_semantics = | sap:semantics="{ io_property->mv_semantic }"|.
    ENDIF.

    rv_xml =
      |        <Property Name="{ iv_name }" Type="{ io_property->mv_edm_type }" Nullable="{
        map_boolean( io_property->mv_nullable ) }"{ lv_facets } sap:unicode="false" sap:label="{
        lv_label }" sap:creatable="{
        map_boolean( io_property->mv_creatable ) }" sap:updatable="{
        map_boolean( io_property->mv_updatable ) }" sap:sortable="{
        map_boolean( io_property->mv_sortable ) }" sap:filterable="{
        map_boolean( io_property->mv_filterable ) }"{ lv_semantics }{ custom_annotations_xml( io_annotation = io_property->mo_annotation
                                                                                              it_builtin    = lt_builtin ) }/>\n|.
  ENDMETHOD.

  METHOD data.

    DATA lo_dpc             TYPE REF TO /iwbep/if_mgw_appl_srv_runtime.
    DATA lt_filter_option   TYPE /iwbep/t_mgw_select_option.
    DATA ls_paging          TYPE /iwbep/s_mgw_paging.
    DATA lt_key_tab         TYPE /iwbep/t_mgw_name_value_pair.
    DATA lt_navigation_path TYPE /iwbep/t_mgw_navigation_path.
    DATA lt_order           TYPE /iwbep/t_mgw_sorting_order.
    DATA lo_request_context TYPE REF TO /iwbep/if_mgw_req_entityset.
    DATA lr_entityset       TYPE REF TO data.

    FIELD-SYMBOLS <tab> TYPE ANY TABLE.
    FIELD-SYMBOLS <row> TYPE any.

    lo_dpc = zcl_oao_registry=>create_dpc( iv_service ).
    CREATE OBJECT lo_request_context TYPE zcl_oao_request_context
      EXPORTING
        iv_entity_set_name = iv_entity_set.

* todo, query options
    lo_dpc->get_entityset(
      EXPORTING
        iv_entity_name           = iv_entity_set
        iv_entity_set_name       = iv_entity_set
        iv_source_name           = ''
        it_filter_select_options = lt_filter_option
        is_paging                = ls_paging
        it_key_tab               = lt_key_tab
        it_navigation_path       = lt_navigation_path
        it_order                 = lt_order
        iv_filter_string         = ''
        iv_search_string         = ''
        io_tech_request_context  = lo_request_context
      IMPORTING
        er_entityset             = lr_entityset ).

    ASSIGN lr_entityset->* TO <tab> ##SUBRC_OK.

    rv_json = `{` && |\n| &&
      `  "d" : {` && |\n| &&
      `    "results" : [` && |\n|.

    LOOP AT <tab> ASSIGNING <row>.
* todo
      rv_json = rv_json &&
        `      {` && |\n| &&
        `        "__metadata" : {` && |\n| &&
        `          "id" : "http://localhost:3030/sap/opu/odata/sap/ZSEGW_SRV/zsegwSet('HELLO')",` && |\n| &&
        `          "uri" : "http://localhost:3030/sap/opu/odata/sap/ZSEGW_SRV/zsegwSet('HELLO')",` && |\n| &&
        `          "type" : "ZSEGW_SRV.zsegw"` && |\n| &&
        `        },` && |\n| &&
        `        "Something1" : "HELLO",` && |\n| &&
        `        "Something2" : "WORLD"` && |\n| &&
        `      }` && |\n|.
    ENDLOOP.

    rv_json = rv_json &&
      `    ]` && |\n| &&
      `  }` && |\n| &&
      `}`.

  ENDMETHOD.

  METHOD metadata.

    DATA lo_mpc          TYPE REF TO /iwbep/cl_mgw_push_abs_model.
    DATA lo_model        TYPE REF TO zcl_oao_model.
    DATA lv_namespace    TYPE string.
    DATA lt_entity_types TYPE zcl_oao_model=>ty_entity_names.
    DATA lv_entity_type  LIKE LINE OF lt_entity_types.
    DATA lo_entity       TYPE REF TO zcl_oao_entity_typ.
    DATA lt_properties   TYPE /iwbep/if_mgw_med_odata_types=>ty_t_mgw_odata_properties.
    DATA ls_property     LIKE LINE OF lt_properties.
    DATA lo_property     TYPE REF TO zcl_oao_property.
    DATA lt_entity_sets  TYPE zcl_oao_entity_typ=>ty_entity_sets.
    DATA ls_entity_set   LIKE LINE OF lt_entity_sets.
    DATA lv_sets_xml     TYPE string.
    DATA lv_searchable TYPE string.
    DATA lt_nav_props    TYPE zcl_oao_entity_typ=>ty_nav_props.
    DATA lo_nav          TYPE REF TO zcl_oao_nav_prop.
    DATA lt_associations TYPE zcl_oao_model=>ty_associations.
    DATA lo_association  TYPE REF TO zcl_oao_association.
    DATA lt_assoc_sets   TYPE zcl_oao_model=>ty_assoc_sets.
    DATA lo_assoc_set    TYPE REF TO zcl_oao_assoc_set.
    DATA lv_from_role    TYPE string.
    DATA lv_to_role      TYPE string.
    DATA lt_actions      TYPE zcl_oao_model=>ty_actions.
    DATA lo_action       TYPE REF TO zcl_oao_action.
    DATA lt_set_builtin  TYPE string_table.
    DATA lt_type_builtin TYPE string_table.
    DATA lt_vocabulary   TYPE string_table.
    DATA lv_vocabulary   TYPE string.

    lo_mpc = zcl_oao_registry=>create_mpc( iv_service ).
    lo_mpc->define( ).
    lo_model ?= lo_mpc->model.
    lo_model->/iwbep/if_mgw_odata_model~get_schema_namespace( IMPORTING ev_namespace = lv_namespace ).
    lt_entity_types = lo_model->get_entity_type_names( ).
    lt_associations = lo_model->get_associations( ).
    lt_assoc_sets   = lo_model->get_association_sets( ).
    lt_actions      = lo_model->get_actions( ).
    lt_vocabulary   = lo_model->get_vocabulary_xml( ).
    APPEND 'creatable' TO lt_set_builtin.
    APPEND 'updatable' TO lt_set_builtin.
    APPEND 'deletable' TO lt_set_builtin.
    APPEND 'pageable' TO lt_set_builtin.
    APPEND 'content-version' TO lt_set_builtin.
    APPEND 'content-version' TO lt_type_builtin.

    rv_xml =
      |<?xml version="1.0" encoding="utf-8"?>\n| &&
      |<edmx:Edmx xmlns:edmx="http://schemas.microsoft.com/ado/2007/06/edmx" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns:sap="http://www.sap.com/Protocols/SAPData" Version="1.0">\n| &&
      |  <edmx:DataServices m:DataServiceVersion="2.0">\n| &&
      |    <Schema xmlns="http://schemas.microsoft.com/ado/2008/09/edm" Namespace="{ lv_namespace }" xml:lang="en" sap:schema-version="1">\n| &&
      |      <Annotation xmlns="http://docs.oasis-open.org/odata/ns/edm" Term="Core.SchemaVersion" String="1.0.0"/>\n|.
    LOOP AT lt_entity_types INTO lv_entity_type.
      lo_entity ?= lo_model->/iwbep/if_mgw_odata_model~get_entity_type( lv_entity_type ).
      lt_properties = lo_entity->/iwbep/if_mgw_odata_entity_typ~get_properties( ).

      rv_xml = rv_xml &&
        |      <EntityType Name="{ lv_entity_type }"{ custom_annotations_xml( io_annotation = lo_entity->mo_annotation
                                                                              it_builtin    = lt_type_builtin ) } sap:content-version="1">\n| &&
        |        <Key>\n|.
      LOOP AT lt_properties INTO ls_property.
        lo_property ?= ls_property-property.
        IF lo_property->mv_is_key = abap_true.
          rv_xml = rv_xml && |          <PropertyRef Name="{ ls_property-name }"/>\n|.
        ENDIF.
      ENDLOOP.
      rv_xml = rv_xml && |        </Key>\n|.

      LOOP AT lt_properties INTO ls_property.
        lo_property ?= ls_property-property.
        rv_xml = rv_xml && property_xml( iv_name      = ls_property-name
                                         io_property  = lo_property
                                         iv_namespace = lv_namespace ).
      ENDLOOP.

      lt_nav_props = lo_entity->get_navigation_properties( ).
      LOOP AT lt_nav_props INTO lo_nav.
* the navigation starts on the side of the association this type is on
        lv_from_role = |FromRole_{ lo_nav->mv_association }|.
        lv_to_role   = |ToRole_{ lo_nav->mv_association }|.
        LOOP AT lt_associations INTO lo_association.
          IF lo_association->mv_name = lo_nav->mv_association AND lo_association->mv_right_type = lv_entity_type
              AND lo_association->mv_left_type <> lv_entity_type.
            lv_from_role = |ToRole_{ lo_nav->mv_association }|.
            lv_to_role   = |FromRole_{ lo_nav->mv_association }|.
          ENDIF.
        ENDLOOP.
        rv_xml = rv_xml &&
          |        <NavigationProperty Name="{ lo_nav->mv_name }" Relationship="{ lv_namespace }.{ lo_nav->mv_association }" FromRole="{ lv_from_role }" ToRole="{ lv_to_role }"/>\n|.
      ENDLOOP.
      rv_xml = rv_xml && |      </EntityType>\n|.

      lt_entity_sets = lo_entity->get_entity_sets( ).
      LOOP AT lt_entity_sets INTO ls_entity_set.
        lv_searchable = searchable_xml( ls_entity_set-entity_set ).
        lv_sets_xml = lv_sets_xml &&
          |        <EntitySet Name="{ ls_entity_set-name }" EntityType="{ lv_namespace }.{ lv_entity_type }" sap:creatable="{
            map_boolean( ls_entity_set-entity_set->mv_creatable ) }" sap:updatable="{
            map_boolean( ls_entity_set-entity_set->mv_updatable ) }" sap:deletable="{
            map_boolean( ls_entity_set-entity_set->mv_deletable ) }" sap:pageable="{
            map_boolean( ls_entity_set-entity_set->mv_pageable ) }"{ lv_searchable }{ custom_annotations_xml( io_annotation = ls_entity_set-entity_set->mo_annotation
                                                                                                              it_builtin    = lt_set_builtin ) } sap:content-version="1"/>\n|.
      ENDLOOP.
    ENDLOOP.
    rv_xml = rv_xml && complex_types_xml( io_model     = lo_model
                                          iv_namespace = lv_namespace ).

    LOOP AT lt_associations INTO lo_association.
      rv_xml = rv_xml && association_xml( io_association = lo_association
                                          iv_namespace   = lv_namespace ).
    ENDLOOP.

    LOOP AT lt_actions INTO lo_action.
      lv_sets_xml = lv_sets_xml && function_import_xml( io_action    = lo_action
                                                        iv_namespace = lv_namespace ).
    ENDLOOP.

    LOOP AT lt_assoc_sets INTO lo_assoc_set.
      lv_sets_xml = lv_sets_xml &&
        |        <AssociationSet Name="{ lo_assoc_set->mv_name }" Association="{ lv_namespace }.{ lo_assoc_set->mv_association }" sap:creatable="false" sap:updatable="false" sap:deletable="false" sap:content-version="1">\n| &&
        |          <End EntitySet="{ lo_assoc_set->mv_left_set }" Role="FromRole_{ lo_assoc_set->mv_association }"/>\n| &&
        |          <End EntitySet="{ lo_assoc_set->mv_right_set }" Role="ToRole_{ lo_assoc_set->mv_association }"/>\n| &&
        |        </AssociationSet>\n|.
    ENDLOOP.

    rv_xml = rv_xml &&
      |      <EntityContainer Name="{ lv_namespace }_Entities" m:IsDefaultEntityContainer="true" sap:supported-formats="json">\n| &&
      lv_sets_xml &&
      |      </EntityContainer>\n|.
    LOOP AT lt_vocabulary INTO lv_vocabulary.
      rv_xml = rv_xml && lv_vocabulary.
    ENDLOOP.
    rv_xml = rv_xml &&
      |      <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="self" href="{ gc_host }/sap/opu/odata/sap/{ lv_namespace }/$metadata"/>\n| &&
      |      <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="latest-version" href="{ gc_host }/sap/opu/odata/sap/{ lv_namespace }/$metadata"/>\n| &&
      |    </Schema>\n| &&
      |  </edmx:DataServices>\n| &&
      |</edmx:Edmx>|.

  ENDMETHOD.

ENDCLASS.

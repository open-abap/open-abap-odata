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

  METHOD property_xml.
    DATA lv_facets TYPE string.
    DATA lv_label  TYPE string.

* label: the text pool is not available off-system, the ABAP field name is
* what SEGW puts into the text element by default
    lv_label = io_property->mv_abap_fieldname.
    IF lv_label IS INITIAL.
      lv_label = iv_name.
    ENDIF.

    CASE io_property->mv_edm_type.
      WHEN /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-string.
        IF io_property->mv_maxlength > 0.
          lv_facets = | MaxLength="{ io_property->mv_maxlength }"|.
        ENDIF.
      WHEN /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-decimal.
* SEGW: set_maxlength = total digits, set_precison = decimal places
        lv_facets = | Precision="{ io_property->mv_maxlength }" Scale="{ io_property->mv_precision }"|.
      WHEN /iwbep/if_mgw_med_odata_types=>gcs_edm_data_types-datetime.
        lv_facets = | Precision="{ io_property->mv_precision }"|.
      WHEN OTHERS.
        lv_facets = ``.
    ENDCASE.

    rv_xml =
      |        <Property Name="{ iv_name }" Type="{ io_property->mv_edm_type }" Nullable="{
        map_boolean( io_property->mv_nullable ) }"{ lv_facets } sap:unicode="false" sap:label="{
        lv_label }" sap:creatable="{
        map_boolean( io_property->mv_creatable ) }" sap:updatable="{
        map_boolean( io_property->mv_updatable ) }" sap:sortable="{
        map_boolean( io_property->mv_sortable ) }" sap:filterable="{
        map_boolean( io_property->mv_filterable ) }"/>\n|.
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

    lo_mpc = zcl_oao_registry=>create_mpc( iv_service ).
    lo_mpc->define( ).
    lo_model ?= lo_mpc->model.
    lo_model->/iwbep/if_mgw_odata_model~get_schema_namespace( IMPORTING ev_namespace = lv_namespace ).
    lt_entity_types = lo_model->get_entity_type_names( ).

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
        |      <EntityType Name="{ lv_entity_type }" sap:content-version="1">\n| &&
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
        rv_xml = rv_xml && property_xml( iv_name     = ls_property-name
                                         io_property = lo_property ).
      ENDLOOP.
      rv_xml = rv_xml && |      </EntityType>\n|.

      lt_entity_sets = lo_entity->get_entity_sets( ).
      LOOP AT lt_entity_sets INTO ls_entity_set.
        lv_sets_xml = lv_sets_xml &&
          |        <EntitySet Name="{ ls_entity_set-name }" EntityType="{ lv_namespace }.{ lv_entity_type }" sap:creatable="{
            map_boolean( ls_entity_set-entity_set->mv_creatable ) }" sap:updatable="{
            map_boolean( ls_entity_set-entity_set->mv_updatable ) }" sap:deletable="{
            map_boolean( ls_entity_set-entity_set->mv_deletable ) }" sap:pageable="{
            map_boolean( ls_entity_set-entity_set->mv_pageable ) }" sap:content-version="1"/>\n|.
      ENDLOOP.
    ENDLOOP.

    rv_xml = rv_xml &&
      |      <EntityContainer Name="{ lv_namespace }_Entities" m:IsDefaultEntityContainer="true" sap:supported-formats="json">\n| &&
      lv_sets_xml &&
      |      </EntityContainer>\n| &&
      |      <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="self" href="{ gc_host }/sap/opu/odata/sap/{ lv_namespace }/$metadata"/>\n| &&
      |      <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="latest-version" href="{ gc_host }/sap/opu/odata/sap/{ lv_namespace }/$metadata"/>\n| &&
      |    </Schema>\n| &&
      |  </edmx:DataServices>\n| &&
      |</edmx:Edmx>|.

  ENDMETHOD.

ENDCLASS.

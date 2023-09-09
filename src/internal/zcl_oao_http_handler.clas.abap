CLASS zcl_oao_http_handler DEFINITION PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_data,
             content_type TYPE string,
             data         TYPE string,
           END OF ty_data.

    CLASS-METHODS handle
      IMPORTING iv_path TYPE string
      RETURNING VALUE(rs_data) TYPE ty_data
      RAISING cx_static_check.

  PRIVATE SECTION.
    CONSTANTS gc_host TYPE string VALUE 'http://localhost:8080'.

    CLASS-METHODS metadata
      RETURNING
        VALUE(rv_xml) TYPE string
      RAISING
        /iwbep/cx_mgw_med_exception.

    CLASS-METHODS data
      RETURNING
        VALUE(rv_json) TYPE string
      RAISING
        /iwbep/cx_mgw_busi_exception
        /iwbep/cx_mgw_tech_exception.

    CLASS-METHODS map_boolean
      IMPORTING iv_boolean TYPE abap_bool
      RETURNING VALUE(rv_string) TYPE string.
ENDCLASS.

CLASS zcl_oao_http_handler IMPLEMENTATION.

  METHOD handle.

* todo,
    IF iv_path CP '*$metadata'.
      rs_data-content_type = 'text/xml'.
      rs_data-data = metadata( ).
    ELSE.
      rs_data-content_type = 'application/json'.
      rs_data-data = data( ).
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

  METHOD data.

    DATA lo_dpc             TYPE REF TO zcl_zsegw_dpc_ext.
    DATA lt_filter_option   TYPE /iwbep/t_mgw_select_option.
    DATA ls_paging          TYPE /iwbep/s_mgw_paging.
    DATA lt_key_tab         TYPE /iwbep/t_mgw_name_value_pair.
    DATA lt_navigation_path TYPE /iwbep/t_mgw_navigation_path.
    DATA lt_order           TYPE /iwbep/t_mgw_sorting_order.
    DATA lo_request_context TYPE REF TO /iwbep/if_mgw_req_entityset.

    CREATE OBJECT lo_dpc.
    CREATE OBJECT lo_request_context TYPE zcl_oao_request_context.

* todo,
    lo_dpc->/iwbep/if_mgw_appl_srv_runtime~get_entityset(
      iv_entity_name           = 'zsegwSet'
      iv_entity_set_name       = ''
      iv_source_name           = ''
      it_filter_select_options = lt_filter_option
      is_paging                = ls_paging
      it_key_tab               = lt_key_tab
      it_navigation_path       = lt_navigation_path
      it_order                 = lt_order
      iv_filter_string         = ''
      iv_search_string         = ''
      io_tech_request_context  = lo_request_context ).

* todo
    rv_json = `{` && |\n| &&
      `  "d" : {` && |\n| &&
      `    "results" : [` && |\n| &&
      `      {` && |\n| &&
      `        "__metadata" : {` && |\n| &&
      `          "id" : "http://localhost:3030/sap/opu/odata/sap/ZSEGW_SRV/zsegwSet('HELLO')",` && |\n| &&
      `          "uri" : "http://localhost:3030/sap/opu/odata/sap/ZSEGW_SRV/zsegwSet('HELLO')",` && |\n| &&
      `          "type" : "ZSEGW_SRV.zsegw"` && |\n| &&
      `        },` && |\n| &&
      `        "Something1" : "HELLO",` && |\n| &&
      `        "Something2" : "WORLD"` && |\n| &&
      `      }` && |\n| &&
      `    ]` && |\n| &&
      `  }` && |\n| &&
      `}`.

  ENDMETHOD.

  METHOD metadata.

    DATA mpc             TYPE REF TO zcl_zsegw_mpc_ext.
    DATA lv_namespace    TYPE string.
    DATA lt_entity_types TYPE STANDARD TABLE OF /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name WITH DEFAULT KEY.
    DATA lv_entity_type  LIKE LINE OF lt_entity_types.
    DATA lo_entity       TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
    DATA lt_properties   TYPE /iwbep/if_mgw_med_odata_types=>ty_t_mgw_odata_properties.
    DATA ls_property     LIKE LINE OF lt_properties.
    DATA lo_property     TYPE REF TO zcl_oao_property.

    INSERT zcl_zsegw_mpc_ext=>gc_zsegw INTO TABLE lt_entity_types.

    CREATE OBJECT mpc.
    mpc->define( ).
    mpc->model->get_schema_namespace( IMPORTING ev_namespace = lv_namespace ).

    rv_xml =
      |<?xml version="1.0" encoding="utf-8"?>\n| &&
      |<edmx:Edmx xmlns:edmx="http://schemas.microsoft.com/ado/2007/06/edmx" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns:sap="http://www.sap.com/Protocols/SAPData" Version="1.0">\n| &&
      |  <edmx:DataServices m:DataServiceVersion="2.0">\n| &&
      |    <Schema xmlns="http://schemas.microsoft.com/ado/2008/09/edm" Namespace="{ lv_namespace }" xml:lang="en" sap:schema-version="1">\n| &&
      |      <Annotation xmlns="http://docs.oasis-open.org/odata/ns/edm" Term="Core.SchemaVersion" String="1.0.0"/>\n|.
    LOOP AT lt_entity_types INTO lv_entity_type.
      lo_entity = mpc->model->get_entity_type( lv_entity_type ).
* todo,
      rv_xml = rv_xml &&
        |      <EntityType Name="{ lv_entity_type }" sap:content-version="1">\n| &&
        |        <Key>\n| &&
        |          <PropertyRef Name="Something1"/>\n| &&
        |        </Key>\n|.
      lt_properties = lo_entity->get_properties( ).
      LOOP AT lt_properties INTO ls_property.
        lo_property ?= ls_property-property.
        rv_xml = rv_xml &&
          |        <Property Name="{ ls_property-name }" Type="{
            lo_property->mv_edm_type }" Nullable="{
            map_boolean( lo_property->mv_nullable ) }" MaxLength="{
            lo_property->mv_maxlength }" sap:unicode="false" sap:label="todo" sap:creatable="{
            map_boolean( lo_property->mv_creatable ) }" sap:updatable="{
            map_boolean( lo_property->mv_updatable ) }" sap:sortable="{
            map_boolean( lo_property->mv_sortable ) }" sap:filterable="{
            map_boolean( lo_property->mv_filterable ) }"/>\n|.
      ENDLOOP.
      rv_xml = rv_xml && |      </EntityType>\n|.
    ENDLOOP.
* todo,
    rv_xml = rv_xml &&
      |      <EntityContainer Name="{ lv_namespace }_Entities" m:IsDefaultEntityContainer="true" sap:supported-formats="json">\n| &&
      |        <EntitySet Name="zsegwSet" EntityType="{ lv_namespace }.zsegw" sap:creatable="false" sap:updatable="false" sap:deletable="false" sap:pageable="false" sap:content-version="1"/>\n| &&
      |      </EntityContainer>\n| &&
      |      <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="self" href="{ gc_host }/sap/opu/odata/sap/{ lv_namespace }/$metadata"/>\n| &&
      |      <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="latest-version" href="{ gc_host }/sap/opu/odata/sap/{ lv_namespace }/$metadata"/>\n| &&
      |    </Schema>\n| &&
      |  </edmx:DataServices>\n| &&
      |</edmx:Edmx>|.

  ENDMETHOD.

ENDCLASS.
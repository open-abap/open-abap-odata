CLASS /iwfnd/cl_sodata_http_handler DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_http_extension.
  PRIVATE SECTION.
    METHODS metadata
      RETURNING VALUE(rv_xml) TYPE string
      RAISING /iwbep/cx_mgw_med_exception.
    METHODS map_boolean
      IMPORTING iv_boolean TYPE abap_bool
      RETURNING VALUE(rv_string) TYPE string.
ENDCLASS.

CLASS /iwfnd/cl_sodata_http_handler IMPLEMENTATION.

  METHOD if_http_extension~handle_request.
    DATA lv_xml TYPE string.

    TRY.
        lv_xml = metadata( ).
      CATCH /iwbep/cx_mgw_med_exception.
        WRITE / 'exception'.
    ENDTRY.

    server->response->set_header_field(
      name  = 'content-type'
      value = 'text/xml' ).
    server->response->set_cdata( lv_xml ).
    server->response->set_status(
      code   = 200
      reason = 'Success' ).

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

  METHOD metadata.
    CONSTANTS lc_host    TYPE string VALUE 'http://localhost:8080'.

    DATA mpc             TYPE REF TO zcl_zsegw_mpc_ext.
    DATA lv_namespace    TYPE string.
    DATA lt_entity_types TYPE STANDARD TABLE OF /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name WITH DEFAULT KEY.
    DATA lv_entity_type  LIKE LINE OF lt_entity_types.
    DATA lo_entity       TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
    DATA lt_properties   TYPE /iwbep/if_mgw_med_odata_types=>ty_t_mgw_odata_properties.
    DATA ls_property     LIKE LINE OF lt_properties.
    DATA lo_property     TYPE REF TO zcl_property.

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
    rv_xml = rv_xml &&
      |      <EntityContainer Name="{ lv_namespace }_Entities" m:IsDefaultEntityContainer="true" sap:supported-formats="json">\n| &&
      |        <EntitySet Name="zsegwSet" EntityType="{ lv_namespace }.zsegw" sap:creatable="false" sap:updatable="false" sap:deletable="false" sap:pageable="false" sap:content-version="1"/>\n| &&
      |      </EntityContainer>\n| &&
      |      <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="self" href="{ lc_host }/sap/opu/odata/sap/{ lv_namespace }/$metadata"/>\n| &&
      |      <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="latest-version" href="{ lc_host }/sap/opu/odata/sap/{ lv_namespace }/$metadata"/>\n| &&
      |    </Schema>\n| &&
      |  </edmx:DataServices>\n| &&
      |</edmx:Edmx>|.

  ENDMETHOD.

ENDCLASS.
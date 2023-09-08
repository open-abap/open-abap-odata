CLASS /iwfnd/cl_sodata_http_handler DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_http_extension.
  PRIVATE SECTION.
    METHODS metadata
      RETURNING VALUE(rv_xml) TYPE string
      RAISING /iwbep/cx_mgw_med_exception.
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

  METHOD metadata.
    CONSTANTS lc_host TYPE string VALUE 'http://localhost:8080'.
    DATA mpc TYPE REF TO zcl_zsegw_mpc_ext.
    DATA lv_namespace TYPE string.

    CREATE OBJECT mpc.
    mpc->define( ).
    mpc->model->get_entity_type( zcl_zsegw_mpc_ext=>gc_zsegw ).
    mpc->model->get_schema_namespace( IMPORTING ev_namespace = lv_namespace ).

    rv_xml =
      |<?xml version="1.0" encoding="utf-8"?>\n| &&
      |<edmx:Edmx xmlns:edmx="http://schemas.microsoft.com/ado/2007/06/edmx" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns:sap="http://www.sap.com/Protocols/SAPData" Version="1.0">\n| &&
      |  <edmx:DataServices m:DataServiceVersion="2.0">\n| &&
      |    <Schema xmlns="http://schemas.microsoft.com/ado/2008/09/edm" Namespace="{ lv_namespace }" xml:lang="en" sap:schema-version="1">\n| &&
      |      <Annotation xmlns="http://docs.oasis-open.org/odata/ns/edm" Term="Core.SchemaVersion" String="1.0.0"/>\n| &&
      |      <EntityType Name="zsegw" sap:content-version="1">\n| &&
      |        <Key>\n| &&
      |          <PropertyRef Name="Something1"/>\n| &&
      |        </Key>\n| &&
      |        <Property Name="Something1" Type="Edm.String" Nullable="false" MaxLength="10" sap:unicode="false" sap:label="SOMETHING1" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false"/>\n| &&
      |        <Property Name="Something2" Type="Edm.String" Nullable="false" MaxLength="10" sap:unicode="false" sap:label="SOMETHING2" sap:creatable="false" sap:updatable="false" sap:sortable="false" sap:filterable="false"/>\n| &&
      |      </EntityType>\n| &&
      |      <EntityContainer Name="{ lv_namespace }_Entities" m:IsDefaultEntityContainer="true" sap:supported-formats="atom json xlsx">\n| &&
      |        <EntitySet Name="zsegwSet" EntityType="{ lv_namespace }.zsegw" sap:creatable="false" sap:updatable="false" sap:deletable="false" sap:pageable="false" sap:content-version="1"/>\n| &&
      |      </EntityContainer>\n| &&
      |      <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="self" href="{ lc_host }/sap/opu/odata/sap/{ lv_namespace }/$metadata"/>\n| &&
      |      <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="latest-version" href="{ lc_host }/sap/opu/odata/sap/{ lv_namespace }/$metadata"/>\n| &&
      |    </Schema>\n| &&
      |  </edmx:DataServices>\n| &&
      |</edmx:Edmx>|.

  ENDMETHOD.

ENDCLASS.
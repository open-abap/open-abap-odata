CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS setup.
    METHODS test FOR TESTING RAISING cx_static_check.
    METHODS metadata_via_registry FOR TESTING RAISING cx_static_check.
    METHODS data_via_registry FOR TESTING RAISING cx_static_check.
    METHODS unknown_service FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.
  METHOD setup.
    zcl_oao_registry=>clear( ).
    zcl_oao_registry=>register(
      iv_service = 'ZSEGW_SRV'
      iv_mpc     = 'ZCL_ZSEGW_MPC_EXT'
      iv_dpc     = 'ZCL_ZSEGW_DPC_EXT' ).
  ENDMETHOD.

  METHOD test.
    DATA mpc TYPE REF TO zcl_zsegw_mpc_ext.
    CREATE OBJECT mpc.

    mpc->define( ).
    mpc->model->get_entity_type( zcl_zsegw_mpc_ext=>gc_zsegw ).
  ENDMETHOD.

  METHOD metadata_via_registry.
    DATA ls_data TYPE zcl_oao_http_handler=>ty_data.

    ls_data = zcl_oao_http_handler=>handle( '/sap/opu/odata/sap/ZSEGW_SRV/$metadata' ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_data-content_type
      exp = 'text/xml' ).
    cl_abap_unit_assert=>assert_true( boolc( ls_data-data CS '<EntityType Name="zsegw"' ) ).
    cl_abap_unit_assert=>assert_true( boolc( ls_data-data CS '<PropertyRef Name="Something1"/>' ) ).
    cl_abap_unit_assert=>assert_true( boolc( ls_data-data CS '<EntitySet Name="zsegwSet" EntityType="ZSEGW_SRV.zsegw"' ) ).
  ENDMETHOD.

  METHOD data_via_registry.
    DATA ls_data TYPE zcl_oao_http_handler=>ty_data.

    ls_data = zcl_oao_http_handler=>handle( '/sap/opu/odata/sap/ZSEGW_SRV/zsegwSet?$format=json' ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_data-content_type
      exp = 'application/json' ).
    cl_abap_unit_assert=>assert_true( boolc( ls_data-data CS '"Something1" : "HELLO"' ) ).
  ENDMETHOD.

  METHOD unknown_service.
    TRY.
        zcl_oao_http_handler=>handle( '/sap/opu/odata/sap/NOT_REGISTERED/$metadata' ).
        cl_abap_unit_assert=>fail( 'expected /iwbep/cx_mgw_tech_exception' ).
      CATCH /iwbep/cx_mgw_tech_exception.
        RETURN.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.

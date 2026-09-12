CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS setup.
    METHODS test FOR TESTING RAISING cx_static_check.
    METHODS metadata_via_registry FOR TESTING RAISING cx_static_check.
    METHODS data_via_registry FOR TESTING RAISING cx_static_check.
    METHODS unknown_service FOR TESTING RAISING cx_static_check.
    METHODS edm_types FOR TESTING RAISING cx_static_check.
    METHODS date_display_format FOR TESTING RAISING cx_static_check.
    METHODS associations FOR TESTING RAISING cx_static_check.
    METHODS actions FOR TESTING RAISING cx_static_check.
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

  METHOD date_display_format.
* bind_structure looks at the bound structure: a DATS field behind an
* Edm.DateTime is printed with sap:display-format="Date", as the Gateway does
    DATA lo_model    TYPE REF TO /iwbep/if_mgw_odata_model.
    DATA lo_entity   TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
    DATA lo_property TYPE REF TO /iwbep/if_mgw_odata_property.
    DATA lo_oao      TYPE REF TO zcl_oao_property.
    DATA lv_xml      TYPE string.

    CREATE OBJECT lo_model TYPE zcl_oao_model.
    lo_entity = lo_model->create_entity_type( 'Dated' ).
    lo_property = lo_entity->create_property( iv_property_name  = 'Id'
                                              iv_abap_fieldname = 'ID' ).
    lo_property->set_type_edm_string( ).
    lo_property = lo_entity->create_property( iv_property_name  = 'When'
                                              iv_abap_fieldname = 'WHEN' ).
    lo_property->set_type_edm_datetime( ).
    lo_entity->bind_structure( 'ZCL_ZSEGW_MPC=>TS_DATED' ).

    lo_oao ?= lo_entity->get_property( 'When' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_display_format
                                        exp = 'Date' ).
    lv_xml = zcl_oao_http_handler=>property_xml( iv_name     = 'When'
                                                 io_property = lo_oao ).
    FIND 'sap:display-format="Date"' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).

    lo_oao ?= lo_entity->get_property( 'Id' ).
    cl_abap_unit_assert=>assert_initial( lo_oao->mv_display_format ).
  ENDMETHOD.

  METHOD edm_types.
    DATA lo_model    TYPE REF TO /iwbep/if_mgw_odata_model.
    DATA lo_entity   TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
    DATA lo_property TYPE REF TO /iwbep/if_mgw_odata_property.
    DATA lo_oao      TYPE REF TO zcl_oao_property.
    DATA lv_xml      TYPE string.

    CREATE OBJECT lo_model TYPE zcl_oao_model.
    lo_entity = lo_model->create_entity_type( 'Thing' ).

    lo_property = lo_entity->create_property( iv_property_name  = 'Amount'
                                              iv_abap_fieldname = 'AMOUNT' ).
    lo_property->set_type_edm_decimal( ).
    lo_property->set_precison( 3 ).
    lo_property->set_maxlength( 16 ).
    lo_property->set_conversion_exit( 'ALPHA' ).
    lo_property->disable_conversion( ).

    lo_oao ?= lo_entity->get_property( 'Amount' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_edm_type
                                        exp = 'Edm.Decimal' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_precision
                                        exp = 3 ).
    lv_xml = zcl_oao_http_handler=>property_xml( iv_name     = 'Amount'
                                                 io_property = lo_oao ).
    FIND 'Type="Edm.Decimal"' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).
    FIND 'Precision="16" Scale="3"' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_conv_exit
                                        exp = 'ALPHA' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_conversion
                                        exp = abap_false ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_abap_fieldname
                                        exp = 'AMOUNT' ).

    lo_property = lo_entity->create_property( 'Count' ).
    lo_property->set_type_edm_int32( ).
    lo_property = lo_entity->create_property( 'Flag' ).
    lo_property->set_type_edm_boolean( ).
    lo_property = lo_entity->create_property( 'When' ).
    lo_property->set_type_edm_datetime( ).
    lo_property = lo_entity->create_property( 'At' ).
    lo_property->set_type_edm_time( ).
    lo_property = lo_entity->create_property( 'Small' ).
    lo_property->set_type_edm_int16( ).
    lo_property = lo_entity->create_property( 'Raw' ).
    lo_property->set_type_edm_byte( ).
    lo_property->set_as_content_type( ).

    lo_oao ?= lo_entity->get_property( 'Raw' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_edm_type
                                        exp = 'Edm.Byte' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_content_type
                                        exp = abap_true ).
  ENDMETHOD.

  METHOD associations.
    DATA lo_model    TYPE REF TO zcl_oao_model.
    DATA lo_intf     TYPE REF TO /iwbep/if_mgw_odata_model.
    DATA lo_head     TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
    DATA lo_item     TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
    DATA lo_assoc    TYPE REF TO /iwbep/if_mgw_odata_assoc.
    DATA lo_ref      TYPE REF TO /iwbep/if_mgw_odata_ref_constr.
    DATA lo_oao_head TYPE REF TO zcl_oao_entity_typ.
    DATA lt_navs     TYPE zcl_oao_entity_typ=>ty_nav_props.
    DATA lo_nav      TYPE REF TO zcl_oao_nav_prop.
    DATA lt_assocs   TYPE zcl_oao_model=>ty_associations.
    DATA lo_oao_asc  TYPE REF TO zcl_oao_association.

    CREATE OBJECT lo_model.
    lo_intf = lo_model.
    lo_head = lo_intf->create_entity_type( 'Head' ).
    lo_item = lo_intf->create_entity_type( 'Item' ).
    lo_assoc = lo_intf->create_association( iv_association_name = 'HeadToItems'
                                            iv_left_type        = 'Head'
                                            iv_right_type       = 'Item'
                                            iv_left_card        = '1'
                                            iv_right_card       = 'N'
                                            iv_def_assoc_set    = abap_false ).
    lo_ref = lo_assoc->create_ref_constraint( ).
    lo_ref->add_property( iv_principal_property = 'Id'
                          iv_dependent_property = 'HeadId' ).
    lo_intf->create_association_set( iv_association_set_name  = 'HeadToItemsSet'
                                     iv_left_entity_set_name  = 'HeadSet'
                                     iv_right_entity_set_name = 'ItemSet'
                                     iv_association_name      = 'HeadToItems' ).
    lo_head->create_navigation_property( iv_property_name    = 'to_Items'
                                         iv_association_name = 'HeadToItems' ).

    lo_oao_head ?= lo_head.
    lt_navs = lo_oao_head->get_navigation_properties( ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_navs )
                                        exp = 1 ).
    READ TABLE lt_navs INDEX 1 INTO lo_nav.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = lo_nav->mv_association
                                        exp = 'HeadToItems' ).

    lt_assocs = lo_model->get_associations( ).
    READ TABLE lt_assocs INDEX 1 INTO lo_oao_asc.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao_asc->mv_right_card
                                        exp = 'N' ).
    cl_abap_unit_assert=>assert_equals( act = lines( lo_oao_asc->mo_ref_constraint->mt_pairs )
                                        exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lines( lo_model->get_association_sets( ) )
                                        exp = 1 ).
  ENDMETHOD.

  METHOD actions.
    DATA lo_model     TYPE REF TO zcl_oao_model.
    DATA lo_intf      TYPE REF TO /iwbep/if_mgw_odata_model.
    DATA lo_action    TYPE REF TO /iwbep/if_mgw_odata_action.
    DATA lo_parameter TYPE REF TO /iwbep/if_mgw_odata_parameter.
    DATA lt_actions   TYPE zcl_oao_model=>ty_actions.
    DATA lo_oao       TYPE REF TO zcl_oao_action.
    DATA lo_oao_par   TYPE REF TO zcl_oao_parameter.

    CREATE OBJECT lo_model.
    lo_intf = lo_model.
    lo_action = lo_intf->create_action( 'Cancel' ).
    lo_action->set_return_entity_type( 'Head' ).
    lo_action->set_return_entity_set( 'HeadSet' ).
    lo_action->set_http_method( 'POST' ).
    lo_action->set_action_for( 'Head' ).
    lo_parameter = lo_action->create_input_parameter( iv_parameter_name = 'Id'
                                                      iv_abap_fieldname = 'ID' ).
    lo_parameter->set_type_edm_string( ).
    lo_parameter->set_maxlength( 8 ).

    lt_actions = lo_model->get_actions( ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_actions )
                                        exp = 1 ).
    READ TABLE lt_actions INDEX 1 INTO lo_oao.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_http_method
                                        exp = 'POST' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_return_entity_set
                                        exp = 'HeadSet' ).
    READ TABLE lo_oao->mt_parameters INDEX 1 INTO lo_oao_par.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao_par->mv_edm_type
                                        exp = 'Edm.String' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao_par->mv_abap_fieldname
                                        exp = 'ID' ).
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

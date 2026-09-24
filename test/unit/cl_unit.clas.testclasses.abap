* a search help provider an application would register
CLASS ltcl_shlp DEFINITION FOR TESTING.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_sb_gendpc_shlp_data.
ENDCLASS.

CLASS ltcl_shlp IMPLEMENTATION.
  METHOD /iwbep/if_sb_gendpc_shlp_data~get_search_help_values.
    DATA ls_row LIKE LINE OF et_return_list.

    CLEAR: et_return_list, es_message.
    ls_row-record_number = 1.
    ls_row-field_name    = 'STATUS'.
    ls_row-field_value   = 'A'.
    APPEND ls_row TO et_return_list.
    ls_row-field_name    = 'TEXT'.
    ls_row-field_value   = |Active { iv_shlp_name }|.
    APPEND ls_row TO et_return_list.
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS setup.
    METHODS test FOR TESTING RAISING cx_static_check.
    METHODS metadata_via_registry FOR TESTING RAISING cx_static_check.
    METHODS data_via_registry FOR TESTING RAISING cx_static_check.
    METHODS unknown_service FOR TESTING RAISING cx_static_check.
    METHODS edm_types FOR TESTING RAISING cx_static_check.
    METHODS date_display_format FOR TESTING RAISING cx_static_check.
    METHODS label_annotation FOR TESTING RAISING cx_static_check.
    METHODS media_entity FOR TESTING RAISING cx_static_check.
    METHODS associations FOR TESTING RAISING cx_static_check.
    METHODS actions FOR TESTING RAISING cx_static_check.
    METHODS complex_types FOR TESTING RAISING cx_static_check.
    METHODS sb_odata_types FOR TESTING RAISING cx_static_check.
    METHODS logger FOR TESTING RAISING cx_static_check.
    METHODS rfc_save_log_error FOR TESTING RAISING cx_static_check.
    METHODS rfc_save_log_success FOR TESTING RAISING cx_static_check.
    METHODS rfc_exception_handling FOR TESTING RAISING cx_static_check.
    METHODS rfc_local_destination FOR TESTING RAISING cx_static_check.
    METHODS dpc_log_message FOR TESTING RAISING cx_static_check.
    METHODS vocabulary_annotations FOR TESTING RAISING cx_static_check.
    METHODS semantics_and_etag FOR TESTING RAISING cx_static_check.
    METHODS read_after_create_context FOR TESTING RAISING cx_static_check.
    METHODS search_help_runtime FOR TESTING RAISING cx_static_check.
    METHODS mapped_dpc_types FOR TESTING RAISING cx_static_check.
    METHODS shlp_ddic_where FOR TESTING RAISING cx_static_check.
    METHODS shlp_ddic_select FOR TESTING RAISING cx_static_check.
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
* the _EXT annotated the entity type, printed before sap:content-version
    cl_abap_unit_assert=>assert_true( boolc( ls_data-data CS '<EntityType Name="zsegw" sap:label="Segw" sap:content-version="1">' ) ).
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

  METHOD label_annotation.
* SEGW writes the label of the model into the MPC as an annotation of the
* property: create_annotation( 'sap' )->add( iv_key = 'label' ); it wins
* over the field name and is not printed a second time
    DATA lo_model    TYPE REF TO /iwbep/if_mgw_odata_model.
    DATA lo_entity   TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
    DATA lo_property TYPE REF TO /iwbep/if_mgw_odata_property.
    DATA lo_oao      TYPE REF TO zcl_oao_property.
    DATA lv_xml      TYPE string.

    CREATE OBJECT lo_model TYPE zcl_oao_model.
    lo_entity = lo_model->create_entity_type( 'Labelled' ).
    lo_property = lo_entity->create_property( iv_property_name  = 'TravelId'
                                              iv_abap_fieldname = 'TRAVEL_ID' ).
    lo_property->set_type_edm_string( ).
    lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      iv_key   = 'label'
      iv_value = 'Travel' ).
    lo_property = lo_entity->create_property( iv_property_name  = 'Description'
                                              iv_abap_fieldname = 'DESCRIPTION' ).
    lo_property->set_type_edm_string( ).

    lo_oao ?= lo_entity->get_property( 'TravelId' ).
    lv_xml = zcl_oao_http_handler=>property_xml( iv_name     = 'TravelId'
                                                 io_property = lo_oao ).
    FIND 'sap:label="Travel"' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).
    FIND 'sap:label="TRAVEL_ID"' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( exp = 4 ).

    lo_oao ?= lo_entity->get_property( 'Description' ).
    lv_xml = zcl_oao_http_handler=>property_xml( iv_name     = 'Description'
                                                 io_property = lo_oao ).
    FIND 'sap:label="DESCRIPTION"' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).
  ENDMETHOD.

  METHOD media_entity.
* set_is_media in the MPC: the entity type carries m:HasStream in $metadata,
* which is how a v2 client learns that <entity>/$value is there
    DATA lo_model  TYPE REF TO /iwbep/if_mgw_odata_model.
    DATA lo_entity TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
    DATA lo_oao    TYPE REF TO zcl_oao_entity_typ.

    CREATE OBJECT lo_model TYPE zcl_oao_model.
    lo_entity = lo_model->create_entity_type( 'Picture' ).
    lo_oao ?= lo_entity.
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_is_media
                                        exp = abap_false ).
    lo_entity->set_is_media( 'X' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_is_media
                                        exp = abap_true ).
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
    lo_property = lo_entity->create_property( 'Key' ).
    lo_property->set_type_edm_guid( ).
    lo_property = lo_entity->create_property( 'Blob' ).
    lo_property->set_type_edm_binary( ).
    lo_property->set_maxlength( 16 ).
    lo_property = lo_entity->create_property( 'Stamp' ).
    lo_property->set_type_edm_datetimeoffset( ).
    lo_property->set_precison( 7 ).
    lo_property = lo_entity->create_property( 'Big' ).
    lo_property->set_type_edm_int64( ).
    lo_property = lo_entity->create_property( 'Dbl' ).
    lo_property->set_type_edm_double( ).
    lo_property = lo_entity->create_property( 'Sgl' ).
    lo_property->set_type_edm_single( ).
    lo_property = lo_entity->create_property( 'Flt' ).
    lo_property->set_type_edm_float( ).
    lo_property = lo_entity->create_property( 'Tiny' ).
    lo_property->set_type_edm_sbyte( ).

    lo_oao ?= lo_entity->get_property( 'Key' ).
    lv_xml = zcl_oao_http_handler=>property_xml( iv_name     = 'Key'
                                                 io_property = lo_oao ).
    FIND 'Type="Edm.Guid" Nullable="false" sap:unicode' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).
    lo_oao ?= lo_entity->get_property( 'Blob' ).
    lv_xml = zcl_oao_http_handler=>property_xml( iv_name     = 'Blob'
                                                 io_property = lo_oao ).
    FIND 'Type="Edm.Binary" Nullable="false" MaxLength="16"' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).
    lo_oao ?= lo_entity->get_property( 'Stamp' ).
    lv_xml = zcl_oao_http_handler=>property_xml( iv_name     = 'Stamp'
                                                 io_property = lo_oao ).
    FIND 'Type="Edm.DateTimeOffset" Nullable="false" Precision="7"' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).
    lo_oao ?= lo_entity->get_property( 'Big' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_edm_type
                                        exp = 'Edm.Int64' ).
    lo_oao ?= lo_entity->get_property( 'Dbl' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_edm_type
                                        exp = 'Edm.Double' ).
    lo_oao ?= lo_entity->get_property( 'Sgl' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_edm_type
                                        exp = 'Edm.Single' ).
    lo_oao ?= lo_entity->get_property( 'Flt' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_edm_type
                                        exp = 'Edm.Float' ).
    lo_oao ?= lo_entity->get_property( 'Tiny' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_edm_type
                                        exp = 'Edm.SByte' ).
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
    lo_action->bind_input_structure( 'ZCL_ZSEGW_MPC=>TS_CANCEL' ).

    lt_actions = lo_model->get_actions( ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_actions )
                                        exp = 1 ).
    READ TABLE lt_actions INDEX 1 INTO lo_oao.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_http_method
                                        exp = 'POST' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_return_entity_set
                                        exp = 'HeadSet' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_input_structure
                                        exp = 'ZCL_ZSEGW_MPC=>TS_CANCEL' ).
    READ TABLE lo_oao->mt_parameters INDEX 1 INTO lo_oao_par.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao_par->mv_edm_type
                                        exp = 'Edm.String' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao_par->mv_abap_fieldname
                                        exp = 'ID' ).
  ENDMETHOD.

  METHOD complex_types.
* SEGW: model->create_complex_type, properties on it, then an entity type
* property typed by it via create_complex_property
    DATA lo_model    TYPE REF TO zcl_oao_model.
    DATA lo_intf     TYPE REF TO /iwbep/if_mgw_odata_model.
    DATA lo_complex  TYPE REF TO /iwbep/if_mgw_odata_cmplx_type.
    DATA lo_returned TYPE REF TO /iwbep/if_mgw_odata_cmplx_type.
    DATA lo_entity   TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
    DATA lo_property TYPE REF TO /iwbep/if_mgw_odata_property.
    DATA lo_oao      TYPE REF TO zcl_oao_property.
    DATA lt_complex  TYPE zcl_oao_model=>ty_complex_types.
    DATA lv_xml      TYPE string.

    CREATE OBJECT lo_model.
    lo_intf = lo_model.
    lo_complex = lo_intf->create_complex_type( 'Address' ).
    lo_property = lo_complex->create_property( iv_property_name  = 'Street'
                                               iv_abap_fieldname = 'STREET' ).
    lo_property->set_type_edm_string( ).
    lo_property->set_maxlength( 40 ).
    lo_property = lo_complex->create_property( 'City' ).
    lo_property->set_type_edm_string( ).
    lo_complex->bind_structure( 'ZCL_NOT_THERE=>TS_ADDRESS' ).

    lo_entity = lo_intf->create_entity_type( 'Partner' ).
    lo_returned = lo_entity->create_complex_property( iv_property_name     = 'Address'
                                                      iv_complex_type_name = 'Address'
                                                      iv_abap_fieldname    = 'ADDRESS' ).
    cl_abap_unit_assert=>assert_bound( lo_returned ).
    cl_abap_unit_assert=>assert_equals( act = lo_returned
                                        exp = lo_complex ).

    lt_complex = lo_model->get_complex_types( ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_complex )
                                        exp = 1 ).
    lo_oao ?= lo_entity->get_property( 'Address' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_complex_type
                                        exp = 'Address' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_abap_fieldname
                                        exp = 'ADDRESS' ).

    lv_xml = zcl_oao_http_handler=>property_xml( iv_name      = 'Address'
                                                 io_property  = lo_oao
                                                 iv_namespace = 'ZSRV' ).
    cl_abap_unit_assert=>assert_equals( act = lv_xml
                                        exp = |        <Property Name="Address" Type="ZSRV.Address" Nullable="false"/>\n| ).

    lv_xml = zcl_oao_http_handler=>complex_types_xml( io_model     = lo_model
                                                      iv_namespace = 'ZSRV' ).
    FIND '<ComplexType Name="Address">' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).
    FIND '<Property Name="Street" Type="Edm.String" Nullable="false" MaxLength="40"' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).
    FIND '<Property Name="City" Type="Edm.String"' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).
    FIND '</ComplexType>' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).
  ENDMETHOD.

  METHOD sb_odata_types.
* SEGW types an Edm.Int16 property of an unbound entity type as
* /iwbep/sb_odata_ty_int2 in the generated TS_ structures
    DATA lv_int2 TYPE /iwbep/sb_odata_ty_int2.
    lv_int2 = 32767.
    cl_abap_unit_assert=>assert_equals( act = lv_int2
                                        exp = 32767 ).
  ENDMETHOD.

  METHOD semantics_and_etag.
* SEGW: set_semantic( 'email' ) and set_as_etag( ) on a property, printed
* as sap:semantics and ConcurrencyMode="Fixed" like the Gateway does
    DATA lo_model    TYPE REF TO /iwbep/if_mgw_odata_model.
    DATA lo_entity   TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
    DATA lo_property TYPE REF TO /iwbep/if_mgw_odata_property.
    DATA lo_oao      TYPE REF TO zcl_oao_property.
    DATA lv_xml      TYPE string.

    CREATE OBJECT lo_model TYPE zcl_oao_model.
    lo_entity = lo_model->create_entity_type( 'Partner' ).
    lo_property = lo_entity->create_property( 'Email' ).
    lo_property->set_type_edm_string( ).
    lo_property->set_semantic( 'email' ).
    lo_property = lo_entity->create_property( 'Changed' ).
    lo_property->set_type_edm_datetime( ).
    lo_property->set_precison( 7 ).
    lo_property->set_as_etag( ).

    lo_oao ?= lo_entity->get_property( 'Email' ).
    cl_abap_unit_assert=>assert_equals( act = lo_oao->mv_semantic
                                        exp = 'email' ).
    lv_xml = zcl_oao_http_handler=>property_xml( iv_name     = 'Email'
                                                 io_property = lo_oao ).
    FIND 'sap:filterable="false" sap:semantics="email"/>' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).

    lo_oao ?= lo_entity->get_property( 'Changed' ).
    cl_abap_unit_assert=>assert_true( lo_oao->mv_etag ).
    lv_xml = zcl_oao_http_handler=>property_xml( iv_name     = 'Changed'
                                                 io_property = lo_oao ).
    FIND 'Precision="7" ConcurrencyMode="Fixed" sap:unicode' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).
    FIND 'sap:semantics' IN lv_xml.
    cl_abap_unit_assert=>assert_subrc( exp = 4 ).
  ENDMETHOD.

  METHOD read_after_create_context.
* SEGW: CREATE OBJECT lo_ctx TYPE /iwbep/cl_sb_gen_read_aftr_crt, then
* set_keys( IMPORTING et_keys = lt_keys ) and the entity set, then get_entity
    TYPES: BEGIN OF ty_keys,
             travel_id TYPE c LENGTH 8,
             other     TYPE c LENGTH 2,
           END OF ty_keys.
    DATA lo_context TYPE REF TO /iwbep/cl_sb_gen_read_aftr_crt.
    DATA lo_request TYPE REF TO /iwbep/if_mgw_req_entity.
    DATA lt_keys    TYPE /iwbep/t_mgw_tech_pairs.
    DATA ls_key     TYPE /iwbep/s_mgw_tech_pair.
    DATA lv_name    TYPE string.
    DATA ls_keys    TYPE ty_keys.

    CREATE OBJECT lo_context.
    ls_key-name  = 'TRAVEL_ID'.
    ls_key-value = 'T0001'.
    APPEND ls_key TO lt_keys.
    lo_context->set_keys( IMPORTING et_keys = lt_keys ).
    lv_name = 'TravelSet'.
    lo_context->set_entityset_name( IMPORTING ev_entityset_name = lv_name ).
    lv_name = 'Travel'.
    lo_context->set_entity_type_name( IMPORTING ev_entity_type_name = lv_name ).

    lo_request = lo_context.
    cl_abap_unit_assert=>assert_equals( act = lo_request->get_entity_set_name( )
                                        exp = 'TravelSet' ).
    cl_abap_unit_assert=>assert_equals( act = lo_request->get_entity_type_name( )
                                        exp = 'Travel' ).
    cl_abap_unit_assert=>assert_equals( act = lo_request->get_source_entity_set_name( )
                                        exp = 'TravelSet' ).
    lo_request->get_converted_keys( IMPORTING es_key_values = ls_keys ).
    cl_abap_unit_assert=>assert_equals( act = ls_keys-travel_id
                                        exp = 'T0001' ).
    cl_abap_unit_assert=>assert_initial( ls_keys-other ).

* the current SEGW template passes the same through IMPORTING parameters
    CLEAR lt_keys.
    ls_key-value = 'T0002'.
    APPEND ls_key TO lt_keys.
    CREATE OBJECT lo_context.
    lo_context->set_keys( lt_keys ).
    lo_context->set_entityset_name( 'BookingSet' ).
    lo_context->set_entity_type_name( 'Booking' ).
    lo_request = lo_context.
    cl_abap_unit_assert=>assert_equals( act = lo_request->get_entity_set_name( )
                                        exp = 'BookingSet' ).
    cl_abap_unit_assert=>assert_equals( act = lo_request->get_entity_type_name( )
                                        exp = 'Booking' ).
    lo_request->get_converted_keys( IMPORTING es_key_values = ls_keys ).
    cl_abap_unit_assert=>assert_equals( act = ls_keys-travel_id
                                        exp = 'T0002' ).
  ENDMETHOD.

  METHOD search_help_runtime.
    DATA lo_sh_data    TYPE REF TO /iwbep/if_sb_shlp_data.
    DATA lo_provider   TYPE REF TO ltcl_shlp.
    DATA lt_selopt     TYPE ddshselops.
    DATA ls_selopt     LIKE LINE OF lt_selopt.
    DATA lt_result     TYPE /iwbep/if_sb_gendpc_shlp_data=>tt_result_list.
    DATA ls_result     LIKE LINE OF lt_result.
    DATA ls_message    TYPE bapiret2.

    zcl_oao_shlp_data=>clear( ).
    lo_sh_data = /iwbep/cl_sb_shlp_data_factory=>get_sh_data_obj( ).
    cl_abap_unit_assert=>assert_bound( lo_sh_data ).

* nobody registered the search help: an error message, no dump
    lo_sh_data->/iwbep/if_sb_gendpc_shlp_data~get_search_help_values(
      EXPORTING
        iv_shlp_name   = 'ZSTG_STATUS_SH'
      IMPORTING
        et_return_list = lt_result
        es_message     = ls_message ).
    cl_abap_unit_assert=>assert_equals( act = ls_message-type
                                        exp = 'E' ).
    cl_abap_unit_assert=>assert_initial( lt_result ).

    CREATE OBJECT lo_provider.
    zcl_oao_shlp_data=>register( iv_shlp_name = 'zstg_status_sh'
                                 io_provider  = lo_provider ).
    ls_selopt-shlpname  = 'ZSTG_STATUS_SH'.
    ls_selopt-shlpfield = 'STATUS'.
    ls_selopt-sign      = 'I'.
    ls_selopt-option    = 'EQ'.
    ls_selopt-low       = 'A'.
    APPEND ls_selopt TO lt_selopt.
    lo_sh_data->/iwbep/if_sb_gendpc_shlp_data~get_search_help_values(
      EXPORTING
        iv_shlp_name      = 'ZSTG_STATUS_SH'
        iv_maxrows        = 10
        iv_sort           = abap_true
        iv_call_shlt_exit = abap_true
        it_selopt         = lt_selopt
      IMPORTING
        et_return_list    = lt_result
        es_message        = ls_message ).
    cl_abap_unit_assert=>assert_initial( ls_message ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_result )
                                        exp = 2 ).
    READ TABLE lt_result INDEX 2 INTO ls_result.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = ls_result-field_value
                                        exp = 'Active ZSTG_STATUS_SH' ).
    zcl_oao_shlp_data=>clear( ).
  ENDMETHOD.

  METHOD mapped_dpc_types.
* the types the RFC templates of SEGW declare, and the entityset context's
* source entity set
    DATA lv_exc_msg TYPE /iwbep/mgw_bop_rfc_excep_text.
    DATA lo_context TYPE REF TO zcl_oao_request_context.
    DATA lo_request TYPE REF TO /iwbep/if_mgw_req_entityset.

    lv_exc_msg = 'no connection'.
    cl_abap_unit_assert=>assert_equals( act = lv_exc_msg
                                        exp = 'no connection' ).
    CREATE OBJECT lo_context
      EXPORTING
        iv_entity_set_name = 'TravelSet'.
    lo_request = lo_context.
    cl_abap_unit_assert=>assert_equals( act = lo_request->get_source_entity_set_name( )
                                        exp = 'TravelSet' ).
  ENDMETHOD.

  METHOD shlp_ddic_where.
    DATA lo_shlp   TYPE REF TO zcl_oao_shlp_ddic.
    DATA lt_selopt TYPE ddshselops.
    DATA ls_selopt TYPE ddshselopt.

    lo_shlp = zcl_oao_shlp_ddic=>create( iv_shlp_name = 'ZSEGW_SH'
                                         iv_selmethod = 'ZSEGW' ).
    cl_abap_unit_assert=>assert_initial( lo_shlp->where_clause( lt_selopt ) ).

    ls_selopt-shlpfield = 'SOMETHING1'.
    ls_selopt-sign      = 'I'.
    ls_selopt-option    = 'CP'.
    ls_selopt-low       = 'HE*'.
    APPEND ls_selopt TO lt_selopt.
    ls_selopt-option    = 'EQ'.
    ls_selopt-low       = 'O''NEIL'.
    APPEND ls_selopt TO lt_selopt.
    ls_selopt-shlpfield = 'SOMETHING2'.
    ls_selopt-sign      = 'E'.
    ls_selopt-option    = 'BT'.
    ls_selopt-low       = 'A'.
    ls_selopt-high      = 'B'.
    APPEND ls_selopt TO lt_selopt.
    cl_abap_unit_assert=>assert_equals(
      act = lo_shlp->where_clause( lt_selopt )
      exp = `( something1 LIKE 'HE%' OR something1 = 'O''NEIL' ) AND ( NOT ( something2 BETWEEN 'A' AND 'B' ) )` ).
  ENDMETHOD.

  METHOD shlp_ddic_select.
* the DDIC search help over the test table, reached the way a generated DPC
* reaches it: through the factory, by name
    DATA lo_sh_data TYPE REF TO /iwbep/if_sb_shlp_data.
    DATA lo_shlp    TYPE REF TO zcl_oao_shlp_ddic.
    DATA ls_row     TYPE zsegw.
    DATA lt_selopt  TYPE ddshselops.
    DATA ls_selopt  TYPE ddshselopt.
    DATA lt_result  TYPE /iwbep/if_sb_gendpc_shlp_data=>tt_result_list.
    DATA ls_result  LIKE LINE OF lt_result.
    DATA ls_message TYPE bapiret2.

    ls_row-mandt      = '123'.
    ls_row-something1 = 'SHLP2'.
    ls_row-something2 = 'ZZ'.
    INSERT zsegw FROM @ls_row.
    cl_abap_unit_assert=>assert_subrc( ).
    ls_row-something1 = 'SHLP1'.
    ls_row-something2 = 'AA'.
    INSERT zsegw FROM @ls_row.
    cl_abap_unit_assert=>assert_subrc( ).
    ls_row-something1 = 'OTHER'.
    INSERT zsegw FROM @ls_row.
    cl_abap_unit_assert=>assert_subrc( ).

    zcl_oao_shlp_data=>clear( ).
    lo_shlp = zcl_oao_shlp_ddic=>create( iv_shlp_name = 'ZSEGW_SH'
                                         iv_selmethod = 'ZSEGW' ).
    lo_shlp->add_parameter( iv_name            = 'SOMETHING1'
                            iv_list_position   = 1
                            iv_select_position = 1 ).
    lo_shlp->add_parameter( iv_name          = 'SOMETHING2'
                            iv_list_position = 2 ).
    lo_shlp->register( ).

    lo_sh_data = /iwbep/cl_sb_shlp_data_factory=>get_sh_data_obj( ).
    ls_selopt-shlpfield = 'SOMETHING1'.
    ls_selopt-sign      = 'I'.
    ls_selopt-option    = 'CP'.
    ls_selopt-low       = 'SHLP*'.
    APPEND ls_selopt TO lt_selopt.
    lo_sh_data->/iwbep/if_sb_gendpc_shlp_data~get_search_help_values(
      EXPORTING
        iv_shlp_name   = 'zsegw_sh'
        iv_sort        = abap_true
        it_selopt      = lt_selopt
      IMPORTING
        et_return_list = lt_result
        es_message     = ls_message ).
    cl_abap_unit_assert=>assert_initial( ls_message ).
* two records, two fields each, sorted by the list: SHLP1 before SHLP2
    cl_abap_unit_assert=>assert_equals( act = lines( lt_result )
                                        exp = 4 ).
    READ TABLE lt_result INDEX 1 INTO ls_result.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = ls_result-record_number
                                        exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = ls_result-field_name
                                        exp = 'SOMETHING1' ).
    cl_abap_unit_assert=>assert_equals( act = ls_result-field_value
                                        exp = 'SHLP1' ).
    READ TABLE lt_result INDEX 4 INTO ls_result.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = ls_result-record_number
                                        exp = 2 ).
    cl_abap_unit_assert=>assert_equals( act = ls_result-field_name
                                        exp = 'SOMETHING2' ).
    cl_abap_unit_assert=>assert_equals( act = ls_result-field_value
                                        exp = 'ZZ' ).

* no selection: every row, three records of two fields
    CLEAR lt_result.
    lo_sh_data->/iwbep/if_sb_gendpc_shlp_data~get_search_help_values(
      EXPORTING
        iv_shlp_name   = 'zsegw_sh'
        iv_sort        = abap_true
      IMPORTING
        et_return_list = lt_result
        es_message     = ls_message ).
    cl_abap_unit_assert=>assert_initial( ls_message ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_result )
                                        exp = 6 ).

* iv_maxrows cuts after sorting
    lo_sh_data->/iwbep/if_sb_gendpc_shlp_data~get_search_help_values(
      EXPORTING
        iv_shlp_name   = 'ZSEGW_SH'
        iv_maxrows     = 1
        iv_sort        = abap_true
        it_selopt      = lt_selopt
      IMPORTING
        et_return_list = lt_result
        es_message     = ls_message ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_result )
                                        exp = 2 ).

* an exit search help is honest about not being served
    zcl_oao_shlp_ddic=>create( iv_shlp_name = 'ZSEGW_EXIT_SH'
                               iv_selmexit  = 'Z_SHLP_EXIT' )->register( ).
    lo_sh_data->/iwbep/if_sb_gendpc_shlp_data~get_search_help_values(
      EXPORTING
        iv_shlp_name   = 'ZSEGW_EXIT_SH'
      IMPORTING
        et_return_list = lt_result
        es_message     = ls_message ).
    cl_abap_unit_assert=>assert_equals( act = ls_message-type
                                        exp = 'E' ).
    cl_abap_unit_assert=>assert_initial( lt_result ).

    DELETE FROM zsegw WHERE something1 = 'SHLP1' OR something1 = 'SHLP2' OR something1 = 'OTHER'.
    cl_abap_unit_assert=>assert_subrc( ).
    zcl_oao_shlp_data=>clear( ).
  ENDMETHOD.

  METHOD logger.
    DATA lo_logger   TYPE REF TO /iwbep/cl_cos_logger.
    DATA lt_messages TYPE /iwbep/cl_cos_logger=>ty_messages.
    DATA ls_message  LIKE LINE OF lt_messages.
    DATA lv_handle   TYPE string.

    CREATE OBJECT lo_logger.
    lv_handle = lo_logger->log_message( iv_msg_type = /iwbep/cl_cos_logger=>error
                                        iv_msg_text = 'plain  text'
                                        iv_agent    = 'TEST' ).
    cl_abap_unit_assert=>assert_equals( act = lv_handle
                                        exp = '1' ).
    lt_messages = lo_logger->get_messages( ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_messages )
                                        exp = 1 ).
    READ TABLE lt_messages INDEX 1 INTO ls_message.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = ls_message-msg_type
                                        exp = 'E' ).
    cl_abap_unit_assert=>assert_equals( act = ls_message-text
                                        exp = 'plain text' ).
    cl_abap_unit_assert=>assert_equals( act = ls_message-agent
                                        exp = 'TEST' ).
  ENDMETHOD.

  METHOD rfc_save_log_error.
* an E in the BAPI return ends the request with a business exception that
* carries the message container
    DATA lo_logger    TYPE REF TO /iwbep/cl_cos_logger.
    DATA lo_container TYPE REF TO zcl_oao_msg_container.
    DATA lt_return    TYPE bapirettab.
    DATA ls_return    TYPE bapiret2.
    DATA lx_busi      TYPE REF TO /iwbep/cx_mgw_busi_exception.
    DATA lt_messages  TYPE bapirettab.

    CREATE OBJECT lo_logger.
    CREATE OBJECT lo_container.
    ls_return-type    = 'S'.
    ls_return-message = 'fine'.
    APPEND ls_return TO lt_return.
    ls_return-type    = 'E'.
    ls_return-message = 'not fine'.
    APPEND ls_return TO lt_return.

    TRY.
        /iwbep/cl_sb_gen_dpc_rt_util=>rfc_save_log(
          it_return            = lt_return
          iv_entity_type       = 'Thing'
          io_logger            = lo_logger
          io_message_container = lo_container ).
        cl_abap_unit_assert=>fail( 'expected a business exception' ).
      CATCH /iwbep/cx_mgw_busi_exception INTO lx_busi.
        cl_abap_unit_assert=>assert_equals( act = lx_busi->message
                                            exp = 'not fine' ).
        cl_abap_unit_assert=>assert_bound( lx_busi->message_container ).
    ENDTRY.
    lt_messages = lo_container->get_messages( ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_messages )
                                        exp = 2 ).
    cl_abap_unit_assert=>assert_true( lo_container->has_errors( ) ).
    cl_abap_unit_assert=>assert_equals( act = lines( lo_logger->get_messages( ) )
                                        exp = 2 ).
  ENDMETHOD.

  METHOD rfc_save_log_success.
    DATA lo_logger    TYPE REF TO /iwbep/cl_cos_logger.
    DATA lo_container TYPE REF TO zcl_oao_msg_container.
    DATA ls_return    TYPE bapiret2.
    DATA lo_facade    TYPE REF TO /iwbep/if_mgw_dp_facade.

    CREATE OBJECT lo_logger.
    CREATE OBJECT lo_container.
    ls_return-type    = 'S'.
    ls_return-message = 'saved'.
    /iwbep/cl_sb_gen_dpc_rt_util=>rfc_save_log(
      is_return            = ls_return
      iv_entity_type       = 'Thing'
      io_logger            = lo_logger
      io_message_container = lo_container ).
    cl_abap_unit_assert=>assert_false( lo_container->has_errors( ) ).
    cl_abap_unit_assert=>assert_equals( act = lines( lo_container->get_messages( ) )
                                        exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = /iwbep/cl_sb_gen_dpc_rt_util=>get_rfc_destination( lo_facade )
                                        exp = 'NONE' ).
  ENDMETHOD.

  METHOD rfc_exception_handling.
    DATA lo_logger TYPE REF TO /iwbep/cl_cos_logger.
    DATA lx_busi   TYPE REF TO /iwbep/cx_mgw_busi_exception.
    DATA lv_tech   TYPE abap_bool.

    CREATE OBJECT lo_logger.
    TRY.
        /iwbep/cl_sb_gen_dpc_rt_util=>rfc_exception_handling(
          iv_subrc            = 1000
          iv_exp_message_text = 'no connection'
          io_logger           = lo_logger ).
      CATCH /iwbep/cx_mgw_tech_exception.
        lv_tech = abap_true.
    ENDTRY.
    cl_abap_unit_assert=>assert_true( lv_tech ).

    TRY.
        /iwbep/cl_sb_gen_dpc_rt_util=>rfc_exception_handling(
          iv_subrc            = 4
          iv_exp_message_text = 'function raised' ).
        cl_abap_unit_assert=>fail( 'expected a business exception' ).
      CATCH /iwbep/cx_mgw_busi_exception INTO lx_busi.
        cl_abap_unit_assert=>assert_equals( act = lx_busi->message
                                            exp = 'function raised' ).
    ENDTRY.
  ENDMETHOD.

  METHOD rfc_local_destination.
* creating any DPC registers 'NONE' as the local destination, after which
* CALL FUNCTION ... DESTINATION 'NONE' reaches the function modules here
    DATA lo_dpc      TYPE REF TO zcl_zsegw_dpc_ext.
    DATA lv_timezone TYPE timezone.
    DATA lv_illegal  TYPE abap_bool.

    CREATE OBJECT lo_dpc.
    CALL FUNCTION 'GET_SYSTEM_TIMEZONE'
      DESTINATION 'NONE'
      IMPORTING
        timezone              = lv_timezone
      EXCEPTIONS
        system_failure        = 1
        communication_failure = 2
        resource_failure      = 3
        OTHERS                = 4.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals( act = lv_timezone
                                        exp = 'UTC' ).

* a function module that is not here is the same error as without DESTINATION
    TRY.
        CALL FUNCTION 'NOT_THERE'
          DESTINATION 'NONE'
          EXCEPTIONS
            system_failure        = 1
            communication_failure = 2
            resource_failure      = 3
            OTHERS                = 4.
      CATCH cx_sy_dyn_call_illegal_func.
        lv_illegal = abap_true.
    ENDTRY.
    cl_abap_unit_assert=>assert_true( lv_illegal ).
  ENDMETHOD.

  METHOD dpc_log_message.
* the generated log_message goes through mo_context->get_logger( )
    DATA lo_dpc    TYPE REF TO zcl_zsegw_dpc_ext.
    DATA lo_comm   TYPE REF TO /iwbep/if_sb_dpc_comm_services.
    DATA lo_conv   TYPE REF TO /iwbep/if_mgw_conv_srv_runtime.
    DATA lo_logger TYPE REF TO /iwbep/cl_cos_logger.

    CREATE OBJECT lo_dpc.
    lo_comm = lo_dpc.
    lo_conv = lo_dpc.
    lo_comm->log_message( iv_msg_type   = 'S'
                          iv_msg_id     = '00'
                          iv_msg_number = '001'
                          iv_msg_v1     = 'hello' ).
    lo_logger = lo_conv->get_logger( ).
    cl_abap_unit_assert=>assert_bound( lo_logger ).
    cl_abap_unit_assert=>assert_equals( act = lines( lo_logger->get_messages( ) )
                                        exp = 1 ).
    cl_abap_unit_assert=>assert_bound( lo_conv->get_message_container( ) ).
  ENDMETHOD.

  METHOD unknown_service.
    TRY.
        zcl_oao_http_handler=>handle( '/sap/opu/odata/sap/NOT_REGISTERED/$metadata' ).
        cl_abap_unit_assert=>fail( 'expected /iwbep/cx_mgw_tech_exception' ).
      CATCH /iwbep/cx_mgw_tech_exception.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD vocabulary_annotations.
* what a SEGW-generated _MPC_EXT writes through vocab_anno_model: a value
* list with a text arrangement on a property, a line item collection on the
* entity type; printed as V4 vocabulary annotations in the V2 $metadata
    DATA lo_model      TYPE REF TO zcl_oao_model.
    DATA lo_vocan      TYPE REF TO /iwbep/if_mgw_vocan_model.
    DATA lo_target     TYPE REF TO /iwbep/if_mgw_vocan_ann_target.
    DATA lo_annotation TYPE REF TO /iwbep/if_mgw_vocan_annotation.
    DATA lo_record     TYPE REF TO /iwbep/if_mgw_vocan_record.
    DATA lo_collection TYPE REF TO /iwbep/if_mgw_vocan_collection.
    DATA lt_xml        TYPE string_table.
    DATA lv_xml        TYPE string.

    CREATE OBJECT lo_model.
    lo_vocan ?= lo_model.

    lo_target = lo_vocan->create_annotations_target( 'ZSRV.Travel/Status' ).
    lo_annotation = lo_target->create_annotation( 'com.sap.vocabularies.Common.v1.Text' ).
    lo_annotation->create_simple_value( )->set_path( 'StatusText' ).
    lo_annotation = lo_annotation->create_annotation( 'com.sap.vocabularies.UI.v1.TextArrangement' ).
    lo_annotation->create_simple_value( )->set_enum_member_by_name( 'com.sap.vocabularies.UI.v1.TextArrangementType/TextFirst' ).
    lo_annotation = lo_target->create_annotation( 'com.sap.vocabularies.Common.v1.ValueList' ).
    lo_annotation->set_value_list_et_name( 'StatusVH' ).
    lo_record = lo_annotation->create_record( ).
    lo_record->create_property( 'Label' )->create_simple_value( )->set_string( 'Status & more' ).
    lo_record->create_property( 'CollectionPath' )->create_simple_value( )->set_string( 'StatusVHSet' ).
    lo_record->create_property( 'SearchSupported' )->create_simple_value( )->set_boolean( abap_true ).
    lo_collection = lo_record->create_property( 'Parameters' )->create_collection( ).
    lo_record = lo_collection->create_record( 'com.sap.vocabularies.Common.v1.ValueListParameterInOut' ).
    lo_record->create_property( 'LocalDataProperty' )->create_simple_value( )->set_property_path( 'Status' ).
    lo_record->create_property( 'ValueListProperty' )->create_simple_value( )->set_string( 'Status' ).

    lo_target = lo_vocan->create_annotations_target( 'ZSRV.Travel' ).
    lo_collection = lo_target->create_annotation( 'com.sap.vocabularies.UI.v1.SelectionFields' )->create_collection( ).
    lo_collection->create_simple_value( )->set_property_path( 'Status' ).
    lo_annotation = lo_target->create_annotation(
      iv_term      = 'com.sap.vocabularies.UI.v1.LineItem'
      iv_qualifier = 'Short' ).
    lo_record = lo_annotation->create_collection( )->create_record( 'com.sap.vocabularies.UI.v1.DataField' ).
    lo_record->create_property( 'Value' )->create_simple_value( )->set_path( 'TravelId' ).
    lo_record->create_property( 'Label' )->create_simple_value( )->set_string( 'Travel' ).

    lt_xml = lo_model->get_vocabulary_xml( ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_xml )
                                        exp = 2 ).
    READ TABLE lt_xml INDEX 1 INTO lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_true( boolc( lv_xml CS '<Annotations xmlns="http://docs.oasis-open.org/odata/ns/edm" Target="ZSRV.Travel/Status">' ) ).
    cl_abap_unit_assert=>assert_true( boolc( lv_xml CS '<Annotation Term="com.sap.vocabularies.Common.v1.Text" Path="StatusText">' ) ).
    cl_abap_unit_assert=>assert_true( boolc( lv_xml CS '<Annotation Term="com.sap.vocabularies.UI.v1.TextArrangement" EnumMember="com.sap.vocabularies.UI.v1.TextArrangementType/TextFirst"/>' ) ).
    cl_abap_unit_assert=>assert_true( boolc( lv_xml CS '<Annotation Term="com.sap.vocabularies.Common.v1.ValueList">' ) ).
    cl_abap_unit_assert=>assert_true( boolc( lv_xml CS '<Record>' ) ).
    cl_abap_unit_assert=>assert_true( boolc( lv_xml CS '<PropertyValue Property="Label" String="Status &amp; more"/>' ) ).
    cl_abap_unit_assert=>assert_true( boolc( lv_xml CS '<PropertyValue Property="SearchSupported" Bool="true"/>' ) ).
    cl_abap_unit_assert=>assert_true( boolc( lv_xml CS '<PropertyValue Property="Parameters">' ) ).
    cl_abap_unit_assert=>assert_true( boolc( lv_xml CS '<Record Type="com.sap.vocabularies.Common.v1.ValueListParameterInOut">' ) ).
    cl_abap_unit_assert=>assert_true( boolc( lv_xml CS '<PropertyValue Property="LocalDataProperty" PropertyPath="Status"/>' ) ).
    READ TABLE lt_xml INDEX 2 INTO lv_xml.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_true( boolc( lv_xml CS '<Annotation Term="com.sap.vocabularies.UI.v1.SelectionFields">' ) ).
    cl_abap_unit_assert=>assert_true( boolc( lv_xml CS '<PropertyPath>Status</PropertyPath>' ) ).
    cl_abap_unit_assert=>assert_true( boolc( lv_xml CS '<Annotation Term="com.sap.vocabularies.UI.v1.LineItem" Qualifier="Short">' ) ).
    cl_abap_unit_assert=>assert_true( boolc( lv_xml CS '<PropertyValue Property="Value" Path="TravelId"/>' ) ).
  ENDMETHOD.

ENDCLASS.

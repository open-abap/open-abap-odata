CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS test FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.
  METHOD test.
    DATA mpc TYPE REF TO zcl_zsegw_mpc_ext.
    CREATE OBJECT mpc.

    mpc->define( ).
    mpc->model->get_entity_type( zcl_zsegw_mpc_ext=>gc_zsegw ).
  ENDMETHOD.
ENDCLASS.
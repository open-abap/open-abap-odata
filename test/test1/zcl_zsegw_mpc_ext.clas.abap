CLASS zcl_zsegw_mpc_ext DEFINITION PUBLIC INHERITING FROM zcl_zsegw_mpc CREATE PUBLIC.
  PUBLIC SECTION.
* what an _EXT class does on a system: refine the generated model, here an
* annotation on the entity type
    METHODS define REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zsegw_mpc_ext IMPLEMENTATION.

  METHOD define.
    super->define( ).
    model->get_entity_type( 'zsegw' )->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' )->add(
      iv_key   = 'label'
      iv_value = 'Segw' ).
  ENDMETHOD.

ENDCLASS.

CLASS zcl_zsegw_dpc_ext DEFINITION PUBLIC INHERITING FROM zcl_zsegw_dpc CREATE PUBLIC.

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS zsegwset_get_entityset REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zsegw_dpc_ext IMPLEMENTATION.


  METHOD zsegwset_get_entityset.

    DATA row LIKE LINE OF et_entityset.
    row-something1 = 'HELLO'.
    row-something2 = 'WORLD'.
    INSERT row INTO TABLE et_entityset.

  ENDMETHOD.
ENDCLASS.

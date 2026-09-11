CLASS zcl_oao_parameter DEFINITION PUBLIC INHERITING FROM zcl_oao_property.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_odata_parameter.

    DATA mv_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.
    DATA mv_mode TYPE string VALUE 'In'.
ENDCLASS.

CLASS zcl_oao_parameter IMPLEMENTATION.

  METHOD /iwbep/if_mgw_odata_parameter~set_mode.
    mv_mode = iv_mode.
  ENDMETHOD.

ENDCLASS.

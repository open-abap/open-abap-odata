CLASS zcl_oao_assoc_set DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_odata_assoc_set.

    DATA mv_name        TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.
    DATA mv_association TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.
    DATA mv_left_set    TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.
    DATA mv_right_set   TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.
ENDCLASS.

CLASS zcl_oao_assoc_set IMPLEMENTATION.
ENDCLASS.

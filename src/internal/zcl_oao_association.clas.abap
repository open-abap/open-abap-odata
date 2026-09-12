CLASS zcl_oao_association DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_odata_assoc.

    DATA mv_name           TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.
    DATA mv_left_type      TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.
    DATA mv_right_type     TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.
    DATA mv_left_card      TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_cardinality.
    DATA mv_right_card     TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_cardinality.
    DATA mo_ref_constraint TYPE REF TO zcl_oao_ref_constraint.
ENDCLASS.

CLASS zcl_oao_association IMPLEMENTATION.

  METHOD /iwbep/if_mgw_odata_assoc~create_ref_constraint.
    CREATE OBJECT mo_ref_constraint.
    mo_ref_constraint->mv_principal_is_left = iv_principal_is_left.
    ro_ref_constraint = mo_ref_constraint.
  ENDMETHOD.

ENDCLASS.

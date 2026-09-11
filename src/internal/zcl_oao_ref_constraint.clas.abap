CLASS zcl_oao_ref_constraint DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_odata_ref_constr.

    TYPES: BEGIN OF ty_pair,
             principal TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name,
             dependent TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name,
           END OF ty_pair.
    TYPES ty_pairs TYPE STANDARD TABLE OF ty_pair WITH DEFAULT KEY.

    DATA mv_principal_is_left TYPE abap_bool VALUE abap_true.
    DATA mt_pairs             TYPE ty_pairs.
ENDCLASS.

CLASS zcl_oao_ref_constraint IMPLEMENTATION.

  METHOD /iwbep/if_mgw_odata_ref_constr~add_property.
    DATA ls_pair TYPE ty_pair.

    ls_pair-principal = iv_principal_property.
    ls_pair-dependent = iv_dependent_property.
    APPEND ls_pair TO mt_pairs.
  ENDMETHOD.

ENDCLASS.

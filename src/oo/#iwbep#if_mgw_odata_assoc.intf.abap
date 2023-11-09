INTERFACE /iwbep/if_mgw_odata_assoc PUBLIC.

  METHODS create_ref_constraint
    IMPORTING
      iv_principal_is_left     TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(ro_ref_constraint) TYPE REF TO /iwbep/if_mgw_odata_ref_constr
    RAISING
      /iwbep/cx_mgw_med_exception.

ENDINTERFACE.
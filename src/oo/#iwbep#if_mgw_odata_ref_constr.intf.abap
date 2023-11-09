INTERFACE /iwbep/if_mgw_odata_ref_constr PUBLIC.

  METHODS add_property
    IMPORTING
      iv_principal_property TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
      iv_dependent_property TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
    RAISING
      /iwbep/cx_mgw_med_exception.

ENDINTERFACE.
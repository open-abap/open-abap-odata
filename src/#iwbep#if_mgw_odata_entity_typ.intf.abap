INTERFACE /iwbep/if_mgw_odata_entity_typ PUBLIC.

  METHODS create_entity_set
    IMPORTING
      iv_entity_set_name   TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
    RETURNING
      VALUE(ro_entity_set) TYPE REF TO /iwbep/if_mgw_odata_entity_set
    RAISING
      /iwbep/cx_mgw_med_exception.

  METHODS bind_structure
    IMPORTING
      iv_structure_name   TYPE string
      iv_bind_conversions TYPE abap_bool DEFAULT abap_false
    RAISING
      /iwbep/cx_mgw_med_exception.

ENDINTERFACE.
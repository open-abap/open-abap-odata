INTERFACE /iwbep/if_mgw_odata_model PUBLIC.

  METHODS create_entity_type
    IMPORTING
      iv_entity_type_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
      iv_def_entity_set   TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(ro_entity)    TYPE REF TO /iwbep/if_mgw_odata_entity_typ
    RAISING
      /iwbep/cx_mgw_med_exception.

  METHODS get_entity_type
    IMPORTING
      iv_entity_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
    RETURNING
      VALUE(ro_entity_type) TYPE REF TO /iwbep/if_mgw_odata_entity_typ
    RAISING
      /iwbep/cx_mgw_med_exception.

  METHODS set_schema_namespace
    IMPORTING
      iv_namespace TYPE string.

  METHODS get_schema_namespace
    EXPORTING
      ev_namespace TYPE string.

ENDINTERFACE.
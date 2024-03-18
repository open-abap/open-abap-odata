INTERFACE /iwbep/if_mgw_odata_action PUBLIC.

  METHODS set_return_entity_type
    IMPORTING
      iv_data_object_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
    RAISING
      /iwbep/cx_mgw_med_exception.

  METHODS set_http_method
    IMPORTING
      iv_method_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_http_method
    RAISING
      /iwbep/cx_mgw_med_exception.

  METHODS set_action_for
    IMPORTING
      iv_entity_type_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name
    RAISING
      /iwbep/cx_mgw_med_exception.

  METHODS set_return_multiplicity
    IMPORTING
      iv_cardinality TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_cardinality.

ENDINTERFACE.
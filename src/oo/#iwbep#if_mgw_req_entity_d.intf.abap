INTERFACE /iwbep/if_mgw_req_entity_d PUBLIC.
  METHODS get_entity_set_name
    RETURNING
      VALUE(rv_entity_set) TYPE /iwbep/mgw_tech_name.

  METHODS get_converted_keys
    EXPORTING
      es_key_values TYPE data.

  METHODS get_entity_type_name
    RETURNING
      VALUE(rv_entity_type) TYPE /iwbep/mgw_tech_name.
ENDINTERFACE.
INTERFACE /iwbep/if_mgw_req_entity_u PUBLIC.

  METHODS get_entity_set_name
    RETURNING
      VALUE(rv_entity_set) TYPE /iwbep/mgw_tech_name.

  METHODS get_converted_keys
    EXPORTING
      es_key_values TYPE data.

ENDINTERFACE.
INTERFACE /iwbep/if_mgw_req_entity PUBLIC.

  METHODS get_entity_set_name
    RETURNING
      VALUE(rv_entity_set) TYPE /iwbep/mgw_tech_name.

ENDINTERFACE.
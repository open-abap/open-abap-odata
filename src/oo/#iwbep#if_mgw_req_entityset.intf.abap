INTERFACE /iwbep/if_mgw_req_entityset PUBLIC.

  METHODS get_entity_set_name
    RETURNING
      VALUE(rv_entity_set) TYPE /iwbep/mgw_tech_name.

  METHODS get_top
    RETURNING
      VALUE(rv_top) TYPE string.

  METHODS get_skip
    RETURNING
      VALUE(rv_skip) TYPE i.

  METHODS get_converted_source_keys
    EXPORTING
      es_key_values TYPE data.

  METHODS get_filter
    RETURNING
      VALUE(ro_filter) TYPE REF TO /iwbep/if_mgw_req_filter.

ENDINTERFACE.
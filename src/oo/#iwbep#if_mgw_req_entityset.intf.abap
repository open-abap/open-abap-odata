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

  METHODS has_inlinecount
    RETURNING
      VALUE(rv_has_inlinecount) TYPE abap_bool.

  METHODS has_count
    RETURNING
      VALUE(rv_has_count) TYPE abap_bool.

  METHODS get_orderby
    RETURNING
      VALUE(rt_orderby) TYPE /iwbep/t_mgw_tech_order.

  METHODS get_osql_where_clause_convert
    RETURNING
      VALUE(rv_osql_where_clause) TYPE string.

ENDINTERFACE.
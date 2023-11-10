INTERFACE /iwbep/if_mgw_entry_provider PUBLIC.

  METHODS read_entry_data
    EXPORTING
      es_data TYPE any
    RAISING
      /iwbep/cx_mgw_tech_exception.

ENDINTERFACE.
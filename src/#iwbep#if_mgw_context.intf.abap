INTERFACE /iwbep/if_mgw_context PUBLIC.
  METHODS get_logger
    RETURNING
      VALUE(ro_logger) TYPE REF TO /iwbep/cl_cos_logger.
ENDINTERFACE.
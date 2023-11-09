INTERFACE /iwbep/if_mgw_conv_srv_runtime PUBLIC.
  METHODS get_message_container
    RETURNING
      VALUE(container) TYPE REF TO /iwbep/if_message_container.

  METHODS set_header
    IMPORTING
      value TYPE any.

  METHODS get_logger
    RETURNING
      VALUE(ro_logger) TYPE REF TO /iwbep/cl_cos_logger.

  METHODS copy_data_to_ref
    IMPORTING
      is_data TYPE any
    CHANGING
      cr_data TYPE REF TO data.

  METHODS get_dp_facade
    RETURNING
      VALUE(ro_dp_facade) TYPE REF TO /iwbep/if_mgw_dp_facade
    RAISING
      /iwbep/cx_mgw_tech_exception.
ENDINTERFACE.
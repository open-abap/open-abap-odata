CLASS zcl_oao_context DEFINITION PUBLIC.
* mo_context of a DPC: what the generated code reaches through it
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_context.

    METHODS constructor
      IMPORTING
        io_logger TYPE REF TO /iwbep/cl_cos_logger.
  PRIVATE SECTION.
    DATA mo_logger TYPE REF TO /iwbep/cl_cos_logger.
ENDCLASS.

CLASS zcl_oao_context IMPLEMENTATION.

  METHOD constructor.
    mo_logger = io_logger.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_context~get_logger.
    ro_logger = mo_logger.
  ENDMETHOD.

ENDCLASS.

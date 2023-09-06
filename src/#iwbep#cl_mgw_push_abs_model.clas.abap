CLASS /iwbep/cl_mgw_push_abs_model DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS get_last_modified
      RETURNING
        VALUE(rv_last_modified) TYPE timestamp.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS /iwbep/cl_mgw_push_abs_model IMPLEMENTATION.

  METHOD get_last_modified.
    RETURN.
  ENDMETHOD.

ENDCLASS.
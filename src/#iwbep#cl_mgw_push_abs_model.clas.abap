CLASS /iwbep/cl_mgw_push_abs_model DEFINITION PUBLIC ABSTRACT CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS get_last_modified
      RETURNING
        VALUE(rv_last_modified) TYPE timestamp.

    METHODS define ABSTRACT
      RAISING
        /iwbep/cx_mgw_med_exception.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS /iwbep/cl_mgw_push_abs_model IMPLEMENTATION.

  METHOD get_last_modified.
    RETURN.
  ENDMETHOD.

ENDCLASS.
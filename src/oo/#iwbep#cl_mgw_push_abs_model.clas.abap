CLASS /iwbep/cl_mgw_push_abs_model DEFINITION PUBLIC ABSTRACT CREATE PUBLIC.

  PUBLIC SECTION.
    DATA model TYPE REF TO /iwbep/if_mgw_odata_model.

    METHODS constructor.

    METHODS get_last_modified
      RETURNING
        VALUE(rv_last_modified) TYPE timestamp.

    METHODS define ABSTRACT
      RAISING
        /iwbep/cx_mgw_med_exception.

ENDCLASS.

CLASS /iwbep/cl_mgw_push_abs_model IMPLEMENTATION.

  METHOD constructor.
    CREATE OBJECT model TYPE zcl_mgw_odata_model.
  ENDMETHOD.

  METHOD get_last_modified.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
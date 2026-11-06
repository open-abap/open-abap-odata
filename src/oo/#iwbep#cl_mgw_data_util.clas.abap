CLASS /iwbep/cl_mgw_data_util DEFINITION PUBLIC.
  PUBLIC SECTION.

    CLASS-METHODS orderby
      IMPORTING
        it_order TYPE /iwbep/t_mgw_sorting_order
      CHANGING
        ct_data  TYPE STANDARD TABLE.

    CLASS-METHODS paging
      IMPORTING
        is_paging TYPE /iwbep/s_mgw_paging
      CHANGING
        ct_data   TYPE STANDARD TABLE.

ENDCLASS.

CLASS /iwbep/cl_mgw_data_util IMPLEMENTATION.
  METHOD paging.
    ASSERT 1 = 2.
  ENDMETHOD.

  METHOD orderby.
    ASSERT 1 = 2.
  ENDMETHOD.

ENDCLASS.
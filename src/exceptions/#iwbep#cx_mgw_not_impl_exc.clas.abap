CLASS /iwbep/cx_mgw_not_impl_exc DEFINITION INHERITING FROM /iwbep/cx_mgw_tech_exception PUBLIC.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous LIKE previous OPTIONAL
        method   TYPE string OPTIONAL.
ENDCLASS.

CLASS /iwbep/cx_mgw_not_impl_exc IMPLEMENTATION.

  METHOD constructor.
    super->constructor( textid   = textid
                        previous = previous ).
  ENDMETHOD.

ENDCLASS.
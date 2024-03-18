CLASS /iwbep/cx_mgw_tech_exception DEFINITION INHERITING FROM /iwbep/cx_mgw_base_exception PUBLIC.
  PUBLIC SECTION.
    CONSTANTS: BEGIN OF method_not_implemented,
                 msgid TYPE symsgid VALUE '/IWBEP/CM_MGW_RT',
                 msgno TYPE symsgno VALUE '021',
                 attr1 TYPE scx_attrname VALUE 'METHOD',
                 attr2 TYPE scx_attrname VALUE '',
                 attr3 TYPE scx_attrname VALUE '',
                 attr4 TYPE scx_attrname VALUE '',
               END OF method_not_implemented.

    CONSTANTS: BEGIN OF internal_error,
                 msgid TYPE symsgid VALUE '/IWBEP/CM_MGW_RT',
                 msgno TYPE symsgno VALUE '032',
                 attr1 TYPE scx_attrname VALUE '',
                 attr2 TYPE scx_attrname VALUE '',
                 attr3 TYPE scx_attrname VALUE '',
                 attr4 TYPE scx_attrname VALUE '',
               END OF internal_error.

    METHODS constructor
      IMPORTING
        textid    LIKE if_t100_message=>t100key OPTIONAL
        method    TYPE clike OPTIONAL
        operation TYPE clike OPTIONAL
        previous  LIKE previous OPTIONAL.
ENDCLASS.

CLASS /iwbep/cx_mgw_tech_exception IMPLEMENTATION.

  METHOD constructor.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
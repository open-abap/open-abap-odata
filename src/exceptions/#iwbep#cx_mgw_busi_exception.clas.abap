CLASS /iwbep/cx_mgw_busi_exception DEFINITION INHERITING FROM /iwbep/cx_mgw_base_exception PUBLIC.
  PUBLIC SECTION.
    CONSTANTS: BEGIN OF business_error,
                 msgid TYPE symsgid VALUE '/IWBEP/CM_MGW_RT',
                 msgno TYPE symsgno VALUE '022',
                 attr1 TYPE scx_attrname VALUE 'MESSAGE',
                 attr2 TYPE scx_attrname VALUE '',
                 attr3 TYPE scx_attrname VALUE '',
                 attr4 TYPE scx_attrname VALUE '',
               END OF business_error.

    CONSTANTS: BEGIN OF business_error_unlimited,
                 msgid TYPE symsgid VALUE '/IWBEP/CM_MGW_RT',
                 msgno TYPE symsgno VALUE '022',
                 attr1 TYPE scx_attrname VALUE 'MESSAGE_UNLIMITED',
                 attr2 TYPE scx_attrname VALUE '',
                 attr3 TYPE scx_attrname VALUE '',
                 attr4 TYPE scx_attrname VALUE '',
               END OF business_error_unlimited.

    METHODS constructor
      IMPORTING
        textid            LIKE if_t100_message=>t100key OPTIONAL
        message_unlimited TYPE string OPTIONAL
        message           TYPE clike OPTIONAL
        message_container TYPE REF TO /iwbep/if_message_container OPTIONAL
        previous          LIKE previous OPTIONAL.
ENDCLASS.

CLASS /iwbep/cx_mgw_busi_exception IMPLEMENTATION.

  METHOD constructor.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
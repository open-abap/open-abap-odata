CLASS zcl_oao_annotation DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_odata_annotation.

    TYPES: BEGIN OF ty_annotation,
             key   TYPE /iwbep/med_annotation_key,
             value TYPE /iwbep/med_annotation_value,
           END OF ty_annotation.
    TYPES ty_annotations TYPE STANDARD TABLE OF ty_annotation WITH DEFAULT KEY.

    METHODS get_all
      RETURNING
        VALUE(rt_annotations) TYPE ty_annotations.
  PRIVATE SECTION.
    DATA mt_annotations TYPE ty_annotations.
ENDCLASS.

CLASS zcl_oao_annotation IMPLEMENTATION.

  METHOD /iwbep/if_mgw_odata_annotation~add.
    DATA ls_row LIKE LINE OF mt_annotations.
    ls_row-key = iv_key.
    ls_row-value = iv_value.
    DELETE mt_annotations WHERE key = ls_row-key.
    APPEND ls_row TO mt_annotations.
  ENDMETHOD.

  METHOD get_all.
    rt_annotations = mt_annotations.
  ENDMETHOD.

ENDCLASS.
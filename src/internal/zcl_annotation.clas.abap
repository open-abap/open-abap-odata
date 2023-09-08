CLASS zcl_annotation DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_odata_annotation.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_annotation,
             key   TYPE /iwbep/med_annotation_key,
             value TYPE /iwbep/med_annotation_value,
           END OF ty_annotation.
    DATA mt_annotations TYPE HASHED TABLE OF ty_annotation WITH UNIQUE KEY key.
ENDCLASS.

CLASS zcl_annotation IMPLEMENTATION.

  METHOD /iwbep/if_mgw_odata_annotation~add.
    DATA ls_row LIKE LINE OF mt_annotations.
    ls_row-key = iv_key.
    ls_row-value = iv_value.
    INSERT ls_row INTO TABLE mt_annotations.
  ENDMETHOD.

ENDCLASS.
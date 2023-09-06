INTERFACE /iwbep/if_mgw_odata_annotatabl PUBLIC.

  METHODS create_annotation
    IMPORTING
      iv_annotation_namespace TYPE /iwbep/med_anno_namespace
    RETURNING
      VALUE(ro_annotation)    TYPE REF TO /iwbep/if_mgw_odata_annotation
    RAISING
      /iwbep/cx_mgw_med_exception.

ENDINTERFACE.
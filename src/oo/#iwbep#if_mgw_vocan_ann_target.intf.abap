INTERFACE /iwbep/if_mgw_vocan_ann_target PUBLIC.
* <Annotations Target="..."> and the annotations under it

  METHODS create_annotation
    IMPORTING
      iv_term              TYPE string
      iv_qualifier         TYPE string OPTIONAL
    RETURNING
      VALUE(ro_annotation) TYPE REF TO /iwbep/if_mgw_vocan_annotation.

* the namespace the target name is relative to (informational: the
* target is printed as given)
  METHODS set_namespace
    IMPORTING
      iv_namespace TYPE string.

ENDINTERFACE.

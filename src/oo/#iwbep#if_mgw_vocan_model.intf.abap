INTERFACE /iwbep/if_mgw_vocan_model PUBLIC.
* Vocabulary-based annotations of a model (the OData V4 vocabularies UI,
* Common, Analytics... inside a V2 $metadata): what an _MPC_EXT builds in
* DEFINE through vocab_anno_model. One target per model element
* ("ZSRV.Entity", "ZSRV.Entity/Property", "ZSRV.Container/Set").

  METHODS create_annotations_target
    IMPORTING
      iv_target                    TYPE string
      iv_qualifier                 TYPE string OPTIONAL
    RETURNING
      VALUE(ro_annotations_target) TYPE REF TO /iwbep/if_mgw_vocan_ann_target.

ENDINTERFACE.

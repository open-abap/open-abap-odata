INTERFACE /iwbep/if_mgw_vocan_annotation PUBLIC.
* <Annotation Term="..."> with one value: a simple value (attribute), a
* record, a collection; annotations may carry annotations themselves
* (Common.Text with UI.TextArrangement)

  METHODS create_simple_value
    RETURNING
      VALUE(ro_simple_value) TYPE REF TO /iwbep/if_mgw_vocan_simple_val.

  METHODS create_record
    IMPORTING
      iv_record_type   TYPE string OPTIONAL
    RETURNING
      VALUE(ro_record) TYPE REF TO /iwbep/if_mgw_vocan_record.

  METHODS create_collection
    RETURNING
      VALUE(ro_collection) TYPE REF TO /iwbep/if_mgw_vocan_collection.

  METHODS create_annotation
    IMPORTING
      iv_term              TYPE string
      iv_qualifier         TYPE string OPTIONAL
    RETURNING
      VALUE(ro_annotation) TYPE REF TO /iwbep/if_mgw_vocan_annotation.

* the entity type a Common.ValueList points at (informational)
  METHODS set_value_list_et_name
    IMPORTING
      iv_entity_type_name TYPE string.

ENDINTERFACE.

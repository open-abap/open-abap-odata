INTERFACE /iwbep/if_mgw_vocan_property PUBLIC.
* <PropertyValue Property="..."> of a record: a simple value, a record or
* a collection

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

ENDINTERFACE.

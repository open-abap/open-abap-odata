INTERFACE /iwbep/if_mgw_vocan_collection PUBLIC.
* <Collection> of records or of simple values (<PropertyPath>, <String>...)

  METHODS create_record
    IMPORTING
      iv_record_type   TYPE string OPTIONAL
    RETURNING
      VALUE(ro_record) TYPE REF TO /iwbep/if_mgw_vocan_record.

  METHODS create_simple_value
    RETURNING
      VALUE(ro_simple_value) TYPE REF TO /iwbep/if_mgw_vocan_simple_val.

ENDINTERFACE.

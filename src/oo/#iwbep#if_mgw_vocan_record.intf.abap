INTERFACE /iwbep/if_mgw_vocan_record PUBLIC.
* <Record Type="..."> with its <PropertyValue>s

  METHODS create_property
    IMPORTING
      iv_property_name   TYPE string
    RETURNING
      VALUE(ro_property) TYPE REF TO /iwbep/if_mgw_vocan_property.

  METHODS create_annotation
    IMPORTING
      iv_term              TYPE string
      iv_qualifier         TYPE string OPTIONAL
    RETURNING
      VALUE(ro_annotation) TYPE REF TO /iwbep/if_mgw_vocan_annotation.

ENDINTERFACE.

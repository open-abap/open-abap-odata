INTERFACE /iwbep/if_mgw_vocan_simple_val PUBLIC.
* one constant or path expression: an attribute on its parent element, or
* an element of its own inside a collection

  METHODS set_string
    IMPORTING
      iv_value TYPE string.

  METHODS set_path
    IMPORTING
      iv_value TYPE string.

  METHODS set_property_path
    IMPORTING
      iv_value TYPE string.

  METHODS set_navigation_property_path
    IMPORTING
      iv_value TYPE string.

  METHODS set_annotation_path
    IMPORTING
      iv_value TYPE string.

  METHODS set_boolean
    IMPORTING
      iv_value TYPE abap_bool.

  METHODS set_int
    IMPORTING
      iv_value TYPE i.

  METHODS set_decimal
    IMPORTING
      iv_value TYPE string.

  METHODS set_enum_member_by_name
    IMPORTING
      iv_enum_member_name TYPE string.

ENDINTERFACE.

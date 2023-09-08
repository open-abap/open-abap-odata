INTERFACE /iwbep/if_mgw_odata_property PUBLIC.

  INTERFACES /iwbep/if_mgw_odata_annotatabl.
  INTERFACES /iwbep/if_mgw_odata_item.

  ALIASES set_label_from_text_element
    FOR /iwbep/if_mgw_odata_item~set_label_from_text_element.

  METHODS set_type_edm_string.

  METHODS set_maxlength
    IMPORTING
      iv_max_length TYPE i.

  METHODS set_creatable
    IMPORTING
      iv_creatable TYPE abap_bool.

  METHODS set_updatable
    IMPORTING
      iv_updatable TYPE abap_bool.

  METHODS set_sortable
    IMPORTING
      iv_sortable TYPE abap_bool.

  METHODS set_nullable
    IMPORTING
      iv_nullable TYPE abap_bool.

  METHODS set_filterable
    IMPORTING
      iv_filterable TYPE abap_bool.

  METHODS set_is_key
    IMPORTING
      iv_key TYPE abap_bool DEFAULT abap_true.

ENDINTERFACE.
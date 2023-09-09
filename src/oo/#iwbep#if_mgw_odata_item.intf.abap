INTERFACE /iwbep/if_mgw_odata_item PUBLIC.

  METHODS set_label_from_text_element
    IMPORTING
      iv_text_element_symbol    TYPE textpoolky
      iv_text_element_container TYPE string OPTIONAL
    RAISING
      /iwbep/cx_mgw_med_exception.

ENDINTERFACE.
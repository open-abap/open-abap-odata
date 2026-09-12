INTERFACE /iwbep/if_mgw_odata_parameter PUBLIC.

  INTERFACES /iwbep/if_mgw_odata_property.

  ALIASES set_type_edm_string FOR /iwbep/if_mgw_odata_property~set_type_edm_string.
  ALIASES set_type_edm_int32 FOR /iwbep/if_mgw_odata_property~set_type_edm_int32.
  ALIASES set_type_edm_boolean FOR /iwbep/if_mgw_odata_property~set_type_edm_boolean.
  ALIASES set_type_edm_datetime FOR /iwbep/if_mgw_odata_property~set_type_edm_datetime.
  ALIASES set_type_edm_decimal FOR /iwbep/if_mgw_odata_property~set_type_edm_decimal.
  ALIASES set_maxlength FOR /iwbep/if_mgw_odata_property~set_maxlength.
  ALIASES set_nullable FOR /iwbep/if_mgw_odata_property~set_nullable.
  ALIASES set_precison FOR /iwbep/if_mgw_odata_property~set_precison.

  METHODS set_mode
    IMPORTING
      iv_mode TYPE string.

ENDINTERFACE.

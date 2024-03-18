INTERFACE /iwbep/if_mgw_med_odata_types PUBLIC.

  TYPES ty_e_med_entity_name   TYPE /iwbep/med_external_name.
  TYPES ty_e_med_internal_name TYPE c LENGTH 40.
  TYPES ty_e_med_http_method   TYPE c LENGTH 6.

  TYPES: BEGIN OF ty_s_mgw_odata_property,
           external_name TYPE /iwbep/med_external_name,
           name          TYPE ty_e_med_internal_name,
           property      TYPE REF TO /iwbep/if_mgw_odata_property,
         END OF ty_s_mgw_odata_property.
  TYPES ty_t_mgw_odata_properties TYPE STANDARD TABLE OF ty_s_mgw_odata_property WITH DEFAULT KEY.

  TYPES ty_e_med_edm_type TYPE c LENGTH 20.
  CONSTANTS: BEGIN OF gcs_edm_data_types,
               string TYPE ty_e_med_edm_type VALUE 'Edm.String',
             END OF gcs_edm_data_types.

  TYPES ty_e_med_cardinality TYPE c LENGTH 1.

ENDINTERFACE.
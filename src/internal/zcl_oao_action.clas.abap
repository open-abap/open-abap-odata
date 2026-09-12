CLASS zcl_oao_action DEFINITION PUBLIC.
* A function import as SEGW defines it: name, input parameters, what it
* returns and how it is called.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_odata_action.

    TYPES ty_parameters TYPE STANDARD TABLE OF REF TO zcl_oao_parameter WITH DEFAULT KEY.

    DATA mv_name                TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.
    DATA mv_return_entity_type  TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.
    DATA mv_return_entity_set   TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.
    DATA mv_return_complex_type TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.
    DATA mv_return_multiplicity TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_cardinality VALUE '1'.
    DATA mv_http_method         TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_http_method VALUE 'GET'.
    DATA mv_action_for          TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name.
    DATA mt_parameters          TYPE ty_parameters.
ENDCLASS.

CLASS zcl_oao_action IMPLEMENTATION.

  METHOD /iwbep/if_mgw_odata_action~create_input_parameter.
    DATA lo_parameter TYPE REF TO zcl_oao_parameter.

    CREATE OBJECT lo_parameter.
    lo_parameter->mv_name           = iv_parameter_name.
    lo_parameter->mv_abap_fieldname = iv_abap_fieldname.
    APPEND lo_parameter TO mt_parameters.
    ro_parameter = lo_parameter.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_action~set_return_entity_type.
    mv_return_entity_type = iv_data_object_name.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_action~set_return_entity_set.
    mv_return_entity_set = iv_entity_set_name.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_action~set_return_complex_type.
    mv_return_complex_type = iv_data_object_name.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_action~set_http_method.
    mv_http_method = iv_method_name.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_action~set_action_for.
    mv_action_for = iv_entity_type_name.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_action~set_return_multiplicity.
    mv_return_multiplicity = iv_cardinality.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_annotatabl~create_annotation.
    CREATE OBJECT ro_annotation TYPE zcl_oao_annotation.
  ENDMETHOD.

ENDCLASS.

CLASS /iwbep/cl_sb_gen_read_aftr_crt DEFINITION PUBLIC.
* The request context a generated DPC builds for the read after a create:
* the keys of the new entity and the entity set, then handed to get_entity.
* Two generations of SEGW templates call the setters differently: the
* current one set_keys( EXPORTING it_keys = lt_keys ), the 2013 one
* set_keys( IMPORTING et_keys = lt_keys ), an EXPORTING parameter read by
* reference. Both are served
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_req_entity.

    METHODS set_keys
      IMPORTING
        it_keys TYPE /iwbep/t_mgw_tech_pairs OPTIONAL
      EXPORTING
        et_keys TYPE /iwbep/t_mgw_tech_pairs.

    METHODS set_entityset_name
      IMPORTING
        iv_entityset_name TYPE csequence OPTIONAL
      EXPORTING
        ev_entityset_name TYPE string.

    METHODS set_entity_type_name
      IMPORTING
        iv_entity_name      TYPE csequence OPTIONAL
      EXPORTING
        ev_entity_type_name TYPE string.
  PRIVATE SECTION.
    DATA mt_keys             TYPE /iwbep/t_mgw_tech_pairs.
    DATA mv_entityset_name   TYPE string.
    DATA mv_entity_type_name TYPE string.
ENDCLASS.

CLASS /iwbep/cl_sb_gen_read_aftr_crt IMPLEMENTATION.

  METHOD set_keys.
    IF it_keys IS SUPPLIED.
      mt_keys = it_keys.
    ELSE.
      mt_keys = et_keys.
    ENDIF.
  ENDMETHOD.

  METHOD set_entityset_name.
    IF iv_entityset_name IS SUPPLIED.
      mv_entityset_name = iv_entityset_name.
    ELSE.
      mv_entityset_name = ev_entityset_name.
    ENDIF.
  ENDMETHOD.

  METHOD set_entity_type_name.
    IF iv_entity_name IS SUPPLIED.
      mv_entity_type_name = iv_entity_name.
    ELSE.
      mv_entity_type_name = ev_entity_type_name.
    ENDIF.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entity~get_entity_set_name.
    rv_entity_set = mv_entityset_name.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entity~get_entity_type_name.
    rv_entity_type = mv_entity_type_name.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entity~get_source_entity_set_name.
    rv_entity_set = mv_entityset_name.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entity~get_converted_keys.
    DATA ls_key TYPE /iwbep/s_mgw_tech_pair.
    FIELD-SYMBOLS <lv_field> TYPE any.

    CLEAR es_key_values.
    LOOP AT mt_keys INTO ls_key.
      ASSIGN COMPONENT ls_key-name OF STRUCTURE es_key_values TO <lv_field>.
      IF sy-subrc = 0.
        <lv_field> = ls_key-value.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entity~get_converted_source_keys.
    /iwbep/if_mgw_req_entity~get_converted_keys( IMPORTING es_key_values = es_key_values ).
  ENDMETHOD.

ENDCLASS.

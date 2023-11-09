CLASS zcl_oao_model DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_odata_model.
  PRIVATE SECTION.
    DATA mv_namespace TYPE string.

    TYPES: BEGIN OF ty_entity,
             entity_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name,
             entity      TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
           END OF ty_entity.
    DATA mt_entities TYPE HASHED TABLE OF ty_entity WITH UNIQUE KEY entity_name.
ENDCLASS.

CLASS zcl_oao_model IMPLEMENTATION.

  METHOD /iwbep/if_mgw_odata_model~create_association.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_model~create_association_set.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_model~create_entity_type.
    DATA ls_row LIKE LINE OF mt_entities.

    CREATE OBJECT ro_entity TYPE zcl_oao_entity_typ.

    ls_row-entity_name = iv_entity_type_name.
    ls_row-entity      = ro_entity.
    INSERT ls_row INTO TABLE mt_entities.
    ASSERT sy-subrc = 0.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_model~get_entity_type.
    FIELD-SYMBOLS <ls_entity> LIKE LINE OF mt_entities.
    READ TABLE mt_entities ASSIGNING <ls_entity> WITH TABLE KEY entity_name = iv_entity_name.
    ASSERT sy-subrc = 0.
    ro_entity_type = <ls_entity>-entity.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_model~set_schema_namespace.
    mv_namespace = iv_namespace.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_model~get_schema_namespace.
    ev_namespace = mv_namespace.
  ENDMETHOD.

ENDCLASS.
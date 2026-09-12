CLASS zcl_oao_model DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_odata_model.

    TYPES ty_entity_names TYPE STANDARD TABLE OF /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name WITH DEFAULT KEY.

    TYPES ty_associations TYPE STANDARD TABLE OF REF TO zcl_oao_association WITH DEFAULT KEY.
    TYPES ty_assoc_sets   TYPE STANDARD TABLE OF REF TO zcl_oao_assoc_set WITH DEFAULT KEY.
    TYPES ty_actions      TYPE STANDARD TABLE OF REF TO zcl_oao_action WITH DEFAULT KEY.

    METHODS get_entity_type_names
      RETURNING
        VALUE(rt_names) TYPE ty_entity_names.

    METHODS get_associations
      RETURNING
        VALUE(rt_associations) TYPE ty_associations.

    METHODS get_association_sets
      RETURNING
        VALUE(rt_sets) TYPE ty_assoc_sets.

    METHODS get_actions
      RETURNING
        VALUE(rt_actions) TYPE ty_actions.
  PRIVATE SECTION.
    DATA mv_namespace TYPE string.
    DATA mt_entity_names TYPE ty_entity_names.
    DATA mt_associations TYPE ty_associations.
    DATA mt_assoc_sets   TYPE ty_assoc_sets.
    DATA mt_actions      TYPE ty_actions.

    TYPES: BEGIN OF ty_entity,
             entity_name TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name,
             entity      TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
           END OF ty_entity.
    DATA mt_entities TYPE HASHED TABLE OF ty_entity WITH UNIQUE KEY entity_name.
ENDCLASS.

CLASS zcl_oao_model IMPLEMENTATION.
  METHOD /iwbep/if_mgw_odata_model~create_action.
    DATA lo_action TYPE REF TO zcl_oao_action.

    CREATE OBJECT lo_action.
    lo_action->mv_name = iv_action_name.
    APPEND lo_action TO mt_actions.
    ro_action = lo_action.
  ENDMETHOD.

  METHOD get_actions.
    rt_actions = mt_actions.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_model~create_association.
    DATA lo_association TYPE REF TO zcl_oao_association.

    CREATE OBJECT lo_association.
    lo_association->mv_name       = iv_association_name.
    lo_association->mv_left_type  = iv_left_type.
    lo_association->mv_right_type = iv_right_type.
    lo_association->mv_left_card  = iv_left_card.
    lo_association->mv_right_card = iv_right_card.
    APPEND lo_association TO mt_associations.
    ro_association = lo_association.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_model~create_association_set.
    DATA lo_set TYPE REF TO zcl_oao_assoc_set.

    CREATE OBJECT lo_set.
    lo_set->mv_name        = iv_association_set_name.
    lo_set->mv_association = iv_association_name.
    lo_set->mv_left_set    = iv_left_entity_set_name.
    lo_set->mv_right_set   = iv_right_entity_set_name.
    APPEND lo_set TO mt_assoc_sets.
    ro_association_set = lo_set.
  ENDMETHOD.

  METHOD get_associations.
    rt_associations = mt_associations.
  ENDMETHOD.

  METHOD get_association_sets.
    rt_sets = mt_assoc_sets.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_model~create_entity_type.
    DATA ls_row LIKE LINE OF mt_entities.

    CREATE OBJECT ro_entity TYPE zcl_oao_entity_typ.

    ls_row-entity_name = iv_entity_type_name.
    ls_row-entity      = ro_entity.
    INSERT ls_row INTO TABLE mt_entities.
    ASSERT sy-subrc = 0.
    APPEND iv_entity_type_name TO mt_entity_names.
  ENDMETHOD.

  METHOD get_entity_type_names.
    rt_names = mt_entity_names.
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
CLASS zcl_entity_typ DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_odata_entity_typ.

  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_entity_typ IMPLEMENTATION.

  METHOD /iwbep/if_mgw_odata_entity_typ~create_entity_set.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_entity_typ~bind_structure.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_entity_typ~create_property.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
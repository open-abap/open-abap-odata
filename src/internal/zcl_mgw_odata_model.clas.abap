CLASS zcl_mgw_odata_model DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_odata_model.
  PRIVATE SECTION.
    DATA mv_namespace TYPE string.
ENDCLASS.

CLASS zcl_mgw_odata_model IMPLEMENTATION.

  METHOD /iwbep/if_mgw_odata_model~create_entity_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_model~get_entity_type.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_model~set_schema_namespace.
    mv_namespace = iv_namespace.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_model~get_schema_namespace.
    ev_namespace = mv_namespace.
  ENDMETHOD.

ENDCLASS.
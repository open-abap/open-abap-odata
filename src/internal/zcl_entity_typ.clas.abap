CLASS zcl_entity_typ DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_odata_entity_typ.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_property,
             name     TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name,
             property TYPE REF TO /iwbep/if_mgw_odata_property,
           END OF ty_property.
    DATA mt_properties TYPE HASHED TABLE OF ty_property WITH UNIQUE KEY name.
ENDCLASS.

CLASS zcl_entity_typ IMPLEMENTATION.

  METHOD /iwbep/if_mgw_odata_entity_typ~create_entity_set.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_entity_typ~bind_structure.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_entity_typ~create_property.
    DATA ls_row LIKE LINE OF mt_properties.

    CREATE OBJECT ro_property TYPE zcl_property.

    ls_row-name = iv_property_name.
    ls_row-property = ro_property.
    INSERT ls_row INTO TABLE mt_properties.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_entity_typ~get_property.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_odata_entity_typ~get_properties.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
INTERFACE if_sadl_public_types PUBLIC.

  TYPES: BEGIN OF ty_parameter,
           name  TYPE string,
           value TYPE string,
         END OF ty_parameter.
  TYPES tt_parameters TYPE STANDARD TABLE OF ty_parameter WITH DEFAULT KEY.

  TYPES: BEGIN OF ty_entity_parameters,
          entity_alias TYPE string,
          parameters   TYPE tt_parameters,
        END OF ty_entity_parameters.
  TYPES tt_entity_parameters TYPE STANDARD TABLE OF ty_entity_parameters WITH DEFAULT KEY.

ENDINTERFACE.
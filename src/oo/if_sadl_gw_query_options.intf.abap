INTERFACE if_sadl_gw_query_options PUBLIC.

  METHODS set_entity_parameters
    IMPORTING
      it_parameters TYPE if_sadl_public_types=>tt_entity_parameters.

ENDINTERFACE.
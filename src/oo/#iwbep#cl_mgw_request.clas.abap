CLASS /iwbep/cl_mgw_request DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES /iwbep/if_mgw_req_entity.
    INTERFACES /iwbep/if_mgw_req_entityset.
    INTERFACES /iwbep/if_mgw_req_entity_c.
    INTERFACES /iwbep/if_mgw_req_entity_d.
    INTERFACES /iwbep/if_mgw_req_entity_p.
    INTERFACES /iwbep/if_mgw_req_entity_u.
    INTERFACES /iwbep/if_mgw_req_func_import.

    METHODS get_request_details
      RETURNING
        VALUE(rs_request) TYPE /iwbep/if_mgw_core_srv_runtime=>ty_s_mgw_request_context.

ENDCLASS.

CLASS /iwbep/cl_mgw_request IMPLEMENTATION.
  METHOD get_request_details.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entity~get_entity_set_name.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entity~get_entity_type_name.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entityset~get_entity_set_name.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entityset~get_top.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entityset~get_skip.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entityset~get_converted_source_keys.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entityset~get_filter.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entityset~has_inlinecount.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entityset~has_count.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entity_c~get_entity_set_name.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entity_d~get_entity_set_name.
    RETURN.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_req_entity_u~get_entity_set_name.
    RETURN.
  ENDMETHOD.

ENDCLASS.
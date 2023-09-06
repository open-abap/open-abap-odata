INTERFACE /iwbep/if_mgw_odata_entity_set PUBLIC.

  METHODS set_creatable
    IMPORTING
      iv_creatable TYPE abap_bool.

  METHODS set_updatable
    IMPORTING
      iv_updatable TYPE abap_bool.

  METHODS set_deletable
    IMPORTING
      iv_deletable TYPE abap_bool.

  METHODS set_pageable
    IMPORTING
      iv_pageable TYPE abap_bool.

  METHODS set_addressable
    IMPORTING
      iv_addressable TYPE abap_bool.

  METHODS set_has_ftxt_search
    IMPORTING
      iv_fsearch TYPE abap_bool.

  METHODS set_subscribable
    IMPORTING
      iv_subscribable TYPE abap_bool.

  METHODS set_filter_required
    IMPORTING
      iv_req_filter TYPE abap_bool.

ENDINTERFACE.
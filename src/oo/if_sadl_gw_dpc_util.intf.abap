INTERFACE if_sadl_gw_dpc_util PUBLIC.

  METHODS get_dpc
    RETURNING
      VALUE(ro_dpc) TYPE REF TO if_sadl_gw_dpc
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception.

ENDINTERFACE.
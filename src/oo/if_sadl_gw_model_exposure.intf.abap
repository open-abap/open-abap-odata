INTERFACE if_sadl_gw_model_exposure PUBLIC.

  METHODS expose
    IMPORTING
      io_model           TYPE REF TO /iwbep/if_mgw_odata_model
    RETURNING
      VALUE(ro_exposure) TYPE REF TO if_sadl_gw_model_exposure
    RAISING
      cx_sadl_exposure_error.

  METHODS expose_vocabulary
    IMPORTING
      io_vocan_model TYPE REF TO /iwbep/if_mgw_vocan_model OPTIONAL
    RAISING
      cx_sadl_exposure_error.

ENDINTERFACE.

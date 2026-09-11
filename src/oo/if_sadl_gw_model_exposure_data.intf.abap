INTERFACE if_sadl_gw_model_exposure_data PUBLIC.

  METHODS get_model_exposure
    RETURNING
      VALUE(ro_model_exposure) TYPE REF TO if_sadl_gw_model_exposure
    RAISING
      cx_sadl_exposure_error.

ENDINTERFACE.

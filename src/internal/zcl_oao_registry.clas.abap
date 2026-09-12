CLASS zcl_oao_registry DEFINITION PUBLIC CREATE PUBLIC.
* Maps a service name (the segment after /sap/opu/odata/sap/) to the MPC and
* DPC classes that implement it, so the HTTP handler can instantiate them
* dynamically instead of naming one concrete class.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_service,
             service TYPE string,
             mpc     TYPE string,
             dpc     TYPE string,
           END OF ty_service.

    CLASS-METHODS register
      IMPORTING
        iv_service TYPE string
        iv_mpc     TYPE string
        iv_dpc     TYPE string.

    CLASS-METHODS get
      IMPORTING
        iv_service        TYPE string
      RETURNING
        VALUE(rs_service) TYPE ty_service
      RAISING
        /iwbep/cx_mgw_tech_exception.

    CLASS-METHODS create_mpc
      IMPORTING
        iv_service    TYPE string
      RETURNING
        VALUE(ro_mpc) TYPE REF TO /iwbep/cl_mgw_push_abs_model
      RAISING
        /iwbep/cx_mgw_tech_exception.

    CLASS-METHODS create_dpc
      IMPORTING
        iv_service    TYPE string
      RETURNING
        VALUE(ro_dpc) TYPE REF TO /iwbep/if_mgw_appl_srv_runtime
      RAISING
        /iwbep/cx_mgw_tech_exception.

    CLASS-METHODS clear.
  PRIVATE SECTION.
    CLASS-DATA gt_services TYPE HASHED TABLE OF ty_service WITH UNIQUE KEY service.
ENDCLASS.

CLASS zcl_oao_registry IMPLEMENTATION.

  METHOD register.
    DATA ls_service TYPE ty_service.

    ls_service-service = to_upper( iv_service ).
    ls_service-mpc     = to_upper( iv_mpc ).
    ls_service-dpc     = to_upper( iv_dpc ).

    DELETE gt_services WHERE service = ls_service-service.
    INSERT ls_service INTO TABLE gt_services.
  ENDMETHOD.

  METHOD get.
    READ TABLE gt_services INTO rs_service WITH TABLE KEY service = to_upper( iv_service ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDIF.
  ENDMETHOD.

  METHOD create_mpc.
    DATA ls_service TYPE ty_service.

    ls_service = get( iv_service ).
    CREATE OBJECT ro_mpc TYPE (ls_service-mpc).
  ENDMETHOD.

  METHOD create_dpc.
    DATA ls_service TYPE ty_service.

    ls_service = get( iv_service ).
    CREATE OBJECT ro_dpc TYPE (ls_service-dpc).
  ENDMETHOD.

  METHOD clear.
    CLEAR gt_services.
  ENDMETHOD.

ENDCLASS.

CLASS /iwfnd/cl_sodata_http_handler DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_http_extension.
  PRIVATE SECTION.
    METHODS metadata RAISING /iwbep/cx_mgw_med_exception.
ENDCLASS.

CLASS /iwfnd/cl_sodata_http_handler IMPLEMENTATION.

  METHOD if_http_extension~handle_request.
    TRY.
        metadata( ).
      CATCH /iwbep/cx_mgw_med_exception.
        WRITE / 'exception'.
    ENDTRY.

    server->response->set_header_field(
      name  = 'content-type'
      value = 'text/plain' ).
    server->response->set_cdata( 'hello' ).
    server->response->set_status(
      code   = 200
      reason = 'Success' ).

  ENDMETHOD.

  METHOD metadata.
    DATA mpc TYPE REF TO zcl_zsegw_mpc_ext.
    CREATE OBJECT mpc.

    mpc->define( ).
  ENDMETHOD.

ENDCLASS.
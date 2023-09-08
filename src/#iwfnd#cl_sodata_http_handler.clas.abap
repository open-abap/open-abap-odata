CLASS /iwfnd/cl_sodata_http_handler DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_http_extension.
ENDCLASS.

CLASS /iwfnd/cl_sodata_http_handler IMPLEMENTATION.

  METHOD if_http_extension~handle_request.
    server->response->set_header_field(
      name  = 'content-type'
      value = 'text/plain' ).
    server->response->set_cdata( 'hello' ).
    server->response->set_status(
      code   = 200
      reason = 'Success' ).
  ENDMETHOD.

ENDCLASS.
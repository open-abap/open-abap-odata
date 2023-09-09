CLASS /iwfnd/cl_sodata_http_handler DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_http_extension.

ENDCLASS.

CLASS /iwfnd/cl_sodata_http_handler IMPLEMENTATION.

  METHOD if_http_extension~handle_request.

    DATA lv_path  TYPE string.
    DATA ls_data  TYPE zcl_http_handler=>ty_data.
    DATA lx_error TYPE REF TO cx_static_check.

    lv_path = server->request->get_header_field( '~path' ).

    TRY.
        ls_data = zcl_http_handler=>handle( lv_path ).
        server->response->set_header_field(
          name  = 'content-type'
          value = ls_data-content_type ).
        server->response->set_cdata( ls_data-data ).
        server->response->set_status(
          code   = 200
          reason = 'Success' ).
      CATCH cx_static_check INTO lx_error.
        server->response->set_status(
          code   = 500
          reason = lx_error->get_text( ) ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
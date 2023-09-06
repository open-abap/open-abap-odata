CLASS /iwfnd/cl_sodata_http_handler DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_http_extension.
ENDCLASS.

CLASS /iwfnd/cl_sodata_http_handler IMPLEMENTATION.

  METHOD if_http_extension~handle_request.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

ENDCLASS.
INTERFACE /iwbep/if_mgw_core_srv_runtime PUBLIC.

  TYPES ty_s_media_resource TYPE /iwbep/if_mgw_core_types=>ty_s_media_resource.

  METHODS init
    IMPORTING
      iv_service_document_name TYPE string
      iv_namespace             TYPE string
      iv_version               TYPE string
      io_context               TYPE string.

ENDINTERFACE.
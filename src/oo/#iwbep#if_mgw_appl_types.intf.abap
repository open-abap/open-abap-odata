INTERFACE /iwbep/if_mgw_appl_types PUBLIC.

  TYPES: BEGIN OF ty_s_media_resource,
           mime_type TYPE string,
           value     TYPE xstring,
         END OF ty_s_media_resource.

ENDINTERFACE.
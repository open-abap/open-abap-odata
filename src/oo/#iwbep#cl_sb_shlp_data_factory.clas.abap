CLASS /iwbep/cl_sb_shlp_data_factory DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS get_sh_data_obj
      RETURNING
        VALUE(ro_sh_data) TYPE REF TO /iwbep/if_sb_shlp_data.
ENDCLASS.

CLASS /iwbep/cl_sb_shlp_data_factory IMPLEMENTATION.

  METHOD get_sh_data_obj.
    CREATE OBJECT ro_sh_data TYPE zcl_oao_shlp_data.
  ENDMETHOD.

ENDCLASS.

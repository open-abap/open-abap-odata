CLASS zcl_oao_shlp_ddic DEFINITION PUBLIC CREATE PUBLIC.
* A search help as the DDIC defines it (DD30V and DD32P of the abapGit
* <name>.shlp.xml): the selection method, a table or view, and the
* parameters with their input/output flags and positions. Runs the
* selection over the transpiled database and answers the generated DPC in
* the record / field / value rows of /iwbep/if_sb_gendpc_shlp_data.
* Selection by exit function (SELMEXIT) and collective search helps are
* not served yet; they come back as an E message.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_sb_gendpc_shlp_data.

    TYPES: BEGIN OF ty_parameter,
             name            TYPE string,
             input           TYPE abap_bool,
             output          TYPE abap_bool,
             list_position   TYPE i,
             select_position TYPE i,
           END OF ty_parameter.
    TYPES ty_parameters TYPE STANDARD TABLE OF ty_parameter WITH DEFAULT KEY.

    DATA mv_shlp_name  TYPE string READ-ONLY.
    DATA mv_selmethod  TYPE string READ-ONLY.
    DATA mv_selmexit   TYPE string READ-ONLY.
    DATA mv_texttab    TYPE string READ-ONLY.
    DATA mt_parameters TYPE ty_parameters READ-ONLY.

    CLASS-METHODS create
      IMPORTING
        iv_shlp_name   TYPE csequence
        iv_selmethod   TYPE csequence OPTIONAL
        iv_selmexit    TYPE csequence OPTIONAL
        iv_texttab     TYPE csequence OPTIONAL
      RETURNING
        VALUE(ro_shlp) TYPE REF TO zcl_oao_shlp_ddic.

    METHODS add_parameter
      IMPORTING
        iv_name            TYPE csequence
        iv_input           TYPE abap_bool DEFAULT abap_true
        iv_output          TYPE abap_bool DEFAULT abap_true
        iv_list_position   TYPE i DEFAULT 0
        iv_select_position TYPE i DEFAULT 0
      RETURNING
        VALUE(ro_shlp)     TYPE REF TO zcl_oao_shlp_ddic.

* makes this definition the provider of its name in zcl_oao_shlp_data
    METHODS register
      RETURNING
        VALUE(ro_shlp) TYPE REF TO zcl_oao_shlp_ddic.

* the list fields in their order, what a value help shows
    METHODS get_output_parameters
      RETURNING
        VALUE(rt_parameters) TYPE ty_parameters.

* the WHERE clause the selection options of a request amount to
    METHODS where_clause
      IMPORTING
        it_selopt       TYPE ddshselops
      RETURNING
        VALUE(rv_where) TYPE string.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_sorted,
             key   TYPE string,
             index TYPE i,
           END OF ty_sorted.
    TYPES ty_sorted_tab TYPE STANDARD TABLE OF ty_sorted WITH DEFAULT KEY.

    METHODS condition
      IMPORTING
        is_selopt      TYPE ddshselopt
      RETURNING
        VALUE(rv_cond) TYPE string.

    METHODS literal
      IMPORTING
        iv_value          TYPE csequence
        iv_pattern        TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(rv_literal) TYPE string.
ENDCLASS.

CLASS zcl_oao_shlp_ddic IMPLEMENTATION.

  METHOD create.
    CREATE OBJECT ro_shlp.
    ro_shlp->mv_shlp_name = to_upper( iv_shlp_name ).
    ro_shlp->mv_selmethod = to_upper( iv_selmethod ).
    ro_shlp->mv_selmexit  = to_upper( iv_selmexit ).
    ro_shlp->mv_texttab   = to_upper( iv_texttab ).
  ENDMETHOD.

  METHOD add_parameter.
    DATA ls_parameter TYPE ty_parameter.

    ls_parameter-name            = to_upper( iv_name ).
    ls_parameter-input           = iv_input.
    ls_parameter-output          = iv_output.
    ls_parameter-list_position   = iv_list_position.
    ls_parameter-select_position = iv_select_position.
    APPEND ls_parameter TO mt_parameters.
    ro_shlp = me.
  ENDMETHOD.

  METHOD register.
    zcl_oao_shlp_data=>register( iv_shlp_name = mv_shlp_name
                                 io_provider  = me ).
    ro_shlp = me.
  ENDMETHOD.

  METHOD get_output_parameters.
    DATA ls_parameter TYPE ty_parameter.
    DATA lv_position  TYPE i.

    LOOP AT mt_parameters INTO ls_parameter WHERE output = abap_true.
      lv_position = lv_position + 1.
      IF ls_parameter-list_position = 0.
        ls_parameter-list_position = 1000 + lv_position.
      ENDIF.
      APPEND ls_parameter TO rt_parameters.
    ENDLOOP.
    SORT rt_parameters BY list_position.
  ENDMETHOD.

  METHOD literal.
    DATA lv_value TYPE string.

    lv_value = iv_value.
    REPLACE ALL OCCURRENCES OF `'` IN lv_value WITH `''`.
    IF iv_pattern = abap_true.
      REPLACE ALL OCCURRENCES OF '*' IN lv_value WITH '%'.
      REPLACE ALL OCCURRENCES OF '+' IN lv_value WITH '_'.
    ENDIF.
    rv_literal = |'{ lv_value }'|.
  ENDMETHOD.

  METHOD condition.
    DATA lv_field TYPE string.

    lv_field = to_lower( is_selopt-shlpfield ).
    CASE is_selopt-option.
      WHEN 'EQ' OR ''.
        rv_cond = |{ lv_field } = { literal( is_selopt-low ) }|.
      WHEN 'NE'.
        rv_cond = |{ lv_field } <> { literal( is_selopt-low ) }|.
      WHEN 'GT'.
        rv_cond = |{ lv_field } > { literal( is_selopt-low ) }|.
      WHEN 'GE'.
        rv_cond = |{ lv_field } >= { literal( is_selopt-low ) }|.
      WHEN 'LT'.
        rv_cond = |{ lv_field } < { literal( is_selopt-low ) }|.
      WHEN 'LE'.
        rv_cond = |{ lv_field } <= { literal( is_selopt-low ) }|.
      WHEN 'BT'.
        rv_cond = |{ lv_field } BETWEEN { literal( is_selopt-low ) } AND { literal( is_selopt-high ) }|.
      WHEN 'NB'.
        rv_cond = |{ lv_field } NOT BETWEEN { literal( is_selopt-low ) } AND { literal( is_selopt-high ) }|.
      WHEN 'CP'.
        rv_cond = |{ lv_field } LIKE { literal( iv_value   = is_selopt-low
                                                iv_pattern = abap_true ) }|.
      WHEN 'NP'.
        rv_cond = |{ lv_field } NOT LIKE { literal( iv_value   = is_selopt-low
                                                    iv_pattern = abap_true ) }|.
      WHEN OTHERS.
        rv_cond = |{ lv_field } = { literal( is_selopt-low ) }|.
    ENDCASE.
    IF is_selopt-sign = 'E'.
      rv_cond = |NOT ( { rv_cond } )|.
    ENDIF.
  ENDMETHOD.

  METHOD where_clause.
* per field: the I lines OR-ed, the E lines AND-ed, fields AND-ed
    DATA lt_selopt  TYPE ddshselops.
    DATA ls_selopt  TYPE ddshselopt.
    DATA lv_field   TYPE string.
    DATA lv_include TYPE string.
    DATA lv_exclude TYPE string.
    DATA lv_part    TYPE string.

    lt_selopt = it_selopt.
    SORT lt_selopt BY shlpfield.
    LOOP AT lt_selopt INTO ls_selopt.
      IF ls_selopt-shlpfield <> lv_field.
        IF lv_include IS NOT INITIAL OR lv_exclude IS NOT INITIAL.
          lv_part = lv_include.
          IF lv_include IS NOT INITIAL AND lv_exclude IS NOT INITIAL.
            lv_part = |( { lv_include } ) AND { lv_exclude }|.
          ELSEIF lv_exclude IS NOT INITIAL.
            lv_part = lv_exclude.
          ENDIF.
          IF rv_where IS NOT INITIAL.
            rv_where = |{ rv_where } AND |.
          ENDIF.
          rv_where = |{ rv_where }( { lv_part } )|.
        ENDIF.
        CLEAR: lv_include, lv_exclude.
        lv_field = ls_selopt-shlpfield.
      ENDIF.
      IF ls_selopt-sign = 'E'.
        IF lv_exclude IS NOT INITIAL.
          lv_exclude = |{ lv_exclude } AND |.
        ENDIF.
        lv_exclude = |{ lv_exclude }{ condition( ls_selopt ) }|.
      ELSE.
        IF lv_include IS NOT INITIAL.
          lv_include = |{ lv_include } OR |.
        ENDIF.
        lv_include = |{ lv_include }{ condition( ls_selopt ) }|.
      ENDIF.
    ENDLOOP.
    IF lv_include IS NOT INITIAL OR lv_exclude IS NOT INITIAL.
      lv_part = lv_include.
      IF lv_include IS NOT INITIAL AND lv_exclude IS NOT INITIAL.
        lv_part = |( { lv_include } ) AND { lv_exclude }|.
      ELSEIF lv_exclude IS NOT INITIAL.
        lv_part = lv_exclude.
      ENDIF.
      IF rv_where IS NOT INITIAL.
        rv_where = |{ rv_where } AND |.
      ENDIF.
      rv_where = |{ rv_where }( { lv_part } )|.
    ENDIF.
  ENDMETHOD.

  METHOD /iwbep/if_sb_gendpc_shlp_data~get_search_help_values.
    DATA lt_output   TYPE ty_parameters.
    DATA ls_output   TYPE ty_parameter.
    DATA lv_where    TYPE string.
    DATA lr_rows     TYPE REF TO data.
    DATA lt_sorted   TYPE ty_sorted_tab.
    DATA ls_sorted   TYPE ty_sorted.
    DATA lv_record   TYPE i.
    DATA ls_result   LIKE LINE OF et_return_list.
    FIELD-SYMBOLS <lt_rows>  TYPE STANDARD TABLE.
    FIELD-SYMBOLS <ls_row>   TYPE any.
    FIELD-SYMBOLS <lv_value> TYPE any.

    CLEAR: et_return_list, es_message.
    IF mv_selmethod IS INITIAL.
      es_message-type    = 'E'.
      es_message-message = |Search help { mv_shlp_name }: selection through exit function { mv_selmexit } is not served here yet|.
      RETURN.
    ENDIF.

    lt_output = get_output_parameters( ).
    IF lt_output IS INITIAL.
      es_message-type    = 'E'.
      es_message-message = |Search help { mv_shlp_name } has no output parameters|.
      RETURN.
    ENDIF.
    lv_where = where_clause( it_selopt ).

    CREATE DATA lr_rows TYPE STANDARD TABLE OF (mv_selmethod).
    ASSIGN lr_rows->* TO <lt_rows>.
    IF lv_where IS INITIAL.
      lv_where = '1 = 1'.
    ENDIF.
    SELECT * FROM (mv_selmethod)
      INTO CORRESPONDING FIELDS OF TABLE <lt_rows>
      WHERE (lv_where)
      ORDER BY PRIMARY KEY.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

* sort by the list fields, then cut to iv_maxrows
    LOOP AT <lt_rows> ASSIGNING <ls_row>.
      CLEAR ls_sorted.
      ls_sorted-index = sy-tabix.
      LOOP AT lt_output INTO ls_output.
        ASSIGN COMPONENT ls_output-name OF STRUCTURE <ls_row> TO <lv_value>.
        IF sy-subrc = 0.
          ls_sorted-key = |{ ls_sorted-key }{ <lv_value> }\||.
        ENDIF.
      ENDLOOP.
      APPEND ls_sorted TO lt_sorted.
    ENDLOOP.
    IF iv_sort = abap_true.
      SORT lt_sorted BY key.
    ENDIF.

    LOOP AT lt_sorted INTO ls_sorted.
      lv_record = lv_record + 1.
      IF iv_maxrows > 0 AND lv_record > iv_maxrows.
        EXIT.
      ENDIF.
      READ TABLE <lt_rows> INDEX ls_sorted-index ASSIGNING <ls_row>.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      LOOP AT lt_output INTO ls_output.
        ASSIGN COMPONENT ls_output-name OF STRUCTURE <ls_row> TO <lv_value>.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
        ls_result-record_number = lv_record.
        ls_result-field_name    = ls_output-name.
        ls_result-field_value   = <lv_value>.
        APPEND ls_result TO et_return_list.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

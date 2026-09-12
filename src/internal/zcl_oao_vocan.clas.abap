CLASS zcl_oao_vocan DEFINITION PUBLIC CREATE PUBLIC.
* One node of a vocabulary annotation tree: the annotations target, an
* annotation, a record, a record property, a collection or a simple value.
* The same class plays every role; the interfaces limit what each role
* offers. render( ) writes the node as the CSDL XML $metadata carries.
  PUBLIC SECTION.
    INTERFACES /iwbep/if_mgw_vocan_ann_target.
    INTERFACES /iwbep/if_mgw_vocan_annotation.
    INTERFACES /iwbep/if_mgw_vocan_record.
    INTERFACES /iwbep/if_mgw_vocan_property.
    INTERFACES /iwbep/if_mgw_vocan_collection.
    INTERFACES /iwbep/if_mgw_vocan_simple_val.

    CONSTANTS: BEGIN OF gc_kind,
                 target     TYPE c LENGTH 1 VALUE 'T',
                 annotation TYPE c LENGTH 1 VALUE 'A',
                 record     TYPE c LENGTH 1 VALUE 'R',
                 property   TYPE c LENGTH 1 VALUE 'P',
                 collection TYPE c LENGTH 1 VALUE 'C',
                 value      TYPE c LENGTH 1 VALUE 'V',
               END OF gc_kind.

    TYPES ty_nodes TYPE STANDARD TABLE OF REF TO zcl_oao_vocan WITH DEFAULT KEY.

    METHODS constructor
      IMPORTING
        iv_kind      TYPE c
        iv_name      TYPE string OPTIONAL
        iv_qualifier TYPE string OPTIONAL.

    METHODS render
      IMPORTING
        iv_indent     TYPE string DEFAULT ''
      RETURNING
        VALUE(rv_xml) TYPE string.

  PRIVATE SECTION.
    DATA mv_kind       TYPE c LENGTH 1.
* the target, term, record type or property name
    DATA mv_name       TYPE string.
    DATA mv_qualifier  TYPE string.
* String, Path, PropertyPath, Bool, Int, Decimal, EnumMember...
    DATA mv_value_kind TYPE string.
    DATA mv_value      TYPE string.
    DATA mt_children   TYPE ty_nodes.

    METHODS child
      IMPORTING
        iv_kind        TYPE c
        iv_name        TYPE string OPTIONAL
        iv_qualifier   TYPE string OPTIONAL
      RETURNING
        VALUE(ro_node) TYPE REF TO zcl_oao_vocan.

    METHODS set_value
      IMPORTING
        iv_kind  TYPE string
        iv_value TYPE string.

    METHODS simple_value_attribute
      RETURNING
        VALUE(rv_attribute) TYPE string.

    CLASS-METHODS xml_escape
      IMPORTING
        iv_text        TYPE string
      RETURNING
        VALUE(rv_text) TYPE string.
ENDCLASS.

CLASS zcl_oao_vocan IMPLEMENTATION.

  METHOD constructor.
    mv_kind      = iv_kind.
    mv_name      = iv_name.
    mv_qualifier = iv_qualifier.
  ENDMETHOD.

  METHOD child.
    CREATE OBJECT ro_node
      EXPORTING
        iv_kind      = iv_kind
        iv_name      = iv_name
        iv_qualifier = iv_qualifier.
    APPEND ro_node TO mt_children.
  ENDMETHOD.

  METHOD set_value.
    mv_value_kind = iv_kind.
    mv_value      = iv_value.
  ENDMETHOD.

  METHOD xml_escape.
    rv_text = iv_text.
    REPLACE ALL OCCURRENCES OF '&' IN rv_text WITH '&amp;'.
    REPLACE ALL OCCURRENCES OF '<' IN rv_text WITH '&lt;'.
    REPLACE ALL OCCURRENCES OF '>' IN rv_text WITH '&gt;'.
    REPLACE ALL OCCURRENCES OF '"' IN rv_text WITH '&quot;'.
  ENDMETHOD.

* ---- target

  METHOD /iwbep/if_mgw_vocan_ann_target~create_annotation.
    ro_annotation = child(
      iv_kind      = gc_kind-annotation
      iv_name      = iv_term
      iv_qualifier = iv_qualifier ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_ann_target~set_namespace.
    RETURN.
  ENDMETHOD.

* ---- annotation

  METHOD /iwbep/if_mgw_vocan_annotation~create_simple_value.
    ro_simple_value = child( gc_kind-value ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_annotation~create_record.
    ro_record = child( iv_kind = gc_kind-record
                       iv_name = iv_record_type ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_annotation~create_collection.
    ro_collection = child( gc_kind-collection ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_annotation~create_annotation.
    ro_annotation = child(
      iv_kind      = gc_kind-annotation
      iv_name      = iv_term
      iv_qualifier = iv_qualifier ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_annotation~set_value_list_et_name.
    RETURN.
  ENDMETHOD.

* ---- record

  METHOD /iwbep/if_mgw_vocan_record~create_property.
    ro_property = child( iv_kind = gc_kind-property
                         iv_name = iv_property_name ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_record~create_annotation.
    ro_annotation = child(
      iv_kind      = gc_kind-annotation
      iv_name      = iv_term
      iv_qualifier = iv_qualifier ).
  ENDMETHOD.

* ---- property

  METHOD /iwbep/if_mgw_vocan_property~create_simple_value.
    ro_simple_value = child( gc_kind-value ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_property~create_record.
    ro_record = child( iv_kind = gc_kind-record
                       iv_name = iv_record_type ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_property~create_collection.
    ro_collection = child( gc_kind-collection ).
  ENDMETHOD.

* ---- collection

  METHOD /iwbep/if_mgw_vocan_collection~create_record.
    ro_record = child( iv_kind = gc_kind-record
                       iv_name = iv_record_type ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_collection~create_simple_value.
    ro_simple_value = child( gc_kind-value ).
  ENDMETHOD.

* ---- simple value

  METHOD /iwbep/if_mgw_vocan_simple_val~set_string.
    set_value( iv_kind  = 'String'
               iv_value = iv_value ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_simple_val~set_path.
    set_value( iv_kind  = 'Path'
               iv_value = iv_value ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_simple_val~set_property_path.
    set_value( iv_kind  = 'PropertyPath'
               iv_value = iv_value ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_simple_val~set_navigation_property_path.
    set_value( iv_kind  = 'NavigationPropertyPath'
               iv_value = iv_value ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_simple_val~set_annotation_path.
    set_value( iv_kind  = 'AnnotationPath'
               iv_value = iv_value ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_simple_val~set_boolean.
    IF iv_value = abap_true.
      set_value( iv_kind  = 'Bool'
                 iv_value = 'true' ).
    ELSE.
      set_value( iv_kind  = 'Bool'
                 iv_value = 'false' ).
    ENDIF.
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_simple_val~set_int.
    set_value( iv_kind  = 'Int'
               iv_value = |{ iv_value }| ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_simple_val~set_decimal.
    set_value( iv_kind  = 'Decimal'
               iv_value = iv_value ).
  ENDMETHOD.

  METHOD /iwbep/if_mgw_vocan_simple_val~set_enum_member_by_name.
    set_value( iv_kind  = 'EnumMember'
               iv_value = iv_enum_member_name ).
  ENDMETHOD.

* ---- rendering

  METHOD simple_value_attribute.
* the one simple value among the children becomes an attribute of this
* element (Annotation Term="..." Path="x", PropertyValue Property="..." String="x")
    DATA lo_child TYPE REF TO zcl_oao_vocan.

    LOOP AT mt_children INTO lo_child.
      IF lo_child->mv_kind = gc_kind-value AND lo_child->mv_value_kind IS NOT INITIAL.
        rv_attribute = | { lo_child->mv_value_kind }="{ xml_escape( lo_child->mv_value ) }"|.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD render.
    DATA lo_child   TYPE REF TO zcl_oao_vocan.
    DATA lv_inner   TYPE string.
    DATA lv_indent  TYPE string.
    DATA lv_tag     TYPE string.
    DATA lv_open    TYPE string.

    lv_indent = |{ iv_indent }  |.
    CASE mv_kind.
      WHEN gc_kind-target.
        lv_tag  = 'Annotations'.
        lv_open = |<Annotations xmlns="http://docs.oasis-open.org/odata/ns/edm" Target="{ xml_escape( mv_name ) }"|.
        IF mv_qualifier IS NOT INITIAL.
          lv_open = |{ lv_open } Qualifier="{ xml_escape( mv_qualifier ) }"|.
        ENDIF.
      WHEN gc_kind-annotation.
        lv_tag  = 'Annotation'.
        lv_open = |<Annotation Term="{ xml_escape( mv_name ) }"|.
        IF mv_qualifier IS NOT INITIAL.
          lv_open = |{ lv_open } Qualifier="{ xml_escape( mv_qualifier ) }"|.
        ENDIF.
        lv_open = |{ lv_open }{ simple_value_attribute( ) }|.
      WHEN gc_kind-record.
        lv_tag  = 'Record'.
        IF mv_name IS INITIAL.
          lv_open = '<Record'.
        ELSE.
          lv_open = |<Record Type="{ xml_escape( mv_name ) }"|.
        ENDIF.
      WHEN gc_kind-property.
        lv_tag  = 'PropertyValue'.
        lv_open = |<PropertyValue Property="{ xml_escape( mv_name ) }"{ simple_value_attribute( ) }|.
      WHEN gc_kind-collection.
        lv_tag  = 'Collection'.
        lv_open = '<Collection'.
      WHEN gc_kind-value.
* a value inside a collection: its own element
        rv_xml = |{ iv_indent }<{ mv_value_kind }>{ xml_escape( mv_value ) }</{ mv_value_kind }>\n|.
        RETURN.
    ENDCASE.

    LOOP AT mt_children INTO lo_child.
* simple values of an annotation or a property went into the attribute
      IF lo_child->mv_kind = gc_kind-value AND mv_kind <> gc_kind-collection.
        CONTINUE.
      ENDIF.
      lv_inner = lv_inner && lo_child->render( lv_indent ).
    ENDLOOP.

    IF lv_inner IS INITIAL.
      rv_xml = |{ iv_indent }{ lv_open }/>\n|.
    ELSE.
      rv_xml = |{ iv_indent }{ lv_open }>\n{ lv_inner }{ iv_indent }</{ lv_tag }>\n|.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

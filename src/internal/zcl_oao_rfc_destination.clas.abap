CLASS zcl_oao_rfc_destination DEFINITION PUBLIC.
* CALL FUNCTION ... DESTINATION goes to abap.context.RFCDestinations[dest]
* in the runtime. A local destination routes the call to the function
* modules of this process, which is what 'NONE' means on a Gateway
  PUBLIC SECTION.
    CLASS-METHODS register_local
      IMPORTING
        iv_name TYPE rfcdest DEFAULT 'NONE'.
ENDCLASS.

CLASS zcl_oao_rfc_destination IMPLEMENTATION.

  METHOD register_local.
    DATA lv_name TYPE string.

    lv_name = iv_name.
    WRITE '@KERNEL abap.context.RFCDestinations[lv_name.get()] = {call: async (name, sig) => {'.
    WRITE '@KERNEL   const fm = abap.FunctionModules[name.trimEnd()];'.
    WRITE '@KERNEL   if (fm === undefined) { throw await new abap.Classes["CX_SY_DYN_CALL_ILLEGAL_FUNC"]().constructor_(); }'.
    WRITE '@KERNEL   await fm(sig);'.
    WRITE '@KERNEL }};'.
  ENDMETHOD.

ENDCLASS.

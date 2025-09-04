INTERFACE /iwbep/if_mgw_odata_expand PUBLIC.

  TYPES:
    BEGIN OF ty_s_node_child,
      tech_nav_prop_name  TYPE string,
      node                TYPE REF TO /iwbep/if_mgw_odata_expand,
    END OF ty_s_node_child.
  TYPES ty_t_node_children TYPE STANDARD TABLE OF ty_s_node_child WITH DEFAULT KEY.

  METHODS get_children
    RETURNING
      VALUE(rt_children) TYPE ty_t_node_children.

ENDINTERFACE.
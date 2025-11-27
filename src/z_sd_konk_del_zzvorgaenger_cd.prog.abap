*&---------------------------------------------------------------------*
*& Include          Z_SD_KONK_DEL_ZZVORGAENGER_CD
*&---------------------------------------------------------------------*

CLASS lcl_select_material DEFINITION.
  PUBLIC SECTION.
    METHODS:
      select_predecessor,
      select_inventory,
      delete_predecessor.
ENDCLASS.

CLASS lcl_display_material DEFINITION.
  PUBLIC SECTION.
    METHODS: display_salv.
ENDCLASS.

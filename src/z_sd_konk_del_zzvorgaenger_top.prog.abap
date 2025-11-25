*&---------------------------------------------------------------------*
*& Include Z_SD_KONK_DEL_ZZVORGAENGER_TOP           - Report Z_SD_KONK_DEL_ZZVORGAENGER
*&---------------------------------------------------------------------*
TABLES: zsd_konk_allg.

CLASS lcl_select_material DEFINITION DEFERRED.
CLASS lcl_compare_material DEFINITION DEFERRED.
CLASS lcl_display_material DEFINITION DEFERRED.

TYPES: BEGIN OF g_wrf_matgrp_sku_struct,
         matnr TYPE matnr18,
         node  TYPE wrf_struc_node,
       END OF g_wrf_matgrp_sku_struct.

TYPES: BEGIN OF g_zsd_konk_allg_struct,
         matnr        TYPE matnr18,
         zzvorgaenger TYPE zmatnr_v,
         erfdat       TYPE zerfdat,
         matkl        TYPE matkl,
         attyp        TYPE attyp,
       END OF g_zsd_konk_allg_struct.

TYPES: BEGIN OF g_inventory_struct,
         matnr   TYPE matnr18,
         labst_a TYPE mard-labst,
         labst_b TYPE mard-labst,
       END OF g_inventory_struct.


DATA: g_node                 TYPE wrf_matgrp_sku-node,
      g_matkl                TYPE matkl,
      l_lcl_select_material  TYPE REF TO lcl_select_material,
      l_lcl_compare_material TYPE REF TO lcl_compare_material,
      l_lcl_display_material TYPE REF TO lcl_display_material,
      lt_zsd_konk_allg       TYPE TABLE OF g_zsd_konk_allg_struct,
      lt_wrf_matgrp_sku      TYPE TABLE OF g_wrf_matgrp_sku_struct,
      lt_inventory           TYPE TABLE OF g_inventory_struct,
      ls_inventory           TYPE g_inventory_struct,
      lt_sorted_matnr        TYPE TABLE OF g_zsd_konk_allg_struct,
      ls_sorted_matnr        TYPE g_zsd_konk_allg_struct.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_node FOR g_node,
                  s_matkl FOR g_matkl,
                  s_attyp FOR zsd_konk_allg-attyp NO INTERVALS NO-EXTENSION.

  PARAMETERS: g_date TYPE d,
              p_flag AS CHECKBOX DEFAULT abap_true.

SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR g_date.
  CALL FUNCTION 'F4_DATE'
    IMPORTING
      select_date = g_date.

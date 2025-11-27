*&---------------------------------------------------------------------*
*& Include Z_SD_KONK_DEL_ZZVORGAENGER_TOP           - Report Z_SD_KONK_DEL_ZZVORGAENGER
*&---------------------------------------------------------------------*
TABLES: zsd_konk_allg, wrf1, mard, marc.

CLASS lcl_select_material DEFINITION DEFERRED.
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
         zlabst_a     TYPE z_sd_konk_labst_a,
         zlabst_b     TYPE z_sd_konk_labst_b,
       END OF g_zsd_konk_allg_struct.

TYPES: BEGIN OF g_inventory_struct,
         matnr   TYPE matnr18,
         labst_a TYPE mard-labst,
         labst_b TYPE mard-labst,
       END OF g_inventory_struct.

TYPES: BEGIN OF g_mat_werks_struct,
         matnr TYPE matnr,
         werks TYPE kunnr,
       END OF g_mat_werks_struct.

TYPES: BEGIN OF g_werks_typ_struct,
         werks TYPE werks_d,
         vlfkz TYPE wrf1-vlfkz,
       END OF g_werks_typ_struct.

TYPES: BEGIN OF g_marc_matnr_struct,
         matnr TYPE matnr,
         werks TYPE werks_d,
       END OF g_marc_matnr_struct.

TYPES: BEGIN OF g_mat_werks_locnr_struct,
         matnr TYPE matnr,
         werks TYPE kunnr,
       END OF g_mat_werks_locnr_struct.

TYPES: BEGIN OF ty_matnr_werks_a,
         matnr TYPE matnr,
         werks TYPE werks_d,
       END OF ty_matnr_werks_a.


TYPES: BEGIN OF ty_matnr_werks_b,
         matnr TYPE matnr,
         werks TYPE werks_d,
       END OF ty_matnr_werks_b.

DATA: g_node  TYPE wrf_matgrp_sku-node,
      g_matkl TYPE matkl.

DATA: l_lcl_select_material  TYPE REF TO lcl_select_material,
      l_lcl_display_material TYPE REF TO lcl_display_material.

DATA: l_zsd_konk_allg   TYPE TABLE OF g_zsd_konk_allg_struct,
      l_wrf_matgrp_sku  TYPE TABLE OF g_wrf_matgrp_sku_struct,
      l_inventory_table TYPE TABLE OF g_inventory_struct,
      l_mat_werks       TYPE TABLE OF g_mat_werks_struct,
      l_werks_typ       TYPE TABLE OF g_werks_typ_struct,
      l_marc_matnr      TYPE TABLE OF g_marc_matnr_struct,
      l_mat_werks_locnr TYPE TABLE OF g_mat_werks_locnr_struct,
      l_matnr_a_table   TYPE TABLE OF ty_matnr_werks_a,
      l_matnr_b_table   TYPE TABLE OF ty_matnr_werks_b.

DATA: l_inventory TYPE g_inventory_struct,
      l_matnr_a   TYPE ty_matnr_werks_a,
      l_matnr_b   TYPE ty_matnr_werks_b.

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

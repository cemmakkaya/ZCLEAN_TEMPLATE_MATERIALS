*&---------------------------------------------------------------------*
*& Include          Z_SD_KONK_DEL_ZZVORGAENGER_CI
*&---------------------------------------------------------------------*

CLASS lcl_select_material IMPLEMENTATION.
  METHOD select_predecessor.

    DATA: lt_wrf_matgrp_sku TYPE TABLE OF g_wrf_matgrp_sku_struct.

    SELECT matnr, node
      FROM wrf_matgrp_sku
      INTO CORRESPONDING FIELDS OF TABLE @lt_wrf_matgrp_sku
      WHERE node = @s_node-low.

    IF lt_wrf_matgrp_sku IS NOT INITIAL.

      SELECT matnr, zzvorgaenger, erfdat, matkl, attyp
          FROM zsd_konk_allg
          INTO CORRESPONDING FIELDS OF TABLE @lt_zsd_konk_allg
          FOR ALL ENTRIES IN @lt_wrf_matgrp_sku
          WHERE matnr = @lt_wrf_matgrp_sku-matnr
            AND  matkl IN @s_matkl
            AND attyp IN @s_attyp
            AND erfdat <= @g_date.
    ENDIF.

  ENDMETHOD.

  METHOD select_inventory.
    SELECT matnr
     INTO CORRESPONDING FIELDS OF @lt_sorted_matnr
     FROM lt_zsd_konk_allg.

  ENDMETHOD.

  METHOD delete_predecessor.

  ENDMETHOD.
ENDCLASS.

CLASS lcl_compare_material IMPLEMENTATION.
  METHOD calculate_predecessor.
    l_lcl_select_material = NEW lcl_select_material( ).
    l_lcl_display_material = NEW lcl_display_material( ).


    l_lcl_select_material->select_predecessor( ).
    l_lcl_display_material->display_salv( ).


  ENDMETHOD.

ENDCLASS.

CLASS lcl_display_material IMPLEMENTATION.
  METHOD display_salv.
    DATA: o_alv TYPE REF TO cl_salv_table.

    cl_salv_table=>factory( IMPORTING
                          r_salv_table = o_alv      " Referenz auf das SAP ALV Grid
                        CHANGING
                          t_table = lt_zsd_konk_allg ).   " Tabelle mit Daten für Ausgabe

*    SALV-Table anzeigen
    o_alv->display( ).

  ENDMETHOD.

ENDCLASS.

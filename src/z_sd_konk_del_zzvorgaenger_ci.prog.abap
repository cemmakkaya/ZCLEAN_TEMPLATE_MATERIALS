*&---------------------------------------------------------------------*
*& Include          Z_SD_KONK_DEL_ZZVORGAENGER_CI
*&---------------------------------------------------------------------*

CLASS lcl_select_material IMPLEMENTATION.
  METHOD select_predecessor.

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

    select_inventory( ).
  ENDMETHOD.

  METHOD select_inventory.
    IF lt_wrf_matgrp_sku IS NOT INITIAL.

      MOVE-CORRESPONDING lt_wrf_matgrp_sku TO lt_marc_matnr.

      SELECT matnr, werks
        FROM marc
        INTO TABLE @lt_mat_werks
        FOR ALL ENTRIES IN @lt_marc_matnr
        WHERE matnr = @lt_marc_matnr-matnr.

      MOVE-CORRESPONDING lt_marc_matnr TO lt_mat_werks_locnr.

      SELECT locnr AS werks,
           vlfkz
        FROM wrf1
        INTO TABLE @lt_werks_typ
        FOR ALL ENTRIES IN @lt_mat_werks_locnr
        WHERE locnr = @lt_mat_werks_locnr-locnr AND vlfkz = 'A'.


      "-----------------------------------------------

      CLEAR lt_matnr_a.

      IF lt_werks_typ IS NOT INITIAL.
        SELECT DISTINCT matnr
          FROM marc
          INTO TABLE @lt_matnr_a
          FOR ALL ENTRIES IN @lt_werks_typ
          WHERE werks = @lt_werks_typ-werks.
      ENDIF.

      CLEAR lt_inventory.
      LOOP AT lt_matnr_a INTO ls_matnr_a.
        CLEAR ls_inventory.
        ls_inventory-matnr = ls_matnr_a-matnr.

        IF ls_matnr_a IS NOT INITIAL.
          SELECT labst
          INTO @ls_inventory-labst_a
          FROM mard
          FOR ALL ENTRIES IN @lt_werks_typ
          WHERE matnr = @ls_matnr_a-matnr
            AND werks = @lt_werks_typ-werks.

            APPEND ls_inventory TO lt_inventory.
          ENDSELECT.
        ENDIF.

      ENDLOOP.


      LOOP AT lt_zsd_konk_allg ASSIGNING FIELD-SYMBOL(<fs_allg>).

        READ TABLE lt_inventory ASSIGNING FIELD-SYMBOL(<fs_inv>)
             WITH KEY matnr = <fs_allg>-matnr.

        IF sy-subrc = 0.
          <fs_allg>-zlabst_a = <fs_inv>-labst_a.
        ENDIF.

      ENDLOOP.

      "-----------------------------------------------

    ENDIF.
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

*   SALV-Table anzeigen
    o_alv->display( ).

  ENDMETHOD.

ENDCLASS.

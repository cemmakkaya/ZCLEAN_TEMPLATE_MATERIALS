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
  ENDMETHOD.

  METHOD select_inventory.
    IF lt_wrf_matgrp_sku IS NOT INITIAL.

      MOVE-CORRESPONDING lt_wrf_matgrp_sku TO lt_marc_matnr.

      SELECT matnr, werks
        FROM marc
        INTO CORRESPONDING FIELDS OF TABLE @lt_mat_werks
        FOR ALL ENTRIES IN @lt_marc_matnr
        WHERE matnr = @lt_marc_matnr-matnr.

      MOVE-CORRESPONDING lt_mat_werks TO lt_mat_werks_locnr.

      SELECT locnr AS werks,
           vlfkz
        FROM wrf1
        INTO TABLE @lt_werks_typ
        FOR ALL ENTRIES IN @lt_mat_werks_locnr
        WHERE locnr = @lt_mat_werks_locnr-werks AND vlfkz = 'A'.

      "-----------------------------------------------

      CLEAR lt_matnr_a.

      IF lt_werks_typ IS NOT INITIAL.
        SELECT DISTINCT matnr, werks
          FROM marc
          INTO CORRESPONDING FIELDS OF TABLE @lt_matnr_a
          FOR ALL ENTRIES IN @lt_werks_typ
          WHERE werks = @lt_werks_typ-werks.
      ENDIF.

      CLEAR lt_inventory.
      CLEAR ls_inventory.
      ls_inventory-matnr = ls_matnr_a-matnr.

      IF lt_matnr_a IS NOT INITIAL.
        SELECT labst AS labst_a
        INTO CORRESPONDING FIELDS OF TABLE @lt_inventory
        FROM mard
        FOR ALL ENTRIES IN @lt_matnr_a
        WHERE matnr = @lt_matnr_a-matnr
          AND werks = @lt_matnr_a-werks.

        APPEND ls_inventory TO lt_inventory.
      ENDIF.

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

    select_predecessor( ).

    select_inventory( ).

*    CALL FUNCTION 'BAPI_MATERIAL_MAINTAINDATA_RT'
*      EXPORTING
*        headdata                      =
**     IMPORTING
**       RETURN                        =
**     TABLES
**       VARIANTSKEYS                  =
**       CHARACTERISTICVALUE           =
**       CHARACTERISTICVALUEX          =
**       CLIENTDATA                    =
**       CLIENTDATAX                   =
**       CLIENTEXT                     =
**       CLIENTEXTX                    =
**       ADDNLCLIENTDATA               =
**       ADDNLCLIENTDATAX              =
**       MATERIALDESCRIPTION           =
**       PLANTDATA                     =
**       PLANTDATAX                    =
**       PLANTEXT                      =
**       PLANTEXTX                     =
**       FORECASTPARAMETERS            =
**       FORECASTPARAMETERSX           =
**       FORECASTVALUES                =
**       TOTALCONSUMPTION              =
**       UNPLNDCONSUMPTION             =
**       PLANNINGDATA                  =
**       PLANNINGDATAX                 =
**       STORAGELOCATIONDATA           =
**       STORAGELOCATIONDATAX          =
**       STORAGELOCATIONEXT            =
**       STORAGELOCATIONEXTX           =
**       UNITSOFMEASURE                =
**       UNITSOFMEASUREX               =
**       UNITOFMEASURETEXTS            =
**       INTERNATIONALARTNOS           =
**       VENDOREAN                     =
**       LAYOUTMODULEASSGMT            =
**       LAYOUTMODULEASSGMTX           =
**       TAXCLASSIFICATIONS            =
**       VALUATIONDATA                 =
**       VALUATIONDATAX                =
**       VALUATIONEXT                  =
**       VALUATIONEXTX                 =
**       WAREHOUSENUMBERDATA           =
**       WAREHOUSENUMBERDATAX          =
**       WAREHOUSENUMBEREXT            =
**       WAREHOUSENUMBEREXTX           =
**       STORAGETYPEDATA               =
**       STORAGETYPEDATAX              =
**       STORAGETYPEEXT                =
**       STORAGETYPEEXTX               =
**       SALESDATA                     =
**       SALESDATAX                    =
**       SALESEXT                      =
**       SALESEXTX                     =
**       POSDATA                       =
**       POSDATAX                      =
**       POSEXT                        =
**       POSEXTX                       =
**       MATERIALLONGTEXT              =
**       PLANTKEYS                     =
**       STORAGELOCATIONKEYS           =
**       DISTRCHAINKEYS                =
**       WAREHOUSENOKEYS               =
**       STORAGETYPEKEYS               =
**       VALUATIONTYPEKEYS             =
**       TEXTILECOMPONENTS             =
**       FIBERCODES                    =
**       SEGSALESSTATUS                =
**       SEGWEIGHTVOLUME               =
**       SEGVALUATIONTYPE              =
**       SEASONS                       =
**       SEGWAREHOUSENUMBERDATA        =
**       SEGSTORAGETYPEDATA            =
**       SEGMRPGENERALDATA             =
**       SEGMRPQUANTITYDATA            =
**       CONFIGURATIONDATA             =
**       INSTANCEDATA                  =
**       CHARACTERISTICVALUATION       =
**       CONFIGURATIONPROFILE          =
*              .


  ENDMETHOD.
ENDCLASS.

CLASS lcl_compare_material IMPLEMENTATION.
  METHOD calculate_predecessor.

    "-------------------------------------------------

  ENDMETHOD.
ENDCLASS.

CLASS lcl_display_material IMPLEMENTATION.
  METHOD display_salv.
    IF p_flag = abap_true.
      l_lcl_select_material->select_predecessor( ).
      l_lcl_select_material->select_inventory( ).
    ENDIF.

    DATA: o_alv TYPE REF TO cl_salv_table.

    cl_salv_table=>factory( IMPORTING
                          r_salv_table = o_alv
                        CHANGING
                          t_table = lt_zsd_konk_allg ).
    o_alv->display( ).

  ENDMETHOD.
ENDCLASS.

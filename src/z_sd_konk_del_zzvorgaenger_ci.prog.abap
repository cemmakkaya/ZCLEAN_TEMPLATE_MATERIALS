*&---------------------------------------------------------------------*
*& Include          Z_SD_KONK_DEL_ZZVORGAENGER_CI
*&---------------------------------------------------------------------*

CLASS lcl_select_material IMPLEMENTATION.
  METHOD select_predecessor.

    SELECT matnr, node
      FROM wrf_matgrp_sku
      INTO CORRESPONDING FIELDS OF TABLE @l_wrf_matgrp_sku
      WHERE node = @s_node-low.

    IF l_wrf_matgrp_sku IS NOT INITIAL.
      SELECT matnr, zzvorgaenger, erfdat, matkl, attyp
          FROM zsd_konk_allg
          INTO CORRESPONDING FIELDS OF TABLE @l_zsd_konk_allg
          FOR ALL ENTRIES IN @l_wrf_matgrp_sku
          WHERE matnr = @l_wrf_matgrp_sku-matnr
            AND  matkl IN @s_matkl
            AND attyp IN @s_attyp
            AND erfdat <= @g_date.
    ENDIF.


    IF l_zsd_konk_allg IS INITIAL.
      MESSAGE: 'Es wurden keine veralteten Vorgänger gefunden.' TYPE 'E'.
    ENDIF.
  ENDMETHOD.

  METHOD select_inventory.
    IF l_wrf_matgrp_sku IS NOT INITIAL.

      MOVE-CORRESPONDING l_wrf_matgrp_sku TO l_marc_matnr.

      SELECT matnr, werks
        FROM marc
        INTO CORRESPONDING FIELDS OF TABLE @l_mat_werks
        FOR ALL ENTRIES IN @l_marc_matnr
        WHERE matnr = @l_marc_matnr-matnr.

      MOVE-CORRESPONDING l_mat_werks TO l_mat_werks_locnr.

      SELECT locnr AS werks,
           vlfkz
        FROM wrf1
        INTO TABLE @l_werks_typ
        FOR ALL ENTRIES IN @l_mat_werks_locnr
        WHERE locnr = @l_mat_werks_locnr-werks AND vlfkz = 'A'.

      "-----------------------------------------------

      CLEAR l_matnr_a.

      IF l_werks_typ IS NOT INITIAL.
        SELECT DISTINCT matnr, werks
          FROM marc
          INTO CORRESPONDING FIELDS OF TABLE @l_matnr_a_table
          FOR ALL ENTRIES IN @l_werks_typ
          WHERE werks = @l_werks_typ-werks.
      ENDIF.

      CLEAR l_inventory.
      CLEAR l_inventory.
      l_inventory-matnr = l_matnr_a-matnr.


      "Typ A Lagerbestand
      IF l_matnr_a IS NOT INITIAL.
        SELECT labst AS labst_a
        INTO CORRESPONDING FIELDS OF TABLE @l_inventory_table
        FROM mard
        WHERE matnr = @l_matnr_a-matnr
          AND werks = @l_matnr_a-werks.

        APPEND l_inventory TO l_inventory_table.
      ENDIF.

      LOOP AT l_zsd_konk_allg ASSIGNING FIELD-SYMBOL(<fs_allg>).

        READ TABLE l_inventory_table ASSIGNING FIELD-SYMBOL(<fs_inv>)
             WITH KEY matnr = <fs_allg>-matnr.

        IF sy-subrc = 0.
          <fs_allg>-zlabst_a = <fs_inv>-labst_a.
        ENDIF.

      ENDLOOP.

      "Typ B Lagerbestand
      IF l_matnr_b IS NOT INITIAL.
        SELECT labst AS labst_b
        INTO CORRESPONDING FIELDS OF TABLE @l_inventory_table
        FROM mard
        WHERE matnr = @l_matnr_b-matnr
          AND werks = @l_matnr_b-werks.

        APPEND l_inventory TO l_inventory_table.
      ENDIF.

      LOOP AT l_zsd_konk_allg ASSIGNING FIELD-SYMBOL(<fs_allg_b>).

        READ TABLE l_inventory_table ASSIGNING FIELD-SYMBOL(<fs_inv_b>)
             WITH KEY matnr = <fs_allg_b>-matnr.

        IF sy-subrc = 0.
          <fs_allg_b>-zlabst_b = <fs_inv_b>-labst_b.
        ENDIF.

      ENDLOOP.

      "Typ B Lagerbestand

      IF l_inventory_table IS INITIAL.
        MESSAGE: 'Es wurden keine Lagerbestände gefunden.' TYPE 'E'.
      ENDIF.

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
                          t_table = l_zsd_konk_allg ).
    o_alv->display( ).

  ENDMETHOD.
ENDCLASS.

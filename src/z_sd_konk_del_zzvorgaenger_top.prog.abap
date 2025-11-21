*&---------------------------------------------------------------------*
*& Include Z_SD_KONK_DEL_ZZVORGAENGER_TOP           - Report Z_SD_KONK_DEL_ZZVORGAENGER
*&---------------------------------------------------------------------*

DATA: l_matnr TYPE matnr,
      l_matkl TYPE matkl.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_matnr FOR l_matnr,
                  s_matkl FOR l_matkl.

  PARAMETERS: p_attyp TYPE attyp,
              p_date  TYPE d OBLIGATORY,
              p_flag  AS CHECKBOX DEFAULT abap_true.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_date.
  CALL FUNCTION 'F4_DATE'
    IMPORTING
      select_date = p_date.

*&---------------------------------------------------------------------*
*& Report Z_SD_KONK_DEL_ZZVORGAENGER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_sd_konk_del_zzvorgaenger.

INCLUDE z_sd_konk_del_zzvorgaenger_top.

INCLUDE z_sd_konk_del_zzvorgaenger_cd.

INCLUDE z_sd_konk_del_zzvorgaenger_ci.

START-OF-SELECTION.
  l_lcl_select_material = NEW lcl_select_material( ).
  l_lcl_display_material = NEW lcl_display_material( ).

  IF p_flag <> abap_true.
    l_lcl_select_material->delete_predecessor( ).
  ELSE.
    l_lcl_display_material->display_salv( ).
  ENDIF.

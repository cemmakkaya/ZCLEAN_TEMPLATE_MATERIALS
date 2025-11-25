*&---------------------------------------------------------------------*
*& Report Z_SD_KONK_DEL_ZZVORGAENGER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_sd_konk_del_zzvorgaenger.

INCLUDE z_sd_konk_del_zzvorgaenger_top          .    " Global Data

INCLUDE z_sd_konk_del_zzvorgaenger_cd.

INCLUDE z_sd_konk_del_zzvorgaenger_ci.

START-OF-SELECTION.
  l_lcl_compare_material = NEW lcl_compare_material( ).
  l_lcl_compare_material->calculate_predecessor( ).

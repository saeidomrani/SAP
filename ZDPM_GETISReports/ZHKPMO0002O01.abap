*&---------------------------------------------------------------------*
*&  Include           ZHKPMO0002O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0001 OUTPUT.
  SET PF-STATUS 'G0100'.
  SET TITLEBAR 'T0100'.

ENDMODULE.                 " STATUS_0001  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  INITIALIZE_0001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE INITIALIZE_0001 OUTPUT.

  DESCRIBE TABLE gt_item   LINES gt_cont-lines.

ENDMODULE.                 " INITIALIZE_0001  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  CHANGE_TC_0001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CHANGE_TC_0001 OUTPUT.

ENDMODULE.                 " CHANGE_TC_0001  OUTPUT

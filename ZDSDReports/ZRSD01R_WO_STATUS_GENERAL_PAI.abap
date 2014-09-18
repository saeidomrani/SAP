*----------------------------------------------------------------------*
*   INCLUDE ZRSD01R_WO_STATUS_GENERAL_PAI                              *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT INPUT.

  SAVE_OK_CODE = OK_CODE.
  CLEAR OK_CODE.
  CASE SAVE_OK_CODE.
    WHEN 'BACK'.
      SET SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      SET SCREEN 0.
  ENDCASE.

ENDMODULE.                 " EXIT  INPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9000 OUTPUT.

  SET PF-STATUS 'ZRSD01R_1'.
  SET TITLEBAR  'ZRSD01R_1'.

ENDMODULE.                 " STATUS_9000  OUTPUT

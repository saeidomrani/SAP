*&---------------------------------------------------------------------*
*&  Include           ZRHT_TO_DO_LIST_CREATIONO01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  IF g_change_flag IS INITIAL.
    SET PF-STATUS 'G100'.
  ENDIF.
  SET TITLEBAR 'T100'.

ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  CREATE_ALV_100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE create_alv_100 OUTPUT.

  PERFORM create_alv_100.

ENDMODULE.                 " CREATE_ALV_100  OUTPUT

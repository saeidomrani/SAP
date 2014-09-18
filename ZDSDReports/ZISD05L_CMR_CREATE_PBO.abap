*&---------------------------------------------------------------------*
*&      Module  STATUS  OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS OUTPUT.
  CASE SY-DYNNR.
    WHEN '9000'.
      SET PF-STATUS 'ISD05M'.
    WHEN '9100'.
      SET PF-STATUS 'ISD05M_9100'.
  ENDCASE.
ENDMODULE.                 " STATUS  OUTPUT



















************************************************************************
***INCLUDE ZISD05L_CMR_CREATE_PBO .
* OUTPUT MODULE FOR TABLECONTROL 'TC_9000':
* COPY DDIC-TABLE TO ITAB
MODULE TC_9000_INIT OUTPUT.
  IF G_TC_9000_COPIED IS INITIAL.
* COPY DDIC-TABLE 'ZTSD_ACL_L'
* INTO INTERNAL TABLE 'g_TC_9000_itab'
*   ==> READ_DATA
    G_TC_9000_COPIED = 'X'.
    REFRESH CONTROL 'TC_9000' FROM SCREEN '9000'.
  ENDIF.
ENDMODULE.

* OUTPUT MODULE FOR TABLECONTROL 'TC_9000':
* MOVE ITAB TO DYNPRO
MODULE TC_9000_MOVE OUTPUT.
  MOVE-CORRESPONDING G_TC_9000_WA TO ZTSD_ACL_L.
ENDMODULE.

* OUTPUT MODULE FOR TABLECONTROL 'TC_9000':
* GET LINES OF TABLECONTROL
MODULE TC_9000_GET_LINES OUTPUT.
  G_TC_9000_LINES = SY-LOOPC.
ENDMODULE.

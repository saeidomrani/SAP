FUNCTION Z_FPP_GET_PVV02AB_2.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  EXPORTING
*"     VALUE(FLAG) TYPE  ZRESULT
*"  TABLES
*"      I_PVV02AB STRUCTURE  ZTPP_PVV02AB
*"      I_PVV01RR STRUCTURE  ZTPP_PVV01RR
*"----------------------------------------------------------------------
  DATA: L_TIME LIKE SY-UZEIT,
        L_COUNT TYPE I.

  DATA: LT_PVV02AB LIKE TABLE OF ZTPP_PVV02AB WITH HEADER LINE,
        LT_PVV01RR LIKE TABLE OF ZTPP_PVV02AB WITH HEADER LINE.

  L_TIME = SY-UZEIT.
** PVV02AB
  DESCRIBE TABLE I_PVV02AB LINES L_COUNT.
  IF L_COUNT > 0.
    LOOP AT I_PVV02AB.
      I_PVV02AB-STTM = SY-DATUM.
      I_PVV02AB-ERZET = L_TIME.
      I_PVV02AB-ZUSER = SY-UNAME.
      MODIFY I_PVV02AB.
    ENDLOOP.

    SELECT * INTO TABLE LT_PVV02AB
      FROM ZTPP_PVV02AB
      WHERE ZUPDATE = ' '.

    IF SY-SUBRC = 0.
      UPDATE ZTPP_PVV02AB SET ZUPDATE = 'X'
                      WHERE ZUPDATE = ' '.
      IF SY-SUBRC = 0.
        COMMIT WORK.
      ELSE.
        ROLLBACK WORK.
        FLAG = 'E'.
        EXIT.
      ENDIF.
    ENDIF.
    INSERT ZTPP_PVV02AB FROM TABLE I_PVV02AB ACCEPTING DUPLICATE KEYS.
    IF SY-SUBRC = 0.
      COMMIT WORK.
      FLAG = 'S'.
    ELSE.
      ROLLBACK WORK.
      FLAG = 'E'.
    ENDIF.
  ENDIF.
** PVV01RR
  CLEAR: L_COUNT.
  DESCRIBE TABLE I_PVV01RR LINES L_COUNT.

  IF L_COUNT > 0.
    LOOP AT I_PVV01RR.
      I_PVV01RR-STTM = SY-DATUM.
      I_PVV01RR-ERZET = L_TIME.
      I_PVV01RR-ZUSER = SY-UNAME.
      MODIFY I_PVV01RR.
    ENDLOOP.

    SELECT * INTO TABLE LT_PVV01RR
      FROM ZTPP_PVV01RR
      WHERE ZUPDATE = ' '.

    IF SY-SUBRC = 0.
      UPDATE ZTPP_PVV01RR SET ZUPDATE = 'X'
                      WHERE ZUPDATE = ' '.
      IF SY-SUBRC = 0.
        COMMIT WORK.
      ELSE.
        ROLLBACK WORK.
        FLAG = 'E'.
        EXIT.
      ENDIF.
    ENDIF.
    INSERT ZTPP_PVV01RR FROM TABLE I_PVV01RR ACCEPTING DUPLICATE KEYS.
    IF SY-SUBRC = 0.
      COMMIT WORK.
      FLAG = 'S'.
    ELSE.
      ROLLBACK WORK.
      FLAG = 'E'.
    ENDIF.
  ENDIF.
ENDFUNCTION.

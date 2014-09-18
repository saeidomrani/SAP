FUNCTION Z_FPP_GET_SODATA_HMA.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  TABLES
*"      T_ZTSD_SODATA STRUCTURE  ZTSD_SODATA
*"----------------------------------------------------------------------

*  DATA IT_ZTSD_SODATA LIKE TABLE OF ZTSD_SODATA WITH HEADER LINE.
  DATA IT_ZTSD_SODATA LIKE ZTSD_SODATA.

*------> MOVE INBOUNDED TABLE TO ITAB
  LOOP AT T_ZTSD_SODATA.
    MOVE-CORRESPONDING T_ZTSD_SODATA TO IT_ZTSD_SODATA.
    IT_ZTSD_SODATA-ZEDAT = SY-DATUM.
    IT_ZTSD_SODATA-ZETIM = SY-UZEIT.
    INSERT INTO ZTSD_SODATA VALUES IT_ZTSD_SODATA.
    IF SY-SUBRC EQ 0.
       MOVE  'S'   TO   T_ZTSD_SODATA-P_FLAG.
       MODIFY T_ZTSD_SODATA.
    ELSE.
       MOVE  'E'   TO   T_ZTSD_SODATA-P_FLAG.
       MODIFY T_ZTSD_SODATA.
*       ROLLBACK WORK.
    ENDIF.
  ENDLOOP.
  COMMIT WORK.

*  INSERT ZTSD_SODATA FROM TABLE IT_ZTSD_SODATA."ACCEPTING DUPLICATE
*KEYS

ENDFUNCTION.

FUNCTION ZMM_PART_SHORTAGE_DEMAND_HR.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  EXPORTING
*"     VALUE(O_FLAG) TYPE  ZRESULT
*"     VALUE(O_MSG) TYPE  ZMSG
*"  TABLES
*"      GCS_ZMMT0052 STRUCTURE  ZMMT0052
*"----------------------------------------------------------------------
*A__ USE RFC BY PAUL
  DATA :  LT_ZMMT0052  LIKE ZMMT0052 OCCURS 0 WITH HEADER LINE.
  CLEAR : LT_ZMMT0052, LT_ZMMT0052[],
          IT_SHORT,    IT_SHORT[].

  SELECT *
    FROM ZTMM_HOUR_SHORT
    INTO CORRESPONDING FIELDS OF TABLE IT_SHORT.

  IF SY-SUBRC = 0.
    O_FLAG = 'S'.
    O_MSG = 'Successful'.
**A__ BY PAUL
    LOOP AT IT_SHORT.
      MOVE-CORRESPONDING IT_SHORT TO LT_ZMMT0052.
      LT_ZMMT0052-ZCRTDT = IT_SHORT-ZSDAT.
      LT_ZMMT0052-ZCRTIM = IT_SHORT-ZSTIM.
      LT_ZMMT0052-WERKS  = 'P001'.
      LT_ZMMT0052-RPOINT = IT_SHORT-RP.
      LT_ZMMT0052-H01MG  = IT_SHORT-RP01.
      LT_ZMMT0052-H02MG  = IT_SHORT-RP02.
      LT_ZMMT0052-H03MG  = IT_SHORT-RP03.
      LT_ZMMT0052-H04MG  = IT_SHORT-RP04.
      LT_ZMMT0052-H05MG  = IT_SHORT-RP05.
      LT_ZMMT0052-H06MG  = IT_SHORT-RP06.
      LT_ZMMT0052-H07MG  = IT_SHORT-RP07.
      LT_ZMMT0052-H08MG  = IT_SHORT-RP08.
      LT_ZMMT0052-H09MG  = IT_SHORT-RP09.
      LT_ZMMT0052-H10MG  = IT_SHORT-RP10.
      LT_ZMMT0052-H11MG  = IT_SHORT-RP11.
      LT_ZMMT0052-H12MG  = IT_SHORT-RP12.
      LT_ZMMT0052-H13MG  = IT_SHORT-RP13.
      LT_ZMMT0052-H14MG  = IT_SHORT-RP14.
      LT_ZMMT0052-H15MG  = IT_SHORT-RP15.
      LT_ZMMT0052-H16MG  = IT_SHORT-RP16.
      LT_ZMMT0052-H17MG  = IT_SHORT-RP17.
      LT_ZMMT0052-H18MG  = IT_SHORT-RP18.
      LT_ZMMT0052-H19MG  = IT_SHORT-RP19.
      LT_ZMMT0052-H20MG  = IT_SHORT-RP20.
      LT_ZMMT0052-H21MG  = IT_SHORT-RP21.
      LT_ZMMT0052-H22MG  = IT_SHORT-RP22.
      LT_ZMMT0052-H23MG  = IT_SHORT-RP23.
      LT_ZMMT0052-H24MG  = IT_SHORT-RP24.
      LT_ZMMT0052-BDMNG  = IT_SHORT-TOTAL.
      LT_ZMMT0052-ZBDAT  = SY-DATUM.
      LT_ZMMT0052-ZBTIM  = SY-UZEIT.
      LT_ZMMT0052-WHQTY  = IT_SHORT-LN_OHQTY.
      CLEAR : LT_ZMMT0052-ZEDAT, LT_ZMMT0052-ZETIM.
      APPEND LT_ZMMT0052.
    ENDLOOP.

    DELETE FROM ZMMT0052 CLIENT SPECIFIED WHERE MANDT = SY-MANDT.

    INSERT ZMMT0052 FROM TABLE LT_ZMMT0052.

    GCS_ZMMT0052[] = LT_ZMMT0052[].

  ELSE.
    O_FLAG = 'E'.
    O_MSG = 'No Data'.
  ENDIF.


ENDFUNCTION.

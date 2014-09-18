FUNCTION ZIM_GET_LOCAL_LC_AMEND_DATA.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(ZFREQNO) LIKE  ZTREQHD-ZFREQNO
*"     VALUE(ZFAMDNO) LIKE  ZTREQST-ZFAMDNO
*"  EXPORTING
*"     VALUE(W_ZTLLCAMHD) LIKE  ZTLLCAMHD STRUCTURE  ZTLLCAMHD
*"  TABLES
*"      IT_ZSLLCAMSGOF STRUCTURE  ZSLLCAMSGOF
*"      IT_ZSLLCAMSGOF_ORG STRUCTURE  ZSLLCAMSGOF
*"  EXCEPTIONS
*"      NOT_FOUND
*"      NOT_INPUT
*"----------------------------------------------------------------------

  REFRESH : IT_ZSLLCAMSGOF, IT_ZSLLCAMSGOF_ORG.

  CLEAR : W_ZTLLCAMHD.

  IF ZFREQNO IS INITIAL OR ZFAMDNO IS INITIAL.
     RAISE NOT_INPUT.
  ENDIF.

  SELECT SINGLE * INTO   W_ZTLLCAMHD FROM ZTLLCAMHD
                  WHERE  ZFREQNO     EQ   ZFREQNO
                  AND    ZFAMDNO     EQ   ZFAMDNO.

  IF SY-SUBRC NE 0.
     RAISE NOT_FOUND.
  ENDIF.

  SELECT *  INTO CORRESPONDING FIELDS OF TABLE IT_ZSLLCAMSGOF
            FROM   ZTLLCAMSGOF
            WHERE  ZFREQNO      EQ   ZFREQNO
            AND    ZFAMDNO      EQ   ZFAMDNO
            ORDER BY  ZFLSGOF.

  LOOP AT IT_ZSLLCAMSGOF.
     MOVE-CORRESPONDING  IT_ZSLLCAMSGOF TO   IT_ZSLLCAMSGOF_ORG.
     APPEND IT_ZSLLCAMSGOF_ORG.
  ENDLOOP.


ENDFUNCTION.

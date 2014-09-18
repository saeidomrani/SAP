FUNCTION ZIM_GET_PURCH_DOC_DATA.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(ZFREQNO) LIKE  ZTREQHD-ZFREQNO
*"     VALUE(ZFAMDNO) LIKE  ZTREQST-ZFAMDNO
*"  EXPORTING
*"     VALUE(W_ZTPUR) LIKE  ZTPUR STRUCTURE  ZTPUR
*"  TABLES
*"      IT_ZSPURSG1 STRUCTURE  ZSPURSG1
*"      IT_ZSPURSG1G STRUCTURE  ZSPURSG1G
*"      IT_ZSPURSG4 STRUCTURE  ZSPURSG4
*"      IT_ZSPURSG1_ORG STRUCTURE  ZSPURSG1
*"      IT_ZSPURSG1G_ORG STRUCTURE  ZSPURSG1G
*"      IT_ZSPURSG4_ORG STRUCTURE  ZSPURSG4
*"  EXCEPTIONS
*"      NOT_FOUND
*"      NOT_INPUT
*"----------------------------------------------------------------------
  REFRESH : IT_ZSPURSG1, IT_ZSPURSG1G, IT_ZSPURSG4.
  REFRESH : IT_ZSPURSG1_ORG, IT_ZSPURSG1G_ORG, IT_ZSPURSG4_ORG.

  CLEAR : W_ZTPUR.

  IF ZFREQNO IS INITIAL.
     RAISE NOT_INPUT.
  ENDIF.

  SELECT SINGLE * INTO   W_ZTPUR   FROM ZTPUR
                  WHERE  ZFREQNO   EQ   ZFREQNO
                  AND    ZFAMDNO   EQ   ZFAMDNO.

  IF SY-SUBRC NE 0.
     RAISE NOT_FOUND.
  ENDIF.

  SELECT *  INTO CORRESPONDING FIELDS OF TABLE IT_ZSPURSG1
            FROM ZTPURSG1
            WHERE  ZFREQNO      EQ   ZFREQNO
            AND    ZFAMDNO      EQ   ZFAMDNO
            ORDER BY  ZFLSG1.

  LOOP AT IT_ZSPURSG1.
     MOVE-CORRESPONDING   IT_ZSPURSG1   TO   IT_ZSPURSG1_ORG.
     APPEND IT_ZSPURSG1_ORG.
  ENDLOOP.

  SELECT *  INTO CORRESPONDING FIELDS OF TABLE IT_ZSPURSG1G
            FROM ZTPURSG1G
            WHERE  ZFREQNO      EQ   ZFREQNO
            AND    ZFAMDNO      EQ   ZFAMDNO
            ORDER BY  ZFLSG1 ZFLSG1G.

  LOOP AT IT_ZSPURSG1G.
     MOVE-CORRESPONDING   IT_ZSPURSG1G  TO   IT_ZSPURSG1G_ORG.
     APPEND IT_ZSPURSG1G_ORG.
  ENDLOOP.

  SELECT *  INTO CORRESPONDING FIELDS OF TABLE IT_ZSPURSG4
            FROM ZTPURSG4
            WHERE  ZFREQNO      EQ   ZFREQNO
            AND    ZFAMDNO      EQ   ZFAMDNO
            ORDER BY  ZFLSG4.

  LOOP AT IT_ZSPURSG4.
     MOVE-CORRESPONDING   IT_ZSPURSG4   TO   IT_ZSPURSG4_ORG.
     APPEND IT_ZSPURSG4_ORG.
  ENDLOOP.

ENDFUNCTION.

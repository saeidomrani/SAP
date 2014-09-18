FUNCTION ZTR_SAVE_PLAN.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(BUKRS) LIKE  ZTTR0008-BUKRS
*"     REFERENCE(GJAHR) LIKE  ZTTR0008-GJAHR
*"     REFERENCE(PDAT1) LIKE  ZTTR0008-PDAT1
*"     REFERENCE(ZTYPE) LIKE  ZTTR0008-ZTYPE
*"  EXCEPTIONS
*"      SAVE_ERROR
*"      SAVE_CANCEL
*"----------------------------------------------------------------------

  DATA : GT_ZTTR0008 LIKE ZTTR0008 OCCURS 0 WITH HEADER LINE,
         GT_FDSR     LIKE FDSR     OCCURS 0 WITH HEADER LINE,
         L_SEQNO     LIKE ZTTR0008-SEQNO,
         ANSWER.

  DATA : BEGIN OF LT_FDSR OCCURS 0.
          INCLUDE STRUCTURE FDSR.
  DATA :   FDGRV LIKE ZTTR0009-FDGRV,
         END OF LT_FDSR.
  DATA : LT_FDFIEP LIKE FDFIEP OCCURS 0 WITH HEADER LINE.

  REFRESH : GT_ZTTR0008, GT_FDSR, LT_FDSR, LT_FDFIEP.
  CLEAR   : GT_ZTTR0008, GT_FDSR, LT_FDSR, LT_FDFIEP, L_SEQNO.

  SELECT MAX( SEQNO ) INTO L_SEQNO
    FROM ZTTR0008
   WHERE BUKRS = BUKRS
     AND PDAT1 = PDAT1
     AND GJAHR = GJAHR
     AND ZTYPE = ZTYPE.

  IF L_SEQNO > 0.
    CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
      EXPORTING
        TEXTLINE1      = 'Already exist'
        TEXTLINE2      = 'Are you save again?'
        TITEL          = 'Save'
        CANCEL_DISPLAY = ' '
      IMPORTING
        ANSWER         = ANSWER.

    IF ANSWER NE 'J'.
      MESSAGE S030(ZMFI).
      RAISE SAVE_CANCEL.
    ENDIF.
  ENDIF.

  ADD 1 TO L_SEQNO.

  SELECT * INTO TABLE GT_FDSR FROM FDSR
   WHERE EBENE NOT LIKE 'F%'.    "Planning Level

*   FDM1
  SELECT A~MANDT AS MANDT
         A~BUKRS AS BUKRS
         A~FDGRP AS GRUPP
         A~FDLEV AS EBENE
         A~CURRD AS DISPW
         A~FDTAG AS DATUM
         A~FDWBT AS WRSHB
         A~FDDBT AS DMSHB
         D~FDGRV AS FDGRV
         APPENDING CORRESPONDING FIELDS OF TABLE LT_FDSR
    FROM FDM1 AS A
    JOIN EKKN AS B
      ON A~EBELN = B~EBELN
     AND A~EBELP = B~EBELP
    JOIN AUFK AS C
      ON B~AUFNR = C~AUFNR
    LEFT OUTER JOIN ZTTR0009 AS D    "[TR-CM] I/O Planning Group
      ON C~ANFAUFNR = D~AUFNR
   WHERE A~FDGRP NE SPACE
     AND A~FDLEV = 'M2'           "Planning Level
     AND B~AUFNR NE SPACE.

*   FDM2
  SELECT A~MANDT AS MANDT
         A~BUKRS AS BUKRS
         A~FDGRP AS GRUPP
         A~FDLEV AS EBENE
         A~CURRD AS DISPW
         A~FDTAG AS DATUM
         A~FDWBT AS WRSHB
         A~FDDBT AS DMSHB
         D~FDGRV AS FDGRV
         APPENDING CORRESPONDING FIELDS OF TABLE LT_FDSR
    FROM FDM2 AS A
    JOIN EBKN AS B
      ON A~BANFN = B~BANFN
     AND A~ZEBKN = B~ZEBKN
    JOIN AUFK AS C
      ON B~AUFNR = C~AUFNR
    LEFT OUTER JOIN ZTTR0009 AS D   "[TR-CM] I/O Planning Group
      ON C~ANFAUFNR = D~AUFNR
   WHERE A~FDGRP NE SPACE
     AND B~AUFNR NE SPACE.

  LOOP AT LT_FDSR.
    MOVE-CORRESPONDING LT_FDSR TO GT_FDSR.
    COLLECT GT_FDSR.
    CLEAR   GT_FDSR.

    MOVE-CORRESPONDING LT_FDSR TO GT_FDSR.
    GT_FDSR-GRUPP =   LT_FDSR-FDGRV.
    GT_FDSR-DMSHB = - LT_FDSR-DMSHB.
    GT_FDSR-WRSHB = - LT_FDSR-WRSHB.
    COLLECT GT_FDSR.
    CLEAR   GT_FDSR..
  ENDLOOP.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE LT_FDFIEP
    FROM FDFIEP AS A
    JOIN FDSR   AS B
      ON A~AUSBK = B~BUKRS
     AND A~FDGRP = B~GRUPP
     AND A~FDLEV = B~EBENE
     AND A~DISPW = B~DISPW
     AND A~FDTAG = B~DATUM
   WHERE B~BUKRS = BUKRS
     AND B~EBENE LIKE 'F%'.       "Planning Level

  LOOP AT LT_FDFIEP.
    CLEAR BSEG.
    SELECT SINGLE * FROM BSEG
     WHERE BUKRS = BUKRS
       AND BELNR = LT_FDFIEP-BELNR
       AND GJAHR = LT_FDFIEP-GJAHR
       AND BUZEI = LT_FDFIEP-BUZEI.

    IF SY-SUBRC NE 0.
      IF LT_FDFIEP-LIFNR IS NOT INITIAL.
        SELECT SINGLE SHKZG DMBTR
          INTO (BSEG-SHKZG, BSEG-DMBTR)
          FROM VBSEGK
         WHERE BUKRS = BUKRS
           AND BELNR = LT_FDFIEP-BELNR
           AND GJAHR = LT_FDFIEP-GJAHR
           AND BUZEI = LT_FDFIEP-BUZEI.
      ELSEIF LT_FDFIEP-KUNNR IS NOT INITIAL.
        SELECT SINGLE SHKZG DMBTR
          INTO (BSEG-SHKZG, BSEG-DMBTR)
          FROM VBSEGD
         WHERE BUKRS = BUKRS
           AND BELNR = LT_FDFIEP-BELNR
           AND GJAHR = LT_FDFIEP-GJAHR
           AND BUZEI = LT_FDFIEP-BUZEI.
      ENDIF.
    ENDIF.

    CHECK SY-SUBRC = 0.
    GT_FDSR-MANDT = SY-MANDT.
    GT_FDSR-BUKRS = BUKRS.
    GT_FDSR-EBENE = LT_FDFIEP-FDLEV.
    GT_FDSR-DISPW = LT_FDFIEP-DISPW.
    GT_FDSR-DATUM = LT_FDFIEP-FDTAG.
    GT_FDSR-WRSHB = BSEG-WRBTR.
    GT_FDSR-DMSHB = BSEG-DMBTR.

    IF BSEG-SHKZG = 'H'.
      GT_FDSR-DMSHB = - GT_FDSR-DMSHB.
      GT_FDSR-WRSHB = - GT_FDSR-WRSHB.
    ENDIF.

    IF BSEG-AUFNR IS INITIAL.
      GT_FDSR-GRUPP = LT_FDFIEP-FDGRP.
    ELSE.
      SELECT SINGLE B~FDGRV INTO GT_FDSR-GRUPP
        FROM AUFK      AS A
        JOIN ZTTR0009  AS B
          ON A~ANFAUFNR = B~AUFNR
       WHERE A~AUFNR    = BSEG-AUFNR.
    ENDIF.

    COLLECT GT_FDSR.
    CLEAR   GT_FDSR.

  ENDLOOP.

  LOOP AT GT_FDSR.

    MOVE-CORRESPONDING GT_FDSR TO GT_ZTTR0008.

    GT_ZTTR0008-PDAT1 = PDAT1.
    GT_ZTTR0008-GJAHR = GJAHR.
    GT_ZTTR0008-ZTYPE = ZTYPE.
    GT_ZTTR0008-SEQNO = L_SEQNO.
    GT_ZTTR0008-ERNAM = SY-UNAME.
    GT_ZTTR0008-ERDAT = SY-DATUM.
    GT_ZTTR0008-ERZET = SY-UZEIT.

    COLLECT GT_ZTTR0008.      "[TR-CM] Planning by daily,monthly
    CLEAR   GT_ZTTR0008.

  ENDLOOP.

*// ==[TR-CM] Planning by daily,monthly
  INSERT ZTTR0008 FROM TABLE GT_ZTTR0008.

  IF SY-SUBRC = 0.
    COMMIT WORK.
    MESSAGE S007(ZMFI).   "Saved successfully
  ELSE.
    ROLLBACK WORK.
    MESSAGE W011(ZMFI) with 'Save failed'.
    RAISE SAVE_ERROR.
  ENDIF.


ENDFUNCTION.

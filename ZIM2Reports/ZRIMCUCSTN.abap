*&---------------------------------------------------------------------*
*& Report  ZRIMCUCSTN                                                 *
*&---------------------------------------------------------------------*
*&  프로그램명 : 관세/부가세 Posting - 무?
*&      작성자 : 김연중 INFOLINK Ltd.                                  *
*&      작성일 : 2000.09.04                                            *
*&  적용회사PJT:                                                       *
*&---------------------------------------------------------------------*
*&   DESC.     : 무환 관세/부가세를 조회하여 BDC로 Posting한다.
*&
*&---------------------------------------------------------------------*
*& [변경내용]
*&
*&---------------------------------------------------------------------*
REPORT  ZRIMCUCST    MESSAGE-ID ZIM
                     LINE-SIZE 107
                     NO STANDARD PAGE HEADING.
*-----------------------------------------------------------------------
* Tables 및 변수 Define
*-----------------------------------------------------------------------
INCLUDE : <ICON>,
          ZRIMCUCSTTOP,
          ZRIMBDCCOM,
          ZRIMBAIPTOP.

DATA : BEGIN OF IT_TAB OCCURS 0,
       MARK            TYPE   C,
       ZFHBLNO(16)     TYPE   C,                  " House B/L No
       BUKRS           LIKE   ZTCUCLCST-BUKRS,
       ZFBLNO          LIKE   ZTCUCLCST-ZFBLNO,   " B/L 관리번?
       ZFCLSEQ         LIKE   ZTCUCLCST-ZFCLSEQ,  " 통관순?
       ZFCSQ           LIKE   ZTCUCLCST-ZFCSQ,    " 비용순?
       WAERS           LIKE   ZTCUCLCST-WAERS,
       ZFCAMT          LIKE   ZTCUCLCST-ZFCAMT,   " 비용금?
       ZFKRW           LIKE   ZTCUCLCST-ZFKRW,    " 원화통?
       ZFCSCD          LIKE   ZTCUCLCST-ZFCSCD,   " 비용코?
       ZFCSCD_NM(6)    TYPE   C,   " 비용코드?
       ZFOCDT          LIKE   ZTCUCLCST-ZFOCDT,   " 발생?
       ZFVEN           LIKE   ZTCUCLCST-ZFVEN,    " Vendor
       ZFVEN_NM(20)    TYPE   C,                  " Vendor ?
       ZFPAY           LIKE   ZTCUCLCST-ZFPAY,    " 지불?
       ZFPAY_NM(20)    TYPE   C,                  " 지불처?
       ZTERM           LIKE   ZTCUCLCST-ZTERM,    " Terms of Payment
       MWSKZ           LIKE   ZTCUCLCST-MWSKZ,    " Tax Code
       ZFWERKS         LIKE   ZTCUCLCST-ZFWERKS,  " Plant
       KOSTL           LIKE   ZTBL-KOSTL,         " Cost Center
       GRP_MARK(10)    TYPE   C.
DATA : END OF IT_TAB.

*-----------------------------------------------------------------------
* Selection Screen ?
*-----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
   SELECT-OPTIONS: S_VEN    FOR ZTCUCLCST-ZFVEN,     " Vendor
                   S_PAY    FOR ZTCUCLCST-ZFPAY,     " 지불?
                   S_ZTERM  FOR ZTCUCLCST-ZTERM,     " Terms Of Payment
                   S_MWSKZ  FOR ZTCUCLCST-MWSKZ,     " Tax Code
                   S_WERKS  FOR ZTCUCLCST-ZFWERKS,   " Plant
                   S_OCDT   FOR ZTCUCLCST-ZFOCDT,    " 발생?
                   S_HBLNO  FOR ZTBL-ZFHBLNO.        " House B/L No
SELECTION-SCREEN END OF BLOCK B1.

*>>>> HELP
AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_ZTERM-LOW.
   PERFORM   P1000_GET_PAY_TERM   USING S_ZTERM-LOW.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_ZTERM-HIGH.
   PERFORM   P1000_GET_PAY_TERM   USING S_ZTERM-HIGH.

INITIALIZATION.                          " 초기값 SETTING
   PERFORM   P2000_INIT.

* Title Text Write
TOP-OF-PAGE.
  IF INCLUDE NE 'POPU'.
     PERFORM   P3000_TITLE_WRITE.                  " 해더 출력...
  ENDIF.
*-----------------------------------------------------------------------
* START OF SELECTION ?
*-----------------------------------------------------------------------
START-OF-SELECTION.

* Import System Configuration Check
  PERFORM   P2000_CONFIG_CHECK        USING   W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* 레포트 관련 TEXT TABLE SELECT
  PERFORM   P1000_READ_TEXT        USING W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

* 레포트 Write
   PERFORM   P3000_DATA_WRITE      USING W_ERR_CHK.
  IF W_ERR_CHK EQ 'Y'.    EXIT.    ENDIF.

*-----------------------------------------------------------------------
* User Command
*-----------------------------------------------------------------------
AT USER-COMMAND.

   CASE SY-UCOMM.
      WHEN 'MKAL' OR 'MKLO'.         " 전체 선택 및 선택해?
            PERFORM P2000_SELECT_RECORD   USING   SY-UCOMM.
      WHEN 'POST'.                  " 비용처리 Posting
            PERFORM P2000_MULTI_SELECTION.
            IF W_SELECTED_LINES EQ 0.
               MESSAGE S766. EXIT.
            ENDIF.
            PERFORM P4000_COST_POST       USING  W_ERR_CHK.
            DESCRIBE  TABLE IT_ERR_LIST   LINES  W_LINE.
            IF W_LINE GT 0.
               INCLUDE = 'POPU'.
               CALL SCREEN 0100 STARTING AT  05   3
                                ENDING   AT  100 12.
               CLEAR : INCLUDE.
            ENDIF.
            PERFORM   P1000_READ_TEXT        USING W_ERR_CHK.
            PERFORM RESET_LIST.
            IF W_ERR_CHK EQ 'Y'.
               MESSAGE S826 WITH W_PROC_CNT.
               LEAVE TO SCREEN 0.
            ENDIF.
            MESSAGE S826 WITH W_PROC_CNT.
      WHEN 'DOWN'.          " FILE DOWNLOAD....
*            PERFORM P3000_TO_PC_DOWNLOAD.
      WHEN 'REFR'.
            PERFORM   P1000_READ_TEXT        USING W_ERR_CHK.
            IF W_ERR_CHK EQ 'Y'.    LEAVE TO SCREEN 0.    ENDIF.
            PERFORM RESET_LIST.
            IF W_ERR_CHK EQ 'Y'.    LEAVE TO SCREEN 0.    ENDIF.
*------- Abbrechen (CNCL) ----------------------------------------------
      WHEN 'CNCL'.
         SET SCREEN 0.    LEAVE SCREEN.
*------- Suchen (SUCH) -------------------------------------------------
      WHEN 'SUCH'.
*------- Sortieren nach Feldbezeichnung (SORB) -------------------------
      WHEN 'SORB'.
*------- Sortieren nach Feldname (SORF) --------------------------------
      WHEN 'SORF'.
*------- Techn. Name ein/aus (TECH) ------------------------------------
      WHEN 'TECH'.
*------- Weiter suchen (WESU) ------------------------------------------
      WHEN 'WESU'.
      WHEN OTHERS.
   ENDCASE.
*-----------------------------------------------------------------------
*&   Event AT LINE-SELECTION
*-----------------------------------------------------------------------
AT LINE-SELECTION.
   CASE INCLUDE.
      WHEN 'POPU'.
         IF NOT IT_ERR_LIST-MSGTYP IS INITIAL.
            MESSAGE ID IT_ERR_LIST-MSGID TYPE IT_ERR_LIST-MSGTYP
                    NUMBER IT_ERR_LIST-MSGNR
                    WITH   IT_ERR_LIST-MSGV1
                           IT_ERR_LIST-MSGV2
                           IT_ERR_LIST-MSGV3
                           IT_ERR_LIST-MSGV4.
         ENDIF.
         CLEAR : IT_ERR_LIST.
     WHEN OTHERS.
  ENDCASE.

*&---------------------------------------------------------------------*
*&      Form  P2000_INIT
*&---------------------------------------------------------------------*
FORM P2000_INIT.

   SET TITLEBAR 'ZIMV4'.
   SELECT SINGLE *
     FROM ZTIMIMG11.

ENDFORM.                    " P2000_INIT
*&---------------------------------------------------------------------*
*&      Form  P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_TITLE_WRITE.

  SKIP 2.
  FORMAT COLOR COL_BACKGROUND INTENSIFIED OFF.
  WRITE : /40  '[ 관세/부가세 POSTING - 무환 ]'
               COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / 'Date : ', SY-DATUM, 89 'Page : ', W_PAGE.
  WRITE : / SY-ULINE.
  FORMAT COLOR COL_HEADING INTENSIFIED ON.
  WRITE : / SY-VLINE, ' ',  SY-VLINE NO-GAP,
            'House B/L No    '               NO-GAP, SY-VLINE NO-GAP,
            '발생일    '                     NO-GAP, SY-VLINE NO-GAP,
            '비용명'                         NO-GAP, SY-VLINE NO-GAP,
            '              금액      '       NO-GAP, SY-VLINE NO-GAP,
            'Vendor                        ' NO-GAP, SY-VLINE NO-GAP,
            'Cst Center'                     NO-GAP, SY-VLINE NO-GAP.
  FORMAT COLOR COL_HEADING INTENSIFIED OFF.
  WRITE : / SY-VLINE, ' ',                           SY-VLINE NO-GAP,
            'B/L 관리NO'                     NO-GAP, SY-VLINE NO-GAP,
            'Seq  '                          NO-GAP, SY-VLINE NO-GAP,
            '통관순번  '                     NO-GAP, SY-VLINE NO-GAP,
            '      '                         NO-GAP, SY-VLINE NO-GAP,
            '    Term/Tax/Plant      '       NO-GAP, SY-VLINE NO-GAP,
            '지불처                        ' NO-GAP, SY-VLINE NO-GAP,
            'Group Seq.'                     NO-GAP, SY-VLINE NO-GAP.
  WRITE : / SY-ULINE NO-GAP.

ENDFORM.                    " P3000_TITLE_WRITE
*&---------------------------------------------------------------------*
*&      Form  P3000_DATA_WRITE
*&---------------------------------------------------------------------*
FORM P3000_DATA_WRITE USING     W_ERR_CHK.

   MOVE 'N' TO W_ERR_CHK.

   SET PF-STATUS 'ZIMV4'.           " GUI STATUS SETTING
   SET  TITLEBAR 'ZIMV4'.           " GUI TITLE SETTING..

   W_PAGE = 1.     W_LINE = 0.     W_COUNT = 0.

   LOOP AT IT_TAB.
      W_LINE = W_LINE + 1.
      PERFORM P2000_PAGE_CHECK.
      PERFORM P3000_LINE_WRITE.

      AT LAST.
         PERFORM P3000_LAST_WRITE.
      ENDAT.

   ENDLOOP.
ENDFORM.                    " P3000_DATA_WRITE

*&---------------------------------------------------------------------*
*&      Form  P2000_PAGE_CHECK
*&---------------------------------------------------------------------*
FORM P2000_PAGE_CHECK.

   IF W_LINE >= 53.
      WRITE : / SY-ULINE.
      W_PAGE = W_PAGE + 1.    W_LINE = 0.
      NEW-PAGE.
   ENDIF.

ENDFORM.                    " P2000_PAGE_CHECK

*&---------------------------------------------------------------------*
*&      Form  P3000_LINE_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LINE_WRITE.

  FORMAT RESET.
  FORMAT COLOR COL_NORMAL INTENSIFIED ON.

  WRITE:/ SY-VLINE, MARKFIELD  AS CHECKBOX,
       SY-VLINE         NO-GAP,
       IT_TAB-ZFHBLNO          NO-GAP, " House B/L No
       SY-VLINE                NO-GAP,
       IT_TAB-ZFOCDT           NO-GAP, " 발생?
       SY-VLINE                NO-GAP,
       IT_TAB-ZFCSCD_NM        NO-GAP, " 비용명?
       SY-VLINE                NO-GAP,
       IT_TAB-ZFCAMT CURRENCY IT_TAB-ZFKRW NO-GAP, " 비용금?
       IT_TAB-ZFKRW            NO-GAP, " 금액통?
       SY-VLINE                NO-GAP,
       IT_TAB-ZFVEN            NO-GAP, " Vendor
       IT_TAB-ZFVEN_NM         NO-GAP, " Vendor ?
       SY-VLINE                NO-GAP,
       IT_TAB-KOSTL            NO-GAP, " Cost Center
       SY-VLINE                NO-GAP.
* Hide
       MOVE SY-TABIX  TO W_LIST_INDEX.
       HIDE: W_LIST_INDEX, IT_TAB.
       MODIFY IT_TAB INDEX SY-TABIX.

       FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
       WRITE : / SY-VLINE, ' ', SY-VLINE NO-GAP,
       IT_TAB-ZFBLNO           NO-GAP, " B/L 관리번?
       SY-VLINE                NO-GAP,
       IT_TAB-ZFCSQ            NO-GAP, " 비용순?
       SY-VLINE                NO-GAP,
       IT_TAB-ZFCLSEQ          NO-GAP, " 통관순?
       '     '                 NO-GAP,
       SY-VLINE                NO-GAP,
       IT_TAB-ZFCSCD           NO-GAP, " 비용코?
       '   '                   NO-GAP,
       SY-VLINE                NO-GAP,
       IT_TAB-BUKRS            NO-GAP,
       '/'                     NO-GAP,
       IT_TAB-ZTERM            NO-GAP, " Terms Of Payment
       '/'                     NO-GAP,
       IT_TAB-MWSKZ            NO-GAP, " Tax Code
       ' /'                    NO-GAP,
       IT_TAB-ZFWERKS          NO-GAP, " Plant
       '      '                NO-GAP,
       SY-VLINE                NO-GAP,
       IT_TAB-ZFPAY            NO-GAP, " 지불?
       IT_TAB-ZFPAY_NM         NO-GAP, " 지불처 ?
       SY-VLINE                NO-GAP,
       IT_TAB-GRP_MARK         NO-GAP, " Grouping Mark
       SY-VLINE                NO-GAP.

* Stored value...
  MOVE SY-TABIX  TO W_LIST_INDEX.
  HIDE: W_LIST_INDEX, IT_TAB.
  MODIFY IT_TAB INDEX SY-TABIX.
  W_COUNT = W_COUNT + 1.

  WRITE : / SY-ULINE.

ENDFORM.                    " P3000_LINE_WRITE

*&---------------------------------------------------------------------*
*&      Form  P3000_LAST_WRITE
*&---------------------------------------------------------------------*
FORM P3000_LAST_WRITE.

  IF W_COUNT GT 0.
     FORMAT RESET.
     WRITE : / '총', W_COUNT, '건'.
  ENDIF.

ENDFORM.                    " P3000_LAST_WRITE

*&---------------------------------------------------------------------*
*&      Form  RESET_LIST
*&---------------------------------------------------------------------*
FORM RESET_LIST.

  MOVE 0 TO SY-LSIND.

  W_PAGE = 1.
  W_LINE = 1.
  W_COUNT = 0.
  PERFORM   P3000_TITLE_WRITE.                  " 해더 출력...
* 레포트 Write
  PERFORM   P3000_DATA_WRITE          USING   W_ERR_CHK.

ENDFORM.                    " RESET_LIST
*&---------------------------------------------------------------------*
*&      Form  P1000_READ_TEXT
*&---------------------------------------------------------------------*
FORM P1000_READ_TEXT USING    W_ERR_CHK.

  CLEAR : SV_ZFVEN, SV_ZFPAY, SV_ZTERM, SV_MWSKZ,
          SV_ZFWERKS, SV_BUKRS, W_GRP_MARK.

  MOVE 'N' TO W_ERR_CHK.

  REFRESH : IT_TAB, IT_ZTIMIMG08.

  SELECT  *  INTO CORRESPONDING FIELDS OF TABLE IT_ZTIMIMG08
  FROM    ZTIMIMG08
  WHERE   ZFCDTY  =  '006'.

  SELECT  H~ZFHBLNO  I~ZFBLNO  I~ZFCLSEQ  I~ZFCSQ  I~ZFOCDT
          I~ZFCSCD   I~ZFCAMT  I~ZTERM    I~MWSKZ  I~ZFWERKS
          I~ZFVEN    I~ZFPAY   I~BUKRS    H~KOSTL  I~ZFKRW
  INTO    CORRESPONDING FIELDS OF TABLE IT_TAB
  FROM    ZTBL  AS  H  INNER  JOIN  ZTCUCLCST  AS  I
  ON      H~ZFBLNO  EQ I~ZFBLNO
  FOR     ALL ENTRIES  IN IT_ZTIMIMG08
  WHERE   I~ZFVEN        IN  S_VEN
  AND     I~ZFPAY        IN  S_PAY
  AND     I~ZTERM        IN  S_ZTERM
  AND     I~MWSKZ        IN  S_MWSKZ
  AND     I~ZFOCDT       IN  S_OCDT
  AND     H~ZFHBLNO      IN  S_HBLNO
  AND   ( I~ZFCSCD       EQ  '001'
  OR      I~ZFCSCD       EQ  '003'  )
  AND     I~ZFCSCD       EQ  IT_ZTIMIMG08-ZFCD
  AND     I~ZFCAMT       GT  0
  AND     I~ZFACDO       EQ  SPACE
  AND     H~ZFPOYN       EQ  'N'.

  SORT IT_TAB BY BUKRS  ZFVEN    ZFPAY ZTERM  MWSKZ   ZFWERKS WAERS.

  LOOP  AT  IT_TAB.

    W_TABIX  =  SY-TABIX.
* 무환건만 Check!
    SELECT  SINGLE  *  FROM  ZTIDS
    WHERE   ZFBLNO  EQ IT_TAB-ZFBLNO
    AND     ZFCLSEQ EQ IT_TAB-ZFCLSEQ
    AND     ZFITKD  EQ 'R'
    AND     ZFPONC  NE '11'.

    IF  SY-SUBRC  NE  0.
        DELETE  IT_TAB INDEX W_TABIX.
        CONTINUE.
    ENDIF.

    IF  IT_TAB-BUKRS    NE  SV_BUKRS    OR
        IT_TAB-ZFVEN    NE  SV_ZFVEN    OR
        IT_TAB-ZFPAY    NE  SV_ZFPAY    OR
        IT_TAB-ZTERM    NE  SV_ZTERM    OR
        IT_TAB-MWSKZ    NE  SV_MWSKZ    OR
        IT_TAB-ZFWERKS  NE  SV_ZFWERKS  .
        ADD   1         TO  W_GRP_MARK.

        MOVE  IT_TAB-BUKRS   TO  SV_BUKRS.
        MOVE  IT_TAB-ZFVEN   TO  SV_ZFVEN.
        MOVE  IT_TAB-ZFPAY   TO  SV_ZFPAY.
        MOVE  IT_TAB-ZTERM   TO  SV_ZTERM.
        MOVE  IT_TAB-MWSKZ   TO  SV_MWSKZ.
        MOVE  IT_TAB-ZFWERKS TO  SV_ZFWERKS.
    ENDIF.
    MOVE  W_GRP_MARK  TO  IT_TAB-GRP_MARK.
*지불처, 거래처명 DISPLAY.
    SELECT  SINGLE NAME1  INTO  IT_TAB-ZFVEN_NM
    FROM    LFA1   WHERE  LIFNR  EQ  IT_TAB-ZFVEN.

    SELECT  SINGLE NAME1  INTO  IT_TAB-ZFPAY_NM
    FROM    LFA1   WHERE  LIFNR  EQ  IT_TAB-ZFPAY.

    IF  IT_TAB-ZFCSCD  =  '001'.
        MOVE  '관세'   TO  IT_TAB-ZFCSCD_NM.
    ELSE.
        MOVE  '부가세' TO  IT_TAB-ZFCSCD_NM.
    ENDIF.

    MODIFY  IT_TAB  INDEX  W_TABIX.
  ENDLOOP.

  SORT IT_TAB BY GRP_MARK  ZFBLNO  ZFCLSEQ  ZFCSQ .

  DESCRIBE TABLE IT_TAB LINES W_COUNT.
  IF W_COUNT = 0.
     MESSAGE S738. W_ERR_CHK = 'Y'.
  ENDIF.

ENDFORM.                    " P1000_READ_TEXT
*&---------------------------------------------------------------------*
*&      Form  P2000_MULTI_SELECTION
*&---------------------------------------------------------------------*
FORM P2000_MULTI_SELECTION.

  REFRESH IT_SELECTED.
  CLEAR   IT_SELECTED.
  CLEAR W_SELECTED_LINES.

  DO.
    CLEAR MARKFIELD.
    READ LINE SY-INDEX FIELD VALUE MARKFIELD.
    IF SY-SUBRC NE 0.   EXIT.   ENDIF.        " EXIT CHECKING
    IF ( MARKFIELD EQ 'x' ) OR ( MARKFIELD EQ 'X' ).
         MOVE : IT_TAB-ZFBLNO      TO IT_SELECTED-ZFBLNO,
                IT_TAB-ZFCLSEQ     TO IT_SELECTED-ZFCLSEQ,
                IT_TAB-ZFCSQ       TO IT_SELECTED-ZFCSQ,
                IT_TAB-ZFCSCD      TO IT_SELECTED-ZFCSCD,
                IT_TAB-BUKRS       TO IT_SELECTED-BUKRS,
                IT_TAB-ZFVEN       TO IT_SELECTED-ZFVEN,
                IT_TAB-ZFPAY       TO IT_SELECTED-ZFPAY,
                IT_TAB-ZTERM       TO IT_SELECTED-ZTERM,
                IT_TAB-MWSKZ       TO IT_SELECTED-MWSKZ,
                IT_TAB-ZFWERKS     TO IT_SELECTED-ZFWERKS,
                IT_TAB-ZFCSCD      TO IT_SELECTED-ZFCSCD,
                IT_TAB-ZFCAMT      TO IT_SELECTED-ZFCAMT,
                IT_TAB-GRP_MARK    TO IT_SELECTED-GRP_MARK.
      APPEND IT_SELECTED.
      ADD 1 TO W_SELECTED_LINES.
    ENDIF.
  ENDDO.

ENDFORM.                    " P2000_MULTI_SELECTION


*&---------------------------------------------------------------------*
*&      Form  P4000_COST_POST
*&---------------------------------------------------------------------*
FORM P4000_COST_POST USING    P_W_ERR_CHK.

  REFRESH : IT_ERR_LIST.
  CLEAR : SUM_ZFCAMT, SUM_ZFCAMT1, SUM_ZFCAMT2.
  MOVE 'N' TO W_ERR_CHK.

  SORT IT_SELECTED BY GRP_MARK ASCENDING.

  CLEAR W_PROC_CNT.
*>> MESSAGE BOX.
  PERFORM P4000_GET_INIVAL.
  IF ANWORT NE 'Y'.
     EXIT.
  ENDIF.

  REFRESH IT_SELECTED_SUM.
  CLEAR   IT_SELECTED_SUM.
  LOOP AT IT_SELECTED.
    IF SY-TABIX = 1.
       MOVE  IT_SELECTED-GRP_MARK   TO  GRP_MARK_T.
    ENDIF.

    IF IT_SELECTED-GRP_MARK  NE  GRP_MARK_T.
       MOVE  IT_SELECTED-GRP_MARK  TO  GRP_MARK_T.
       MOVE  IT_SELECTED-BUKRS     TO  IT_SELECTED_SUM-BUKRS.
       MOVE  IT_SELECTED-ZFVEN     TO  IT_SELECTED_SUM-ZFVEN.
       MOVE  IT_SELECTED-ZFPAY     TO  IT_SELECTED_SUM-ZFPAY.
       MOVE  IT_SELECTED-ZTERM     TO  IT_SELECTED_SUM-ZTERM.
       MOVE  IT_SELECTED-MWSKZ     TO  IT_SELECTED_SUM-MWSKZ.
       MOVE  IT_SELECTED-ZFWERKS   TO  IT_SELECTED_SUM-ZFWERKS.
       MOVE  IT_SELECTED-GRP_MARK  TO  IT_SELECTED_SUM-GRP_MARK.
       MOVE  SUM_ZFCAMT            TO  IT_SELECTED_SUM-ZFCAMT.
       MOVE  SUM_ZFCAMT1           TO  IT_SELECTED_SUM-ZFCAMT_1.
       MOVE  SUM_ZFCAMT2           TO  IT_SELECTED_SUM-ZFCAMT_2.
       APPEND    IT_SELECTED_SUM.

       MOVE  0                     TO  SUM_ZFCAMT.
       MOVE  0                     TO  SUM_ZFCAMT1.
       MOVE  0                     TO  SUM_ZFCAMT2.
    ENDIF.
    ADD  IT_SELECTED-ZFCAMT   TO  SUM_ZFCAMT.
    IF IT_SELECTED-ZFCSCD  =  '001'.
       ADD  IT_SELECTED-ZFCAMT  TO  SUM_ZFCAMT1.
    ELSE.
       ADD  IT_SELECTED-ZFCAMT  TO  SUM_ZFCAMT2.
    ENDIF.
  ENDLOOP.
*>> 마지막 LINE 의 DATA WRITE!
  MOVE  IT_SELECTED-BUKRS     TO  IT_SELECTED_SUM-BUKRS.
  MOVE  IT_SELECTED-ZFVEN     TO  IT_SELECTED_SUM-ZFVEN.
  MOVE  IT_SELECTED-ZFPAY     TO  IT_SELECTED_SUM-ZFPAY.
  MOVE  IT_SELECTED-ZTERM     TO  IT_SELECTED_SUM-ZTERM.
  MOVE  IT_SELECTED-MWSKZ     TO  IT_SELECTED_SUM-MWSKZ.
  MOVE  IT_SELECTED-ZFWERKS   TO  IT_SELECTED_SUM-ZFWERKS.
  MOVE  IT_SELECTED-GRP_MARK  TO  IT_SELECTED_SUM-GRP_MARK.
  MOVE  SUM_ZFCAMT            TO  IT_SELECTED_SUM-ZFCAMT.
  MOVE  SUM_ZFCAMT1           TO  IT_SELECTED_SUM-ZFCAMT_1.
  MOVE  SUM_ZFCAMT2           TO  IT_SELECTED_SUM-ZFCAMT_2.
  APPEND    IT_SELECTED_SUM.

  LOOP AT IT_SELECTED_SUM.
     REFRESH : IT_LOCKED.
*>> 오류 검증....
     IF IT_SELECTED_SUM-BUKRS IS INITIAL.
        MESSAGE S167 WITH '회사코드'.
        PERFORM  P2000_SINGLE_MESS_MAKE.
        CONTINUE.
     ENDIF.
     IF IT_SELECTED_SUM-ZTERM IS INITIAL.
        MESSAGE S167 WITH '지급 조건'.
        PERFORM  P2000_SINGLE_MESS_MAKE.
        CONTINUE.
     ENDIF.
     IF IT_SELECTED_SUM-ZFVEN IS INITIAL.
        MESSAGE S167 WITH '거래처 코드'.
        PERFORM  P2000_SINGLE_MESS_MAKE.
        CONTINUE.
     ENDIF.
     IF IT_SELECTED_SUM-ZFWERKS IS INITIAL.
        MESSAGE S167 WITH '플랜트'.
        PERFORM  P2000_SINGLE_MESS_MAKE.
        CONTINUE.
     ENDIF.
*>> 해당 수입비용.
     REFRESH  : IT_ZTCUCST.
     LOOP AT IT_TAB WHERE  BUKRS   EQ   IT_SELECTED_SUM-BUKRS
                    AND    ZFVEN   EQ   IT_SELECTED_SUM-ZFVEN
                    AND    ZFPAY   EQ   IT_SELECTED_SUM-ZFPAY
                    AND    ZTERM   EQ   IT_SELECTED_SUM-ZTERM
                    AND    MWSKZ   EQ   IT_SELECTED_SUM-MWSKZ
                    AND    ZFWERKS EQ   IT_SELECTED_SUM-ZFWERKS.

        SELECT *  APPENDING TABLE IT_ZTCUCST
                  FROM   ZTCUCLCST
                  WHERE  ZFBLNO   EQ   IT_TAB-ZFBLNO
                  AND    ZFCLSEQ  EQ   IT_TAB-ZFCLSEQ
                  AND    ZFCSQ    EQ   IT_TAB-ZFCSQ.

     ENDLOOP.
*>> LOCK MODE.
    CLEAR : W_LOCK_CHK.
    SORT IT_ZTCUCST BY ZFBLNO ZFCLSEQ.
    LOOP AT IT_ZTCUCST.
       ON CHANGE OF IT_ZTCUCST-ZFBLNO OR IT_ZTCUCST-ZFCLSEQ.
           PERFORM  P2000_SET_LOCK_MODE   USING IT_ZTCUCST-ZFBLNO
                                                IT_ZTCUCST-ZFCLSEQ
                                               'L'    W_SUBRC.
         IF SY-SUBRC EQ 0.
            MOVE IT_ZTCUCST-ZFBLNO  TO IT_LOCKED-ZFBLNO.
            MOVE IT_ZTCUCST-ZFCLSEQ TO IT_LOCKED-ZFCLSEQ.
            APPEND IT_LOCKED.
         ELSE.
            W_LOCK_CHK = 'Y'.
            PERFORM  P2000_SINGLE_MESS_MAKE.
            EXIT.
         ENDIF.
      ENDON.
   ENDLOOP.

   IF W_LOCK_CHK EQ 'Y'.
      CONTINUE.
   ENDIF.
*>> BAPIs Function
*     PERFORM  P2000_GL_DATA_MAKE    USING   W_SUBRC.
**>> BDC DATA MAKE.
     PERFORM COST_BDC_INSERT.
*>>PARAMETER CLEAR.
     SET PARAMETER ID 'BLN' FIELD ''.        " 전표번호.
     SET PARAMETER ID 'GJR' FIELD ''.        " 회계년도.

*>> BDC CALL.
     PERFORM P2000_CALL_TRANSACTION USING     'F-42'
                                              W_SUBRC.

     IF W_SUBRC NE 0.      ">> ERROR 발생시.
        PERFORM  P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST.
        ADD    1    TO    W_ERR_CNT.
        CONTINUE.
     ELSE.                 ">> SUCCESS 시.
        GET PARAMETER ID 'BLN' FIELD ZFACDO.        " 전표번호.
        GET PARAMETER ID 'GJR' FIELD ZFFIYR.        " 회계년도.
*>> 전표번호가 전달되지 않을 경우.
        IF ZFACDO IS INITIAL AND ZFFIYR IS INITIAL.
*>>> 오류..(사용자 종결 등....)
           MESSAGE S494.
           PERFORM  P2000_SINGLE_MESS_MAKE.
           CONTINUE.
        ENDIF.

        LOOP AT IT_ZTCUCST.

           MOVE : ZFACDO      TO     IT_ZTCUCST-ZFACDO,
                  ZFFIYR      TO     IT_ZTCUCST-ZFFIYR,
                  W_POSDT     TO     IT_ZTCUCST-ZFPSDT,
                  W_DOCDT     TO     IT_ZTCUCST-ZFOCDT,
                  SY-UNAME    TO     IT_ZTCUCST-UNAM,
                  SY-DATUM    TO     IT_ZTCUCST-UDAT.
           MODIFY  IT_ZTCUCST  INDEX   SY-TABIX.
        ENDLOOP.
        MODIFY ZTCUCLCST FROM TABLE IT_ZTCUCST.
        PERFORM  P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST.
       ENDIF.
       ADD 1       TO W_PROC_CNT.
  ENDLOOP.

ENDFORM.                    " P4000_COST_POST

*&---------------------------------------------------------------------*
*&      Form  P4000_GET_INIVAL
*&---------------------------------------------------------------------*
FORM P4000_GET_INIVAL.

  MOVE 'Initial Value' TO SPOP-TITEL.
*  MOVE 'X'             TO RADIO_NONE.
  IF W_POSDT IS INITIAL.
     MOVE SY-DATUM    TO W_POSDT.
  ENDIF.
  IF W_DOCDT IS INITIAL.
     MOVE SY-DATUM    TO W_DOCDT.
  ENDIF.

  CALL SCREEN 0010 STARTING AT 15 1
                   ENDING   AT 56 14.

  IF RADIO_NONE = 'X'.
     DISP_MODE = 'N'.
  ENDIF.
  IF RADIO_ALL = 'X'.
     DISP_MODE = 'A'.
  ENDIF.
  IF RADIO_ERROR = 'X'.
     DISP_MODE = 'E'.
  ENDIF.

ENDFORM.                    " P4000_GET_INIVAL

*&---------------------------------------------------------------------*
*&      Module  SET_STATUS_SCR0010  OUTPUT
*&---------------------------------------------------------------------*
MODULE SET_STATUS_SCR0010 OUTPUT.

   SET TITLEBAR 'POPU' WITH SPOP-TITEL.
   SET PF-STATUS 'POPU'.

ENDMODULE.                 " SET_STATUS_SCR0010  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  GET_OK_CODE_SCR0010  INPUT
*&---------------------------------------------------------------------*
MODULE GET_OK_CODE_SCR0010 INPUT.

  IF OK-CODE EQ 'ENTR' OR OK-CODE EQ 'YES'.
     ANWORT = 'Y'.
     SET SCREEN 0.
     LEAVE SCREEN.
  ELSEIF OK-CODE EQ 'CANC' OR OK-CODE EQ 'NO'.
     ANWORT = 'N'.
     SET SCREEN 0.   LEAVE SCREEN.
  ENDIF.

ENDMODULE.                 " GET_OK_CODE_SCR0010  INPUT

*&---------------------------------------------------------------------*
*&      Form  COST_BDC_INSERT
*&---------------------------------------------------------------------*
FORM COST_BDC_INSERT.

DATA :   L_ZFPAY     LIKE   IT_SELECTED-ZFPAY,
         L_ZFIOCAC1  LIKE   ZTIMIMG11-ZFIOCAC1.

  W_WRBTR = IT_SELECTED_SUM-ZFCAMT.
  WRITE W_WRBTR CURRENCY 'KRW' TO TEMP_WRBTR.
*--------------------------------------------------------------------
* J_1BT001WV ===> ZVT001W VIEW CREATE
*  Database View가 아니기 때문에 Select시 오류가 발생하는 것 같음????
*--------------------------------------------------------------------
  CLEAR : ZVT001W.
  SELECT SINGLE * FROM ZVT001W
                  WHERE WERKS EQ IT_SELECTED_SUM-ZFWERKS.
*>> 지불처가 다를 경우.
  IF NOT ( IT_SELECTED_SUM-ZFPAY IS INITIAL ) AND
         ( IT_SELECTED_SUM-ZFVEN NE IT_SELECTED-ZFPAY ).
     L_ZFPAY  =  IT_SELECTED_SUM-ZFPAY. " Payee
  ELSE.
     CLEAR L_ZFPAY.
  ENDIF.

  REFRESH : BDCDATA.
* 초기화면 FIELD
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0100',
      ' ' 'BKPF-BLDAT'   W_DOCDT,                " Document Date
      ' ' 'BKPF-BLART'  'KR',                    " Type
      ' ' 'BKPF-BUKRS'   IT_SELECTED_SUM-BUKRS,  " Company Code
      ' ' 'BKPF-BUDAT'   W_POSDT,            " Posting Date
      ' ' 'BKPF-BLDAT'   W_DOCDT,            " Document Date
      ' ' 'BKPF-WAERS'  'KRW',               " Currency
      ' ' 'BKPF-KURSF'  '',                  " 환율.
      ' ' 'BKPF-BELNR'  SPACE,               " 회계전표번호.
      ' ' 'BKPF-WWERT'  SPACE,               " 환산일.
      ' ' 'BKPF-XBLNR'  SPACE,               " 참조문서번호.
      ' ' 'BKPF-BVORG'  SPACE,               " 회사코드간 거래번호.
      ' ' 'BKPF-BKTXT'  '관세/부가세(무환)',
      ' ' 'RF05A-PARGB' SPACE,               " 관계사 사업영역.
      ' ' 'RF05A-NEWBS' '31',                " Posting Key
      ' ' 'RF05A-NEWKO'  IT_SELECTED_SUM-ZFVEN,  " Account
      ' ' 'RF05A-NEWUM'  SPACE,              "다음 개별항목특별 G/L지시.
      ' ' 'RF05A-NEWBW'  SPACE,              " 자산거래유형.
      ' ' 'BDC_OKCODE'  '/00'.               " ENTER

* NEXT SCREEN.
  PERFORM P2000_DYNPRO USING :
      'X' 'SAPMF05A'    '0302',
      ' ' 'BSEG-WRBTR'  TEMP_WRBTR,            " Amount
      ' ' 'BSEG-WMWST'  TEMP_WMWST,            " Tax
      ' ' 'BKPF-XMWST'  SPACE,                 " 세금을 자동으로 계산.
      ' ' 'BSEG-MWSKZ'  IT_SELECTED_SUM-MWSKZ,     " Tax Code
      ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
      ' ' 'BSEG-SECCO'  SPACE,                 " 섹션코드.
      ' ' 'BSEG-GSBER'  BSEG-GSBER,            " Business Area
      ' ' 'BSEG-ZTERM'  IT_SELECTED_SUM-ZTERM,     " Payment Term
*      ' ' 'BSEG-EMPFB'  L_ZFPAY,               " Payee
      ' ' 'BSEG-ZLSPR'  'B',                   " 지급보류.
      ' ' 'BSEG-SGTXT'  '관세/부가세(무환)'.
*>> 부가세가 존재하면...
  IF IT_SELECTED_SUM-ZFCAMT_2 GT 0.
     L_ZFIOCAC1  =  ZTIMIMG11-ZFIOCAC6.
     W_WRBTR = IT_SELECTED_SUM-ZFCAMT_2.
     WRITE W_WRBTR CURRENCY 'KRW' TO TEMP_WRBTR.
     PERFORM P2000_DYNPRO USING :
         ' ' 'RF05A-NEWBS' '40',                  " Posting Key
         ' ' 'RF05A-NEWKO' L_ZFIOCAC1,            " ACCOUNT
         ' ' 'BDC_OKCODE'  '/00',                  " ENTER
         'X' 'SAPMF05A'    '0300',
         ' ' 'BSEG-WRBTR'  TEMP_WRBTR,
         ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
         ' ' 'BSEG-SGTXT'  '관세/부가세(무환)'.   " 텍스트.
  ENDIF.
*>> 관세가 존재하면...
  IF IT_SELECTED_SUM-ZFCAMT_1 GT 0.
     L_ZFIOCAC1  =  ZTIMIMG11-ZFIOCAC9.
     LOOP AT IT_SELECTED  WHERE GRP_MARK = IT_SELECTED_SUM-GRP_MARK
                          AND   ZFCSCD   = '001'.
        W_WRBTR = IT_SELECTED-ZFCAMT.
        WRITE  W_WRBTR  CURRENCY 'KRW' TO TEMP_WRBTR.
        PERFORM P2000_DYNPRO USING :
            ' ' 'RF05A-NEWBS' '40',                  " Posting Key
            ' ' 'RF05A-NEWKO' L_ZFIOCAC1,            " ACCOUNT
            ' ' 'BDC_OKCODE'  '/00',                  " ENTER
**            'X' 'SAPLKACB'     '0002',
*            ' ' 'COBL-GSBER'   BSEG-GSBER,    " 사업영역.TEST
*           ' ' 'COBL-KOSTL'   COBL-KOSTL,    " COST CENTER TEST
*           ' ' 'COBL-PRCTR'   COBL-PRCTR,    " 손익센터.
*           ' ' 'BDC_OKCODE'   '/00',         " ENTER
            'X' 'SAPMF05A'    '0300',
            ' ' 'BSEG-WRBTR'  TEMP_WRBTR,
            ' ' 'BSEG-BUPLA'  ZVT001W-J_1BBRANCH,    " Business Place
            ' ' 'BSEG-SGTXT'  '관세/부가세(무환)'.   " 텍스트.
     ENDLOOP.
  ENDIF.

  PERFORM P2000_DYNPRO USING :
      ' ' 'BDC_OKCODE'   'BU',                  " 저장.
      'X' 'SAPLKACB'     '0002',
      ' ' 'COBL-GSBER'   BSEG-GSBER,    " 사업영역.TEST
*      ' ' 'COBL-KOSTL'   COBL-KOSTL,    " COST CENTER TEST
      ' ' 'COBL-PRCTR'   COBL-PRCTR,    " 손익센터.
      ' ' 'BDC_OKCODE'   '/00'.         " ENTER

ENDFORM.                    " COST_BDC_INSERT

*&---------------------------------------------------------------------*
*&      Form  A_ZBDCDATA
*&---------------------------------------------------------------------*
FORM A_ZBDCDATA USING BEGIN_CHECK OBJNAM VALUE.

  CLEAR ZBDCDATA.
  IF BEGIN_CHECK = 'X'.
     MOVE : OBJNAM TO ZBDCDATA-PROGRAM,
            VALUE  TO ZBDCDATA-DYNPRO,
            BEGIN_CHECK TO ZBDCDATA-DYNBEGIN.
  ELSE.
     MOVE : OBJNAM TO ZBDCDATA-FNAM,
            VALUE  TO ZBDCDATA-FVAL.
  ENDIF.
  APPEND ZBDCDATA.

ENDFORM.                    " A_ZBDCDATA

*&---------------------------------------------------------------------*
*&      Form  P1000_GET_PAY_TERM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_S_ZTERM_LOW  text
*----------------------------------------------------------------------*
FORM P1000_GET_PAY_TERM USING    P_ZTERM.

   TABLES : T052.

   CALL FUNCTION 'FI_F4_ZTERM'
         EXPORTING
              I_KOART       = 'K'
              I_ZTERM       = P_ZTERM
              I_XSHOW       = ' '
         IMPORTING
              E_ZTERM       = T052-ZTERM
         EXCEPTIONS
              NOTHING_FOUND = 01.


  IF SY-SUBRC NE 0.
*   message e177 with ekko-zterm.
    MESSAGE S177(06) WITH P_ZTERM.
    EXIT.
  ENDIF.

  IF T052-ZTERM NE SPACE.
     P_ZTERM = T052-ZTERM.
  ENDIF.

ENDFORM.                    " P1000_GET_PAY_TERM

*&---------------------------------------------------------------------*
*&      Form  P2000_SELECT_RECORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_SY_UCOMM  text
*----------------------------------------------------------------------*
FORM P2000_SELECT_RECORD USING    P_SY_UCOMM.
DATA : WL_MARK.

   IF P_SY_UCOMM EQ 'MKAL'.
      WL_MARK = 'X'.
   ELSEIF P_SY_UCOMM EQ 'MKLO'.
      CLEAR : WL_MARK.
   ENDIF.
   DO.
      CLEAR MARKFIELD.
      READ LINE SY-INDEX FIELD VALUE MARKFIELD.
      IF SY-SUBRC NE 0.    EXIT.   ENDIF.
      MODIFY CURRENT LINE FIELD VALUE MARKFIELD FROM WL_MARK.
   ENDDO.

ENDFORM.                    " P2000_SELECT_RECORD
*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN_SCR0010  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE MODIFY_SCREEN_SCR0010 OUTPUT.

  AUTHORITY-CHECK OBJECT 'ZM_BDC_MGT'
                  ID 'ACTVT' FIELD '*'.
  W_SY_SUBRC = SY-SUBRC.

  LOOP AT SCREEN.

    IF W_SY_SUBRC NE 0 AND SY-DYNNR EQ '0010'.
       IF SCREEN-NAME(10) EQ 'RADIO_NONE'  OR
          SCREEN-NAME(09) EQ 'RADIO_ALL'   OR
          SCREEN-NAME(11) EQ 'RADIO_ERROR' OR
          SCREEN-NAME(06) EQ 'BLOCK2'.
          SCREEN-INVISIBLE = 1.
       ENDIF.
    ENDIF.

    MODIFY SCREEN.

  ENDLOOP.

ENDMODULE.                 " MODIFY_SCREEN_SCR0010  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_INPUT_FIELD_SCR0010  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CHECK_INPUT_FIELD_SCR0010 INPUT.

  IF NOT ( OK-CODE EQ 'YES' OR OK-CODE EQ 'ENTR' ).
     EXIT.
  ENDIF.

   IF W_POSDT IS INITIAL.
      MESSAGE E167 WITH '증빙일'.
   ENDIF.
   IF W_DOCDT IS INITIAL.
      MESSAGE E167 WITH '전기일'.
   ENDIF.
   IF BSEG-GSBER IS INITIAL.
      PERFORM NO_INPUT(SAPFMMEX) USING 'BSEG' 'GSBER'.
   ENDIF.

ENDMODULE.                 " CHECK_INPUT_FIELD_SCR0010  INPUT
*&---------------------------------------------------------------------*
*&      Module  D0100_STATUS_SCR0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE D0100_STATUS_SCR0100 OUTPUT.
  SET PF-STATUS 'STDLISW'.

  CASE INCLUDE.
     WHEN 'POPU'.
        SET TITLEBAR 'POPU' WITH '오류 LIST'.
     WHEN OTHERS.
  ENDCASE.

  SUPPRESS DIALOG.

ENDMODULE.                 " D0100_STATUS_SCR0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  D0100_LIST_CHECK_SCR0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE D0100_LIST_CHECK_SCR0100 INPUT.
   LEAVE TO LIST-PROCESSING.
   CASE INCLUDE.
      WHEN 'POPU'.
         FORMAT COLOR COL_HEADING INTENSIFIED OFF.
         WRITE : / SY-ULINE(96),    /   SY-VLINE NO-GAP,
                   '유형'   NO-GAP,     SY-VLINE NO-GAP,
                   '메세지 텍스트',  94 SY-VLINE NO-GAP,
                   'T'      NO-GAP,     SY-VLINE,
                 / SY-ULINE(96).
         LOOP AT IT_ERR_LIST.
            W_MOD  =  SY-TABIX MOD 2.
            FORMAT RESET.
            IF W_MOD EQ 0.
               FORMAT COLOR COL_NORMAL  INTENSIFIED ON.
            ELSE.
               FORMAT COLOR COL_NORMAL  INTENSIFIED OFF.
            ENDIF.
            WRITE : / SY-VLINE NO-GAP, IT_ERR_LIST-ICON(4) NO-GAP,
                      SY-VLINE NO-GAP, IT_ERR_LIST-MESSTXT(87) NO-GAP,
                      SY-VLINE NO-GAP.

            CASE IT_ERR_LIST-MSGTYP.
               WHEN 'E'.
                  FORMAT COLOR COL_NEGATIVE INTENSIFIED OFF.
               WHEN 'W'.
                  FORMAT COLOR COL_KEY      INTENSIFIED OFF.
               WHEN 'I'.
                  FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.
               WHEN 'S'.
                  FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.
            ENDCASE.

            WRITE : IT_ERR_LIST-MSGTYP(1) NO-GAP, SY-VLINE NO-GAP.
*                   / SY-ULINE(96).
            HIDE:IT_ERR_LIST.
         ENDLOOP.
         WRITE : / SY-ULINE(96).
         CLEAR : IT_ERR_LIST.
      WHEN OTHERS.
   ENDCASE.

ENDMODULE.                 " D0100_LIST_CHECK_SCR0100  INPUT
*&---------------------------------------------------------------------*
*&      Form  P2000_SET_LOCK_MODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_ZTCUCST_ZFBLNO  text
*      -->P_IT_ZTCUCST_ZFCLSEQ  text
*      -->P_1378   text
*      -->P_W_SUBRC  text
*----------------------------------------------------------------------*
FORM P2000_SET_LOCK_MODE USING    P_ZFBLNO
                                  P_ZFCLSEQ
                                  PA_MODE
                                  W_SUBRC.
  IF PA_MODE EQ 'L'.
    CALL FUNCTION 'ENQUEUE_EZ_IM_ZTIDS'
         EXPORTING
              ZFBLNO  = P_ZFBLNO
              ZFCLSEQ = P_ZFCLSEQ
         EXCEPTIONS
              OTHERS  = 1.

    W_SUBRC = SY-SUBRC.

    IF W_SUBRC <> 0.
       MESSAGE S510 WITH SY-MSGV1 '통관 Cost'
                         P_ZFBLNO P_ZFCLSEQ
                    RAISING DOCUMENT_LOCKED.
    ENDIF.
  ELSEIF PA_MODE EQ 'U'.

    CALL FUNCTION 'DEQUEUE_EZ_IM_ZTIDS'
         EXPORTING
              ZFBLNO  = P_ZFBLNO
              ZFCLSEQ = P_ZFCLSEQ.
    W_SUBRC = SY-SUBRC.
  ENDIF.


ENDFORM.                    " P2000_SET_LOCK_MODE

*&---------------------------------------------------------------------*
*&      Form  P2000_SINGLE_MESS_MAKE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM P2000_SINGLE_MESS_MAKE.

   REFRESH : MESSTAB.
   MOVE : 'E'                 TO     MESSTAB-MSGTYP,
          SY-MSGID            TO     MESSTAB-MSGID,
          SY-MSGNO            TO     MESSTAB-MSGNR,
          SY-MSGV1            TO     MESSTAB-MSGV1,
          SY-MSGV2            TO     MESSTAB-MSGV2,
          SY-MSGV3            TO     MESSTAB-MSGV3,
          SY-MSGV4            TO     MESSTAB-MSGV4.
   APPEND MESSTAB.

   PERFORM  P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST.

*>> UNLOCKED.
   LOOP AT IT_LOCKED.
      PERFORM  P2000_SET_LOCK_MODE   USING IT_LOCKED-ZFBLNO
                                           IT_LOCKED-ZFCLSEQ
                                           'U'    W_SUBRC.
   ENDLOOP.


ENDFORM.                    " P2000_SINGLE_MESS_MAKE

*&---------------------------------------------------------------------*
*&      Form  P2000_MESSAGE_MAKE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IT_ERR_LIST  text
*----------------------------------------------------------------------*
FORM P2000_MESSAGE_MAKE  TABLES  IT_ERR_LIST  STRUCTURE IT_ERR_LIST.

   LOOP AT MESSTAB.

      MOVE : MESSTAB-MSGTYP           TO     IT_ERR_LIST-MSGTYP,
             MESSTAB-MSGID            TO     IT_ERR_LIST-MSGID,
             MESSTAB-MSGNR            TO     IT_ERR_LIST-MSGNR,
             MESSTAB-MSGV1            TO     IT_ERR_LIST-MSGV1,
             MESSTAB-MSGV2            TO     IT_ERR_LIST-MSGV2,
             MESSTAB-MSGV3            TO     IT_ERR_LIST-MSGV3,
             MESSTAB-MSGV4            TO     IT_ERR_LIST-MSGV4.

       CALL FUNCTION 'MESSAGE_TEXT_BUILD'
            EXPORTING
                   MSGID               = IT_ERR_LIST-MSGID
                   MSGNR               = IT_ERR_LIST-MSGNR
                   MSGV1               = IT_ERR_LIST-MSGV1
                   MSGV2               = IT_ERR_LIST-MSGV2
                   MSGV3               = IT_ERR_LIST-MSGV3
                   MSGV4               = IT_ERR_LIST-MSGV4
            IMPORTING
                   MESSAGE_TEXT_OUTPUT = IT_ERR_LIST-MESSTXT.

      CASE IT_ERR_LIST-MSGTYP.
         WHEN 'E'.
            MOVE ICON_LED_RED             TO     IT_ERR_LIST-ICON.
         WHEN 'I'.
            MOVE ICON_LED_GREEN           TO     IT_ERR_LIST-ICON.
         WHEN 'S'.
            MOVE ICON_LED_GREEN           TO     IT_ERR_LIST-ICON.
         WHEN 'W'.
            MOVE ICON_LED_YELLOW          TO     IT_ERR_LIST-ICON.
         WHEN OTHERS.
            MOVE ICON_LED_RED             TO     IT_ERR_LIST-ICON.
      ENDCASE.

      APPEND  IT_ERR_LIST.

   ENDLOOP.
*>> UNLOCKED.
   LOOP AT IT_LOCKED.
      PERFORM  P2000_SET_LOCK_MODE   USING IT_LOCKED-ZFBLNO
                                           IT_LOCKED-ZFCLSEQ
                                           'U'    W_SUBRC.
   ENDLOOP.


ENDFORM.                    " P2000_MESSAGE_MAKE
*&---------------------------------------------------------------------*
*&      Form  P2000_CONFIG_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_W_ERR_CHK  text
*----------------------------------------------------------------------*
FORM P2000_CONFIG_CHECK USING    W_ERR_CHK.

  W_ERR_CHK = 'N'.
* Import Config Select
  SELECT SINGLE * FROM ZTIMIMG00.
* Not Found
  IF SY-SUBRC NE 0.
     W_ERR_CHK = 'Y'.   MESSAGE S961.   EXIT.
  ENDIF.

  IF ZTIMIMG00-ZFPSMS NE 1.
     W_ERR_CHK = 'Y'.   MESSAGE S573.   EXIT.
  ENDIF.

ENDFORM.                    " P2000_CONFIG_CHECK

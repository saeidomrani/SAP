FUNCTION ZIM_APP707_EDI_SEND.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(W_ZFREQNO) LIKE  ZTREQHD-ZFREQNO
*"     VALUE(W_ZFAMDNO) LIKE  ZTREQST-ZFAMDNO
*"     VALUE(W_ZFDHENO) LIKE  ZTDHF1-ZFDHENO
*"  EXCEPTIONS
*"      DB_ERROR
*"----------------------------------------------------------------------

   CALL FUNCTION 'ZIM_GET_MASTER_LC_DATA'
        EXPORTING
              ZFREQNO           =       W_ZFREQNO
        IMPORTING
              W_ZTMLCHD         =       ZTMLCHD
              W_ZTMLCSG2        =       ZTMLCSG2
              W_ZTMLCSG910      =       ZTMLCSG910
        TABLES
              IT_ZSMLCSG7G      =       IT_ZSMLCSG7G
              IT_ZSMLCSG7O      =       IT_ZSMLCSG7O
              IT_ZSMLCSG8E      =       IT_ZSMLCSG8E
              IT_ZSMLCSG9O      =       IT_ZSMLCSG9O
              IT_ZSMLCSG7G_ORG  =       IT_ZSMLCSG7G_ORG
              IT_ZSMLCSG7O_ORG  =       IT_ZSMLCSG7O_ORG
              IT_ZSMLCSG8E_ORG  =       IT_ZSMLCSG8E_ORG
              IT_ZSMLCSG9O_ORG  =       IT_ZSMLCSG9O_ORG
        EXCEPTIONS
              NOT_FOUND     =       4
              NOT_INPUT     =       8.

   CASE SY-SUBRC.
      WHEN 4.
         MESSAGE E018 WITH W_ZFREQNO.
      WHEN 8.
         MESSAGE E019.
   ENDCASE.

   CALL FUNCTION 'ZIM_GET_MASTER_LC_AMEND_DATA'
        EXPORTING
              ZFREQNO           =       W_ZFREQNO
              ZFAMDNO           =       W_ZFAMDNO
        IMPORTING
              W_ZTMLCAMHD       =       ZTMLCAMHD
        TABLES
              IT_ZSMLCAMNARR     =      IT_ZSMLCAMNARR
              IT_ZSMLCAMNARR_ORG =      IT_ZSMLCAMNARR_ORG
        EXCEPTIONS
              NOT_FOUND     =       4
              NOT_INPUT     =       8.

   CASE SY-SUBRC.
      WHEN 4.
         MESSAGE E194 WITH W_ZFREQNO W_ZFAMDNO.
      WHEN 8.
         MESSAGE E195.
   ENDCASE.

*-----------------------------------------------------------------------
* internal Table Append
*-----------------------------------------------------------------------
   REFRESH : IT_ZTDDF1.
   CLEAR : IT_ZTDDF1.
   IT_ZTDDF1-ZFDDENO = W_ZFDHENO.
*>>> 전자문서 시작
   IT_ZTDDF1-ZFDDFDA = '{10'.            APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '469'.            APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = W_ZFDHENO.        APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFEDFN. APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = 'AB'.             APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '}10'.            APPEND IT_ZTDDF1.
*>>> 개설방법
   IT_ZTDDF1-ZFDDFDA = '{11'.            APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '1'..             APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '5'.              APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFOPME. APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '}11'.            APPEND IT_ZTDDF1.
*>>> 참조번호
   IT_ZTDDF1-ZFDDFDA = '{12'.            APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '2AD'.            APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTREQST-ZFOPNNO.  APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '}12'.            APPEND IT_ZTDDF1.
*>>> 변경횟수
   IT_ZTDDF1-ZFDDFDA = '{12'.            APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '2AB'.            APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTREQST-ZFAMDNO.  APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '}12'.            APPEND IT_ZTDDF1.
*>>> 조건변경신청일자
   IT_ZTDDF1-ZFDDFDA = '{13'.                APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '2AA'.                APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTREQST-ZFAPPDT+2(6). APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '101'.                APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '}13'.                APPEND IT_ZTDDF1.
*>>> 개설일자
   W_AMDNO = W_ZFAMDNO - 1.
   SELECT SINGLE ZFOPNDT INTO W_ZFOPNDT FROM ZTREQST
                         WHERE ZFREQNO   EQ  W_ZFREQNO
                         AND   ZFAMDNO   EQ  W_AMDNO.
   IT_ZTDDF1-ZFDDFDA = '{13'.                 APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '182'.                 APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = W_ZFOPNDT+2(6).        APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '101'.                 APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '}13'.                 APPEND IT_ZTDDF1.
*>>> 변경유효기일
   IF NOT ZTMLCAMHD-ZFNEXDT IS INITIAL.
      IT_ZTDDF1-ZFDDFDA = '{13'.                  APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '123'.                  APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFNEXDT+2(6). APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '101'.                  APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '}13'.                  APPEND IT_ZTDDF1.
   ENDIF.
*>>> 변경최종선적기일
   IF NOT ZTMLCAMHD-ZFNLTSD IS INITIAL.
      IT_ZTDDF1-ZFDDFDA = '{13'.                  APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '38'.                   APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFNLTSD+2(6). APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '101'.                  APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '}13'.                  APPEND IT_ZTDDF1.
   ENDIF.
*>>> 선적항 변경
   IF NOT ZTMLCAMHD-ZFNSPRT IS INITIAL.
      IT_ZTDDF1-ZFDDFDA = '{14'.                APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '149'.                APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFNSPRT.    APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '}14'.                APPEND IT_ZTDDF1.
   ENDIF.
*>>> 도착항 변경
   IF NOT ZTMLCAMHD-ZFNAPRT IS INITIAL.
      IT_ZTDDF1-ZFDDFDA = '{14'.                APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '149'.                APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFNAPRT.    APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '}14'.                APPEND IT_ZTDDF1.
   ENDIF.
*>>> 기타정보
   IF NOT ZTMLCAMHD-ZFETC1 IS INITIAL OR NOT ZTMLCAMHD-ZFETC2 IS INITIAL
   OR NOT ZTMLCAMHD-ZFETC3 IS INITIAL OR NOT ZTMLCAMHD-ZFETC4 IS INITIAL
   OR NOT ZTMLCAMHD-ZFETC5 IS INITIAL.
      IT_ZTDDF1-ZFDDFDA = '{15'.             APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = 'ACB'.             APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFETC1.  APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFETC2.  APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFETC3.  APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFETC4.  APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFETC5.  APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '}15'.             APPEND IT_ZTDDF1.
   ENDIF.
*>>> 부가금액부담 변경
   IF NOT ZTMLCAMHD-ZFNAMT1 IS INITIAL OR
      NOT ZTMLCAMHD-ZFNAMT2 IS INITIAL OR
      NOT ZTMLCAMHD-ZFNAMT3 IS INITIAL OR
      NOT ZTMLCAMHD-ZFNAMT4 IS INITIAL.
      IT_ZTDDF1-ZFDDFDA = '{15'.             APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = 'ABT'.             APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFNAMT1. APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFNAMT2. APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFNAMT3. APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFNAMT4. APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ''.                APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '}15'.             APPEND IT_ZTDDF1.
   ENDIF.
*>>> 선적기간 변경
   IF ( NOT ZTMLCAMHD-ZFNSHPR1 IS INITIAL OR
        NOT ZTMLCAMHD-ZFNSHPR2 IS INITIAL OR
        NOT ZTMLCAMHD-ZFNSHPR3 IS INITIAL ) AND
        ZTMLCAMHD-ZFNLTSD IS INITIAL.
      IT_ZTDDF1-ZFDDFDA = '{15'.              APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '2AF'.              APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFNSHPR1. APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFNSHPR2. APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFNSHPR3. APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ''.                APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ''.                APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '}15'.              APPEND IT_ZTDDF1.
   ENDIF.
* 기타조건변경 사항
   LOOP AT IT_ZSMLCAMNARR.
      W_MOD = SY-TABIX MOD 5.
      CASE W_MOD.
         WHEN 1.
           IT_ZTDDF1-ZFDDFDA = '{15'.                 APPEND IT_ZTDDF1.
           IT_ZTDDF1-ZFDDFDA = '2AD'.                 APPEND IT_ZTDDF1.
           IT_ZTDDF1-ZFDDFDA = IT_ZSMLCAMNARR-ZFNARR. APPEND IT_ZTDDF1.
         WHEN 0.
           IT_ZTDDF1-ZFDDFDA = IT_ZSMLCAMNARR-ZFNARR. APPEND IT_ZTDDF1.
           IT_ZTDDF1-ZFDDFDA = '}15'.                 APPEND IT_ZTDDF1.
         WHEN OTHERS.
           IT_ZTDDF1-ZFDDFDA = IT_ZSMLCAMNARR-ZFNARR. APPEND IT_ZTDDF1.
      ENDCASE.
   ENDLOOP.
   IF W_MOD NE 0.
      W_MOD = 5 - W_MOD.
      DO W_MOD TIMES.
           IT_ZTDDF1-ZFDDFDA = ''.        APPEND IT_ZTDDF1.
      ENDDO.
      IT_ZTDDF1-ZFDDFDA = '}15'.          APPEND IT_ZTDDF1.
   ENDIF.
* 개설(의뢰)은행
   IT_ZTDDF1-ZFDDFDA = '{16'.            APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = 'AW'.             APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCHD-ZFOPBNCD. APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCHD-ZFOBNM.   APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCHD-ZFOBBR.   APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '}16'.            APPEND IT_ZTDDF1.
* 개설(의뢰)은행
   IT_ZTDDF1-ZFDDFDA = '{16'.            APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = 'AW'.             APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCHD-ZFOPBNCD. APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCHD-ZFOBNM.   APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCHD-ZFOBBR.   APPEND IT_ZTDDF1.
* 개설(의뢰)은행 전화번호
   IF NOT ZTMLCHD-ZFOBPH IS INITIAL.
      IT_ZTDDF1-ZFDDFDA = '{20'.            APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCHD-ZFOBPH.   APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = 'TE'.             APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '}20'.            APPEND IT_ZTDDF1.
   ENDIF.
   IT_ZTDDF1-ZFDDFDA = '}16'.            APPEND IT_ZTDDF1.
* 희망통지은행
   IF NOT ZTMLCHD-ZFABNM IS INITIAL OR NOT ZTMLCHD-ZFABBR IS INITIAL.
      IT_ZTDDF1-ZFDDFDA = '{16'.            APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '2AA'.            APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCHD-ZFABNM.   APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCHD-ZFABBR.   APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ''.               APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '}16'.            APPEND IT_ZTDDF1.
   ENDIF.
* 개설의뢰인
   IT_ZTDDF1-ZFDDFDA = '{17'.             APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = 'DF'.              APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCSG2-ZFAPPNM.  APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCSG2-ZFAPPAD1. APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCSG2-ZFAPPAD2. APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCSG2-ZFAPPAD3. APPEND IT_ZTDDF1.
   DO 6 TIMES.
      IT_ZTDDF1-ZFDDFDA = ''.                APPEND IT_ZTDDF1.
   ENDDO.
*-----> 개설인 전화번호
   IF NOT ZTMLCSG2-ZFTELNO IS INITIAL.
      IT_ZTDDF1-ZFDDFDA = '{21'.            APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCSG2-ZFTELNO. APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = 'TE'.             APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '}21'.            APPEND IT_ZTDDF1.
   ENDIF.
   IT_ZTDDF1-ZFDDFDA = '}17'.             APPEND IT_ZTDDF1.
* 원수익자
   IT_ZTDDF1-ZFDDFDA = '{17'.             APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = 'DG'.              APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFBENI1. APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFBENI2. APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFBENI3. APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFBENI4. APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFBENIA. APPEND IT_ZTDDF1.
   DO 5 TIMES.
      IT_ZTDDF1-ZFDDFDA = ''.                APPEND IT_ZTDDF1.
   ENDDO.
   IT_ZTDDF1-ZFDDFDA = '}17'.             APPEND IT_ZTDDF1.
* 개설의뢰인 전자서명
   IT_ZTDDF1-ZFDDFDA = '{17'.             APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '2AE'.             APPEND IT_ZTDDF1.
   DO 5 TIMES.
      IT_ZTDDF1-ZFDDFDA = ''.                APPEND IT_ZTDDF1.
   ENDDO.
   IT_ZTDDF1-ZFDDFDA = ZTMLCSG2-ZFELENM.  APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCSG2-ZFREPRE.  APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCSG2-ZFELEID.  APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCSG2-ZFELEAD1. APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = ZTMLCSG2-ZFELEAD2. APPEND IT_ZTDDF1.
   IT_ZTDDF1-ZFDDFDA = '}17'.             APPEND IT_ZTDDF1.
* 금액 변동분
   IF NOT ZTMLCAMHD-ZFIDAM IS INITIAL.
      IT_ZTDDF1-ZFDDFDA = '{18'.            APPEND IT_ZTDDF1.
      CASE ZTMLCAMHD-ZFIDCD.
         WHEN '+'.
            IT_ZTDDF1-ZFDDFDA = '2AA'. APPEND IT_ZTDDF1.
         WHEN '-'.
            IT_ZTDDF1-ZFDDFDA = '2AB'. APPEND IT_ZTDDF1.
      ENDCASE.
      WRITE   ZTMLCAMHD-ZFIDAM   TO      W_TEXT_AMOUNT
                            CURRENCY     ZTMLCAMHD-WAERS.
      PERFORM    P2000_WRITE_NO_MASK     CHANGING  W_TEXT_AMOUNT.
      IT_ZTDDF1-ZFDDFDA = W_TEXT_AMOUNT.    APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-WAERS.  APPEND IT_ZTDDF1.
* -----> 과부족 허용율
      IF NOT ZTMLCAMHD-ZFALCQ IS INITIAL.
         IT_ZTDDF1-ZFDDFDA = '{22'.             APPEND IT_ZTDDF1.
         IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFALCQ.  APPEND IT_ZTDDF1.
         IF NOT ZTMLCAMHD-ZFALCP IS INITIAL.
            IT_ZTDDF1-ZFDDFDA = '{30'.             APPEND IT_ZTDDF1.
            IT_ZTDDF1-ZFDDFDA = '13'.              APPEND IT_ZTDDF1.
            IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFALCP.  APPEND IT_ZTDDF1.
            IT_ZTDDF1-ZFDDFDA = '}30'.             APPEND IT_ZTDDF1.
         ENDIF.
         IT_ZTDDF1-ZFDDFDA = '}22'.             APPEND IT_ZTDDF1.
      ENDIF.
      IT_ZTDDF1-ZFDDFDA = '}18'.            APPEND IT_ZTDDF1.
   ENDIF.
* 변경후 최종금액
   IF NOT ZTMLCAMHD-ZFNDAMT IS INITIAL.
      IT_ZTDDF1-ZFDDFDA = '{18'.            APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = '212'.            APPEND IT_ZTDDF1.
      WRITE   ZTMLCAMHD-ZFNDAMT  TO      W_TEXT_AMOUNT
                            CURRENCY     ZTMLCAMHD-WAERS.
      PERFORM    P2000_WRITE_NO_MASK     CHANGING  W_TEXT_AMOUNT.
      IT_ZTDDF1-ZFDDFDA = W_TEXT_AMOUNT.    APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-WAERS.  APPEND IT_ZTDDF1.
* -----> 과부족 허용율
      IF NOT ZTMLCAMHD-ZFALCQ IS INITIAL.
         IT_ZTDDF1-ZFDDFDA = '{22'.             APPEND IT_ZTDDF1.
         IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFALCQ.  APPEND IT_ZTDDF1.
         IF NOT ZTMLCAMHD-ZFALCP IS INITIAL.
            IT_ZTDDF1-ZFDDFDA = '{30'.             APPEND IT_ZTDDF1.
            IT_ZTDDF1-ZFDDFDA = '13'.              APPEND IT_ZTDDF1.
            IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFALCP.  APPEND IT_ZTDDF1.
            IT_ZTDDF1-ZFDDFDA = '}30'.             APPEND IT_ZTDDF1.
         ENDIF.
         IT_ZTDDF1-ZFDDFDA = '}22'.             APPEND IT_ZTDDF1.
      ENDIF.
      IT_ZTDDF1-ZFDDFDA = '}18'.            APPEND IT_ZTDDF1.
   ENDIF.
* 수입승인번호
   IF NOT ZTMLCAMHD-ZFILNO IS INITIAL.
      IT_ZTDDF1-ZFDDFDA = '{19'.            APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = 'IP'.             APPEND IT_ZTDDF1.
      IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFILNO. APPEND IT_ZTDDF1.
      IF NOT ZTMLCAMHD-ZFILAMT IS INITIAL.
         IT_ZTDDF1-ZFDDFDA = '{23'.              APPEND IT_ZTDDF1.
         WRITE   ZTMLCAMHD-ZFILAMT  TO      W_TEXT_AMOUNT
                               CURRENCY     ZTMLCAMHD-ZFILCUR.
         PERFORM    P2000_WRITE_NO_MASK     CHANGING  W_TEXT_AMOUNT.
         IT_ZTDDF1-ZFDDFDA = W_TEXT_AMOUNT.      APPEND IT_ZTDDF1.
         IT_ZTDDF1-ZFDDFDA = ZTMLCAMHD-ZFILCUR.  APPEND IT_ZTDDF1.
         IT_ZTDDF1-ZFDDFDA = '}23'.              APPEND IT_ZTDDF1.
      ENDIF.
      IT_ZTDDF1-ZFDDFDA = '}19'.            APPEND IT_ZTDDF1.
   ENDIF.

*-----------------------------------------------------------------------
* ITEM INSERT
*-----------------------------------------------------------------------
   CALL FUNCTION 'ZIM_EDI_FLAT_ITEM_INSERT'
        EXPORTING
              W_ZFDHENO         =        W_ZFDHENO
        TABLES
              IT_ZTDDF1         =        IT_ZTDDF1
        EXCEPTIONS
              DB_ERROR         =         4.

   IF SY-SUBRC NE 0.
      MESSAGE E118 WITH W_ZFDHENO.
   ENDIF.

ENDFUNCTION.

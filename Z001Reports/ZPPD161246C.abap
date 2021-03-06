* (c) Copyright 1999 SAP America, Inc.
* Accelerated HR PD Individual Infotype Load
* Version 1.0  - August 2000

* PD/Org Infotype 1612
* Authors : Mrudula - Annance Consulting
*---------------------------------------------------------------------*
REPORT ZPPD161246C MESSAGE-ID ZP.
TABLES : t5u26.

* SELECTION SCREEN
** PARAMETER

PARAMETER : FILE1612  LIKE  RLGRAP-FILENAME DEFAULT
          'C:\WINDOWS\SAP\1612.txt'.

* data decleration
** Tables
** internal tables

DATA : BEGIN OF _P1612 OCCURS 10.
        INCLUDE STRUCTURE P1612.
DATA : BEGDA1(10),ENDDA1(10),DPATT(40),
       ORGEH1(8),WCSTATE1(3),WCCODE1(4),BEGIN1(10),END1(10).
DATA : END OF _P1612.
DATA : TCNT TYPE I VALUE 0.


 DATA: BEGIN OF BDC_DATA OCCURS 100.
         INCLUDE STRUCTURE BDCDATA.
 DATA: END OF BDC_DATA.

** Data
DATA : TRCODE LIKE TSTC-TCODE.
DATA  DELIMITER TYPE X VALUE '09' .
DATA  CNT TYPE I VALUE 0.

* Source Code

PERFORM READ_DATA.
PERFORM INIT_BDC USING 'HRPD1612' SY-UNAME.
SORT _P1612 BY OTYPE OBJID ORGEH1 WCSTATE1.
DATA : TOBJID LIKE P1612-OBJID VALUE '00000000'.
LOOP AT _P1612.
  PERFORM POPULATE_BDC.
  TRCODE = 'PP02' .
  PERFORM INSERT_BDC TABLES BDC_DATA USING TRCODE.
  CNT = CNT + 1.
ENDLOOP.
PERFORM CLOSE_PROGRAM.
*WRITE:/ 'TOTAL RECORD LOADED =', CNT.


** FORMS

*&---------------------------------------------------------------------*
*&      Form  POPULATE_BDC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM POPULATE_BDC.
IF TOBJID <> _P1612-OBJID.

SELECT COUNT( * ) FROM T5U26 INTO TCNT WHERE ORGEH = _P1612-OBJID.
 IF TCNT = 0.
   PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPMH5A0' '1000' ' ',
            ' ' 'PPHDR-PLVAR' '01' ' ', "PLAN VERSN
            ' ' 'PPHDR-OTYPE' _P1612-OTYPE ' ', "OBJ TYPE
            ' ' 'PM0D1-SEARK' _P1612-OBJID ' ', "OBJ ID
            ' ' 'PPHDR-INFTY' '1612' ' ',       "INFOTYPE
            ' ' 'PPHDR-SUBTY' _P1612-SUBTY ' ', "SUBTYPE
            ' ' 'PPHDR-ISTAT' '1' ' ',          "PLANNING STATUS
            ' ' 'PPHDR-BEGDA' _P1612-BEGDA1 ' ', "BEGIN DT
            ' ' 'PPHDR-ENDDA' _P1612-ENDDA1 ' ', "END DT
            ' ' 'PM0D1-DPATT' _P1612-DPATT ' ' , "DATA SAMPLE
            ' ' 'BDC_OKCODE' '/05' ' '.          "CREATE-F5
   PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1011' ' ',
            ' ' 'BDC_OKCODE' 'NEWL' ' '.          "NEW ENTRY
   PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1012' ' ',
            ' ' 'V_T5U26-ORGEH' _P1612-ORGEH1 ' ', "ORG UNIT,
            ' ' 'V_T5U26-WCSTATE' _P1612-WCSTATE1 ' ', "WC STATE
            ' ' 'V_T5U26-WCCODE' _P1612-WCCODE1 ' ', "WC CODE
            ' ' 'D0001_BEGIN(01)' _P1612-BEGIN1 ' ', "FROM DATE
            ' ' 'D0001_END(01)' _P1612-END1 ' ', "END DATE
            ' ' 'BDC_OKCODE' '/11' ' '.   "SAVE
* BEGIN PERFORM STATEMENT FOR 'CTS' REQUEST SCREEN WHICH SHOULD BE
* REMOVED WHEN LOADING THIS PROGRAM TO QAS OR PRD.
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPLSTRD' '0300' ' ',
            ' ' 'BDC_OKCODE' '/00' ' '.
* END OF 'CTS' REQUEST SCREEN.
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1012' ' ',
            ' ' 'BDC_OKCODE' 'UEBE' ' '.           "BACK
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1012' ' ',
            ' ' 'BDC_OKCODE' 'UEBE' ' '.           "BACK
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1011' ' ',
            ' ' 'BDC_OKCODE' 'BACK' ' '.           "BACK
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPMH5A0' '1000' ' ',
            ' ' 'BDC_OKCODE' 'BACK' ' '       . "BACK
 ELSEIF TCNT = 1.
   PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPMH5A0' '1000' ' ',
            ' ' 'PPHDR-PLVAR' '01' ' ', "PLAN VERSN
            ' ' 'PPHDR-OTYPE' _P1612-OTYPE ' ', "OBJ TYPE
            ' ' 'PM0D1-SEARK' _P1612-OBJID ' ', "OBJ ID
            ' ' 'PPHDR-INFTY' '1612' ' ',       "INFOTYPE
            ' ' 'PPHDR-SUBTY' _P1612-SUBTY ' ', "SUBTYPE
            ' ' 'PPHDR-ISTAT' '1' ' ',          "PLANNING STATUS
            ' ' 'PPHDR-BEGDA' _P1612-BEGDA1 ' ', "BEGIN DT
            ' ' 'PPHDR-ENDDA' _P1612-ENDDA1 ' ', "END DT
            ' ' 'PM0D1-DPATT' _P1612-DPATT ' ' , "DATA SAMPLE
            ' ' 'BDC_OKCODE' '/05' ' '.          "CREATE-F5
   PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1012' ' ',
            ' ' 'BDC_OKCODE' '=NEWL' ' '.          "CREATE-F5
   PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1012' ' ',
            ' ' 'V_T5U26-ORGEH' _P1612-ORGEH1 ' ', "ORG UNIT,
            ' ' 'V_T5U26-WCSTATE' _P1612-WCSTATE1 ' ', "WC STATE
            ' ' 'V_T5U26-WCCODE' _P1612-WCCODE1 ' ', "WC CODE
            ' ' 'D0001_BEGIN(01)' _P1612-BEGIN1 ' ', "FROM DATE
            ' ' 'D0001_END(01)' _P1612-END1 ' ', "END DATE
            ' ' 'BDC_OKCODE' '/11' ' '.   "SAVE
* BEGIN PERFORM STATEMENT FOR 'CTS' REQUEST SCREEN WHICH SHOULD BE
* REMOVED WHEN LOADING THIS PROGRAM TO QAS OR PRD.
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPLSTRD' '0300' ' ',
            ' ' 'BDC_OKCODE' '/00' ' '.
* END OF 'CTS' REQUEST SCREEN.
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1012' ' ',
            ' ' 'BDC_OKCODE' 'UEBE' ' '.           "BACK
*         PERFORM DYNPRO TABLES BDC_DATA USING:
*            'X' 'SAPL0PUN' '1012' ' ',
*            ' ' 'BDC_OKCODE' 'UEBE' ' '.           "BACK
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1011' ' ',
            ' ' 'BDC_OKCODE' 'BACK' ' '.           "BACK
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPMH5A0' '1000' ' ',
            ' ' 'BDC_OKCODE' 'BACK' ' '. "BACK

 ELSE.
   PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPMH5A0' '1000' ' ',
            ' ' 'PPHDR-PLVAR' '01' ' ', "PLAN VERSN
            ' ' 'PPHDR-OTYPE' _P1612-OTYPE ' ', "OBJ TYPE
            ' ' 'PM0D1-SEARK' _P1612-OBJID ' ', "OBJ ID
            ' ' 'PPHDR-INFTY' '1612' ' ',       "INFOTYPE
            ' ' 'PPHDR-SUBTY' _P1612-SUBTY ' ', "SUBTYPE
            ' ' 'PPHDR-ISTAT' '1' ' ',          "PLANNING STATUS
            ' ' 'PPHDR-BEGDA' _P1612-BEGDA1 ' ', "BEGIN DT
            ' ' 'PPHDR-ENDDA' _P1612-ENDDA1 ' ', "END DT
            ' ' 'PM0D1-DPATT' _P1612-DPATT ' ' , "DATA SAMPLE
            ' ' 'BDC_OKCODE' '/05' ' '.          "CREATE-F5
   PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1011' ' ',
            ' ' 'BDC_OKCODE' '=NEWL' ' '.          "CREATE-F5
   PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1012' ' ',
            ' ' 'V_T5U26-ORGEH' _P1612-ORGEH1 ' ', "ORG UNIT,
            ' ' 'V_T5U26-WCSTATE' _P1612-WCSTATE1 ' ', "WC STATE
            ' ' 'V_T5U26-WCCODE' _P1612-WCCODE1 ' ', "WC CODE
            ' ' 'D0001_BEGIN(01)' _P1612-BEGIN1 ' ', "FROM DATE
            ' ' 'D0001_END(01)' _P1612-END1 ' ', "END DATE
            ' ' 'BDC_OKCODE' '/11' ' '.   "SAVE
* BEGIN PERFORM STATEMENT FOR 'CTS' REQUEST SCREEN WHICH SHOULD BE
* REMOVED WHEN LOADING THIS PROGRAM TO QAS OR PRD.
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPLSTRD' '0300' ' ',
            ' ' 'BDC_OKCODE' '/00' ' '.
* END OF 'CTS' REQUEST SCREEN.
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1012' ' ',
            ' ' 'BDC_OKCODE' 'UEBE' ' '.           "BACK
*         PERFORM DYNPRO TABLES BDC_DATA USING:
*            'X' 'SAPL0PUN' '1012' ' ',
*            ' ' 'BDC_OKCODE' 'UEBE' ' '.           "BACK
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1011' ' ',
            ' ' 'BDC_OKCODE' 'BACK' ' '.           "BACK
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPMH5A0' '1000' ' ',
            ' ' 'BDC_OKCODE' 'BACK' ' '       . "BACK
 ENDIF.
ELSE.
TCNT = TCNT + 1.
  IF TCNT = 1.
    PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPMH5A0' '1000' ' ',
            ' ' 'PPHDR-PLVAR' '01' ' ', "PLAN VERSN
            ' ' 'PPHDR-OTYPE' _P1612-OTYPE ' ', "OBJ TYPE
            ' ' 'PM0D1-SEARK' _P1612-OBJID ' ', "OBJ ID
            ' ' 'PPHDR-INFTY' '1612' ' ',       "INFOTYPE
            ' ' 'PPHDR-SUBTY' _P1612-SUBTY ' ', "SUBTYPE
            ' ' 'PPHDR-ISTAT' '1' ' ',          "PLANNING STATUS
            ' ' 'PPHDR-BEGDA' _P1612-BEGDA1 ' ', "BEGIN DT
            ' ' 'PPHDR-ENDDA' _P1612-ENDDA1 ' ', "END DT
            ' ' 'PM0D1-DPATT' _P1612-DPATT ' ' , "DATA SAMPLE
            ' ' 'BDC_OKCODE' '/05' ' '.          "CREATE-F5
   PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1012' ' ',
            ' ' 'BDC_OKCODE' '=NEWL' ' '.          "CREATE-F5
   PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1012' ' ',
            ' ' 'V_T5U26-ORGEH' _P1612-ORGEH1 ' ', "ORG UNIT,
            ' ' 'V_T5U26-WCSTATE' _P1612-WCSTATE1 ' ', "WC STATE
            ' ' 'V_T5U26-WCCODE' _P1612-WCCODE1 ' ', "WC CODE
            ' ' 'D0001_BEGIN(01)' _P1612-BEGIN1 ' ', "FROM DATE
            ' ' 'D0001_END(01)' _P1612-END1 ' ', "END DATE
            ' ' 'BDC_OKCODE' '/11' ' '.   "SAVE
* BEGIN PERFORM STATEMENT FOR 'CTS' REQUEST SCREEN WHICH SHOULD BE
* REMOVED WHEN LOADING THIS PROGRAM TO QAS OR PRD.
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPLSTRD' '0300' ' ',
            ' ' 'BDC_OKCODE' '/00' ' '.
* END OF 'CTS' REQUEST SCREEN.
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1012' ' ',
            ' ' 'BDC_OKCODE' 'UEBE' ' '.           "BACK
*         PERFORM DYNPRO TABLES BDC_DATA USING:
*            'X' 'SAPL0PUN' '1012' ' ',
*            ' ' 'BDC_OKCODE' 'UEBE' ' '.           "BACK
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1011' ' ',
            ' ' 'BDC_OKCODE' 'BACK' ' '.           "BACK
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPMH5A0' '1000' ' ',
            ' ' 'BDC_OKCODE' 'BACK' ' '.
  ELSE.
   PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPMH5A0' '1000' ' ',
            ' ' 'PPHDR-PLVAR' '01' ' ', "PLAN VERSN
            ' ' 'PPHDR-OTYPE' _P1612-OTYPE ' ', "OBJ TYPE
            ' ' 'PM0D1-SEARK' _P1612-OBJID ' ', "OBJ ID
            ' ' 'PPHDR-INFTY' '1612' ' ',       "INFOTYPE
            ' ' 'PPHDR-SUBTY' _P1612-SUBTY ' ', "SUBTYPE
            ' ' 'PPHDR-ISTAT' '1' ' ',          "PLANNING STATUS
            ' ' 'PPHDR-BEGDA' _P1612-BEGDA1 ' ', "BEGIN DT
            ' ' 'PPHDR-ENDDA' _P1612-ENDDA1 ' ', "END DT
            ' ' 'PM0D1-DPATT' _P1612-DPATT ' ' , "DATA SAMPLE
            ' ' 'BDC_OKCODE' '/05' ' '.          "CREATE-F5
   PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1011' ' ',
            ' ' 'BDC_OKCODE' '=NEWL' ' '.          "CREATE-F5
   PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1012' ' ',
            ' ' 'V_T5U26-ORGEH' _P1612-ORGEH1 ' ', "ORG UNIT,
            ' ' 'V_T5U26-WCSTATE' _P1612-WCSTATE1 ' ', "WC STATE
            ' ' 'V_T5U26-WCCODE' _P1612-WCCODE1 ' ', "WC CODE
            ' ' 'D0001_BEGIN(01)' _P1612-BEGIN1 ' ', "FROM DATE
            ' ' 'D0001_END(01)' _P1612-END1 ' ', "END DATE
            ' ' 'BDC_OKCODE' '/11' ' '.   "SAVE
* BEGIN PERFORM STATEMENT FOR 'CTS' REQUEST SCREEN WHICH SHOULD BE
* REMOVED WHEN LOADING THIS PROGRAM TO QAS OR PRD.
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPLSTRD' '0300' ' ',
            ' ' 'BDC_OKCODE' '/00' ' '.
* END OF 'CTS' REQUEST SCREEN.
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1012' ' ',
            ' ' 'BDC_OKCODE' 'UEBE' ' '.           "BACK
*         PERFORM DYNPRO TABLES BDC_DATA USING:
*            'X' 'SAPL0PUN' '1012' ' ',
*            ' ' 'BDC_OKCODE' 'UEBE' ' '.           "BACK
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPL0PUN' '1011' ' ',
            ' ' 'BDC_OKCODE' 'BACK' ' '.           "BACK
         PERFORM DYNPRO TABLES BDC_DATA USING:
            'X' 'SAPMH5A0' '1000' ' ',
            ' ' 'BDC_OKCODE' 'BACK' ' '       . "BACK
  ENDIF.

ENDIF.
TOBJID = _P1612-OBJID.
ENDFORM.                    " POPULATE_BDC

*&---------------------------------------------------------------------*
*&      Form  READ_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM READ_DATA.

DATA : BEGIN OF WA OCCURS 100,
       STR(1000),
       END OF WA.

CALL FUNCTION 'WS_UPLOAD'
    EXPORTING
*         CODEPAGE                = ' '
         FILENAME                = FILE1612
         FILETYPE                = 'ASC'
*         HEADLEN                 = ' '
*         LINE_EXIT               = ' '
*         TRUNCLEN                = ' '
*         USER_FORM               = ' '
*         USER_PROG               = ' '
*    IMPORTING
*         FILELENGTH              =
     TABLES
          DATA_TAB                = WA
     EXCEPTIONS
          CONVERSION_ERROR        = 1
          FILE_OPEN_ERROR         = 2
          FILE_READ_ERROR         = 3
          INVALID_TABLE_WIDTH     = 4
          INVALID_TYPE            = 5
          NO_BATCH                = 6
          UNKNOWN_ERROR           = 7
          GUI_REFUSE_FILETRANSFER = 8
          OTHERS                  = 9.


 LOOP AT WA.
   SPLIT WA-STR AT DELIMITER INTO
           _P1612-OTYPE
           _P1612-BEGDA1
           _P1612-ENDDA1
           _P1612-OBJID
           _P1612-SUBTY
           _P1612-DPATT
           _P1612-ORGEH1
           _P1612-WCSTATE1
           _P1612-WCCODE1
           _P1612-BEGIN1
           _P1612-END1.
IF   _P1612-OBJID NE SPACE.
   APPEND _P1612.
ENDIF.
 ENDLOOP.

ENDFORM.                    " READ_DATA

* include for commonly used forms
INCLUDE ZPPDUTIL.

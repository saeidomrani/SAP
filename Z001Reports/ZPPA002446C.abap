* (c) Copyright 1999 SAP America, Inc.
* Accelerated HR Individual Infotype Load
* Version 1.0  - December 1998

* PA Infotype 0024 - using PA30
* Authors : Hemang/Mrudula - Annance Consulting
*---------------------------------------------------------------------*
REPORT ZPPA002446C MESSAGE-ID ZP.

* Internal table declaration for reading the source data

DATA: BEGIN OF _P0024 OCCURS 0,
       PERID(13),
       PERNR LIKE P0024-PERNR,
       BEGDA1(10),
       ENDDA1(10),
       QUALI LIKE P0024-QUALI,
       AUSPR LIKE P0024-AUSPR.
DATA: END OF _P0024.

DATA: BEGIN OF BDC_DATA OCCURS 0.
        INCLUDE STRUCTURE BDCDATA.
DATA: END OF BDC_DATA.

DATA: DELIMITER TYPE X  VALUE '09'.
DATA  SSN(13).
DATA: CNT1 TYPE I.

PARAMETER : FILE0024 LIKE RLGRAP-FILENAME
                      DEFAULT 'C:\WINDOWS\SAP\0024.TXT' .

* Source Code

PERFORM INIT_BDC USING 'HRPA0024' SY-UNAME.
PERFORM UPLOAD_0024 USING FILE0024 'Error'.
PERFORM POPULATE_BDC.
PERFORM CLOSE_PROGRAM.

*&---------------------------------------------------------------------*
*&      Form  UPLOAD_0024
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPLOAD_0024 USING F ERR.

  DATA: BEGIN OF ITAB OCCURS 0,
*  file1(65535),
  FILE1(8192),
   END OF ITAB.



  CALL FUNCTION 'WS_UPLOAD'
      EXPORTING
*         CODEPAGE                = ' '
           FILENAME                = F
           FILETYPE                = 'ASC'
*         HEADLEN                 = ' '
*         LINE_EXIT               = ' '
*         TRUNCLEN                = ' '
*         USER_FORM               = ' '
*         USER_PROG               = ' '
*   importing
*         FILELENGTH              =
       TABLES
            DATA_TAB                = ITAB
       EXCEPTIONS
            UNKNOWN_ERROR = 7
          OTHERS        = 8.
PERFORM CHECK_ERROR USING SY-SUBRC ERR.

DATA : T .
LOOP AT ITAB.
  SPLIT ITAB-FILE1 AT DELIMITER INTO
       _P0024-PERID _P0024-BEGDA1 _P0024-ENDDA1 _P0024-QUALI
       _P0024-AUSPR T .
 MOVE  _P0024-PERID TO _P0024-PERNR.
IF _P0024-PERID NE SPACE.
    APPEND _P0024.
ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHECK_ERROR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_SY_SUBRC  text                                             *
*      -->P_ERR  text                                                  *
*----------------------------------------------------------------------*
FORM CHECK_ERROR USING ERR_CD STAGE.
  CASE ERR_CD.
    WHEN 0.
    WHEN OTHERS.
*      write:/ 'Error in the process ', stage, '. Error -', err_cd.
      STOP.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  POPULATE_BDC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM POPULATE_BDC.
LOOP AT _P0024.
  CLEAR SSN. CONCATENATE '=c..' _P0024-PERID INTO SSN.

 PERFORM DYNPRO TABLES BDC_DATA
                USING: 'X' 'SAPMP50A' '1000' ' ',
                       ' ' 'rp50g-pernr' SSN ' ',
                       ' ' 'RP50G-CHOIC' '0024' ' ',
                       ' ' 'BDC_OKCODE' '/05' ' '.

  PERFORM DYNPRO TABLES BDC_DATA USING: 'X' 'MP002400' '2000' ' ',
                        ' ' 'P0024-BEGDA' _P0024-BEGDA1 ' ',
                        ' ' 'P0024-ENDDA' _P0024-ENDDA1 ' ',
                        ' ' 'P0024-QUALI' _P0024-QUALI ' ',
                        ' ' 'P0024-AUSPR' _P0024-AUSPR ' ',
                        ' ' 'BDC_OKCODE' '/11' ' ' .

     PERFORM INSERT_BDC TABLES BDC_DATA USING 'PA30'.
ENDLOOP.

ENDFORM.                    " POPULATE_BDC

*&---------------------------------------------------------------------*
*&      Form  DYNPRO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_BDC_DATA  text                                             *
*      -->P_0153   text                                                *
*      -->P_0154   text                                                *
*      -->P_0155   text                                                *
*      -->P_0156   text                                                *
*----------------------------------------------------------------------*
FORM DYNPRO TABLES BDC_DATA STRUCTURE BDCDATA
           USING  DYNBEGIN NAME VALUE IDX.
 IF DYNBEGIN = 'X'.
   CLEAR   BDC_DATA.
   BDC_DATA-PROGRAM = NAME.
   BDC_DATA-DYNPRO = VALUE.
   BDC_DATA-DYNBEGIN = 'X'.
   APPEND BDC_DATA.
 ELSE.
   CLEAR   BDC_DATA.
   IF IDX = ' '.
     BDC_DATA-FNAM = NAME.
   ELSE.
     CONCATENATE NAME '(' IDX ')' INTO BDC_DATA-FNAM.
   ENDIF.
   BDC_DATA-FVAL = VALUE.
   APPEND BDC_DATA.
 ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  INSERT_BDC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_BDC_DATA  text                                             *
*      -->P_0297   text                                                *
*----------------------------------------------------------------------*
FORM INSERT_BDC TABLES BTAB USING TRCD.
  CALL FUNCTION 'BDC_INSERT'
       EXPORTING
            TCODE     = TRCD
       TABLES
            DYNPROTAB = BTAB.
  REFRESH BTAB.
  CLEAR BTAB.
  CNT1 = CNT1 + 1.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INIT_BDC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0044   text                                                *
*      -->P_SY_UNAME  text                                             *
*----------------------------------------------------------------------*
FORM INIT_BDC USING SES_NAME SAP_USER.

  CALL FUNCTION 'BDC_OPEN_GROUP'
       EXPORTING
            CLIENT = SY-MANDT
            GROUP  = SES_NAME
            USER   = SAP_USER.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  CLOSE_PROGRAM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

FORM CLOSE_PROGRAM.

  CALL FUNCTION 'BDC_CLOSE_GROUP'.
*  write:/ 'No. of Transaction : ',cnt1.
*  write:/ ' BDC session created ' . " , cnt2, 'documents.' .

ENDFORM.

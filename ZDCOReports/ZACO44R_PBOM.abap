************************************************************************
* Program Name      : ZACO44R_PBOM
* Author            : Hyung Jin Youn
* Creation Date     : 2004.02.02.
* Specifications By : Hae Sung Cho
* Pattern           : Report 1-1
* Development Request No : UD1K906784
* Addl Documentation:
* Description       : Report For plan BOM
*
* Modification Logs
* Date       Developer    RequestNo    Description
*
************************************************************************
* Comments : The naming convention can be different from Development
*            Standard guide in HMMA because this program was generated
*            by a SAP standard tool

REPORT ZACO44R_PBOM
   LINE-SIZE 253 NO STANDARD PAGE HEADING LINE-COUNT 000(001).

INCLUDE <SYMBOL>.
INCLUDE <ICON>.
SELECTION-SCREEN: BEGIN OF BLOCK PROG
                           WITH FRAME TITLE TEXT-F58.

* %FA00000 ZTCO_EBUSPLANBOM-CHK_EXIST
* %FA00001 ZTCO_EBUSPLANBOM-MATNR_CHG
* %FA00002 ZTCO_EBUSPLANBOM-MATNR_CHG2
TABLES ZTCO_EBUSPLANBOM.
DATA %COUNT-ZTCO_EBUSPLANBOM(4) TYPE X.
DATA %LINR-ZTCO_EBUSPLANBOM(2).

TABLES AQLDB.

INCLUDE RSAQEXCD.

DATA: BEGIN OF %ST_LISTE OCCURS 100,
          HEAD(1),
          TAB(3),
          LINE(6) TYPE N,
          CONT(1) TYPE N,
          FINT(1),
          FINV(1),
          FCOL(1) TYPE N,
          TEXT(0253),
      END OF %ST_LISTE.

DATA %DATA_SELECTED(1).
DATA %GLFRAME(1)  VALUE 'X' .
DATA %UFLAG(1).
DATA %USTFLAG(1).
DATA %GRST_TEXT(255).
DATA %GLLINE TYPE I.
DATA %TABIX LIKE SY-TABIX.
DATA %PRFLAG(1) TYPE X VALUE '02'.


DATA %PERC(4) TYPE P DECIMALS 3.
DATA %P100(4) TYPE P DECIMALS 3 VALUE '100.000'.
DATA %RANGCT TYPE I.
DATA %RANGCC(8).
SELECT-OPTIONS SP$00001 FOR ZTCO_EBUSPLANBOM-GJAHR MEMORY ID GJR.
SELECT-OPTIONS SP$00002 FOR ZTCO_EBUSPLANBOM-BOMTYPE.
SELECT-OPTIONS SP$00003 FOR ZTCO_EBUSPLANBOM-MATNR MEMORY ID MAT.
SELECT-OPTIONS SP$00004 FOR ZTCO_EBUSPLANBOM-WERKS MEMORY ID WRK.
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN: BEGIN OF BLOCK DIRECT
                  WITH FRAME TITLE TEXT-F59.
SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS:       %ALV RADIOBUTTON GROUP FUNC USER-COMMAND OUTBUT
                         DEFAULT 'X' .
SELECTION-SCREEN: COMMENT 4(26) TEXT-F72 FOR FIELD %ALV.
PARAMETERS:       %ALVL TYPE SLIS_VARI.
SELECTION-SCREEN: PUSHBUTTON 72(4) PB%EXCO USER-COMMAND EXPCOL.
SELECTION-SCREEN: END OF LINE.
SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS:       %NOFUNC RADIOBUTTON GROUP FUNC MODIF ID OLD.
SELECTION-SCREEN: COMMENT 4(26) TEXT-F66 FOR FIELD %NOFUNC
                                         MODIF ID OLD.
PARAMETERS:       %TVIEW RADIOBUTTON GROUP FUNC MODIF ID OLD.
SELECTION-SCREEN: COMMENT 34(26) TEXT-F68 FOR FIELD %TVIEW
                                          MODIF ID OLD,
                  END OF LINE.
SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS:       %GRAPH RADIOBUTTON GROUP FUNC MODIF ID OLD.
SELECTION-SCREEN: COMMENT 4(26) TEXT-F61 FOR FIELD %GRAPH
                                         MODIF ID OLD.
PARAMETERS:       %TEXT RADIOBUTTON GROUP FUNC MODIF ID OLD.
SELECTION-SCREEN: COMMENT 34(26) TEXT-F69 FOR FIELD %TEXT
                                          MODIF ID OLD,
                  END OF LINE.
SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS:       %ABC RADIOBUTTON GROUP FUNC MODIF ID OLD.
SELECTION-SCREEN: COMMENT 4(26) TEXT-F70 FOR FIELD %ABC
                                         MODIF ID OLD.
PARAMETERS:       %EXCEL RADIOBUTTON GROUP FUNC MODIF ID OLD.
SELECTION-SCREEN: COMMENT 34(26) TEXT-F60 FOR FIELD %EXCEL
                                         MODIF ID OLD,
                  END OF LINE.
SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS:       %EIS RADIOBUTTON GROUP FUNC MODIF ID OLD.
SELECTION-SCREEN: COMMENT 4(26) TEXT-F63 FOR FIELD %EIS
                                         MODIF ID OLD.
SELECTION-SCREEN: END OF LINE.
SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS:       %XINT RADIOBUTTON GROUP FUNC MODIF ID XIN.
SELECTION-SCREEN: COMMENT 4(26) TEXT-F73 FOR FIELD %XINT
                                         MODIF ID XIN.
PARAMETERS:       %XINTK(30) LOWER CASE MODIF ID XIN.
SELECTION-SCREEN: END OF LINE.
SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS:       %DOWN RADIOBUTTON GROUP FUNC MODIF ID OLD.
SELECTION-SCREEN: COMMENT 4(26) TEXT-F64 FOR FIELD %DOWN
                                         MODIF ID OLD.
PARAMETERS:       %PATH(132) LOWER CASE MODIF ID OLD.
SELECTION-SCREEN: END OF LINE.
SELECTION-SCREEN: BEGIN OF LINE.
PARAMETERS:       %SAVE RADIOBUTTON GROUP FUNC MODIF ID OLD.
SELECTION-SCREEN: COMMENT 4(26) TEXT-F62 FOR FIELD %SAVE
                                         MODIF ID OLD.
PARAMETERS:       %LISTID(40) LOWER CASE MODIF ID OLD.
SELECTION-SCREEN: END OF LINE.
SELECTION-SCREEN: END OF BLOCK DIRECT.
SELECTION-SCREEN: END OF BLOCK PROG.

DATA: BEGIN OF %G00 OCCURS 100,
            ZTCO_EBUSPLANBOM-GJAHR LIKE ZTCO_EBUSPLANBOM-GJAHR,
            ZTCO_EBUSPLANBOM-BOMTYPE LIKE ZTCO_EBUSPLANBOM-BOMTYPE,
            ZTCO_EBUSPLANBOM-MATNR LIKE ZTCO_EBUSPLANBOM-MATNR,
            ZTCO_EBUSPLANBOM-WERKS LIKE ZTCO_EBUSPLANBOM-WERKS,
            ZTCO_EBUSPLANBOM-DATUV LIKE ZTCO_EBUSPLANBOM-DATUV,
            %FA00001 LIKE ZTCO_EBUSPLANBOM-MATNR_CHG,
            %FA00002 LIKE ZTCO_EBUSPLANBOM-MATNR_CHG2,
            %FA00000 LIKE ZTCO_EBUSPLANBOM-CHK_EXIST,
            ZTCO_EBUSPLANBOM-ERDAT LIKE ZTCO_EBUSPLANBOM-ERDAT,
            ZTCO_EBUSPLANBOM-ERZET LIKE ZTCO_EBUSPLANBOM-ERZET,
            ZTCO_EBUSPLANBOM-ERNAM LIKE ZTCO_EBUSPLANBOM-ERNAM,
            ZTCO_EBUSPLANBOM-AEDAT LIKE ZTCO_EBUSPLANBOM-AEDAT,
            ZTCO_EBUSPLANBOM-AEZET LIKE ZTCO_EBUSPLANBOM-AEZET,
            ZTCO_EBUSPLANBOM-AENAM LIKE ZTCO_EBUSPLANBOM-AENAM,
      END OF %G00.
DATA: BEGIN OF %%G00,
            ZTCO_EBUSPLANBOM-GJAHR(005),
            ZTCO_EBUSPLANBOM-BOMTYPE(001),
            ZTCO_EBUSPLANBOM-MATNR(040),
            ZTCO_EBUSPLANBOM-WERKS(004),
            ZTCO_EBUSPLANBOM-DATUV(010),
            %FA00001(040),
            %FA00002(040),
            %FA00000(001),
            ZTCO_EBUSPLANBOM-ERDAT(010),
            ZTCO_EBUSPLANBOM-ERZET(008),
            ZTCO_EBUSPLANBOM-ERNAM(012),
            ZTCO_EBUSPLANBOM-AEDAT(010),
            ZTCO_EBUSPLANBOM-AEZET(008),
            ZTCO_EBUSPLANBOM-AENAM(012),
      END OF %%G00.
DATA %ZNR TYPE I.
DATA %LZNR TYPE I VALUE 99999.
FIELD-GROUPS HEADER.
DATA %GROUP01.
DATA %%ZTCO_EBUSPLANBOM-GJAHR LIKE ZTCO_EBUSPLANBOM-GJAHR.
DATA %%%ZTCO_EBUSPLANBOM-GJAHR(1).
DATA %GROUP0101.
DATA %GROUP02.
DATA %%ZTCO_EBUSPLANBOM-BOMTYPE LIKE ZTCO_EBUSPLANBOM-BOMTYPE.
DATA %%%ZTCO_EBUSPLANBOM-BOMTYPE(1).
DATA %GROUP0102.
DATA %GROUP03.
DATA %%ZTCO_EBUSPLANBOM-MATNR LIKE ZTCO_EBUSPLANBOM-MATNR.
DATA %%%ZTCO_EBUSPLANBOM-MATNR(1).
DATA %GROUP0103.
DATA %GROUP04.
DATA %%ZTCO_EBUSPLANBOM-WERKS LIKE ZTCO_EBUSPLANBOM-WERKS.
DATA %%%ZTCO_EBUSPLANBOM-WERKS(1).
DATA %GROUP0104.
FIELD-GROUPS %FG01.
DATA %ANY-01.

CONTROLS TVIEW100 TYPE TABLEVIEW USING SCREEN 100.

AT SELECTION-SCREEN .
PERFORM ALVL_CHECK(RSAQEXCE) USING %ALVL 'G00'.
PERFORM TESTMODE(RSAQEXCE).
PERFORM CHECK_EXPCOL(RSAQEXCE) USING %ALV.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR %ALVL .
PERFORM ALVL_VALUE_REQUEST(RSAQEXCE) USING %ALVL 'G00'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR %XINTK .
PERFORM XINT_VALUE_REQUEST(RSAQEXCE).

AT SELECTION-SCREEN OUTPUT .

PERFORM RINIT(RSAQBRST).
PERFORM SET_EXPCOL(RSAQEXCE) USING %ALV PB%EXCO.
PERFORM ALVL_SET_INVISIBLE(RSAQEXCE).
PERFORM SET_XINT_PARAMS(RSAQEXCE).

INITIALIZATION.
PERFORM INIT_XINT(RSAQEXCE).
PERFORM SET_WWW_FLAGS(RSAQEXCE).
PERFORM INIT_PRINT_PARAMS(RSAQEXCE).

START-OF-SELECTION.
INSERT ZTCO_EBUSPLANBOM-GJAHR INTO HEADER.
INSERT ZTCO_EBUSPLANBOM-BOMTYPE INTO HEADER.
INSERT ZTCO_EBUSPLANBOM-MATNR INTO HEADER.
INSERT ZTCO_EBUSPLANBOM-WERKS INTO HEADER.
INSERT %COUNT-ZTCO_EBUSPLANBOM INTO HEADER.
INSERT %LINR-ZTCO_EBUSPLANBOM INTO HEADER.
INSERT ZTCO_EBUSPLANBOM-DATUV INTO %FG01.
INSERT ZTCO_EBUSPLANBOM-MATNR_CHG INTO %FG01.
INSERT ZTCO_EBUSPLANBOM-MATNR_CHG2 INTO %FG01.
INSERT ZTCO_EBUSPLANBOM-CHK_EXIST INTO %FG01.
INSERT ZTCO_EBUSPLANBOM-ERDAT INTO %FG01.
INSERT ZTCO_EBUSPLANBOM-ERZET INTO %FG01.
INSERT ZTCO_EBUSPLANBOM-ERNAM INTO %FG01.
INSERT ZTCO_EBUSPLANBOM-AEDAT INTO %FG01.
INSERT ZTCO_EBUSPLANBOM-AEZET INTO %FG01.
INSERT ZTCO_EBUSPLANBOM-AENAM INTO %FG01.
PERFORM INIT_TEXTHANDLING(RSAQEXCE) USING 'CL_TEXT_IDENTIFIER' ' '
        'SYSTQV000000000000000010'.
* {* 2011/08/24 Paul Change Parameter.
*PERFORM AUTHORITY_BEGIN(RSAQEXCE).
*PERFORM AUTHORITY(RSAQEXCE) USING 'ZTCO_EBUSPLANBOM'.
*PERFORM AUTHORITY_END(RSAQEXCE).
PERFORM AUTHORITY_BEGIN(RSAQEXCE) USING 'CL_QUERY_TAB_ACCESS_AUTHORITY'.
PERFORM AUTHORITY(RSAQEXCE) USING 'ZTCO_EBUSPLANBOM'
                                  'CL_QUERY_TAB_ACCESS_AUTHORITY'.
PERFORM AUTHORITY_END(RSAQEXCE) USING 'CL_QUERY_TAB_ACCESS_AUTHORITY'.
PERFORM %COMP_LDESC.
SELECT AEDAT AENAM AEZET BOMTYPE CHK_EXIST DATUV ERDAT ERNAM ERZET
       GJAHR MATNR MATNR_CHG MATNR_CHG2 WERKS
       INTO CORRESPONDING FIELDS OF ZTCO_EBUSPLANBOM
       FROM ZTCO_EBUSPLANBOM
       WHERE BOMTYPE IN SP$00002
         AND GJAHR IN SP$00001
         AND MATNR IN SP$00003
         AND WERKS IN SP$00004.
  %DBACC = %DBACC - 1.
  IF %DBACC = 0.
    STOP.
  ENDIF.
  ADD 1 TO %COUNT-ZTCO_EBUSPLANBOM.
  %LINR-ZTCO_EBUSPLANBOM = '01'.
  EXTRACT %FG01.
ENDSELECT.

END-OF-SELECTION.
SORT AS TEXT BY
        ZTCO_EBUSPLANBOM-GJAHR
        ZTCO_EBUSPLANBOM-BOMTYPE
        ZTCO_EBUSPLANBOM-MATNR
        ZTCO_EBUSPLANBOM-WERKS
        %COUNT-ZTCO_EBUSPLANBOM
        %LINR-ZTCO_EBUSPLANBOM.
%DIACT = SPACE.
%BATCH = SY-BATCH.
IF %BATCH <> SPACE.
  IF %EIS <> SPACE.
    %DIACT = 'E'.
    IF %EISPROTOCOL = SPACE.
      NEW-PAGE PRINT ON DESTINATION 'NULL' NO DIALOG
               LINE-SIZE 0253 LINE-COUNT 0065.
    ELSE.
      NEW-PAGE PRINT ON NO DIALOG
               PARAMETERS %INIT_PRI_PARAMS.
    ENDIF.
  ENDIF.
  IF %ALV <> SPACE.
    %DIACT = 'V'.
    %ALV_LAYOUT = %ALVL.
    NEW-PAGE PRINT ON DESTINATION 'NULL' NO DIALOG
             LINE-SIZE 0253 LINE-COUNT 0065.
  ENDIF.
  IF %SAVE <> SPACE.
    %DIACT = 'S'.
    NEW-PAGE PRINT ON DESTINATION 'NULL' NO DIALOG
             LINE-SIZE 0253 LINE-COUNT 0065.
  ENDIF.
ELSEIF %CALLED_BY_WWW <> SPACE.
  %DIACT = SPACE.
ELSEIF %CALLED_BY_WWW_ALV <> SPACE.
  %DIACT = 'V'.
ELSE.
  PERFORM INIT_PRINT_PARAMS(RSAQEXCE).
  IF %SAVE  <> SPACE. %DIACT = 'S'. ENDIF.
  IF %XINT  <> SPACE. %DIACT = 'I'. ENDIF.
  IF %TVIEW <> SPACE. %DIACT = 'T'. ENDIF.
  IF %ALV   <> SPACE. %DIACT = 'V'. ENDIF.
  IF %DOWN  <> SPACE. %DIACT = 'D'. ENDIF.
  IF %EIS   <> SPACE. %DIACT = 'E'. ENDIF.
  IF %GRAPH <> SPACE. %DIACT = 'G'. ENDIF.
  IF %EXCEL <> SPACE. %DIACT = 'X'. ENDIF.
  IF %TEXT  <> SPACE. %DIACT = 'W'. ENDIF.
  IF %ABC   <> SPACE. %DIACT = 'A'. ENDIF.
  IF %DIACT <> SPACE AND %DIACT <> 'S' AND %DIACT <> 'W'.
    NEW-PAGE PRINT ON DESTINATION 'NULL' NO DIALOG
             LINE-SIZE 0253 LINE-COUNT 0065.
  ENDIF.
  %PATHNAME = %PATH.
  IF %DIACT = 'I'.
    %FUNCTIONKEY = %XINTK.
  ENDIF.
  IF %DIACT = 'V'.
    %ALV_LAYOUT = %ALVL.
  ENDIF.
ENDIF.
FREE MEMORY ID 'AQLISTDATA'.
IF %MEMMODE <> SPACE.
  IF %BATCH <> SPACE.
    NEW-PAGE PRINT ON DESTINATION 'NULL' NO DIALOG
             LINE-SIZE 0253 LINE-COUNT 0065.
  ENDIF.
  %DIACT = '1'.
ENDIF.
%TITEL = ' '.
IF SY-SUBTY O %PRFLAG AND %TITEL = SPACE.
  NEW-PAGE WITH-TITLE.
ENDIF.
%TVSIZE = 0200.
%PLINE = 1.
%PZGR  = 1.
%FIRST = 'X'.
PERFORM %OUTPUT.
%FIRST = SPACE.
IF %DIACT <> SPACE AND %DIACT <> 'S'.
  IF %BATCH = SPACE.
    NEW-PAGE PRINT OFF.
    IF NOT ( %DIACT = 'V' AND %UCOMM = 'PRIN' ).
      NEW-PAGE NO-HEADING NO-TITLE.
      WRITE SPACE.
    ENDIF.
  ENDIF.
ELSE.
  PERFORM PF-STATUS(RSAQEXCE) USING 'XXX   '.
ENDIF.
CLEAR: %TAB, %LINE, %CONT.
IF %DATA_SELECTED = SPACE.
  IF %DIACT = '1'.
    EXPORT EMPTY FROM %EMPTY TO MEMORY ID 'AQLISTDATA'.
    LEAVE.
  ELSE.
    IF %BATCH = SPACE AND
       %CALLED_BY_WWW = SPACE AND
       %CALLED_BY_WWW_ALV = SPACE.
      MESSAGE S260(AQ).
      LEAVE LIST-PROCESSING.
    ELSE.
      IF %CALLED_BY_WWW_ALV = SPACE.
        %DIACT = SPACE.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
IF %DIACT = 'S'.
  PERFORM %SAVE_LIST.
  LEAVE LIST-PROCESSING.
ENDIF.
IF %DIACT = 'V' AND %BATCH <> SPACE.
  NEW-PAGE PRINT OFF.
  PERFORM SET_PRINT_PARAMS(RSAQEXCE).
  PERFORM %DOWNLOAD USING 'ALV'.
  LEAVE.
ENDIF.
IF %DIACT = 'V' AND %CALLED_BY_WWW_ALV <> SPACE.
  PERFORM %DOWNLOAD USING 'ALV'.
  LEAVE.
ENDIF.
IF %DIACT = 'V' AND %UCOMM = 'PRIN'.
  NEW-PAGE PRINT OFF.
  PERFORM SET_PRINT_PARAMS(RSAQEXCE).
  PERFORM %DOWNLOAD USING 'ALV'.
  LEAVE LIST-PROCESSING.
ENDIF.
IF %DIACT = 'P' AND %BATCH <> SPACE.
  PERFORM %DOWNLOAD USING '+DAT'.
  LEAVE LIST-PROCESSING.
ENDIF.
IF %DIACT = 'E' AND %BATCH <> SPACE.
  PERFORM %DOWNLOAD USING 'EIS'.
  LEAVE LIST-PROCESSING.
ENDIF.
IF %DIACT = '1'.
  PERFORM %DOWNLOAD USING '+MEM'.
  LEAVE.
ENDIF.
IF %DIACT = 'X'.
  SET USER-COMMAND 'XXL'.
ELSEIF %DIACT = 'W'.
  SET USER-COMMAND 'TEXT'.
ELSEIF %DIACT = 'V'.
  SET USER-COMMAND 'ALV'.
ELSEIF %DIACT = 'T'.
  SET USER-COMMAND 'VIEW'.
ELSEIF %DIACT = 'G'.
  SET USER-COMMAND 'GRAF'.
ELSEIF %DIACT = 'A'.
  SET USER-COMMAND 'ABCA'.
ELSEIF %DIACT = 'E'.
  SET USER-COMMAND 'EIS'.
ELSEIF %DIACT = 'D'.
  SET USER-COMMAND 'DOWN'.
ELSEIF %DIACT = 'I'.
  SET USER-COMMAND 'XINT'.
ELSEIF %DIACT = 'P'.
  SET USER-COMMAND '+DAT'.
ENDIF.

TOP-OF-PAGE.
PERFORM %TOP-OF-PAGE.

END-OF-PAGE.
PERFORM PAGE_FOOT(RSAQEXCE).
PERFORM %SAVE_PAGE.

TOP-OF-PAGE DURING LINE-SELECTION.
PERFORM %TOP-OF-PAGE.

AT USER-COMMAND.
CASE SY-UCOMM.
WHEN 'EXIT'.
  LEAVE PROGRAM.
WHEN 'RETN'.
  PERFORM RETURN(RSAQEXCE).
WHEN 'CANC'.
  PERFORM RETURN(RSAQEXCE).
WHEN 'WEIT'.
  PERFORM RETURN(RSAQEXCE).
WHEN 'INHA'.
  PERFORM CATALOGUE(RSAQEXCE).
WHEN 'AUSL'.
  PERFORM PICKUP(RSAQEXCE).
WHEN 'AUSW'.
  PERFORM PICKUP(RSAQEXCE).
WHEN 'RCAA'.
  PERFORM RCHAIN(RSAQBRST).
WHEN 'RCAL'.
  PERFORM RCALL(RSAQBRST).
WHEN 'VGLI'.
  PERFORM CHANGE(RSAQEXCE).
WHEN 'VGLE'.
  PERFORM CHANGE(RSAQEXCE).
WHEN 'TOTO'.
  PERFORM CHANGE(RSAQEXCE).
WHEN 'VSTA'.
  PERFORM CHANGE(RSAQEXCE).
WHEN 'VSTE'.
  PERFORM RETURN(RSAQEXCE).
WHEN 'SAVL'.
  PERFORM %SAVE_LIST.
WHEN 'ODRU'.
  PERFORM PRINT_LIST(RSAQEXCE).
WHEN 'COPA'.
  PERFORM PRINT_COVER_PAGE(RSAQEXCE).
WHEN 'TEXT'.
  PERFORM %DOWNLOAD USING 'TEXT'.
WHEN 'ALV'.
  PERFORM %DOWNLOAD USING 'ALV'.
WHEN 'VIEW'.
  PERFORM %VIEW.
WHEN 'XXL'.
  PERFORM %DOWNLOAD USING 'XXL'.
WHEN 'GRAF'.
  PERFORM %DOWNLOAD USING 'GRAF'.
WHEN 'ABCA'.
  PERFORM %DOWNLOAD USING 'ABCA'.
WHEN 'EIS'.
  PERFORM %DOWNLOAD USING 'EIS'.
WHEN 'DOWN'.
  PERFORM %DOWNLOAD USING 'DOWN'.
WHEN 'XINT'.
  PERFORM %DOWNLOAD USING 'XINT'.
ENDCASE.
CLEAR: %CLINE, %ZGR.
CLEAR: %TAB, %LINE, %CONT.
IF %DIACT <> SPACE.
  LEAVE LIST-PROCESSING.
ENDIF.


FORM %COMP_LDESC.

  REFRESH %LDESC.
  REFRESH %GDESC.
  PERFORM LDESC(RSAQEXCE) USING 'G00010000X005       01  98'
    TEXT-A00 TEXT-B00 TEXT-H00 'ZTCO_EBUSPLANBOM-GJAHR'
    ZTCO_EBUSPLANBOM-GJAHR 'ZTCO_EBUSPLANBOM-GJAHR'.
  PERFORM LDESC(RSAQEXCE) USING 'G00020000X001       02  98'
    TEXT-A01 TEXT-B01 TEXT-H00 'ZTCO_EBUSPLANBOM-BOMTYPE'
    ZTCO_EBUSPLANBOM-BOMTYPE 'ZTCO_EBUSPLANBOM-BOMTYPE'.
  PERFORM LDESC(RSAQEXCE) USING 'G00030000X040       03  98'
    TEXT-A02 TEXT-B02 TEXT-H00 'ZTCO_EBUSPLANBOM-MATNR'
    ZTCO_EBUSPLANBOM-MATNR 'ZTCO_EBUSPLANBOM-MATNR'.
  PERFORM LDESC(RSAQEXCE) USING 'G00040000X004       04  98'
    TEXT-A03 TEXT-B03 TEXT-H00 'ZTCO_EBUSPLANBOM-WERKS'
    ZTCO_EBUSPLANBOM-WERKS 'ZTCO_EBUSPLANBOM-WERKS'.
  PERFORM LDESC(RSAQEXCE) USING 'G00050000X010       00  98'
    TEXT-A04 TEXT-B04 TEXT-H00 'ZTCO_EBUSPLANBOM-DATUV'
    ZTCO_EBUSPLANBOM-DATUV 'ZTCO_EBUSPLANBOM-DATUV'.
  PERFORM LDESC(RSAQEXCE) USING 'G00060000X040       00  98'
    TEXT-A05 TEXT-B05 TEXT-H00 'ZTCO_EBUSPLANBOM-MATNR_CHG'
    ZTCO_EBUSPLANBOM-MATNR_CHG '%FA00001'.
  PERFORM LDESC(RSAQEXCE) USING 'G00070000X040       00  98'
    TEXT-A06 TEXT-B06 TEXT-H00 'ZTCO_EBUSPLANBOM-MATNR_CHG2'
    ZTCO_EBUSPLANBOM-MATNR_CHG2 '%FA00002'.
  PERFORM LDESC(RSAQEXCE) USING 'G00080000X001       00  98'
    TEXT-A07 TEXT-B07 TEXT-H00 'ZTCO_EBUSPLANBOM-CHK_EXIST'
    ZTCO_EBUSPLANBOM-CHK_EXIST '%FA00000'.
  PERFORM LDESC(RSAQEXCE) USING 'G00090000X010       00  98'
    TEXT-A08 TEXT-B08 TEXT-H00 'ZTCO_EBUSPLANBOM-ERDAT'
    ZTCO_EBUSPLANBOM-ERDAT 'ZTCO_EBUSPLANBOM-ERDAT'.
  PERFORM LDESC(RSAQEXCE) USING 'G00100000X008       00  98'
    TEXT-A09 TEXT-B09 TEXT-H00 'ZTCO_EBUSPLANBOM-ERZET'
    ZTCO_EBUSPLANBOM-ERZET 'ZTCO_EBUSPLANBOM-ERZET'.
  PERFORM LDESC(RSAQEXCE) USING 'G00110000X012       00  98'
    TEXT-A10 TEXT-B10 TEXT-H00 'ZTCO_EBUSPLANBOM-ERNAM'
    ZTCO_EBUSPLANBOM-ERNAM 'ZTCO_EBUSPLANBOM-ERNAM'.
  PERFORM LDESC(RSAQEXCE) USING 'G00120000X010       00  98'
    TEXT-A11 TEXT-B11 TEXT-H00 'ZTCO_EBUSPLANBOM-AEDAT'
    ZTCO_EBUSPLANBOM-AEDAT 'ZTCO_EBUSPLANBOM-AEDAT'.
  PERFORM LDESC(RSAQEXCE) USING 'G00130000X008       00  98'
    TEXT-A12 TEXT-B12 TEXT-H00 'ZTCO_EBUSPLANBOM-AEZET'
    ZTCO_EBUSPLANBOM-AEZET 'ZTCO_EBUSPLANBOM-AEZET'.
  PERFORM LDESC(RSAQEXCE) USING 'G00140000X012       00  98'
    TEXT-A13 TEXT-B13 TEXT-H00 'ZTCO_EBUSPLANBOM-AENAM'
    ZTCO_EBUSPLANBOM-AENAM 'ZTCO_EBUSPLANBOM-AENAM'.
  PERFORM GDESC(RSAQEXCE) USING 'G00' 5 20 ' ' ' ' 'X'.
  PERFORM COMPLETE_LDESC(RSAQEXCE) TABLES %LDESC.

ENDFORM.

FORM %OUTPUT.

DESCRIBE TABLE %PRLIST LINES %MAX_PRLIST.
%HEAD = 'AAA'.
%KEYEMPTY = SPACE.
NEW-PAGE.
PERFORM %OUTPUT_GL.
PERFORM COMPLETE_PAGE(RSAQEXCE).
%HEAD = 'ZZZ'.
PERFORM LAST_PTAB_ENTRY(RSAQEXCE).
NEW-PAGE.
IF %KEYEMPTY <> SPACE.
  MESSAGE S894(AQ).
ENDIF.

ENDFORM.


FORM %TOP-OF-PAGE.

IF SY-UCOMM = 'INHA'. EXIT. ENDIF.
IF SY-UCOMM = 'COPA'. EXIT. ENDIF.
IF %HEAD    = SPACE.  EXIT. ENDIF.
IF %HEAD = 'DDD'.
  PERFORM TVIEWPAGE(RSAQEXCE).
  EXIT.
ENDIF.
IF %HEAD = 'GGG'.
  PERFORM PAGE(RSAQEXCE) USING 'G00' TEXT-GRL 252 %GLFRAME 001.
  SET LEFT SCROLL-BOUNDARY COLUMN 002.
  PERFORM SET_SCROLL_BOUNDARY(RSAQEXCE) USING 002.
  IF %TOTO <> SPACE. EXIT. ENDIF.
ELSE.
*  CASE %HEAD.
*  ENDCASE.
ENDIF.

ENDFORM.


FORM %NEWLINE.

  %UFLAG = SPACE.
  NEW-LINE.
  WRITE: '|', 252 '|'.
  POSITION 2.

ENDFORM.

FORM %SKIP USING COUNT.

  IF SY-LINNO > 1.
    %UFLAG = SPACE.
    DO COUNT TIMES.
      NEW-LINE.
      FORMAT RESET.
      WRITE: '|', 252 '|'.
    ENDDO.
  ENDIF.

ENDFORM.

FORM %ULINE.

  IF %UFLAG = SPACE.
    IF SY-LINNO > 1.
      ULINE /1(252).
    ENDIF.
    %UFLAG = 'X'.
  ENDIF.

ENDFORM.

FORM %HIDE.

  IF %BATCH <> SPACE AND %DIACT = 'S'.
    PERFORM HIDE(RSAQEXCE).
  ELSE.
    HIDE: %TAB, %LINE, %CONT.
  ENDIF.

ENDFORM.

FORM %HIDE_COLOR.

  IF %BATCH <> SPACE AND %DIACT = 'S'.
    PERFORM HIDE_COLOR(RSAQEXCE).
  ELSE.
    HIDE: %FINT, %FCOL.
  ENDIF.

ENDFORM.

FORM %RCALL USING NAME VALUE.

FIELD-SYMBOLS <FIELD>.

  ASSIGN (NAME) TO <FIELD>.
  READ CURRENT LINE FIELD VALUE <FIELD> INTO VALUE.
  IF SY-SUBRC <> 0.
    VALUE = SPACE.
    EXIT.
  ENDIF.
  IF VALUE = SPACE AND %TAB = 'G00' AND %LDESC-FCUR NA 'FM'.
    READ TABLE %G00 INDEX %LINE.
    IF SY-SUBRC = 0.
      ASSIGN COMPONENT %LDESC-FNAMEINT OF STRUCTURE %G00
                                       TO <FIELD>.
      IF SY-SUBRC = 0.
        WRITE <FIELD> TO VALUE(%LDESC-FOLEN).
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.

FORM %SAVE_PAGE.

  IF %BATCH <> SPACE AND %DIACT = 'S'.
    PERFORM SAVE_PAGE(RSAQEXCE) TABLES %ST_LISTE.
  ENDIF.

ENDFORM.

FORM %REPLACE_VAR USING TEXT.

FIELD-SYMBOLS <VAR>.

  ASSIGN TEXT+1(*) TO <VAR>.

ENDFORM.

FORM %SAVE_LIST.

DATA: %SFLAG,
      QREPORT LIKE SY-REPID.

  IF %DIACT = 'S'. %SFLAG = 'X'. ENDIF.
  QREPORT = SY-REPID.
  PERFORM SAVE_LIST(RSAQEXCE) TABLES %ST_LISTE
                              USING QREPORT %SFLAG %LISTID.
  IF %QL_ID <> SPACE.
    %DLFLAG = 'X'.
    %LISTSIZE = 0253.
    PERFORM COMP_SELECTION_SCREEN(RSAQEXCE).
    EXPORT %ST_LISTE %PTAB %LDESC %GDESC %DLFLAG %LISTSIZE
           %SELECTIONS
           %G00
           TO DATABASE AQLDB(AQ) ID %QL_ID.
  ENDIF.

ENDFORM.

FORM %REFRESH.

  CASE %TAB.
  WHEN 'G00'.
    IMPORT %G00 FROM DATABASE AQLDB(AQ) ID %QL_ID.
  ENDCASE.

ENDFORM.

FORM %DOWNLOAD USING CODE.

DATA: QREPORT LIKE SY-REPID.

  PERFORM INIT_DOWNLOAD(RSAQEXCE).
  QREPORT = SY-REPID.
  CASE %TAB.
  WHEN 'G00'.
    PERFORM DOWNLOAD(RSAQEXCE)
            TABLES %G00 USING CODE QREPORT TEXT-GRL.
  WHEN OTHERS.
    MESSAGE S860(AQ).
  ENDCASE.

ENDFORM.

FORM %SET_DATA CHANGING L_LINES TYPE I.

  IMPORT LDATA TO %G00 FROM MEMORY ID 'AQLISTDATA'.
  DESCRIBE TABLE %G00 LINES L_LINES.
  FREE MEMORY ID 'AQLISTDATA'.

ENDFORM.

FORM %GET_DATA TABLES DATATAB STRUCTURE %G00
               USING  FIRST TYPE I
                      LAST  TYPE I.

  APPEND LINES OF %G00 FROM FIRST TO LAST TO DATATAB.

ENDFORM.

FORM %GET_REF_TO_TABLE USING LID         LIKE RSAQLDESC-LID
                             REF_TO_ITAB TYPE REF TO DATA
                             SUBRC       LIKE SY-SUBRC.

  SUBRC = 0.
  CASE LID.
  WHEN 'G00'.
    CREATE DATA REF_TO_ITAB LIKE %G00[].
  WHEN OTHERS.
    SUBRC = 4.
    MESSAGE S860(AQ).
  ENDCASE.

ENDFORM.

FORM %VIEW.

DATA: RET TYPE I.

  PERFORM CHECK_WINGUI(RSAQSYST) USING RET.
  IF RET <> 0.
    MESSAGE S841(AQ).
    PERFORM %DOWNLOAD USING 'ALV'.
    EXIT.
  ENDIF.

DATA: ANZ TYPE I,
      PROG LIKE SY-REPID.

  PROG = SY-REPID.
  PERFORM INIT_DOWNLOAD(RSAQEXCE).
  CASE %TAB.
  WHEN 'G00'.
    PERFORM GENERATE_VIEW_DYNPRO(RSAQEXCE)
            USING PROG TEXT-GRL.
    DESCRIBE TABLE %G00 LINES ANZ.
    TVIEW100-LINES = ANZ.
    PERFORM INIT_VIEW(RSAQEXCE) TABLES %G00 USING TVIEW100.
    CALL SCREEN 100.
    PERFORM RESET_VIEW_DYNPRO(RSAQEXCE).
  WHEN OTHERS.
    MESSAGE S860(AQ).
  ENDCASE.

ENDFORM.


FORM %OUTPUT_GL.

IF %MAX_PRLIST <> 0.
  READ TABLE %PRLIST WITH KEY TAB = 'GGG'.
  IF SY-SUBRC <> 0.
    EXIT.
  ENDIF.
ENDIF.
SET MARGIN 00.
PERFORM COMPLETE_PAGE(RSAQEXCE).
%NOCHANGE = SPACE.
NEW-PAGE.
%GLLINE   = 0.
%TAB      = 'G00'.
%LINE     = 0.
%CONT     = '0'.
%FINT     = SPACE.
%FCOL     = '0'.
%HEAD     = 'GGG'.
%CLINE    = 0.
%OUTFLAG  = SPACE.
%OUTCOMP  = SPACE.
%OUTTOTAL = SPACE.
%RFLAG    = 'AA'.
IF %DIACT <> SPACE AND %DIACT NA 'SWE'. WRITE SPACE. ENDIF.
FORMAT RESET.
LOOP.
  %DATA_SELECTED = 'X'.
  AT %FG01.
    %ZNR = '01'.
    %ZGR = '01'.
    %CLINE = %CLINE + 1.
    %G00-ZTCO_EBUSPLANBOM-GJAHR = ZTCO_EBUSPLANBOM-GJAHR.
    %G00-ZTCO_EBUSPLANBOM-BOMTYPE = ZTCO_EBUSPLANBOM-BOMTYPE.
    %G00-ZTCO_EBUSPLANBOM-MATNR = ZTCO_EBUSPLANBOM-MATNR.
    %G00-ZTCO_EBUSPLANBOM-WERKS = ZTCO_EBUSPLANBOM-WERKS.
    %G00-ZTCO_EBUSPLANBOM-DATUV = ZTCO_EBUSPLANBOM-DATUV.
    %G00-%FA00001 = ZTCO_EBUSPLANBOM-MATNR_CHG.
    %G00-%FA00002 = ZTCO_EBUSPLANBOM-MATNR_CHG2.
    %G00-%FA00000 = ZTCO_EBUSPLANBOM-CHK_EXIST.
    %G00-ZTCO_EBUSPLANBOM-ERDAT = ZTCO_EBUSPLANBOM-ERDAT.
    %G00-ZTCO_EBUSPLANBOM-ERZET = ZTCO_EBUSPLANBOM-ERZET.
    %G00-ZTCO_EBUSPLANBOM-ERNAM = ZTCO_EBUSPLANBOM-ERNAM.
    %G00-ZTCO_EBUSPLANBOM-AEDAT = ZTCO_EBUSPLANBOM-AEDAT.
    %G00-ZTCO_EBUSPLANBOM-AEZET = ZTCO_EBUSPLANBOM-AEZET.
    %G00-ZTCO_EBUSPLANBOM-AENAM = ZTCO_EBUSPLANBOM-AENAM.
    IF %FIRST <> SPACE. APPEND %G00. ENDIF.
    %GLLINE = %GLLINE + 1.
    %LZNR = %ZNR.
    IF %DIACT <> SPACE AND %DIACT NA 'SWE'. CONTINUE. ENDIF.
    PERFORM CHECK(RSAQEXCE) USING ' '.
    IF %RFLAG = 'E'. EXIT. ENDIF.
IF ZTCO_EBUSPLANBOM-GJAHR <> %%ZTCO_EBUSPLANBOM-GJAHR OR
%%%ZTCO_EBUSPLANBOM-GJAHR = SPACE.
      %%ZTCO_EBUSPLANBOM-GJAHR = ZTCO_EBUSPLANBOM-GJAHR.
      %%%ZTCO_EBUSPLANBOM-GJAHR ='X'.
      CLEAR %%ZTCO_EBUSPLANBOM-BOMTYPE.
      CLEAR %%%ZTCO_EBUSPLANBOM-BOMTYPE.
      CLEAR %%ZTCO_EBUSPLANBOM-MATNR.
      CLEAR %%%ZTCO_EBUSPLANBOM-MATNR.
      CLEAR %%ZTCO_EBUSPLANBOM-WERKS.
      CLEAR %%%ZTCO_EBUSPLANBOM-WERKS.
    ENDIF.
IF ZTCO_EBUSPLANBOM-BOMTYPE <> %%ZTCO_EBUSPLANBOM-BOMTYPE OR
%%%ZTCO_EBUSPLANBOM-BOMTYPE = SPACE.
      %%ZTCO_EBUSPLANBOM-BOMTYPE = ZTCO_EBUSPLANBOM-BOMTYPE.
      %%%ZTCO_EBUSPLANBOM-BOMTYPE ='X'.
      CLEAR %%ZTCO_EBUSPLANBOM-MATNR.
      CLEAR %%%ZTCO_EBUSPLANBOM-MATNR.
      CLEAR %%ZTCO_EBUSPLANBOM-WERKS.
      CLEAR %%%ZTCO_EBUSPLANBOM-WERKS.
    ENDIF.
IF ZTCO_EBUSPLANBOM-MATNR <> %%ZTCO_EBUSPLANBOM-MATNR OR
%%%ZTCO_EBUSPLANBOM-MATNR = SPACE.
      %%ZTCO_EBUSPLANBOM-MATNR = ZTCO_EBUSPLANBOM-MATNR.
      %%%ZTCO_EBUSPLANBOM-MATNR ='X'.
      CLEAR %%ZTCO_EBUSPLANBOM-WERKS.
      CLEAR %%%ZTCO_EBUSPLANBOM-WERKS.
    ENDIF.
IF ZTCO_EBUSPLANBOM-WERKS <> %%ZTCO_EBUSPLANBOM-WERKS OR
%%%ZTCO_EBUSPLANBOM-WERKS = SPACE.
      %%ZTCO_EBUSPLANBOM-WERKS = ZTCO_EBUSPLANBOM-WERKS.
      %%%ZTCO_EBUSPLANBOM-WERKS ='X'.
    ENDIF.
    IF %RFLAG(1) = 'A'.
    FORMAT RESET.
    %FINT = 'F'. %FCOL = '0'.
    FORMAT COLOR 2. %FCOL = '2'.
    PERFORM %NEWLINE.
    WRITE 002(005) ZTCO_EBUSPLANBOM-GJAHR
      INTENSIFIED ON
      COLOR 3 ON.
    %LINE = %GLLINE.
    PERFORM %HIDE.
    %LINE = 0.
    PERFORM %HIDE_COLOR.
    WRITE 008(001) ZTCO_EBUSPLANBOM-BOMTYPE.
    WRITE 010(040) ZTCO_EBUSPLANBOM-MATNR.
    WRITE 051(004) ZTCO_EBUSPLANBOM-WERKS
      INTENSIFIED OFF
      COLOR 7 ON.
    WRITE 056(010) ZTCO_EBUSPLANBOM-DATUV.
    WRITE 067(040) ZTCO_EBUSPLANBOM-MATNR_CHG
      INTENSIFIED ON
      COLOR 2 ON.
    WRITE 108(040) ZTCO_EBUSPLANBOM-MATNR_CHG2.
    WRITE 149(001) ZTCO_EBUSPLANBOM-CHK_EXIST
      INTENSIFIED ON
      COLOR 2 ON.
    WRITE 151(010) ZTCO_EBUSPLANBOM-ERDAT.
    WRITE 162(008) ZTCO_EBUSPLANBOM-ERZET.
    WRITE 171(012) ZTCO_EBUSPLANBOM-ERNAM.
    WRITE 184(010) ZTCO_EBUSPLANBOM-AEDAT.
    WRITE 195(008) ZTCO_EBUSPLANBOM-AEZET.
    WRITE 204(012) ZTCO_EBUSPLANBOM-AENAM.
    ENDIF.
  ENDAT.
  AT END OF ZTCO_EBUSPLANBOM-WERKS.
    %ZGR = '01'.
    PERFORM CHECK(RSAQEXCE) USING 'X'.
    IF %RFLAG = 'E'. EXIT. ENDIF.
  ENDAT.
  AT END OF ZTCO_EBUSPLANBOM-MATNR.
    %ZGR = '01'.
    PERFORM CHECK(RSAQEXCE) USING 'X'.
    IF %RFLAG = 'E'. EXIT. ENDIF.
  ENDAT.
  AT END OF ZTCO_EBUSPLANBOM-BOMTYPE.
    %ZGR = '01'.
    PERFORM CHECK(RSAQEXCE) USING 'X'.
    IF %RFLAG = 'E'. EXIT. ENDIF.
  ENDAT.
  AT END OF ZTCO_EBUSPLANBOM-GJAHR.
    %ZGR = '01'.
    PERFORM CHECK(RSAQEXCE) USING 'X'.
    IF %RFLAG = 'E'. EXIT. ENDIF.
  ENDAT.
ENDLOOP.
%RFLAG = 'AA'.
PERFORM %ULINE.
CLEAR: %CLINE, %ZGR.

ENDFORM.



MODULE %INIT_VIEW OUTPUT.

  CASE %TAB.
  WHEN 'G00'.
    PERFORM INIT_PBO(RSAQEXCE) TABLES %G00 USING TVIEW100 'X'.
  WHEN OTHERS.
    MESSAGE S860(AQ).
  ENDCASE.

ENDMODULE.

MODULE %PBO_VIEW OUTPUT.

  CASE %TAB.
  WHEN 'G00'.
    PERFORM LOOP_PBO(RSAQEXCE) TABLES %G00 USING %%G00 TVIEW100.
  ENDCASE.

ENDMODULE.

MODULE %PAI_VIEW INPUT.

  CASE %TAB.
  WHEN 'G00'.
    PERFORM LOOP_PAI(RSAQEXCE) TABLES %G00 USING %%G00 TVIEW100.
  ENDCASE.

ENDMODULE.

MODULE %OKCODE_VIEW INPUT.

  CASE %TAB.
  WHEN 'G00'.
    PERFORM OKCODE(RSAQEXCE) TABLES %G00 USING TVIEW100.
  ENDCASE.

ENDMODULE.

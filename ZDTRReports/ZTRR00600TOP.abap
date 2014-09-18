*&---------------------------------------------------------------------*
*&  Include           ZTRR00600TOP
*&---------------------------------------------------------------------*
*Define
DEFINE ICLEAR.
  CLEAR : &1, &1[].
END-OF-DEFINITION.

DEFINE IAPPEND.
  APPEND : &1.
  CLEAR  : &1.
END-OF-DEFINITION.

DEFINE ICOLLECT.
  COLLECT : &1.
  CLEAR   : &1.
END-OF-DEFINITION.

FIELD-SYMBOLS <FS>.

DATA : BEGIN OF GT_DATE OCCURS 0,
         INDEX(2) TYPE N,
         DATUM LIKE SY-DATUM,
       END OF GT_DATE.

DATA: BEGIN OF HIER_TB OCCURS 100.
        INCLUDE STRUCTURE TKCHS.
DATA: END OF HIER_TB.

DATA: BEGIN OF HIER_DB OCCURS 100.
        INCLUDE STRUCTURE TKCHA.
DATA: END OF HIER_DB.

DATA : BEGIN OF GT_PA OCCURS 0,
         FDGRV    LIKE KNB1-FDGRV,   "Planning group
***         PERBL    LIKE CE2HK00-PERBL,
***         VV002001 LIKE CE2HK00-VV002001,
***         VV003001 LIKE CE2HK00-VV003001,
***         VV004001 LIKE CE2HK00-VV004001,
***         VV005001 LIKE CE2HK00-VV005001,
***         VV006001 LIKE CE2HK00-VV006001,
***         VV007001 LIKE CE2HK00-VV007001,
***         VV140001 LIKE CE2HK00-VV140001,
***         VV141001 LIKE CE2HK00-VV141001,
***         VV142001 LIKE CE2HK00-VV142001,
***         VV143001 LIKE CE2HK00-VV143001,
***         VV144001 LIKE CE2HK00-VV144001,
***         VV145001 LIKE CE2HK00-VV145001,
***         VV146001 LIKE CE2HK00-VV146001,
***         VV147001 LIKE CE2HK00-VV147001,
       END OF GT_PA,

       BEGIN OF GT_CCA OCCURS 0,
         AUFNR  LIKE AUFK-AUFNR,
         OBJNR  LIKE AUFK-OBJNR,
         FDGRV  LIKE ZTTR0009-FDGRV,
         WKG001 LIKE COSP-WKG001,
         WKG002 LIKE COSP-WKG002,
         WKG003 LIKE COSP-WKG003,
         WKG004 LIKE COSP-WKG004,
         WKG005 LIKE COSP-WKG005,
         WKG006 LIKE COSP-WKG006,
         WKG007 LIKE COSP-WKG007,
         WKG008 LIKE COSP-WKG008,
         WKG009 LIKE COSP-WKG009,
         WKG010 LIKE COSP-WKG010,
         WKG011 LIKE COSP-WKG011,
         WKG012 LIKE COSP-WKG012,
         WKG013 LIKE COSP-WKG013,
         WKG014 LIKE COSP-WKG014,
         WKG015 LIKE COSP-WKG015,
         WKG016 LIKE COSP-WKG016,
       END OF GT_CCA,

       BEGIN OF GT_IM OCCURS 0,
         KSTAR  LIKE COSP-KSTAR,
         OBJNR  LIKE COSP-OBJNR,
         FDGRV  LIKE SKB1-FDGRV,
         WKG001 LIKE COSP-WKG001,
         WKG002 LIKE COSP-WKG002,
         WKG003 LIKE COSP-WKG003,
         WKG004 LIKE COSP-WKG004,
         WKG005 LIKE COSP-WKG005,
         WKG006 LIKE COSP-WKG006,
         WKG007 LIKE COSP-WKG007,
         WKG008 LIKE COSP-WKG008,
         WKG009 LIKE COSP-WKG009,
         WKG010 LIKE COSP-WKG010,
         WKG011 LIKE COSP-WKG011,
         WKG012 LIKE COSP-WKG012,
         WKG013 LIKE COSP-WKG013,
         WKG014 LIKE COSP-WKG014,
         WKG015 LIKE COSP-WKG015,
         WKG016 LIKE COSP-WKG016,
       END OF GT_IM,

       BEGIN OF GT_MANUAL OCCURS 0,
         GRUPP   LIKE FDSR-GRUPP,
         TEXTL   LIKE T035T-TEXTL,
         DMSHB01 LIKE FDSR-DMSHB,
         DMSHB02 LIKE FDSR-DMSHB,
         DMSHB03 LIKE FDSR-DMSHB,
         DMSHB04 LIKE FDSR-DMSHB,
         DMSHB05 LIKE FDSR-DMSHB,
         DMSHB06 LIKE FDSR-DMSHB,
         DMSHB07 LIKE FDSR-DMSHB,
         DMSHB08 LIKE FDSR-DMSHB,
         DMSHB09 LIKE FDSR-DMSHB,
         DMSHB10 LIKE FDSR-DMSHB,
         DMSHB11 LIKE FDSR-DMSHB,
         DMSHB12 LIKE FDSR-DMSHB,
       END OF GT_MANUAL,

       BEGIN OF GT_7000 OCCURS 0,
         GRUPP   LIKE FDSR-GRUPP,
         TEXTL   LIKE T035T-TEXTL,
         DMSHB01 LIKE FDSR-DMSHB,
         DMSHB02 LIKE FDSR-DMSHB,
         DMSHB03 LIKE FDSR-DMSHB,
         DMSHB04 LIKE FDSR-DMSHB,
         DMSHB05 LIKE FDSR-DMSHB,
         DMSHB06 LIKE FDSR-DMSHB,
         DMSHB07 LIKE FDSR-DMSHB,
         DMSHB08 LIKE FDSR-DMSHB,
         DMSHB09 LIKE FDSR-DMSHB,
         DMSHB10 LIKE FDSR-DMSHB,
         DMSHB11 LIKE FDSR-DMSHB,
         DMSHB12 LIKE FDSR-DMSHB,
       END OF GT_7000.

DATA : BEGINNING  LIKE  FDSR OCCURS 0 WITH HEADER LINE,
       PLAN       LIKE  FDSR OCCURS 0 WITH HEADER LINE,
       ENDING     LIKE  FDSR OCCURS 0 WITH HEADER LINE,
       DATE       LIKE  SY-DATUM OCCURS 0 WITH HEADER LINE.
DATA : FIELDNAME(30).

CLASS LCL_APPLICATION DEFINITION DEFERRED.

TYPES: ITEM_TABLE_TYPE LIKE STANDARD TABLE OF MTREEITM
       WITH DEFAULT KEY.

DATA : G_CUSTOM_CONTAINER  TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
       G_GRID              TYPE REF TO CL_GUI_COLUMN_TREE,
       GT_NODE_TABLE       TYPE TREEV_NTAB WITH HEADER LINE,
       GT_ITEM_TABLE       TYPE ITEM_TABLE_TYPE WITH HEADER LINE,
       GS_HIERARCHY_HEADER TYPE TREEV_HHDR,

       G_CUSTOM_7000       TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
       G_GRID_7000         TYPE REF TO CL_GUI_ALV_GRID,
       GT_FIELDCAT1        TYPE LVC_T_FCAT,
       GT_FIELDCAT         TYPE SLIS_T_FIELDCAT_ALV,
       GS_FIELDCAT         TYPE SLIS_FIELDCAT_ALV,
       GS_FIELDCAT_LVC     TYPE LVC_S_FCAT,
       GS_STABLE           TYPE LVC_S_STBL,
       GS_LAYOUT_7000      TYPE LVC_S_LAYO,
       GT_EXCLUDE          TYPE UI_FUNCTIONS.   "Tool Bar Button##


DATA : G_EVENTS            TYPE CNTL_SIMPLE_EVENTS.
DATA : G_EVENT             TYPE CNTL_SIMPLE_EVENT.
DATA : G_APPLICATION       TYPE REF TO LCL_APPLICATION.
DATA : OK_CODE LIKE SY-UCOMM.

DATA : LATER(1)             VALUE  ' ',
       ALL_DAY              VALUE  SPACE,
       G_WAERS              LIKE T001-WAERS,
       G_PA,
       G_CCA,
       G_IM,
       G_NODE_KEY_TABLE     TYPE TREEV_NKS WITH HEADER LINE.

CONSTANTS : C_YEARLY        TYPE ZPLAN VALUE '4',
            C_DAY(1)                   VALUE 'D',
            C_MONTH(1)                 VALUE 'M',
            C_BEGIN(12)                VALUE 'Begin',
            C_END(12)                  VALUE 'End'.

*---------------------------------------------------------------------*
*  Selection Screen                                                   *
*---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE  TEXT-T01.

PARAMETERS: P_BUKRS  LIKE FAGLFLEXT-RBUKRS,
            P_GJAHR  TYPE GJAHR DEFAULT SY-DATUM(4),
            P_VERSN  LIKE COSP-VERSN DEFAULT '001'.
SELECTION-SCREEN skip 1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-T02.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 01(11) TEXT-T21 FOR FIELD P_SKALV. "Skalierung
PARAMETERS: P_SKALV TYPE TS70SKAL_VOR  DEFAULT '3'.
SELECTION-SCREEN COMMENT 16(16) TEXT-T22 FOR FIELD P_DECIM. "Nachkommast
PARAMETERS: P_DECIM TYPE TS70SKAL_NACH DEFAULT '0'.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-T03.
PARAMETERS     : P_HIER  LIKE TKCHH-ID2 DEFAULT 'H02'
                       VISIBLE LENGTH 3 NO-DISPLAY ,
                 P_R1 RADIOBUTTON GROUP G1 DEFAULT 'X' USER-COMMAND F1,
                 P_R2 RADIOBUTTON GROUP G1,
                 P_SEQNO LIKE ZTTR0008-SEQNO MODIF ID G1.
SELECTION-SCREEN END OF BLOCK B3.
SELECTION-SCREEN END   OF BLOCK B1.

*---------------------------------------------------------------------*
*  AT SELECTION-SCREEN OUTPUT.                                        *
*---------------------------------------------------------------------*

AT SELECTION-SCREEN OUTPUT.

  IF P_R1 = 'X'.
    LOOP AT SCREEN.
      IF SCREEN-GROUP1 = 'G1'.
        SCREEN-INPUT     = 0.
        SCREEN-INVISIBLE = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_SEQNO.

  DATA : GT_SCRFIELD LIKE  DYNPREAD OCCURS 0 WITH HEADER LINE.
  GT_SCRFIELD-FIELDNAME = 'P_GJAHR'.
  IAPPEND GT_SCRFIELD.

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      DYNAME             = SY-CPROG
      DYNUMB             = SY-DYNNR
      TRANSLATE_TO_UPPER = 'X'
    TABLES
      DYNPFIELDS         = GT_SCRFIELD.

  READ TABLE GT_SCRFIELD WITH KEY FIELDNAME = 'P_GJAHR'.
  IF SY-SUBRC = 0 AND GT_SCRFIELD-FIELDVALUE IS NOT INITIAL.
    P_GJAHR = GT_SCRFIELD-FIELDVALUE.
  ENDIF.

*  DATA : BEGIN OF GT_SEQ OCCURS 0,
*          SEQNO LIKE ZTTR0008-SEQNO,
*         END OF GT_SEQ,
  DATA : BEGIN OF GT_SEQ OCCURS 0,
             SEQNO LIKE ZTTR0008-SEQNO,
             ERNAM LIKE ZTTR0008-ERNAM,
             ERDAT LIKE ZTTR0008-ERDAT,
             ERZET LIKE ZTTR0008-ERZET,
             AENAM LIKE ZTTR0008-AENAM,
             AEDAT LIKE ZTTR0008-AEDAT,
             AEZET LIKE ZTTR0008-AEZET,
           END OF GT_SEQ,
           L_PDAT1 LIKE ZTTR0008-PDAT1.
  DATA: L_TITLE(40).

  ICLEAR GT_SEQ.

*  SELECT DISTINCT SEQNO INTO TABLE GT_SEQ
  SELECT DISTINCT SEQNO ERNAM ERDAT ERZET AENAM AEDAT AEZET
    INTO CORRESPONDING FIELDS OF TABLE GT_SEQ
    FROM ZTTR0008
   WHERE BUKRS = P_BUKRS
     AND GJAHR = P_GJAHR
     AND ZTYPE = C_YEARLY.
  SORT GT_SEQ.

  CONCATENATE 'Plan Version :' P_GJAHR INTO L_TITLE.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD        = 'SEQNO'
      DYNPPROG        = SY-REPID
      DYNPNR          = SY-DYNNR
      DYNPROFIELD     = 'P_SEQNO'
      WINDOW_TITLE    = L_TITLE
      VALUE_ORG       = 'S'
    TABLES
      VALUE_TAB       = GT_SEQ
    EXCEPTIONS
      PARAMETER_ERROR = 1
      NO_VALUES_FOUND = 2
      OTHERS          = 3.

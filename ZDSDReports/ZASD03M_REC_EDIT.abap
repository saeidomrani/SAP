************************************************************************
* Program Name      : ZASD03M_REC_EDIT
* Author            : jun ho choi
* Creation Date     : 2003.07.21.
* Specifications By : jun ho choi
* Pattern           : 3-3
* Development Request No : UD1K904910
* Addl Documentation:
* Description       : Create Debit Memo Request based on Reclaim
*                          result in SAP Costum Tables.
*
* Modification Logs
* Date       Developer    RequestNo    Description
* 02/14/2005 Chris        ud1k914272   a. change the screen layout and
*                                       add result display
*                                      b. change the bachground job
*                                       event trigger to direct call
*                                      c. import the result for display
* 08.19.2014      Victor     T-code has been deleted for APM         *
*
************************************************************************
REPORT ZASD03M_REC_EDIT NO STANDARD PAGE HEADING
                        MESSAGE-ID ZMSD.


*
TABLES : ZTSD_ACM_H,
         ZTSD_ACM_I,
         ZTSD_ACL_L,
         ZTSD_REC_H,
         ZTSD_REC_I,
         ZTSD_REC_L,
         ZTSD_PART_INF,
         ZTSD_PART_PRC,
         ZTSD_PART_HST,
         ZTSD_PART_SUP,
         ZTSD_VEN_WC,
         ZTSD_RATIO_I,
         CABN,
         AUSP,
         TCURR,
         KNA1,
         TBTCO.


*
DATA : BEGIN OF IT_ACM_H OCCURS 0.
        INCLUDE STRUCTURE ZTSD_ACM_H.
DATA : END OF IT_ACM_H.

DATA : BEGIN OF IT_ACM_I OCCURS 0.
        INCLUDE STRUCTURE ZTSD_ACM_I.
DATA : END OF IT_ACM_I.

DATA : BEGIN OF IT_REC_H OCCURS 0.
        INCLUDE STRUCTURE ZTSD_REC_H.
DATA : END OF IT_REC_H.

DATA : BEGIN OF IT_REC_I OCCURS 0.
        INCLUDE STRUCTURE ZTSD_REC_I.
DATA : END OF IT_REC_I.

DATA : BEGIN OF IT_REC_L OCCURS 0.
        INCLUDE STRUCTURE ZTSD_REC_L.
DATA : END OF IT_REC_L.

DATA : BEGIN OF IT_PART_INF OCCURS 0.
        INCLUDE STRUCTURE ZTSD_PART_INF.
DATA : END OF IT_PART_INF.

DATA : BEGIN OF IT_PART_PRC OCCURS 0.
        INCLUDE STRUCTURE ZTSD_PART_PRC.
DATA : END OF IT_PART_PRC.

DATA : BEGIN OF IT_PART_HST OCCURS 0.
        INCLUDE STRUCTURE ZTSD_PART_HST.
DATA : END OF IT_PART_HST.

DATA : BEGIN OF IT_PART_SUP OCCURS 0.
        INCLUDE STRUCTURE ZTSD_PART_SUP.
DATA : END OF IT_PART_SUP.

DATA : BEGIN OF IT_VEN_WC OCCURS 0.
        INCLUDE STRUCTURE ZTSD_VEN_WC.
DATA : END OF IT_VEN_WC.

DATA : BEGIN OF IT_RATIO_I OCCURS 0.
        INCLUDE STRUCTURE ZTSD_RATIO_I.
DATA : END OF IT_RATIO_I.

DATA : BEGIN OF IT_VENDOR OCCURS 0,
       ZCPTN LIKE IT_PART_HST-ZCPTN,
       ZVEND LIKE IT_PART_HST-ZVEND,
       ZSQTY LIKE IT_PART_SUP-ZQTY01,
       ZSPRT LIKE IT_REC_H-ZSPRT,
       END OF IT_VENDOR.

DATA : BEGIN OF IT_VM OCCURS 0,
       ZVIN  LIKE IT_ACM_H-ZVIN,
       ZPD   LIKE SY-DATUM,
       ZSD   LIKE SY-DATUM,
       END OF IT_VM.

DATA : SAVE_OK_CODE(4).

DATA : W_CNT TYPE I,
       W_INDEX LIKE SY-TABIX.

DATA : W_ZISSN LIKE ZTSD_ACL_L-ZISSN,
       W_ZISSN_SCR LIKE ZTSD_ACL_L-ZISSN,
       W_ZSQTY LIKE IT_PART_SUP-ZQTY01,
       W_ZSPRT LIKE IT_REC_H-ZSPRT,
       W_ZODRD TYPE P DECIMALS 9,
       W_NUMC_8(8) TYPE N,
       W_MODE(4),
       W_UKURS LIKE TCURR-UKURS,
       W_COLR LIKE ZTSD_RATIO_I-ZCOLR.

DATA : W_ERR(1),
       W_CON_FG(1),
       W_MY(4),
       W_DATE_3 LIKE SY-DATUM, "-3
       W_DATE_2 LIKE SY-DATUM. "2

* PF-STATUS
TYPES : BEGIN OF TAB_TYPE,
        FCODE LIKE RSMPE-FUNC,
        END OF TAB_TYPE.

DATA : TAB TYPE STANDARD TABLE OF TAB_TYPE WITH
               NON-UNIQUE DEFAULT KEY INITIAL SIZE 10,
       WA_TAB TYPE TAB_TYPE.


*
DATA : VARIANT LIKE INDX-SRTFD VALUE 'ASD03_01'.

DATA : BEGIN OF IT_LIST OCCURS 0.
        INCLUDE STRUCTURE ZTSD_ACL_L.
DATA : FLAG,       "flag for mark column
       OKCODE(4).
DATA : END OF IT_LIST.

DATA: EVENTID LIKE TBTCJOB-EVENTID.

CONTROLS: TC9001 TYPE TABLEVIEW USING SCREEN 9001,
          TC9002 TYPE TABLEVIEW USING SCREEN 9002,
          TC9003 TYPE TABLEVIEW USING SCREEN 9003.


*
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : S_ZCMRD FOR ZTSD_ACL_L-ZCMRD NO-EXTENSION.
PARAMETERS : P_ZRCFG LIKE ZTSD_ACL_L-ZRCFG.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS : P_ALL   RADIOBUTTON GROUP RD.
SELECTION-SCREEN COMMENT 10(30) TEXT-012 FOR FIELD P_ALL.
PARAMETERS : P_ONE   RADIOBUTTON GROUP RD .
SELECTION-SCREEN COMMENT 50(30) TEXT-011 FOR FIELD P_ONE.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK B1.


*
START-OF-SELECTION.
  PERFORM READ_DATA.


*
END-OF-SELECTION.
  PERFORM CALL_SCREEN.









************************************************************************
* TYPE FOR THE DATA OF TABLECONTROL 'TC_9000'
  TYPES: BEGIN OF T_TC_9000.
          INCLUDE STRUCTURE ZTSD_ACL_L.
  TYPES:   FLAG,       "flag for mark column
         END OF T_TC_9000.

* INTERNAL TABLE FOR TABLECONTROL 'TC_9000'
  DATA:     G_TC_9000_ITAB   TYPE T_TC_9000 OCCURS 0,
            G_TC_9000_WA     TYPE T_TC_9000, "work area
            G_TC_9000_COPIED.           "copy flag

* DECLARATION OF TABLECONTROL 'TC_9000' ITSELF
  CONTROLS: TC_9000 TYPE TABLEVIEW USING SCREEN 9000.

* LINES OF TABLECONTROL 'TC_9000'
  DATA:     G_TC_9000_LINES  LIKE SY-LOOPC.

  DATA:     OK_CODE LIKE SY-UCOMM.


* Includes inserted by Screen Painter Wizard. DO NOT CHANGE THIS LINE!
  INCLUDE ZASD03L_REC_EDIT_F01.
  INCLUDE ZASD03L_REC_EDIT_PBO.
  INCLUDE ZASD03L_REC_EDIT_PAI.




* FUNCTION CODES FOR TABSTRIP 'TAB1'
  CONSTANTS: BEGIN OF C_TAB1,
               TAB1 LIKE SY-UCOMM VALUE 'TAB1_FC1',
               TAB2 LIKE SY-UCOMM VALUE 'TAB1_FC2',
               TAB3 LIKE SY-UCOMM VALUE 'TAB1_FC3',
             END OF C_TAB1.
* DATA FOR TABSTRIP 'TAB1'
  CONTROLS:  TAB1 TYPE TABSTRIP.
  DATA:      BEGIN OF G_TAB1,
               SUBSCREEN   LIKE SY-DYNNR,
               PROG        LIKE SY-REPID VALUE 'ZASD03M_REC_EDIT',
               PRESSED_TAB LIKE SY-UCOMM VALUE C_TAB1-TAB1,
             END OF G_TAB1.

* OUTPUT MODULE FOR TABSTRIP 'TAB1': SETS ACTIVE TAB
MODULE TAB1_ACTIVE_TAB_SET OUTPUT.
  TAB1-ACTIVETAB = G_TAB1-PRESSED_TAB.
  CASE G_TAB1-PRESSED_TAB.
    WHEN C_TAB1-TAB1.
      G_TAB1-SUBSCREEN = '9001'.
    WHEN C_TAB1-TAB2.
      G_TAB1-SUBSCREEN = '9002'.
    WHEN C_TAB1-TAB3.
      G_TAB1-SUBSCREEN = '9003'.
    WHEN OTHERS.
*      DO NOTHING
  ENDCASE.
ENDMODULE.

* INPUT MODULE FOR TABSTRIP 'TAB1': GETS ACTIVE TAB
MODULE TAB1_ACTIVE_TAB_GET INPUT.
  OK_CODE = SY-UCOMM.
  CASE OK_CODE.
    WHEN C_TAB1-TAB1.
      G_TAB1-PRESSED_TAB = C_TAB1-TAB1.
    WHEN C_TAB1-TAB2.
      G_TAB1-PRESSED_TAB = C_TAB1-TAB2.
    WHEN C_TAB1-TAB3.
      G_TAB1-PRESSED_TAB = C_TAB1-TAB3.
    WHEN OTHERS.
*      DO NOTHING
  ENDCASE.
ENDMODULE.

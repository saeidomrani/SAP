*&---------------------------------------------------------------------*
*& Include MZEMMPM45E_MODULETOP                                        *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  SAPMZEMMPM45E_MODULE          .

TABLES : CKI64A,
         ZTBM_ABXDULDT,
         MARA,
         KONP,
         T024,
         T100.

TABLES : CTU_PARAMS.

DATA : IT_MODULE  LIKE ZTMM_MODULE OCCURS   0 WITH HEADER LINE,
       IT_PART    LIKE ZTBM_ABXDULDT OCCURS 0 WITH HEADER LINE,
       IT_200     LIKE ZSCO_ADD_COST OCCURS 0 WITH HEADER LINE.


* Field name & desciption
* KLVAR	Costing Variant
* MATNR	Material number
* WERKS	Plant
* TVERS	Costing version
* LOSGR	Costing lot size
* KADAT	Costing date from
* BIDAT	Costing date to
* RAW_MATERIAL	Material component
* TYPPS	Item category
* KSTAR	Cost element
* MENGE	Quantity
* LPREIS	Price in entry currency
* LPREIFX	Fixed price in entry currency
* LPEINH	Price unit
* LIFNR	Account number of vendor or creditor
* MEINS	Base unit of measure

DATA : BEGIN OF IT_100 OCCURS 10 ,
       MARK     TYPE C,
       KLVAR    LIKE ZTMM_MODULE-KLVAR,
       MATNR    LIKE ZTMM_MODULE-MATNR,
       WERKS    LIKE ZTMM_MODULE-WERKS,
       LOSGR    LIKE ZTMM_MODULE-LOSGR,
       TVERS    LIKE ZTMM_MODULE-TVERS,
       KADAT    LIKE ZTMM_MODULE-KADAT,
       BIDAT    LIKE ZTMM_MODULE-BIDAT,
       COMP     LIKE ZTMM_MODULE-RAW_MATERIAL,
       TYPPS    LIKE ZTMM_MODULE-TYPPS,
       KSTAR    LIKE ZTMM_MODULE-KSTAR,
       MENGE    LIKE ZTMM_MODULE-MENGE,
       PUNIT    LIKE ZTMM_MODULE-MENGE,
       LPREIS   LIKE ZTMM_MODULE-LPREIS,
       LPREIFX  LIKE ZTMM_MODULE-LPREIFX,
       LPEINH   LIKE ZTMM_MODULE-LPEINH,
       LIFNR    LIKE ZTMM_MODULE-LIFNR,
       MEINS    LIKE ZTMM_MODULE-MEINS,
       END OF IT_100.

DATA : BEGIN OF IT_400 OCCURS 10,
       MARK     TYPE C,
       MATNR    LIKE ZTMM_MODULE-MATNR,
       LIFNR    LIKE ZTMM_MODULE-LIFNR,
       KBETR    LIKE KONP-KBETR,
       KZUST    LIKE KONH-KZUST,
       KADAT    LIKE ZTMM_MODULE-KADAT,
       BIDAT    LIKE ZTMM_MODULE-BIDAT,
       VTEXT    LIKE T686D-VTEXT,
       EKGRP    LIKE EINE-EKGRP,
       FLAG     TYPE C,
       MODE     TYPE C,
       END OF IT_400.

DATA : IT_BAPIEINE   LIKE BAPIEINE   OCCURS 0 WITH HEADER LINE,
       IT_RETURN     LIKE BAPIRETURN OCCURS 0 WITH HEADER LINE.


DATA : WA_LINE TYPE I,
       WA_T_LINES TYPE I.

DATA : OK_CODE LIKE SY-UCOMM.

CONTROLS: TC_100 TYPE TABLEVIEW USING SCREEN 100,
          TC_200 TYPE TABLEVIEW USING SCREEN 200,
          TC_400 TYPE TABLEVIEW USING SCREEN 400.
* bdc
DATA: BEGIN OF BDC_TAB OCCURS 50.
        INCLUDE STRUCTURE BDCDATA.
DATA: END OF BDC_TAB.

DATA : TCOUNT TYPE I,
       ECOUNT TYPE I.


DATA : BEGIN OF IT_KONP OCCURS 0,
       KOPOS LIKE KONP-KOPOS,
       KSCHL LIKE KONP-KSCHL,
       KBETR LIKE KONP-KBETR,
       KONWA LIKE KONP-KONWA,
       END OF IT_KONP .

DATA: MSGTAB TYPE TABLE OF BDCMSGCOLL WITH HEADER LINE.
DATA : W_MODE   TYPE C VALUE 'E',
       W_UPDATE TYPE C VALUE 'S'.
DATA: BEGIN OF IT_ER OCCURS  0,
      MATNR LIKE IT_400-MATNR,
      TEXT(480),
      END OF IT_ER.


CONSTANTS : C_WERKS LIKE MAST-WERKS VALUE 'P001',
            C_STLAN LIKE MAST-STLAN VALUE '1',
            C_KAPPL LIKE A018-KAPPL VALUE 'M',
            C_PB00  LIKE A018-KSCHL VALUE 'PB00',
            C_EKORG LIKE A018-EKORG VALUE 'PU01'.

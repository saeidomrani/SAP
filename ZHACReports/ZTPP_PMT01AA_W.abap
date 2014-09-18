*&-------------------------------------------------------------*
*& Report ZTPP_PMT01AA_W
*&-------------------------------------------------------------*
*System name         : HMI SYSTEM
*Sub system name     : ARCHIVE
*Program name        : Archiving : ZTPP_PMT01AA (Write)
*Program descrition  : Generated automatically by the ZHACR00800
*Created on   : 20130603          Created by   : T00302
*Changed on :                           Changed by    :
*Changed descrition :
*"-------------------------------------------------------------*
REPORT ZTPP_PMT01AA_W .

***** Include TOP
INCLUDE ZTPP_PMT01AA_T .

***** Selection screen.
SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-001.
*SELECT-OPTIONS S_DIST FOR ZTPP_PMT01AA-DIST.
*SELECT-OPTIONS S_EXTC FOR ZTPP_PMT01AA-EXTC.
*SELECT-OPTIONS S_INTC FOR ZTPP_PMT01AA-INTC.
*SELECT-OPTIONS S_MODL FOR ZTPP_PMT01AA-MODL.
*SELECT-OPTIONS S_MONT FOR ZTPP_PMT01AA-MONT.
*SELECT-OPTIONS S_PACK FOR ZTPP_PMT01AA-PACK.
*SELECT-OPTIONS S_REGN FOR ZTPP_PMT01AA-REGN.
*SELECT-OPTIONS S_SERL FOR ZTPP_PMT01AA-SERL.
*SELECT-OPTIONS S_USEE FOR ZTPP_PMT01AA-USEE.
SELECT-OPTIONS S_ANDAT FOR ZTPP_PMT01AA-ANDAT.
SELECTION-SCREEN SKIP 1.
PARAMETERS: TESTRUN               AS CHECKBOX,
            CREATE    DEFAULT  'X' AS CHECKBOX,
            OBJECT    LIKE         ARCH_IDX-OBJECT
                      DEFAULT 'ZTPP_PMT0A' NO-DISPLAY .
SELECTION-SCREEN SKIP 1.
PARAMETERS: COMMENT   LIKE ADMI_RUN-COMMENTS OBLIGATORY.
SELECTION-SCREEN END OF BLOCK B2.

***** Main login - common routine of include
PERFORM ARCHIVE_PROCESS.

***** Common routine
INCLUDE ZITARCW.

***** History for each object,
***** processing required for each part defined,
FORM OPEN_CURSOR_FOR_DB.
  OPEN CURSOR WITH HOLD G_CURSOR FOR
SELECT * FROM ZTPP_PMT01AA
*WHERE DIST IN S_DIST
*AND EXTC IN S_EXTC
*AND INTC IN S_INTC
*AND MODL IN S_MODL
*AND MONT IN S_MONT
*AND PACK IN S_PACK
*AND REGN IN S_REGN
*AND SERL IN S_SERL
*AND USEE IN S_USEE.
WHERE ANDAT IN S_ANDAT.
ENDFORM.
FORM MAKE_ARCHIVE_OBJECT_ID.



ENDFORM.

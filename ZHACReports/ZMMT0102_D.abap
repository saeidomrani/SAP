*&-------------------------------------------------------------*
*& Report ZMMT0102_D
*&-------------------------------------------------------------*
*System name         : HMI SYSTEM
*Sub system name     : ARCHIVE
*Program name        : Archiving : ZMMT0102 (Delete)
*Program descrition  : Generated automatically by the ZHACR00800
*Created on   : 20130603          Created by   : T00302
*Changed on :                           Changed by    :
*Changed descrition :
*"-------------------------------------------------------------*
REPORT ZMMT0102_D .

***** Include TOP
INCLUDE ZMMT0102_T .

***** Selection screen.
PARAMETERS: TESTRUN               AS CHECKBOX,
            OBJECT    LIKE         ARCH_IDX-OBJECT
                      DEFAULT 'ZMMT0102' NO-DISPLAY .

***** Main login - common routine of include
PERFORM DELETE_PROCESS.

***** common routine
INCLUDE ZITARCD.

***** History for each object,
***** processing required for each part defined,
FORM DELETE_FROM_TABLE.
  DELETE (ARC_TABLE) FROM TABLE T_ITAB.
  COMMIT WORK.
  CLEAR : T_ITAB, T_ITAB[].
ENDFORM.

FUNCTION ZPMF_PDA703 .
*"----------------------------------------------------------------------
*"*"Local interface:
*"  EXPORTING
*"     VALUE(SUBRC) LIKE  SY-SUBRC
*"  TABLES
*"      T703 STRUCTURE  ZSPM_PDA703
*"      T703R STRUCTURE  ZSPM_PDA703R
*"----------------------------------------------------------------------
  DATA : IT_MARD LIKE TABLE OF MARD WITH HEADER LINE.

*  RANGES : R_MAKTX FOR MAKT-MAKTX.

  READ TABLE T703 INDEX 1.

*  IF NOT T703-MAKTX IS INITIAL.
*    R_MAKTX-SIGN = 'I'.
*    R_MAKTX-OPTION = 'CP'.
*    R_MAKTX-LOW = T703-MAKTX.
*    APPEND R_MAKTX.
*  ENDIF.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE IT_MARD
         FROM MARD
        WHERE MATNR EQ T703-MATNR
        AND  WERKS EQ T703-WERKS
        AND   LGORT EQ T703-LGORT.
  LOOP AT IT_MARD.
    T703R-MATNR = IT_MARD-MATNR.
    T703R-LGPBE = IT_MARD-LGPBE.

    SELECT SINGLE MEINS INTO T703R-MEINS
           FROM MARA
          WHERE MATNR EQ IT_MARD-MATNR.

    SELECT SINGLE MAKTX INTO T703R-MAKTX
           FROM MAKT
          WHERE MATNR EQ IT_MARD-MATNR
          AND   SPRAS EQ 'E'.
*          AND   MAKTX IN R_MAKTX.

    CHECK SY-SUBRC = 0.

    PERFORM CONVERSION_EXIT_MATN1_OUTPUT USING T703R-MATNR T703R-MATNR.

    APPEND T703R. CLEAR T703R.
  ENDLOOP.

  DESCRIBE TABLE T703R LINES SY-INDEX.
  IF SY-INDEX = 0.
    SUBRC = 4.
  ELSE.
    SUBRC = 0.
  ENDIF.

  SORT T703R.
ENDFUNCTION.

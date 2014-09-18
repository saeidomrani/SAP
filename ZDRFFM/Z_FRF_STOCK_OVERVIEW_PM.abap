FUNCTION Z_FRF_STOCK_OVERVIEW_PM.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(P_MATNR) LIKE  MARA-MATNR
*"     VALUE(P_WERKS) LIKE  MARC-WERKS OPTIONAL
*"     VALUE(P_LGORT) LIKE  MARD-LGORT OPTIONAL
*"  TABLES
*"      T_ST STRUCTURE  ZSRF_STOCK_OVERVIEW
*"----------------------------------------------------------------------

  IF P_WERKS IS INITIAL AND P_LGORT IS INITIAL.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE T_ST
      FROM MARA AS H
      INNER JOIN MARD AS I
      ON H~MATNR EQ I~MATNR
      INNER JOIN MARC AS M
      ON I~MATNR = M~MATNR
      AND I~WERKS = M~WERKS
      INNER JOIN MAKT AS J
      ON H~MATNR EQ J~MATNR
      WHERE H~MATNR = P_MATNR.
  ENDIF.
  IF NOT P_WERKS IS INITIAL AND P_LGORT IS INITIAL.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE T_ST
    FROM MARA AS H INNER JOIN MARD AS I
    ON  H~MATNR EQ  I~MATNR
    INNER JOIN MARC AS M
    ON I~MATNR = M~MATNR
    AND I~WERKS = M~WERKS
    INNER JOIN MAKT AS J
    ON H~MATNR EQ J~MATNR
    WHERE H~MATNR = P_MATNR
      AND I~WERKS = P_WERKS.
  ENDIF.
  IF P_WERKS IS INITIAL AND NOT P_LGORT IS INITIAL.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE T_ST
    FROM MARA AS H INNER JOIN MARD AS I
    ON  H~MATNR EQ  I~MATNR
    INNER JOIN MARC AS M
    ON I~MATNR = M~MATNR
    AND I~WERKS = M~WERKS
    INNER JOIN MAKT AS J
    ON H~MATNR EQ J~MATNR
    WHERE H~MATNR = P_MATNR
    AND I~LGORT = P_LGORT.
  ENDIF.
  IF NOT P_WERKS IS INITIAL AND NOT P_LGORT IS INITIAL.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE T_ST
    FROM MARA AS H INNER JOIN MARD AS I
     ON  H~MATNR EQ  I~MATNR
     INNER JOIN MARC AS M
     ON I~MATNR = M~MATNR
     AND I~WERKS = M~WERKS
     INNER JOIN MAKT AS J
     ON H~MATNR EQ J~MATNR
     WHERE H~MATNR = P_MATNR
       AND I~WERKS = P_WERKS
       AND I~LGORT = P_LGORT.
  ENDIF.

ENDFUNCTION.

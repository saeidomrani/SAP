FUNCTION Z_FPM_EQUI_LIST_BY_FUNC.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(I_TPLNR) LIKE  IFLOT-TPLNR
*"  EXPORTING
*"     VALUE(RETURN) LIKE  BAPIRETURN STRUCTURE  BAPIRETURN
*"  TABLES
*"      T_EQUI_LIST STRUCTURE  ZSPM_EQUI_BY_FUNC OPTIONAL
*"  EXCEPTIONS
*"      INVALID_TPLNR
*"      NOT_FOUND_EQUI
*"----------------------------------------------------------------------
  DATA: LV_STATUS.

  CLEAR RETURN.
  IF I_TPLNR IS INITIAL.
    PERFORM ERROR_MESSAGE USING TEXT-M02 '' '' '' RETURN.
    EXIT.
  ENDIF.

  CLEAR RETURN.
  LV_STATUS = 'X'.
  PERFORM CHECK_STATUS_OF_TPLNR USING I_TPLNR CHANGING LV_STATUS.

  IF LV_STATUS EQ ' '.
    PERFORM ERROR_MESSAGE USING TEXT-M03 '' '' '' RETURN.
    EXIT.
  ENDIF.


  DATA : IT_EQUI_LIST_T LIKE IT_EQUI_LIST OCCURS 0
                                         WITH HEADER LINE.

  SELECT EQUNR EQKTX AS SHTXT
           INTO CORRESPONDING FIELDS OF TABLE IT_EQUI_LIST_T
                     FROM V_EQUI
                    WHERE TPLNR = I_TPLNR
                      AND DATAB <= SY-DATUM
                      AND DATBI = '99991231'.

  LOOP AT IT_EQUI_LIST_T.
    MOVE I_TPLNR TO IT_EQUI_LIST_T-TPLNR.
    MOVE-CORRESPONDING IT_EQUI_LIST_T TO IT_EQUI_LIST.
    COLLECT IT_EQUI_LIST.    CLEAR IT_EQUI_LIST.
  ENDLOOP.



  SORT IT_EQUI_LIST BY TPLNR EQUNR.

  T_EQUI_LIST[] = IT_EQUI_LIST[].





ENDFUNCTION.

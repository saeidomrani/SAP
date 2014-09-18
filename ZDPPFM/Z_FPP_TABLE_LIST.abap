FUNCTION Z_FPP_TABLE_LIST.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(TABLE_NAME)
*"     VALUE(ACTION) LIKE  SY-UCOMM DEFAULT 'ANZE'
*"     VALUE(WITHOUT_SUBMIT) DEFAULT SPACE
*"     VALUE(GENERATION_FORCED) OPTIONAL
*"     VALUE(NEW_SEL) OPTIONAL
*"     VALUE(NO_STRUCTURE_CHECK) DEFAULT SPACE
*"     VALUE(DATA_EXIT) LIKE  RS38L-NAME DEFAULT SPACE
*"  EXPORTING
*"     VALUE(PROGNAME) LIKE  RSNEWLENG-PROGRAMM
*"  TABLES
*"      SELTAB STRUCTURE  RSPARAMS OPTIONAL
*"  EXCEPTIONS
*"      TABLE_IS_STRUCTURE
*"      TABLE_NOT_EXISTS
*"      DB_NOT_EXISTS
*"      NO_PERMISSION
*"      NO_CHANGE_ALLOWED
*"----------------------------------------------------------------------


  DATA: EXIT.
  DATA: SUBRC LIKE SY-SUBRC.

  G_DATA_EXIT = DATA_EXIT.
  SUPPRESS_STRUCTURE_CHECK = NO_STRUCTURE_CHECK.
  DATABROWSE-TABLENAME = TABLE_NAME.
  IF DATABROWSE-TABLENAME IS INITIAL.
    CALL SCREEN 220 STARTING AT 10 5.
    IF OK_CODE ='CANC' OR DATABROWSE-TABLENAME IS INITIAL.
      EXIT.
    ENDIF.
  ENDIF.
* Datenbank-Existens pruefen
  PERFORM DATABASE_EXIST_CHECK USING ACTION
                               CHANGING EXIT.
  IF NOT EXIT IS INITIAL.
    EXIT.
  ENDIF.
* Hier kann man noch schneller werden...
* Sicherheitshalber noch mal, falls ?er Testumgebung aufgerufen
*  PERFORM AUTHORITY_CHECK_AGAIN USING ACTION.
* Und die View und SM31 noch mal
  CLEAR EXIT.
  PERFORM VIEW_MAINTENANCE_CALL USING ACTION CHANGING EXIT.
  IF NOT EXIT IS INITIAL.
    EXIT.
  ENDIF.
  IF GLOBAL_AUTH <> 'SHOW'.
    PERFORM SYS_PARAMS_CHECK.
    IF GLOBAL_AUTH = 'SHOW' AND ACTION = 'ANLE'.
      MESSAGE E421 RAISING NO_CHANGE_ALLOWED.
    ENDIF.
  ENDIF.
  PERFORM CHECK_GENERATE_REPORT USING ACTION
                                         NEW_SEL
                                         GENERATION_FORCED
                                CHANGING SUBRC
                                         PROGNAME.
  IF WITHOUT_SUBMIT IS INITIAL AND SUBRC = 0.
    PERFORM SUBMIT_REPORT TABLES SELTAB
                          USING ACTION
                                PROGNAME.
  ENDIF.




ENDFUNCTION.

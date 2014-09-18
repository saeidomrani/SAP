FUNCTION ZIINBDOC_WRITE_DOCUMENT       .

  CALL FUNCTION 'CHANGEDOCUMENT_OPEN'
    EXPORTING
      OBJECTCLASS             = 'ZIINBDOC       '
      OBJECTID                = OBJECTID
      PLANNED_CHANGE_NUMBER   = PLANNED_CHANGE_NUMBER
      PLANNED_OR_REAL_CHANGES = PLANNED_OR_REAL_CHANGES
    EXCEPTIONS
      SEQUENCE_INVALID        = 1
      OTHERS                  = 2.

  CASE SY-SUBRC.
    WHEN 0.                                   "ok.
    WHEN 1. MESSAGE A600 WITH 'SEQUENCE INVALID'.
    WHEN 2. MESSAGE A600 WITH 'OPEN ERROR'.
  ENDCASE.


IF UPD_ZTINSB                         NE SPACE.
   CALL FUNCTION 'CHANGEDOCUMENT_SINGLE_CASE'
     EXPORTING
       TABLENAME              = 'ZTINSB                        '
       WORKAREA_OLD           = O_ZTINSB
       WORKAREA_NEW           = N_ZTINSB
        CHANGE_INDICATOR       = UPD_ZTINSB
        DOCU_DELETE            = ' '
     EXCEPTIONS
       NAMETAB_ERROR          = 1
       OPEN_MISSING           = 2
       POSITION_INSERT_FAILED = 3
       OTHERS                 = 4.

    CASE SY-SUBRC.
      WHEN 0.                                "ok.
      WHEN 1. MESSAGE A600 WITH 'NAMETAB-ERROR'.
      WHEN 2. MESSAGE A600 WITH 'OPEN MISSING'.
      WHEN 3. MESSAGE A600 WITH 'INSERT ERROR'.
      WHEN 4. MESSAGE A600 WITH 'SINGLE ERROR'.
    ENDCASE.
  ENDIF.


IF UPD_ZTINSBRSP                      NE SPACE.
   CALL FUNCTION 'CHANGEDOCUMENT_SINGLE_CASE'
     EXPORTING
       TABLENAME              = 'ZTINSBRSP                     '
       WORKAREA_OLD           = O_ZTINSBRSP
       WORKAREA_NEW           = N_ZTINSBRSP
        CHANGE_INDICATOR       = UPD_ZTINSBRSP
        DOCU_DELETE            = ' '
     EXCEPTIONS
       NAMETAB_ERROR          = 1
       OPEN_MISSING           = 2
       POSITION_INSERT_FAILED = 3
       OTHERS                 = 4.

    CASE SY-SUBRC.
      WHEN 0.                                "ok.
      WHEN 1. MESSAGE A600 WITH 'NAMETAB-ERROR'.
      WHEN 2. MESSAGE A600 WITH 'OPEN MISSING'.
      WHEN 3. MESSAGE A600 WITH 'INSERT ERROR'.
      WHEN 4. MESSAGE A600 WITH 'SINGLE ERROR'.
    ENDCASE.
  ENDIF.


IF UPD_ZTINSBSG3                      NE SPACE.
   CALL FUNCTION 'CHANGEDOCUMENT_SINGLE_CASE'
     EXPORTING
       TABLENAME              = 'ZTINSBSG3                     '
       WORKAREA_OLD           = O_ZTINSBSG3
       WORKAREA_NEW           = N_ZTINSBSG3
        CHANGE_INDICATOR       = UPD_ZTINSBSG3
        DOCU_DELETE            = ' '
     EXCEPTIONS
       NAMETAB_ERROR          = 1
       OPEN_MISSING           = 2
       POSITION_INSERT_FAILED = 3
       OTHERS                 = 4.

    CASE SY-SUBRC.
      WHEN 0.                                "ok.
      WHEN 1. MESSAGE A600 WITH 'NAMETAB-ERROR'.
      WHEN 2. MESSAGE A600 WITH 'OPEN MISSING'.
      WHEN 3. MESSAGE A600 WITH 'INSERT ERROR'.
      WHEN 4. MESSAGE A600 WITH 'SINGLE ERROR'.
    ENDCASE.
  ENDIF.

  IF UPD_ICDTXT_ZIINBDOC        NE SPACE.
     CALL FUNCTION 'CHANGEDOCUMENT_TEXT_CASE'
       TABLES
         TEXTTABLE              = ICDTXT_ZIINBDOC
       EXCEPTIONS
         OPEN_MISSING           = 1
         POSITION_INSERT_FAILED = 2
         OTHERS                 = 3.

    CASE SY-SUBRC.
      WHEN 0.                                "ok.
      WHEN 1. MESSAGE A600 WITH 'OPEN MISSING'.
      WHEN 2. MESSAGE A600 WITH 'INSERT ERROR'.
      WHEN 3. MESSAGE A600 WITH 'TEXT ERROR'.
    ENDCASE.
  ENDIF.

  CALL FUNCTION 'CHANGEDOCUMENT_CLOSE'
    EXPORTING
      OBJECTCLASS             = 'ZIINBDOC       '
      OBJECTID                = OBJECTID
      DATE_OF_CHANGE          = UDATE
      TIME_OF_CHANGE          = UTIME
      TCODE                   = TCODE
      USERNAME                = USERNAME
      OBJECT_CHANGE_INDICATOR = OBJECT_CHANGE_INDICATOR
      NO_CHANGE_POINTERS      = NO_CHANGE_POINTERS
    EXCEPTIONS
      HEADER_INSERT_FAILED    = 1
      OBJECT_INVALID          = 2
      OPEN_MISSING            = 3
      NO_POSITION_INSERTED    = 4
      OTHERS                  = 5.

  CASE SY-SUBRC.
    WHEN 0.                                   "ok.
    WHEN 1. MESSAGE A600 WITH 'INSERT HEADER FAILED'.
    WHEN 2. MESSAGE A600 WITH 'OBJECT INVALID'.
    WHEN 3. MESSAGE A600 WITH 'OPEN MISSING'.
*    WHEN 4. MESSAGE A600 WITH 'NO_POSITION_INSERTED'.
* do not abort, if positions are not inserted!!!
    WHEN 5. MESSAGE A600 WITH 'CLOSE ERROR'.
  ENDCASE.

ENDFUNCTION.

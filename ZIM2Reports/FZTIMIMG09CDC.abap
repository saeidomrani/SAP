FORM CD_CALL_ZTIMIMG09                     .
   IF   ( UPD_ZTIMIMG09                      NE SPACE )
     OR ( UPD_ICDTXT_ZTIMIMG09       NE SPACE )
   .
     CALL FUNCTION 'SWE_REQUESTER_TO_UPDATE'.
     CALL FUNCTION 'ZTIMIMG09_WRITE_DOCUMENT      ' IN UPDATE TASK
        EXPORTING OBJECTID              = OBJECTID
                  TCODE                 = TCODE
                  UTIME                 = UTIME
                  UDATE                 = UDATE
                  USERNAME              = USERNAME
                  PLANNED_CHANGE_NUMBER = PLANNED_CHANGE_NUMBER
                  OBJECT_CHANGE_INDICATOR = CDOC_UPD_OBJECT
                  PLANNED_OR_REAL_CHANGES = CDOC_PLANNED_OR_REAL
                  NO_CHANGE_POINTERS = CDOC_NO_CHANGE_POINTERS
                  O_ZTIMIMG09
                      = *ZTIMIMG09
                  N_ZTIMIMG09
                      = ZTIMIMG09
                  UPD_ZTIMIMG09
                      = UPD_ZTIMIMG09
                  UPD_ICDTXT_ZTIMIMG09
                      = UPD_ICDTXT_ZTIMIMG09
          TABLES  ICDTXT_ZTIMIMG09
                      = ICDTXT_ZTIMIMG09
     .
   ENDIF.
   CLEAR PLANNED_CHANGE_NUMBER.
ENDFORM.

FORM CD_CALL_ZILOADOC                      .
  IF   ( UPD_ZTLLCAMHD                      NE SPACE )
    OR ( UPD_ZTREQHD                        NE SPACE )
    OR ( UPD_ZTREQST                        NE SPACE )
    OR ( UPD_ICDTXT_ZILOADOC        NE SPACE )
  .
    CALL FUNCTION 'SWE_REQUESTER_TO_UPDATE'.
    CALL FUNCTION 'ZILOADOC_WRITE_DOCUMENT       ' IN UPDATE TASK
        EXPORTING
          OBJECTID                = OBJECTID
          TCODE                   = TCODE
          UTIME                   = UTIME
          UDATE                   = UDATE
          USERNAME                = USERNAME
          PLANNED_CHANGE_NUMBER   = PLANNED_CHANGE_NUMBER
          OBJECT_CHANGE_INDICATOR = CDOC_UPD_OBJECT
          PLANNED_OR_REAL_CHANGES = CDOC_PLANNED_OR_REAL
          NO_CHANGE_POINTERS      = CDOC_NO_CHANGE_POINTERS
          O_ZTLLCAMHD
                      = *ZTLLCAMHD
          N_ZTLLCAMHD
                      = ZTLLCAMHD
          UPD_ZTLLCAMHD
                      = UPD_ZTLLCAMHD
          O_ZTREQHD
                      = *ZTREQHD
          N_ZTREQHD
                      = ZTREQHD
          UPD_ZTREQHD
                      = UPD_ZTREQHD
          O_ZTREQST
                      = *ZTREQST
          N_ZTREQST
                      = ZTREQST
          UPD_ZTREQST
                      = UPD_ZTREQST
          UPD_ICDTXT_ZILOADOC
                      = UPD_ICDTXT_ZILOADOC
        TABLES
          ICDTXT_ZILOADOC
                      = ICDTXT_ZILOADOC
    .
  ENDIF.
  CLEAR PLANNED_CHANGE_NUMBER.
ENDFORM.

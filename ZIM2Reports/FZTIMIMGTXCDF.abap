DATA: OBJECTID              LIKE CDHDR-OBJECTID,
      TCODE                 LIKE CDHDR-TCODE,
      PLANNED_CHANGE_NUMBER LIKE CDHDR-PLANCHNGNR,
      UTIME                 LIKE CDHDR-UTIME,
      UDATE                 LIKE CDHDR-UDATE,
      USERNAME              LIKE CDHDR-USERNAME,
      CDOC_PLANNED_OR_REAL  LIKE CDHDR-CHANGE_IND,
      CDOC_UPD_OBJECT       LIKE CDHDR-CHANGE_IND VALUE 'U',
      CDOC_NO_CHANGE_POINTERS LIKE CDHDR-CHANGE_IND.


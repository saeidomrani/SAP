*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZGPP_MODEL_CONV
*   generation date: 02/18/2010 at 15:15:27 by user 101457
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZGPP_MODEL_CONV    .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.

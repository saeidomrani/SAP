*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZGPP_BDP
*   generation date: 12/23/2009 at 12:56:06 by user 101457
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZGPP_BDP           .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.


*----------------------------------------------------------------------*
*   INCLUDE Z_APP_DELETE_PARA_R252718
*
*----------------------------------------------------------------------
*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(33) text-002 FOR FIELD r_sp.
PARAMETER r_sp RADIOBUTTON GROUP r_gr .
SELECTION-SCREEN COMMENT 40(30) text-003 FOR FIELD r_si.
PARAMETER r_si RADIOBUTTON GROUP r_gr DEFAULT 'X'.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-004.

PARAMETERS: p_rtime TYPE ppc_res_time DEFAULT '30',
            p_25time TYPE  PPC_RES_TIME DEFAULT '7',
            p_plant LIKE marc-werks DEFAULT 'P001'.

SELECT-OPTIONS : s_plnum FOR plaf-plnum NO INTERVALS
                 NO-EXTENSION.

PARAMETERS: p_d TYPE c.

PARAMETERS: p_e TYPE c. "Check RESB


SELECTION-SCREEN END OF BLOCK b2.

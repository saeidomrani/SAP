FUNCTION Z_FSD_MAIL_ADDR.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     REFERENCE(KUNNR) TYPE  C
*"  TABLES
*"      MAIL_ADDR STRUCTURE  ZSSD_MAIL_ADDR OPTIONAL
*"  EXCEPTIONS
*"      NOT_FOUND_KNA1
*"      NOT_FOUND_KNVK
*"----------------------------------------------------------------------

SELECT SINGLE * FROM KNA1 WHERE KUNNR = KUNNR.
IF SY-SUBRC <> 0.
  RAISE NOT_FOUND_KNA1.
ENDIF.

SELECT * FROM KNVK WHERE KUNNR = KUNNR.
  MAIL_ADDR-NAMEV = KNVK-NAMEV.
  MAIL_ADDR-NAME1 = KNVK-NAME1.

  SELECT SINGLE * FROM ADR6 WHERE ADDRNUMBER = KNA1-ADRNR
                            AND   PERSNUMBER = KNVK-PRSNR.
  IF SY-SUBRC = 0.
    MAIL_ADDR-SMTP_ADDR = ADR6-SMTP_ADDR.
  ENDIF.

  APPEND MAIL_ADDR. CLEAR MAIL_ADDR.
ENDSELECT.
IF SY-SUBRC <> 0.
  RAISE NOT_FOUND_KNVK.
ENDIF.

ENDFUNCTION.

*----------------------------------------------------------------------*
***INCLUDE YAPP250M_PAI .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE  sy-ucomm.
    WHEN 'BACK' OR 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN  OTHERS.
      PERFORM  status_data_create.
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_0100  INPUT

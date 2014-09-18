*&---------------------------------------------------------------------*
*& Report  ZGHRR00100
*&
*&---------------------------------------------------------------------*

INCLUDE zghrr00100top                           .    " global Data
INCLUDE zghrr00100o01                           .  " PBO-Modules
INCLUDE zghrr00100i01                           .  " PAI-Modules
INCLUDE zghrr00100f01                           .  " FORM-Routines


*&---------------------------------------------------------------------
* # INITIALIZATION: SELECTION-SCREEN
*&---------------------------------------------------------------------*
INITIALIZATION.
  PERFORM set_initial_value.
*&----------------------------------------------------------------------
*  AT SELECTION-SCREEN OUTPUT : SELECTION-SCREEN PBO  ,
*&----------------------------------------------------------------------
AT SELECTION-SCREEN OUTPUT.

*&----------------------------------------------------------------------
*  AT SELECTION-SCREEN : SELECTION-SCREEN
*&----------------------------------------------------------------------
AT SELECTION-SCREEN.

*&---------------------------------------------------------------------*
*  START-OF-SELECTION:
*              .
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM get_data.
*&---------------------------------------------------------------------*
*  END-OF-SELECTION:
*               .
*&---------------------------------------------------------------------*
END-OF-SELECTION.
  CALL SCREEN 100.
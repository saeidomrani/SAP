*&---------------------------------------------------------------------*
*& Module pool       SAPMZIM08                                         *
*&---------------------------------------------------------------------*
*&  ���α׷��� : �ⳳ��   Main Module Pool Program                     *
*&      �ۼ��� : ������ INFOLINK Ltd.                                  *
*&      �ۼ��� : 2001.08.25                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
PROGRAM  SAPMZIM08     MESSAGE-ID    ZIM
                       NO STANDARD PAGE HEADING.

*-----------------------------------------------------------------------
* Data Define Include
*-----------------------------------------------------------------------
INCLUDE <ICON>.
INCLUDE ZRIM00TOP.    " ���� System Main Data Define Include
INCLUDE ZRIM08TOP.    "
INCLUDE ZRIM00T01.    " �����Ƿ� Scrren �� ��� Define
INCLUDE ZRIMBDCCOM.   " �����Ƿ� BDC ���� Include

*-----------------------------------------------------------------------
* PBO Module
*-----------------------------------------------------------------------
INCLUDE ZRIM08O01.     " �ⳳ�� Main PBO MODULE Include

*-----------------------------------------------------------------------
* PAI MODULE
*-----------------------------------------------------------------------
INCLUDE ZRIM08I01.    " �ⳳ�� Main PAI MODULE Include

*-----------------------------------------------------------------------
* SUB MODULE
*-----------------------------------------------------------------------
INCLUDE ZRIM08F01.    " �ⳳ�� Main Sub MODULE Include

*-----------------------------------------------------------------------
* EVENT MODULE
*-----------------------------------------------------------------------
INCLUDE ZRIM08E01.    " �ⳳ�� POPUP�� Event Include

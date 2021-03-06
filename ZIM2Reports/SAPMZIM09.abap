*&---------------------------------------------------------------------*
*& Module  SAPMZIM09                                                   *
*&----------------------------------------------------------------------
*&  프로그램명 : 보세창고 출고 관련 Module Pool Program
*&      작성자 : 이채경  INFOLINK Ltd.
*&      작성일 : 2001.08.20
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
PROGRAM  SAPMZIM09     MESSAGE-ID    ZIM
                       NO STANDARD PAGE HEADING.

INCLUDE <ICON>.
*-----------------------------------------------------------------------
* BDC용 서브루팀 및 데이타 선언부.
*-----------------------------------------------------------------------
INCLUDE ZRIMBDCCOM.  " BDC 공통 INCLUDE

*-----------------------------------------------------------------------
* DATA DEFINE
*-----------------------------------------------------------------------
INCLUDE ZRIM00TOP.    " 수입 System Main Data Define Include
INCLUDE ZRIM01T09.    " 보세창고 출고 관련 Scrren 및 상수 Define


*-----------------------------------------------------------------------
* PBO Module
*-----------------------------------------------------------------------
INCLUDE ZRIM09O01.     " 보세창고 출고 관련 PBO MODULE Include

*-----------------------------------------------------------------------
* PAI MODULE
*-----------------------------------------------------------------------
INCLUDE ZRIM09I01.    " 보세창고 출고 관련 PAI MODULE Include

*-----------------------------------------------------------------------
* SUB MODULE
*-----------------------------------------------------------------------
INCLUDE ZRIM09F01.    " 보세창고 출고 관련 Sub MODULE Include

*-----------------------------------------------------------------------
* EVENT MODULE
*-----------------------------------------------------------------------
INCLUDE ZRIM09E01.    " 보세창고 출고 관련 Event Include

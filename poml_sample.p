/************************************************************************************************************
 **                                              
 ** POML is not Markup Language.                         
 ** POML is (POG, ops!) Progress 4gl Markup Language !!!
 **
 ** It's a simple Markup Language converter to Progress 4gl Table inspired by YAML
 **
 **   Arthor: Romulo (romuloccomp@gmail.com)
 **     Date: Ago/2013
 **   
 **  Version: 0.1 beta
 **
 **     File: poml_sample.p
 **     Desc: Sample programm 
 **
 ************************************************************************************************************/
 
{poml.i}

DEF TEMP-TABLE tt_person NO-UNDO
    FIELD id_number            AS INT
    FIELD full_name     AS CHAR
    FIELD birth_date    AS DATE.


RUN pCreateAlias('person'            , 'tt_person' , 'table').
RUN pCreateAlias('ID Number'         , 'id_number' , 'field').
RUN pCreateAlias('Full Name'         , 'full_name' , 'field').
RUN pCreateAlias('Date of birthday'  , 'birth_date', 'field').


RUN pImportFile("poml_sample_file.txt").

RUN pCreateTable (INPUT BUFFER tt_person:HANDLE).

FOR EACH tt_person NO-LOCK:
    DISP tt_person WITH WIDTH 320 1 COL.
END.


RUN pResetTempDates.

POML
=========

POML is not Markup Language.                         
POML is (POG, ops!) Progress 4gl Markup Language !!!
It's a simple Markup Language converter to Progress 4gl Table inspired by YAML

  Arthor: Romulo (romuloccomp@gmail.com)
    Date: Ago/2013
  
 Version: 0.1 beta
    File: poml_sample.p
    Desc: Sample programm 


Getting started
---------------

Create a poml text file:

    # comments
    # you can comment your poml file :)
    
    tt_person
      id_number:  1
      full_name: John Jobs
      birth_date: 01/04/1990

Create a progress programm with poml include and a relative table:

    {poml.i}

    DEF TEMP-TABLE tt_person NO-UNDO
      FIELD id_number            AS INT
      FIELD full_name     AS CHAR
      FIELD birth_date    AS DATE.

Now let's import and create table data the poml text file:
    
    RUN pImportFile("<YOUR_PATH>\poml_sample_file.txt").

    RUN pCreateTable (INPUT BUFFER tt_person:HANDLE).

So, you can see your data like this:

    FOR EACH tt_person NO-LOCK:
        DISP tt_person WITH WIDTH 320 1 COL.
    END.


Improve you POML text file
--------------------------

You can improve your text file with alias.

    RUN pCreateAlias('person'            , 'tt_person' , 'table').
    RUN pCreateAlias('ID Number'         , 'id_number' , 'field').
    RUN pCreateAlias('Full Name'         , 'full_name' , 'field').
    RUN pCreateAlias('Date of birthday'  , 'birth_date', 'field').

Then, change your file:

    # Poml more friendly file 
    
    person
     ID Number: 2
     Full Name: Peter Bruce
     Date of birthday: 07/04/1980

Import and create create table data the same way

    RUN pImportFile("<YOUR_PATH>\poml_sample_file.txt").

    RUN pCreateTable (INPUT BUFFER tt_person:HANDLE).

Full Sample
-----------

Poml file:
  
    # comments
    # you can comment your poml file :)
    tt_person
     id_number:  1
     full_name: John Jobs
     birth_date: 01/04/1990
    person
     ID Number: 2
     Full Name: Peter Bruce
     Date of birthday: 07/04/1980
    tt_person
     id_number:  3
     full_name: Woz Wanne
     birth_date: 01/01/1975

Progress program

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


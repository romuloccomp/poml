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
 **     File: poml.i
 **     Desc: Main include
 **
 ************************************************************************************************************/
 
&SCOPED-DEFINE COMMENT    '#'

DEF TEMP-TABLE tt_alias NO-UNDO
    FIELD poml_name		AS CHAR
	FIELD real_name		AS CHAR
	FIELD alias_type	AS CHAR
	INDEX ipname IS PRIMARY poml_name.

DEF TEMP-TABLE tt_poml NO-UNDO
    FIELD line_number    AS INT
    FIELD line_value     AS CHAR FORMAT "x(40)" 
    INDEX iline IS PRIMARY line_number.
	
PROCEDURE pResetTempDates:

    EMPTY TEMP-TABLE tt_alias.
    EMPTY TEMP-TABLE tt_poml.

END.

PROCEDURE pCreateTable:

    DEF INPUT PARAM p-buffer  AS HANDLE NO-UNDO.

    DEF VAR node_name  AS CHAR  NO-UNDO.
    DEF VAR node_value AS CHAR  NO-UNDO.

    FOR EACH tt_poml BY tt_poml.line_number:
    
        node_name  = TRIM(ENTRY(1,tt_poml.line_value,':')) NO-ERROR.
        node_value = TRIM(ENTRY(2,tt_poml.line_value,':')) NO-ERROR.
    
        FIND FIRST tt_alias 
            WHERE tt_alias.poml_name = node_name NO-LOCK NO-ERROR.

        IF AVAIL tt_alias THEN DO:
            IF  tt_alias.alias_type = 'table' THEN
                p-buffer:BUFFER-CREATE().
            ELSE
                IF p-buffer:BUFFER-FIELD(tt_alias.real_name):DATA-TYPE = "date" THEN
                    ASSIGN p-buffer:BUFFER-FIELD(tt_alias.real_name):BUFFER-VALUE = DATE(node_value) NO-ERROR.
                ELSE
                    ASSIGN p-buffer:BUFFER-FIELD(tt_alias.real_name):BUFFER-VALUE = node_value NO-ERROR.
        END.
        ELSE DO:

            IF  p-buffer:NAME = node_name THEN
                p-buffer:BUFFER-CREATE().
            ELSE
                IF p-buffer:BUFFER-FIELD(node_name):DATA-TYPE = "date" THEN
                    p-buffer:BUFFER-FIELD(node_name):BUFFER-VALUE = DATE(node_value) NO-ERROR.   
                ELSE
                    p-buffer:BUFFER-FIELD(node_name):BUFFER-VALUE = node_value NO-ERROR.
            
        END.
    
    END.

END PROCEDURE.


PROCEDURE pCreateAlias:

	DEF INPUT PARAM p_poml_name	  LIKE tt_alias.poml_name  .
    DEF INPUT PARAM p_real_name	  LIKE tt_alias.real_name  .
	DEF INPUT PARAM p_alias_type  LIKE tt_alias.alias_type .
	
	CREATE tt_alias.
	ASSIGN
		tt_alias.poml_name  = p_poml_name	 
		tt_alias.real_name  = p_real_name	 
		tt_alias.alias_type = p_alias_type .
	
END PROCEDURE.

PROCEDURE pImportFile:
    DEF INPUT PARAM pFile AS CHAR  NO-UNDO. 

    DEF VAR cLine AS CHAR  NO-UNDO.
    DEF VAR i     AS INT   NO-UNDO.

    INPUT FROM VALUE(pFile) .
    REPEAT:
        IMPORT UNFORMATTED cLine .
        IF NOT cLine BEGINS {&COMMENT} THEN DO:
            CREATE tt_poml.
            ASSIGN
                i             		= i + 1
                tt_poml.line_number	= i 
                tt_poml.line_value  = cLine.
        END.
    END.
    INPUT CLOSE . 

END PROCEDURE.



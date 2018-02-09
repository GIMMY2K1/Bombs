$PBExportHeader$bombs.sra
$PBExportComments$Generated Application Object
forward
global type bombs from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
string	regbase='HKEY_CURRENT_USER\Software\BradjaSoft\Bombs'

end variables

global type bombs from application
string appname = "bombs"
end type
global bombs bombs

on bombs.create
appname="bombs"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on bombs.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;open(w_bombs)
end event


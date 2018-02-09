$PBExportHeader$w_customgame.srw
forward
global type w_customgame from window
end type
type em_3 from editmask within w_customgame
end type
type em_2 from editmask within w_customgame
end type
type em_1 from editmask within w_customgame
end type
type st_3 from statictext within w_customgame
end type
type st_2 from statictext within w_customgame
end type
type st_1 from statictext within w_customgame
end type
type cb_2 from commandbutton within w_customgame
end type
type cb_1 from commandbutton within w_customgame
end type
type gb_1 from groupbox within w_customgame
end type
end forward

global type w_customgame from window
integer width = 1157
integer height = 580
boolean titlebar = true
string title = "Custom Game"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "DosEdit5!"
em_3 em_3
em_2 em_2
em_1 em_1
st_3 st_3
st_2 st_2
st_1 st_1
cb_2 cb_2
cb_1 cb_1
gb_1 gb_1
end type
global w_customgame w_customgame

type variables

end variables

on w_customgame.create
this.em_3=create em_3
this.em_2=create em_2
this.em_1=create em_1
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_1=create gb_1
this.Control[]={this.em_3,&
this.em_2,&
this.em_1,&
this.st_3,&
this.st_2,&
this.st_1,&
this.cb_2,&
this.cb_1,&
this.gb_1}
end on

on w_customgame.destroy
destroy(this.em_3)
destroy(this.em_2)
destroy(this.em_1)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event open;string	temp

f_center_window(this)
temp=Message.StringParm
if isnull(temp) or temp='' then return

em_1.text=mid(temp,1,pos(temp,'%') -1)
temp     =mid(temp,pos(temp,'%') +1)
em_2.text=mid(temp,1,pos(temp,'%') -1)
temp     =mid(temp,pos(temp,'%') +1)
em_3.text=mid(temp,1,pos(temp,'%') -1)

end event

type em_3 from editmask within w_customgame
integer x = 805
integer y = 232
integer width = 302
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "10"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
boolean spin = true
string minmax = "9~~"
end type

event getfocus;this.SelectText(1,5)
end event

type em_2 from editmask within w_customgame
integer x = 805
integer y = 140
integer width = 302
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "9"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
boolean spin = true
string minmax = "9~~"
end type

event getfocus;this.SelectText(1,5)
end event

type em_1 from editmask within w_customgame
integer x = 805
integer y = 48
integer width = 302
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "9"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
boolean spin = true
string minmax = "9~~"
end type

event getfocus;this.SelectText(1,5)
end event

type st_3 from statictext within w_customgame
integer x = 46
integer y = 244
integer width = 402
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Bombs"
boolean focusrectangle = false
end type

type st_2 from statictext within w_customgame
integer x = 46
integer y = 152
integer width = 402
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rows"
boolean focusrectangle = false
end type

type st_1 from statictext within w_customgame
integer x = 46
integer y = 60
integer width = 402
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cells"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_customgame
integer x = 713
integer y = 376
integer width = 393
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;closewithreturn(parent,'cancel')
end event

type cb_1 from commandbutton within w_customgame
integer x = 311
integer y = 376
integer width = 393
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
end type

event clicked;string	temp

if long(em_1.text)*long(em_2.text)<=long(em_3.text) then
	Messagebox('Bombs',em_3.text+' bombs cannot fit on a '+em_1.text+'x'+em_2.text+' grid!',StopSign!)
	return
end if
temp=em_1.text+'%'+em_2.text+'%'+em_3.text+'%'
RegistrySet(regbase,'CustomGame',RegString!,temp)
closewithreturn(parent,temp)
end event

type gb_1 from groupbox within w_customgame
integer x = 37
integer y = 324
integer width = 1070
integer height = 36
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type


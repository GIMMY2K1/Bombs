$PBExportHeader$w_entername.srw
forward
global type w_entername from window
end type
type cb_1 from commandbutton within w_entername
end type
type sle_1 from singlelineedit within w_entername
end type
type st_2 from statictext within w_entername
end type
type st_1 from statictext within w_entername
end type
end forward

global type w_entername from window
integer width = 1221
integer height = 260
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
cb_1 cb_1
sle_1 sle_1
st_2 st_2
st_1 st_1
end type
global w_entername w_entername

type variables
boolean	canclose=FALSE
end variables

event open;f_center_window(this)
sle_1.Selecttext(1,len(sle_1.Text))
sle_1.post SetFocus()
end event

on w_entername.create
this.cb_1=create cb_1
this.sle_1=create sle_1
this.st_2=create st_2
this.st_1=create st_1
this.Control[]={this.cb_1,&
this.sle_1,&
this.st_2,&
this.st_1}
end on

on w_entername.destroy
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.st_2)
destroy(this.st_1)
end on

event closequery;if not canclose then return 1
end event

type cb_1 from commandbutton within w_entername
integer x = 823
integer y = 148
integer width = 357
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;canclose=TRUE
closewithreturn(parent,sle_1.text)
end event

type sle_1 from singlelineedit within w_entername
integer x = 23
integer y = 148
integer width = 773
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Anonymous"
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_entername
integer x = 27
integer y = 76
integer width = 1161
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enter your name for the Hall Of Fame..."
boolean focusrectangle = false
end type

type st_1 from statictext within w_entername
integer x = 27
integer y = 8
integer width = 1161
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Your time is one of the best times I have ever seen!"
boolean focusrectangle = false
end type


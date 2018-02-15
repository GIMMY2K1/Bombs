$PBExportHeader$w_about.srw
forward
global type w_about from window
end type
type p_1 from picture within w_about
end type
type st_3 from statictext within w_about
end type
type st_2 from statictext within w_about
end type
type st_1 from statictext within w_about
end type
type cb_2 from commandbutton within w_about
end type
type gb_1 from groupbox within w_about
end type
end forward

global type w_about from window
integer width = 1125
integer height = 408
windowtype windowtype = response!
long backcolor = 255
string icon = "DosEdit5!"
p_1 p_1
st_3 st_3
st_2 st_2
st_1 st_1
cb_2 cb_2
gb_1 gb_1
end type
global w_about w_about

type variables
integer	dummy  =SetProfileString("build.ini","appinfo","BuildNo",&
                 string(ProfileInt("build.ini","appinfo","BuildNo",1) +1))

integer	buildnum =ProfileInt("build.ini","appinfo","BuildNo",1)

end variables

on w_about.create
this.p_1=create p_1
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_2=create cb_2
this.gb_1=create gb_1
this.Control[]={this.p_1,&
this.st_3,&
this.st_2,&
this.st_1,&
this.cb_2,&
this.gb_1}
end on

on w_about.destroy
destroy(this.p_1)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.gb_1)
end on

event open;f_center_window(this)

end event

type p_1 from picture within w_about
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "D:\Programming\PowerBuilder Projects\Games\Bombs\bombs.bmp"
boolean focusrectangle = false
boolean map3dcolors = true
end type

type st_3 from statictext within w_about
integer x = 489
integer y = 184
integer width = 581
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Version 1.0 Build 001"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;this.Text='Version 1.0 Build '+string(buildnum,'000')
end event

type st_2 from statictext within w_about
integer x = 613
integer y = 124
integer width = 457
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "by Giorgio Bradja"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_about
integer x = 192
integer y = 28
integer width = 878
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 15780518
string text = "BOMBS"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_about
integer x = 238
integer y = 300
integer width = 512
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
boolean cancel = true
end type

event clicked;closewithreturn(parent,'cancel')
end event

type gb_1 from groupbox within w_about
integer x = 9
integer y = 236
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


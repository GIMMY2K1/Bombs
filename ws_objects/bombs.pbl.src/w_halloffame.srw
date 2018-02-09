$PBExportHeader$w_halloffame.srw
forward
global type w_halloffame from window
end type
type tab_1 from tab within w_halloffame
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tab_1 from tab within w_halloffame
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type cb_2 from commandbutton within w_halloffame
end type
type cb_1 from commandbutton within w_halloffame
end type
end forward

global type w_halloffame from window
integer width = 1518
integer height = 1020
boolean titlebar = true
string title = "Hall Of Fame"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
tab_1 tab_1
cb_2 cb_2
cb_1 cb_1
end type
global w_halloffame w_halloffame

on w_halloffame.create
this.tab_1=create tab_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.tab_1,&
this.cb_2,&
this.cb_1}
end on

on w_halloffame.destroy
destroy(this.tab_1)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;datawindow	adw
string		scores[],dum[]
string		temp
long			i,atype,arow
time			atime,maxtime

f_center_window(this)

//Make sure there are HOF registry entries
scores=dum
RegistryGet(regbase+'\HOF','Easy',RegMultiString!,scores)
if UpperBound(scores)=0 then
	for i=1 to 10
		scores[i]=string(i)+'~t'+'Anonymous'+'~t'+'00:00:00'
	next
	RegistrySet(regbase+'\HOF','Easy',RegMultiString!,scores)
end if

scores=dum
RegistryGet(regbase+'\HOF','Normal',RegMultiString!,scores)
if UpperBound(scores)=0 then
	for i=1 to 10
		scores[i]=string(i)+'~t'+'Anonymous'+'~t'+'00:00:00'
	next
	RegistrySet(regbase+'\HOF','Normal',RegMultiString!,scores)
end if

scores=dum
RegistryGet(regbase+'\HOF','Extreme',RegMultiString!,scores)
if UpperBound(scores)=0 then
	for i=1 to 10
		scores[i]=string(i)+'~t'+'Anonymous'+'~t'+'00:00:00'
	next
	RegistrySet(regbase+'\HOF','Extreme',RegMultiString!,scores)
end if

//Load HOF entries
RegistryGet(regbase+'\HOF','Easy',RegMultiString!,scores)
for i=1 to Upperbound(scores)
	adw=tab_1.tabpage_1.dw_1
	adw.ImportString(scores[i])
next
for i=Upperbound(scores) to 10
	adw=tab_1.tabpage_1.dw_1
	adw.ImportString(string(i)+'~t'+'Anonymous'+'~t'+'00:00:00')
next

RegistryGet(regbase+'\HOF','Normal',RegMultiString!,scores)
for i=1 to Upperbound(scores)
	adw=tab_1.tabpage_2.dw_2
	adw.ImportString(scores[i])
next
for i=Upperbound(scores) to 10
	adw=tab_1.tabpage_2.dw_2
	adw.ImportString(string(i)+'~t'+'Anonymous'+'~t'+'00:00:00')
next

RegistryGet(regbase+'\HOF','Extreme',RegMultiString!,scores)
for i=1 to Upperbound(scores)
	adw=tab_1.tabpage_3.dw_3
	adw.ImportString(scores[i])
next
for i=Upperbound(scores) to 10
	adw=tab_1.tabpage_3.dw_3
	adw.ImportString(string(i)+'~t'+'Anonymous'+'~t'+'00:00:00')
next

//Check if somebody must be entered in HOF
temp=Message.StringParm
if isnull(temp) or temp='' then return

atime  =time(mid(temp,1,pos(temp,'^') -1))
atype  =long(mid(temp,pos(temp,'^') +1))

choose case atype
	case 1 
		adw=tab_1.tabpage_1.dw_1
	case 2 
		adw=tab_1.tabpage_2.dw_2
	case 3 
		adw=tab_1.tabpage_3.dw_3
end choose
tab_1.Selecttab(atype)

arow=adw.Find('#3>=time("'+string(atime,'hh:mm:ss')+'")',1,adw.RowCount())
if arow>=0 and arow<10 then
	//Insert man in HOF list
	if arow=0 then
		maxtime=adw.GetItemTime(1,'comp_maxtime')
		if atime>maxtime and maxtime>00:00:00 then
			MessageBox('Bombs','You win!')
			close(this)
			return
		else
			arow=1
		end if
	end if
	open(w_entername)
	temp=Message.StringParm
	arow=adw.InsertRow(arow)
	
	adw.SetItem(arow,1,arow)
	adw.SetItem(arow,2,temp)
	adw.SetItem(arow,3,atime)
	
	for i=arow +1 to 10
		adw.SetItem(i,1,i)
	next
	do while adw.RowCount()>10
		adw.DeleteRow(adw.RowCount())
	loop
else
	MessageBox('Bombs','You win!')
	close(this)
	return
end if

end event

event close;datawindow	adw[]
string		scores[],key[]
long			i,j


//Save HOF entries
adw[1]=tab_1.tabpage_1.dw_1
adw[2]=tab_1.tabpage_2.dw_2
adw[3]=tab_1.tabpage_3.dw_3
key[1]='Easy'
key[2]='Normal'
key[3]='Extreme'

for j=1 to 3
	for i=1 to 10
		if i<=adw[j].RowCount() then
			scores[i]=string(adw[j].GetItemNumber(i,1))+'~t'+adw[j].GetItemString(i,2)+'~t'+string(adw[j].GetItemTime(i,3),'hh:mm:ss')
		else
			scores[i]=string(i)+'~t'+'Anonymous'+'~t'+'00:00:00'
		end if
	next
	RegistrySet(regbase+'\HOF',key[j],RegMultiString!,scores)
next



end event

type tab_1 from tab within w_halloffame
integer x = 5
integer y = 8
integer width = 1481
integer height = 820
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean raggedright = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1445
integer height = 704
long backcolor = 67108864
string text = "Easy"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within tabpage_1
integer width = 1454
integer height = 692
integer taborder = 20
string title = "none"
string dataobject = "d_halloffame"
boolean border = false
boolean livescroll = true
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1445
integer height = 704
long backcolor = 67108864
string text = "Normal"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
integer width = 1445
integer height = 704
integer taborder = 20
string title = "none"
string dataobject = "d_halloffame"
boolean border = false
boolean livescroll = true
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 1445
integer height = 704
long backcolor = 67108864
string text = "Extreme"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from datawindow within tabpage_3
integer width = 1445
integer height = 708
integer taborder = 20
string title = "none"
string dataobject = "d_halloffame"
boolean border = false
boolean livescroll = true
end type

type cb_2 from commandbutton within w_halloffame
integer x = 1143
integer y = 836
integer width = 338
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_1 from commandbutton within w_halloffame
integer x = 795
integer y = 836
integer width = 338
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reset"
end type

event clicked;datawindow	adw
string		scores[],dum[]
long			i

if MessageBox('Bombs','Are you sure you want to reset Hall Of Fame?',Question!,YesNo!,2)=2 then return


//Make sure there are HOF registry entries
scores=dum
for i=1 to 10
	scores[i]=string(i)+'~t'+'Anonymous'+'~t'+'00:00:00'
next
RegistrySet(regbase+'\HOF','Easy',RegMultiString!,scores)

scores=dum
for i=1 to 10
	scores[i]=string(i)+'~t'+'Anonymous'+'~t'+'00:00:00'
next
RegistrySet(regbase+'\HOF','Normal',RegMultiString!,scores)

scores=dum
for i=1 to 10
	scores[i]=string(i)+'~t'+'Anonymous'+'~t'+'00:00:00'
next
RegistrySet(regbase+'\HOF','Extreme',RegMultiString!,scores)

//Load HOF entries
RegistryGet(regbase+'\HOF','Easy',RegMultiString!,scores)
adw=tab_1.tabpage_1.dw_1
adw.Reset()
for i=1 to Upperbound(scores)
	adw.ImportString(scores[i])
next
for i=Upperbound(scores) to 10
	adw.ImportString(string(i)+'~t'+'Anonymous'+'~t'+'00:00:00')
next

RegistryGet(regbase+'\HOF','Normal',RegMultiString!,scores)
adw=tab_1.tabpage_2.dw_2
adw.Reset()
for i=1 to Upperbound(scores)
	adw.ImportString(scores[i])
next
for i=Upperbound(scores) to 10
	adw.ImportString(string(i)+'~t'+'Anonymous'+'~t'+'00:00:00')
next

RegistryGet(regbase+'\HOF','Extreme',RegMultiString!,scores)
adw=tab_1.tabpage_3.dw_3
adw.Reset()
for i=1 to Upperbound(scores)
	adw.ImportString(scores[i])
next
for i=Upperbound(scores) to 10
	adw.ImportString(string(i)+'~t'+'Anonymous'+'~t'+'00:00:00')
next

end event


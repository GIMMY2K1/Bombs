$PBExportHeader$w_bombs.srw
forward
global type w_bombs from window
end type
type st_time from statictext within w_bombs
end type
type st_1 from statictext within w_bombs
end type
type dw_1 from datawindow within w_bombs
end type
end forward

global type w_bombs from window
integer width = 2533
integer height = 1408
boolean titlebar = true
string title = "Bombs"
string menuname = "m_bombs"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
st_time st_time
st_1 st_1
dw_1 dw_1
end type
global w_bombs w_bombs

type variables
long		rows,cells,bombnum,bombsstepped=0
long		bombsfound,realbombs,errorsallowed=5

integer	gametype=1  //1=Easy    9x 9@10
                     //2=Normal 16x16@40
							//1=Extrem 16x30@99
							//0=Custom 
							
string	customgame='9%9%10%'
boolean	isFirst=TRUE,gameover=FALSE
boolean	gamestarted=FALSE,timerwasstarted=FALSE
long		secondspassed=0
end variables

forward prototypes
public function integer wf_getbombsnear (integer ax, integer ay)
public subroutine wf_uncover (integer ax, integer ay)
public function integer wf_getgametype ()
public subroutine wf_setgame (integer atype)
public subroutine wf_populate_grid ()
public subroutine wf_uncover_all ()
end prototypes

public function integer wf_getbombsnear (integer ax, integer ay);//Returns the number of bombs near cell (ax,ay)
integer	a,b,bomb=0
string	temp

for b=ay -1 to ay +1
	if b<1 or b>rows then continue
	for a=ax -1 to ax +1
		if a<1 or a>cells then continue
		temp=dw_1.GetItemString(b,1)
		if mid(temp,a,1)='1' then bomb ++
	next
next

return bomb
end function

public subroutine wf_uncover (integer ax, integer ay);//Returns the number of bombs near cell (ax,ay)
integer	a,b,bomb=0,bombshere
string	temp,forstar

bombshere=wf_getbombsnear(ax,ay)
temp=dw_1.GetItemString(ay,2)
temp=Replace(temp,ax,1,string(bombshere))
dw_1.SetItem(ay,2,temp)
if bombshere>0 then return
for b=ay -1 to ay +1
	if b<1 or b>rows then continue
	for a=ax -1 to ax +1
		if a<1 or a>cells then continue
		temp=dw_1.GetItemString(b,1)
		if mid(temp,a,1)='1' then continue
		bomb=wf_getbombsnear(a,b)
		if bomb=0 then 
			forstar=dw_1.GetItemString(b,2)
			if mid(forstar,a,1)='*' then wf_uncover(a,b)
		end if
		temp=dw_1.GetItemString(b,2)
		temp=Replace(temp,a,1,string(bomb))
		dw_1.SetItem(b,2,temp)
	next
next


end subroutine

public function integer wf_getgametype ();return gametype
end function

public subroutine wf_setgame (integer atype);string	temp

choose case atype
	case 1
		rows    =9
		cells   =9
		bombnum =10
	case 2
		rows    =16
		cells   =16
		bombnum =40
	case 3
		rows    =16
		cells   =30
		bombnum =99
	case 0
		if isFirst then
			temp=customgame
			isFirst=FALSE
		else
			choose case gametype
				case 1
					temp='9%9%10%'
				case 2
					temp='16%16%40%'
				case 3
					temp='16%30%99%'
				case 0
					temp=customgame
			end choose
			openwithparm(w_customgame,temp)
			temp=Message.StringParm
		end if
		if isnull(temp) or temp='' or temp='cancel' then 
			atype=gametype
		else
			cells   =long(mid(temp,1,pos(temp,'%') -1))
			temp    =mid(temp,pos(temp,'%') +1)
			rows    =long(mid(temp,1,pos(temp,'%') -1))
			temp    =mid(temp,pos(temp,'%') +1)
			bombnum=long(mid(temp,1,pos(temp,'%') -1))
		end if
end choose

gametype=atype
RegistrySet(regbase,'LastGame',RegString!,string(atype))
wf_populate_grid()
end subroutine

public subroutine wf_populate_grid ();string	mod_str
long		i,ax,title_height
long		bombs_plugged[],abomb
long		acell,arow
string	bomb[]

st_time.text=' Time passed : 00:00'
timer(0)

dw_1.DataObject='d_bombgrid'
//Create grid
ax=8
for i=1 to cells
	mod_str='create text(band=detail alignment="1" text="~tif( mid(bombs,'+string(i)+',1)=~'1~',~'M~',~' ~')" border="0" color="'+string(RGB(64,0,0))+'" html.valueishtml="0" visible="0" '+&
	        'font.face="Wingdings" font.height="-10" font.weight="400"  font.family="0" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" '+&
	        'x="'+string(ax)+'" y="4" height="52" width="59" name=bomb_'+string(i)+') '
	dw_1.Modify(mod_str)
	
	mod_str='create text(band=detail alignment="2" text="~tif ( number(mid(cells,'+string(i)+',1)) >0 or mid(cells,'+string(i)+',1)=~'¶~' ,mid(cells,'+string(i)+',1), ~'~')" border="0~tif( mid(cells,'+string(i)+',1)=~'*~' or mid(cells,'+string(i)+',1)=~'¶~',6,5)" html.valueishtml="0" visible="1" '+&
	        'font.face="Tahoma" font.height="-8" font.weight="700"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912" '+&
	        'x="'+string(ax)+'" y="4" height="52" width="59" name=cell_'+string(i)+&
			  ' color="0~tcase( mid(cells,'+string(i)+',1) when ~'1~' then RGB(0,0,255) when ~'2~' then RGB(0,168,0) '+&
			  'when ~'3~' then RGB(255,0,0) when ~'4~' then RGB(128,0,0) when ~'5~' then RGB(128,128,0) when ~'6~' then RGB(128,0,128) '+&
			  'when ~'¶~' then RGB(0,0,64) else 33554432)" )'
	dw_1.Modify(mod_str)

	ax=ax+82
next
dw_1.Modify('DataWindow.Detail.Height=68')
for i=1 to rows
	dw_1.InsertRow(0)
	bomb[i]=Fill('0',cells)
next

dw_1.height=rows*69
dw_1.width =ax -4

st_1.y=dw_1.height
st_1.width=dw_1.width
title_height=this.height - this.Workspaceheight()
this.height=dw_1.height+title_height+st_1.height
this.width =dw_1.width +44

st_time.x=st_1.x+8
st_time.y=st_1.y+60
st_time.width=st_1.width - 32

//Populate with bombs
randomize(0)
do until upperbound(bombs_plugged)=bombnum
	abomb=rand(cells*rows)
	for i=1 to upperbound(bombs_plugged)
		if bombs_plugged[i]=abomb then exit
	next
	if i>upperbound(bombs_plugged) then bombs_plugged[upperbound(bombs_plugged) +1]=abomb
loop

for i=1 to upperbound(bombs_plugged)
	arow =bombs_plugged[i]/cells +1
	acell=bombs_plugged[i] - (arow -1)*cells
	if acell=0 then 
		arow --
		acell=cells
	end if
	bomb[arow]=replace(bomb[arow],acell,1,'1')
next

for i=1 to rows
	dw_1.SetItem(i,1,bomb[i])
	dw_1.SetItem(i,2,Fill('*',cells))
next

st_1.Text=' Press F2 to start a new game ...'
bombsfound=0
realbombs =0
gameover=FALSE
gamestarted=FALSE
bombsstepped=0
this.Visible=FALSE
f_center_window(this)
this.Visible=TRUE
end subroutine

public subroutine wf_uncover_all ();string	temp
long		i,j

dw_1.SetRedraw(FALSE)
for i=1 to rows
	temp=dw_1.GetItemString(i,2)
	for j=1 to cells
		if mid(temp,j,1)='*' then temp=Replace(temp,j,1,string(wf_getbombsnear(j,i)))
	next
	dw_1.SetItem(i,2,temp)
next
dw_1.SetRedraw(TRUE)
end subroutine

event wf_populate_grid;string	mod_str
long		i,ax,title_height
long		bombs_plugged[],abomb
long		acell,arow
string	bomb[]

dw_1.DataObject='d_bombgrid'
//Create grid
ax=8
for i=1 to cells
	mod_str='create text(band=detail alignment="1" text="~tif( mid(bombs,'+string(i)+',1)=~'1~',~'M~',~' ~')" border="0" color="'+string(RGB(64,0,0))+'" html.valueishtml="0" visible="0" '+&
	        'font.face="Wingdings" font.height="-10" font.weight="400"  font.family="0" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" '+&
	        'x="'+string(ax)+'" y="4" height="52" width="59" name=bomb_'+string(i)+') '
	dw_1.Modify(mod_str)
	
	mod_str='create text(band=detail alignment="2" text="~tif ( number(mid(cells,'+string(i)+',1)) >0 or mid(cells,'+string(i)+',1)=~'¶~' ,mid(cells,'+string(i)+',1), ~'~')" border="0~tif( mid(cells,'+string(i)+',1)=~'*~' or mid(cells,'+string(i)+',1)=~'¶~',6,5)" html.valueishtml="0" visible="1" '+&
	        'font.face="Tahoma" font.height="-8" font.weight="700"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912" '+&
	        'x="'+string(ax)+'" y="4" height="52" width="59" name=cell_'+string(i)+&
			  ' color="0~tcase( mid(cells,'+string(i)+',1) when ~'1~' then RGB(0,0,255) when ~'2~' then RGB(0,168,0) '+&
			  'when ~'3~' then RGB(255,0,0) when ~'4~' then RGB(128,0,0) when ~'5~' then RGB(128,128,0) when ~'6~' then RGB(128,0,128) '+&
			  'when ~'¶~' then RGB(0,0,64) else 33554432)" )'
	dw_1.Modify(mod_str)

	ax=ax+82
next
dw_1.Modify('DataWindow.Detail.Height=68')
for i=1 to rows
	dw_1.InsertRow(0)
	bomb[i]=Fill('0',cells)
next

dw_1.height=rows*69
dw_1.width =ax -4

st_1.y=dw_1.height
st_1.width=dw_1.width
title_height=this.height - this.Workspaceheight()
this.height=dw_1.height+title_height+st_1.height
this.width =dw_1.width +44

//Populate with bombs
randomize(0)
do until upperbound(bombs_plugged)=bombnum
	abomb=rand(cells*rows)
	for i=1 to upperbound(bombs_plugged)
		if bombs_plugged[i]=abomb then exit
	next
	if i>upperbound(bombs_plugged) then bombs_plugged[upperbound(bombs_plugged) +1]=abomb
loop

for i=1 to upperbound(bombs_plugged)
	arow =bombs_plugged[i]/cells +1
	acell=bombs_plugged[i] - (arow -1)*cells
	if acell=0 then 
		arow --
		acell=cells
	end if
	bomb[arow]=replace(bomb[arow],acell,1,'1')
next

for i=1 to rows
	dw_1.SetItem(i,1,bomb[i])
	dw_1.SetItem(i,2,Fill('*',cells))
next

bombsfound=0
realbombs =0
gameover=FALSE
bombsstepped=0
this.Visible=FALSE
f_center_window(this)
this.Visible=TRUE
end event

on w_bombs.create
if this.MenuName = "m_bombs" then this.MenuID = create m_bombs
this.st_time=create st_time
this.st_1=create st_1
this.dw_1=create dw_1
this.Control[]={this.st_time,&
this.st_1,&
this.dw_1}
end on

on w_bombs.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_time)
destroy(this.st_1)
destroy(this.dw_1)
end on

event open;string	temp

isFirst=TRUE
if RegistryGet(regbase,'LastGame',RegString!,temp)=1 then gametype=long(temp)
if RegistryGet(regbase,'CustomGame',RegString!,temp)=1 then customgame=temp
if RegistryGet(regbase,'ErrorsAllowed',RegString!,temp)=1 then errorsallowed=long(temp)
wf_setgame(gametype)
end event

event timer;long	min,sec

secondspassed ++
min=int(secondspassed/60)
sec=mod(secondspassed,60)
st_time.text=' Time passed : '+string(min,'00')+':'+string(sec,'00')

end event

event deactivate;timerwasstarted=gamestarted
timer(0)
end event

event activate;if timerwasstarted and not gameover then timer(1)
end event

type st_time from statictext within w_bombs
integer x = 18
integer y = 956
integer width = 1632
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65535
long backcolor = 0
boolean focusrectangle = false
end type

type st_1 from statictext within w_bombs
integer x = 9
integer y = 896
integer width = 1682
integer height = 128
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65280
long backcolor = 0
string text = " Press F2 to start a new game ..."
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_bombs
integer x = 14
integer y = 8
integer width = 2098
integer height = 836
integer taborder = 10
string dataobject = "d_bombgrid"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;string	temp
long		acell,bombshere,i
boolean	isbomb

if gameover then return
if left(dwo.name,5)<>'cell_' then return
if not gamestarted then
	secondspassed=0
	timer(1)
	st_time.text=' Time passed : 00:00'
end if
gamestarted=TRUE
temp=dw_1.GetItemString(row,2)
acell=long(mid(dwo.name,6))
if mid(temp,acell,1)='¶' then
	beep(2)
	return
end if
temp=dw_1.GetItemString(row,1)
acell=long(mid(dwo.name,6))
isbomb=(mid(temp,acell,1)='1')
if isbomb then
	Messagebox('Oops!','You stepped on a bomb!',StopSign!)
	bombsstepped ++
	gameover=(bombsstepped=errorsallowed)
	if gameover then
		timer(0)
		Messagebox('Bombs','GameOver!!!',StopSign!)
		for i=1 to cells
			dw_1.Modify("bomb_"+string(i)+".Visible='1'")
		next
	end if
	
else
	wf_uncover(acell,row)
end if

st_1.text=' Bombs left '+string(bombnum - bombsfound)+' out of '+string(bombnum)
if bombsstepped>0 then
	st_1.text=st_1.text  +' ('+string(bombsstepped)+' errors!)'
	if bombsstepped=1 then st_1.text=replace(st_1.text,lastpos(st_1.text,'errors'),6,'error')
	if gametype=1     then st_1.text=replace(st_1.text,lastpos(st_1.text,'error'),5,'err')
end if
end event

event rbuttondown;string	temp
long		acell,bombshere
boolean	isbomb

if gameover then return
if left(dwo.name,5)<>'cell_' then return
if not gamestarted then
	secondspassed=0
	timer(1)
	st_time.text=' Time passed : 00:00'
end if
gamestarted=TRUE
temp=dw_1.GetItemString(row,1)
acell=long(mid(dwo.name,6))
isbomb=(mid(temp,acell,1)='1')

temp=dw_1.GetItemString(row,2)
if mid(temp,acell,1)='¶' then
	temp=Replace(temp,acell,1,'*')
	dw_1.SetItem(row,2,temp)

	bombsfound --
	if isbomb then realbombs --
else
	temp=Replace(temp,acell,1,'¶')
	dw_1.SetItem(row,2,temp)

	bombsfound ++
	if isbomb then realbombs ++
end if

if realbombs=bombnum and bombsfound=bombnum then
	timer(0)
	gameover=TRUE
	
	wf_uncover_all()
	if gametype<>0 then openwithparm(w_halloffame,'00:'+trim(mid(st_time.text,pos(st_time.text,':') +1))+'^'+string(gametype))
	return
end if

st_1.text=' Bombs left '+string(bombnum - bombsfound)+' out of '+string(bombnum)
if bombsstepped>0 then
	st_1.text=st_1.text  +' ('+string(bombsstepped)+' errors!)'
	if bombsstepped=1 then st_1.text=replace(st_1.text,lastpos(st_1.text,'errors'),6,'error')
	if gametype=1     then st_1.text=replace(st_1.text,lastpos(st_1.text,'error'),5,'err')
end if
end event


#include "globals.bi"

#ifdef FB_WIN32
#define KEY_HUDMENU_UP			VK_UP
#define KEY_HUDMENU_DOWN		VK_DOWN
#define KEY_HUDMENU_LEFT		VK_LEFT
#define KEY_HUDMENU_RIGHT		VK_RIGHT
#define KEY_HUDMENU_TOGGLE		VK_SPACE
#define KEY_HUDMENU_SKIP1		VK_CONTROL
#define KEY_HUDMENU_SKIP2		VK_SHIFT
#else
#define KEY_HUDMENU_UP			XK_Up and &HFF
#define KEY_HUDMENU_DOWN		XK_Down and &HFF
#define KEY_HUDMENU_LEFT		XK_Left and &HFF
#define KEY_HUDMENU_RIGHT		XK_Right and &HFF
#define KEY_HUDMENU_TOGGLE		XK_space
#define KEY_HUDMENU_SKIP1		XK_Control_L and &HFF
#define KEY_HUDMENU_SKIP2		XK_Shift_L and &HFF
#endif

dim shared as integer MenuItem, LastMenuItem, FirstTrueMenuItem, MaxMenuItem


sub hudMenu_Init()
MenuItem = 0: LastMenuItem = MenuItem: FirstTrueMenuItem = 0: MaxMenuItem = 0


end sub

sub hudMenu_HandleInput(Menu as __zHUDMenuEntry ptr , _Len as integer)
	'// temp storage
	dim as integer MenuVal

	'// define menu dimensions/bounds
	FirstTrueMenuItem = 0
 	do while Menu[FirstTrueMenuItem]._type = -1: FirstTrueMenuItem+=1:loop
 
	

	MaxMenuItem = _Len
	do while Menu[MaxMenuItem]._type = -1: MaxMenuItem-=1:loop
	
 

	 if(LastMenuItem = MenuItem andalso Menu[MenuItem]._Type = -1) then  MenuItem+=1
	LastMenuItem = MenuItem 

	' // go up
	if(zProgram._Key(KEY_HUDMENU_UP))  then
		if(MenuItem > FirstTrueMenuItem) then
			MenuItem-=1
		  else 
			MenuItem = MaxMenuItem 
		end if
		zProgram._Key(KEY_HUDMENU_UP) = false
		goto __sanitycheck
	end if
	
	
	' // go down
		if(zProgram._Key(KEY_HUDMENU_DOWN))  then
		if(MenuItem < MaxMenuItem) then
			MenuItem+=1
		  else 
			MenuItem = FirstTrueMenuItem
		end if
		zProgram._Key(KEY_HUDMENU_UP) = false
		goto __sanitycheck
	end if
	
	
	 
	

	 '// decrease value
	if((zProgram._Key(KEY_HUDMENU_LEFT)) andalso (Menu[MenuItem]._Type = 2)) then
		MenuVal = *Menu[MenuItem].Value
		'// modifiers held down?
		if(zProgram._Key(KEY_HUDMENU_SKIP1)) then
			MenuVal-=16
			if(zProgram._Key(KEY_HUDMENU_SKIP2)) then MenuVal-=16
		  else 
			MenuVal-=1
		end if
		*Menu[MenuItem].Value = MenuVal 
		zProgram._Key(KEY_HUDMENU_LEFT) = false
		return 
	end if

	' // increase value
	if((zProgram._Key(KEY_HUDMENU_RIGHT)) andalso (Menu[MenuItem]._Type = 2)) then
		MenuVal = *Menu[MenuItem].Value 
		'// modifiers held down?
		if(zProgram._Key(KEY_HUDMENU_SKIP1)) then
			MenuVal+=16
			if(zProgram._Key(KEY_HUDMENU_SKIP2)) then MenuVal+=16
		  else
			MenuVal+=1
		end if
		*Menu[MenuItem].Value = MenuVal
		zProgram._Key(KEY_HUDMENU_RIGHT) = false
		return
	end if

	' // toggle value on/off
	if((zProgram._Key(KEY_HUDMENU_TOGGLE)) andalso (Menu[MenuItem]._Type < 2)) then 
		MenuVal = *Menu[MenuItem].Value
		MenuVal xor= 1
		*Menu[MenuItem].Value = MenuVal
		zProgram._Key(KEY_HUDMENU_TOGGLE) = false
		return
	end if

__sanitycheck:
	'// skip labels when selecting
	if (Menu[MenuItem]._Type = -1)  then 
		'// if we're going down in the menu
		if (LastMenuItem < MenuItem)  then
			'// is there another entry below?
			if(MenuItem + 1 < _Len) then 
				'// go there
				MenuItem+=1
			 else 
				'// if not, reset
				MenuItem = LastMenuItem
			end if
			return
		 elseif LastMenuItem > MenuItem then
			'// is another entry above?
			if(MenuItem - 1 > 0) then
				MenuItem-=1
			  else 
				MenuItem = LastMenuItem
			end if
			return 
		end if
	end if
end sub

sub hudMenu_Render(Title as zstring ptr,X as integer , Y as integer, Menu as __zHUDMenuEntry ptr, _Len as integer)
 
	dim as zstring * 256 Message
	dim as zstring * 256 TempString
	
	'// output title
	sprintf(Message, !"\x90[ %s ]\n", Title)
	
	dbgprintf(0, MSK_COLORTYPE_ERROR, !"%s\n", Message)
	
	
 
	
	dim i as integer
	do while i < _len
	if(i =  MenuItem) then strcat(Message, !"\x90")
	
	select case Menu[i]._type
	case -1
		sprintf(TempString, !"- %s:\n", Menu[i]._Name)
	case 1
	sprintf(TempString, !"  %s [%s] %s\n", iif(i = MenuItem, " " , " "), iif(*Menu[i].Value , "X", " "), Menu[i]._Name)
	case 2
				select case Menu[i].Disp  
					 
					case 0 ' // signed dec
						sprintf(TempString, !"  %s %s = %i\n", iif(i = MenuItem , " " , " "), Menu[i]._Name, cast(short, *Menu[i].Value))
					 
					case 1  '// unsigned dec
						sprintf(TempString, !"  %s %s = %i\n", iif(i = MenuItem , " " , " "), Menu[i]._Name, cast(ushort,*Menu[i].Value))
						 
					case 2 '// signed hex
						sprintf(TempString, !"  %s %s = 0x%04X\n", iif(i = MenuItem , " " , " "), Menu[i]._Name, cast(short, *Menu[i].Value))
						 
					case 3: '// unsigned hex
					 
				end select
	case 0
	sprintf(TempString, !"  %s %s\n", iif(i = MenuItem, " ", " "), Menu[i]._Name)
	
	case else
	sprintf(TempString, !"  %s %s\n", iif(i = MenuItem, " ", " "), Menu[i]._Name)
	
	end select
	
	
	strcat(Message, TempString)
	i+=1
	loop
	
	'// print via HUD
	hud_Print2(X, Y, -1, -1, 1, 1.0f, Message)
	
	

end sub

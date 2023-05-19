#include "misaka_.bi"
#include "msk_base.bi"
#include "msk_console.bi"
#include "msk_ui.bi"


dim shared as short ObjectValue(512) 
dim shared  as boolean ObjectValueSet(512)





function MSK_MessageBox(Title as zstring ptr, Text as zstring ptr, _Type as integer) as integer Export
dim as __MSK_UI_Dialog_Data Temp

	dim as integer FreeObj = 0
	dim as integer i = 0

	memset(@Temp, &H00, sizeof(Temp)) 

	Temp.ParentHandle = _Console.Handle 
	Temp.Handle = rand() 

'//	MSK_ConsolePrint(MSK_COLORTYPE_WARNING, "NEW MESSAGEBOX: parenthandle: %i, handle: %i\n", Temp.ParentHandle, Temp.Handle);

	dim as integer TextLines = 0, MaxLineLength = 1
	dim as byte LineData(256,256)

	dim as byte Text2(1024)
	strcpy(@Text2(0), Text)

	dim as zstring ptr _Ptr
	_Ptr = strtok(@Text2(0), "|")
	do while (_Ptr <> NULL) 
		strcpy(@LineData(TextLines,0), _Ptr)
		TextLines+=1
		_Ptr = strtok(NULL, "|")
	loop

	'// base message box settings
	Temp.y = -1
	Temp.x = -1
	Temp.Title = Title
	Temp.BkgColor = 5
	Temp.HLColor = 4

	select case _type
	
	case MSK_UI_MSGBOX_OK
			FreeObj = MSK_UI_Dialog_GetFreeObject()
			_Object(FreeObj).ParentHandle = Temp.Handle
			_Object(FreeObj).Handle = rand()
			_Object(FreeObj)._Type = MSK_UI_DLGOBJ_BUTTON
			_Object(FreeObj).y = -1
			_Object(FreeObj).x = -1
			_Object(FreeObj).Order = 0
			_Object(FreeObj).ObjParameters = @"Ok|1"
			_Object(FreeObj).Value = NULL
			
			i=0
			Do while i < textlines
				if(strlen(@LineData(i,0)) >= MaxLineLength) then MaxLineLength = strlen(@LineData(i,0))
				FreeObj = MSK_UI_Dialog_GetFreeObject()
				_Object(FreeObj).ParentHandle = Temp.Handle
				_Object(FreeObj).Handle = rand()		
				_Object(FreeObj)._Type = MSK_UI_DLGOBJ_LABEL		
				_Object(FreeObj).y = (i * 2) + 1
				_Object(FreeObj).x = 1
				_Object(FreeObj).Order = -1
				_Object(FreeObj).ObjParameters = @LineData(i,0)		
				_Object(FreeObj).Value = NULL	
			
			i+=1
			loop
 
	case MSK_UI_MSGBOX_YESNO

	
	
	
	
	
			FreeObj = MSK_UI_Dialog_GetFreeObject()
			_Object(FreeObj).ParentHandle = Temp.Handle
			_Object(FreeObj).Handle = rand()
			_Object(FreeObj)._Type = MSK_UI_DLGOBJ_BUTTON
			_Object(FreeObj).y = -1
			_Object(FreeObj).x = 1
			_Object(FreeObj).Order = 1
			_Object(FreeObj).ObjParameters = @"Yes|1"
			_Object(FreeObj).Value = NULL
 
			' MSK_ConsolePrint(MSK_COLORTYPE_OKAY, !"%i\n",_Object(FreeObj)._Type)
			FreeObj = MSK_UI_Dialog_GetFreeObject()
			_Object(FreeObj).ParentHandle = Temp.Handle
			_Object(FreeObj).Handle = rand()
			_Object(FreeObj)._Type = MSK_UI_DLGOBJ_BUTTON
			_Object(FreeObj).y = -1
			_Object(FreeObj).x = -1
			_Object(FreeObj).Order = 0
			_Object(FreeObj).ObjParameters = @"No|0"
			_Object(FreeObj).Value = NULL
			'MSK_ConsolePrint(MSK_COLORTYPE_OKAY, !"%i\n",_Object(FreeObj)._Type)
			
			
			
			
		        i=0
			Do while i < textlines
				if(strlen(@LineData(i,0)) >= MaxLineLength) then MaxLineLength = strlen(@LineData(i,0))
				FreeObj = MSK_UI_Dialog_GetFreeObject()
				_Object(FreeObj).ParentHandle = Temp.Handle
				_Object(FreeObj).Handle = rand()		
				_Object(FreeObj)._Type = MSK_UI_DLGOBJ_LABEL		
				_Object(FreeObj).y = (i * 2) + 1
				_Object(FreeObj).x = 1
				_Object(FreeObj).Order = -1
				_Object(FreeObj).ObjParameters = @LineData(i,0)		
				_Object(FreeObj).Value = NULL												
					
						
			i+=1
			loop
			
			
			
			
	case else
		return -1
	
	
	
	end select


	Temp.h = (TextLines*2) + 4
	Temp.w = MaxLineLength + 4

	i = MSK_UI_Dialog_GetFreeDlgHandle()
	if (i = -1) then
		return -1
	else
	
	end if
	memcpy(@Dialog(i), @Temp, sizeof(__MSK_UI_Dialog_Data))
	Dialog_Active = Dialog(i)
	i = 0
	do while i < ArraySize(ObjectValue)
		ObjectValue(i) = 0
		ObjectValueSet(i) = 0
		i+=1
	loop


	MSK_SetMainFunction(@MSK_DoEvents_Dialog)
	return Dialog_Active.Handle


end function

function  MSK_Dialog(Dlg as __MSK_UI_Dialog ptr ) as integer
       dim as __MSK_UI_Dialog_Data Temp

	dim as integer FreeObj = -1

	memset(@Temp, &H00, sizeof(Temp))

	Temp.ParentHandle = _Console.Handle
	Temp.Handle = rand()

	Temp.y = -1
	Temp.x = -1
	Temp.Title = Dlg->Title
	Temp.BkgColor = 5
	Temp.HLColor = 4

	Temp.h = Dlg->h
	Temp.w = Dlg->w

	dim as integer  i = 0
	do while(i < ArraySize(Dlg->_Object))  
		FreeObj = MSK_UI_Dialog_GetFreeObject() 

		_Object(FreeObj).ParentHandle = Temp.Handle 
		_Object(FreeObj).Handle = rand() 
		_Object(FreeObj)._Type = Dlg->_Object(i)._Type 
		_Object(FreeObj).y = Dlg->_Object(i).y 
		_Object(FreeObj).x = Dlg->_Object(i).x 
		_Object(FreeObj).Order = Dlg->_Object(i).Order 
		_Object(FreeObj).ObjParameters = Dlg->_Object(i).ObjParameters
		_Object(FreeObj).Value = Dlg->_Object(i).Value
		i+=1
	loop

	dim as integer FreeDlgH = MSK_UI_Dialog_GetFreeDlgHandle()
	if(FreeDlgH = -1) then return -1

	memcpy(@Dialog(FreeDlgH), @Temp, sizeof(__MSK_UI_Dialog_Data))
	Dialog_Active = Dialog(FreeDlgH)

	 
	i = 0 
	do while i < ArraySize(ObjectValue)
		ObjectValue(i) = 0
		ObjectValueSet(i) = 0
		i+=1
	loop

	MSK_SetMainFunction(@MSK_DoEvents_Dialog)

	return Dialog_Active.Handle


end function

sub MSK_DoEvents_Dialog()
	MSK_UI_Dialog_Draw(@Dialog_Active) 'might be issues area
	
	 if(kbhit() = 0) then return 

	dim as integer OnObject = Dialog_Active.ObjSelected(0)

	dim as integer Character = getch()
	
	dim as 	boolean IsOkay = FALSE 
	dim as 	boolean ExitDlg = FALSE
	
	
	
	select case (Character) 
		'// exit dialog
		case ESCAPE_KEY
		beep
			ExitDlg = TRUE
		

		'// select prev object
		case KEY_UP
			if(Dialog_Active.ObjSelected(1) > 0) then
				Dialog_Active.ObjSelected(1)-=1
			 else  
				Dialog_Active.ObjSelected(1) = Dialog_Active.ObjCount(1)
			end if
			

		'// select next object
		case KEY_DOWN
			if(Dialog_Active.ObjSelected(1) < Dialog_Active.ObjCount(1)) then 
				Dialog_Active.ObjSelected(1)+=1
			 else 
				Dialog_Active.ObjSelected(1) = 0 
			end if
			

		case KEY_LEFT
		'MSK_ConsolePrint(MSK_COLORTYPE_OKAY, !"%i\n",Dialog_Active.ObjSelected(1))
			if(_Object(OnObject)._Type = MSK_UI_DLGOBJ_NUMBERSEL) then
		 
				'// select prev option in object
				'// see if negative vals allowed
				dim as boolean AllowNegative = MSK_UI_Dialog_ObjNumSelect_GetAllowNegativeFlag(@_Object(OnObject))
				'// if not neg allowed AND value is neg, reset to org value
				if((AllowNegative = 0) andalso (ObjectValue(OnObject) < 0)) then ObjectValue(OnObject) = *_Object(OnObject).Value
				'// get max value
				dim as integer Total = MSK_UI_Dialog_ObjNumSelect_GetCount(@_Object(OnObject)) - 1
				'// set min value
			        dim as integer  MinValue = 0
				'// if neg allowed, set min value to (total / 2) - total
				if(AllowNegative) then MinValue = (Total \ 2) - Total
				if(ObjectValue(OnObject) > MinValue) then ObjectValue(OnObject)-=1

			'// select prev object
			  elseif((_Object(OnObject)._Type = MSK_UI_DLGOBJ_BUTTON) orelse (_Object(OnObject)._Type = MSK_UI_DLGOBJ_CHECKBOX)) then
			'	beep
				if(Dialog_Active.ObjSelected(1) > 0) then
					Dialog_Active.ObjSelected(1)-=1
				  else 
					Dialog_Active.ObjSelected(1)= Dialog_Active.ObjCount(1)
				end if
			end if
		

		case KEY_RIGHT
		'MSK_ConsolePrint(MSK_COLORTYPE_OKAY, !"%i\n",Dialog_Active.ObjSelected(1))
			'// select next option in object
	                if(_Object(OnObject)._Type = MSK_UI_DLGOBJ_NUMBERSEL) then
			 
				dim as boolean AllowNegative = MSK_UI_Dialog_ObjNumSelect_GetAllowNegativeFlag(@_Object(OnObject))
				if((AllowNegative = 0) andalso (ObjectValue(OnObject) < 0)) then ObjectValue(OnObject) = *_Object(OnObject).Value
				dim as integer Total = MSK_UI_Dialog_ObjNumSelect_GetCount(@_Object(OnObject)) - 1
				dim as integer MaxValue = Total
				if(AllowNegative) then MaxValue = (Total \ 2)
				if(ObjectValue(OnObject) < MaxValue) then ObjectValue(OnObject)+=1

			'// select next object
			   elseif((_Object(OnObject)._Type = MSK_UI_DLGOBJ_BUTTON) orelse (_Object(OnObject)._Type = MSK_UI_DLGOBJ_CHECKBOX)) then
		               '  beep
		                 
				if(Dialog_Active.ObjSelected(1) < Dialog_Active.ObjCount(1)) then
					Dialog_Active.ObjSelected(1)+=1
				 else 
					Dialog_Active.ObjSelected(1) = 0 
				end if
		 	end if
			

		'// toggle object
		case asc(" ")
			'// toggle checkbox state
			if(_Object(OnObject)._Type = MSK_UI_DLGOBJ_CHECKBOX) then
				if (ObjectValueSet(OnObject) = 0)  then
					ObjectValue(OnObject)= *_Object(OnObject).Value
					ObjectValueSet(OnObject) = 1
				end if
				ObjectValue(OnObject) = (ObjectValue(OnObject) = 0)
			end if
	

		'// activate object
		case asc(!"\n")
		
		
					'// if button
			if(_Object(OnObject)._Type = MSK_UI_DLGOBJ_BUTTON) then
			' MSK_ConsolePrint(MSK_COLORTYPE_OKAY, !"%i\n",OnObject)
			 
				ExitDlg = TRUE
				if(MSK_UI_Dialog_ObjButton_IsOkay(@_Object(OnObject))) then beep: IsOkay = TRUE
			end if
		
		case PADENTER
		
			'// if button
			if(_Object(OnObject)._Type = MSK_UI_DLGOBJ_BUTTON) then
		 'MSK_ConsolePrint(MSK_COLORTYPE_OKAY, !"%i\n",OnObject)
				ExitDlg = TRUE
				if(MSK_UI_Dialog_ObjButton_IsOkay(@_Object(OnObject))) then beep: IsOkay = TRUE
			end if
		
	end select


	
	if (ExitDlg) then
		Dialog_Active.ObjSelected(0) = 0
		Dialog_Active.ObjSelected(1) = 0

		MSK_Refresh(_Console.CurrentConsoleLine - 1)

		ReturnVal.Handle = Dialog_Active.Handle
		ReturnVal.s8 = _Object(OnObject).Order
	
			dim as integer i 
			
			 i = 0
		do while(i < ArraySize(_Object))
			if(IsOkay andalso ((_Object(i).Value = NULL) = 0 ) andalso ObjectValueSet(i)) then
				*_Object(i).Value = ObjectValue(i)
			end if

			if(_Object(i).ParentHandle = Dialog_Active.Handle) then
				if(_Object(i).ObjParameters = NULL) then exit do

				MSK_UI_Dialog_DestroyObject(i)
			end if
			i+=1
		loop

	
	
	 
	
	 

		MSK_UI_Dialog_DestroyDlgHandle(Dialog_Active.Handle)
	
	MSK_RestoreMainFunction()
	
        ' if((Dialog_Active.Handle = _Console.ExitHandle) then MSK_ConsolePrint(MSK_COLORTYPE_OKAY, !"%i\n",OnObject)


	if((Dialog_Active.Handle = _Console.ExitHandle) andalso (IsOkay)) then _Console.IsRunning = FALSE
	
 	end if
	
	
end sub


sub MSK_UI_Dialog_Draw(Dlg as __MSK_UI_Dialog_Data ptr )


        dim y as integer = Dlg->Y
	dim x as integer = Dlg->x
	if(y = -1)then  y = (LINES \ 2) - (Dlg->h \ 2)
	if(x = -1) then x = (COLS \ 2) - (Dlg->w \ 2)
	Dlg->Win = newwin(Dlg->h, Dlg->w, y, x)
	Dlg->WinShade = newwin(Dlg->h, Dlg->w, y + 1, x + 1)

	wbkgd(Dlg->Win, COLOR_PAIR(Dlg->BkgColor))
	wbkgd(Dlg->WinShade, COLOR_PAIR(Dlg->HLColor))

	box(Dlg->Win, 0, 0)
	mvwhline(Dlg->Win, 0, 0, ACS_CKBOARD, Dlg->w)

	wmove(Dlg->Win, 0, 1)
	wprintw(Dlg->Win, "[%s]", Dlg->Title)

	dim as zstring ptr EscMsg = @"[X]"
	wmove(Dlg->Win, 0, Dlg->w - strlen(EscMsg) - 1)
	wprintw(Dlg->Win, EscMsg)

	dim as integer ObjCountTotal = 0
	dim as integer ObjCountSelectable = 0
	
	dim as integer i
	i = 0
	
	
	do while i < arraysize(_object)
		if(_Object(i).ParentHandle = Dlg->Handle) then
			if(_Object(i).ObjParameters = NULL) then exit do
			
			ObjCountTotal+=1
			if(_Object(i).Order <> -1) then ObjCountSelectable+=1
			
			select case _object(i)._type
			
			case MSK_UI_DLGOBJ_LABEL
				        wmove(Dlg->Win, _Object(i).y + 1, _Object(i).x + 1)
					wprintw(Dlg->Win,_Object(i).ObjParameters)
					 
			
			
			case MSK_UI_DLGOBJ_BUTTON
				
				       if(Dlg->ObjSelected(1) = _Object(i).Order) then  wattron(Dlg->Win, COLOR_PAIR(Dlg->HLColor))
					dim as zstring * 64 Text 
					strcpy(Text, _Object(i).ObjParameters)
					dim as zstring ptr _ptr 
					_ptr = strstr(Text, "|")
					if((_Ptr)) then *_Ptr = &H00 

				 	if(_Object(i).y =  -1) then _Object(i).y  = Dlg->h - 3 
					if(_Object(i).x = -1) then _Object(i).x = (Dlg->w - strlen(Text) - 9)
					 wmove(Dlg->Win, _Object(i).y + 1, _Object(i).x + 1)
					 wprintw(Dlg->Win, "[  %s  ]", Text)
					  if(Dlg->ObjSelected(1) = _Object(i).Order) then wattroff(Dlg->Win, COLOR_PAIR(Dlg->HLColor))
			
			case MSK_UI_DLGOBJ_CHECKBOX
				       if(Dlg->ObjSelected(1) = _Object(i).Order) then wattron(Dlg->Win, COLOR_PAIR(Dlg->HLColor))
					wmove(Dlg->Win, _Object(i).y + 1, _Object(i).x + 1)
					if(ObjectValueSet(i) = 0) then
						ObjectValue(i) = *_Object(i).Value
						ObjectValueSet(i) = 1
					end if
					 wprintw(Dlg->Win, "[%s]", iif(ObjectValue(i), "X" , " "))
					if(Dlg->ObjSelected(1) = _Object(i).Order) then  wattroff(Dlg->Win, COLOR_PAIR(Dlg->HLColor))
					wprintw(Dlg->Win, " %s", _Object(i).ObjParameters) 
 
			case MSK_UI_DLGOBJ_NUMBERSEL
		'	MSK_ConsolePrint(0, "IN NUM") 
			 wmove(Dlg->Win,_Object(i).y + 1, _Object(i).x + 1) 
					dim as zstring * 64 Text
					strcpy(Text, @_Object(i).ObjParameters)
					dim as zstring ptr _ptr
					
					_ptr = strstr(Text, "|")
					if(_ptr  ) then  *_ptr = &H00

					dim as integer Current = 0 
					dim as integer  Amount = MSK_UI_Dialog_ObjNumSelect_GetCount(@_Object(i))

					wprintw(Dlg->Win, "%s : ", Text)
					if(MSK_UI_Dialog_ObjNumSelect_GetDisplayType(@_Object(i)) = 1) then 
					       if(Dlg->ObjSelected(1) = _Object(i).Order) then wattron(Dlg->Win, COLOR_PAIR(Dlg->HLColor))
						dim as byte _Format(64): dim as integer NumbCnt = 2: dim as integer OldAmount = Amount
						do while(Amount): NumbCnt+=1:Amount /= 10: loop
						Amount = OldAmount
						sprintf(@_Format(0), "%*i", NumbCnt, ObjectValue(i))
						if(MSK_UI_Dialog_ObjNumSelect_GetStringFormat(@_Object(i)) = 1) then sprintf(@_Format(0), "0x%04X", cast(ushort,ObjectValue(i)))
						wprintw(Dlg->Win, "< %s >", @_Format(0))
						if(Dlg->ObjSelected(1) = _Object(i).Order) then wattroff(Dlg->Win, COLOR_PAIR(Dlg->HLColor))
                                       else
						  do while current < Amount
							if(ObjectValueSet(i) = 0) then
								ObjectValue(i) = *_Object(i).Value
								ObjectValueSet(i) = 1
							end if
							if(ObjectValue(i) = Current) then
								if(Dlg->ObjSelected(1) = _Object(1).Order) then wattron(Dlg->Win, COLOR_PAIR(Dlg->HLColor)) 
								wprintw(Dlg->Win, "[ %i ]", Current)
							 else 
								wprintw(Dlg->Win, "  %i  ", Current)
							end if
							if((Dlg->ObjSelected(i) = _Object(i).Order) andalso (ObjectValue(i) = Current)) then wattroff(Dlg->Win, COLOR_PAIR(Dlg->HLColor))  
						 Current +=1
						 loop
					end if  
				 
			
			case MSK_UI_DLGOBJ_LINE 
				        dim as integer Length = 0
					sscanf(_Object(i).ObjParameters, "%i", @Length)
					if(Length = -1) then Length = Dlg->w - 4
					mvwhline(Dlg->Win, _Object(i).y + 1, _Object(i).x + 1, ACS_HLINE, Length)
				 
			
			end select
		
		
		end if
	i +=1
	
	loop




	Dlg->ObjCount(0) = ObjCountTotal
	Dlg->ObjCount(1) = ObjCountSelectable - 1

	MSK_UI_Dialog_SyncSelection(Dlg)

'//	wmove(Dlg->Win, 1, 1);
'//	wprintw(Dlg->Win, "true: %i %i  sel: %i %i", Dlg->ObjSelected[0], Dlg->ObjCount[0], Dlg->ObjSelected[1], Dlg->ObjCount[1]);


	wnoutrefresh(Dlg->WinShade)
	wnoutrefresh(Dlg->Win)
	refresh()


	delwin(Dlg->WinShade)
	delwin(Dlg->Win)
end sub

sub MSK_UI_Dialog_CalculateObjCount(Dlg as __MSK_UI_Dialog_Data ptr )
	dim as integer i = 0
	do while(i < ArraySize(_Object)) 
		if(_Object(i).ParentHandle = Dlg->Handle) then  Dlg->ObjCount(0)+=1
		if(_Object(i).Order <> -1) then Dlg->ObjCount(1)+=1
		i+=1
	loop
end sub

function MSK_UI_Dialog_ObjNumSelect_GetCount(Obj as __MSK_UI_Object_Data ptr ) as integer
	dim as integer ret = 0

	dim as zstring ptr _Ptr = strchr(Obj->ObjParameters, asc("|"))
	sscanf(_Ptr+1, !"%i", @Ret)

	return Ret

end function

 function MSK_UI_Dialog_ObjNumSelect_GetDisplayType(Obj as __MSK_UI_Object_Data ptr ) as integer
	dim as integer ret = 0

	dim as zstring ptr _Ptr = strchr(Obj->ObjParameters, asc("|"))
	_Ptr = strchr(_Ptr+1, asc("|"))
	sscanf(_Ptr+1, !"%i", @Ret)

	return Ret
end function

function MSK_UI_Dialog_ObjNumSelect_GetStringFormat(Obj as __MSK_UI_Object_Data ptr ) as integer
	dim as integer ret = 0

	dim as zstring ptr _Ptr = strchr(Obj->ObjParameters, asc("|"))
	_Ptr = strchr(_Ptr+1, asc("|"))
	_Ptr = strchr(_Ptr+1, asc("|"))
	sscanf(_Ptr+1, !"%i", @Ret)

	return Ret
end function 

function MSK_UI_Dialog_ObjNumSelect_GetAllowNegativeFlag(Obj as __MSK_UI_Object_Data ptr )  as integer
	dim as integer ret = 0

	dim as zstring ptr _Ptr = strchr(Obj->ObjParameters, asc("|"))
	_Ptr = strchr(_Ptr+1, asc("|"))
	_Ptr = strchr(_Ptr+1, asc("|"))
	_Ptr = strchr(_Ptr+1, asc("|"))
	sscanf(_Ptr+1, !"%i", @Ret)

	return Ret
end function

function MSK_UI_Dialog_ObjButton_IsOkay(Obj as __MSK_UI_Object_Data ptr ) as boolean
	dim _Get as integer = 0
 
	dim as zstring * 64 _format
	 
 
	sprintf(_Format, !"%%*%dc|%%i", (strlen(Obj->ObjParameters) - 2))
	sscanf(Obj->ObjParameters, _Format, @_Get)

'//	MSK_ConsolePrint(MSK_COLORTYPE_OKAY, "'%s' -> '%s' -> '%i'\n", Format, Obj->ObjParameters, Get);

	return cast(boolean,_Get)
end function

sub MSK_UI_Dialog_SyncSelection(Dlg as __MSK_UI_Dialog_Data ptr )
	dim as integer i = 0
	
	do while i < ArraySize(_Object) 
		if(_Object(i).ParentHandle = Dlg->Handle) then
			if(_Object(i).Order = Dlg->ObjSelected(i)) then
				Dlg->ObjSelected(0) = i
				exit do
			end if
		end if

		i+=1
	loop
end sub

function MSK_UI_Dialog_GetFreeDlgHandle() as integer 
	dim as integer i = 0
	do while i < ArraySize(Dialog) 
		if(Dialog(i).Handle = -1)then
			return i
		end if
		i+=1
	loop

	return -1
end function

sub MSK_UI_Dialog_DestroyDlgHandle(DstHandle  as integer)
	dim as integer i = 0
	do while i < ArraySize(Dialog) 
		if(Dialog(i).Handle = DstHandle) then
			memset(@Dialog(i), -1,  sizeof(Dialog)) 'single element
			Dialog(i).Handle = -1
			exit do
		end if
		i+=1
	loop
end sub

function MSK_UI_Dialog_GetFreeObject() as integer
	dim as integer i = 0
	
	do while i < ArraySize(_Object) 
	
		
		if(_Object(i).ObjParameters = NULL) then
		 
			return i
		end if
		
		i+=1
	loop

	return -1
end function

sub MSK_UI_Dialog_DestroyObject(ObjHandle  as integer)
	memset(@_Object(ObjHandle), -1,  sizeof(_Object)) 'single element
	_Object(ObjHandle).ObjParameters = NULL
end sub

'COMPLETE////////////////////////////////

 type __MSK_Return
	as integer Handle 
	as byte s8 
	as ubyte u8 
	as short s16
	as ushort u16
	as integer s32 
	as uinteger u32 
	as longint s64 
	as ulongint  u64 
	as zstring ptr _str
end type 

type __MSK_UI_Object
	as integer _Type
	as integer y
	as integer x
	as integer Order

	as any ptr ObjParameters 
	as short ptr Value
end type

type __MSK_UI_Dialog
	 Title  as  zstring ptr
	as integer h
	as integer w 

	as __MSK_UI_Object _Object(512)
end type



#define ArraySize_bytes(a) ubound(a) * sizeof(a)
#define ArraySize(a) ubound(a)

extern "C"


#ifndef SHARED_SO

#ifdef NEW_MISAKA
#inclib "FB_MISAKA"
#else
#inclib "MISAKA"


#endif


declare function MSK_Init(  _Apptitle as zstring ptr) as integer
declare sub MSK_SetValidCharacters(Chars as Zstring ptr)
declare sub MSK_AddCommand(cmd as zstring ptr,  Help  as zstring ptr,Func as any ptr)
declare sub MSK_Exit()
declare sub MSK_InitLogging(  path as zstring ptr) 
declare sub MSK_SetLogging(Toggle as integer)
declare sub MSK_ConsolePrint  cdecl  (_Color as integer,frmt as zstring ptr, ...)
declare function MSK_MessageBox( Title as zstring ptr, Text as zstring ptr , Type as integer) as integer
declare function MSK_DoEvents() as integer
declare function MSK_Dialog(Dlg as __MSK_UI_Dialog ptr ) as integer
 



#endif



end extern

 
#ifdef SHARED_SO
extern as function( _Apptitle as zstring ptr) as integer  MSK_Init 

extern as sub (Chars as Zstring ptr) MSK_SetValidCharacters 

extern as sub(cmd as zstring ptr,  Help  as zstring ptr,Func as any ptr) MSK_AddCommand 

extern as sub()   MSK_Exit 

extern as sub( _Apptitle as zstring ptr)   MSK_InitLogging 

extern as sub(Toggle as integer) MSK_SetLogging 

extern as sub  cdecl  (_Color as integer,frmt as zstring ptr, ...) MSK_ConsolePrint  

extern as function( Title as zstring ptr, Text as zstring ptr , Type as integer) as integer MSK_MessageBox 

extern as sub()   MSK_DoEvent 

extern as function(Dlg as __MSK_UI_Dialog ptr ) as integer MSK_Dialog

#endif

enum __MSK_Console_Colors
	MSK_COLORTYPE_INFO, MSK_COLORTYPE_OKAY, MSK_COLORTYPE_WARNING, MSK_COLORTYPE_ERROR
end enum

enum __MSK_UI_ObjTypes
	MSK_UI_DLGOBJ_LABEL, _
	MSK_UI_DLGOBJ_BUTTON, _
	MSK_UI_DLGOBJ_CHECKBOX, _ 
	MSK_UI_DLGOBJ_NUMBERSEL, _
	MSK_UI_DLGOBJ_LINE
end enum

enum __MSK_UI_MsgBoxTypes
	MSK_UI_MSGBOX_OK, MSK_UI_MSGBOX_YESNO
end enum

enum __MSK_UI_MsgBoxRetTypes
	MSK_UI_MSGBOX_RETOKYES, MSK_UI_MSGBOX_RETNO
end enum

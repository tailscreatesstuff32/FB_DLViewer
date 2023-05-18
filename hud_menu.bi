type __zHUDMenuEntry
	as zstring * 256 _Name 
	as short ptr Value
	as integer _Type
	as integer Disp
end type



declare sub hudMenu_Init()
declare sub hudMenu_HandleInput(Menu as __zHUDMenuEntry ptr,_Len as  integer) 
declare sub hudMenu_Render(Title as zstring ptr,X as integer , Y as integer, Menu as __zHUDMenuEntry ptr, _Len as integer)

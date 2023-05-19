'FINISHED/////////////////////////


type __zHUD 
	as ubyte ptr _Image
	as GLuint TexID 
	as GLuint BaseDL 
	as integer _width, _Height, Plane, BPP 
	as byte CharWidths(256)
end type

dim shared as  __zHUD zHUD

declare function hud_Init() as integer
declare function hud_LoadFontBuffer(buffer as ubyte ptr) as boolean
declare sub hud_BuildFont()
declare sub hud_KillFont()
declare sub hud_Print cdecl (X as GLint, Y as GLint,W  as integer, H as integer,scale as integer,Vis as double,  _String as zstring ptr, ...)






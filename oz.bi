declare function oz_InitProgram(WWndTitle as zstring ptr, w as integer, h as integer) as integer
declare function oz_APIMain() as integer 
declare function oz_ExitProgram() as integer
declare function oz_SetWindowTitle(WndTitle as zstring ptr ) as integer
declare function  oz_SetWindowSize(_Width as integer,_Height as integer) as integer
declare function oz_CreateFolder(_Folder as zstring ptr) as integer
'declare function oz_Unimplemented( FuncName() as const byte) as integer

declare function oz_Unimplemented( _FuncName as const zstring ptr) as integer

#define MAX_SEGMENTS 16


#ifndef MAX_PATH
 #include "crt/limits.bi"
 #define MAX_PATH PATH_MAX
#endif

type __RAM 
	as integer IsSet
        as uinteger _Size
	as integer SourceCompType
	as uinteger SourceOffset
	as ubyte ptr _Data
end type

extern as __RAM RAM(MAX_SEGMENTS)

type __RDRAM
	as boolean IsSet
	as uinteger  _Size
	as ubyte ptr _Data
end type

extern as __RDRAM RDRAM


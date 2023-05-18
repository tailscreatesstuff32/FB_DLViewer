 

static shared as __MSK_UI_Dialog DlgAbout =>  _
( _
	@"About", 15, 58,  _
	{( MSK_UI_DLGOBJ_LABEL,  1,  1, -1,  NULL,                                                      NULL ),   _
	 ( MSK_UI_DLGOBJ_LABEL,  2,  1,  -1, @"libbadRDP-based viewer for compiled Display Lists",      NULL ),   _
	 ( MSK_UI_DLGOBJ_LABEL,  4,  1,  -1, @"Written in December 2010 by xdaniel",                    NULL ),   _
	 ( MSK_UI_DLGOBJ_LABEL,  5,  1,  -1, @"Using PDCurses and libMISAKA Console & UI Library",      NULL ),   _
	 ( MSK_UI_DLGOBJ_LABEL,  6,  1,  -1, @"http://ozmav.googlecode.com/",                           NULL ),   _
	 ( MSK_UI_DLGOBJ_LABEL,  8,  1,  -1, @"libMISAKA - Written in 2010 by xdaniel & contributors",  NULL ),   _
	 ( MSK_UI_DLGOBJ_LINE,  10,  1,  -1, @"-1",                                                     NULL ),   _
	 ( MSK_UI_DLGOBJ_BUTTON,  -1, -1, 0, @"OK|1",                                                   NULL )}   _
)
DlgAbout._Object(0).ObjParameter  = @zProgram.Title

type __ConsoleCmd
	as zstring ptr _Name
	as zstring ptr Desc
	as sub( as any ptr) Func



end type


static shared as __ConsoleCmd Cmds(0 to ...) => {(@"loadscript",@"Load command script (<filename>)", cast(any ptr,@cn_Cmd_LoadScript )), _ 
						( @"setucode",@"Set Ucode to emulate (<name>)", cast(any ptr,@cn_Cmd_SetUCode )), _ 
						( @"loadram",@"Load file to RDRAM <filename>", cast(any ptr,@cn_Cmd_LoadRAM )), _
						( @"loadseg",@"Load file to segment (<[0x]segment> <filename>)", cast(any ptr,@cn_Cmd_LoadFile )), _
						( @"finddlists",@"Find possible Display Lists (<[0x]segment>)", cast(any ptr,@cn_Cmd_FindDLists )), _
						( @"clearseg",@"Clear specified segment (<[0x]segment>)", cast(any ptr,@cn_Cmd_ClearSegment )), _
						( @"adddlist",@"Add Display List address (<[0x]address>)", cast(any ptr,@cn_Cmd_AddDList )), _
						( @"cleardlists",@"Clear known Display Lists addresses", cast(any ptr,@cn_Cmd_ClearDLists )), _
						( @"setscale",@"Set scaling factor (<scale[f]>)", cast(any ptr,@cn_Cmd_SetScale )), _
						( @"segments",@"List segment usage", cast(any ptr,@cn_cmd_SegmentUsage )), _
						( @"about",@"About the program", cast(any ptr,@cn_Cmd_About )) _
						}
						 
													     


/'


static __MSK_UI_Dialog DlgAbout =
{
	"About", 15, 58,
	{
		{ MSK_UI_DLGOBJ_LABEL,  1,  1,  -1, zProgram.Title,                                          NULL },
		{ MSK_UI_DLGOBJ_LABEL,  2,  1,  -1, "libbadRDP-based viewer for compiled Display Lists",     NULL },
		{ MSK_UI_DLGOBJ_LABEL,  4,  1,  -1, "Written in December 2010 by xdaniel",                   NULL },
		{ MSK_UI_DLGOBJ_LABEL,  5,  1,  -1, "Using PDCurses and libMISAKA Console & UI Library",     NULL },
		{ MSK_UI_DLGOBJ_LABEL,  6,  1,  -1, "http://ozmav.googlecode.com/",                          NULL },
		{ MSK_UI_DLGOBJ_LABEL,  8,  1,  -1, "libMISAKA - Written in 2010 by xdaniel & contributors", NULL },
		{ MSK_UI_DLGOBJ_LINE,   10, 1,  -1, "-1",                                                    NULL },
		{ MSK_UI_DLGOBJ_BUTTON, -1, -1, 0,  "OK|1",                                                  NULL }
	}
};

typedef struct {
	char * Name;
	char * Desc;
	void (* Func)(void * Params);
} __ConsoleCmd;



                   


 




static __ConsoleCmd Cmds[] =
{
	{ "loadscript",		"Load command script (<filename>)",					(void*)&cn_Cmd_LoadScript },
	{ "setucode",		"Set Ucode to emulate (<name>)",					(void*)&cn_Cmd_SetUCode },
	{ "loadram",		"Load file to RDRAM <filename>",					(void*)&cn_Cmd_LoadRAM },
	{ "loadseg",		"Load file to segment (<[0x]segment> <filename>)",	(void*)&cn_Cmd_LoadFile },
	{ "finddlists",		"Find possible Display Lists (<[0x]segment>)",		(void*)&cn_Cmd_FindDLists },
	{ "clearseg",		"Clear specified segment (<[0x]segment>)",			(void*)&cn_Cmd_ClearSegment },
	{ "adddlist",		"Add Display List address (<[0x]address>)",			(void*)&cn_Cmd_AddDList },
	{ "cleardlists",	"Clear known Display Lists addresses",				(void*)&cn_Cmd_ClearDLists },
	{ "setscale",		"Set scaling factor (<scale[f]>)",					(void*)&cn_Cmd_SetScale },
	{ "segments",		"List segment usage",								(void*)&cn_cmd_SegmentUsage },
	{ "about",			"About the program",								(void*)&cn_Cmd_About }
}; '/

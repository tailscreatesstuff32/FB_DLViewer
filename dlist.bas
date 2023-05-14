#include "globals.bi"

sub dl_ViewerInit(UCode as integer)

/'RDP_ClearStructures(true);
	RDP_ClearTextures();

	if((int)zProgram.UCode != UCode) {
		zProgram.UCode = UCode;
		RDP_InitParser(zProgram.UCode);

		switch(zProgram.UCode) {
			case F3D:
			case F3DEX:
				Cmd_DL = 0x06;
				Cmd_ENDDL = 0xB8;
				Cmd_TEXTURE = 0xBB;
				break;
			case F3DEX2:
				Cmd_DL = 0xDE;
				Cmd_ENDDL = 0xDF;
				Cmd_TEXTURE = 0xD7;
				break;
		}
		dbgprintf(0, MSK_COLORTYPE_OKAY, "Viewer initialized, using %s microcode.\n", UCodeName(UCode))
	}'/

dbgprintf(0, MSK_COLORTYPE_OKAY, !"Viewer initialized, using %s microcode.\n",UCodeName(UCode))


end sub

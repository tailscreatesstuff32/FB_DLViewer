

#include "globals.bi"

 'char * UCodeNames[] = { "Fast3D", "F3DEX", "F3DEX2" };

dim shared as zstring ptr UCodeName(0 to ...) =>  { @"Fast3D", @"F3DEX", @"F3DEX2" }




dim shared  as zstring * MAX_PATH WorkingDir 



sub cn_InitCommands()
 
	dim i as integer 

	'do while i < cast(integer,ubounds(Cmds))
	'MSK_AddCommand(Cmds[i].Name, Cmds[i].Desc, Cmds[i].Func)
	
	'i+=1 
	'loop

      memset(@WorkingDir, 0, sizeof(WorkingDir))
 
 
	
	
	
	
	
end sub

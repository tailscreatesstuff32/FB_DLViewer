'FINISHED/////////////////////////////////////

#include "globals.bi"

#include "msk_data.bi"

 'char * UCodeNames[] = { "Fast3D", "F3DEX", "F3DEX2" };

dim shared as zstring ptr UCodeNames(0 to ...) =>  { @"Fast3D", @"F3DEX", @"F3DEX2" }

dim shared as zstring * MAX_PATH WorkingDir 
dim shared as boolean  DoScript = false 

 
dim shared as zstring * MAX_PATH TempString 
 

sub cn_Cmd_About(_Ptr as ubyte ptr)
 
	_Ptr = NULL 
	zProgram.HandleAbout = MSK_Dialog(@DlgAbout)
end sub


sub cn_Cmd_LoadScript(_Ptr as ubyte ptr)
if(_Ptr = NULL) then
		dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: No parameter specified!")
	  else 
		dim as zstring * MAX_PATH Filename
		memset(@Filename, 0, sizeof(Filename))
		sscanf(cast(zstring ptr,_Ptr+1), "%s",  cast(zstring ptr,@Filename))	
		
		if(Filename[0] = &H00)  then

		 	dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: Invalid parameters specified!")
		 	return 
		end if	 
		
		
		dim as FILE ptr fp
		FP = fopen(Filename, "r")
		if FP = NULL then
			dbgprintf(0, MSK_COLORTYPE_ERROR, !"- Error: File %s not found!\n", Filename)
			return
		end if
		
		GetFilePath(Filename, WorkingDir)
		DoScript = true
		
		dbgprintf(0, MSK_COLORTYPE_OKAY, "Now running command script %s...", Filename)
		
		' // clear all RAM
		dim as integer i
		 
		
		do while i < MAX_SEGMENTS: /'RDP_ClearSegment(i)'/ :i += 1:loop
		'RDP_ClearRDRAM()
		
		' // clear DList addresses
		memset(@zProgram.DListAddr(0), 0, ArraySize(zProgram.DListAddr))
		zProgram.DListCount = -1
		zProgram.DListSel = -1

		' // clear libbadRDP data
		'RDP_ClearStructures(true)
		'RDP_ClearTextures()

		' // analyze command script
		dim as zstring * MAX_PATH Temp, TempCmd
 
		do while fgets(Temp,MAX_PATH,FP) <> NULL
			' // get line and extract command
			sscanf(cast(zstring ptr, @Temp), "%s", cast(zstring ptr, @TempCmd))
			dim as integer i = 0	

			'  // if line is not a comment, go and check known commands
			i = 0
			if TempCmd[0] <> asc("#") then
				do while i < cast(integer,ArraySize(Cmds))
				
					' // if command exists, execute its function using the line's parameters
					if strcmp(Cmds(i)._Name, TempCmd) = 0 then
					 
					 
					' dbgprintf(0, MSK_COLORTYPE_OKAY, "%s",cast(zstring ptr,@Temp) + strlen(TempCmd))
					 
					 
					        Cmds(i).Func(cast(zstring ptr,@Temp) + strlen(TempCmd))
						exit do
					end if
					i += 1
				loop
			end if
		loop

		
		dbgprintf(0, MSK_COLORTYPE_OKAY, "Command script has been executed.")
		
		DoScript = false
		
		fclose(FP)
	end if

end sub

sub cn_Cmd_SetUCode(_Ptr as ubyte ptr)
	if(_Ptr = NULL) then
		dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: No parameter specified!")
	  else 
		 
		dim as zstring * MAX_PATH UCodeName
		memset(@UCodeName, 0, sizeof(UCodeName))
		sscanf(cast(zstring ptr,_Ptr+1), "%s",  cast(zstring ptr,@UCodeName))

		dim as boolean _Error = false
		if(UCodeName[0] = &H00) then
			_Error = true
		  else  
			dim as integer i = 0
			do while i < cast(integer,ArraySize(UCodeNames))
			 
				if(strcmp(UCodeName, UCodeNames(i)) = 0) then
				dl_ViewerInit(i)
					return
				end if
				i+=1
			loop
			_Error = true
		end if

		if(_Error) then
			dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: Invalid parameter specified!")
			return
		end if
	end if

end sub

sub cn_Cmd_LoadFile(_Ptr as ubyte ptr)
	if(_Ptr = NULL) then
		dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: No parameter specified!")
	  else 
		dim as int32_t  Segment = -1 
		dim as zstring * MAX_PATH Filename
		memset(@Filename, 0, sizeof(Filename))
		sscanf(cast(zstring ptr,_Ptr+1), "0x%02X %s", @Segment, cast(zstring ptr,@filename))

		if((Filename[0] = &H00) orelse (Segment = -1))  then

		 	dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: Invalid parameters specified!")
		 	return 
		end if

		if(DoScript) then
			strcpy(TempString, WorkingDir)
			strcat(TempString, Filename)
			 dbgprintf(0, MSK_COLORTYPE_ERROR, "0x%02X %s",Segment,Filename)
			'dl_LoadFileToSegment(TempString, Segment)
		 else 
		 
		 
		 dbgprintf(0, MSK_COLORTYPE_ERROR, "0x%02X %s",Segment,Filename)
			'dl_LoadFileToSegment(Filename, Segment)
		end if
	end if

end sub

sub cn_Cmd_ClearSegment(_Ptr as ubyte ptr)
	if(_Ptr = NULL) then
		dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: No parameter specified!")
	 else 
		dim as int32_t Segment = -1
		sscanf(cast(zstring ptr,_Ptr+1), "0x%02X", @Segment)

		'if(!RDP_CheckAddressValidity((Segment << 24))) {
			dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: Invalid segment specified!")
			return
		'}

		dbgprintf(0, MSK_COLORTYPE_INFO, "Cleared segment 0x%02X.", Segment)
		'RDP_ClearSegment(Segment)
	end if

end sub

sub cn_Cmd_LoadRAM(_Ptr as ubyte ptr)
	if(_Ptr = NULL) then
		dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: No parameter specified!")
	  else 
		dim as zstring * MAX_PATH Filename
		memset(@Filename, 0, sizeof(Filename))
		sscanf(cast(zstring ptr,_Ptr+1), "%s",cast(zstring ptr,@filename))

		if(Filename[0] = &H00)  then

		 	dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: Invalid parameters specified!")
		 	return 
		end if


zOptions.EnableGrid = false

		if(DoScript) then
			strcpy(TempString, WorkingDir)
			strcat(TempString, Filename)
			 dbgprintf(0, MSK_COLORTYPE_ERROR, "%s",TempString)
			'dRAMDump(dl_LoaTempString)
		 else 
		 
		 
		 dbgprintf(0, MSK_COLORTYPE_ERROR, "%s",Filename)
			'dl_LoadRAMDump(Filename)
		end if
	end if


end sub

sub cn_Cmd_FindDLists(_Ptr as ubyte ptr)



	if(_Ptr = NULL) then
		dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: No parameter specified!")
	else 
		dim as integer Segment = -1
			sscanf(cast(zstring ptr,_Ptr+1), "0x%02X", @Segment)

		'if(!RDP_CheckAddressValidity((Segment shl 24))) {
			'dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: Invalid segment specified!")
			'return
		'}

		'dl_FindDLists(Segment)
		gl_CreateSceneDLists()
	end if

end sub

sub cn_Cmd_AddDList(_Ptr as ubyte ptr)
	if(_Ptr = NULL) then
		dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: No parameter specified!")
	else 
		dim as int32_t Address = -1
		sscanf(cast(zstring ptr,_Ptr+1), "0x%08X", @Address)

		'if(!RDP_CheckAddressValidity(Address)) {
			dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: Invalid address specified!")
			return
		'}

		dbgprintf(0, MSK_COLORTYPE_INFO, "Added Display List address 0x%08X.", Address)
		zProgram.DListCount+=1
		zProgram.DListAddr(zProgram.DListCount) = Address

		gl_CreateSceneDLists()
	end if

end sub

sub cn_Cmd_ClearDLists(_Ptr as ubyte ptr)

_Ptr = NULL

	memset(@zProgram.DListAddr(0), 0, ArraySize(zProgram.DListAddr))
	zProgram.DListCount = -1
	zProgram.DListSel = -1

	dbgprintf(0, MSK_COLORTYPE_INFO, "All Display List addresses removed from list.")
	
end sub

sub cn_Cmd_SetScale(_Ptr as ubyte ptr)
	if(_Ptr = NULL) then
		dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: No parameter specified!")
	else 
		dim as single scale = 1.0f
			sscanf(cast(zstring ptr,_Ptr+1), "%f", cast(single ptr,@scale))

		if(Scale <= 0.0f) then
			dbgprintf(0, MSK_COLORTYPE_ERROR, "- Error: Invalid scale specified!")
			return
		end if

		dbgprintf(0, MSK_COLORTYPE_INFO, "Set scaling factor to %f.", Scale)
		zProgram.ScaleFactor = Scale
	end if

end sub

sub cn_cmd_SegmentUsage(_Ptr as ubyte ptr)
	_Ptr  = NULL 

	dbgprintf(0, MSK_COLORTYPE_OKAY, "Current RAM segments:")

	dim as integer i = 0
	do while i < MAX_SEGMENTS
		 if RAM(i).IsSet then
		 	dbgprintf(0, MSK_COLORTYPE_OKAY, "- Segment 0x%02X's base address is 0x%08X.", i, RAM(i).SourceOffset) 
	           else 
		 	dbgprintf(0, MSK_COLORTYPE_WARNING, "- Segment 0x%02X is not set.", i) 
		end if
		i+=1
	loop

end sub





sub cn_InitCommands()
	dim i as integer 
        i = 0
	do while i < cast(integer,Arraysize(Cmds))
	MSK_AddCommand(Cmds(i)._Name, Cmds(i).Desc, Cmds(i).Func)
	
	i+=1 
 	loop

      memset(@WorkingDir, 0, sizeof(WorkingDir))
end sub

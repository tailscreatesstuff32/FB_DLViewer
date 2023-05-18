#include "globals.bi"

dim shared as ubyte Cmd_DL = 0
dim shared as ubyte Cmd_ENDDL = 0
dim shared as ubyte Cmd_TEXTURE = 0

sub dl_ViewerInit(UCode as integer)

        'RDP_ClearStructures(true);
	'RDP_ClearTextures();

	if(cast(integer, zProgram.UCode) <> UCode) then 
		zProgram.UCode = UCode
		'RDP_InitParser(zProgram.UCode)

		select case (zProgram.UCode) 
			case F3D
				Cmd_DL = &H06
				Cmd_ENDDL = &HB8
				Cmd_TEXTURE = &HBB
			case F3DEX
				Cmd_DL = &H06
				Cmd_ENDDL = &HB8
				Cmd_TEXTURE = &HBB
				 
			case F3DEX2
				Cmd_DL = &HDE
				Cmd_ENDDL = &HDF
				Cmd_TEXTURE = &HD7
				
		end select
		dbgprintf(0, MSK_COLORTYPE_OKAY, !"Viewer initialized, using %s microcode.\n", UCodeNames(UCode))
	end if


end sub




function dl_IsDLEndInBetween(Segment as ubyte, From as uinteger, _To as uinteger) as bool
 
	dim as integer i = From 

	do while i < cast(integer,_to)

		dim as uinteger W0 = Read32(RAM(Segment)._Data, i) 
		dim as uinteger W1  = Read32(RAM(Segment)._Data, i + 4) 

		if cast(integer,W0 ) = (Cmd_ENDDL shl 24) andalso cast(integer,w1 ) then return true

		i+=1
	loop

 

	return false 
end function



sub dl_LoadRAMDump(Filename as zstring ptr)
 dim as FILE ptr file 
        file = fopen(Filename, "rb")
	if file =  NULL  then
		dbgprintf(0, MSK_COLORTYPE_ERROR, !"- Error: File %s not found!\n", Filename)
		return
	end if
	
	fseek(file, 0, SEEK_END)
	dim as integer _Size = ftell(file)
	rewind(file)
	dim as ubyte ptr tempRDRAM = cast(ubyte ptr, malloc (sizeof(ubyte) * _Size))
	fread(TempRDRAM, 1, _Size, file)
	fclose(file)

	'RDP_LoadToRDRAM(TempRDRAM, Size);

	free(TempRDRAM)

	dbgprintf(0, MSK_COLORTYPE_INFO, "Loaded %s to RDRAM.", Filename)

/'	zProgram.DListSel = 0;
	//zProgram.DListAddr[0] = 0x802E1AD0; //sin
	//zProgram.DListAddr[0] = 0x8016E5A0; //eva
	zProgram.DListAddr[0] = 0x8016A648; //oot
	zProgram.DListCount = 0;'/
end sub



sub dl_LoadFileToSegment(Filename as zstring ptr,Segment as ubyte)
dim as FILE ptr file 

        file = fopen(Filename, "rb")
	if file =  NULL  then
		dbgprintf(0, MSK_COLORTYPE_ERROR, !"- Error: File %s not found!\n", Filename)
		return
	end if

	fseek(file, 0, SEEK_END)
	dim as integer _Size = ftell(file)
	rewind(file)
	 
	
	dim as ubyte ptr _data = cast(ubyte ptr, malloc (sizeof(ubyte) * _Size))
	
	
	fread(_Data, 1, _Size, file)
	fclose(file)

	dl_ViewerInit(zProgram.UCode)

	'if(RDP_CheckAddressValidity(Segment << 24)) {
	'	RDP_ClearSegment(Segment);
	'}

	'RDP_LoadToSegment(Segment, Data, 0, Size);

	free(_Data)

	dbgprintf(0, MSK_COLORTYPE_INFO, "Loaded %s to segment 0x%02X.", Filename, Segment)
	
end sub



sub dl_FindDLists(Segment as ubyte)
 
	zProgram.DListCount = -1
	zProgram.DListSel = -1

	dim as integer i = 0
	dim as uinteger FullAddr = 0

	do while 1
		FullAddr = ((Segment shl 24) or i) 
		'if(!RDP_CheckAddressValidity(FullAddr + 8)) break;

 
		dim as uinteger W0 = Read32(RAM(Segment)._Data, i) 
		dim as uinteger W1  = Read32(RAM(Segment)._Data, i + 4) 
		 
		if cast(integer,w0) = (Cmd_DL shl 24) and cast(integer, 0) <> 0 then 'andalso  (RDP_CheckAddressValidity(W1)))  then
			zProgram.DListCount += 1
			zProgram.DListAddr(zProgram.DListCount) = W1
			dbgprintf(0, MSK_COLORTYPE_INFO, "Found Display List at address 0x%08X.", zProgram.DListAddr(zProgram.DListCount))
		end if

		i += 8
	loop

	i = 0

	 if zProgram.DListCount = -1  then
	    do while 1
	    
	    FullAddr = ((Segment shl 24) or i)
	    
			 
		'	if(!RDP_CheckAddressValidity(FullAddr + 8)) break;

 
			
		   dim as uinteger W0 = Read32(RAM(Segment)._Data, i) 
		   dim as uinteger W1 = Read32(RAM(Segment)._Data, i + 4) 
		 
			

		 	if(	((W0 = &HE7000000) andalso (W1 = 0)) orelse _
				((W0 = &HE8000000) andalso (W1 = 0)) orelse _
				(W0 shr 8 = &HFA0000) orelse _
				(W0 = &HFB000000) orelse _
				(cast(integer,W0) shr 8 = (Cmd_TEXTURE shl 16)) orelse _
				((W0 shr 24 = &HFD) andalso ((W0 and &H0000FFFF) = 0)) ) then 'andalso (RDP_CheckAddressValidity(W1)))) {
				
				 	if(zProgram.DListCount = -1)  then
				 	zProgram.DListCount +=1
	 
						zProgram.DListAddr(zProgram.DListCount) = FullAddr
						dbgprintf(0, MSK_COLORTYPE_INFO, "Found initial Display List at address 0x%08X.", zProgram.DListAddr(zProgram.DListCount) )
				 	 else  
					'//	dbgprintf(0,0,"%08X -> %08X",i,RAM[Segment].Size);
					
					
					if  dl_IsDLEndInBetween(Segment, (zProgram.DListAddr(zProgram.DListCount) and &H00FFFFFF), i) andalso _
					    dl_IsDLEndInBetween(Segment, i, RAM(Segment)._Size)  then
					 			zProgram.DListCount +=1
								 zProgram.DListAddr(zProgram.DListCount) = FullAddr
								dbgprintf(0, MSK_COLORTYPE_INFO, "Assuming next Display List at address 0x%08X.",  zProgram.DListAddr(zProgram.DListCount)) 
							end if
					end if
			end if

			i += 8
		loop
	end if  

	if(zProgram.DListCount = 0) then zProgram.DListSel = 0

	dbgprintf(0, MSK_COLORTYPE_INFO, "Found %i Display Lists.", zProgram.DListCount + 1)
end sub



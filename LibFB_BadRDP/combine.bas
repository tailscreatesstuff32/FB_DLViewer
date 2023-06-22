#include "globals.bi"
#include "misaka.bi"
Dim shared CombinerTypes32(0 To ...) As Const ZString Ptr => _
   { _
        @ "COMBINED        ", @ "TEXEL0          ", _
        @ "TEXEL1          ", @ "PRIMITIVE       ", _
        @ "SHADE           ", @ "ENVIRONMENT     ", _
        @ "1               ", @ "COMBINED_ALPHA  ", _
        @ "TEXEL0_ALPHA    ", @ "TEXEL1_ALPHA    ", _
        @ "PRIMITIVE_ALPHA ", @ "SHADE_ALPHA     ", _
        @ "ENV_ALPHA       ", @ "LOCFRAC         ", _
        @ "PRIMLOCFRAC     ", @ "K5              ", _
        @ "<unknown>       ", @ "<unknown>       ", _
        @ "<unknown>       ", @ "<unknown>       ", _
        @ "<unknown>       ", @ "<unknown>       ", _
        @ "<unknown>       ", @ "<unknown>       ", _
        @ "<unknown>       ", @ "<unknown>       ", _
        @ "<unknown>       ", @ "<unknown>       ", _
        @ "<unknown>       ", @ "<unknown>       ", _
        @ "<unknown>       ", @ "0               " _ 
   }

Dim shared CombinerTypes16(0 To ...) As Const ZString Ptr => _
   { _
        @ "COMBINED        ", @ "TEXEL0          ", _
        @ "TEXEL1          ", @ "PRIMITIVE       ", _
        @ "SHADE           ", @ "ENVIRONMENT     ", _
        @ "1               ", @ "COMBINED_ALPHA  ", _
        @ "TEXEL0_ALPHA    ", @ "TEXEL1_ALPHA    ", _
        @ "PRIMITIVE_ALPHA ", @ "SHADE_ALPHA     ", _
        @ "ENV_ALPHA       ", @ "LOCFRAC         ", _
        @ "PRIMLOCFRAC     ", @ "0               " _
    }

Dim shared CombinerTypes8(0 To ...) As Const ZString Ptr => _
    { _
        @ "COMBINED        ", @ "TEXEL0          ", _
        @ "TEXEL1          ", @ "PRIMITIVE       ", _
        @ "SHADE           ", @ "ENVIRONMENT     ", _
        @ "1               ", @ "0               " _
    }

sub RDP_CreateCombinerProgram(Cmb0 As integer, Cmb1 As integer)
if(OpenGL.Ext_FragmentProgram = 0) then return

Dim cA(1) As Integer, cB(1) As Integer, cC(1) As Integer, cD(1) As Integer
Dim aA(1) As Integer, aB(1) As Integer, aC(1) As Integer, aD(1) As Integer

cA(0) = ((Cmb0 Shr 20) And &HF)
cB(0) = ((Cmb1 Shr 28) And &HF)
cC(0) = ((Cmb0 Shr 15) And &H1F)
cD(0) = ((Cmb1 Shr 15) And &H7)

aA(0) = ((Cmb0 Shr 12) And &H7)
aB(0) = ((Cmb1 Shr 12) And &H7)
aC(0) = ((Cmb0 Shr 9) And &H7)
aD(0) = ((Cmb1 Shr 9) And &H7)

cA(1) = ((Cmb0 Shr 5) And &HF)
cB(1) = ((Cmb1 Shr 24) And &HF)
cC(1) = ((Cmb0 Shr 0) And &H1F)
cD(1) = ((Cmb1 Shr 6) And &H7)

aA(1) = ((Cmb1 Shr 21) And &H7)
aB(1) = ((Cmb1 Shr 3) And &H7)
aC(1) = ((Cmb1 Shr 18) And &H7)
aD(1) = (Cmb1 And &H7)

dim as zstring * 16384 ProgramString
	 memset(@ProgramString, &H00, len(ProgramString))

	dim as zstring ptr LeadIn = _
		@!"!!ARBfp1.0\n" _
		!"\n" _
		!"TEMP Tex0; TEMP Tex1;\n" _
		!"TEMP R0; TEMP R1;\n" _
		!"TEMP aR0; TEMP aR1;\n" _
		!"TEMP Comb; TEMP aComb;\n" _
		!"\n" _
		!"PARAM EnvColor = program.env[0];\n" _
		!"PARAM PrimColor = program.env[1];\n" _
		!"PARAM PrimColorLOD = program.env[2];\n" _
		!"ATTRIB Shade = fragment.color.primary;\n" _
		!"\n" _
		!"OUTPUT Out = result.color;\n" _
		!"\n" _
		!"TEX Tex0, fragment.texcoord[0], texture[0], 2D;\n" _
		!"TEX Tex1, fragment.texcoord[1], texture[1], 2D;\n" _
		!"\n"
		
		strcpy(ProgramString, LeadIn)
		
			dim as integer Cycle = 0, NumCycles = 2

	if(Gfx.OtherMode.cycleType = G_CYC_1CYCLE) then NumCycles = 1

		
 
For Cycle = 0 To NumCycles - 1
    sprintf(ProgramString, !"%s# Color %d\n", ProgramString, Cycle)
	    Select Case cA(Cycle)
		Case G_CCMUX_COMBINED
		    StrCat(ProgramString, !"MOV R0.rgb, Comb;\n")
		Case G_CCMUX_TEXEL0
		     StrCat(ProgramString, !"MOV R0.rgb, Tex0;\n")
		Case G_CCMUX_TEXEL1
		    StrCat(ProgramString, !"MOV R0.rgb, Tex1;\n")
		Case G_CCMUX_PRIMITIVE
		     StrCat(ProgramString, !"MOV R0.rgb, PrimColor;\n")
		Case G_CCMUX_SHADE
		    StrCat(ProgramString, !"MOV R0.rgb, Shade;\n")
		Case G_CCMUX_ENVIRONMENT
		     StrCat(ProgramString, !"MOV R0.rgb, EnvColor;\n")
		Case G_CCMUX_1
		     StrCat(ProgramString, !"MOV R0.rgb, {1.0, 1.0, 1.0, 1.0};\n")
		Case G_CCMUX_COMBINED_ALPHA
		  StrCat(ProgramString, !"MOV R0.rgb, Comb.a;\n")
		Case G_CCMUX_TEXEL0_ALPHA
		    StrCat(ProgramString, !"MOV R0.rgb, Tex0.a;\n")
		Case G_CCMUX_TEXEL1_ALPHA
		   StrCat(ProgramString, !"MOV R0.rgb, Tex1.a;\n")
		Case G_CCMUX_PRIMITIVE_ALPHA
		  StrCat(ProgramString, !"MOV R0.rgb, PrimColor.a;\n")
		Case G_CCMUX_SHADE_ALPHA
		   StrCat(ProgramString, !"MOV R0.rgb, Shade.a;\n")
		Case G_CCMUX_ENV_ALPHA
		   StrCat(ProgramString, !"MOV R0.rgb, EnvColor.a;\n")
		Case G_CCMUX_LOD_FRACTION
		   StrCat(ProgramString, !"MOV R0.rgb, {0.0, 0.0, 0.0, 0.0};\n") ' unemulated
		Case G_CCMUX_PRIM_LOD_FRAC
		   StrCat(ProgramString, !"MOV R0.rgb, PrimColorLOD;\n")
		Case 15 ' 0
		   StrCat(ProgramString, !"MOV R0.rgb, {0.0, 0.0, 0.0, 0.0};\n")
		Case Else
		   StrCat(ProgramString, !"MOV R0.rgb, {0.0, 0.0, 0.0, 0.0};\n")
		  sprintf(ProgramString, !"%s# -%d\n", ProgramString, cA(Cycle))
	    End Select
 

		
		select case cB(Cycle)
			case G_CCMUX_COMBINED
				strcat(ProgramString, !"MOV R1.rgb, Comb;\n")
			case G_CCMUX_TEXEL0 
				strcat(ProgramString, !"MOV R1.rgb, Tex0;\n")
			case G_CCMUX_TEXEL1 
				strcat(ProgramString, !"MOV R1.rgb, Tex1;\n")
			case G_CCMUX_PRIMITIVE 
				strcat(ProgramString, !"MOV R1.rgb, PrimColor;\n")
			case G_CCMUX_SHADE
				strcat(ProgramString, !"MOV R1.rgb, Shade;\n")
			case G_CCMUX_ENVIRONMENT
				strcat(ProgramString, !"MOV R1.rgb, EnvColor;\n")
			case G_CCMUX_1:
				strcat(ProgramString, !"MOV R1.rgb, {1.0, 1.0, 1.0, 1.0};\n")
			case G_CCMUX_COMBINED_ALPHA 
				strcat(ProgramString, !"MOV R1.rgb, Comb.a;\n") 
			case G_CCMUX_TEXEL0_ALPHA
				strcat(ProgramString, !"MOV R1.rgb, Tex0.a;\n")
			case G_CCMUX_TEXEL1_ALPHA
				strcat(ProgramString, !"MOV R1.rgb, Tex1.a;\n")
			case G_CCMUX_PRIMITIVE_ALPHA
				strcat(ProgramString, !"MOV R1.rgb, PrimColor.a;\n")
			case G_CCMUX_SHADE_ALPHA
				strcat(ProgramString, !"MOV R1.rgb, Shade.a;\n")
			case G_CCMUX_ENV_ALPHA
				strcat(ProgramString, !"MOV R1.rgb, EnvColor.a;\n") 
			case G_CCMUX_LOD_FRACTION
				strcat(ProgramString, !"MOV R1.rgb, {0.0, 0.0, 0.0, 0.0};\n") 	'// unemulated
			case G_CCMUX_PRIM_LOD_FRAC
				strcat(ProgramString, !"MOV R1.rgb, PrimColorLOD;\n")
			case 15:	'// 0
				strcat(ProgramString, !"MOV R1.rgb, {0.0, 0.0, 0.0, 0.0};\n")
			case else
				strcat(ProgramString, !"MOV R1.rgb, {0.0, 0.0, 0.0, 0.0};\n")
				sprintf(ProgramString, !"%s# -%d\n", ProgramString, cB(Cycle))
				 
		end select
		strcat(ProgramString, !"SUB R0, R0, R1;\n\n")
		
		 select case cC(Cycle)
			case G_CCMUX_COMBINED 
				strcat(ProgramString, !"MOV R1.rgb, Comb;\n") 
			 
			case G_CCMUX_TEXEL0:
				strcat(ProgramString, !"MOV R1.rgb, Tex0;\n")
				 
			case G_CCMUX_TEXEL1:
				strcat(ProgramString, !"MOV R1.rgb, Tex1;\n")
			
			case G_CCMUX_PRIMITIVE:
				strcat(ProgramString, !"MOV R1.rgb, PrimColor;\n") 
 
			case G_CCMUX_SHADE:
				strcat(ProgramString, !"MOV R1.rgb, Shade;\n") 
				 
			case G_CCMUX_ENVIRONMENT:
				strcat(ProgramString, !"MOV R1.rgb, EnvColor;\n") 
				 
			case G_CCMUX_1:
				strcat(ProgramString, !"MOV R1.rgb, {1.0, 1.0, 1.0, 1.0};\n") 
			 
			case G_CCMUX_COMBINED_ALPHA:
				strcat(ProgramString, !"MOV R1.rgb, Comb.a;\n") 
 
			case G_CCMUX_TEXEL0_ALPHA:
				strcat(ProgramString, !"MOV R1.rgb, Tex0.a;\n") 
				 
			case G_CCMUX_TEXEL1_ALPHA:
				strcat(ProgramString, !"MOV R1.rgb, Tex1.a;\n") 
 
			case G_CCMUX_PRIMITIVE_ALPHA:
				strcat(ProgramString, !"MOV R1.rgb, PrimColor.a;\n") 
 
			case G_CCMUX_SHADE_ALPHA:
				strcat(ProgramString, !"MOV R1.rgb, Shade.a;\n") 
 
			case G_CCMUX_ENV_ALPHA:
				strcat(ProgramString,!"MOV R1.rgb, EnvColor.a;\n") 
 
			case G_CCMUX_LOD_FRACTION:
				strcat(ProgramString, !"MOV R1.rgb, {0.0, 0.0, 0.0, 0.0};\n") 	'// unemulated
 
			case G_CCMUX_PRIM_LOD_FRAC:
				strcat(ProgramString, !"MOV R1.rgb, PrimColorLOD;\n") 
			 
			case G_CCMUX_K5:
				strcat(ProgramString, !"MOV R1.rgb, {1.0, 1.0, 1.0, 1.0};\n")	'// unemulated
				 
			case G_CCMUX_0 
				strcat(ProgramString, !"MOV R1.rgb, {0.0, 0.0, 0.0, 0.0};\n")
				 
			case else
				strcat(ProgramString, !"MOV R1.rgb, {0.0, 0.0, 0.0, 0.0};\n") 
				sprintf(ProgramString, !"%s# -%d\n", ProgramString, cC(Cycle)) 
				 
		end select
		strcat(ProgramString, !"MUL R0, R0, R1;\n\n") 

	 	select case (cD(Cycle))
			case G_CCMUX_COMBINED 
				strcat(ProgramString, !"MOV R1.rgb, Comb;\n") 
			 
			case G_CCMUX_TEXEL0 
				strcat(ProgramString, !"MOV R1.rgb, Tex0;\n") 
			 
			case G_CCMUX_TEXEL1 
				strcat(ProgramString, !"MOV R1.rgb, Tex1;\n") 
		 
			case G_CCMUX_PRIMITIVE:
				strcat(ProgramString, !"MOV R1.rgb, PrimColor;\n") 
		 
			case G_CCMUX_SHADE:
				strcat(ProgramString, !"MOV R1.rgb, Shade;\n") 
			 
			case G_CCMUX_ENVIRONMENT 
				strcat(ProgramString, "MOV R1.rgb, EnvColor;\n") 
			 
			case G_CCMUX_1 
				strcat(ProgramString, !"MOV R1.rgb, {1.0, 1.0, 1.0, 1.0};\n") 
			 
			case 7 		'// 0
				strcat(ProgramString, !"MOV R1.rgb, {0.0, 0.0, 0.0, 0.0};\n") 
			 
			case else
				strcat(ProgramString, !"MOV R1.rgb, {0.0, 0.0, 0.0, 0.0};\n")
				sprintf(ProgramString, !"%s# -%d\n", ProgramString, cD(Cycle)) 
				 
		end select
		strcat(ProgramString, !"ADD R0, R0, R1;\n\n") 

		sprintf(ProgramString, !"%s# Alpha %d\n", ProgramString, Cycle) 

		select case (aA(Cycle))
			case G_ACMUX_COMBINED:
				strcat(ProgramString, !"MOV aR0.a, aComb;\n") 
			 
			case G_ACMUX_TEXEL0 
				strcat(ProgramString, !"MOV aR0.a, Tex0.a;\n") 
			 
			case G_ACMUX_TEXEL1:
				strcat(ProgramString, !"MOV aR0.a, Tex1.a;\n") 
		 
			case G_ACMUX_PRIMITIVE:
				strcat(ProgramString, !"MOV aR0.a, PrimColor.a;\n") 
			 
			case G_ACMUX_SHADE:
				strcat(ProgramString, !"MOV aR0.a, Shade.a;\n") 
			 
			case G_ACMUX_ENVIRONMENT:
				strcat(ProgramString, !"MOV aR0.a, EnvColor.a;\n") 
			 
			case G_ACMUX_1:
				strcat(ProgramString, !"MOV aR0.a, {1.0, 1.0, 1.0, 1.0};\n") 
			 
			case G_ACMUX_0:
				strcat(ProgramString, !"MOV aR0.a, {0.0, 0.0, 0.0, 0.0};\n") 
			 
			case else
				strcat(ProgramString, !"MOV aR0.a, {0.0, 0.0, 0.0, 0.0};\n")
				sprintf(ProgramString, !"%s# -%d\n", ProgramString, aA(Cycle)) 
			 
		end select

		select case (aB(Cycle))  
			case G_ACMUX_COMBINED
				strcat(ProgramString, !"MOV aR1.a, aComb;\n")
		 
			case G_ACMUX_TEXEL0
				strcat(ProgramString, !"MOV aR1.a, Tex0.a;\n")
		 
			case G_ACMUX_TEXEL1
				strcat(ProgramString, !"MOV aR1.a, Tex1.a;\n")
			 
			case G_ACMUX_PRIMITIVE
				strcat(ProgramString, !"MOV aR1.a, PrimColor.a;\n")
				 
			case G_ACMUX_SHADE
				strcat(ProgramString, !"MOV aR1.a, Shade.a;\n")
				 
			case G_ACMUX_ENVIRONMENT
				strcat(ProgramString, !"MOV aR1.a, EnvColor.a;\n")
 
			case G_ACMUX_1
				strcat(ProgramString, !"MOV aR1.a, {1.0, 1.0, 1.0, 1.0};\n")
			 
			case G_ACMUX_0
				strcat(ProgramString, !"MOV aR1.a, {0.0, 0.0, 0.0, 0.0};\n")
		 
			case else
				strcat(ProgramString, !"MOV aR1.a, {0.0, 0.0, 0.0, 0.0};\n")
				sprintf(ProgramString, !"%s# -%d\n", ProgramString, aB(Cycle))
			 
		end select
		strcat(ProgramString, !"SUB aR0.a, aR0.a, aR1.a;\n\n") 

		select case (aC(Cycle))
			case G_ACMUX_LOD_FRACTION:
				strcat(ProgramString, !"MOV R1.rgb, {0.0, 0.0, 0.0, 0.0};\n")	'// unemulated
			case G_ACMUX_TEXEL0:
				strcat(ProgramString, !"MOV aR1.a, Tex0.a;\n")
			case G_ACMUX_TEXEL1:
				strcat(ProgramString, !"MOV aR1.a, Tex1.a;\n")
			case G_ACMUX_PRIMITIVE:
				strcat(ProgramString, !"MOV aR1.a, PrimColor.a;\n")
			case G_ACMUX_SHADE:
				strcat(ProgramString, !"MOV aR1.a, Shade.a;\n")
			case G_ACMUX_ENVIRONMENT:
				strcat(ProgramString, !"MOV aR1.a, EnvColor.a;\n")
			case G_ACMUX_PRIM_LOD_FRAC:
				strcat(ProgramString, !"MOV aR1.a, PrimColorLOD.a;\n")
			case G_ACMUX_0:
				strcat(ProgramString, !"MOV aR1.a, {0.0, 0.0, 0.0, 0.0};\n")
			case else
				strcat(ProgramString, !"MOV aR1.a, {0.0, 0.0, 0.0, 0.0};\n")
				sprintf(ProgramString, !"%s# -%d\n", ProgramString, aC(Cycle))
		end select
		strcat(ProgramString, !"MUL aR0.a, aR0.a, aR1.a;\n\n")

		select case aD(Cycle)
			case G_ACMUX_COMBINED:
				strcat(ProgramString, !"MOV aR1.a, aComb.a;\n")
			case G_ACMUX_TEXEL0:
				strcat(ProgramString, !"MOV aR1.a, Tex0.a;\n")
			case G_ACMUX_TEXEL1:
				strcat(ProgramString, !"MOV aR1.a, Tex1.a;\n")
			case G_ACMUX_PRIMITIVE:
				strcat(ProgramString, !"MOV aR1.a, PrimColor.a;\n")
			case G_ACMUX_SHADE:
				strcat(ProgramString, !"MOV aR1.a, Shade.a;\n")
			case G_ACMUX_ENVIRONMENT:
				strcat(ProgramString, !"MOV aR1.a, EnvColor.a;\n")
			case G_ACMUX_1:
				strcat(ProgramString, !"MOV aR1.a, {1.0, 1.0, 1.0, 1.0};\n")			 
			case G_ACMUX_0:
				strcat(ProgramString, !"MOV aR1.a, {0.0, 0.0, 0.0, 0.0};\n")	 
			case else
				strcat(ProgramString, !"MOV aR1.a, {0.0, 0.0, 0.0, 0.0};\n")
				sprintf(ProgramString, !"%s# -%d\n", ProgramString, aD(Cycle))	 
		end select
		strcat(ProgramString, !"ADD aR0.a, aR0.a, aR1.a;\n\n") 

		strcat(ProgramString, !"MOV Comb.rgb, R0;\n")
		strcat(ProgramString, !"MOV aComb.a, aR0;\n\n")
	next	
		
		strcat(ProgramString, !"# Finish\n")
	        strcat(ProgramString, _
			!"MOV Comb.a, aComb.a;\n" _
			!"MOV Out, Comb;\n" _
			!"END\n")
		
		
	glGenProgramsARB(1, @FragmentCache(_System.FragCachePosition).ProgramID)
	glBindProgramARB(GL_FRAGMENT_PROGRAM_ARB, FragmentCache(_System.FragCachePosition).ProgramID)
	glProgramStringARB(GL_FRAGMENT_PROGRAM_ARB, GL_PROGRAM_FORMAT_ASCII_ARB, strlen(ProgramString), @ProgramString)

	FragmentCache(_System.FragCachePosition).Combiner0 = Cmb0
	FragmentCache(_System.FragCachePosition).Combiner1 = Cmb1
	_System.FragCachePosition+=1


	#if 0
	char temp[MAX_PATH];
	sprintf(temp, "combiner_%08X_%08X.txt", Cmb0, Cmb1);
	FILE *fp = fopen(temp, "w");

	char CombMsg[1024];
	sprintf(CombMsg, "----------------------------------------------------------------------------------------\n"
		"Color 0 = [(%s - %s) * %s] + %s\n"
		"Alpha 0 = [(%s - %s) * %s] + %s\n"
		"Color 1 = [(%s - %s) * %s] + %s\n"
		"Alpha 1 = [(%s - %s) * %s] + %s\n"
		"----------------------------------------------------------------------------------------\n",
		CombinerTypes16[cA[0]], CombinerTypes16[cB[0]], CombinerTypes32[cC[0]], CombinerTypes8[cD[0]],
		CombinerTypes8[aA[0]], CombinerTypes8[aB[0]], CombinerTypes8[aC[0]], CombinerTypes8[aD[0]],
		CombinerTypes16[cA[1]], CombinerTypes16[cB[1]], CombinerTypes32[cC[1]], CombinerTypes8[cD[1]],
		CombinerTypes8[aA[1]], CombinerTypes8[aB[1]], CombinerTypes8[aC[1]], CombinerTypes8[aD[1]]);
	fprintf(fp, CombMsg);

	fprintf(fp, ProgramString);

	fclose(fp);
	#endif


end sub



sub RDP_CheckFragmentCache() 

  Dim CacheCheck As Integer = 0
Dim SearchingCache As Boolean = True
Dim NewProg As Boolean = False


	do while (SearchingCache) 
		If (FragmentCache(CacheCheck).Combiner0 = Gfx.Combiner0) AndAlso (FragmentCache(CacheCheck).Combiner1 = Gfx.Combiner1) Then
		    SearchingCache = False
		    NewProg = False
		Else
		    If CacheCheck <> CACHE_FRAGMENT Then
			CacheCheck = CacheCheck + 1
		    Else
			SearchingCache = False
			NewProg = True
		    End If
		End If

	loop


glEnable(GL_FRAGMENT_PROGRAM_ARB)

	if(NewProg) then 
		 RDP_CreateCombinerProgram(Gfx.Combiner0, Gfx.Combiner1) 
	else
		 glBindProgramARB(GL_FRAGMENT_PROGRAM_ARB, FragmentCache(CacheCheck).ProgramID)
	end if
	
  If _System.FragCachePosition > CACHE_FRAGMENT Then
    Dim i As Integer = 0
    'Static As const __FragmentCache
    Static As  __FragmentCache FragmentCache_Empty = (0, 0, -1)
   
    
    For i = 0 To ArraySize(FragmentCache) - 1
         If OpenGL.Ext_FragmentProgram Then glDeleteProgramsARB(1, @FragmentCache(i).ProgramID)
        FragmentCache(i) = FragmentCache_Empty
    Next

    _System.FragCachePosition = 0
End If  
	

end sub



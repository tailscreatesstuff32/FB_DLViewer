'FINISHED/////////////////////////



#include "globals.bi"
#include "font.bi"

dim shared as zstring * 8192 TempString 

dim shared as ubyte FontWidths(128)

dim shared as double BGColor(4) => { 0.1f, 0.1f, 0.1f, 0.5f } 
dim shared as double FGColor(4) => { 1.0f, 1.0f, 1.0f, 1.0f } 

function hud_Init() as integer
 
 'WORKS//////
	memset(@FontWidths(0), 2, ubound(FontWidths)) 
	
	

		' dbgprintf(0, MSK_COLORTYPE_INFO,"%i", FontWidths(0))
	

	if(hud_LoadFontBuffer(@fontdata(0)) = 0)  then
		MSK_ConsolePrint(MSK_COLORTYPE_ERROR, !"- Error: Could not load font data!\n") 
		return EXIT_FAILURE 
	end if
 	

 	 
 

 	 
  
	if(glIsTexture(zHUD.TexID)) then glDeleteTextures(1, @zHUD.TexID)
	glGenTextures(1, @zHUD.TexID)

	glBindTexture(GL_TEXTURE_2D, zHUD.TexID)
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, zHUD._Width, zHUD._Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, zHUD._Image)

	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)

	memcpy(@zHUD.CharWidths(0), @FontWidths(0), ArraySize(FontWidths))


 	' dbgprintf(0, MSK_COLORTYPE_INFO,"tex id: %i", zHUD.TexID)
 	' dbgprintf(0, MSK_COLORTYPE_INFO,"width: %i", zHUD._width)
 	' dbgprintf(0, MSK_COLORTYPE_INFO,"height: %i", zHUD._height)
 	' dbgprintf(0, MSK_COLORTYPE_INFO,"plane: %i", zHUD.plane)
 	' dbgprintf(0, MSK_COLORTYPE_INFO,"BPP: %i", zHUD.BPP)
 	' dbgprintf(0, MSK_COLORTYPE_INFO,"charwidth: %i", zHUD.charwidths(0))

 	 	' do while getch() = 0
 	 
 	 
 	 
 	' loop
 	 


	hud_BuildFont()



	if(zHUD._Image <> NULL) then free(zHUD._Image)

	return EXIT_SUCCESS
 

end function


function hud_LoadFontBuffer(buffer as ubyte ptr) as boolean
	dim as integer ColorKey(3) => { &HFF,&H00, &HFF } 
	dim as integer WidthKey(3) => { &HFF, &HFF, &H00 }


'WORKS/////////////////
	dim as byte TempID(0 to ...) => { 0, 0, 0 } 
	
	memcpy(@TempID(0), @Buffer[0], 2)
	
	if strcmp(@TempID(0), "BM") then

		MSK_ConsolePrint(MSK_COLORTYPE_ERROR, !"- Error: Font data not in BMP format!\n")
		return false
	end if

	memcpy(@zHUD._Width, @Buffer[18], sizeof(integer))
	memcpy(@zHUD._Height, @Buffer[22], sizeof(integer))
	memcpy(@zHUD.Plane, @Buffer[26], sizeof(short))
	memcpy(@zHUD.BPP, @Buffer[28], sizeof(short))
	
	
	
	 zHUD._width = 128
         zHUD._Height = 64
         zHUD.Plane = 1
         zHUD.BPP = 24
         
	if(zHUD.BPP <> 24)  then
		MSK_ConsolePrint(MSK_COLORTYPE_ERROR, !"- Error: BMP data is not 24bpp!\n")
		return false
	end if

	 zHUD._Image = cast(ubyte ptr,malloc((sizeof(byte) * zHUD._Width * zHUD._Height * 4)) )
 
	
  
        dim as integer Size = zHUD._Width * zHUD._Height * (zHUD.BPP \ 8)
        
	dim as ubyte ptr TempImage = cast(ubyte ptr,malloc(size * sizeof(byte)))
 
	
 	if tempimage = NULL then
 	MSK_ConsolePrint(MSK_COLORTYPE_ERROR, !"- Error: Failed to allocate tempimage %i \n",sizeof(byte) )
 	else
  
 	end if
 	
  	
   ' MSK_ConsolePrint(MSK_COLORTYPE_ERROR, !"%i",(sizeof(byte) * zHUD._Width * zHUD._Height * 4)) 	
     '   do while getch() = 0 
	'loop
      

	memcpy(TempImage, @Buffer[54], Size)
 


	dim as integer BytesPx = zHUD.BPP \ 8
	

 
	
'////////////////////////////////////////////////



	dim as integer  X, Y, Y2: x = 0: Y = 0: Y2 = 0 
	dim as integer SrcOffset = 0



	Y =  zHUD._Height
        do while Y > 0
        x = 0
        do while X < (zHUD._Width * BytesPx) 
 
        
        if(	TempImage[((Y - 1) * zHUD._Width) * BytesPx + X + 2] = ColorKey(0) andalso TempImage[((Y - 1) * zHUD._Width) * BytesPx + X + 1] = ColorKey(1) andalso TempImage[((Y - 1) * zHUD._Width) * BytesPx + X + 0] = ColorKey(2)) then
				
		 
				zHUD._Image[SrcOffset + 3]	= 0 

			' // check for width marker color key (255, 255, 0)
			 elseif TempImage[((Y - 1) * zHUD._Width) * BytesPx + X + 2] = WidthKey(0) andalso TempImage[((Y - 1) * zHUD._Width) * BytesPx + X + 1] = WidthKey(1)  andalso TempImage[((Y - 1) * zHUD._Width) * BytesPx + X + 0] = WidthKey(2) then
 
				dim as integer CharNo = ((Y2 * zHUD._Width \ 8) \ 8) + ((X \ BytesPx) \ 8)
				dim as integer _Width = ((X \ BytesPx) - (((X \ BytesPx) \ 8) * 8)) + 1
				FontWidths(CharNo) = _Width

				zHUD._Image[SrcOffset + 3]	= 0
				
				else
                            zHUD._Image[SrcOffset + 3]	= &HFF
			end if  
        
        
        	' // copy image
			zHUD._Image[SrcOffset + 2]	= TempImage[((Y - 1) * zHUD._Width) * BytesPx + X + 0]
			zHUD._Image[SrcOffset + 1]	= TempImage[((Y - 1) * zHUD._Width) * BytesPx + X + 1]
			zHUD._Image[SrcOffset + 0]	= TempImage[((Y - 1) * zHUD._Width) * BytesPx + X + 2]
			SrcOffset += 4
        
        X += BytesPx
        loop
       Y2+=1 
       Y-=1 
        loop

	

	'  MSK_ConsolePrint(MSK_COLORTYPE_ERROR, !"%i",TempImage[24576]) 	
       'do while getch() = 0 
	' loop
      
  

	free(TempImage)
	

	return true
 
end function


sub hud_BuildFont()






 
 dim as integer i
	dim as double CharX, CharY







	zHUD.BaseDL = glGenLists(128)
	 glBindTexture(GL_TEXTURE_2D, zHUD.TexID)






	for i = 0 to 128 -1
 

		charx = cast(double ,i mod 16) / 16.0f
		chary = cast(double,i \ 16) /  8.0f
		

		glNewList(zHUD.BaseDL + i, GL_COMPILE) 
		 glBegin(GL_QUADS)
 	 			glTexCoord2f(CharX, CharY)
				glVertex2i(0, 0)
				glTexCoord2f(CharX + 0.0625f, CharY)
				glVertex2i(8, 0)
				glTexCoord2f(CharX + 0.0625f, CharY + 0.125f)
				glVertex2i(8, 8)
				glTexCoord2f(CharX, CharY + 0.125f)
				glVertex2i(0, 8)
				
 		glEnd()
			glTranslated(zHUD.CharWidths(i), 0, 0)
		glEndList()
	next
	
end sub



sub hud_Print cdecl (X as GLint,Y as  GLint,W as integer,H as integer,Scale as integer, Vis as double ,  _String as zstring ptr, ...)
  
  
        dim as zstring * 256 Text
	dim as cva_list argp
	if(_String = NULL) then  return
	cva_start(argp, _String)
	vsprintf(Text, _String, argp)
	cva_end(argp)

	dim as integer i, j
  
  	strcpy(TempString, Text)
  	dim as ubyte LineText(512,MAX_PATH)
  	dim as integer Lines, _width
  	dim as integer LineWidths(512)
  	
        memset(@LineText(0,0), &H00, ArraySize(LineText) + ubound(LineText,2)) 'not sure if need to add second dimmension size
	memset(@LineWidths(0), &H00, ArraySize(LineWidths))

  
         ' dbgprintf(0, MSK_COLORTYPE_INFO,"%s",str(ArraySize(LineText)))
  
  	dim as zstring ptr pch
  	pch = strtok(TempString, !"\n")
  		do while(pch <> NULL)
		strcpy( cast( zstring ptr,@LineText(Lines,0)), pch)
		Lines+=1
		pch = strtok(NULL, !"\n")
	        loop

  
  	dim as integer RectWidth = _width + 5
  	dim as integer RectHeight = (lines * 10) + 3
  
  	if(W <> -1) then RectWidth = W 
	if(H <> -1) then RectHeight = H 
  
 	if(X = -1) then  X = zProgram.WindowWidth - RectWidth
	if(Y = -1) then Y = zProgram.WindowHeight - RectHeight

	if(X + RectWidth > zProgram.WindowWidth) then  X -= RectWidth
	if(Y + RectHeight > zProgram.WindowHeight) then Y -= RectHeight

	scope
		glPushMatrix()
		glLoadIdentity()
		
		
		glScaled(Scale, Scale, Scale)
		glTranslated(X, Y, 0)

		if(RDP_OpenGL_ExtFragmentProgram()) then glDisable(GL_FRAGMENT_PROGRAM_ARB)		
		 
		 glDisable(GL_TEXTURE_GEN_S)
		 glDisable(GL_TEXTURE_GEN_T)
		 
	         glEnable(GL_BLEND)
		 glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
		 glDisable(GL_ALPHA_TEST)
		 
		 glDisable(GL_TEXTURE_2D)
		 glColor4f(BGColor(0), BGColor(1), BGColor(2), BGColor(3) * Vis)
		 glRectd(0, 0, RectWidth, RectHeight)
		 glEnable(GL_TEXTURE_2D)
		 
		 
		 glTranslated(3, 3, 0)
		glEnable(GL_TEXTURE_2D)
		glBindTexture(GL_TEXTURE_2D, zHUD.TexID)
		glListBase(zHUD.BaseDL - 32)
		 
		 
		 '//text
		 i=0
		 do while i < lines
		 dim as integer HorzCenter = 0
		 
		 select case LineText(i,0)
		 case &H80
		 	HorzCenter = (zProgram.WindowWidth \ 2) - (LineWidths(i) \ 2)
		 case &H90
		 	glColor4f(0.0f, 1.0f, 0.0f, FGColor(3) * Vis)
		 case &H91 
			glColor4f(1.0f, 0.5f, 0.0f,  FGColor(3) * Vis)		
		 case &H92 
			glColor4f(0.0f, 0.75f, 1.0f,  FGColor(3) * Vis)				 
		 case &HA0 
		       HorzCenter = (zProgram.WindowWidth \ 2) - (LineWidths(i) \ 2)
		       glColor4f(0.0f, 1.0f, 0.0f,  FGColor(3) * Vis)
		case &HA1 	 
		       HorzCenter = (zProgram.WindowWidth \ 2) - (LineWidths(i) \ 2)	
		       glColor4f(1.0f, 0.5f, 0.0f,  FGColor(3) * Vis)		
		case &HA2 			
		       HorzCenter = (zProgram.WindowWidth \ 2) - (LineWidths(i) \ 2) 
		       glColor4f(0.0f, 0.75f, 1.0f,  FGColor(3) * Vis)	
		case else 			
			glColor4f(FGColor(0),  FGColor(1),  FGColor(2),  FGColor(3) * Vis) 		
		end select
		glPushMatrix()
		glTranslated(HorzCenter, (i * 10), 0)	
		glCallLists(strlen(cast(zstring ptr,@LineText(i,0))), GL_BYTE, @LineText(i,0))	
		glPopMatrix()		
		 i+=1
		 loop
	        glPopMatrix()
	 
 
		
		glDisable(GL_TEXTURE_2D)
		glEnable(GL_ALPHA_TEST)
		glDisable(GL_BLEND)
		glPopMatrix()
	end scope 
	
end sub	




	
sub hud_KillFont()

	if(glIsList(zHUD.BaseDL)) then  glDeleteLists(zHUD.BaseDL, 256)

end sub

#include "globals.bi"
#include "misaka.bi"
 
 


Sub RDP_Dump_InitModelDumping(Path As ZString Ptr, ObjFilename As ZString Ptr, MtlFilename As ZString Ptr)
    Dim As ZString Ptr TempPath
  '  Dim As integer MAX_PATH = 260 ' Define MAX_PATH if not already defined

    TempPath = malloc(MAX_PATH)

    strcpy(_System.WavefrontObjPath, Path)

    strcpy(TempPath, Path)
    strcat(TempPath, "/")
    strcat(TempPath, ObjFilename)
    _System.FileWavefrontObj = NULL
    _System.FileWavefrontObj = fopen(TempPath, "w")

    strcpy(TempPath, Path)
    strcat(TempPath, "/")
    strcat(TempPath, MtlFilename)
    _System.FileWavefrontMtl = NULL
    _System.FileWavefrontMtl = fopen(TempPath, "w")

    If _System.FileWavefrontObj = 0 Orelse _System.FileWavefrontMtl = 0 Then
        Return
    End If

    fprintf(_System.FileWavefrontObj, !"# dumped via libbadRDP\n\n")
    fprintf(_System.FileWavefrontObj, !"mtllib %s\n\n", MtlFilename)

      fprintf(_System.FileWavefrontObj, !"# dumped via libbadRDP\n\n")

    _System.WavefrontObjVertCount = 1
    _System.WavefrontObjMaterialCnt = 1

    _System.ObjDumpingEnabled = True

    free(TempPath)
 
 
end sub

Sub RDP_Dump_DumpTriangle (Vtx As __Vertex Ptr, VtxID As integer Ptr)
	if(_System.FileWavefrontObj = 0 orelse _System.FileWavefrontMtl = 0 orelse _System.ObjDumpingEnabled = 0) then return

	dim as single vtS, vtT,vtS2,vtT2


    




	dim as integer i = 0
	for i as integer = 0 to 3 - 1
		vtS = Vtx[VtxID[i]].RealS0
		vtT = -Vtx[VtxID[i]].RealT0
        	vtS2 = Vtx[VtxID[i]].RealS1
	     	vtT2 = -Vtx[VtxID[i]].RealT1
		 if IsInfinite(vtS) then vtS = 0.0f
		 if IsInfinite(vtT) then vtT = 0.0f
		if(Texture(0).CMS = G_TX_MIRROR) then vtS = vtS/2
		if(Texture(0).CMT = G_TX_MIRROR) then vtT = vtT/2

        'msk_consoleprint(1,"X: %hi", Vertex(VtxID[i]).Vtx.X )
      '  msk_consoleprint(1,"Y: %hi", Vertex(VtxID[i]).Vtx.Y )
       ' msk_consoleprint(1,"Z: %hi", Vertex(VtxID[i]).Vtx.Z ) 
       ' msk_consoleprint(1,"W: %hi", Vertex(Vtxs[i]).Vtx.W )
	       fprintf(_System.FileWavefrontObj, !"v %4.8f %4.8f %4.8f\n", cast(integer,Vtx[VtxID[i]].Vtx.X) / 32.0f, cast(integer,Vtx[VtxID[i]].Vtx.Y) / 32.0f, cast(integer,Vtx[VtxID[i]].Vtx.Z) / 32.0f)
		  
	      ' fprintf(_System.FileWavefrontObj, !"v %hi %hi %hi\n",Vtx[VtxID[i]].Vtx.X, Vtx[VtxID[i]].Vtx.Y , Vtx[VtxID[i]].Vtx.Z)
          ' fprintf(_System.FileWavefrontObj, !"vt %4.8f %4.8f\n", vtS2, vtT2)
           fprintf(_System.FileWavefrontObj, !"vt %4.8f %4.8f\n", vtS, vtT)
           
		  fprintf(_System.FileWavefrontObj, !"vn %4.8f %4.8f %4.8f\n",cast(single,Vtx[VtxID[i]].Vtx.R),cast(single,Vtx[VtxID[i]].Vtx.G),cast(single,Vtx[VtxID[i]].Vtx.B))
	next



 fprintf(_System.FileWavefrontObj, !"f %d/%d %d/%d %d/%d\n\n", _
	 	_System.WavefrontObjVertCount, _System.WavefrontObjVertCount, _
	 	_System.WavefrontObjVertCount + 1, _System.WavefrontObjVertCount + 1, _
	 	_System.WavefrontObjVertCount + 2, _System.WavefrontObjVertCount + 2)


	' fprintf(_System.FileWavefrontObj, !"f %d/%d/%d %d/%d/%d %d/%d/%d\n\n", _
	' 	_System.WavefrontObjVertCount, _System.WavefrontObjVertCount, _System.WavefrontObjVertCount, _
	' 	_System.WavefrontObjVertCount + 1, _System.WavefrontObjVertCount + 1, _System.WavefrontObjVertCount + 1, _
	' 	_System.WavefrontObjVertCount + 2, _System.WavefrontObjVertCount + 2, _System.WavefrontObjVertCount + 2)

	_System.WavefrontObjVertCount += 3

end sub

Function RDP_Dump_CreateMaterial(TextureData As UByte Ptr, TexFormat As UByte, TexOffset As Uinteger, _Width As integer, _Height As integer, SMirror As Boolean, TMirror As Boolean) As integer

	If _System.FileWavefrontObj = NULL Orelse _System.FileWavefrontMtl = NULL Orelse _System.ObjDumpingEnabled = NULL Then Return EXIT_FAILURE

	If _System.FileWavefrontObj = NULL OrElse _System.FileWavefrontMtl = NULL OrElse   _System.ObjDumpingEnabled = NULL Then Return EXIT_FAILURE

	Dim As ZString * MAX_PATH TextureFilename
	

 
	sprintf(TextureFilename, !"texture_0x%08X_fmt0x%02X%s.png", TexOffset, TexFormat, IIf(SMirror Andalso TMirror, ".stmirror", "") , IIf(SMirror, ".smirror", "") , IIf(TMirror, ".tmirror", ""))
 

 Dim As ZString * MAX_PATH TexturePath
	sprintf(TexturePath, !"%s//%s", _System.WavefrontObjPath, TextureFilename)

	RDP_Dump_SavePNG(TextureData, _Width, _Height, TexturePath, SMirror, TMirror)

	fprintf(_System.FileWavefrontMtl, !"newmtl material_%d\n", _System.WavefrontObjMaterialCnt)
	fprintf(_System.FileWavefrontMtl, !"Ka 0.2000 0.2000 0.2000\n")
	fprintf(_System.FileWavefrontMtl, !"Kd 0.8000 0.8000 0.8000\n")
	fprintf(_System.FileWavefrontMtl, !"illum 1\n")
	fprintf(_System.FileWavefrontMtl, !"map_Kd %s\n", TextureFilename)
	fprintf(_System.FileWavefrontMtl, !"#%s%s%s\n", IIf(SMirror, "horz. mirror", "horz nope") , IIf(TMirror, "/vert. mirror", "/vert nope"), IIf(SMirror OrElse TMirror, !"\n", ""))

	_System.WavefrontObjMaterialCnt += 1

	Return _System.WavefrontObjMaterialCnt - 1
end function

Sub RDP_Dump_StopModelDumping()
	if  _System.FileWavefrontObj  then fclose(_System.FileWavefrontObj)
        if    _System.FileWavefrontMtl  then fclose(_System.FileWavefrontMtl)

	_System.ObjDumpingEnabled = false
end sub

sub RDP_Dump_BeginGroup(Address as uinteger)
 
	if( _System.FileWavefrontObj = 0 orelse _System.FileWavefrontMtl  = 0 orelse _System.ObjDumpingEnabled = 0) then return

	fprintf(_System.FileWavefrontObj, !"g DList_%08X\n", Address)
end sub

Function RDP_Dump_SavePNG(Buffer As UByte Ptr, _Width As integer, _Height As integer, ByRef Filename As ZString Ptr, SMirror As Boolean, TMirror As Boolean) As integer
    Dim x As integer, y As integer, x2 As integer, y2 As integer
    Dim mirrored As UByte Ptr = NULL
    
    Dim png_ptr As png_structp
    Dim info_ptr As png_infop
    
' horz\vert mirror
If SMirror Andalso TMirror Then
    _width *= 2
    _height *= 2
    mirrored = cast(ubyte ptr,malloc(_Height*_Width*4))
    MemSet(mirrored, &HFF, _height * _width * 4)
    
for y = 0 to _Height - 1
    memcpy(@mirrored[y * _Width * 4], @Buffer[(y * _Width / 2) * 4], _Width / 2 * 4)
    x2 = (_Width / 2) - 1
    for x = 0 to (_Width / 2) - 1
 
	mirrored[(y*_Width*4)+(_Width/2*4)+(x*4)]   = Buffer[((y-1)*_Width/2*4)+(_Width/2*4)+(x2*4)]
	mirrored[(y*_Width*4)+(_Width/2*4)+(x*4)+1] = Buffer[((y-1)*_Width/2*4)+(_Width/2*4)+(x2*4)+1]
	mirrored[(y*_Width*4)+(_Width/2*4)+(x*4)+2] = Buffer[((y-1)*_Width/2*4)+(_Width/2*4)+(x2*4)+2]
	mirrored[(y*_Width*4)+(_Width/2*4)+(x*4)+3] = Buffer[((y-1)*_Width/2*4)+(_Width/2*4)+(x2*4)+3]
	x2-=1

     
    next
next
    
    y2 = _height / 2
    For y = _height / 2 To _height - 1
        y2 -= 1
            memcpy(@mirrored[y * _Width * 4], @Buffer[(y2 * _Width / 2) * 4], _Width / 2 * 4)
        x2 = (_Width / 2) - 1
          for x = 0 to (_Width / 2) - 1
 
	mirrored[(y*_Width*4)+(_Width/2*4)+(x*4)]   = Buffer[((y2-1)*_Width/2*4)+(_Width/2*4)+(x2*4)]
	mirrored[(y*_Width*4)+(_Width/2*4)+(x*4)+1] = Buffer[((y2-1)*_Width/2*4)+(_Width/2*4)+(x2*4)+1]
	mirrored[(y*_Width*4)+(_Width/2*4)+(x*4)+2] = Buffer[((y2-1)*_Width/2*4)+(_Width/2*4)+(x2*4)+2]
	mirrored[(y*_Width*4)+(_Width/2*4)+(x*4)+3] = Buffer[((y2-1)*_Width/2*4)+(_Width/2*4)+(x2*4)+3]
	x2-=1
        Next x
    Next y

 
 ' horz mirror
ElseIf SMirror Then
	/'	_Width *= 2
		mirrored = cast(ubyte ptr,malloc(_Height*_Width*4))
		memset(mirrored, &HFF, _Height*_Width*4)
		for y = 0 to _Height - 1
			memcpy(@mirrored[y*_Width*4], @Buffer[y*_Width\2*4], _Width\2*4)
			x2 = (_Width\2)-1
			for x = 0 to _width \ 2 
				mirrored[(y*_Width*4)+(_Width\2*4)+(x*4)]   = Buffer[((y-1)*_Width\2*4)+(_Width\2*4)+(x2*4)]
				mirrored[(y*_Width*4)+(_Width\2*4)+(x*4)+1] = Buffer[((y-1)*_Width\2*4)+(_Width\2*4)+(x2*4)+1]
				mirrored[(y*_Width*4)+(_Width\2*4)+(x*4)+2] = Buffer[((y-1)*_Width\2*4)+(_Width\2*4)+(x2*4)+2]
				mirrored[(y*_Width*4)+(_Width\2*4)+(x*4)+3] = Buffer[((y-1)*_Width\2*4)+(_Width\2*4)+(x2*4)+3]
				x2-=1
			next
		next '/
_Width *= 2
mirrored = cast(ubyte ptr, malloc(_Height * _Width * 4))
memset(mirrored, &HFF, _Height * _Width * 4)

for y = 0 to _Height - 1
    memcpy(@mirrored[y * _Width * 4], @Buffer[(y * _Width / 2) * 4], _Width / 2 * 4)
    x2 = (_Width / 2) - 1
    for x = 0 to (_Width / 2) - 1
 
	mirrored[(y*_Width*4)+(_Width/2*4)+(x*4)]   = Buffer[((y-1)*_Width/2*4)+(_Width/2*4)+(x2*4)]
	mirrored[(y*_Width*4)+(_Width/2*4)+(x*4)+1] = Buffer[((y-1)*_Width/2*4)+(_Width/2*4)+(x2*4)+1]
	mirrored[(y*_Width*4)+(_Width/2*4)+(x*4)+2] = Buffer[((y-1)*_Width/2*4)+(_Width/2*4)+(x2*4)+2]
	mirrored[(y*_Width*4)+(_Width/2*4)+(x*4)+3] = Buffer[((y-1)*_Width/2*4)+(_Width/2*4)+(x2*4)+3]
	x2-=1

     
    next
next
    
    ' vert mirror
    ElseIf TMirror Then
        _Height *= 2
        mirrored = malloc(_Height * _Width * 4)
        MemSet(mirrored, &HFF, _Height * _Width * 4)
        For y = 0 To _Height \ 2 - 1
            MemCpy(mirrored + y * _Width * 4, Buffer + y * _Width * 4, _Width * 4)
        Next y
        y2 = _Height \ 2
        For y = _Height \ 2 To _Height - 1
        y2 -=1
            MemCpy(mirrored + y * _Width * 4, Buffer + (y2) * _Width * 4, _Width * 4)
        Next y
    End If  
    
    Dim _file As File ptr = fopen(Filename, "wb")
    if( _file = NULL) then  return EXIT_FAILURE
    
    png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL)
    info_ptr = png_create_info_struct(png_ptr)
    setjmp(png_jmpbuf(png_ptr))
    
    png_init_io(png_ptr, _file)
    
    png_set_IHDR(png_ptr, info_ptr, _Width, _Height, 8, PNG_COLOR_TYPE_RGB_ALPHA, PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE)
    png_set_packing(png_ptr)
    
    png_write_info(png_ptr, info_ptr)
    
    Dim row_pointers As png_byte Ptr Ptr = NULL
    row_pointers = malloc(_Height * SizeOf(png_byte Ptr))
    
    ' mirrored texture
    If SMirror Orelse TMirror Then
        For y = 0 To _Height - 1
            row_pointers[y] = mirrored + (y * _Width * 4)
        Next y
    
    ' normal texture
    Else
        For y = 0 To _Height - 1
            row_pointers[y] = Buffer + (y * _Width * 4)
        Next y
    End If
    
    png_set_rows(png_ptr, info_ptr, row_pointers)
    png_write_image(png_ptr, row_pointers)
    png_write_end(png_ptr, info_ptr)
    
	free(row_pointers)

	free(mirrored)

    
    png_destroy_write_struct(@png_ptr, @info_ptr)
    
    fClose(_file)
    
    Return 0
End Function 


/' Function RDP_Dump_SavePNG(Buffer As UByte Ptr, _Width As integer, _Height As integer, ByRef Filename As ZString Ptr, SMirror As Boolean, TMirror As Boolean) As integer
    Dim x As integer, y As integer, x2 As integer, y2 As integer
    Dim mirrored As UByte Ptr = NULL
    
    Dim png_ptr As png_structp
    Dim info_ptr As png_infop
    
    ' horz\vert mirror
    If SMirror Andalso TMirror Then
        _Width *= 2
        _Height *= 2
        mirrored = malloc(_Height * _Width * 4)
        MemSet(mirrored, &HFF, _Height * _Width * 4)
        For y = 0 To _Height \ 2 - 1
            MemCpy(mirrored + y * _Width * 4, Buffer + y * (_Width \ 2) * 4, _Width * 4)
            x2 = _Width \ 2 - 1
            For x = 0 To _Width \ 2 - 1
                mirrored[y * _Width * 4 + (_Width \ 2) * 4 + x * 4] = Buffer[(y - 1) * (_Width \ 2) * 4 + (_Width \ 2) * 4 + x2 * 4]
                mirrored[y * _Width * 4 + (_Width \ 2) * 4 + x * 4 + 1] = Buffer[(y - 1) * (_Width \ 2) * 4 + (_Width \ 2) * 4 + x2 * 4 + 1]
                mirrored[y * _Width * 4 + (_Width \ 2) * 4 + x * 4 + 2] = Buffer[(y - 1) * (_Width \ 2) * 4 + (_Width \ 2) * 4 + x2 * 4 + 2]
                mirrored[y * _Width * 4 + (_Width \ 2) * 4 + x * 4 + 3] = Buffer[(y - 1) * (_Width \ 2) * 4 + (_Width \ 2) * 4 + x2 * 4 + 3]
                x2 -= 1
            Next x
        Next y
        y2 = _Height \ 2
        For y = _Height \ 2 To _Height - 1
            y2 -= 1
            MemCpy(mirrored + y * _Width * 4, Buffer + y2 * (_Width \ 2) * 4, _Width * 4)
            x2 = _Width \ 2 - 1
            For x = 0 To _Width \ 2 - 1
                mirrored[y * _Width * 4 + (_Width \ 2) * 4 + x * 4] = Buffer[(y2 - 1) * (_Width \ 2) * 4 + (_Width \ 2) * 4 + x2 * 4]
                mirrored[y * _Width * 4 + (_Width \ 2) * 4 + x * 4 + 1] = Buffer[(y2 - 1) * (_Width \ 2) * 4 + (_Width \ 2) * 4 + x2 * 4 + 1]
                mirrored[y * _Width * 4 + (_Width \ 2) * 4 + x * 4 + 2] = Buffer[(y2 - 1) * (_Width \ 2) * 4 + (_Width \ 2) * 4 + x2 * 4 + 2]
                mirrored[y * _Width * 4 + (_Width \ 2) * 4 + x * 4 + 3] = Buffer[(y2 - 1) * (_Width \ 2) * 4 + (_Width \ 2) * 4 + x2 * 4 + 3]
                x2 -= 1
            Next x
        Next y
    ' horz mirror
    ElseIf SMirror Then
        _Width *= 2
        mirrored = malloc(_Height * _Width * 4)
        MemSet(mirrored, &HFF, _Height * _Width * 4)
        For y = 0 To _Height - 1
            MemCpy(mirrored + y * _Width * 4, Buffer + y * (_Width \ 2) * 4, (_Width \ 2) * 4)
            x2 = _Width \ 2 - 1
            For x = 0 To _Width \ 2 - 1
                mirrored[y * _Width * 4 + (_Width \ 2) * 4 + x * 4] = Buffer[(y - 1) * (_Width \ 2) * 4 + (_Width \ 2) * 4 + x2 * 4]
                mirrored[y * _Width * 4 + (_Width \ 2) * 4 + x * 4 + 1] = Buffer[(y - 1) * (_Width \ 2) * 4 + (_Width \ 2) * 4 + x2 * 4 + 1]
                mirrored[y * _Width * 4 + (_Width \ 2) * 4 + x * 4 + 2] = Buffer[(y - 1) * (_Width \ 2) * 4 + (_Width \ 2) * 4 + x2 * 4 + 2]
                mirrored[y * _Width * 4 + (_Width \ 2) * 4 + x * 4 + 3] = Buffer[(y - 1) * (_Width \ 2) * 4 + (_Width \ 2) * 4 + x2 * 4 + 3]
                x2 -= 1
            Next x
        Next y
    ' vert mirror
    ElseIf TMirror Then
        _Height *= 2
        mirrored = malloc(_Height * _Width * 4)
        MemSet(mirrored, &HFF, _Height * _Width * 4)
        For y = 0 To _Height \ 2 - 1
            MemCpy(mirrored + y * _Width * 4, Buffer + y * _Width * 4, _Width * 4)
        Next y
        y2 = _Height \ 2
        For y = _Height \ 2 To _Height - 1
            y2 -= 1
            MemCpy(mirrored + y * _Width * 4, Buffer + y2 * _Width * 4, _Width * 4)
        Next y
    End If
    
    Dim _file As File ptr = fopen(Filename, "wb")
    if( _file = NULL) then  return EXIT_FAILURE
    
    png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL)
    info_ptr = png_create_info_struct(png_ptr)
    setjmp(png_jmpbuf(png_ptr))
    
    png_init_io(png_ptr, _file)
    
    png_set_IHDR(png_ptr, info_ptr, _Width, _Height, 8, PNG_COLOR_TYPE_RGB_ALPHA, PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE)
    png_set_packing(png_ptr)
    
    png_write_info(png_ptr, info_ptr)
    
    Dim row_pointers As png_byte Ptr Ptr = NULL
    row_pointers = malloc(_Height * SizeOf(png_byte Ptr))
    
    ' mirrored texture
    If SMirror Or TMirror Then
        For y = 0 To _Height - 1
            row_pointers[y] = mirrored + (y * _Width * 4)
        Next y
    ' normal texture
    Else
        For y = 0 To _Height - 1
            row_pointers[y] = Buffer + (y * _Width * 4)
        Next y
    End If
    
    png_set_rows(png_ptr, info_ptr, row_pointers)
    png_write_image(png_ptr, row_pointers)
    png_write_end(png_ptr, info_ptr)
    
    free(row_pointers)
    free(mirrored)
    
    png_destroy_write_struct(@png_ptr, @info_ptr)
    
    fclose(_file)
    
    Return 0
End Function '/
 


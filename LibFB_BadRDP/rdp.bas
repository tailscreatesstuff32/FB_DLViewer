
#include "globals.bi"
#include "misaka.bi"


sub RDP_UnemulatedCmd()
 
	'// simulate ENDDL to break out of DList
 '//	Gfx.DLStackPos-=1
'//	DListAddress = Gfx.DLStack?(Gfx.DLStackPos)
end sub


Sub RDP_G_TEXRECT()
msk_consoleprint(0,"G_TEXRECT")
End Sub

Sub RDP_G_TEXRECTFLIP()
msk_consoleprint(0,"G_G_TEXRECTFLIP")

End Sub

Sub RDP_G_RDPLOADSYNC()
msk_consoleprint(0,"G_RDPLOADSYNC")
End Sub

Sub RDP_G_RDPPIPESYNC()

msk_consoleprint(0,"G_RDPTILESYNC")

End Sub

Sub RDP_G_RDPTILESYNC()
msk_consoleprint(0,"G_RDPTILESYNC")
End Sub

Sub RDP_G_RDPFULLSYNC()
msk_consoleprint(0,"G_RDPFULLSYNC")
End Sub

Sub RDP_G_SETKEYGB()
msk_consoleprint(0,"G_SETKEYGB")
End Sub

Sub RDP_G_SETKEYR()
msk_consoleprint(0,"G_SETKEYR")
End Sub

Sub RDP_G_SETCONVERT()
msk_consoleprint(0,"G_SETCONVERT")
End Sub

Sub RDP_G_SETSCISSOR()
msk_consoleprint(0,"G_SETSCISSOR")
End Sub

Sub RDP_G_SETPRIMDEPTH()
msk_consoleprint(0,"G_SETPRIMDEPTH")
End Sub

Sub RDP_G_RDPSETOTHERMODE()
msk_consoleprint(0,"G_RDPSETOTHERMODE")
End Sub

Sub RDP_G_LOADTLUT()
msk_consoleprint(0,"G_LOADTLUT")
End Sub

Sub RDP_G_SETTILESIZE()
msk_consoleprint(0,"G_SETTILESIZE")
End Sub

Sub RDP_G_LOADBLOCK()
msk_consoleprint(0,"G_LOADBLOCK")
End Sub

Sub RDP_G_LOADTILE()
msk_consoleprint(0,"G_LOADTILE")
End Sub

Sub RDP_G_SETTILE()
msk_consoleprint(0,"G_SETTILE")
End Sub

Sub RDP_G_FILLRECT()
msk_consoleprint(0,"G_FILLRECT")
End Sub

Sub RDP_G_SETFILLCOLOR()
msk_consoleprint(0,"G_SETFILLCOLOR")
End Sub

Sub RDP_G_SETFOGCOLOR()
msk_consoleprint(0,"G_SETFOGCOLOR")
End Sub

Sub RDP_G_SETBLENDCOLOR()
msk_consoleprint(0,"G_SETBLENDCOLOR")
End Sub

Sub RDP_G_SETPRIMCOLOR()
msk_consoleprint(0,"G_SETPRIMCOLOR")
End Sub

Sub RDP_G_SETENVCOLOR()
msk_consoleprint(0,"G_SETENVCOLOR")
End Sub

Sub RDP_G_SETCOMBINE()
msk_consoleprint(0,"G_SETCOMBINE")
End Sub

Sub RDP_G_SETTIMG()
msk_consoleprint(0,"G_SETTIMG")
gDP_SetTImg(w0, w1)

End Sub

Sub RDP_G_SETZIMG()
End Sub

Sub RDP_G_SETCIMG()
End Sub


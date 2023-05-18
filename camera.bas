'FINISHED/////////////////////////////////////


#include "globals.bi"

 sub ca_Reset()
 
	zCamera.AngleX = 0.0f: zCamera.AngleY = 0.0f 
	zCamera.X = 0.0f: zCamera.Y = 1.0f: zCamera.Z = 5.0f
	zCamera.LX = 0.0f: zCamera.LY = -0.4f: zCamera.LZ = -1.0f

	ca_Orientation(zCamera.AngleX, zCamera.AngleY)
end sub

  sub ca_Orientation(Ang as double , Ang2  as double )
 
	zCamera.LX = sin(Ang)
	zCamera.LY = Ang2
	zCamera.LZ = -cos(Ang)
end sub

sub ca_Movement(Strafe as boolean,Speed as double )
 
	if(Strafe = 0) then
		zCamera.X += zCamera.LX * 0.025f * Speed
		zCamera.Y += zCamera.LY * 0.025f * Speed
		zCamera.Z += zCamera.LZ * 0.025f * Speed
	 else  
		zCamera.X += cos(zCamera.AngleX) * (0.025f * Speed)
		zCamera.Z += sin(zCamera.AngleX) * (0.025f * Speed)
	end if
end sub

sub ca_MouseMove(x as integer, y as integer)
 
	zProgram.MousePosX = x - zProgram.MouseCenterX
	zProgram.MousePosY = y - zProgram.MouseCenterY

	zCamera.AngleX = zCamera.AngleX + (0.01f * zProgram.MousePosX)
	zCamera.AngleY = zCamera.AngleY - (0.01f * zProgram.MousePosY)

	zProgram.MouseCenterX = x
	zProgram.MouseCenterY = y
end sub

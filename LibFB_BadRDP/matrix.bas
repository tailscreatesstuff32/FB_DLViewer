#include "globals.bi"
sub RDP_Matrix_MulMatrices(Src1 as single ptr ,Src2 as single ptr  ,Target as single ptr )

end sub 

sub RDP_Matrix_ModelviewMul(Mat As Single Ptr)


end sub


Sub RDP_Matrix_ModelviewLoad(Mat As Single Ptr)


end sub


Sub RDP_Matrix_ProjectionLoad(Mat As Single Ptr)
	memcpy(@Matrix.Proj(0,0), Mat, 64)

	glMatrixMode(GL_PROJECTION)
	'glLoadMatrixf(*Matrix.Proj(0,0))

	Gfx.Update or= CHANGED_MULT_MAT
end sub

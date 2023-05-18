
#include "globals.bi"
 



 function ms_GetScreenCoords(SceneX as single,SceneY  as single, SceneZ  as single) as __Vect3D
 	dim as __Vect3D RetVect
	dim as GLdouble ModelM(16), ProjM(16), _Pos(3)
	dim as integer Viewp(4)

	glPushMatrix()
		glLoadIdentity()
		gl_SetupScene3D(zProgram.WindowWidth, zProgram.WindowHeight)
		gl_LookAt(zCamera.X, zCamera.Y, zCamera.Z, zCamera.X + zCamera.LX, zCamera.Y + zCamera.LY, zCamera.Z + zCamera.LZ)
		glScalef(0.005, 0.005, 0.005)

		glGetDoublev(GL_MODELVIEW_MATRIX, @ModelM(0))
		glGetDoublev(GL_PROJECTION_MATRIX, @ProjM(0))
		glGetIntegerv(GL_VIEWPORT, cast(glint ptr,@Viewp(0)))

		_gluProject(cast(GLdouble,SceneX), cast(GLdouble,SceneY), cast(GLdouble,SceneZ), @ModelM(0), @ProjM(0),cast(GLint ptr,@Viewp(0)),@_Pos(0),@_Pos(1),@_Pos(2))

		_Pos(1) = cast(GLdouble,Viewp(3)) - cast(GLdouble,_Pos(1)) - 1

		RetVect.X = cast(integer,_Pos(0))
		RetVect.Y = cast(integer,_Pos(1))
		RetVect.Z = cast(integer,_Pos(2))

		gl_SetupScene2D(zProgram.WindowWidth, zProgram.WindowHeight)
	glPopMatrix()

	return RetVect
 end function
 
function ms_GetSceneCoords(MousePosX as integer, MousePosY as integer) as __Vect3D
	dim as __Vect3D RetVect
	dim as single x,y,z 
	dim as GLdouble ModelM(16), ProjM(16), _Pos(3)
	dim as integer Viewp(4)
	
	glPushMatrix()
		glLoadIdentity()
		gl_SetupScene3D(zProgram.WindowWidth, zProgram.WindowHeight)
		gl_LookAt(zCamera.X, zCamera.Y, zCamera.Z, zCamera.X + zCamera.LX, zCamera.Y + zCamera.LY, zCamera.Z + zCamera.LZ)
		glScalef(0.005, 0.005, 0.005)

		glGetDoublev(GL_MODELVIEW_MATRIX, @ModelM(0))
		glGetDoublev(GL_PROJECTION_MATRIX, @ProjM(0))
		glGetIntegerv(GL_VIEWPORT, cast(glint ptr,@Viewp(0)))
		
		
		X = cast(single, MousePosX)
		Y = cast(single,Viewp(3) - MousePosY)
		glReadPixels(MousePosX, cast(integer,y), 1, 1, GL_DEPTH_COMPONENT, GL_FLOAT, @Z)
		_gluUnProject(cast(GLdouble,X), cast(GLdouble,Y),cast(GLdouble,Z), @ModelM(0), @ProjM(0),cast(GLint ptr,@Viewp(0)),@_Pos(0),@_Pos(1),@_Pos(2))

		
		RetVect.X = cast(integer,_Pos(0))
		RetVect.Y = cast(integer,_Pos(1))
		RetVect.Z = cast(integer,_Pos(2))

		gl_SetupScene2D(zProgram.WindowWidth, zProgram.WindowHeight)
	glPopMatrix()
 end function
 
 'static void 
sub  __gluMultMatricesd(a as const GLdouble ptr ,b as const GLdouble ptr, _
				r as GLdouble ptr)
    dim as integer i, j

    for i = 0 to 4 - 1
	for j = 0 to 4 - 1
	    r[i*4+j] = _
		a[i*4+0]*b[0*4+j] + _
		a[i*4+1]*b[1*4+j] + _
		a[i*4+2]*b[2*4+j] + _
		a[i*4+3]*b[3*4+j]
	next
   next
				
				
end sub				
				
 
 ' static void 
sub __gluMultMatrixVecd(matrix as const GLdouble ptr,_in as GLdouble ptr, _
		      _out as GLdouble ptr)
   dim as  integer i

    for i = 0 to 4-1
	_out[i] = _
	    _in[0] * matrix[0*4+i] + _
	    _in[1] * matrix[1*4+i] + _
	    _in[2] * matrix[2*4+i] + _ 
	    _in[3] * matrix[3*4+i] 
    next	      
		      
		     
end sub
 
 ' static int
 function __gluInvertMatrixd(m as const GLdouble ptr,invOut as GLdouble ptr) as integer
    dim as  double inv(16), det 
  dim as integer i

    inv(0) =   m[5]*m[10]*m[15] - m[5]*m[11]*m[14] - m[9]*m[6]*m[15] _
             + m[9]*m[7]*m[14] + m[13]*m[6]*m[11] - m[13]*m[7]*m[10]
    inv(4) =  -m[4]*m[10]*m[15] + m[4]*m[11]*m[14] + m[8]*m[6]*m[15]  _
             - m[8]*m[7]*m[14] - m[12]*m[6]*m[11] + m[12]*m[7]*m[10]
    inv(8) =   m[4]*m[9]*m[15] - m[4]*m[11]*m[13] - m[8]*m[5]*m[15]  _
             + m[8]*m[7]*m[13] + m[12]*m[5]*m[11] - m[12]*m[7]*m[9]
    inv(12) = -m[4]*m[9]*m[14] + m[4]*m[10]*m[13] + m[8]*m[5]*m[14]  _
             - m[8]*m[6]*m[13] - m[12]*m[5]*m[10] + m[12]*m[6]*m[9]
    inv(1) =  -m[1]*m[10]*m[15] + m[1]*m[11]*m[14] + m[9]*m[2]*m[15]  _
             - m[9]*m[3]*m[14] - m[13]*m[2]*m[11] + m[13]*m[3]*m[10]
    inv(5) =   m[0]*m[10]*m[15] - m[0]*m[11]*m[14] - m[8]*m[2]*m[15]  _
             + m[8]*m[3]*m[14] + m[12]*m[2]*m[11] - m[12]*m[3]*m[10]
    inv(9) =  -m[0]*m[9]*m[15] + m[0]*m[11]*m[13] + m[8]*m[1]*m[15] _
             - m[8]*m[3]*m[13] - m[12]*m[1]*m[11] + m[12]*m[3]*m[9]
    inv(13) =  m[0]*m[9]*m[14] - m[0]*m[10]*m[13] - m[8]*m[1]*m[14] _
             + m[8]*m[2]*m[13] + m[12]*m[1]*m[10] - m[12]*m[2]*m[9]
    inv(2) =   m[1]*m[6]*m[15] - m[1]*m[7]*m[14] - m[5]*m[2]*m[15] _
             + m[5]*m[3]*m[14] + m[13]*m[2]*m[7] - m[13]*m[3]*m[6]
    inv(6) =  -m[0]*m[6]*m[15] + m[0]*m[7]*m[14] + m[4]*m[2]*m[15] _
             - m[4]*m[3]*m[14] - m[12]*m[2]*m[7] + m[12]*m[3]*m[6]
    inv(10) =  m[0]*m[5]*m[15] - m[0]*m[7]*m[13] - m[4]*m[1]*m[15] _
             + m[4]*m[3]*m[13] + m[12]*m[1]*m[7] - m[12]*m[3]*m[5]
    inv(14) = -m[0]*m[5]*m[14] + m[0]*m[6]*m[13] + m[4]*m[1]*m[14] _
             - m[4]*m[2]*m[13] - m[12]*m[1]*m[6] + m[12]*m[2]*m[5]
    inv(3) =  -m[1]*m[6]*m[11] + m[1]*m[7]*m[10] + m[5]*m[2]*m[11] _
             - m[5]*m[3]*m[10] - m[9]*m[2]*m[7] + m[9]*m[3]*m[6]
    inv(7) =   m[0]*m[6]*m[11] - m[0]*m[7]*m[10] - m[4]*m[2]*m[11] _
             + m[4]*m[3]*m[10] + m[8]*m[2]*m[7] - m[8]*m[3]*m[6]
    inv(11) = -m[0]*m[5]*m[11] + m[0]*m[7]*m[9] + m[4]*m[1]*m[11] _
             - m[4]*m[3]*m[9] - m[8]*m[1]*m[7] + m[8]*m[3]*m[5]
    inv(15) =  m[0]*m[5]*m[10] - m[0]*m[6]*m[9] - m[4]*m[1]*m[10] _
             + m[4]*m[2]*m[9] + m[8]*m[1]*m[6] - m[8]*m[2]*m[5]

    det = m[0]*inv(0) + m[1]*inv(4) + m[2]*inv(8) + m[3]*inv(12)
    
    
    
    if (det = 0) then
        return GL_FALSE
end if
    det = 1.0 / det

    for i = 0 to 16-1
        invOut[i] = inv(i) * det 
     next
    return GL_TRUE
 
 end function
 
function  _gluUnProject(winx as GLdouble ,winy as GLdouble ,winz as GLdouble , _
 		       modelMatrix as const GLdouble ptr, _
                       projMatrix as const GLdouble ptr, _
                       viewport as const GLint ptr , _
                       objx as GLdouble ptr,objy as GLdouble ptr,objz as GLdouble ptr) as  GLint 
                       
                       
                       
                       
    dim as double finalMatrix(16)
    dim as double _in(4)
    dim as double _out(4)
    
    __gluMultMatricesd(modelMatrix, projMatrix, @finalMatrix(0))
    if (__gluInvertMatrixd(@finalMatrix(0), @finalMatrix(0)) = 0) then return(GL_FALSE)
    
    _in(0)=winx
    _in(1)=winy
    _in(2)=winz
    _in(3)=1.0
    
    _in(0) = (_in(0) - viewport[0]) / viewport[2]
    _in(1) = (_in(1) - viewport[1]) / viewport[3]
    
    
    _in(0) = _in(0) * 2 -1
    _in(1) = _in(1) * 2 -1
    _in(2) = _in(2) * 2 -1
    _in(3) = 1
    
 __gluMultMatrixVecd(@finalMatrix(0), @_in(0), @_out(0))
 if (_out(3) = 0.0) then return(GL_FALSE)    

   _out(0) /= _out(3)
   _out(1) /= _out(3)
   _out(2) /= _out(3)
    *objx = _out(0)
    *objy =  _out(1)
    *objz = _out(2) 
end function
 
function  _gluProject(objx as GLdouble ,objy as GLdouble , objz as GLdouble, _
		    modelMatrix as const GLdouble ptr, _
		    projMatrix as const GLdouble ptr, _
		    viewport as const GLint ptr,winx as GLdouble ptr,winy as GLdouble ptr,winz as GLdouble ptr) as GLint 
    dim as double _in(4)
    dim as double _out(4)

    _in(0)=objx
    _in(1)=objy
    _in(2)=objz
    _in(3)=1.0
    __gluMultMatrixVecd(modelMatrix, @_in(0), @_out(0))
    __gluMultMatrixVecd(projMatrix, @_out(0), @_in(0))
    if (_in(3) = 0.0) then return(GL_FALSE)
    _in(0) /= _in(3)
    _in(1) /= _in(3)
    _in(2) /= _in(3)
    /' Map x, y and z to range 0-1 '/
    _in(0) = _in(0) * 0.5 + 0.5
    _in(1) = _in(1) * 0.5 + 0.5
    _in(2) = _in(2) * 0.5 + 0.5

    /' Map x,y to viewport '/
    _in(0) = _in(0) * viewport[2] + viewport[0]
    _in(1) = _in(1) * viewport[3] + viewport[1]
    *winx=_in(0)
    *winy=_in(1)
    *winz=_in(2)
    return(GL_TRUE)
end function

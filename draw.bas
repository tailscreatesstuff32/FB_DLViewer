#include "globals.bi"
#include "GL/glu.bi"
#define GRID_SIZE	10.0f


sub gl_LookAt( p_EyeX as const GLdouble, p_EyeY  as const GLdouble, p_EyeZ as const GLdouble,p_CenterX as  const GLdouble ,  p_CenterY as const GLdouble, p_CenterZ as const GLdouble)
	dim as GLdouble l_X = p_EyeX - p_CenterX
	dim as GLdouble l_Y = p_EyeY - p_CenterY
	dim as GLdouble l_Z = p_EyeZ - p_CenterZ
	
	if(l_X =  l_Y andalso l_Y = l_Z andalso l_Z = 0.0f) then return

	if(l_X = l_Z andalso l_Z = 0.0f)  then
		if(l_Y < 0.0f) then
			glRotated(-90.0f, 1, 0, 0)
		else
			glRotated(90.0f, 1, 0, 0)
		end if
		glTranslated(-l_X, -l_Y, -l_Z)
		return
	end if

	dim as GLdouble l_rX = 0.0f
	dim as GLdouble l_rY = 0.0f

	dim as GLdouble l_hA =  iif(l_X = 0.0f, l_Z,hypot(l_X, l_Z))    
	dim as GLdouble l_hB
	if(l_Z = 0.0f) then
		l_hB = hypot(l_X, l_Y)
	else
		l_hB =  iif(l_Y = 0.0f,l_hA, hypot(l_Y, l_hA)) 
	end if

	l_rX = asin(l_Y / l_hB) * (180 / M_PI)
	l_rY = asin(l_X / l_hA) * (180 / M_PI)

	glRotated(l_rX, 1, 0, 0)
	if(l_Z < 0.0f) then
		l_rY += 180.0f
	else
		l_rY = 360.0f - l_rY
	end if

	glRotated(l_rY, 0, 1, 0)
	glTranslated(-p_EyeX, -p_EyeY, -p_EyeZ)
end sub



sub gl_Perspective(fovy as GLdouble ,aspect as GLdouble ,zNear as GLdouble , zFar as GLdouble)
 
	dim as GLdouble xmin, xmax, ymin, ymax 

	ymax = zNear * tan(fovy * M_PI / 360.0)
	ymin = -ymax
	xmin = ymin * aspect
	xmax = ymax * aspect

	glFrustum(xmin, xmax, ymin, ymax, zNear, zFar)
end sub

 

 

 

 
sub gl_SetupScene2D(W as integer,H as integer)
        glViewport(0, 0, w, h)

	glMatrixMode(GL_PROJECTION)
	glLoadIdentity()

        glOrtho(0,w,h,0,-1,1)
        
	glMatrixMode(GL_MODELVIEW)
	glLoadIdentity()
	
	glDisable(GL_DEPTH_TEST)
	glDisable(GL_CULL_FACE)
        glDisable(GL_LIGHTING)
        glDisable(GL_NORMALIZE)




end sub


'NOT COMPLETE///////////////
sub gl_DrawHUD()

	if(zOptions.EnableHUD = 0) then return
 	gl_SetupScene2D(zProgram.WindowWidth, zProgram.WindowHeight)
 
 	if(RDRAM.IsSet = true) then
		hud_Print( _
			0, -1, zProgram.WindowWidth, -1, 1, 1.0f, _
			"Display List: ignored")
         elseif(zProgram.DListSel = -1)  then
		hud_Print( _
			0, -1, zProgram.WindowWidth, -1, 1, 1.0f, _
			"Display List: all")
	else
		hud_Print( _
			0, -1, zProgram.WindowWidth, -1, 1, 1.0f, _
			"Display List: %08X", _
			zProgram.DListAddr(zProgram.DListSel))
	end if

	if(RDRAM.IsSet = false) then
		hud_Print( _
			130, -1, 0, -1, 1, 1.0f, _
			"Scale: %4f", _
			zProgram.ScaleFactor)
	else
		hud_Print( _
			130, -1, 0, -1, 1, 1.0f, _
			"Scale: ignored")
	end if
/'
	hud_Print( _
		230, -1, 0, -1, 1, 1.0f, _
		"%4f", _
		zCamera.CamSpeed)
'/
	hud_Print( _
		zProgram.WindowWidth - 45, -1, 0, -1, 1, 1.0f, _
		"FPS: %i", _
		zProgram.LastFPS)	
 

end sub








sub gl_DrawScene()
 
	glClearColor(0.2f, 0.5f, 0.7f, 1.0f)
	glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
 

	  gl_SetupScene3D(zProgram.WindowWidth, zProgram.WindowHeight)
	gl_LookAt(zCamera.X, zCamera.Y, zCamera.Z, zCamera.X + zCamera.LX, zCamera.Y + zCamera.LY, zCamera.Z + zCamera.LZ)

	 if(zOptions.EnableGrid) then
	 	 if(RDP_OpenGL_ExtFragmentProgram()) then glDisable(GL_FRAGMENT_PROGRAM_ARB)
	 	glCallList(zProgram.GLGrid)
 
	end if
	
	
 glScalef(zProgram.ScaleFactor, zProgram.ScaleFactor, zProgram.ScaleFactor)
 	
 	  if(zProgram.DListSel = -1)  then
	 	dim as integer i
		
		
	 	i = 0
	 	do while i < zProgram.DListCount + 1
		
		
		 	if glIsList(zProgram.DListGL(i)) then glCallList(zProgram.DListGL(i)) 
			
			'
		 if(RDP_CheckAddressValidity(zProgram.DListAddr(i))) then RDP_ParseDisplayList(zProgram.DListAddr(i), true)
		loop
		
		
 
		
		
		
	  else  
		if glIsList(zProgram.DListGL(zProgram.DListSel)) then   glCallList(zProgram.DListGL(zProgram.DListSel))
		
		/' if(RDP_CheckAddressValidity(zProgram.DListAddr(zProgram.DListSel))) then
			RDP_ParseDisplayList(zProgram.DListAddr(zProgram.DListSel), true) 
		end if '/
	end if
	



	
	
 	gl_DrawHUD

end sub

sub gl_SetupScene3D(W as integer,H as integer)
 
	dim as double TempMatrix(4,4)

	glViewport(0, 0, W, H)

	glMatrixMode(GL_PROJECTION)
	glLoadIdentity()
	gl_Perspective(60.0f, cast(GLfloat,W) / cast(GLfloat,H), 0.001f, 10000.0f)
	glGetFloatv(GL_PROJECTION_MATRIX, @TempMatrix(0,0))
	RDP_Matrix_ProjectionLoad(@TempMatrix(0,0))
	glMatrixMode(GL_MODELVIEW)
	glLoadIdentity()
	glGetFloatv(GL_MODELVIEW_MATRIX, @TempMatrix(0,0))
	RDP_Matrix_ModelviewLoad(@TempMatrix(0,0))

	glEnable(GL_DEPTH_TEST)
end sub




 

sub gl_CreateSceneDLists()

dbgprintf(0, MSK_COLORTYPE_OKAY, "Now executing Display Lists... please wait.")

dim as integer i = 0


do while i < zProgram.Dlistcount
	if(RDP_CheckAddressValidity(zProgram.DListAddr(i))) then
			'// delete list
			if(glIsList(zProgram.DListGL(i))) then glDeleteLists(zProgram.DListGL(i), 1)
			'// generate list
			zProgram.DListGL(i) = glGenLists(1)
			'// fill list
			glNewList(zProgram.DListGL(i), GL_COMPILE_AND_EXECUTE)
				RDP_SetCycleType(1)
				RDP_ParseDisplayList(zProgram.DListAddr(i), true)
			glEndList()
			 glDeleteLists(zProgram.DListGL(i), 1)
		end if
i+=1

loop



end sub





sub gl_CreateViewerDLists()
 
	zProgram.GLAxisMarker = glGenLists(1)
	zProgram.GLGrid = glGenLists(1)

	glNewList(zProgram.GLAxisMarker, GL_COMPILE)
		glDisable(GL_TEXTURE_2D)
		glDisable(GL_LIGHTING)
		glDisable(GL_NORMALIZE)
		glLineWidth(2)

		glBegin(GL_LINES) 
			glColor3f(0.0f, 0.0f, 1.0f)
			glVertex3f(420.0f, 0.1f, 0.1f)
			glVertex3f(-420.0f, 0.1f, 0.1f)
		glEnd()
		glBegin(GL_LINES)
			glColor3f(1.0f, 0.0f, 0.0f)
			glVertex3f(0.1f, 420.0f, 0.1f)
			glVertex3f(0.1f, -420.0f, 0.1f)
		glEnd()
		glBegin(GL_LINES)
			glColor3f(0.0f, 1.0f, 0.0f)
			glVertex3f(0.1f, 0.1f, 420.0f)
			glVertex3f(0.1f, 0.1f, -420.0f)
			glVertex3f(0.1f, 0.1f, 420.0f)
		glEnd()

		glEnable(GL_TEXTURE_2D) 
		glEnable(GL_LIGHTING) 
		glEnable(GL_NORMALIZE) 
		glLineWidth(1) 
	glEndList() 
	
	
dim as integer i
		glNewList(zProgram.GLGrid, GL_COMPILE)
		glDisable(GL_TEXTURE_2D)
		glDisable(GL_LIGHTING)
		glDisable(GL_NORMALIZE)

		glColor3f(0.0f, 0.0f, 0.0f)

 
		i = -GRID_SIZE
		do while i <= GRID_SIZE
			glBegin(GL_LINES) 
				glVertex3f(-GRID_SIZE, 0.0f,          i) 
				glVertex3f( GRID_SIZE, 0.0f,          i) 
				glVertex3f(         i, 0.0f, -GRID_SIZE) 
				glVertex3f(         i, 0.0f,  GRID_SIZE) 
			glEnd()
			i += GRID_SIZE / 10.0f
		loop
		
		glEnable(GL_TEXTURE_2D)
		glEnable(GL_LIGHTING)
		glEnable(GL_NORMALIZE)
	glEndList()

end sub

'maybe static inline or inline macro maybe?
function  gl_GetPointDistance(First as __Vect3D, Second as __Vect3D) as GLFloat 
 
         dim as GLfloat DeltaX = cast(double,Second.X) - cast(double,First.X)
	 dim as GLfloat DeltaY = cast(double,Second.Y) - cast(double,First.Y)
	 dim as GLfloat DeltaZ = cast(double,Second.Z) - cast(double,First.Z)
	 return sqrtf(DeltaX * DeltaX + DeltaY * DeltaY + DeltaZ * DeltaZ)
end function

function gl_FinishScene() as integer
 
	#ifdef FB_WIN32
	SwapBuffers(hDC):  return EXIT_SUCCESS 
	#else
	glXSwapBuffers(dpy, win): return EXIT_SUCCESS
	#endif
end function

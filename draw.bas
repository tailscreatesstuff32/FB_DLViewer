#include "globals.bi"
#include "GL/glu.bi"
#define GRID_SIZE	10.0f


Sub gl_LookAt(p_EyeX As Const GLdouble, p_EyeY As Const GLdouble, p_EyeZ As Const GLdouble, _
              p_CenterX As Const GLdouble, p_CenterY As Const GLdouble, p_CenterZ As Const GLdouble)
    Dim As GLdouble l_X = p_EyeX - p_CenterX
    Dim As GLdouble l_Y = p_EyeY - p_CenterY
    Dim As GLdouble l_Z = p_EyeZ - p_CenterZ

    If (l_X = l_Y AndAlso l_Y = l_Z AndAlso l_Z = 0.0) Then Return

    If (l_X = l_Z AndAlso l_Z = 0.0) Then
        If (l_Y < 0.0) Then
            glRotated(-90.0, 1, 0, 0)
        Else
            glRotated(90.0, 1, 0, 0)
        End If
        glTranslated(-l_X, -l_Y, -l_Z)
        Return
    End If

    Dim As GLdouble l_rX = 0.0
    Dim As GLdouble l_rY = 0.0

    Dim As GLdouble l_hA = IIf(l_X = 0.0, l_Z, hypot(l_X, l_Z))
    Dim As GLdouble l_hB
    If (l_Z = 0.0) Then
        l_hB = hypot(l_X, l_Y)
    Else
        l_hB = IIf(l_Y = 0.0, l_hA, hypot(l_Y, l_hA))
    End If

    l_rX = ASin(l_Y / l_hB) * (180 / M_PI)
    l_rY = ASin(l_X / l_hA) * (180 / M_PI)

    glRotated(l_rX, 1, 0, 0)
    If (l_Z < 0.0) Then
        l_rY += 180.0
    Else
        l_rY = 360.0 - l_rY
    End If

    glRotated(l_rY, 0, 1, 0)
    glTranslated(-p_EyeX, -p_EyeY, -p_EyeZ)
End Sub

sub gl_Perspective(fovy as GLdouble ,aspect as GLdouble ,zNear as GLdouble , zFar as GLdouble)
 
	dim as GLdouble xmin, xmax, ymin, ymax 

	ymax = zNear * tan(fovy * M_PI / 360.0)
	ymin = -ymax
	xmin = ymin * aspect
	xmax = ymax * aspect

	glFrustum(xmin, xmax, ymin, ymax, zNear, zFar)
end sub

Sub gl_SetupScene2D(W as integer, H as integer)
    glViewport(0, 0, W, H)

    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()

    glOrtho(0, W, H, 0, -1, 1)

    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()

    glDisable(GL_DEPTH_TEST)
    glDisable(GL_CULL_FACE)
    glDisable(GL_LIGHTING)
    glDisable(GL_NORMALIZE)
End Sub


'COMPLETE///////////////
Sub gl_DrawHUD()
    If (zOptions.EnableHUD = 0) Then Return
    gl_SetupScene2D(zProgram.WindowWidth, zProgram.WindowHeight)

    If (RDRAM.IsSet = True) Then
        hud_Print(0, -1, zProgram.WindowWidth, -1, 1, 1.0f, _
            "Display List: ignored")
    ElseIf (zProgram.DListSel = -1) Then
        hud_Print(0, -1, zProgram.WindowWidth, -1, 1, 1.0f, _
            "Display List: all")
    Else
        hud_Print(0, -1, zProgram.WindowWidth, -1, 1, 1.0f, _
            "Display List: %08X", _
            zProgram.DListAddr(zProgram.DListSel))
    End If

    If (RDRAM.IsSet = False) Then
        hud_Print(130, -1, 0, -1, 1, 1.0f, _
            "Scale: %4f", _
            zProgram.ScaleFactor)
    Else
        hud_Print(130, -1, 0, -1, 1, 1.0f, _
            "Scale: ignored")
    End If
    '/'
    'hud_Print(230, -1, 0, -1, 1, 1.0f, _
    '    "%4f", _
    '    zCamera.CamSpeed)
    '/

    hud_Print(zProgram.WindowWidth - 45, -1, 0, -1, 1, 1.0f, _
        "FPS: %i", _
        zProgram.LastFPS)
End Sub

Sub gl_DrawScene()
    glClearColor(0.2f, 0.5f, 0.7f, 1.0f)
    glClear(GL_COLOR_BUFFER_BIT Or GL_DEPTH_BUFFER_BIT)

    gl_SetupScene3D(zProgram.WindowWidth, zProgram.WindowHeight)
    gl_LookAt(zCamera.X, zCamera.Y, zCamera.Z, zCamera.X + zCamera.LX, zCamera.Y + zCamera.LY, zCamera.Z + zCamera.LZ)

    If (zOptions.EnableGrid) Then
        If (RDP_OpenGL_ExtFragmentProgram()) Then glDisable(GL_FRAGMENT_PROGRAM_ARB)
        glCallList(zProgram.GLGrid)
    End If

    glScalef(zProgram.ScaleFactor, zProgram.ScaleFactor, zProgram.ScaleFactor)

    If (zProgram.DListSel = -1) Then
        Dim As integer i
        i = 0
        Do While i < zProgram.DListCount + 1
            If glIsList(zProgram.DListGL(i)) Then glCallList(zProgram.DListGL(i))
            
           ' if(RDP_CheckAddressValidity(zProgram.DListAddr(i))) then RDP_ParseDisplayList(zProgram.DListAddr(i), true)
            i += 1
        Loop
    Else
        If glIsList(zProgram.DListGL(zProgram.DListSel)) Then glCallList(zProgram.DListGL(zProgram.DListSel))
        
        '/
        'if(RDP_CheckAddressValidity(zProgram.DListAddr(zProgram.DListSel))) then
        '    RDP_ParseDisplayList(zProgram.DListAddr(zProgram.DListSel), true)
        'end if
        '/
    End If

    gl_DrawHUD
End Sub

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

Sub gl_CreateSceneDLists()
    dbgprintf(0, MSK_COLORTYPE_OKAY, "Now executing Display Lists... please wait.")

    Dim As integer i = 0

    Do While i < zProgram.Dlistcount + 1
        If RDP_CheckAddressValidity(zProgram.DListAddr(i)) Then
      '   msk_consoleprint(1, "DLIST: %i",zProgram.DListAddr(i))     
            '// delete list
          If glIsList(zProgram.DListGL(i)) Then glDeleteLists(zProgram.DListGL(i), 1)
            '// generate list
            zProgram.DListGL(i) = glGenLists(1)
            '// fill list
            glNewList(zProgram.DListGL(i), GL_COMPILE_AND_EXECUTE)
            	RDP_SetCycleType(1)
            	RDP_ParseDisplayList(zProgram.DListAddr(i), True)
            glEndList() 
        End If
        i += 1
    Loop

End Sub


	 ' glPushMatrix()  ' Save the current matrix state
           /' glTranslatef(1.0, 0.0, 0.0)  ' Apply translation
            glDisable(GL_TEXTURE_2D)
            glEnable(GL_LIGHTING)
            glEnable(GL_COLOR_MATERIAL)
            glBegin(GL_TRIANGLES)  ' Begin rendering
            glColor3f(1.0, 0.0, 0.0)  ' Set color to red
            glVertex3f(-0.5, -0.5, 0.0)
            glVertex3f(0.5, -0.5, 0.0)
            glVertex3f(0.0, 0.5, 0.0)
            glEnd()  ' End rendering
    
            glEnable(GL_TEXTURE_2D)
            glDisable(GL_LIGHTING)
            glDisable(GL_COLOR_MATERIAL)
            glPopMatrix()  ' Restore the previous matrix state '/
            
Sub gl_CreateViewerDLists()
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

    Dim As integer i
    glNewList(zProgram.GLGrid, GL_COMPILE)
        glDisable(GL_TEXTURE_2D)
        glDisable(GL_LIGHTING)
        glDisable(GL_NORMALIZE)

        glColor3f(0.0f, 0.0f, 0.0f)

        i = -GRID_SIZE
        Do While i <= GRID_SIZE
            glBegin(GL_LINES)
                glVertex3f(-GRID_SIZE, 0.0f, i)
                glVertex3f(GRID_SIZE, 0.0f, i)
                glVertex3f(i, 0.0f, -GRID_SIZE)
                glVertex3f(i, 0.0f, GRID_SIZE)
            glEnd()
            i += GRID_SIZE / 10.0f
        Loop

       glEnable(GL_TEXTURE_2D)
        glEnable(GL_LIGHTING)
        glEnable(GL_NORMALIZE)
    glEndList()
End Sub

'maybe static inline or inline macro maybe?
Function gl_GetPointDistance(First As __Vect3D, Second As __Vect3D) As GLFloat
    Dim As GLfloat DeltaX = Cast(Double, Second.X) - Cast(Double, First.X)
    Dim As GLfloat DeltaY = Cast(Double, Second.Y) - Cast(Double, First.Y)
    Dim As GLfloat DeltaZ = Cast(Double, Second.Z) - Cast(Double, First.Z)
    Return Sqrtf(DeltaX * DeltaX + DeltaY * DeltaY + DeltaZ * DeltaZ)
End Function

Function gl_FinishScene() As integer
    #ifdef FB_WIN32
        SwapBuffers(hDC)
        Return EXIT_SUCCESS
    #else
        glXSwapBuffers(dpy, win)
        Return EXIT_SUCCESS
    #endif
End Function

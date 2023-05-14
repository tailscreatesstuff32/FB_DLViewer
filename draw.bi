declare sub gl_Perspective( fovy as GLdouble,aspect as GLdouble , zNear as GLdouble, zFar as GLdouble)
declare sub gl_LookAt(p_EyeX as const GLdouble ,p_EyeY as  const GLdouble ,p_EyeZ as const GLdouble ,p_CenterX as const GLdouble ,p_CenterY as const GLdouble , p_CenterZ as const GLdouble )
declare sub gl_SetupScene2D(w as integer, height as integer)
declare sub gl_SetupScene3D(w as integer, height as integer)
declare sub gl_CreateSceneDLists()
declare sub gl_DrawScene()
declare sub gl_DrawHUD()
declare sub gl_CreateViewerDLists()
declare function gl_FinishScene() as integer

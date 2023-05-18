'FINISHED//////////////////////////////////


declare function  ms_GetScreenCoords(SceneX as single,SceneY  as single, SceneZ  as single) as __Vect3D
declare function  ms_GetSceneCoords(MousePosX as integer, MousePosY as integer) as __Vect3D 
declare function  _gluUnProject(winx as GLdouble ,winy as GLdouble ,winz as GLdouble , modelMatrix as const GLdouble ptr, projMatrix as const GLdouble ptr,viewport as const GLint ptr , objx as GLdouble ptr,objy as GLdouble ptr,objz as GLdouble ptr) as  GLint 
declare function  _gluProject(objx as GLdouble ,objy as GLdouble , objz as GLdouble, modelMatrix as const GLdouble ptr, projMatrix as const GLdouble ptr,viewport as const GLint ptr,winx as GLdouble ptr,winy as GLdouble ptr,winz as GLdouble ptr) as GLint 



extern "c"

type __MSK_UI_Object_Data
	as integer ParentHandle
	as integer  Handle

	as integer _Type
	as integer  y, x
	as integer  Order

	as any ptr ObjParameters
	as short ptr Value
end type

type  __MSK_UI_Dialog_Data
	as integer ParentHandle
	as integer Handle

	as integer h, w, y, x
	as zstring ptr Title
	as integer BkgColor
	as integer HLColor

	as integer ObjCount(2)			'// set automatically, 0 = total, 1 = selectable
	as integer ObjSelected(2)			'// 0 = total, 1 = selectable

	as WINDOW_ ptr Win
	as WINDOW_ ptr WinShade
end type

declare sub MSK_DoEvents_Dialog()
declare sub MSK_UI_Dialog_Draw(Dlg as __MSK_UI_Dialog_Data ptr )
declare sub MSK_UI_Dialog_CalculateObjCount(Dlg as __MSK_UI_Dialog_Data ptr )
declare function MSK_UI_Dialog_ObjNumSelect_GetCount(Obj as __MSK_UI_Object_Data ptr ) as integer
declare function MSK_UI_Dialog_ObjNumSelect_GetDisplayType(Obj as __MSK_UI_Object_Data ptr ) as integer
declare function MSK_UI_Dialog_ObjNumSelect_GetStringFormat(Obj as __MSK_UI_Object_Data ptr ) as integer
declare function MSK_UI_Dialog_ObjNumSelect_GetAllowNegativeFlag(Obj as __MSK_UI_Object_Data ptr )  as integer
declare function MSK_UI_Dialog_ObjButton_IsOkay(Obj as __MSK_UI_Object_Data ptr ) as boolean
declare sub MSK_UI_Dialog_SyncSelection(Dlg as __MSK_UI_Dialog_Data ptr )
declare function MSK_UI_Dialog_GetFreeDlgHandle() as integer 
declare sub MSK_UI_Dialog_DestroyDlgHandle(DstHandle  as integer)
declare function MSK_UI_Dialog_GetFreeObject() as integer
declare sub MSK_UI_Dialog_DestroyObject(ObjHandle  as integer)

extern as __MSK_UI_Dialog_Data Dialog(512)
extern as __MSK_UI_Object_Data _Object(512)
extern as __MSK_UI_Dialog_Data Dialog_Active
extern as short ObjectValue(512)
extern as boolean ObjectValueSe(512)


end extern

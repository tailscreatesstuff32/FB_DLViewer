Type __GfxMacro
    _Len As Integer
    Func As RDPInstruction
    _Cmd(32) as byte
End Type

Dim Shared As __GfxMacro GfxMacros(0 to ...) = _
{ _
    (7, @RDP_Macro_LoadTextureBlock, {G_SETTIMG, G_SETTILE, G_RDPLOADSYNC, G_LOADBLOCK, G_RDPPIPESYNC, G_SETTILE, G_SETTILESIZE}), _
    (6, @RDP_Macro_LoadTLUT, {G_SETTIMG, G_RDPTILESYNC, G_SETTILE, G_RDPLOADSYNC, G_LOADTLUT, G_RDPPIPESYNC}), _
    (8, @RDP_Macro_LoadTextureSF64, {G_RDPTILESYNC, G_SETTILE, G_SETTILESIZE, G_SETTIMG, G_RDPTILESYNC, G_SETTILE, G_RDPLOADSYNC, G_LOADBLOCK}) _
}


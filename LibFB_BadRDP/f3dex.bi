declare Sub RDP_F3DEX_Init ()

' Function declarations
Declare Sub RDP_F3DEX_VTX ()
Declare Sub RDP_F3DEX_LOAD_UCODE ()
Declare Sub RDP_F3DEX_BRANCH_Z ()
Declare Sub RDP_F3DEX_TRI2 ()
Declare Sub RDP_F3DEX_MODIFYVTX ()
Declare Sub RDP_F3DEX_CULLDL ()
Declare Sub RDP_F3DEX_TRI1 ()

' Macro definitions
#Define F3DEX_LOAD_UCODE    &HAF
#Define F3DEX_BRANCH_Z      &HB0
#Define F3DEX_TRI2          &HB1
#Define F3DEX_MODIFYVTX     &HB2

' Constant definitions
#Define F3DEX_TEXTURE_ENABLE    &H00000002
#Define F3DEX_SHADING_SMOOTH    &H00000200
#Define F3DEX_CULL_FRONT        &H00001000
#Define F3DEX_CULL_BACK         &H00002000
#Define F3DEX_CULL_BOTH         &H00003000
#Define F3DEX_CLIPPING          &H00800000

#Define F3DEX_MTX_STACKSIZE     18

#Define F3DEX_MTX_MODELVIEW     &H00
#Define F3DEX_MTX_PROJECTION    &H01
#Define F3DEX_MTX_MUL           &H00
#Define F3DEX_MTX_LOAD          &H02
#Define F3DEX_MTX_NOPUSH        &H00
#Define F3DEX_MTX_PUSH          &H04


Declare Sub RDP_F3D_Init ()



' Function declarations
Declare Sub RDP_F3D_SPNOOP ()
Declare Sub RDP_F3D_MTX ()
Declare Sub RDP_F3D_RESERVED0 ()
Declare Sub RDP_F3D_MOVEMEM ()
Declare Sub RDP_F3D_VTX ()
Declare Sub RDP_F3D_RESERVED1 ()
Declare Sub RDP_F3D_DL ()
Declare Sub RDP_F3D_RESERVED2 ()
Declare Sub RDP_F3D_RESERVED3 ()
Declare Sub RDP_F3D_SPRITE2D_BASE ()
Declare Sub RDP_F3D_TRI4 ()
Declare Sub RDP_F3D_RDPHALF_CONT ()
Declare Sub RDP_F3D_RDPHALF_2 ()
Declare Sub RDP_F3D_RDPHALF_1 ()
Declare Sub RDP_F3D_QUAD ()
Declare Sub RDP_F3D_CLEARGEOMETRYMODE ()
Declare Sub RDP_F3D_SETGEOMETRYMODE ()
Declare Sub RDP_F3D_ENDDL ()
Declare Sub RDP_F3D_SETOTHERMODE_L ()
Declare Sub RDP_F3D_SETOTHERMODE_H ()
Declare Sub RDP_F3D_TEXTURE ()
Declare Sub RDP_F3D_MOVEWORD ()
Declare Sub RDP_F3D_POPMTX ()
Declare Sub RDP_F3D_CULLDL ()
Declare Sub RDP_F3D_TRI1 ()







' Macro and constant definitions
#Define F3D_SPNOOP              &H00
#Define F3D_MTX                 &H01
#Define F3D_RESERVED0           &H02
#Define F3D_MOVEMEM             &H03
#Define F3D_VTX                 &H04
#Define F3D_RESERVED1           &H05
#Define F3D_DL                  &H06
#Define F3D_RESERVED2           &H07
#Define F3D_RESERVED3           &H08
#Define F3D_SPRITE2D_BASE       &H09

#Define F3D_TRI4                &HB1
#Define F3D_RDPHALF_CONT        &HB2
#Define F3D_RDPHALF_2           &HB3
#Define F3D_RDPHALF_1           &HB4
#Define F3D_QUAD                &HB5
#Define F3D_CLEARGEOMETRYMODE   &HB6
#Define F3D_SETGEOMETRYMODE     &HB7
#Define F3D_ENDDL               &HB8
#Define F3D_SETOTHERMODE_L      &HB9
#Define F3D_SETOTHERMODE_H      &HBA
#Define F3D_TEXTURE             &HBB
#Define F3D_MOVEWORD            &HBC
#Define F3D_POPMTX              &HBD
#Define F3D_CULLDL              &HBE
#Define F3D_TRI1                &HBF

#Define F3D_TEXTURE_ENABLE      &H00000002
#Define F3D_SHADING_SMOOTH      &H00000200
#Define F3D_CULL_FRONT          &H00001000
#Define F3D_CULL_BACK           &H00002000
#Define F3D_CULL_BOTH           &H00003000
#Define F3D_CLIPPING            &H00000000

#Define F3D_MTX_STACKSIZE       10

#Define F3D_MTX_MODELVIEW       &H00
#Define F3D_MTX_PROJECTION      &H01
#Define F3D_MTX_MUL             &H00
#Define F3D_MTX_LOAD            &H02
#Define F3D_MTX_NOPUSH          &H00
#Define F3D_MTX_PUSH            &H04

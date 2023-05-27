#define	G_SETCIMG				&HFF
#define	G_SETZIMG				&HFE
#define	G_SETTIMG				&HFD
#define	G_SETCOMBINE			&HFC
#define	G_SETENVCOLOR			&HFB
#define	G_SETPRIMCOLOR			&HFA
#define	G_SETBLENDCOLOR			&HF9
#define	G_SETFOGCOLOR			&HF8
#define	G_SETFILLCOLOR			&HF7
#define	G_FILLRECT				&HF6
#define	G_SETTILE				&HF5
#define	G_LOADTILE				&HF4
#define	G_LOADBLOCK				&HF3
#define	G_SETTILESIZE			&HF2
#define	G_LOADTLUT				&HF0
#define	G_RDPSETOTHERMODE		&HEF
#define	G_SETPRIMDEPTH			&HEE
#define	G_SETSCISSOR			&HED
#define	G_SETCONVERT			&HEC
#define	G_SETKEYR				&HEB
#define	G_SETKEYGB				&HEA
#define	G_RDPFULLSYNC			&HE9
#define	G_RDPTILESYNC			&HE8
#define	G_RDPPIPESYNC			&HE7
#define	G_RDPLOADSYNC			&HE6
#define G_TEXRECTFLIP			&HE5
#define G_TEXRECT				&HE4

'// ----------------------------------------

#define G_ZBUFFER				&H00000001
#define G_SHADE					&H00000004
#define G_FOG					&H00010000
#define G_LIGHTING				&H00020000
#define G_TEXTURE_GEN			&H00040000
#define G_TEXTURE_GEN_LINEAR	&H00080000
#define G_LOD					&H00100000

#define	G_MDSFT_ALPHACOMPARE	0
#define	G_MDSFT_ZSRCSEL			2
#define	G_MDSFT_RENDERMODE		3

#define	G_MDSFT_ALPHADITHER		4
#define	G_MDSFT_RGBDITHER		6
#define	G_MDSFT_COMBKEY			8
#define	G_MDSFT_TEXTCONV		9
#define	G_MDSFT_TEXTFILT		12
#define	G_MDSFT_TEXTLUT			14
#define	G_MDSFT_TEXTLOD			16
#define	G_MDSFT_TEXTDETAIL		17
#define	G_MDSFT_TEXTPERSP		19
#define	G_MDSFT_CYCLETYPE		20
#define	G_MDSFT_PIPELINE		23

#define	G_TX_WRAP				&H00
#define	G_TX_MIRROR				&H01
#define	G_TX_CLAMP				&H02

#define G_CCMUX_COMBINED		0
#define G_CCMUX_TEXEL0			1
#define G_CCMUX_TEXEL1			2
#define G_CCMUX_PRIMITIVE		3
#define G_CCMUX_SHADE			4
#define G_CCMUX_ENVIRONMENT		5
#define G_CCMUX_CENTER			6
#define G_CCMUX_SCALE			6
#define G_CCMUX_COMBINED_ALPHA	7
#define G_CCMUX_TEXEL0_ALPHA	8
#define G_CCMUX_TEXEL1_ALPHA	9
#define G_CCMUX_PRIMITIVE_ALPHA	10
#define G_CCMUX_SHADE_ALPHA		11
#define G_CCMUX_ENV_ALPHA		12
#define G_CCMUX_LOD_FRACTION	13
#define G_CCMUX_PRIM_LOD_FRAC	14
#define G_CCMUX_NOISE			7
#define G_CCMUX_K4				7
#define G_CCMUX_K5				15
#define G_CCMUX_1				6
#define G_CCMUX_0				31

#define G_ACMUX_COMBINED		0
#define G_ACMUX_TEXEL0			1
#define G_ACMUX_TEXEL1			2
#define G_ACMUX_PRIMITIVE		3
#define G_ACMUX_SHADE			4
#define G_ACMUX_ENVIRONMENT		5
#define G_ACMUX_LOD_FRACTION	0
#define G_ACMUX_PRIM_LOD_FRAC	6
#define G_ACMUX_1				6
#define G_ACMUX_0				7

#define	AA_EN					&H00000008
#define	Z_CMP					&H00000010
#define	Z_UPD					&H00000020
#define	IM_RD					&H00000040
#define	CLR_ON_CVG				&H00000080
#define	CVG_DST_CLAMP			&H00000000
#define	CVG_DST_WRAP			&H00000100
#define	CVG_DST_FULL			&H00000200
#define	CVG_DST_SAVE			&H00000300
/'
#define	ZMODE_OPA				&H00000000
#define	ZMODE_INTER				&H00000400
#define	ZMODE_XLU				&H00000800
#define	ZMODE_DEC				&H00000C00
'/
#define	CVG_X_ALPHA				&H00001000
#define	ALPHA_CVG_SEL			&H00002000
#define	FORCE_BL				&H00004000

#define G_MWO_POINT_RGBA		&H10
#define G_MWO_POINT_ST			&H14

#define	ZMODE_OPA				0
#define	ZMODE_INTER				1
#define	ZMODE_XLU				2
#define	ZMODE_DEC				3

#define	G_CYC_1CYCLE			0
#define	G_CYC_2CYCLE			1
#define	G_CYC_COPY				2
#define	G_CYC_FILL				3

#define G_MW_MATRIX			&H00
#define G_MW_NUMLIGHT		&H02
#define G_MW_CLIP			&H04
#define G_MW_SEGMENT		&H06
#define G_MW_FOG			&H08
#define G_MW_LIGHTCOL		&H0A
#define G_MW_FORCEMTX		&H0C
#define G_MW_POINTS			&H0C
#define	G_MW_PERSPNORM		&H0E

#define G_DL_PUSH		&H00
#define G_DL_NOPUSH		&H01

PROJECT = FB_DL_Viewer
TARGET = $(PROJECT)

# Environment
#FB = fbc 
#FB = fbc -gen gas64
#FB = fbc32 -Wc -Wno-builtin-declaration-mismatch,-Wno-memset-elt-size -gen gcc
FB = fbc32 -Wc -w -w none  -gen gcc



# Utils flags
#CFLAGS = -Wall -U_FORTIFY_SOURCE
#FBFLAGS =

# Application pieces
PIECES	= main.bas confuncs.bas oz.bas dlist.bas draw.bas hud.bas hud_menu.bas camera.bas mouse.bas
PIECES += __linux.bas 
#PIECES += __win32.bas  
  
# Make
all: $(PIECES)
	$(FB) $(PIECES) -x $(TARGET) 

# Cleanup
#clean:
	#-vrf $(TARGET) *.o dump extr log.txt
	


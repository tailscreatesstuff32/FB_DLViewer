PROJECT = FB_DL_Viewer
TARGET = $(PROJECT)

# Environment
FB = fbc

# Utils flags
#CFLAGS = -Wall -U_FORTIFY_SOURCE
#FBFLAGS =

# Application pieces
PIECES	= main.bas confuncs.bas oz.bas dlist.bas draw.bas hud.bas hud_menu.bas camera.bas mouse.bas
PIECES += __linux.bas 
  
  
# Make
all: $(PIECES)
	$(FB) $(PIECES) -x $(TARGET) 

# Cleanup
#clean:
	#-vrf $(TARGET) *.o dump extr log.txt
	


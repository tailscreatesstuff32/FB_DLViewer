PROJECT = libFB_BadRDP
TARGET = $(PROJECT).a

# Environment
FB = fbc32
FBFLAGS =  -Wc -w -w none -gen gcc -lib

# Utils flags
#CFLAGS = -Wall -U_FORTIFY_SOURCE
#FBFLAGS =

# Application pieces
PIECES	=   combine.bas dump.bas f3dex2.bas gdp.bas macro.bas  opengl.bas\
	    dlparse.bas f3d.bas  f3dex.bas  gsp.bas matrix.bas rdp.bas \
	    crc.bas
 
  
# Make
all: $(PIECES)
	$(FB) $(FBFLAGS) $(PIECES) -x $(TARGET) 

# Cleanup
#clean:
	#-vrf $(TARGET) *.o dump extr log.txt
	

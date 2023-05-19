PROJECT = libFB_BadRDP
TARGET = $(PROJECT).a

# Environment
FB = fbc
FBFLAGS = -lib

# Utils flags
#CFLAGS = -Wall -U_FORTIFY_SOURCE
#FBFLAGS =

# Application pieces
PIECES	=  opengl.bas dlparse.bas dump.bas combine.bas matrix.bas
 
  
# Make
all: $(PIECES)
	$(FB) $(FBFLAGS) $(PIECES) -x $(TARGET) 

# Cleanup
#clean:
	#-vrf $(TARGET) *.o dump extr log.txt
	

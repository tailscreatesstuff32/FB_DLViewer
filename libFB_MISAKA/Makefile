PROJECT = libFB_MISAKA
TARGET = $(PROJECT).a
#TARGET = $(PROJECT).so


# Environment
FB = fbc
# AR = ar  

# Utils flags
#CFLAGS = -Wall -U_FORTIFY_SOURCE
#FBFLAGS = -dll
FBFLAGS = -lib

# Application pieces
PIECES	= msk_base.bas msk_console.bas msk_ui.bas

#Platfor specific options
#ifeq ($(WIN32), 1)
#  CFLAGS += -DWIN32
 # LDFLAGS = C:/Programme/PDCurses-SO/win32/panel.a	\
#            C:/Programme/PDCurses-SO/win32/pdcurses.a
#endif

#Debug?
#ifeq ($(DBG),1)
 # CFLAGS += -DDEBUG -ggdb3 -g
#else
#  CFLAGS += -O3
#endif

# Make
all: $(PIECES)
	$(FB) $(FBFLAGS) $(PIECES) -x $(TARGET) 

# Cleanup
clean:
	rm -vf *.a *.o

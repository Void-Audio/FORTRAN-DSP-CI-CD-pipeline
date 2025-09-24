FC      = gfortran
FFLAGS  = -Wall -O2 -std=f2008 -fPIC -Wtabs -J$(OBJDIR)
LDFLAGS = -shared

SRC     = DSP/numtype.f03 DSP/ringBuffer.f03 DSP/VOID_Verb.f03
OBJDIR  = kernel
OBJ     = $(patsubst DSP/%.f03,$(OBJDIR)/%.o,$(SRC))

TARGET  = $(OBJDIR)/VOID_Verb.so
TESTSRC = DSP/test.f03
TESTOBJ = $(OBJDIR)/test.o
TESTEXE = test

# ------------------------------------------------------------
# Default target (shared library)
# ------------------------------------------------------------
all: $(TARGET)

# Uncomment the next line if you want to build test instead
# all: $(TESTEXE)

# ------------------------------------------------------------
# Build shared library
# ------------------------------------------------------------
$(TARGET): $(OBJ)
	$(FC) $(FFLAGS) -o $@ $(OBJ) $(LDFLAGS)

# ------------------------------------------------------------
# Build test executable
# ------------------------------------------------------------
$(TESTEXE): $(OBJ) $(TESTOBJ)
	$(FC) -Wall -O2 -std=f2008 -o $@ $(OBJ) $(TESTOBJ)

$(OBJDIR)/test.o: $(TESTSRC) | $(OBJDIR)
	$(FC) -Wall -O2 -std=f2008 -J$(OBJDIR) -c $< -o $@

# ------------------------------------------------------------
# Generic object rule
# ------------------------------------------------------------
$(OBJDIR)/%.o: DSP/%.f03 | $(OBJDIR)
	$(FC) $(FFLAGS) -c $< -o $@

# ------------------------------------------------------------
# Create obj dir
# ------------------------------------------------------------
$(OBJDIR):
	mkdir -p $(OBJDIR)

# ------------------------------------------------------------
# Clean
# ------------------------------------------------------------
clean:
	rm -rf $(OBJDIR) $(TESTEXE)

.PHONY: run
run: all $(TESTEXE)
	./$(TESTEXE)

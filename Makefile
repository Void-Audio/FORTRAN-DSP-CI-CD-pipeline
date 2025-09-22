FC      = gfortran
FFLAGS  = -Wall -O2 -std=f2008 -fPIC -Wtabs -J$(OBJDIR)
LDFLAGS = -shared

SRC     = DSP/numtype.f03  DSP/VOID_ConVerb.f03

OBJDIR  = kernel
OBJ     = $(patsubst DSP/%.f03,$(OBJDIR)/%.o,$(SRC))

TARGET  = $(OBJDIR)/VOID_Verb.so

all: $(TARGET)

$(TARGET): $(OBJ)
	$(FC) $(FFLAGS) -o $@ $(OBJ) $(LDFLAGS)

$(OBJDIR)/%.o: DSP/%.f03 | $(OBJDIR)
	$(FC) $(FFLAGS) -c $< -o $@

$(OBJDIR):
	mkdir -p $(OBJDIR)

clean:
	rm -rf $(OBJDIR)

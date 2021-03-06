#
# Usage:
#       make mod    # To compile module
#       make        # To compile all routines and link it to HDF5 libraries
#       make clean  # to remove *.o *.exe *.mod
#

SRC=src/
TEST=tests/

#PROG=wrapper
TEST1=test_funcs
TEST2=test_objs

LIST_MOD_F=\
$(SRC)Types_mod.f90\
$(SRC)Strings_Func_mod.f90\
$(SRC)H5_func_mod.f90\
$(SRC)H5_OO_mod.f90

LIST_SUB_F=\


# work compilation
#DIRLIBRARY_H=/usr/local/hdf5-1.8.11/hdf5

#LIBRARY_HF=hdf5_fortran
#LIBRARY_H=hdf5

#LIB=lib
#INC=include


# home compilation
DIRLIBRARY_H=/usr

LIBRARY_HF=hdf5_serial_fortran
LIBRARY_H=hdf5_serial
LIBRARY_HFL=hdf5_serialhl_fortran
LIBRARY_HL=hdf5_serial_hl

LIB=lib/x86_64-linux-gnu
INC=include/hdf5/serial/

# *.f90 -> *.o
LIST_MOD_O=$(LIST_MOD_F:.f90=.o)
LIST_SUB_O=$(LIST_SUB_F:.f90=.o)


#Compiler
FC = gfortran

#options for
FFLAGS= -fbounds-check -O0 -fconvert=big-endian -finit-local-zero -cpp -DLITTLE_ENDIAN -Wsurprising -ffree-line-length-none -I $(DIRLIBRARY_H)/$(INC) -I $(DIRLIBRARY_H)/$(LIB) 

$(TEST1).exe: $(TEST)$(TEST1).o $(LIST_MOD_O) $(LIST_SUB_O) \
	$(DIRLIBRARY_H)/$(LIB)/lib$(LIBRARY_HF).a \
	$(DIRLIBRARY_H)/$(LIB)/lib$(LIBRARY_H).a \
	$(DIRLIBRARY_H)/$(LIB)/lib$(LIBRARY_HL).a \
	$(DIRLIBRARY_H)/$(LIB)/lib$(LIBRARY_HFL).a 
	$(FC) $(FFLAGS) $(TEST)$(TEST1).o $(LIST_MOD_O) $(LIST_SUB_O) \
	-L$(DIRLIBRARY_H)/$(LIB) \
	-l$(LIBRARY_HF) \
	-L$(DIRLIBRARY_H)/$(LIB) \
	-l$(LIBRARY_H) \
	-l$(LIBRARY_HL) \
	-l$(LIBRARY_HFL) \
	-o $@

$(TEST2).exe: $(TEST)$(TEST2).o $(LIST_MOD_O) $(LIST_SUB_O) \
	$(DIRLIBRARY_H)/$(LIB)/lib$(LIBRARY_HF).a \
	$(DIRLIBRARY_H)/$(LIB)/lib$(LIBRARY_H).a \
	$(DIRLIBRARY_H)/$(LIB)/lib$(LIBRARY_HL).a \
	$(DIRLIBRARY_H)/$(LIB)/lib$(LIBRARY_HFL).a 
	$(FC) $(FFLAGS) $(TEST)$(TEST2).o $(LIST_MOD_O) $(LIST_SUB_O) \
	-L$(DIRLIBRARY_H)/$(LIB) \
	-l$(LIBRARY_HF) \
	-L$(DIRLIBRARY_H)/$(LIB) \
	-l$(LIBRARY_H) \
	-l$(LIBRARY_HL) \
	-l$(LIBRARY_HFL) \
	-o $@

#	-l$(LIBRARY_HL) \
#	-l$(LIBRARY_HFL) \
#	$(DIRLIBRARY_H)/$(LIB)/lib$(LIBRARY_HL).a \
#	$(DIRLIBRARY_H)/$(LIB)/lib$(LIBRARY_HFL).a 

clean:
	rm -f $(SRC)*.o $(TEST)*.o *.exe *.mod *.o

mod:
	$(FC) -c $(FFLAGS) $(LIST_MOD_F)

all:
	make clean
	make mod
	make 

.SUFFIXES: .f90 .o

.f90.o : 
	$(FC) -c $(FFLAGS) $*.f90 -o $*.o


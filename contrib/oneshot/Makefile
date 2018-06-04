ROOT := ../..

INCDIRS := $(ROOT)/src
ALL_EXE := gwRemoveImgGallery gwBaseCompatiblePlus gwFixDateText gwExportAscCSV
EVERYTHING_EXE := gwFixAddEvent gwMostAsc
LIBS = unix

include $(ROOT)/tools/Makefile.common

gwFixAddEvent.ml: $(ROOT)/src/pa_lock.cmo

gwFixAddEvent.ml: CAMLP5 = camlp5r $(ROOT)/src/pa_lock.cmo

depend .depend: gwFixAddEvent.ml

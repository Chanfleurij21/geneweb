include tools/Makefile.config
-include $(ROOT)/Makefile.local

INCDIRS=src wserver

OCAMLI=$(foreach d,$(INCDIRS),-I $d) -I $(CAMLP5D)
OCAMLC=$(OCAMLC_PATH) $(OCAMLFLAGS)
OCAMLOPT=$(OCAMLOPT_PATH) $(OCAMLFLAGS)
OCAML_opt_LINK=$(OCAMLOPT) $(LINKSTATIC_opt)
OCAML_out_LINK=$(OCAMLC) $(LINKSTATIC_out)

ALL_EXE = \
	src/gwc1 \
	src/gwc2 \
	src/mk_consang \
	src/gwd \
	src/gwu \
	src/update_nldb \
	ged2gwb/ged2gwb \
	ged2gwb/ged2gwb2 \
	gwb2ged/gwb2ged \
	gwtp/gwtp \
	gui/gui \
	contrib/gwpublic/gwpublic1 \
	contrib/gwpublic/gwpublic2 \
	contrib/gwpublic/gwpublic2priv \
	contrib/gwpublic/gwprivate \
	contrib/gwpublic/gwiftitles \
	contrib/gwFix/gwFixBase \
	contrib/gwFix/gwFixFromFile \
	contrib/gwFix/gwFixFromFileDomicile \
	contrib/gwFix/gwFixFromFileAlias \
	contrib/gwFix/gwFixBurial \
	contrib/gwFix/gwFixEvtSrc \
	contrib/gwFix/gwFixColon \
	contrib/gwFix/gwFindCpl \
	contrib/gwFix/gwFixY \
	contrib/gwdiff/gwdiff \
	contrib/gwbase/etc/public \
	contrib/gwbase/etc/public2 \
	contrib/history/convert_hist \
	contrib/history/fix_hist \
	contrib/history/is_gw_plus \
	contrib/lex/lex_utils \
	contrib/misc/lower_string \
	contrib/oneshot/gwRemoveImgGallery \
	contrib/oneshot/gwBaseCompatiblePlus \
	contrib/oneshot/gwFixDateText \
	contrib/oneshot/gwExportAscCSV

EVERYTHING_EXE = \
	$(ALL_EXE) \
	contrib/gwbase/etc/geneanet \
	contrib/gwbase/etc/clavier \
	contrib/gwbase/etc/connex \
	contrib/gwbase/etc/hist \
	contrib/gwbase/etc/selroy \
	contrib/gwbase/etc/chkimg \
	contrib/gwbase/etc/consmoy \
	contrib/gwbase/etc/lune \
	contrib/gwbase/etc/titres \
	contrib/gwbase/etc/gwck \
	contrib/gwbase/etc/nbdesc \
	contrib/gwbase/etc/probot \
	contrib/oneshot/gwFixAddEvent \
	contrib/oneshot/gwMostAsc \
	dag2html/main \
	gwtp/recover \
	src/check_base

opt: $(ALL_EXE:=.native)
out: $(ALL_EXE:=.byte)

CAMLP5_PA_HTML_FILES = \
	src/advSearchOk \
	src/alln \
	src/api_wiki \
	src/birthday \
	src/birthDeath \
	src/changeChildren \
	src/cousins \
	src/dag \
	src/descend \
	src/history_diff \
	src/hutil \
	src/merge \
	src/mergeInd \
	src/mergeDup \
	src/mergeFam \
	src/notes \
	src/relation \
	src/relationLink \
	src/sendImage \
	src/some \
	src/title \
	src/update \
	src/updateData \
	src/updateInd \
	src/wiki \
	src/wiznotes \
	src/gwd

CAMLP5_PA_EXTAND_FILES = \
	src/templ \
	src/pa_lock \
	src/pa_html \
	src/pr_transl \
	ged2gwb/ged2gwb \
	ged2gwb/ged2gwb2 \
	wserver/wserver

CAMLP5_PA_LOCK_FILES = \
	src/mk_consang \
	src/gwc1 \
	src/gwc2 \
	src/gwd \
	src/srcfile \
	src/api_saisie_autocomplete \
	ged2gwb/ged2gwb \
	ged2gwb/ged2gwb2 \
	gwtp/gwtp \
	contrib/gwpublic/gwpublic1 \
	contrib/gwpublic/gwpublic2 \
	contrib/gwpublic/gwpublic2priv \
	contrib/gwpublic/gwprivate \
	contrib/gwpublic/gwiftitles \
	contrib/gwbase/etc/gwck \
	contrib/oneshot/gwFixAddEvent

CAMLP5_Q_MLAST_FILES = \
	src/templ \
	src/pa_lock \
	src/pa_html \
	src/pr_transl \
	src/gwd

CAMLP5_PA_MACRO_FILES = src/gwd

CAMLP5_FILES = $(sort $(CAMLP5_PA_HTML_FILES) $(CAMLP5_PA_LOCK_FILES) $(CAMLP5_Q_MLAST_FILES) $(CAMLP5_PA_MACRO_FILES) $(CAMLP5_PA_EXTAND_FILES))

src/q_codes.cm% src/pa_lock.cm% src/pa_html.cm% src/gwd.cm% src/pr_transl.cm%: PP = -I $(CAMLP5D)

$(CAMLP5_PA_HTML_FILES:=.ml): CAMLP5_OPT += src/pa_html.cmo
$(CAMLP5_PA_LOCK_FILES:=.ml): CAMLP5_OPT += src/pa_lock.cmo
$(CAMLP5_PA_EXTAND_FILES:=.ml): CAMLP5_OPT += pa_extend.cmo
$(CAMLP5_Q_MLAST_FILES:=.ml): CAMLP5_OPT += q_MLast.cmo
$(CAMLP5_PA_MACRO_FILES:=.ml): CAMLP5_OPT += pa_macro.cmo

$(CAMLP5_PA_LOCK_FILES:=.ml): src/pa_lock.cmo
$(CAMLP5_PA_HTML_FILES:=.ml): src/pa_html.cmo

%.cmi: %.mli
	$(OCAMLC) -c $(OCAMLI) $<

%.cmo: %.ml
	$(OCAMLC) -c $(OCAMLI) $<

%.cmx: %.ml
	$(OCAMLOPT) -c $(OCAMLI) $<

%.ml: CAMLP5_OPT=

%.ml: %.camlp5
	@[ -z "$(CAMLP5_OPT)" ] \
	&& echo "ERROR generating $@: CAMLP5_OPT variable must be defined" \
	|| (echo -n "Generating $@..." \
	    && echo "(* DO NOT EDIT *)" > $@ \
	    && echo "(* This file was generated from $< *)" >> $@ \
	    && camlp5o pr_o.cmo -I $(CAMLP5D) $(CAMLP5_OPT) -impl $< >> $@ \
	    && echo " Done!")

compile-ml: $(CAMLP5_FILES:=.camlp5) $(CAMLP5_FILES:=.ml)

clean-ml:
	$(RM) $(CAMLP5_FILES:=.ml)

clean-cm:
	$(RM) $(CAMLP5_FILES:=.cm[ioxa])

clean: clean-cm

%.native %.byte:
	ocamlbuild -use-ocamlfind -r -I +camlp5 -Is wserver,src,dag2html -lib camlp5 -pkgs piqirun.ext,piqirun.ext,redis-sync,yojson,curl,camlp5,str,lablgtk2 -no-links $@

ocamlbuild: $(CAMLP5_FILES:=.ml) src/gwlib.ml clean-cm $(EVERYTHING_EXE:=.native)

ocamlbuild-clean:
	ocamlbuild -clean

src/gwlib.ml:
	echo "let prefix =" > $@
	echo "  try Sys.getenv \"GWPREFIX\"" >> $@
	echo "  with Not_found -> \"$(PREFIX)\"" | sed -e 's|\\|/|g' >> $@

.PHONY: install uninstall distrib

install:
	PWD=`pwd`
	if test "$(OS_TYPE)" = "Darwin"; then \
	    etc/macOS/install.command $(PWD) $(DESTDIR) etc/macOS; \
	elif test "$(OS_TYPE)" = "Win"; then \
		echo "No install for Window"; \
	else \
		mkdir -p $(PREFIX)/bin; \
		cp src/gwc1 $(PREFIX)/bin/gwc$(EXE); \
		cp src/gwc1 $(PREFIX)/bin/gwc1$(EXE); \
		cp src/gwc2 $(PREFIX)/bin/gwc2$(EXE); \
		cp src/mk_consang $(PREFIX)/bin/mk_consang$(EXE); \
		cp src/mk_consang $(PREFIX)/bin/consang$(EXE); \
		cp src/gwd $(PREFIX)/bin/gwd$(EXE); \
		cp src/gwu $(PREFIX)/bin/gwu$(EXE); \
		cp ged2gwb/ged2gwb $(PREFIX)/bin/ged2gwb$(EXE); \
		cp ged2gwb/ged2gwb2 $(PREFIX)/bin/ged2gwb2$(EXE); \
		cp gwb2ged/gwb2ged $(PREFIX)/bin/gwb2ged$(EXE); \
		cp setup/setup $(PREFIX)/bin/gwsetup$(EXE); \
		cp src/update_nldb $(PREFIX)/bin/update_nldb$(EXE); \
		mkdir -p $(LANGDIR); \
		cp -R hd/* $(LANGDIR)/.; \
		mkdir -p $(MANDIR); \
		cd man; cp $(MANPAGES) $(MANDIR)/.; \
	fi

uninstall:
	$(RM) $(PREFIX)/bin/gwc$(EXE)
	$(RM) $(PREFIX)/bin/gwc1$(EXE)
	$(RM) $(PREFIX)/bin/gwc2$(EXE)
	$(RM) $(PREFIX)/bin/mk_consang$(EXE)
	$(RM) $(PREFIX)/bin/consang$(EXE)
	$(RM) $(PREFIX)/bin/gwd$(EXE)
	$(RM) $(PREFIX)/bin/gwu$(EXE)
	$(RM) $(PREFIX)/bin/ged2gwb$(EXE)
	$(RM) $(PREFIX)/bin/gwb2ged$(EXE)
	$(RM) $(PREFIX)/bin/gwsetup$(EXE)
	$(RM) $(PREFIX)/bin/update_nldb$(EXE)
	$(RM) -r $(PREFIX)/share/geneweb
	cd $(MANDIR); $(RM) $(MANPAGES)

distribution: distrib
distrib:
	$(RM) -r $(DESTDIR)
	mkdir $(DESTDIR)
	mkdir -p $(DESTDIR)/bases
	cp CHANGES $(DESTDIR)/CHANGES.txt
	cp LICENSE $(DESTDIR)/LICENSE.txt
	cp etc/README.txt $(DESTDIR)/.
	cp etc/LISEZMOI.txt $(DESTDIR)/.
	cp etc/START.htm $(DESTDIR)/.
	if test $(OS_TYPE) = "Win"; then \
	  cp etc/Windows/gwd.bat $(DESTDIR); \
	  cp etc/Windows/gwsetup.bat $(DESTDIR); \
	  cp -f etc/Windows/README.txt $(DESTDIR)/README.txt; \
	  cp -f etc/Windows/LISEZMOI.txt $(DESTDIR)/LISEZMOI.txt; \
	elif test $(OS_TYPE) = "Darwin"; then \
	  cp etc/gwd $(DESTDIR)/gwd.command; \
	  cp etc/gwsetup $(DESTDIR)/gwsetup.command; \
	  cp etc/macOS/geneweb.command $(DESTDIR); \
	else \
	  cp etc/gwd $(DESTDIR); \
	  cp etc/gwsetup $(DESTDIR); \
	fi
	mkdir $(DESTDIR)/gw
	cp etc/a.gwf $(DESTDIR)/gw/.
	echo "127.0.0.1" > $(DESTDIR)/gw/only.txt
	echo "-setup_link" > $(DESTDIR)/gw/gwd.arg
	cp src/gwc1 $(DESTDIR)/gw/gwc$(EXE)
	cp src/gwc1 $(DESTDIR)/gw/gwc1$(EXE)
	cp src/gwc2 $(DESTDIR)/gw/gwc2$(EXE)
	cp src/mk_consang $(DESTDIR)/gw/mk_consang$(EXE)
	cp src/mk_consang $(DESTDIR)/gw/consang$(EXE)
	cp src/gwd $(DESTDIR)/gw/gwd$(EXE)
	cp src/gwu $(DESTDIR)/gw/gwu$(EXE)
	cp src/update_nldb $(DESTDIR)/gw/update_nldb$(EXE)
	cp ged2gwb/ged2gwb $(DESTDIR)/gw/ged2gwb$(EXE)
	cp ged2gwb/ged2gwb2 $(DESTDIR)/gw/ged2gwb2$(EXE)
	cp gwb2ged/gwb2ged $(DESTDIR)/gw/gwb2ged$(EXE)
	cp setup/setup $(DESTDIR)/gw/gwsetup$(EXE)
	mkdir $(DESTDIR)/gw/gwtp_tmp
	mkdir $(DESTDIR)/gw/gwtp_tmp/lang
	cp gwtp/README $(DESTDIR)/gw/gwtp_tmp/.
	cp gwtp/gwtp $(DESTDIR)/gw/gwtp_tmp/gwtp$(EXE)
	cp gwtp/lang/*.txt $(DESTDIR)/gw/gwtp_tmp/lang/.
	mkdir $(DESTDIR)/gw/setup
	cp setup/intro.txt $(DESTDIR)/gw/setup/.
	mkdir $(DESTDIR)/gw/setup/lang
	if test $(OS_TYPE) = "Win"; then \
	  cp setup/lang/intro.txt.dos $(DESTDIR)/gw/setup/lang/intro.txt; \
	else \
	  cp setup/lang/intro.txt $(DESTDIR)/gw/setup/lang/intro.txt; \
	fi
	cp setup/lang/*.htm $(DESTDIR)/gw/setup/lang/.
	cp setup/lang/lexicon.txt $(DESTDIR)/gw/setup/lang/.
	cp -R hd/* $(DESTDIR)/gw/.

.merlin:
	echo "PKG $(PACKAGES)" > $@
	$(foreach target,$(ALL_TARGETS) $(EVERYTHING_TARGETS),printf "S $(target)\nB $(target)\n" >> $@$(\n))

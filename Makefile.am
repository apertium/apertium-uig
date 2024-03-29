###############################################################################
## Makefile for apertium-uig
###############################################################################

LANG1=uig
BASENAME=apertium-$(LANG1)

TARGETS_COMMON = $(LANG1).automorf.hfst $(LANG1).autogen.hfst \
	$(LANG1)_guesser.automorf.hfst \
	$(LANG1).automorf.bin $(LANG1).autogen.bin \
	$(LANG1).autopgen.bin \
	$(LANG1)_guesser.automorf.bin \
	$(LANG1).automorf.att.gz $(LANG1).autogen.att.gz

if HAVE_VISLCG3
TARGETS_COMMON += $(LANG1).rlx.bin
endif # HAVE_VISLCG3


#	$(LANG1).autopgen.bin 

# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@

###############################################################################
## Uyghur transducer
###############################################################################

## Chinese 

.deps/cjk.hfst: dev/cjk.lexc .deps/.d
	hfst-lexc $< -o $@

## Guesser

.deps/guesser.hfst: $(LANG1).guesser.hfst .deps/.d
	echo "" | hfst-xfst -e "source $<" -e "save stack $@" -e "quit"

.deps/$(LANG1)_guesser.lexc.hfst: .deps/$(LANG1).LR.lexc.hfst .deps/guesser.hfst .deps/.d 
	hfst-substitute -i .deps/$(LANG1).LR.lexc.hfst -o $@ -f '{🂡}:{🂡}' -T .deps/guesser.hfst

.deps/restrict_guesser.hfst: $(LANG1).restrict_guesser.hfst .deps/.d
	hfst-regexp2fst $< -o $@

.deps/$(LANG1)_guesser.hfst: .deps/$(LANG1)_guesser.lexc.hfst .deps/$(LANG1).twol.hfst 
	hfst-compose-intersect -1 .deps/$(LANG1)_guesser.lexc.hfst -2 .deps/$(LANG1).twol.hfst -o $@

$(LANG1)_guesser.automorf.hfst: .deps/$(LANG1)_guesser.hfst .deps/spellrelax.hfst .deps/restrict_guesser.hfst .deps/cjk.hfst
	cat .deps/$(LANG1)_guesser.hfst | hfst-invert | hfst-compose -1 - -2 .deps/restrict_guesser.hfst | hfst-invert | hfst-compose-intersect -1 - -2 .deps/spellrelax.hfst | hfst-substitute -f '{乚}:{乚}' -T .deps/cjk.hfst | hfst-invert | hfst-fst2fst -O -o $@

$(LANG1)_guesser.automorf.bin: $(LANG1)_guesser.automorf.hfst .deps/.d
	hfst-fst2txt $(LANG1)_guesser.automorf.hfst   > .deps/$(LANG1)_guesser.autogen.att
	lt-comp lr .deps/$(LANG1)_guesser.autogen.att $@

## For orthogrpahic/phonological "errors"

.deps/$(LANG1).err.hfst: $(BASENAME).err.twol .deps/.d
	hfst-twolc $< -o $@

# We make an uig.LR.err.hfst by taking the transducer produced from the 
# twol file with error rules (apertium-uig.err.twol), we then remove all the
# strings from that which are in the normative orthography transducer.
# After that we append <err_orth> to the tag string.
.deps/$(LANG1).LR.err.hfst: .deps/$(LANG1).LR.lexc.hfst .deps/$(LANG1).err.hfst .deps/$(LANG1).LR.hfst
# lexc + error model twol
	hfst-compose-intersect -1 .deps/$(LANG1).LR.lexc.hfst -2 .deps/$(LANG1).err.hfst | hfst-minimise -o .deps/$(LANG1).LR.err.hfst.tmp
# extract valid surface forms
	hfst-project -p output .deps/uig.LR.hfst | hfst-minimise -o .deps/$(LANG1).LR.corr.hfst.tmp
# get the valid surface forms that are in the error model
	hfst-invert .deps/$(LANG1).LR.err.hfst.tmp | hfst-compose -1 .deps/$(LANG1).LR.corr.hfst.tmp -2 - | hfst-invert -o .deps/$(LANG1).LR.err.hfst.tmp2
# subtract the valid surface forms from the error model
	hfst-subtract -1 .deps/$(LANG1).LR.err.hfst.tmp -2 .deps/$(LANG1).LR.err.hfst.tmp2 -o .deps/$(LANG1).LR.err.hfst.tmp3
# append the error tag to the error model strings
	echo "<err_orth>:0" | hfst-strings2fst -e 0 -S | hfst-concatenate -1 .deps/$(LANG1).LR.err.hfst.tmp3 -2 - -o $@


## Spellrelax

.deps/spellrelax.hfst: dev/spellrelax.twol .deps/.d
	hfst-twolc $< -o $@

.deps/$(LANG1).twol.hfst: $(BASENAME).$(LANG1).twol .deps/.d
	hfst-twolc $< -o $@

.deps/$(LANG1).RL.lexc: $(BASENAME).$(LANG1).lexc .deps/.d
	cat $< | grep -v 'Dir/LR' > $@

.deps/$(LANG1).LR.lexc: $(BASENAME).$(LANG1).lexc .deps/.d
	cat $< | grep -v 'Dir/RL' > $@

.deps/$(LANG1).RL.lexc.hfst: .deps/$(LANG1).RL.lexc
	hfst-lexc $< -o $@ -v

.deps/$(LANG1).LR.lexc.hfst: .deps/$(LANG1).LR.lexc
	hfst-lexc $< -o $@ -v

.deps/$(LANG1).RL.hfst: .deps/$(LANG1).RL.lexc.hfst .deps/$(LANG1).twol.hfst
	hfst-compose-intersect -1 .deps/$(LANG1).RL.lexc.hfst -2 .deps/$(LANG1).twol.hfst -o $@

.deps/$(LANG1).LR.hfst: .deps/$(LANG1).LR.lexc.hfst .deps/$(LANG1).twol.hfst
	hfst-compose-intersect -1 .deps/$(LANG1).LR.lexc.hfst -2 .deps/$(LANG1).twol.hfst -o $@

$(LANG1).autogen.hfst: .deps/$(LANG1).RL.hfst
	hfst-fst2fst -O $< -o $@

$(LANG1).automorf.hfst: .deps/$(LANG1).LR.hfst .deps/spellrelax.hfst .deps/cjk.hfst .deps/$(LANG1).LR.err.hfst
	hfst-compose-intersect -1 $< -2 .deps/spellrelax.hfst |	hfst-substitute -f '{乚}:{乚}' -T .deps/cjk.hfst | hfst-union -1 - -2 .deps/$(LANG1).LR.err.hfst | hfst-invert | hfst-fst2fst -O -o $@

$(LANG1).autogen.att.gz: $(LANG1).autogen.hfst
	hfst-fst2txt $< | gzip -9 -c -n > $@

$(LANG1).automorf.att.gz: $(LANG1).automorf.hfst
	hfst-fst2txt $< | gzip -9 -c -n > $@

$(LANG1).autogen.bin: $(LANG1).autogen.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).autogen.att
	lt-comp lr .deps/$(LANG1).autogen.att $@

$(LANG1).automorf.bin: $(LANG1).automorf.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).automorf.att
	lt-comp lr .deps/$(LANG1).automorf.att $@

###############################################################################
## Debugging transducers (for testvoc)
###############################################################################

debug: .deps/$(LANG1).LR-debug.hfst .deps/$(LANG1).lexc.hfst

.deps/$(LANG1).LR-debug.hfst: $(BASENAME).$(LANG1).lexc .deps/.d
	cat $< | grep -v 'Dir/RL' | grep -v 'Use/Circ' > .deps/$(LANG1).LR-debug.lexc
	hfst-lexc .deps/$(LANG1).LR-debug.lexc -o .deps/$(LANG1).LR-debug.lexc.hfst -v
	hfst-compose-intersect -1 .deps/$(LANG1).LR-debug.lexc.hfst -2 .deps/$(LANG1).twol.hfst -o $@

.deps/$(LANG1).lexc.hfst: .deps/$(LANG1).RL.lexc.hfst
	hfst-fst2fst -O -i $< -o $@

###############################################################################
## Postgeneration
###############################################################################
$(LANG1).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	lt-comp lr $< $@

###############################################################################
## Disambiguation rules
###############################################################################

$(LANG1).rlx.bin: $(BASENAME).$(LANG1).rlx $(CGCOMP)
	$(CGCOMP) $< $@

###############################################################################
## Spell checker
###############################################################################

$(LANG1).zhfst: .deps/acceptor.default.hfst .deps/errmodel.default.hfst
	rm -f $@
	zip -j $@ .deps/acceptor.default.hfst .deps/errmodel.default.hfst speller/index.xml

.deps/errmodel.default.hfst: .deps/words.default.hfst .deps/strings.default.hfst
	python dev/editdist.py -v -s -d 1 -e '@0@' -i speller/editdist.default.txt -a .deps/acceptor.default.hfst \
	| hfst-txt2fst  -e '@0@' -o .deps/editdist.default.hfst
	hfst-disjunct .deps/strings.default.hfst .deps/editdist.default.hfst \
	| hfst-minimise | hfst-repeat -f 1 -t 2 -o .deps/editstrings.default.hfst
	hfst-disjunct .deps/words.default.hfst .deps/editstrings.default.hfst \
	| hfst-fst2fst  -f olw -o $@

.deps/words.default.hfst: speller/words.default.txt
	grep -v -e "^#" -e "^$$" $< | hfst-strings2fst  -j -o $@

.deps/strings.default.hfst: speller/strings.default.txt .deps/anystar.hfst
	grep -v -e "^#" -e "^$$" $< | hfst-strings2fst  -j | hfst-concatenate .deps/anystar.hfst - |\
	hfst-concatenate - .deps/anystar.hfst -o $@

.deps/anystar.hfst:
	echo "?*;" | hfst-regexp2fst -S -o $@

.deps/acceptor.default.hfst: $(LANG1).autogen.hfst
	cat $< | hfst-fst2fst -t | hfst-project  --project=lower | hfst-minimise |hfst-fst2fst  -f olw -o $@


###############################################################################
## Distribution
###############################################################################
EXTRA_DIST=$(BASENAME).$(LANG1).lexc \
	   $(BASENAME).$(LANG1).twol \
	   $(BASENAME).$(LANG1).rlx  \
	   $(BASENAME).post-$(LANG1).dix  \
	   modes.xml

###############################################################################
## Installation stuff
###############################################################################
#
#   apertium_uig_dir: This is where the compiled binaries go
#   apertium_uig_srcdir: This is where the source files go

apertium_uigdir=$(prefix)/share/apertium/$(BASENAME)/
apertium_uig_srcdir=$(prefix)/share/apertium/$(BASENAME)/

EXTRA_TARGETS=

if HAVE_HFSTOSPELL
EXTRA_TARGETS += $(LANG1).zhfst
endif # HAVE_HFSTOSPELL

apertium_uig_DATA=$(TARGETS_COMMON) $(EXTRA_TARGETS) $(LANG1).prob \
				  $(BASENAME).$(LANG1).lexc $(BASENAME).$(LANG1).twol \
				  $(BASENAME).$(LANG1).rlx $(BASENAME).post-$(LANG1).dix

pkgconfigdir = $(prefix)/share/pkgconfig
pkgconfig_DATA = $(BASENAME).pc

noinst_DATA=modes/$(LANG1)-morph.mode

install-data-local: install-modes
uninstall-local: uninstall-modes

###############################################################################
## Cleanup
###############################################################################


CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

test: all
	apertium-regtest test

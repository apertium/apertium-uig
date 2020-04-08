all: uig-MULTI.automorf.hfst uig-CYR.automorf.bin uig-CYR.autogen.hfst uig-LAT.automorf.hfst uig-LAT.autogen.hfst uig-MULTI.automorf.bin

# all: ara-cyr-test.hfst ara-lat-test.hfst cyr-ara-test.hfst lat-ara-test.hfst

%.lexc.hfst: %.lexc
	hfst-lexc $< -o $@

%.twol.hfst: %.twol
	hfst-twolc $< -o $@

%-test.hfst: %.twol.hfst %.lexc.hfst
	hfst-compose-intersect -1 $(word 2,$^) -2 $< | hfst-fst2fst -o $@ -O

%.hfst: %.twol.hfst %.lexc.hfst
	hfst-compose-intersect -1 $(word 2,$^) -2 $< -o $@

uig-CYR.autogen.hfst: ../../.deps/uig.LR.hfst ara-cyr.hfst
	hfst-minimise $< | hfst-compose-intersect -1 - -2 $(word 2,$^) -o $@

uig-CYR.REVautomorf.hfst: ../../.deps/uig.LR.hfst ara-cyr.hfst
	hfst-minimise $< | hfst-compose-intersect -1 - -2 $(word 2,$^) -o $@

uig-CYR.automorf.hfst: uig-CYR.REVautomorf.hfst
	hfst-invert $< -o $@

# This works fine as an hfst using hfst-proc, but I get "Error: Invalid dictionary (hint: the left side of an entry is empty)"
# if I run it as a .bin using lt-proc.
# uig-CYR.automorf.hfst: ../../.deps/uig.LR.hfst cyr-ara.hfst
# 	hfst-invert $< | hfst-minimise | hfst-compose-intersect -1 $(word 2,$^) -2 - -o $@

uig-LAT.autogen.hfst: ../../.deps/uig.LR.hfst ara-lat.hfst
	hfst-minimise $< | hfst-compose-intersect -1 - -2 $(word 2,$^) -o $@

uig-LAT.REVautomorf.hfst: ../../.deps/uig.LR.hfst ara-lat.hfst
	hfst-minimise $< | hfst-compose-intersect -1 - -2 $(word 2,$^) -o $@

uig-LAT.automorf.hfst: uig-LAT.REVautomorf.hfst
	hfst-invert $< -o $@

# This works fine as an hfst using hfst-proc, but it finds no analyses for any vowel-initial word when run as a .bin
# e..g, 'adem' won't return an analysis.
# uig-LAT.automorf.hfst: ../../.deps/uig.LR.hfst lat-ara.hfst
# 	hfst-invert $< | hfst-minimise | hfst-compose-intersect -1 $(word 2,$^) -2 - -o $@

uig-MULTI.automorf.hfst: uig.LR.hfst uig-LAT.automorf.hfst uig-CYR.automorf.hfst
	hfst-invert $< | hfst-minimise | hfst-union -1 - -2 $(word 2,$^) | hfst-union -1 - -2 $(word 3,$^) | hfst-fst2fst -O -i - -o $@

uig.LR.lexc.hfst: ../../apertium-uig.uig.lexc
	cat $< | grep -v 'Use/Ortho' | hfst-lexc - -o $@ -v

uig.LR.hfst: uig.LR.lexc.hfst ../../.deps/uig.twol.hfst ../../.deps/spellrelax.hfst ../../.deps/cjk.hfst ../../.deps/uig.LR.err.hfst
	hfst-compose-intersect -1 $< -2 $(word 2,$^) | hfst-compose-intersect -1 - -2 $(word 3,$^) | hfst-substitute -f '{乚}:{乚}' -T $(word 4,$^) | hfst-union -1 - -2 $(word 5,$^) -o $@

%.att.gz: %.hfst
	hfst-fst2txt $< | gzip -9 -c -n > $@

%.bin: %.att.gz
	zcat < $< > %.att
	lt-comp lr %.att $@

clean:
	rm *.hfst *.att *.att.gz

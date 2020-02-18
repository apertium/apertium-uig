all: uig-CYR.automorf.hfst uig-CYR.automorf.bin uig-CYR.autogen.hfst uig-LAT.automorf.hfst uig-LAT.automorf.bin uig-LAT.autogen.hfst ara-cyr.hfst ara-lat.hfst

#all: ara-lat.hfst ara-cyr.hfst ara-lat-rev.hfst ara-cyr-rev.hfst

ara-cyr.lexc.hfst: ara-cyr.lexc
	hfst-lexc $< -o $@

ara-cyr.twol.hfst: ara-cyr.twol
	hfst-twolc $< -o $@

# ara-cyr.hfst: ara-cyr.twol.hfst ara-cyr.lexc.hfst
# 	hfst-compose-intersect -1 $(word 2,$^) -2 $< | hfst-fst2fst -o $@ -O

# ara-cyr-rev.hfst: ara-cyr.twol.hfst ara-cyr.lexc.hfst
# 	hfst-compose-intersect -1 $(word 2,$^) -2 $<  | hfst-invert | hfst-fst2fst -o $@ -O

ara-cyr.hfst: ara-cyr.twol.hfst ara-cyr.lexc.hfst
	hfst-compose-intersect -1 $(word 2,$^) -2 $< -o $@

ara-lat.lexc.hfst: ara-lat.lexc
	hfst-lexc $< -o $@

ara-lat.twol.hfst: ara-lat.twol
	hfst-twolc $< -o $@

# ara-lat.hfst: ara-lat.twol.hfst ara-lat.lexc.hfst
# 	hfst-compose-intersect -1 $(word 2,$^) -2 $<  | hfst-fst2fst -o $@ -O

# ara-lat-rev.hfst: ara-lat.twol.hfst ara-lat.lexc.hfst
# 	hfst-compose-intersect -1 $(word 2,$^) -2 $<  | hfst-invert | hfst-fst2fst -o $@ -O

ara-lat.hfst: ara-lat.twol.hfst ara-lat.lexc.hfst
	hfst-compose-intersect -1 $(word 2,$^) -2 $<  -o $@

uig-CYR.autogen.hfst: ../../.deps/uig.LR.hfst ara-cyr.hfst
	hfst-minimise $< | hfst-compose-intersect -1 - -2 $(word 2,$^) -o $@

uig-CYR.REVautomorf.hfst: ../../.deps/uig.RL.hfst ara-cyr.hfst
	hfst-minimise $< | hfst-compose-intersect -1 - -2 $(word 2,$^) -o $@

uig-CYR.automorf.hfst: uig-CYR.REVautomorf.hfst
	hfst-invert $< -o $@

uig-LAT.autogen.hfst: ../../.deps/uig.LR.hfst ara-lat.hfst
	hfst-minimise $< | hfst-compose-intersect -1 - -2 $(word 2,$^) -o $@

uig-LAT.REVautomorf.hfst: ../../.deps/uig.RL.hfst ara-lat.hfst
	hfst-minimise $< | hfst-compose-intersect -1 - -2 $(word 2,$^) -o $@

uig-LAT.automorf.hfst: uig-LAT.REVautomorf.hfst
	hfst-invert $< -o $@

%.att.gz: %.hfst
	hfst-fst2txt $< | gzip -9 -c -n > $@

%.bin: %.att.gz
	zcat < $< > %.att
	lt-comp lr %.att $@

clean:
	rm *.hfst *.att *.att.gz

all: uig-ARA.automorf.hfst uig-ARA.automorf.bin uig-ARA.autogen.hfst #ara-cyr.lexc.hfst

ara-cyr.lexc.hfst: ara-cyr.lexc
	hfst-lexc $< -o $@

uig-ARA.autogen.hfst: ../../.deps/uig.LR.hfst ara-cyr.lexc.hfst
	hfst-minimise $< | hfst-compose-intersect -1 - -2 ara-cyr.lexc.hfst -o $@

uig-ARA.REVautomorf.hfst: ../../.deps/uig.RL.hfst ara-cyr.lexc.hfst
	hfst-minimise $< | hfst-compose-intersect -1 - -2 ara-cyr.lexc.hfst -o $@

uig-ARA.automorf.hfst: uig-ARA.REVautomorf.hfst
	hfst-invert $< -o $@

%.att.gz: %.hfst
	hfst-fst2txt $< | gzip -9 -c -n > $@

%.bin: %.att.gz
	zcat < $< > %.att
	lt-comp lr %.att $@
	

clean:
	rm *.hfst *.att *.att.gz

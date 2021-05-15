MODULE ?= main

use_tty:=$(shell [ -t 0 ] && echo -it)

docker_img := kovagoz/icestorm
docker_run := docker run --rm $(use_tty) -v $(PWD):/host -w /host
docker_cmd := $(docker_run) $(docker_img)

.PHONY: build
build: src/$(MODULE).bin

src/$(MODULE).bin: src/$(MODULE).asc
	$(docker_cmd) icepack $< $@

src/$(MODULE).asc: src/$(MODULE).json constraints.pcf
	$(docker_cmd) nextpnr-ice40 --hx1k --package vq100 --json $< --pcf $(word 2,$^) --asc $@

src/$(MODULE).json: src/$(MODULE).v
	$(docker_cmd) yosys -p 'synth_ice40 -top $(MODULE) -json $@' $<

constraints.pcf: # Download the constraints file for Go Board
	curl https://www.nandland.com/goboard/Go_Board_Constraints.pcf > $@

.PHONY: install
install: src/$(MODULE).bin # Send bitstream to the Go Board
	$(docker_run) --device /dev/ttyUSB1 --privileged --user 0 $(docker_img) iceprog $<

.PHONY: clean
clean:
	rm -f src/*.{json,asc,bin,vvp,vcd}

.PHONY: test # Run the simulation and open it in GTKWave
test: src/$(MODULE).vcd
	open -a gtkwave $<

src/$(MODULE).vcd: src/$(MODULE).vvp
	$(docker_run) --entrypoint vvp kovagoz/iverilog:0.5.0 $<

src/$(MODULE).vvp: src/$(MODULE).v
	$(docker_run) kovagoz/iverilog:0.5.0 -I src -DDUMPFILE_PATH=$(basename $@).vcd -o $@ $<

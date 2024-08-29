PROJECT_NAME ?=led_counter
VERILOG_FILE := $(PROJECT_NAME).v
CONSTRAINT_FILE := $(PROJECT_NAME).cst
PLACE_AND_ROUTE_OUTPUT := $(PROJECT_NAME)_place_and_route.json
BIT_STREAM_FILE := $(PROJECT_NAME)_bit_stream.fs

TOP_MODULE ?= top
NET_LIST_FILE = $(PROJECT_NAME)_netlist.json

DEVICE_FAMILY = GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

HIGH_LEVEL_VISUAL := $(PROJECT_NAME)_hl

GENERATED_FILES = $(PLACE_AND_ROUTE_OUTPUT) $(NET_LIST_FILE) $(BIT_STREAM_FILE)

all: $(BIT_STREAM_FILE)

upload_memory: $(BIT_STREAM_FILE)
	openFPGALoader -b tangnano9k -m $<

$(NET_LIST_FILE): $(VERILOG_FILE)
	yosys -p "synth_gowin -top $(TOP_MODULE) -json $@" $<

$(PLACE_AND_ROUTE_OUTPUT): $(NET_LIST_FILE) $(CONSTRAINT_FILE)
	nextpnr-gowin --json $(NET_LIST_FILE) --write $@ --family $(DEVICE_FAMILY) --device $(DEVICE) --cst $(CONSTRAINT_FILE)

$(BIT_STREAM_FILE): $(PLACE_AND_ROUTE_OUTPUT)
	gowin_pack -d $(DEVICE_FAMILY) -o $@ $<

high_viz: $(VERILOG_FILE)
	yosys -p "read_verilog $(VERILOG_FILE); proc; opt; fsm; opt; memory; opt; show -prefix $(HIGH_LEVEL_VISUAL)"

clean:
	rm -f $(GENERATED_FILES)

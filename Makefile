BUILD_DIR := build_lvx

.PHONY: conf all check refs opcode

# Run the first line of HOWTO, which sets up the build tree from scratch.
conf:
	mkdir -p $(BUILD_DIR) && cd $(BUILD_DIR) && ../lvx-family/configure --target=lvx

all check refs:
	$(MAKE) -C $(BUILD_DIR) $@

FAMILY := $(shell sed -n 's/^FAMILY:=[[:space:]]*//p' $(BUILD_DIR)/Makerules)
CORES  := $(shell sed -n 's/^CORES:=[[:space:]]*//p' $(BUILD_DIR)/Makerules)
OPCODE_TXT := $(addprefix $(FAMILY)/,$(addsuffix /Opcode.txt,$(CORES)))

opcode:
	rm -f $(addprefix $(BUILD_DIR)/FE/YAML/,$(OPCODE_TXT))
	$(MAKE) -C $(BUILD_DIR)/FE/YAML $(OPCODE_TXT)

clean:
	rm -rf $(BUILD_DIR)


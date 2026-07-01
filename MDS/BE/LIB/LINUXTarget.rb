#!/usr/bin/env ruby


OpcodeVariantGen = Struct.new(:sizes, :opcodes, :variants)

module LINUXTarget 

	def get_opcode_prefix(target)
		return "Opcode-v1-"
	end

	def get_gpr_regfile_name(target)
		return "RegFile-#{target}-GPR"
	end

	def get_parallel_bitfield_name(target)
		return "BitField-#{target}-parallel"
	end

	def get_operand_register_name(target)
		"Operand-#{target}-register"
	end

	def get_selected_bitfields(target)
		selected_bitfields = {
			"BitField-#{target}-parallel" => BitfieldGenDecoding.new("PARALLEL",
				{
					"EOB" => "0",
					"NONE" => "1",
				}
			),
			"BitField-#{target}-steering" => BitfieldGenDecoding.new("STEERING",
				{
					"BCU" => "0",
					"LSU" => "1",
					"MAU_FPU" => "2",
					"ALU" => "3",
				}
			),
		}
		return selected_bitfields
	end

	def get_selected_opcode()
		selected_opcode = {
			"MAKE_registerW_signed16_simple" => OpcodeGenEncoding.new("MAKE_IMM16"),
			"MAKE_registerW_extend6_upper27_lower10_double" => OpcodeGenEncoding.new("MAKE_IMM43"),
			"MAKE_registerW_extend27_upper27_lower10_triple" => OpcodeGenEncoding.new("MAKE_IMM64"),
			"NOP_simple" => OpcodeGenEncoding.new("NOP"),
			"ERROP_simple" => OpcodeGenEncoding.new("ERROP"),
			# BCU
			"GOTO_pcrel27_simple"  => OpcodeGenEncoding.new("GOTO"),
			"IGOTO_registerZ_simple"  => OpcodeGenEncoding.new("IGOTO"),
			"CALL_pcrel27_simple"  => OpcodeGenEncoding.new("CALL"),
			"ICALL_registerZ_simple"  => OpcodeGenEncoding.new("ICALL"),
			"RET_simple"  => OpcodeGenEncoding.new("RET"),
			"CB_branchcond_registerZ_pcrel17_simple" => OpcodeGenEncoding.new("CB"),
			# LSU
			"SO_signed10_registerZ_registerV_simple" => OpcodeGenEncoding.new("SO_IMM10"),
			"LO_variant_registerN_signed10_registerZ_simple" => OpcodeGenEncoding.new("LO_IMM10"),
			"GET_registerZ_systemS3_simple" => OpcodeGenEncoding.new("GET"),
			"SET_systemT3_registerZ_simple" => OpcodeGenEncoding.new("SET"),
			# SBF
			"SBFD_registerW_registerZ_registerY_simple" => OpcodeGenEncoding.new("SBF_D"),
			"SBFW_registerW_registerZ_registerY_simple" => OpcodeGenEncoding.new("SBF_W"),
			# Synthetic
			"ZXBD_registerW_registerZ_simple" => OpcodeGenEncoding.new("ZXBD"),
			"ZXHD_registerW_registerZ_simple" => OpcodeGenEncoding.new("ZXHD"),
			"ZXWD_registerW_registerZ_simple" => OpcodeGenEncoding.new("ZXWD"),
			# SBMM
			"SBMM8_registerW_registerZ_extend27_upper27_lower10_triple" => OpcodeGenEncoding.new("SBMM8"),
		}

		alu_sizes = {
			"D" => "_D",
			"W" => "_W"
		}

		# Inject variants for some opcode
		arith_opcodes = ["AND", "OR", "XOR", "MUL", "ADD", "COMP"] 
		arith_variants = {
			"_registerW_registerZ_registerY_simple" => "",
			"_registerW_registerZ_upper27_lower10_double" => "_IMM37",
			"_registerW_registerZ_signed10_simple" => "_IMM10",
		}

		shift_opcodes = ["SLL", "SRL", "SRA"]
		shift_variants = {
			"_registerW_registerZ_registerY_simple" => "",
			"_registerW_registerZ_unsigned6_simple" => "_IMM6",
		}

		neg_copy_opcodes = ["NEG", "COPY"]
		neg_copy_variants = {
			"_registerW_registerZ_simple" => "",
		}

		comp_opcodes = ["COMP"]
		comp_variants = {
			"_comparison_registerW_registerZ_registerY_simple" => "",
			"_comparison_registerW_registerZ_signed10_simple" => "_IMM10",
		}

		load_opcode = ["LD", "LWZ", "LWS", "LHZ", "LBZ"]
		load_variants = {
			"_variant_registerW_signed10_registerZ_simple" => "_IMM10",
			"_variant_registerW_upper27_lower10_registerZ_double" => "_IMM37",
		}

		store_opcode = ["SD", "SW", "SH", "SB"]
		store_variants = {
			"_signed10_registerZ_registerT_simple" => "_IMM10",
			"_upper27_lower10_registerZ_registerT_double" => "_IMM37",
		}


		acswap_opcode = ["ACSWAP"]
		acswap_variant = {
			"_upper27_lower10_registerZ_registerU_double" => "_IMM37"
		}

		gen_variant_array = [
			OpcodeVariantGen.new(alu_sizes, arith_opcodes, arith_variants),
			OpcodeVariantGen.new(alu_sizes, shift_opcodes, shift_variants),
			OpcodeVariantGen.new(alu_sizes, neg_copy_opcodes, neg_copy_variants),
			OpcodeVariantGen.new(alu_sizes, comp_opcodes, comp_variants),
			OpcodeVariantGen.new(alu_sizes, acswap_opcode, acswap_variant),
			OpcodeVariantGen.new({"" => ""}, load_opcode, load_variants),
			OpcodeVariantGen.new({"" => ""}, store_opcode, store_variants),
		]


		gen_variant_array.each do |gen_variant|
			gen_variant.opcodes.each do |op|
				gen_variant.variants.each do |variant, variant_name|
					gen_variant.sizes.each do |size, size_name|
						selected_opcode[op + size + variant] = OpcodeGenEncoding.new(op + variant_name + size_name)
					end
				end
			end
		end

		selected_opcode.each do |key, opcode|
			puts "#{key} => #{opcode.gen_name}"
		end

		return selected_opcode
	end
end

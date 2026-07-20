	##-----------------------------------------------------------
	## Generating test.s from MDS
	## Copyright (C) 2026 Liesme Tech.
	##-----------------------------------------------------------

#	Option: ''

##	target-core:	lvx-1

	.section .text

	.align 8
	.proc	main
	.global	main
main:
	abdd $r0 = $r0r1.lo, $r0r1r2r3.x 	#Opcode-lvx_v1-ABDD_registerW_registerZ_registerY_simple
	;;
	abdd $r1 = $r0r1.hi, 536870911 	#Opcode-lvx_v1-ABDD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	abdsd $r0r1r2r3.y = $r2, $r2r3.lo 	#Opcode-lvx_v1-ABDSD_registerW_registerZ_registerY_simple
	;;
	abdsd $r0r1r2r3.z = $r3, 536870911.@ 	#Opcode-lvx_v1-ABDSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	abdsw $r2r3.hi = $r0r1r2r3.t, $r4 	#Opcode-lvx_v1-ABDSW_signextw_registerW_registerZ_registerY_simple
	;;
	abdsw.sx $r4r5.lo = $r4r5r6r7.x, 536870911 	#Opcode-lvx_v1-ABDSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	abdud $r5 = $r4r5.hi, $r4r5r6r7.y 	#Opcode-lvx_v1-ABDUD_registerW_registerZ_registerY_simple
	;;
	abdud $r6 = $r6r7.lo, 536870911 	#Opcode-lvx_v1-ABDUD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	abduw $r4r5r6r7.z = $r7, $r6r7.hi 	#Opcode-lvx_v1-ABDUW_signextw_registerW_registerZ_registerY_simple
	;;
	abduw.sx $r4r5r6r7.t = $r8, 536870911 	#Opcode-lvx_v1-ABDUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	abdw $r8r9.lo = $r8r9r10r11.x, $r9 	#Opcode-lvx_v1-ABDW_signextw_registerW_registerZ_registerY_simple
	;;
	abdw.sx $r8r9.hi = $r8r9r10r11.y, 536870911 	#Opcode-lvx_v1-ABDW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	absd $r10 = $r10r11.lo 	#Opcode-lvx_v1-ABSD_registerW_registerZ_simple
	;;
	abssd $r8r9r10r11.z = $r11 	#Opcode-lvx_v1-ABSSD_registerW_registerZ_simple
	;;
	abssw $r10r11.hi = $r8r9r10r11.t 	#Opcode-lvx_v1-ABSSW_registerW_registerZ_simple
	;;
	absw $r12 = $sp 	#Opcode-lvx_v1-ABSW_registerW_registerZ_simple
	;;
	acswapb.v $r13, -1125899906842624[$tp] = $r0r1 	#Opcode-lvx_v1-ACSWAPB_boolcas_coherency_registerW_extend27_offset27_registerZ_registerO_triple
	;;
	acswapb.g $r14, -8388608[$fp] = $r0r1r2r3.lo 	#Opcode-lvx_v1-ACSWAPB_boolcas_coherency_registerW_offset27_registerZ_registerO_double
	;;
	acswapb.v.s $r14r15.lo, [$r15] = $r2r3 	#Opcode-lvx_v1-ACSWAPB_boolcas_coherency_registerW_registerZ_registerO_simple
	;;
	acswapd $rp, -1125899906842624[$r14r15.hi] = $r0r1r2r3.hi 	#Opcode-lvx_v1-ACSWAPD_boolcas_coherency_registerW_extend27_offset27_registerZ_registerO_triple
	;;
	acswapd.v.g $r16, -8388608[$r16r17.lo] = $r4r5 	#Opcode-lvx_v1-ACSWAPD_boolcas_coherency_registerW_offset27_registerZ_registerO_double
	;;
	acswapd.s $r16r17r18r19.x, [$r17] = $r4r5r6r7.lo 	#Opcode-lvx_v1-ACSWAPD_boolcas_coherency_registerW_registerZ_registerO_simple
	;;
	acswaph.v $r16r17.hi, -1125899906842624[$r16r17r18r19.y] = $r6r7 	#Opcode-lvx_v1-ACSWAPH_boolcas_coherency_registerW_extend27_offset27_registerZ_registerO_triple
	;;
	acswaph.g $r18, -8388608[$r18r19.lo] = $r4r5r6r7.hi 	#Opcode-lvx_v1-ACSWAPH_boolcas_coherency_registerW_offset27_registerZ_registerO_double
	;;
	acswaph.v.s $r16r17r18r19.z, [$r19] = $r8r9 	#Opcode-lvx_v1-ACSWAPH_boolcas_coherency_registerW_registerZ_registerO_simple
	;;
	acswapq $r8r9r10r11.lo, -1125899906842624[$r18r19.hi] = $r0r1r2r3 	#Opcode-lvx_v1-ACSWAPQ_boolcas_coherency_registerM_extend27_offset27_registerZ_registerQ_triple
	;;
	acswapq.v.g $r10r11, -8388608[$r16r17r18r19.t] = $r4r5r6r7 	#Opcode-lvx_v1-ACSWAPQ_boolcas_coherency_registerM_offset27_registerZ_registerQ_double
	;;
	acswapq.s $r8r9r10r11.hi, [$r20] = $r8r9r10r11 	#Opcode-lvx_v1-ACSWAPQ_boolcas_coherency_registerM_registerZ_registerQ_simple
	;;
	acswapw.v $r20r21.lo, -1125899906842624[$r20r21r22r23.x] = $r12r13 	#Opcode-lvx_v1-ACSWAPW_boolcas_coherency_registerW_extend27_offset27_registerZ_registerO_triple
	;;
	acswapw.g $r21, -8388608[$r20r21.hi] = $r12r13r14r15.lo 	#Opcode-lvx_v1-ACSWAPW_boolcas_coherency_registerW_offset27_registerZ_registerO_double
	;;
	acswapw.v.s $r20r21r22r23.y, [$r22] = $r14r15 	#Opcode-lvx_v1-ACSWAPW_boolcas_coherency_registerW_registerZ_registerO_simple
	;;
	addd $r22r23.lo = $r20r21r22r23.z, 2305843009213693951 	#Opcode-lvx_v1-ADDD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	addd $r23 = $r22r23.hi, $r20r21r22r23.t 	#Opcode-lvx_v1-ADDD_registerW_registerZ_registerY_simple
	;;
	addd $r24 = $r24r25.lo, -64 	#Opcode-lvx_v1-ADDD_registerW_registerZ_signed10_simple
	;;
	addd $r24r25r26r27.x = $r25, -8589934592 	#Opcode-lvx_v1-ADDD_registerW_registerZ_upper27_lower10_double
	;;
	addq $r12r13r14r15.hi = $r16r17, $r16r17r18r19.lo 	#Opcode-lvx_v1-ADDQ_registerM_registerP_registerO_simple
	;;
	addq $r18r19 = $r16r17r18r19.hi, 536870911.@ 	#Opcode-lvx_v1-ADDQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	addsd $r24r25.hi = $r24r25r26r27.y, $r26 	#Opcode-lvx_v1-ADDSD_registerW_registerZ_registerY_simple
	;;
	addsd $r26r27.lo = $r24r25r26r27.z, 536870911 	#Opcode-lvx_v1-ADDSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addsw $r27 = $r26r27.hi, $r24r25r26r27.t 	#Opcode-lvx_v1-ADDSW_signextw_registerW_registerZ_registerY_simple
	;;
	addsw.sx $r28 = $r28r29.lo, 536870911 	#Opcode-lvx_v1-ADDSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addusd $r28r29r30r31.x = $r29, $r28r29.hi 	#Opcode-lvx_v1-ADDUSD_registerW_registerZ_registerY_simple
	;;
	addusd $r28r29r30r31.y = $r30, 536870911.@ 	#Opcode-lvx_v1-ADDUSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addusw $r30r31.lo = $r28r29r30r31.z, $r31 	#Opcode-lvx_v1-ADDUSW_signextw_registerW_registerZ_registerY_simple
	;;
	addusw.sx $r30r31.hi = $r28r29r30r31.t, 536870911 	#Opcode-lvx_v1-ADDUSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addw $r32 = $r32r33.lo, $r32r33r34r35.x 	#Opcode-lvx_v1-ADDW_signextw_registerW_registerZ_registerY_simple
	;;
	addw.sx $r33 = $r32r33.hi, 536870911 	#Opcode-lvx_v1-ADDW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addx16d $r32r33r34r35.y = $r34, $r34r35.lo 	#Opcode-lvx_v1-ADDX16D_registerW_registerZ_registerY_simple
	;;
	addx16d $r32r33r34r35.z = $r35, 536870911 	#Opcode-lvx_v1-ADDX16D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx16w $r34r35.hi = $r32r33r34r35.t, $r36 	#Opcode-lvx_v1-ADDX16W_signextw_registerW_registerZ_registerY_simple
	;;
	addx16w.sx $r36r37.lo = $r36r37r38r39.x, 536870911 	#Opcode-lvx_v1-ADDX16W_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addx2d $r37 = $r36r37.hi, $r36r37r38r39.y 	#Opcode-lvx_v1-ADDX2D_registerW_registerZ_registerY_simple
	;;
	addx2d $r38 = $r38r39.lo, 536870911.@ 	#Opcode-lvx_v1-ADDX2D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx2w $r36r37r38r39.z = $r39, $r38r39.hi 	#Opcode-lvx_v1-ADDX2W_signextw_registerW_registerZ_registerY_simple
	;;
	addx2w.sx $r36r37r38r39.t = $r40, 536870911 	#Opcode-lvx_v1-ADDX2W_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addx32d $r40r41.lo = $r40r41r42r43.x, $r41 	#Opcode-lvx_v1-ADDX32D_registerW_registerZ_registerY_simple
	;;
	addx32d $r40r41.hi = $r40r41r42r43.y, 536870911 	#Opcode-lvx_v1-ADDX32D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx32w $r42 = $r42r43.lo, $r40r41r42r43.z 	#Opcode-lvx_v1-ADDX32W_signextw_registerW_registerZ_registerY_simple
	;;
	addx32w.sx $r43 = $r42r43.hi, 536870911 	#Opcode-lvx_v1-ADDX32W_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addx4d $r40r41r42r43.t = $r44, $r44r45.lo 	#Opcode-lvx_v1-ADDX4D_registerW_registerZ_registerY_simple
	;;
	addx4d $r44r45r46r47.x = $r45, 536870911.@ 	#Opcode-lvx_v1-ADDX4D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx4w $r44r45.hi = $r44r45r46r47.y, $r46 	#Opcode-lvx_v1-ADDX4W_signextw_registerW_registerZ_registerY_simple
	;;
	addx4w.sx $r46r47.lo = $r44r45r46r47.z, 536870911 	#Opcode-lvx_v1-ADDX4W_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addx64d $r47 = $r46r47.hi, $r44r45r46r47.t 	#Opcode-lvx_v1-ADDX64D_registerW_registerZ_registerY_simple
	;;
	addx64d $r48 = $r48r49.lo, 536870911 	#Opcode-lvx_v1-ADDX64D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx64w $r48r49r50r51.x = $r49, $r48r49.hi 	#Opcode-lvx_v1-ADDX64W_signextw_registerW_registerZ_registerY_simple
	;;
	addx64w.sx $r48r49r50r51.y = $r50, 536870911 	#Opcode-lvx_v1-ADDX64W_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addx8d $r50r51.lo = $r48r49r50r51.z, $r51 	#Opcode-lvx_v1-ADDX8D_registerW_registerZ_registerY_simple
	;;
	addx8d $r50r51.hi = $r48r49r50r51.t, 536870911.@ 	#Opcode-lvx_v1-ADDX8D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx8w $r52 = $r52r53.lo, $r52r53r54r55.x 	#Opcode-lvx_v1-ADDX8W_signextw_registerW_registerZ_registerY_simple
	;;
	addx8w.sx $r53 = $r52r53.hi, 536870911 	#Opcode-lvx_v1-ADDX8W_signextw_registerW_registerZ_upper27_lower5_double
	;;
	aladdb -1125899906842624[$r52r53r54r55.y] = $r54 	#Opcode-lvx_v1-ALADDB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aladdb.g -8388608[$r54r55.lo] = $r52r53r54r55.z 	#Opcode-lvx_v1-ALADDB_coherency_offset27_registerZ_registerT_double
	;;
	aladdb.s [$r55] = $r54r55.hi 	#Opcode-lvx_v1-ALADDB_coherency_registerZ_registerT_simple
	;;
	aladdd -1125899906842624[$r52r53r54r55.t] = $r56 	#Opcode-lvx_v1-ALADDD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aladdd.g -8388608[$r56r57.lo] = $r56r57r58r59.x 	#Opcode-lvx_v1-ALADDD_coherency_offset27_registerZ_registerT_double
	;;
	aladdd.s [$r57] = $r56r57.hi 	#Opcode-lvx_v1-ALADDD_coherency_registerZ_registerT_simple
	;;
	aladdh -1125899906842624[$r56r57r58r59.y] = $r58 	#Opcode-lvx_v1-ALADDH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aladdh.g -8388608[$r58r59.lo] = $r56r57r58r59.z 	#Opcode-lvx_v1-ALADDH_coherency_offset27_registerZ_registerT_double
	;;
	aladdh.s [$r59] = $r58r59.hi 	#Opcode-lvx_v1-ALADDH_coherency_registerZ_registerT_simple
	;;
	aladdw -1125899906842624[$r56r57r58r59.t] = $r60 	#Opcode-lvx_v1-ALADDW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aladdw.g -8388608[$r60r61.lo] = $r60r61r62r63.x 	#Opcode-lvx_v1-ALADDW_coherency_offset27_registerZ_registerT_double
	;;
	aladdw.s [$r61] = $r60r61.hi 	#Opcode-lvx_v1-ALADDW_coherency_registerZ_registerT_simple
	;;
	alandb -1125899906842624[$r60r61r62r63.y] = $r62 	#Opcode-lvx_v1-ALANDB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alandb.g -8388608[$r62r63.lo] = $r60r61r62r63.z 	#Opcode-lvx_v1-ALANDB_coherency_offset27_registerZ_registerT_double
	;;
	alandb.s [$r63] = $r62r63.hi 	#Opcode-lvx_v1-ALANDB_coherency_registerZ_registerT_simple
	;;
	alandd -1125899906842624[$r60r61r62r63.t] = $r0 	#Opcode-lvx_v1-ALANDD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alandd.g -8388608[$r0r1.lo] = $r0r1r2r3.x 	#Opcode-lvx_v1-ALANDD_coherency_offset27_registerZ_registerT_double
	;;
	alandd.s [$r1] = $r0r1.hi 	#Opcode-lvx_v1-ALANDD_coherency_registerZ_registerT_simple
	;;
	alandh -1125899906842624[$r0r1r2r3.y] = $r2 	#Opcode-lvx_v1-ALANDH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alandh.g -8388608[$r2r3.lo] = $r0r1r2r3.z 	#Opcode-lvx_v1-ALANDH_coherency_offset27_registerZ_registerT_double
	;;
	alandh.s [$r3] = $r2r3.hi 	#Opcode-lvx_v1-ALANDH_coherency_registerZ_registerT_simple
	;;
	alandw -1125899906842624[$r0r1r2r3.t] = $r4 	#Opcode-lvx_v1-ALANDW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alandw.g -8388608[$r4r5.lo] = $r4r5r6r7.x 	#Opcode-lvx_v1-ALANDW_coherency_offset27_registerZ_registerT_double
	;;
	alandw.s [$r5] = $r4r5.hi 	#Opcode-lvx_v1-ALANDW_coherency_registerZ_registerT_simple
	;;
	alb $r4r5r6r7.y = -1125899906842624[$r6] 	#Opcode-lvx_v1-ALB_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	alb.g $r6r7.lo = -8388608[$r4r5r6r7.z] 	#Opcode-lvx_v1-ALB_coherency_registerW_offset27_registerZ_double
	;;
	alb.s $r7 = [$r6r7.hi] 	#Opcode-lvx_v1-ALB_coherency_registerW_registerZ_simple
	;;
	alclrb $r4r5r6r7.t = -1125899906842624[$r8] 	#Opcode-lvx_v1-ALCLRB_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	alclrb.g $r8r9.lo = -8388608[$r8r9r10r11.x] 	#Opcode-lvx_v1-ALCLRB_coherency_registerW_offset27_registerZ_double
	;;
	alclrb.s $r9 = [$r8r9.hi] 	#Opcode-lvx_v1-ALCLRB_coherency_registerW_registerZ_simple
	;;
	alclrd $r8r9r10r11.y = -1125899906842624[$r10] 	#Opcode-lvx_v1-ALCLRD_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	alclrd.g $r10r11.lo = -8388608[$r8r9r10r11.z] 	#Opcode-lvx_v1-ALCLRD_coherency_registerW_offset27_registerZ_double
	;;
	alclrd.s $r11 = [$r10r11.hi] 	#Opcode-lvx_v1-ALCLRD_coherency_registerW_registerZ_simple
	;;
	alclrh $r8r9r10r11.t = -1125899906842624[$r12] 	#Opcode-lvx_v1-ALCLRH_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	alclrh.g $sp = -8388608[$r13] 	#Opcode-lvx_v1-ALCLRH_coherency_registerW_offset27_registerZ_double
	;;
	alclrh.s $tp = [$r14] 	#Opcode-lvx_v1-ALCLRH_coherency_registerW_registerZ_simple
	;;
	alclrw $fp = -1125899906842624[$r14r15.lo] 	#Opcode-lvx_v1-ALCLRW_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	alclrw.g $r15 = -8388608[$rp] 	#Opcode-lvx_v1-ALCLRW_coherency_registerW_offset27_registerZ_double
	;;
	alclrw.s $r14r15.hi = [$r16] 	#Opcode-lvx_v1-ALCLRW_coherency_registerW_registerZ_simple
	;;
	aldusb -1125899906842624[$r16r17.lo] = $r16r17r18r19.x 	#Opcode-lvx_v1-ALDUSB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aldusb.g -8388608[$r17] = $r16r17.hi 	#Opcode-lvx_v1-ALDUSB_coherency_offset27_registerZ_registerT_double
	;;
	aldusb.s [$r16r17r18r19.y] = $r18 	#Opcode-lvx_v1-ALDUSB_coherency_registerZ_registerT_simple
	;;
	aldusd -1125899906842624[$r18r19.lo] = $r16r17r18r19.z 	#Opcode-lvx_v1-ALDUSD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aldusd.g -8388608[$r19] = $r18r19.hi 	#Opcode-lvx_v1-ALDUSD_coherency_offset27_registerZ_registerT_double
	;;
	aldusd.s [$r16r17r18r19.t] = $r20 	#Opcode-lvx_v1-ALDUSD_coherency_registerZ_registerT_simple
	;;
	aldush -1125899906842624[$r20r21.lo] = $r20r21r22r23.x 	#Opcode-lvx_v1-ALDUSH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aldush.g -8388608[$r21] = $r20r21.hi 	#Opcode-lvx_v1-ALDUSH_coherency_offset27_registerZ_registerT_double
	;;
	aldush.s [$r20r21r22r23.y] = $r22 	#Opcode-lvx_v1-ALDUSH_coherency_registerZ_registerT_simple
	;;
	aldusw -1125899906842624[$r22r23.lo] = $r20r21r22r23.z 	#Opcode-lvx_v1-ALDUSW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aldusw.g -8388608[$r23] = $r22r23.hi 	#Opcode-lvx_v1-ALDUSW_coherency_offset27_registerZ_registerT_double
	;;
	aldusw.s [$r20r21r22r23.t] = $r24 	#Opcode-lvx_v1-ALDUSW_coherency_registerZ_registerT_simple
	;;
	ald $r24r25.lo = -1125899906842624[$r24r25r26r27.x] 	#Opcode-lvx_v1-ALD_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	ald.g $r25 = -8388608[$r24r25.hi] 	#Opcode-lvx_v1-ALD_coherency_registerW_offset27_registerZ_double
	;;
	ald.s $r24r25r26r27.y = [$r26] 	#Opcode-lvx_v1-ALD_coherency_registerW_registerZ_simple
	;;
	aleorb -1125899906842624[$r26r27.lo] = $r24r25r26r27.z 	#Opcode-lvx_v1-ALEORB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aleorb.g -8388608[$r27] = $r26r27.hi 	#Opcode-lvx_v1-ALEORB_coherency_offset27_registerZ_registerT_double
	;;
	aleorb.s [$r24r25r26r27.t] = $r28 	#Opcode-lvx_v1-ALEORB_coherency_registerZ_registerT_simple
	;;
	aleord -1125899906842624[$r28r29.lo] = $r28r29r30r31.x 	#Opcode-lvx_v1-ALEORD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aleord.g -8388608[$r29] = $r28r29.hi 	#Opcode-lvx_v1-ALEORD_coherency_offset27_registerZ_registerT_double
	;;
	aleord.s [$r28r29r30r31.y] = $r30 	#Opcode-lvx_v1-ALEORD_coherency_registerZ_registerT_simple
	;;
	aleorh -1125899906842624[$r30r31.lo] = $r28r29r30r31.z 	#Opcode-lvx_v1-ALEORH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aleorh.g -8388608[$r31] = $r30r31.hi 	#Opcode-lvx_v1-ALEORH_coherency_offset27_registerZ_registerT_double
	;;
	aleorh.s [$r28r29r30r31.t] = $r32 	#Opcode-lvx_v1-ALEORH_coherency_registerZ_registerT_simple
	;;
	aleorw -1125899906842624[$r32r33.lo] = $r32r33r34r35.x 	#Opcode-lvx_v1-ALEORW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aleorw.g -8388608[$r33] = $r32r33.hi 	#Opcode-lvx_v1-ALEORW_coherency_offset27_registerZ_registerT_double
	;;
	aleorw.s [$r32r33r34r35.y] = $r34 	#Opcode-lvx_v1-ALEORW_coherency_registerZ_registerT_simple
	;;
	alh $r34r35.lo = -1125899906842624[$r32r33r34r35.z] 	#Opcode-lvx_v1-ALH_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	alh.g $r35 = -8388608[$r34r35.hi] 	#Opcode-lvx_v1-ALH_coherency_registerW_offset27_registerZ_double
	;;
	alh.s $r32r33r34r35.t = [$r36] 	#Opcode-lvx_v1-ALH_coherency_registerW_registerZ_simple
	;;
	aliorb -1125899906842624[$r36r37.lo] = $r36r37r38r39.x 	#Opcode-lvx_v1-ALIORB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aliorb.g -8388608[$r37] = $r36r37.hi 	#Opcode-lvx_v1-ALIORB_coherency_offset27_registerZ_registerT_double
	;;
	aliorb.s [$r36r37r38r39.y] = $r38 	#Opcode-lvx_v1-ALIORB_coherency_registerZ_registerT_simple
	;;
	aliord -1125899906842624[$r38r39.lo] = $r36r37r38r39.z 	#Opcode-lvx_v1-ALIORD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aliord.g -8388608[$r39] = $r38r39.hi 	#Opcode-lvx_v1-ALIORD_coherency_offset27_registerZ_registerT_double
	;;
	aliord.s [$r36r37r38r39.t] = $r40 	#Opcode-lvx_v1-ALIORD_coherency_registerZ_registerT_simple
	;;
	aliorh -1125899906842624[$r40r41.lo] = $r40r41r42r43.x 	#Opcode-lvx_v1-ALIORH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aliorh.g -8388608[$r41] = $r40r41.hi 	#Opcode-lvx_v1-ALIORH_coherency_offset27_registerZ_registerT_double
	;;
	aliorh.s [$r40r41r42r43.y] = $r42 	#Opcode-lvx_v1-ALIORH_coherency_registerZ_registerT_simple
	;;
	aliorw -1125899906842624[$r42r43.lo] = $r40r41r42r43.z 	#Opcode-lvx_v1-ALIORW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aliorw.g -8388608[$r43] = $r42r43.hi 	#Opcode-lvx_v1-ALIORW_coherency_offset27_registerZ_registerT_double
	;;
	aliorw.s [$r40r41r42r43.t] = $r44 	#Opcode-lvx_v1-ALIORW_coherency_registerZ_registerT_simple
	;;
	almaxb -1125899906842624[$r44r45.lo] = $r44r45r46r47.x 	#Opcode-lvx_v1-ALMAXB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxb.g -8388608[$r45] = $r44r45.hi 	#Opcode-lvx_v1-ALMAXB_coherency_offset27_registerZ_registerT_double
	;;
	almaxb.s [$r44r45r46r47.y] = $r46 	#Opcode-lvx_v1-ALMAXB_coherency_registerZ_registerT_simple
	;;
	almaxd -1125899906842624[$r46r47.lo] = $r44r45r46r47.z 	#Opcode-lvx_v1-ALMAXD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxd.g -8388608[$r47] = $r46r47.hi 	#Opcode-lvx_v1-ALMAXD_coherency_offset27_registerZ_registerT_double
	;;
	almaxd.s [$r44r45r46r47.t] = $r48 	#Opcode-lvx_v1-ALMAXD_coherency_registerZ_registerT_simple
	;;
	almaxh -1125899906842624[$r48r49.lo] = $r48r49r50r51.x 	#Opcode-lvx_v1-ALMAXH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxh.g -8388608[$r49] = $r48r49.hi 	#Opcode-lvx_v1-ALMAXH_coherency_offset27_registerZ_registerT_double
	;;
	almaxh.s [$r48r49r50r51.y] = $r50 	#Opcode-lvx_v1-ALMAXH_coherency_registerZ_registerT_simple
	;;
	almaxub -1125899906842624[$r50r51.lo] = $r48r49r50r51.z 	#Opcode-lvx_v1-ALMAXUB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxub.g -8388608[$r51] = $r50r51.hi 	#Opcode-lvx_v1-ALMAXUB_coherency_offset27_registerZ_registerT_double
	;;
	almaxub.s [$r48r49r50r51.t] = $r52 	#Opcode-lvx_v1-ALMAXUB_coherency_registerZ_registerT_simple
	;;
	almaxud -1125899906842624[$r52r53.lo] = $r52r53r54r55.x 	#Opcode-lvx_v1-ALMAXUD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxud.g -8388608[$r53] = $r52r53.hi 	#Opcode-lvx_v1-ALMAXUD_coherency_offset27_registerZ_registerT_double
	;;
	almaxud.s [$r52r53r54r55.y] = $r54 	#Opcode-lvx_v1-ALMAXUD_coherency_registerZ_registerT_simple
	;;
	almaxuh -1125899906842624[$r54r55.lo] = $r52r53r54r55.z 	#Opcode-lvx_v1-ALMAXUH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxuh.g -8388608[$r55] = $r54r55.hi 	#Opcode-lvx_v1-ALMAXUH_coherency_offset27_registerZ_registerT_double
	;;
	almaxuh.s [$r52r53r54r55.t] = $r56 	#Opcode-lvx_v1-ALMAXUH_coherency_registerZ_registerT_simple
	;;
	almaxuw -1125899906842624[$r56r57.lo] = $r56r57r58r59.x 	#Opcode-lvx_v1-ALMAXUW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxuw.g -8388608[$r57] = $r56r57.hi 	#Opcode-lvx_v1-ALMAXUW_coherency_offset27_registerZ_registerT_double
	;;
	almaxuw.s [$r56r57r58r59.y] = $r58 	#Opcode-lvx_v1-ALMAXUW_coherency_registerZ_registerT_simple
	;;
	almaxw -1125899906842624[$r58r59.lo] = $r56r57r58r59.z 	#Opcode-lvx_v1-ALMAXW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxw.g -8388608[$r59] = $r58r59.hi 	#Opcode-lvx_v1-ALMAXW_coherency_offset27_registerZ_registerT_double
	;;
	almaxw.s [$r56r57r58r59.t] = $r60 	#Opcode-lvx_v1-ALMAXW_coherency_registerZ_registerT_simple
	;;
	alminb -1125899906842624[$r60r61.lo] = $r60r61r62r63.x 	#Opcode-lvx_v1-ALMINB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alminb.g -8388608[$r61] = $r60r61.hi 	#Opcode-lvx_v1-ALMINB_coherency_offset27_registerZ_registerT_double
	;;
	alminb.s [$r60r61r62r63.y] = $r62 	#Opcode-lvx_v1-ALMINB_coherency_registerZ_registerT_simple
	;;
	almind -1125899906842624[$r62r63.lo] = $r60r61r62r63.z 	#Opcode-lvx_v1-ALMIND_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almind.g -8388608[$r63] = $r62r63.hi 	#Opcode-lvx_v1-ALMIND_coherency_offset27_registerZ_registerT_double
	;;
	almind.s [$r60r61r62r63.t] = $r0 	#Opcode-lvx_v1-ALMIND_coherency_registerZ_registerT_simple
	;;
	alminh -1125899906842624[$r0r1.lo] = $r0r1r2r3.x 	#Opcode-lvx_v1-ALMINH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alminh.g -8388608[$r1] = $r0r1.hi 	#Opcode-lvx_v1-ALMINH_coherency_offset27_registerZ_registerT_double
	;;
	alminh.s [$r0r1r2r3.y] = $r2 	#Opcode-lvx_v1-ALMINH_coherency_registerZ_registerT_simple
	;;
	alminub -1125899906842624[$r2r3.lo] = $r0r1r2r3.z 	#Opcode-lvx_v1-ALMINUB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alminub.g -8388608[$r3] = $r2r3.hi 	#Opcode-lvx_v1-ALMINUB_coherency_offset27_registerZ_registerT_double
	;;
	alminub.s [$r0r1r2r3.t] = $r4 	#Opcode-lvx_v1-ALMINUB_coherency_registerZ_registerT_simple
	;;
	alminud -1125899906842624[$r4r5.lo] = $r4r5r6r7.x 	#Opcode-lvx_v1-ALMINUD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alminud.g -8388608[$r5] = $r4r5.hi 	#Opcode-lvx_v1-ALMINUD_coherency_offset27_registerZ_registerT_double
	;;
	alminud.s [$r4r5r6r7.y] = $r6 	#Opcode-lvx_v1-ALMINUD_coherency_registerZ_registerT_simple
	;;
	alminuh -1125899906842624[$r6r7.lo] = $r4r5r6r7.z 	#Opcode-lvx_v1-ALMINUH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alminuh.g -8388608[$r7] = $r6r7.hi 	#Opcode-lvx_v1-ALMINUH_coherency_offset27_registerZ_registerT_double
	;;
	alminuh.s [$r4r5r6r7.t] = $r8 	#Opcode-lvx_v1-ALMINUH_coherency_registerZ_registerT_simple
	;;
	alminuw -1125899906842624[$r8r9.lo] = $r8r9r10r11.x 	#Opcode-lvx_v1-ALMINUW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alminuw.g -8388608[$r9] = $r8r9.hi 	#Opcode-lvx_v1-ALMINUW_coherency_offset27_registerZ_registerT_double
	;;
	alminuw.s [$r8r9r10r11.y] = $r10 	#Opcode-lvx_v1-ALMINUW_coherency_registerZ_registerT_simple
	;;
	alminw -1125899906842624[$r10r11.lo] = $r8r9r10r11.z 	#Opcode-lvx_v1-ALMINW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alminw.g -8388608[$r11] = $r10r11.hi 	#Opcode-lvx_v1-ALMINW_coherency_offset27_registerZ_registerT_double
	;;
	alminw.s [$r8r9r10r11.t] = $r12 	#Opcode-lvx_v1-ALMINW_coherency_registerZ_registerT_simple
	;;
	alw $sp = -1125899906842624[$r13] 	#Opcode-lvx_v1-ALW_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	alw.g $tp = -8388608[$r14] 	#Opcode-lvx_v1-ALW_coherency_registerW_offset27_registerZ_double
	;;
	alw.s $fp = [$r14r15.lo] 	#Opcode-lvx_v1-ALW_coherency_registerW_registerZ_simple
	;;
	andd $r15 = $rp, 2305843009213693951 	#Opcode-lvx_v1-ANDD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	andd $r14r15.hi = $r16, $r16r17.lo 	#Opcode-lvx_v1-ANDD_registerW_registerZ_registerY_simple
	;;
	andd $r16r17r18r19.x = $r17, -64 	#Opcode-lvx_v1-ANDD_registerW_registerZ_signed10_simple
	;;
	andd $r16r17.hi = $r16r17r18r19.y, -8589934592 	#Opcode-lvx_v1-ANDD_registerW_registerZ_upper27_lower10_double
	;;
	andnd $r18 = $r18r19.lo, 2305843009213693951 	#Opcode-lvx_v1-ANDND_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	andnd $r16r17r18r19.z = $r19, $r18r19.hi 	#Opcode-lvx_v1-ANDND_registerW_registerZ_registerY_simple
	;;
	andnd $r16r17r18r19.t = $r20, -64 	#Opcode-lvx_v1-ANDND_registerW_registerZ_signed10_simple
	;;
	andnd $r20r21.lo = $r20r21r22r23.x, -8589934592 	#Opcode-lvx_v1-ANDND_registerW_registerZ_upper27_lower10_double
	;;
	andnq $r20r21 = $r20r21r22r23.lo, $r22r23 	#Opcode-lvx_v1-ANDNQ_registerM_registerP_registerO_simple
	;;
	andnq $r20r21r22r23.hi = $r24r25, 536870911 	#Opcode-lvx_v1-ANDNQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	andnw $r21 = $r20r21.hi, $r20r21r22r23.y 	#Opcode-lvx_v1-ANDNW_signextw_registerW_registerZ_registerY_simple
	;;
	andnw.sx $r22 = $r22r23.lo, 536870911 	#Opcode-lvx_v1-ANDNW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	andq $r24r25r26r27.lo = $r26r27, $r24r25r26r27.hi 	#Opcode-lvx_v1-ANDQ_registerM_registerP_registerO_simple
	;;
	andq $r28r29 = $r28r29r30r31.lo, 536870911.@ 	#Opcode-lvx_v1-ANDQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	andw $r20r21r22r23.z = $r23, $r22r23.hi 	#Opcode-lvx_v1-ANDW_signextw_registerW_registerZ_registerY_simple
	;;
	andw.sx $r20r21r22r23.t = $r24, 536870911 	#Opcode-lvx_v1-ANDW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	asaddb -1125899906842624[$r24r25.lo] = $r24r25r26r27.x 	#Opcode-lvx_v1-ASADDB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asaddb.g -8388608[$r25] = $r24r25.hi 	#Opcode-lvx_v1-ASADDB_coherency_offset27_registerZ_registerT_double
	;;
	asaddb.s [$r24r25r26r27.y] = $r26 	#Opcode-lvx_v1-ASADDB_coherency_registerZ_registerT_simple
	;;
	asaddd -1125899906842624[$r26r27.lo] = $r24r25r26r27.z 	#Opcode-lvx_v1-ASADDD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asaddd.g -8388608[$r27] = $r26r27.hi 	#Opcode-lvx_v1-ASADDD_coherency_offset27_registerZ_registerT_double
	;;
	asaddd.s [$r24r25r26r27.t] = $r28 	#Opcode-lvx_v1-ASADDD_coherency_registerZ_registerT_simple
	;;
	asaddh -1125899906842624[$r28r29.lo] = $r28r29r30r31.x 	#Opcode-lvx_v1-ASADDH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asaddh.g -8388608[$r29] = $r28r29.hi 	#Opcode-lvx_v1-ASADDH_coherency_offset27_registerZ_registerT_double
	;;
	asaddh.s [$r28r29r30r31.y] = $r30 	#Opcode-lvx_v1-ASADDH_coherency_registerZ_registerT_simple
	;;
	asaddw -1125899906842624[$r30r31.lo] = $r28r29r30r31.z 	#Opcode-lvx_v1-ASADDW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asaddw.g -8388608[$r31] = $r30r31.hi 	#Opcode-lvx_v1-ASADDW_coherency_offset27_registerZ_registerT_double
	;;
	asaddw.s [$r28r29r30r31.t] = $r32 	#Opcode-lvx_v1-ASADDW_coherency_registerZ_registerT_simple
	;;
	asandb -1125899906842624[$r32r33.lo] = $r32r33r34r35.x 	#Opcode-lvx_v1-ASANDB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asandb.g -8388608[$r33] = $r32r33.hi 	#Opcode-lvx_v1-ASANDB_coherency_offset27_registerZ_registerT_double
	;;
	asandb.s [$r32r33r34r35.y] = $r34 	#Opcode-lvx_v1-ASANDB_coherency_registerZ_registerT_simple
	;;
	asandd -1125899906842624[$r34r35.lo] = $r32r33r34r35.z 	#Opcode-lvx_v1-ASANDD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asandd.g -8388608[$r35] = $r34r35.hi 	#Opcode-lvx_v1-ASANDD_coherency_offset27_registerZ_registerT_double
	;;
	asandd.s [$r32r33r34r35.t] = $r36 	#Opcode-lvx_v1-ASANDD_coherency_registerZ_registerT_simple
	;;
	asandh -1125899906842624[$r36r37.lo] = $r36r37r38r39.x 	#Opcode-lvx_v1-ASANDH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asandh.g -8388608[$r37] = $r36r37.hi 	#Opcode-lvx_v1-ASANDH_coherency_offset27_registerZ_registerT_double
	;;
	asandh.s [$r36r37r38r39.y] = $r38 	#Opcode-lvx_v1-ASANDH_coherency_registerZ_registerT_simple
	;;
	asandw -1125899906842624[$r38r39.lo] = $r36r37r38r39.z 	#Opcode-lvx_v1-ASANDW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asandw.g -8388608[$r39] = $r38r39.hi 	#Opcode-lvx_v1-ASANDW_coherency_offset27_registerZ_registerT_double
	;;
	asandw.s [$r36r37r38r39.t] = $r40 	#Opcode-lvx_v1-ASANDW_coherency_registerZ_registerT_simple
	;;
	asb -1125899906842624[$r40r41.lo] = $r40r41r42r43.x 	#Opcode-lvx_v1-ASB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asb.g -8388608[$r41] = $r40r41.hi 	#Opcode-lvx_v1-ASB_coherency_offset27_registerZ_registerT_double
	;;
	asb.s [$r40r41r42r43.y] = $r42 	#Opcode-lvx_v1-ASB_coherency_registerZ_registerT_simple
	;;
	asdusb -1125899906842624[$r42r43.lo] = $r40r41r42r43.z 	#Opcode-lvx_v1-ASDUSB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asdusb.g -8388608[$r43] = $r42r43.hi 	#Opcode-lvx_v1-ASDUSB_coherency_offset27_registerZ_registerT_double
	;;
	asdusb.s [$r40r41r42r43.t] = $r44 	#Opcode-lvx_v1-ASDUSB_coherency_registerZ_registerT_simple
	;;
	asdusd -1125899906842624[$r44r45.lo] = $r44r45r46r47.x 	#Opcode-lvx_v1-ASDUSD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asdusd.g -8388608[$r45] = $r44r45.hi 	#Opcode-lvx_v1-ASDUSD_coherency_offset27_registerZ_registerT_double
	;;
	asdusd.s [$r44r45r46r47.y] = $r46 	#Opcode-lvx_v1-ASDUSD_coherency_registerZ_registerT_simple
	;;
	asdush -1125899906842624[$r46r47.lo] = $r44r45r46r47.z 	#Opcode-lvx_v1-ASDUSH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asdush.g -8388608[$r47] = $r46r47.hi 	#Opcode-lvx_v1-ASDUSH_coherency_offset27_registerZ_registerT_double
	;;
	asdush.s [$r44r45r46r47.t] = $r48 	#Opcode-lvx_v1-ASDUSH_coherency_registerZ_registerT_simple
	;;
	asdusw -1125899906842624[$r48r49.lo] = $r48r49r50r51.x 	#Opcode-lvx_v1-ASDUSW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asdusw.g -8388608[$r49] = $r48r49.hi 	#Opcode-lvx_v1-ASDUSW_coherency_offset27_registerZ_registerT_double
	;;
	asdusw.s [$r48r49r50r51.y] = $r50 	#Opcode-lvx_v1-ASDUSW_coherency_registerZ_registerT_simple
	;;
	asd -1125899906842624[$r50r51.lo] = $r48r49r50r51.z 	#Opcode-lvx_v1-ASD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asd.g -8388608[$r51] = $r50r51.hi 	#Opcode-lvx_v1-ASD_coherency_offset27_registerZ_registerT_double
	;;
	asd.s [$r48r49r50r51.t] = $r52 	#Opcode-lvx_v1-ASD_coherency_registerZ_registerT_simple
	;;
	aseorb -1125899906842624[$r52r53.lo] = $r52r53r54r55.x 	#Opcode-lvx_v1-ASEORB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aseorb.g -8388608[$r53] = $r52r53.hi 	#Opcode-lvx_v1-ASEORB_coherency_offset27_registerZ_registerT_double
	;;
	aseorb.s [$r52r53r54r55.y] = $r54 	#Opcode-lvx_v1-ASEORB_coherency_registerZ_registerT_simple
	;;
	aseord -1125899906842624[$r54r55.lo] = $r52r53r54r55.z 	#Opcode-lvx_v1-ASEORD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aseord.g -8388608[$r55] = $r54r55.hi 	#Opcode-lvx_v1-ASEORD_coherency_offset27_registerZ_registerT_double
	;;
	aseord.s [$r52r53r54r55.t] = $r56 	#Opcode-lvx_v1-ASEORD_coherency_registerZ_registerT_simple
	;;
	aseorh -1125899906842624[$r56r57.lo] = $r56r57r58r59.x 	#Opcode-lvx_v1-ASEORH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aseorh.g -8388608[$r57] = $r56r57.hi 	#Opcode-lvx_v1-ASEORH_coherency_offset27_registerZ_registerT_double
	;;
	aseorh.s [$r56r57r58r59.y] = $r58 	#Opcode-lvx_v1-ASEORH_coherency_registerZ_registerT_simple
	;;
	aseorw -1125899906842624[$r58r59.lo] = $r56r57r58r59.z 	#Opcode-lvx_v1-ASEORW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aseorw.g -8388608[$r59] = $r58r59.hi 	#Opcode-lvx_v1-ASEORW_coherency_offset27_registerZ_registerT_double
	;;
	aseorw.s [$r56r57r58r59.t] = $r60 	#Opcode-lvx_v1-ASEORW_coherency_registerZ_registerT_simple
	;;
	ash -1125899906842624[$r60r61.lo] = $r60r61r62r63.x 	#Opcode-lvx_v1-ASH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	ash.g -8388608[$r61] = $r60r61.hi 	#Opcode-lvx_v1-ASH_coherency_offset27_registerZ_registerT_double
	;;
	ash.s [$r60r61r62r63.y] = $r62 	#Opcode-lvx_v1-ASH_coherency_registerZ_registerT_simple
	;;
	asiorb -1125899906842624[$r62r63.lo] = $r60r61r62r63.z 	#Opcode-lvx_v1-ASIORB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asiorb.g -8388608[$r63] = $r62r63.hi 	#Opcode-lvx_v1-ASIORB_coherency_offset27_registerZ_registerT_double
	;;
	asiorb.s [$r60r61r62r63.t] = $r0 	#Opcode-lvx_v1-ASIORB_coherency_registerZ_registerT_simple
	;;
	asiord -1125899906842624[$r0r1.lo] = $r0r1r2r3.x 	#Opcode-lvx_v1-ASIORD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asiord.g -8388608[$r1] = $r0r1.hi 	#Opcode-lvx_v1-ASIORD_coherency_offset27_registerZ_registerT_double
	;;
	asiord.s [$r0r1r2r3.y] = $r2 	#Opcode-lvx_v1-ASIORD_coherency_registerZ_registerT_simple
	;;
	asiorh -1125899906842624[$r2r3.lo] = $r0r1r2r3.z 	#Opcode-lvx_v1-ASIORH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asiorh.g -8388608[$r3] = $r2r3.hi 	#Opcode-lvx_v1-ASIORH_coherency_offset27_registerZ_registerT_double
	;;
	asiorh.s [$r0r1r2r3.t] = $r4 	#Opcode-lvx_v1-ASIORH_coherency_registerZ_registerT_simple
	;;
	asiorw -1125899906842624[$r4r5.lo] = $r4r5r6r7.x 	#Opcode-lvx_v1-ASIORW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asiorw.g -8388608[$r5] = $r4r5.hi 	#Opcode-lvx_v1-ASIORW_coherency_offset27_registerZ_registerT_double
	;;
	asiorw.s [$r4r5r6r7.y] = $r6 	#Opcode-lvx_v1-ASIORW_coherency_registerZ_registerT_simple
	;;
	asmaxb -1125899906842624[$r6r7.lo] = $r4r5r6r7.z 	#Opcode-lvx_v1-ASMAXB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxb.g -8388608[$r7] = $r6r7.hi 	#Opcode-lvx_v1-ASMAXB_coherency_offset27_registerZ_registerT_double
	;;
	asmaxb.s [$r4r5r6r7.t] = $r8 	#Opcode-lvx_v1-ASMAXB_coherency_registerZ_registerT_simple
	;;
	asmaxd -1125899906842624[$r8r9.lo] = $r8r9r10r11.x 	#Opcode-lvx_v1-ASMAXD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxd.g -8388608[$r9] = $r8r9.hi 	#Opcode-lvx_v1-ASMAXD_coherency_offset27_registerZ_registerT_double
	;;
	asmaxd.s [$r8r9r10r11.y] = $r10 	#Opcode-lvx_v1-ASMAXD_coherency_registerZ_registerT_simple
	;;
	asmaxh -1125899906842624[$r10r11.lo] = $r8r9r10r11.z 	#Opcode-lvx_v1-ASMAXH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxh.g -8388608[$r11] = $r10r11.hi 	#Opcode-lvx_v1-ASMAXH_coherency_offset27_registerZ_registerT_double
	;;
	asmaxh.s [$r8r9r10r11.t] = $r12 	#Opcode-lvx_v1-ASMAXH_coherency_registerZ_registerT_simple
	;;
	asmaxub -1125899906842624[$sp] = $r13 	#Opcode-lvx_v1-ASMAXUB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxub.g -8388608[$tp] = $r14 	#Opcode-lvx_v1-ASMAXUB_coherency_offset27_registerZ_registerT_double
	;;
	asmaxub.s [$fp] = $r14r15.lo 	#Opcode-lvx_v1-ASMAXUB_coherency_registerZ_registerT_simple
	;;
	asmaxud -1125899906842624[$r15] = $rp 	#Opcode-lvx_v1-ASMAXUD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxud.g -8388608[$r14r15.hi] = $r16 	#Opcode-lvx_v1-ASMAXUD_coherency_offset27_registerZ_registerT_double
	;;
	asmaxud.s [$r16r17.lo] = $r16r17r18r19.x 	#Opcode-lvx_v1-ASMAXUD_coherency_registerZ_registerT_simple
	;;
	asmaxuh -1125899906842624[$r17] = $r16r17.hi 	#Opcode-lvx_v1-ASMAXUH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxuh.g -8388608[$r16r17r18r19.y] = $r18 	#Opcode-lvx_v1-ASMAXUH_coherency_offset27_registerZ_registerT_double
	;;
	asmaxuh.s [$r18r19.lo] = $r16r17r18r19.z 	#Opcode-lvx_v1-ASMAXUH_coherency_registerZ_registerT_simple
	;;
	asmaxuw -1125899906842624[$r19] = $r18r19.hi 	#Opcode-lvx_v1-ASMAXUW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxuw.g -8388608[$r16r17r18r19.t] = $r20 	#Opcode-lvx_v1-ASMAXUW_coherency_offset27_registerZ_registerT_double
	;;
	asmaxuw.s [$r20r21.lo] = $r20r21r22r23.x 	#Opcode-lvx_v1-ASMAXUW_coherency_registerZ_registerT_simple
	;;
	asmaxw -1125899906842624[$r21] = $r20r21.hi 	#Opcode-lvx_v1-ASMAXW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxw.g -8388608[$r20r21r22r23.y] = $r22 	#Opcode-lvx_v1-ASMAXW_coherency_offset27_registerZ_registerT_double
	;;
	asmaxw.s [$r22r23.lo] = $r20r21r22r23.z 	#Opcode-lvx_v1-ASMAXW_coherency_registerZ_registerT_simple
	;;
	asminb -1125899906842624[$r23] = $r22r23.hi 	#Opcode-lvx_v1-ASMINB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asminb.g -8388608[$r20r21r22r23.t] = $r24 	#Opcode-lvx_v1-ASMINB_coherency_offset27_registerZ_registerT_double
	;;
	asminb.s [$r24r25.lo] = $r24r25r26r27.x 	#Opcode-lvx_v1-ASMINB_coherency_registerZ_registerT_simple
	;;
	asmind -1125899906842624[$r25] = $r24r25.hi 	#Opcode-lvx_v1-ASMIND_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmind.g -8388608[$r24r25r26r27.y] = $r26 	#Opcode-lvx_v1-ASMIND_coherency_offset27_registerZ_registerT_double
	;;
	asmind.s [$r26r27.lo] = $r24r25r26r27.z 	#Opcode-lvx_v1-ASMIND_coherency_registerZ_registerT_simple
	;;
	asminh -1125899906842624[$r27] = $r26r27.hi 	#Opcode-lvx_v1-ASMINH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asminh.g -8388608[$r24r25r26r27.t] = $r28 	#Opcode-lvx_v1-ASMINH_coherency_offset27_registerZ_registerT_double
	;;
	asminh.s [$r28r29.lo] = $r28r29r30r31.x 	#Opcode-lvx_v1-ASMINH_coherency_registerZ_registerT_simple
	;;
	asminub -1125899906842624[$r29] = $r28r29.hi 	#Opcode-lvx_v1-ASMINUB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asminub.g -8388608[$r28r29r30r31.y] = $r30 	#Opcode-lvx_v1-ASMINUB_coherency_offset27_registerZ_registerT_double
	;;
	asminub.s [$r30r31.lo] = $r28r29r30r31.z 	#Opcode-lvx_v1-ASMINUB_coherency_registerZ_registerT_simple
	;;
	asminud -1125899906842624[$r31] = $r30r31.hi 	#Opcode-lvx_v1-ASMINUD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asminud.g -8388608[$r28r29r30r31.t] = $r32 	#Opcode-lvx_v1-ASMINUD_coherency_offset27_registerZ_registerT_double
	;;
	asminud.s [$r32r33.lo] = $r32r33r34r35.x 	#Opcode-lvx_v1-ASMINUD_coherency_registerZ_registerT_simple
	;;
	asminuh -1125899906842624[$r33] = $r32r33.hi 	#Opcode-lvx_v1-ASMINUH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asminuh.g -8388608[$r32r33r34r35.y] = $r34 	#Opcode-lvx_v1-ASMINUH_coherency_offset27_registerZ_registerT_double
	;;
	asminuh.s [$r34r35.lo] = $r32r33r34r35.z 	#Opcode-lvx_v1-ASMINUH_coherency_registerZ_registerT_simple
	;;
	asminuw -1125899906842624[$r35] = $r34r35.hi 	#Opcode-lvx_v1-ASMINUW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asminuw.g -8388608[$r32r33r34r35.t] = $r36 	#Opcode-lvx_v1-ASMINUW_coherency_offset27_registerZ_registerT_double
	;;
	asminuw.s [$r36r37.lo] = $r36r37r38r39.x 	#Opcode-lvx_v1-ASMINUW_coherency_registerZ_registerT_simple
	;;
	asminw -1125899906842624[$r37] = $r36r37.hi 	#Opcode-lvx_v1-ASMINW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asminw.g -8388608[$r36r37r38r39.y] = $r38 	#Opcode-lvx_v1-ASMINW_coherency_offset27_registerZ_registerT_double
	;;
	asminw.s [$r38r39.lo] = $r36r37r38r39.z 	#Opcode-lvx_v1-ASMINW_coherency_registerZ_registerT_simple
	;;
	aswapb -1125899906842624[$r39] = $r38r39.hi 	#Opcode-lvx_v1-ASWAPB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aswapb.g -8388608[$r36r37r38r39.t] = $r40 	#Opcode-lvx_v1-ASWAPB_coherency_offset27_registerZ_registerT_double
	;;
	aswapb.s [$r40r41.lo] = $r40r41r42r43.x 	#Opcode-lvx_v1-ASWAPB_coherency_registerZ_registerT_simple
	;;
	aswapd -1125899906842624[$r41] = $r40r41.hi 	#Opcode-lvx_v1-ASWAPD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aswapd.g -8388608[$r40r41r42r43.y] = $r42 	#Opcode-lvx_v1-ASWAPD_coherency_offset27_registerZ_registerT_double
	;;
	aswapd.s [$r42r43.lo] = $r40r41r42r43.z 	#Opcode-lvx_v1-ASWAPD_coherency_registerZ_registerT_simple
	;;
	aswaph -1125899906842624[$r43] = $r42r43.hi 	#Opcode-lvx_v1-ASWAPH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aswaph.g -8388608[$r40r41r42r43.t] = $r44 	#Opcode-lvx_v1-ASWAPH_coherency_offset27_registerZ_registerT_double
	;;
	aswaph.s [$r44r45.lo] = $r44r45r46r47.x 	#Opcode-lvx_v1-ASWAPH_coherency_registerZ_registerT_simple
	;;
	aswapw -1125899906842624[$r45] = $r44r45.hi 	#Opcode-lvx_v1-ASWAPW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aswapw.g -8388608[$r44r45r46r47.y] = $r46 	#Opcode-lvx_v1-ASWAPW_coherency_offset27_registerZ_registerT_double
	;;
	aswapw.s [$r46r47.lo] = $r44r45r46r47.z 	#Opcode-lvx_v1-ASWAPW_coherency_registerZ_registerT_simple
	;;
	asw -1125899906842624[$r47] = $r46r47.hi 	#Opcode-lvx_v1-ASW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asw.g -8388608[$r44r45r46r47.t] = $r48 	#Opcode-lvx_v1-ASW_coherency_offset27_registerZ_registerT_double
	;;
	asw.s [$r48r49.lo] = $r48r49r50r51.x 	#Opcode-lvx_v1-ASW_coherency_registerZ_registerT_simple
	;;
	avgruw $r49 = $r48r49.hi, $r48r49r50r51.y 	#Opcode-lvx_v1-AVGRUW_signextw_registerW_registerZ_registerY_simple
	;;
	avgruw.sx $r50 = $r50r51.lo, 536870911 	#Opcode-lvx_v1-AVGRUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	avgrw $r48r49r50r51.z = $r51, $r50r51.hi 	#Opcode-lvx_v1-AVGRW_signextw_registerW_registerZ_registerY_simple
	;;
	avgrw.sx $r48r49r50r51.t = $r52, 536870911 	#Opcode-lvx_v1-AVGRW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	avguw $r52r53.lo = $r52r53r54r55.x, $r53 	#Opcode-lvx_v1-AVGUW_signextw_registerW_registerZ_registerY_simple
	;;
	avguw.sx $r52r53.hi = $r52r53r54r55.y, 536870911 	#Opcode-lvx_v1-AVGUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	avgw $r54 = $r54r55.lo, $r52r53r54r55.z 	#Opcode-lvx_v1-AVGW_signextw_registerW_registerZ_registerY_simple
	;;
	avgw.sx $r55 = $r54r55.hi, 536870911 	#Opcode-lvx_v1-AVGW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	await 	#Opcode-lvx_v1-AWAIT_simple
	;;
	barrier 	#Opcode-lvx_v1-BARRIER_simple
	;;
	blend.mt $r52r53r54r55.t? 7 	#Opcode-lvx_v1-BLEND_lanetodo_lanesize_registerZ_activate_simple
	;;
	break 0 	#Opcode-lvx_v1-BREAK_brknumber_simple
	;;
	callx -4503599627370496 	#Opcode-lvx_v1-CALLX_upper27_lower27_double
	;;
	call -33554432 	#Opcode-lvx_v1-CALL_pcrel27s2_simple
	;;
	catdq $r30r31 = $r56, $r56r57.lo 	#Opcode-lvx_v1-CATDQ_registerM_registerZ_registerY_simple
	;;
	cbsd $r56r57r58r59.x = $r57 	#Opcode-lvx_v1-CBSD_registerW_registerZ_simple
	;;
	cbsw $r56r57.hi = $r56r57r58r59.y 	#Opcode-lvx_v1-CBSW_registerW_registerZ_simple
	;;
	cbx.dltz $r58? -4398046511104 	#Opcode-lvx_v1-CBX_bcucond_registerZ_upper27_lower17_double
	;;
	cb.dgez $r58r59.lo? -32768 	#Opcode-lvx_v1-CB_bcucond_registerZ_pcrel17s2_simple
	;;
	ccbx.dlt $r56r57r58r59.z, $r59 ? -68719476736 	#Opcode-lvx_v1-CCBX_ccbcomp_registerZ_registerY_upper27_lower11_double
	;;
	ccb.dge $r58r59.hi, $r56r57r58r59.t ? -512 	#Opcode-lvx_v1-CCB_ccbcomp_registerZ_registerY_pcrel11s2_simple
	;;
	clsd $r60 = $r60r61.lo 	#Opcode-lvx_v1-CLSD_registerW_registerZ_simple
	;;
	clsw $r60r61r62r63.x = $r61 	#Opcode-lvx_v1-CLSW_registerW_registerZ_simple
	;;
	clzd $r60r61.hi = $r60r61r62r63.y 	#Opcode-lvx_v1-CLZD_registerW_registerZ_simple
	;;
	clzw $r62 = $r62r63.lo 	#Opcode-lvx_v1-CLZW_registerW_registerZ_simple
	;;
	cmoved.dlez $r60r61r62r63.z? $r63 = $r62r63.hi 	#Opcode-lvx_v1-CMOVED_cmovecond_registerZ_registerW_registerY_simple
	;;
	cmoved.dgtz $r60r61r62r63.t? $r0 = 536870911 	#Opcode-lvx_v1-CMOVED_cmovecond_registerZ_registerW_upper27_lower5_splat32_double
	;;
	cmoveq.deqz $r0r1.lo? $r28r29r30r31.hi = $r32r33 	#Opcode-lvx_v1-CMOVEQ_cmovecond_registerZ_registerM_registerO_simple
	;;
	compd.lt $r0r1r2r3.x = $r1, $r0r1.hi 	#Opcode-lvx_v1-COMPD_intcomp_registerW_registerZ_registerY_simple
	;;
	compd.ge $r0r1r2r3.y = $r2, 536870911 	#Opcode-lvx_v1-COMPD_intcomp_registerW_registerZ_upper27_lower5_double
	;;
	compq.ltu $r32r33r34r35.lo = $r34r35, $r32r33r34r35.hi 	#Opcode-lvx_v1-COMPQ_intcomp_registerM_registerP_registerO_simple
	;;
	compw.geu $r2r3.lo = $r0r1r2r3.z, $r3 	#Opcode-lvx_v1-COMPW_intcomp_signextw_registerW_registerZ_registerY_simple
	;;
	compw.eq.sx $r2r3.hi = $r0r1r2r3.t, 536870911 	#Opcode-lvx_v1-COMPW_intcomp_signextw_registerW_registerZ_upper27_lower5_double
	;;
	copyd $r4 = $r4r5.lo 	#Opcode-lvx_v1-COPYD_registerW_registerZ_simple
	;;
	copyo $r12r13r14r15 = $r16r17r18r19 	#Opcode-lvx_v1-COPYO_registerN_registerR_simple
	;;
	copyq $r36r37 = $r4r5r6r7.x, $r5 	#Opcode-lvx_v1-COPYQ_registerM_registerZ_registerY_simple
	;;
	copyw $r4r5.hi = $r4r5r6r7.y 	#Opcode-lvx_v1-COPYW_signextw_registerW_registerZ_simple
	;;
	crcbellw $r6 = $r6r7.lo, $r4r5r6r7.z 	#Opcode-lvx_v1-CRCBELLW_registerW_registerZ_registerY_simple
	;;
	crcbellw $r7 = $r6r7.hi, 536870911 	#Opcode-lvx_v1-CRCBELLW_registerW_registerZ_upper27_lower5_double
	;;
	crcbelmw $r4r5r6r7.t = $r8, $r8r9.lo 	#Opcode-lvx_v1-CRCBELMW_registerW_registerZ_registerY_simple
	;;
	crcbelmw $r8r9r10r11.x = $r9, 536870911 	#Opcode-lvx_v1-CRCBELMW_registerW_registerZ_upper27_lower5_double
	;;
	crclellw $r8r9.hi = $r8r9r10r11.y, $r10 	#Opcode-lvx_v1-CRCLELLW_registerW_registerZ_registerY_simple
	;;
	crclellw $r10r11.lo = $r8r9r10r11.z, 536870911 	#Opcode-lvx_v1-CRCLELLW_registerW_registerZ_upper27_lower5_double
	;;
	crclelmw $r11 = $r10r11.hi, $r8r9r10r11.t 	#Opcode-lvx_v1-CRCLELMW_registerW_registerZ_registerY_simple
	;;
	crclelmw $r12 = $sp, 536870911 	#Opcode-lvx_v1-CRCLELMW_registerW_registerZ_upper27_lower5_double
	;;
	csrrc $r13 = 511 	#Opcode-lvx_v1-CSRRC_registerZ_csrnumber_simple
	;;
	csrrs $tp = 511 	#Opcode-lvx_v1-CSRRS_registerZ_csrnumber_simple
	;;
	csrrw $r14 = 511 	#Opcode-lvx_v1-CSRRW_registerZ_csrnumber_simple
	;;
	ctzd $fp = $r14r15.lo 	#Opcode-lvx_v1-CTZD_registerW_registerZ_simple
	;;
	ctzw $r15 = $rp 	#Opcode-lvx_v1-CTZW_registerW_registerZ_simple
	;;
	d1inval 	#Opcode-lvx_v1-D1INVAL_simple
	;;
	dflushl 2305843009213693951[$r14r15.hi] 	#Opcode-lvx_v1-DFLUSHL_extend27_upper27_lower10_registerZ_triple
	;;
	dflushl $r16[$r16r17.lo] 	#Opcode-lvx_v1-DFLUSHL_registerY_registerZ_simple
	;;
	dflushl -64[$r16r17r18r19.x] 	#Opcode-lvx_v1-DFLUSHL_signed10_registerZ_simple
	;;
	dflushl -8589934592[$r17] 	#Opcode-lvx_v1-DFLUSHL_upper27_lower10_registerZ_double
	;;
	dflushsw.l1 $r16r17.hi, $r16r17r18r19.y 	#Opcode-lvx_v1-DFLUSHSW_cachelev_registerY_registerZ_simple
	;;
	dinvall 2305843009213693951[$r18] 	#Opcode-lvx_v1-DINVALL_extend27_upper27_lower10_registerZ_triple
	;;
	dinvall $r18r19.lo[$r16r17r18r19.z] 	#Opcode-lvx_v1-DINVALL_registerY_registerZ_simple
	;;
	dinvall -64[$r19] 	#Opcode-lvx_v1-DINVALL_signed10_registerZ_simple
	;;
	dinvall -8589934592[$r18r19.hi] 	#Opcode-lvx_v1-DINVALL_upper27_lower10_registerZ_double
	;;
	dinvalsw.l2 $r16r17r18r19.t, $r20 	#Opcode-lvx_v1-DINVALSW_cachelev_registerY_registerZ_simple
	;;
	divmodd $r36r37r38r39.lo = $r20r21.lo, $r20r21r22r23.x 	#Opcode-lvx_v1-DIVMODD_registerM_registerZ_registerY_simple
	;;
	divmodud $r38r39 = $r21, $r20r21.hi 	#Opcode-lvx_v1-DIVMODUD_registerM_registerZ_registerY_simple
	;;
	divmoduw.sx $r36r37r38r39.hi = $r20r21r22r23.y, $r22 	#Opcode-lvx_v1-DIVMODUW_signextw_registerM_registerZ_registerY_simple
	;;
	divmodw $r40r41 = $r22r23.lo, $r20r21r22r23.z 	#Opcode-lvx_v1-DIVMODW_signextw_registerM_registerZ_registerY_simple
	;;
	dpurgel 2305843009213693951[$r23] 	#Opcode-lvx_v1-DPURGEL_extend27_upper27_lower10_registerZ_triple
	;;
	dpurgel $r22r23.hi[$r20r21r22r23.t] 	#Opcode-lvx_v1-DPURGEL_registerY_registerZ_simple
	;;
	dpurgel -64[$r24] 	#Opcode-lvx_v1-DPURGEL_signed10_registerZ_simple
	;;
	dpurgel -8589934592[$r24r25.lo] 	#Opcode-lvx_v1-DPURGEL_upper27_lower10_registerZ_double
	;;
	dpurgesw.l1 $r24r25r26r27.x, $r25 	#Opcode-lvx_v1-DPURGESW_cachelev_registerY_registerZ_simple
	;;
	dtouchl 2305843009213693951[$r24r25.hi] 	#Opcode-lvx_v1-DTOUCHL_extend27_upper27_lower10_registerZ_triple
	;;
	dtouchl $r24r25r26r27.y[$r26] 	#Opcode-lvx_v1-DTOUCHL_registerY_registerZ_simple
	;;
	dtouchl -64[$r26r27.lo] 	#Opcode-lvx_v1-DTOUCHL_signed10_registerZ_simple
	;;
	dtouchl -8589934592[$r24r25r26r27.z] 	#Opcode-lvx_v1-DTOUCHL_upper27_lower10_registerZ_double
	;;
	eord $r27 = $r26r27.hi, 2305843009213693951 	#Opcode-lvx_v1-EORD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	eord $r24r25r26r27.t = $r28, $r28r29.lo 	#Opcode-lvx_v1-EORD_registerW_registerZ_registerY_simple
	;;
	eord $r28r29r30r31.x = $r29, -64 	#Opcode-lvx_v1-EORD_registerW_registerZ_signed10_simple
	;;
	eord $r28r29.hi = $r28r29r30r31.y, -8589934592 	#Opcode-lvx_v1-EORD_registerW_registerZ_upper27_lower10_double
	;;
	eorq $r40r41r42r43.lo = $r42r43, $r40r41r42r43.hi 	#Opcode-lvx_v1-EORQ_registerM_registerP_registerO_simple
	;;
	eorq $r44r45 = $r44r45r46r47.lo, 536870911.@ 	#Opcode-lvx_v1-EORQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	eorw.sx $r30 = $r30r31.lo, $r28r29r30r31.z 	#Opcode-lvx_v1-EORW_signextw_registerW_registerZ_registerY_simple
	;;
	eorw $r31 = $r30r31.hi, 536870911 	#Opcode-lvx_v1-EORW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	errop 	#Opcode-lvx_v1-ERROP_simple
	;;
	extfs $r28r29r30r31.t = $r32, 7, 7 	#Opcode-lvx_v1-EXTFS_registerW_registerZ_stopbit2_stopbit4_startbit_simple
	;;
	extfz $r32r33.lo = $r32r33r34r35.x, 7, 7 	#Opcode-lvx_v1-EXTFZ_registerW_registerZ_stopbit2_stopbit4_startbit_simple
	;;
	fabsd $r33 = $r32r33.hi 	#Opcode-lvx_v1-FABSD_registerW_registerZ_simple
	;;
	fabsh $r32r33r34r35.y = $r34 	#Opcode-lvx_v1-FABSH_registerW_registerZ_simple
	;;
	fabswp $r34r35.lo = $r32r33r34r35.z 	#Opcode-lvx_v1-FABSWP_registerW_registerZ_simple
	;;
	fabsw $r35 = $r34r35.hi 	#Opcode-lvx_v1-FABSW_registerW_registerZ_simple
	;;
	faddd.rn $r32r33r34r35.t = $r36, $r36r37.lo 	#Opcode-lvx_v1-FADDD_floatmode_registerW_registerZ_registerY_simple
	;;
	faddh.rz $r36r37r38r39.x = $r37, $r36r37.hi 	#Opcode-lvx_v1-FADDH_floatmode_registerW_registerZ_registerY_simple
	;;
	faddwc.rd $r36r37r38r39.y = $r38, $r38r39.lo 	#Opcode-lvx_v1-FADDWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple
	;;
	faddw.ru $r36r37r38r39.z = $r39, $r38r39.hi 	#Opcode-lvx_v1-FADDW_floatmode_registerW_registerZ_registerY_simple
	;;
	fclassd $r36r37r38r39.t = $r40 	#Opcode-lvx_v1-FCLASSD_registerW_registerZ_simple
	;;
	fclassh $r40r41.lo = $r40r41r42r43.x 	#Opcode-lvx_v1-FCLASSH_registerW_registerZ_simple
	;;
	fclasswp $r41 = $r40r41.hi 	#Opcode-lvx_v1-FCLASSWP_registerW_registerZ_simple
	;;
	fclassw $r40r41r42r43.y = $r42 	#Opcode-lvx_v1-FCLASSW_registerW_registerZ_simple
	;;
	fcompd.one $r42r43.lo = $r40r41r42r43.z, $r43 	#Opcode-lvx_v1-FCOMPD_floatcomp_registerW_registerZ_registerY_simple
	;;
	fcompd.ueq $r42r43.hi = $r40r41r42r43.t, 536870911 	#Opcode-lvx_v1-FCOMPD_floatcomp_registerW_registerZ_upper27_lower5_double
	;;
	fcomph.oeq $r44 = $r44r45.lo, $r44r45r46r47.x 	#Opcode-lvx_v1-FCOMPH_floatcomp_registerW_registerZ_registerY_simple
	;;
	fcomph.une $r45 = $r44r45.hi, 536870911 	#Opcode-lvx_v1-FCOMPH_floatcomp_registerW_registerZ_upper27_lower5_double
	;;
	fcompw.olt $r44r45r46r47.y = $r46, $r46r47.lo 	#Opcode-lvx_v1-FCOMPW_floatcomp_registerW_registerZ_registerY_simple
	;;
	fcompw.uge $r44r45r46r47.z = $r47, 536870911 	#Opcode-lvx_v1-FCOMPW_floatcomp_registerW_registerZ_upper27_lower5_double
	;;
	fdivd.rm $r46r47.hi = $r44r45r46r47.t, $r48 	#Opcode-lvx_v1-FDIVD_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fdivh.n.r5 $r48r49.lo = $r48r49r50r51.x, $r49 	#Opcode-lvx_v1-FDIVH_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fdivw.ro $r48r49.hi = $r48r49r50r51.y, $r50 	#Opcode-lvx_v1-FDIVW_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fence 	#Opcode-lvx_v1-FENCE_accesses_simple
	;;
	ffmad.n $r50r51.lo = $r48r49r50r51.z, $r51 	#Opcode-lvx_v1-FFMAD_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmah.rn $r50r51.hi = $r48r49r50r51.t, $r52 	#Opcode-lvx_v1-FFMAH_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmawc.c.mi.rz $r52r53.lo = $r52r53r54r55.x, $r53 	#Opcode-lvx_v1-FFMAWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmaw.n.rd $r52r53.hi = $r52r53r54r55.y, $r54 	#Opcode-lvx_v1-FFMAW_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmsd.ru $r54r55.lo = $r52r53r54r55.z, $r55 	#Opcode-lvx_v1-FFMSD_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmsh.n.rm $r54r55.hi = $r52r53r54r55.t, $r56 	#Opcode-lvx_v1-FFMSH_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmsw.r5 $r56r57.lo = $r56r57r58r59.x, $r57 	#Opcode-lvx_v1-FFMSW_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fixeddw.ro $r56r57.hi = $r56r57r58r59.y 	#Opcode-lvx_v1-FIXEDDW_floatmode_registerW_registerZ_simple
	;;
	fixedd $r58 = $r58r59.lo 	#Opcode-lvx_v1-FIXEDD_floatmode_registerW_registerZ_simple
	;;
	fixedudw.rn $r56r57r58r59.z = $r59 	#Opcode-lvx_v1-FIXEDUDW_floatmode_registerW_registerZ_simple
	;;
	fixedud.rz $r58r59.hi = $r56r57r58r59.t 	#Opcode-lvx_v1-FIXEDUD_floatmode_registerW_registerZ_simple
	;;
	fixeduwd.rd $r60 = $r60r61.lo 	#Opcode-lvx_v1-FIXEDUWD_floatmode_registerW_registerZ_simple
	;;
	fixeduwp.ru $r60r61r62r63.x = $r61 	#Opcode-lvx_v1-FIXEDUWP_floatmode_registerW_registerZ_simple
	;;
	fixeduw.rm $r60r61.hi = $r60r61r62r63.y 	#Opcode-lvx_v1-FIXEDUW_floatmode_registerW_registerZ_simple
	;;
	fixedwd.r5 $r62 = $r62r63.lo 	#Opcode-lvx_v1-FIXEDWD_floatmode_registerW_registerZ_simple
	;;
	fixedwp.ro $r60r61r62r63.z = $r63 	#Opcode-lvx_v1-FIXEDWP_floatmode_registerW_registerZ_simple
	;;
	fixedw $r62r63.hi = $r60r61r62r63.t 	#Opcode-lvx_v1-FIXEDW_floatmode_registerW_registerZ_simple
	;;
	floatdw.rn $r0 = $r0r1.lo 	#Opcode-lvx_v1-FLOATDW_floatmode_registerW_registerZ_simple
	;;
	floatd.rz $r0r1r2r3.x = $r1 	#Opcode-lvx_v1-FLOATD_floatmode_registerW_registerZ_simple
	;;
	floatudw.rd $r0r1.hi = $r0r1r2r3.y 	#Opcode-lvx_v1-FLOATUDW_floatmode_registerW_registerZ_simple
	;;
	floatud.ru $r2 = $r2r3.lo 	#Opcode-lvx_v1-FLOATUD_floatmode_registerW_registerZ_simple
	;;
	floatuwd.rm $r0r1r2r3.z = $r3 	#Opcode-lvx_v1-FLOATUWD_floatmode_registerW_registerZ_simple
	;;
	floatuwp.r5 $r2r3.hi = $r0r1r2r3.t 	#Opcode-lvx_v1-FLOATUWP_floatmode_registerW_registerZ_simple
	;;
	floatuw.ro $r4 = $r4r5.lo 	#Opcode-lvx_v1-FLOATUW_floatmode_registerW_registerZ_simple
	;;
	floatwd $r4r5r6r7.x = $r5 	#Opcode-lvx_v1-FLOATWD_floatmode_registerW_registerZ_simple
	;;
	floatwp.rn $r4r5.hi = $r4r5r6r7.y 	#Opcode-lvx_v1-FLOATWP_floatmode_registerW_registerZ_simple
	;;
	floatw.rz $r6 = $r6r7.lo 	#Opcode-lvx_v1-FLOATW_floatmode_registerW_registerZ_simple
	;;
	fmaxd $r4r5r6r7.z = $r7, $r6r7.hi 	#Opcode-lvx_v1-FMAXD_registerW_registerZ_registerY_simple
	;;
	fmaxh $r4r5r6r7.t = $r8, $r8r9.lo 	#Opcode-lvx_v1-FMAXH_registerW_registerZ_registerY_simple
	;;
	fmaxnd $r8r9r10r11.x = $r9, $r8r9.hi 	#Opcode-lvx_v1-FMAXND_registerW_registerZ_registerY_simple
	;;
	fmaxnh $r8r9r10r11.y = $r10, $r10r11.lo 	#Opcode-lvx_v1-FMAXNH_registerW_registerZ_registerY_simple
	;;
	fmaxnw $r8r9r10r11.z = $r11, $r10r11.hi 	#Opcode-lvx_v1-FMAXNW_registerW_registerZ_registerY_simple
	;;
	fmaxw $r8r9r10r11.t = $r12, $sp 	#Opcode-lvx_v1-FMAXW_registerW_registerZ_registerY_simple
	;;
	fmind $r13 = $tp, $r14 	#Opcode-lvx_v1-FMIND_registerW_registerZ_registerY_simple
	;;
	fminh $fp = $r14r15.lo, $r15 	#Opcode-lvx_v1-FMINH_registerW_registerZ_registerY_simple
	;;
	fminnd $rp = $r14r15.hi, $r16 	#Opcode-lvx_v1-FMINND_registerW_registerZ_registerY_simple
	;;
	fminnh $r16r17.lo = $r16r17r18r19.x, $r17 	#Opcode-lvx_v1-FMINNH_registerW_registerZ_registerY_simple
	;;
	fminnw $r16r17.hi = $r16r17r18r19.y, $r18 	#Opcode-lvx_v1-FMINNW_registerW_registerZ_registerY_simple
	;;
	fminw $r18r19.lo = $r16r17r18r19.z, $r19 	#Opcode-lvx_v1-FMINW_registerW_registerZ_registerY_simple
	;;
	fmuld.n.rd $r18r19.hi = $r16r17r18r19.t, $r20 	#Opcode-lvx_v1-FMULD_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fmulh.ru $r20r21.lo = $r20r21r22r23.x, $r21 	#Opcode-lvx_v1-FMULH_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fmulwc.rm $r20r21.hi = $r20r21r22r23.y, $r22 	#Opcode-lvx_v1-FMULWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple
	;;
	fmulw.n.r5 $r22r23.lo = $r20r21r22r23.z, $r23 	#Opcode-lvx_v1-FMULW_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fnarrowdw.ro $r22r23.hi = $r20r21r22r23.t 	#Opcode-lvx_v1-FNARROWDW_floatmode_registerW_registerZ_simple
	;;
	fnarrowwh $r24 = $r24r25.lo 	#Opcode-lvx_v1-FNARROWWH_floatmode_registerW_registerZ_simple
	;;
	fnegd $r24r25r26r27.x = $r25 	#Opcode-lvx_v1-FNEGD_registerW_registerZ_simple
	;;
	fnegh $r24r25.hi = $r24r25r26r27.y 	#Opcode-lvx_v1-FNEGH_registerW_registerZ_simple
	;;
	fnegwp $r26 = $r26r27.lo 	#Opcode-lvx_v1-FNEGWP_registerW_registerZ_simple
	;;
	fnegw $r24r25r26r27.z = $r27 	#Opcode-lvx_v1-FNEGW_registerW_registerZ_simple
	;;
	frintd.rn $r26r27.hi = $r24r25r26r27.t 	#Opcode-lvx_v1-FRINTD_floatmode_registerW_registerZ_simple
	;;
	frinth.rz $r28 = $r28r29.lo 	#Opcode-lvx_v1-FRINTH_floatmode_registerW_registerZ_simple
	;;
	frintw.rd $r28r29r30r31.x = $r29 	#Opcode-lvx_v1-FRINTW_floatmode_registerW_registerZ_simple
	;;
	fsbfd.ru $r28r29.hi = $r28r29r30r31.y, $r30 	#Opcode-lvx_v1-FSBFD_floatmode_registerW_registerZ_registerY_simple
	;;
	fsbfh.rm $r30r31.lo = $r28r29r30r31.z, $r31 	#Opcode-lvx_v1-FSBFH_floatmode_registerW_registerZ_registerY_simple
	;;
	fsbfwc.c.mi.r5 $r30r31.hi = $r28r29r30r31.t, $r32 	#Opcode-lvx_v1-FSBFWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple
	;;
	fsbfw.ro $r32r33.lo = $r32r33r34r35.x, $r33 	#Opcode-lvx_v1-FSBFW_floatmode_registerW_registerZ_registerY_simple
	;;
	fsignd $r32r33.hi = $r32r33r34r35.y, $r34 	#Opcode-lvx_v1-FSIGND_registerW_registerZ_registerY_simple
	;;
	fsignh $r34r35.lo = $r32r33r34r35.z, $r35 	#Opcode-lvx_v1-FSIGNH_registerW_registerZ_registerY_simple
	;;
	fsignmd $r34r35.hi = $r32r33r34r35.t, $r36 	#Opcode-lvx_v1-FSIGNMD_registerW_registerZ_registerY_simple
	;;
	fsignmh $r36r37.lo = $r36r37r38r39.x, $r37 	#Opcode-lvx_v1-FSIGNMH_registerW_registerZ_registerY_simple
	;;
	fsignmw $r36r37.hi = $r36r37r38r39.y, $r38 	#Opcode-lvx_v1-FSIGNMW_registerW_registerZ_registerY_simple
	;;
	fsignnd $r38r39.lo = $r36r37r38r39.z, $r39 	#Opcode-lvx_v1-FSIGNND_registerW_registerZ_registerY_simple
	;;
	fsignnh $r38r39.hi = $r36r37r38r39.t, $r40 	#Opcode-lvx_v1-FSIGNNH_registerW_registerZ_registerY_simple
	;;
	fsignnw $r40r41.lo = $r40r41r42r43.x, $r41 	#Opcode-lvx_v1-FSIGNNW_registerW_registerZ_registerY_simple
	;;
	fsignw $r40r41.hi = $r40r41r42r43.y, $r42 	#Opcode-lvx_v1-FSIGNW_registerW_registerZ_registerY_simple
	;;
	fsqrtd $r42r43.lo = $r40r41r42r43.z 	#Opcode-lvx_v1-FSQRTD_floatmode_registerW_registerZ_simple
	;;
	fsqrth.rn $r43 = $r42r43.hi 	#Opcode-lvx_v1-FSQRTH_floatmode_registerW_registerZ_simple
	;;
	fsqrtw.rz $r40r41r42r43.t = $r44 	#Opcode-lvx_v1-FSQRTW_floatmode_registerW_registerZ_simple
	;;
	fsrecd $r44r45.lo = $r44r45r46r47.x 	#Opcode-lvx_v1-FSRECD_registerW_registerZ_simple
	;;
	fsrecwp $r45 = $r44r45.hi 	#Opcode-lvx_v1-FSRECWP_registerW_registerZ_simple
	;;
	fsrecw $r44r45r46r47.y = $r46 	#Opcode-lvx_v1-FSRECW_registerW_registerZ_simple
	;;
	fsrsrd $r46r47.lo = $r44r45r46r47.z 	#Opcode-lvx_v1-FSRSRD_registerW_registerZ_simple
	;;
	fsrsrwp $r47 = $r46r47.hi 	#Opcode-lvx_v1-FSRSRWP_registerW_registerZ_simple
	;;
	fsrsrw $r44r45r46r47.t = $r48 	#Opcode-lvx_v1-FSRSRW_registerW_registerZ_simple
	;;
	fwidenhw $r48r49.lo = $r48r49r50r51.x 	#Opcode-lvx_v1-FWIDENHW_mostsig_registerW_registerZ_simple
	;;
	fwidenwd.m $r49 = $r48r49.hi 	#Opcode-lvx_v1-FWIDENWD_mostsig_registerW_registerZ_simple
	;;
	get $r48r49r50r51.y = $pc 	#Opcode-lvx_v1-GET_registerZ_systemS2_simple
	;;
	get $r50 = $pc 	#Opcode-lvx_v1-GET_registerZ_systemS3_simple
	;;
	gotox -4503599627370496 	#Opcode-lvx_v1-GOTOX_upper27_lower27_double
	;;
	goto -33554432 	#Opcode-lvx_v1-GOTO_pcrel27s2_simple
	;;
	guard.dnez $r50r51.lo? 7 	#Opcode-lvx_v1-GUARD_execpred_registerZ_activate_simple
	;;
	i1invals 2305843009213693951[$r48r49r50r51.z] 	#Opcode-lvx_v1-I1INVALS_extend27_upper27_lower10_registerZ_triple
	;;
	i1invals $r51[$r50r51.hi] 	#Opcode-lvx_v1-I1INVALS_registerY_registerZ_simple
	;;
	i1invals -64[$r48r49r50r51.t] 	#Opcode-lvx_v1-I1INVALS_signed10_registerZ_simple
	;;
	i1invals -8589934592[$r52] 	#Opcode-lvx_v1-I1INVALS_upper27_lower10_registerZ_double
	;;
	i1inval 	#Opcode-lvx_v1-I1INVAL_simple
	;;
	icall $r52r53.lo 	#Opcode-lvx_v1-ICALL_registerZ_simple
	;;
	iget $r52r53r54r55.x 	#Opcode-lvx_v1-IGET_registerZ_simple
	;;
	igoto $r53 	#Opcode-lvx_v1-IGOTO_registerZ_simple
	;;
	insf $r52r53.hi = $r52r53r54r55.y, 7, 7 	#Opcode-lvx_v1-INSF_registerW_registerZ_stopbit2_stopbit4_startbit_simple
	;;
	iord $r54 = $r54r55.lo, 2305843009213693951 	#Opcode-lvx_v1-IORD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	iord $r52r53r54r55.z = $r55, $r54r55.hi 	#Opcode-lvx_v1-IORD_registerW_registerZ_registerY_simple
	;;
	iord $r52r53r54r55.t = $r56, -64 	#Opcode-lvx_v1-IORD_registerW_registerZ_signed10_simple
	;;
	iord $r56r57.lo = $r56r57r58r59.x, -8589934592 	#Opcode-lvx_v1-IORD_registerW_registerZ_upper27_lower10_double
	;;
	iornd $r57 = $r56r57.hi, 2305843009213693951 	#Opcode-lvx_v1-IORND_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	iornd $r56r57r58r59.y = $r58, $r58r59.lo 	#Opcode-lvx_v1-IORND_registerW_registerZ_registerY_simple
	;;
	iornd $r56r57r58r59.z = $r59, -64 	#Opcode-lvx_v1-IORND_registerW_registerZ_signed10_simple
	;;
	iornd $r58r59.hi = $r56r57r58r59.t, -8589934592 	#Opcode-lvx_v1-IORND_registerW_registerZ_upper27_lower10_double
	;;
	iornq $r46r47 = $r44r45r46r47.hi, $r48r49 	#Opcode-lvx_v1-IORNQ_registerM_registerP_registerO_simple
	;;
	iornq $r48r49r50r51.lo = $r50r51, 536870911 	#Opcode-lvx_v1-IORNQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	iornw.sx $r60 = $r60r61.lo, $r60r61r62r63.x 	#Opcode-lvx_v1-IORNW_signextw_registerW_registerZ_registerY_simple
	;;
	iornw $r61 = $r60r61.hi, 536870911 	#Opcode-lvx_v1-IORNW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	iorq $r48r49r50r51.hi = $r52r53, $r52r53r54r55.lo 	#Opcode-lvx_v1-IORQ_registerM_registerP_registerO_simple
	;;
	iorq $r54r55 = $r52r53r54r55.hi, 536870911.@ 	#Opcode-lvx_v1-IORQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	iorw.sx $r60r61r62r63.y = $r62, $r62r63.lo 	#Opcode-lvx_v1-IORW_signextw_registerW_registerZ_registerY_simple
	;;
	iorw $r60r61r62r63.z = $r63, 536870911 	#Opcode-lvx_v1-IORW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	landd $r62r63.hi = $r60r61r62r63.t, $r0 	#Opcode-lvx_v1-LANDD_registerW_registerZ_registerY_simple
	;;
	landw $r0r1.lo = $r0r1r2r3.x, $r1 	#Opcode-lvx_v1-LANDW_registerW_registerZ_registerY_simple
	;;
	lbs $r0r1.hi = 2305843009213693951[$r0r1r2r3.y] 	#Opcode-lvx_v1-LBS_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lbs.s $r2 = $r2r3.lo[$r0r1r2r3.z] 	#Opcode-lvx_v1-LBS_variant_registerW_registerY_registerZ_simple
	;;
	lbs.u $r3 = -64[$r2r3.hi] 	#Opcode-lvx_v1-LBS_variant_registerW_signed10_registerZ_simple
	;;
	lbs.us $r0r1r2r3.t = -8589934592[$r4] 	#Opcode-lvx_v1-LBS_variant_registerW_upper27_lower10_registerZ_double
	;;
	lbz $r4r5.lo = 2305843009213693951[$r4r5r6r7.x] 	#Opcode-lvx_v1-LBZ_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lbz.s $r5 = $r4r5.hi[$r4r5r6r7.y] 	#Opcode-lvx_v1-LBZ_variant_registerW_registerY_registerZ_simple
	;;
	lbz.u $r6 = -64[$r6r7.lo] 	#Opcode-lvx_v1-LBZ_variant_registerW_signed10_registerZ_simple
	;;
	lbz.us $r4r5r6r7.z = -8589934592[$r7] 	#Opcode-lvx_v1-LBZ_variant_registerW_upper27_lower10_registerZ_double
	;;
	ld $r6r7.hi = 2305843009213693951[$r4r5r6r7.t] 	#Opcode-lvx_v1-LD_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	ld.s $r8 = $r8r9.lo[$r8r9r10r11.x] 	#Opcode-lvx_v1-LD_variant_registerW_registerY_registerZ_simple
	;;
	ld.u $r9 = -64[$r8r9.hi] 	#Opcode-lvx_v1-LD_variant_registerW_signed10_registerZ_simple
	;;
	ld.us $r8r9r10r11.y = -8589934592[$r10] 	#Opcode-lvx_v1-LD_variant_registerW_upper27_lower10_registerZ_double
	;;
	lhs $r10r11.lo = 2305843009213693951[$r8r9r10r11.z] 	#Opcode-lvx_v1-LHS_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lhs.s $r11 = $r10r11.hi[$r8r9r10r11.t] 	#Opcode-lvx_v1-LHS_variant_registerW_registerY_registerZ_simple
	;;
	lhs.u $r12 = -64[$sp] 	#Opcode-lvx_v1-LHS_variant_registerW_signed10_registerZ_simple
	;;
	lhs.us $r13 = -8589934592[$tp] 	#Opcode-lvx_v1-LHS_variant_registerW_upper27_lower10_registerZ_double
	;;
	lhz $r14 = 2305843009213693951[$fp] 	#Opcode-lvx_v1-LHZ_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lhz.s $r14r15.lo = $r15[$rp] 	#Opcode-lvx_v1-LHZ_variant_registerW_registerY_registerZ_simple
	;;
	lhz.u $r14r15.hi = -64[$r16] 	#Opcode-lvx_v1-LHZ_variant_registerW_signed10_registerZ_simple
	;;
	lhz.us $r16r17.lo = -8589934592[$r16r17r18r19.x] 	#Opcode-lvx_v1-LHZ_variant_registerW_upper27_lower10_registerZ_double
	;;
	liord $r17 = $r16r17.hi, $r16r17r18r19.y 	#Opcode-lvx_v1-LIORD_registerW_registerZ_registerY_simple
	;;
	liorw $r18 = $r18r19.lo, $r16r17r18r19.z 	#Opcode-lvx_v1-LIORW_registerW_registerZ_registerY_simple
	;;
	lnandd $r19 = $r18r19.hi, $r16r17r18r19.t 	#Opcode-lvx_v1-LNANDD_registerW_registerZ_registerY_simple
	;;
	lnandw $r20 = $r20r21.lo, $r20r21r22r23.x 	#Opcode-lvx_v1-LNANDW_registerW_registerZ_registerY_simple
	;;
	lniord $r21 = $r20r21.hi, $r20r21r22r23.y 	#Opcode-lvx_v1-LNIORD_registerW_registerZ_registerY_simple
	;;
	lniorw $r22 = $r22r23.lo, $r20r21r22r23.z 	#Opcode-lvx_v1-LNIORW_registerW_registerZ_registerY_simple
	;;
	loopdo $r23, -32768 	#Opcode-lvx_v1-LOOPDO_registerZ_pcrel17s2_simple
	;;
	lo $r20r21r22r23 = 2305843009213693951[$r22r23.hi] 	#Opcode-lvx_v1-LO_variant_registerN_extend27_upper27_lower10_registerZ_triple
	;;
	lo.s $r24r25r26r27 = $r20r21r22r23.t[$r24] 	#Opcode-lvx_v1-LO_variant_registerN_registerY_registerZ_simple
	;;
	lo.u $r28r29r30r31 = -64[$r24r25.lo] 	#Opcode-lvx_v1-LO_variant_registerN_signed10_registerZ_simple
	;;
	lo.us $r32r33r34r35 = -8589934592[$r24r25r26r27.x] 	#Opcode-lvx_v1-LO_variant_registerN_upper27_lower10_registerZ_double
	;;
	lq $r56r57 = 2305843009213693951[$r25] 	#Opcode-lvx_v1-LQ_variant_registerM_extend27_upper27_lower10_registerZ_triple
	;;
	lq.s $r56r57r58r59.lo = $r24r25.hi[$r24r25r26r27.y] 	#Opcode-lvx_v1-LQ_variant_registerM_registerY_registerZ_simple
	;;
	lq.u $r58r59 = -64[$r26] 	#Opcode-lvx_v1-LQ_variant_registerM_signed10_registerZ_simple
	;;
	lq.us $r56r57r58r59.hi = -8589934592[$r26r27.lo] 	#Opcode-lvx_v1-LQ_variant_registerM_upper27_lower10_registerZ_double
	;;
	lws $r24r25r26r27.z = 2305843009213693951[$r27] 	#Opcode-lvx_v1-LWS_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lws.s $r26r27.hi = $r24r25r26r27.t[$r28] 	#Opcode-lvx_v1-LWS_variant_registerW_registerY_registerZ_simple
	;;
	lws.u $r28r29.lo = -64[$r28r29r30r31.x] 	#Opcode-lvx_v1-LWS_variant_registerW_signed10_registerZ_simple
	;;
	lws.us $r29 = -8589934592[$r28r29.hi] 	#Opcode-lvx_v1-LWS_variant_registerW_upper27_lower10_registerZ_double
	;;
	lwz $r28r29r30r31.y = 2305843009213693951[$r30] 	#Opcode-lvx_v1-LWZ_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lwz.s $r30r31.lo = $r28r29r30r31.z[$r31] 	#Opcode-lvx_v1-LWZ_variant_registerW_registerY_registerZ_simple
	;;
	lwz.u $r30r31.hi = -64[$r28r29r30r31.t] 	#Opcode-lvx_v1-LWZ_variant_registerW_signed10_registerZ_simple
	;;
	lwz.us $r32 = -8589934592[$r32r33.lo] 	#Opcode-lvx_v1-LWZ_variant_registerW_upper27_lower10_registerZ_double
	;;
	madddq $r60r61 = $r32r33r34r35.x, $r33 	#Opcode-lvx_v1-MADDDQ_widemult_registerM_registerZ_registerY_simple
	;;
	madddt $r60r61r62r63.lo = $r32r33.hi, $r32r33r34r35.y 	#Opcode-lvx_v1-MADDDT_registerM_registerZ_registerY_simple
	;;
	maddd $r34 = $r34r35.lo, $r32r33r34r35.z 	#Opcode-lvx_v1-MADDD_highmult_registerW_registerZ_registerY_simple
	;;
	maddd.h $r35 = $r34r35.hi, 536870911 	#Opcode-lvx_v1-MADDD_highmult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	maddsudt $r62r63 = $r32r33r34r35.t, $r36 	#Opcode-lvx_v1-MADDSUDT_registerM_registerZ_registerY_simple
	;;
	maddsuwd $r36r37.lo = $r36r37r38r39.x, $r37 	#Opcode-lvx_v1-MADDSUWD_registerW_registerZ_registerY_simple
	;;
	maddsuwd $r36r37.hi = $r36r37r38r39.y, 536870911 	#Opcode-lvx_v1-MADDSUWD_registerW_registerZ_upper27_lower5_double
	;;
	maddudt $r60r61r62r63.hi = $r38, $r38r39.lo 	#Opcode-lvx_v1-MADDUDT_registerM_registerZ_registerY_simple
	;;
	madduwd $r36r37r38r39.z = $r39, $r38r39.hi 	#Opcode-lvx_v1-MADDUWD_registerW_registerZ_registerY_simple
	;;
	madduwd $r36r37r38r39.t = $r40, 536870911 	#Opcode-lvx_v1-MADDUWD_registerW_registerZ_upper27_lower5_double
	;;
	maddwd.u $r40r41.lo = $r40r41r42r43.x, $r41 	#Opcode-lvx_v1-MADDWD_widemult_registerW_registerZ_registerY_simple
	;;
	maddwd.su $r40r41.hi = $r40r41r42r43.y, 536870911.@ 	#Opcode-lvx_v1-MADDWD_widemult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	maddw.hu.sx $r42 = $r42r43.lo, $r40r41r42r43.z 	#Opcode-lvx_v1-MADDW_highmult_signextw_registerW_registerZ_registerY_simple
	;;
	maddw.hsu $r43 = $r42r43.hi, 536870911 	#Opcode-lvx_v1-MADDW_highmult_signextw_registerW_registerZ_upper27_lower5_double
	;;
	make $r40r41r42r43.t = 2305843009213693951 	#Opcode-lvx_v1-MAKE_registerW_extend27_upper27_lower10_triple
	;;
	make $r44 = -549755813888 	#Opcode-lvx_v1-MAKE_registerW_extend6_upper27_lower10_double
	;;
	make $r44r45.lo = -4096 	#Opcode-lvx_v1-MAKE_registerW_signed16_simple
	;;
	maxd $r44r45r46r47.x = $r45, 2305843009213693951 	#Opcode-lvx_v1-MAXD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	maxd $r44r45.hi = $r44r45r46r47.y, $r46 	#Opcode-lvx_v1-MAXD_registerW_registerZ_registerY_simple
	;;
	maxd $r46r47.lo = $r44r45r46r47.z, -64 	#Opcode-lvx_v1-MAXD_registerW_registerZ_signed10_simple
	;;
	maxd $r47 = $r46r47.hi, -8589934592 	#Opcode-lvx_v1-MAXD_registerW_registerZ_upper27_lower10_double
	;;
	maxud $r44r45r46r47.t = $r48, 2305843009213693951 	#Opcode-lvx_v1-MAXUD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	maxud $r48r49.lo = $r48r49r50r51.x, $r49 	#Opcode-lvx_v1-MAXUD_registerW_registerZ_registerY_simple
	;;
	maxud $r48r49.hi = $r48r49r50r51.y, -64 	#Opcode-lvx_v1-MAXUD_registerW_registerZ_signed10_simple
	;;
	maxud $r50 = $r50r51.lo, -8589934592 	#Opcode-lvx_v1-MAXUD_registerW_registerZ_upper27_lower10_double
	;;
	maxuw.sx $r48r49r50r51.z = $r51, $r50r51.hi 	#Opcode-lvx_v1-MAXUW_signextw_registerW_registerZ_registerY_simple
	;;
	maxuw $r48r49r50r51.t = $r52, 536870911 	#Opcode-lvx_v1-MAXUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	maxw.sx $r52r53.lo = $r52r53r54r55.x, $r53 	#Opcode-lvx_v1-MAXW_signextw_registerW_registerZ_registerY_simple
	;;
	maxw $r52r53.hi = $r52r53r54r55.y, 536870911 	#Opcode-lvx_v1-MAXW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	mind $r54 = $r54r55.lo, 2305843009213693951 	#Opcode-lvx_v1-MIND_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	mind $r52r53r54r55.z = $r55, $r54r55.hi 	#Opcode-lvx_v1-MIND_registerW_registerZ_registerY_simple
	;;
	mind $r52r53r54r55.t = $r56, -64 	#Opcode-lvx_v1-MIND_registerW_registerZ_signed10_simple
	;;
	mind $r56r57.lo = $r56r57r58r59.x, -8589934592 	#Opcode-lvx_v1-MIND_registerW_registerZ_upper27_lower10_double
	;;
	minud $r57 = $r56r57.hi, 2305843009213693951 	#Opcode-lvx_v1-MINUD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	minud $r56r57r58r59.y = $r58, $r58r59.lo 	#Opcode-lvx_v1-MINUD_registerW_registerZ_registerY_simple
	;;
	minud $r56r57r58r59.z = $r59, -64 	#Opcode-lvx_v1-MINUD_registerW_registerZ_signed10_simple
	;;
	minud $r58r59.hi = $r56r57r58r59.t, -8589934592 	#Opcode-lvx_v1-MINUD_registerW_registerZ_upper27_lower10_double
	;;
	minuw.sx $r60 = $r60r61.lo, $r60r61r62r63.x 	#Opcode-lvx_v1-MINUW_signextw_registerW_registerZ_registerY_simple
	;;
	minuw $r61 = $r60r61.hi, 536870911 	#Opcode-lvx_v1-MINUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	minw.sx $r60r61r62r63.y = $r62, $r62r63.lo 	#Opcode-lvx_v1-MINW_signextw_registerW_registerZ_registerY_simple
	;;
	minw $r60r61r62r63.z = $r63, 536870911 	#Opcode-lvx_v1-MINW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	msbfdq $r0r1 = $r62r63.hi, $r60r61r62r63.t 	#Opcode-lvx_v1-MSBFDQ_widemult_registerM_registerZ_registerY_simple
	;;
	msbfdt $r0r1r2r3.lo = $r0, $r0r1.lo 	#Opcode-lvx_v1-MSBFDT_registerM_registerZ_registerY_simple
	;;
	msbfd $r0r1r2r3.x = $r1, $r0r1.hi 	#Opcode-lvx_v1-MSBFD_highmult_registerW_registerZ_registerY_simple
	;;
	msbfd.h $r0r1r2r3.y = $r2, 536870911 	#Opcode-lvx_v1-MSBFD_highmult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	msbfsudt $r2r3 = $r2r3.lo, $r0r1r2r3.z 	#Opcode-lvx_v1-MSBFSUDT_registerM_registerZ_registerY_simple
	;;
	msbfsuwd $r3 = $r2r3.hi, $r0r1r2r3.t 	#Opcode-lvx_v1-MSBFSUWD_registerW_registerZ_registerY_simple
	;;
	msbfsuwd $r4 = $r4r5.lo, 536870911 	#Opcode-lvx_v1-MSBFSUWD_registerW_registerZ_upper27_lower5_double
	;;
	msbfudt $r0r1r2r3.hi = $r4r5r6r7.x, $r5 	#Opcode-lvx_v1-MSBFUDT_registerM_registerZ_registerY_simple
	;;
	msbfuwd $r4r5.hi = $r4r5r6r7.y, $r6 	#Opcode-lvx_v1-MSBFUWD_registerW_registerZ_registerY_simple
	;;
	msbfuwd $r6r7.lo = $r4r5r6r7.z, 536870911 	#Opcode-lvx_v1-MSBFUWD_registerW_registerZ_upper27_lower5_double
	;;
	msbfwd.u $r7 = $r6r7.hi, $r4r5r6r7.t 	#Opcode-lvx_v1-MSBFWD_widemult_registerW_registerZ_registerY_simple
	;;
	msbfwd.su $r8 = $r8r9.lo, 536870911.@ 	#Opcode-lvx_v1-MSBFWD_widemult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	msbfw.hu.sx $r8r9r10r11.x = $r9, $r8r9.hi 	#Opcode-lvx_v1-MSBFW_highmult_signextw_registerW_registerZ_registerY_simple
	;;
	msbfw.hsu $r8r9r10r11.y = $r10, 536870911 	#Opcode-lvx_v1-MSBFW_highmult_signextw_registerW_registerZ_upper27_lower5_double
	;;
	muldq $r4r5 = $r10r11.lo, $r8r9r10r11.z 	#Opcode-lvx_v1-MULDQ_widemult_registerM_registerZ_registerY_simple
	;;
	muldt $r4r5r6r7.lo = $r11, $r10r11.hi 	#Opcode-lvx_v1-MULDT_registerM_registerZ_registerY_simple
	;;
	muld $r8r9r10r11.t = $r12, $sp 	#Opcode-lvx_v1-MULD_highmult_registerW_registerZ_registerY_simple
	;;
	muld.h $r13 = $tp, 536870911 	#Opcode-lvx_v1-MULD_highmult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	mulndq.u $r6r7 = $r14, $fp 	#Opcode-lvx_v1-MULNDQ_widemult_registerM_registerZ_registerY_simple
	;;
	mulnd.hu $r14r15.lo = $r15, $rp 	#Opcode-lvx_v1-MULND_highmult_registerW_registerZ_registerY_simple
	;;
	mulnd.hsu $r14r15.hi = $r16, 536870911.@ 	#Opcode-lvx_v1-MULND_highmult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	mulnwd.su $r16r17.lo = $r16r17r18r19.x, $r17 	#Opcode-lvx_v1-MULNWD_widemult_registerW_registerZ_registerY_simple
	;;
	mulnwd $r16r17.hi = $r16r17r18r19.y, 536870911 	#Opcode-lvx_v1-MULNWD_widemult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	mulnw.sx $r18 = $r18r19.lo, $r16r17r18r19.z 	#Opcode-lvx_v1-MULNW_highmult_signextw_registerW_registerZ_registerY_simple
	;;
	mulnw.h $r19 = $r18r19.hi, 536870911 	#Opcode-lvx_v1-MULNW_highmult_signextw_registerW_registerZ_upper27_lower5_double
	;;
	mulsudt $r4r5r6r7.hi = $r16r17r18r19.t, $r20 	#Opcode-lvx_v1-MULSUDT_registerM_registerZ_registerY_simple
	;;
	mulsuwd $r20r21.lo = $r20r21r22r23.x, $r21 	#Opcode-lvx_v1-MULSUWD_registerW_registerZ_registerY_simple
	;;
	mulsuwd $r20r21.hi = $r20r21r22r23.y, 536870911 	#Opcode-lvx_v1-MULSUWD_registerW_registerZ_upper27_lower5_double
	;;
	muludt $r8r9 = $r22, $r22r23.lo 	#Opcode-lvx_v1-MULUDT_registerM_registerZ_registerY_simple
	;;
	muluwd $r20r21r22r23.z = $r23, $r22r23.hi 	#Opcode-lvx_v1-MULUWD_registerW_registerZ_registerY_simple
	;;
	muluwd $r20r21r22r23.t = $r24, 536870911 	#Opcode-lvx_v1-MULUWD_registerW_registerZ_upper27_lower5_double
	;;
	mulwd.u $r24r25.lo = $r24r25r26r27.x, $r25 	#Opcode-lvx_v1-MULWD_widemult_registerW_registerZ_registerY_simple
	;;
	mulwd.su $r24r25.hi = $r24r25r26r27.y, 536870911.@ 	#Opcode-lvx_v1-MULWD_widemult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	mulw.hu.sx $r26 = $r26r27.lo, $r24r25r26r27.z 	#Opcode-lvx_v1-MULW_highmult_signextw_registerW_registerZ_registerY_simple
	;;
	mulw.hsu $r27 = $r26r27.hi, 536870911 	#Opcode-lvx_v1-MULW_highmult_signextw_registerW_registerZ_upper27_lower5_double
	;;
	nandd $r24r25r26r27.t = $r28, 2305843009213693951 	#Opcode-lvx_v1-NANDD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	nandd $r28r29.lo = $r28r29r30r31.x, $r29 	#Opcode-lvx_v1-NANDD_registerW_registerZ_registerY_simple
	;;
	nandd $r28r29.hi = $r28r29r30r31.y, -64 	#Opcode-lvx_v1-NANDD_registerW_registerZ_signed10_simple
	;;
	nandd $r30 = $r30r31.lo, -8589934592 	#Opcode-lvx_v1-NANDD_registerW_registerZ_upper27_lower10_double
	;;
	nandq $r8r9r10r11.lo = $r10r11, $r8r9r10r11.hi 	#Opcode-lvx_v1-NANDQ_registerM_registerP_registerO_simple
	;;
	nandq $r12r13 = $r12r13r14r15.lo, 536870911 	#Opcode-lvx_v1-NANDQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	nandw.sx $r28r29r30r31.z = $r31, $r30r31.hi 	#Opcode-lvx_v1-NANDW_signextw_registerW_registerZ_registerY_simple
	;;
	nandw $r28r29r30r31.t = $r32, 536870911 	#Opcode-lvx_v1-NANDW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	negd $r32r33.lo = $r32r33r34r35.x 	#Opcode-lvx_v1-NEGD_registerW_registerZ_simple
	;;
	negq $r14r15 = $r12r13r14r15.hi 	#Opcode-lvx_v1-NEGQ_registerM_registerP_simple
	;;
	negsd $r33 = $r32r33.hi 	#Opcode-lvx_v1-NEGSD_registerW_registerZ_simple
	;;
	negsw $r32r33r34r35.y = $r34 	#Opcode-lvx_v1-NEGSW_registerW_registerZ_simple
	;;
	negw $r34r35.lo = $r32r33r34r35.z 	#Opcode-lvx_v1-NEGW_registerW_registerZ_simple
	;;
	neord $r35 = $r34r35.hi, 2305843009213693951 	#Opcode-lvx_v1-NEORD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	neord $r32r33r34r35.t = $r36, $r36r37.lo 	#Opcode-lvx_v1-NEORD_registerW_registerZ_registerY_simple
	;;
	neord $r36r37r38r39.x = $r37, -64 	#Opcode-lvx_v1-NEORD_registerW_registerZ_signed10_simple
	;;
	neord $r36r37.hi = $r36r37r38r39.y, -8589934592 	#Opcode-lvx_v1-NEORD_registerW_registerZ_upper27_lower10_double
	;;
	neorq $r16r17 = $r16r17r18r19.lo, $r18r19 	#Opcode-lvx_v1-NEORQ_registerM_registerP_registerO_simple
	;;
	neorq $r16r17r18r19.hi = $r20r21, 536870911.@ 	#Opcode-lvx_v1-NEORQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	neorw.sx $r38 = $r38r39.lo, $r36r37r38r39.z 	#Opcode-lvx_v1-NEORW_signextw_registerW_registerZ_registerY_simple
	;;
	neorw $r39 = $r38r39.hi, 536870911 	#Opcode-lvx_v1-NEORW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	niord $r36r37r38r39.t = $r40, 2305843009213693951 	#Opcode-lvx_v1-NIORD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	niord $r40r41.lo = $r40r41r42r43.x, $r41 	#Opcode-lvx_v1-NIORD_registerW_registerZ_registerY_simple
	;;
	niord $r40r41.hi = $r40r41r42r43.y, -64 	#Opcode-lvx_v1-NIORD_registerW_registerZ_signed10_simple
	;;
	niord $r42 = $r42r43.lo, -8589934592 	#Opcode-lvx_v1-NIORD_registerW_registerZ_upper27_lower10_double
	;;
	niorq $r20r21r22r23.lo = $r22r23, $r20r21r22r23.hi 	#Opcode-lvx_v1-NIORQ_registerM_registerP_registerO_simple
	;;
	niorq $r24r25 = $r24r25r26r27.lo, 536870911 	#Opcode-lvx_v1-NIORQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	niorw.sx $r40r41r42r43.z = $r43, $r42r43.hi 	#Opcode-lvx_v1-NIORW_signextw_registerW_registerZ_registerY_simple
	;;
	niorw $r40r41r42r43.t = $r44, 536870911 	#Opcode-lvx_v1-NIORW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	nop 	#Opcode-lvx_v1-NOP_simple
	;;
	notd $r44r45.lo = $r44r45r46r47.x 	#Opcode-lvx_v1-NOTD_registerW_registerZ_simple
	;;
	notq $r26r27 = $r24r25r26r27.hi 	#Opcode-lvx_v1-NOTQ_registerM_registerP_simple
	;;
	notw $r45 = $r44r45.hi 	#Opcode-lvx_v1-NOTW_registerW_registerZ_simple
	;;
	pcrel $r44r45r46r47.y = 2305843009213693951 	#Opcode-lvx_v1-PCREL_registerW_extend27_upper27_lower10_triple
	;;
	pcrel $r46 = -549755813888 	#Opcode-lvx_v1-PCREL_registerW_extend6_upper27_lower10_double
	;;
	pcrel $r46r47.lo = -4096 	#Opcode-lvx_v1-PCREL_registerW_signed16_simple
	;;
	ret 	#Opcode-lvx_v1-RET_simple
	;;
	rfe 	#Opcode-lvx_v1-RFE_simple
	;;
	rold $r44r45r46r47.z = $r47, $r46r47.hi 	#Opcode-lvx_v1-ROLD_registerW_registerZ_registerY_simple
	;;
	rold $r44r45r46r47.t = $r48, 7 	#Opcode-lvx_v1-ROLD_registerW_registerZ_unsigned6_simple
	;;
	rolw.sx $r48r49.lo = $r48r49r50r51.x, $r49 	#Opcode-lvx_v1-ROLW_signextw_registerW_registerZ_registerY_simple
	;;
	rolw $r48r49.hi = $r48r49r50r51.y, 7 	#Opcode-lvx_v1-ROLW_signextw_registerW_registerZ_unsigned6_simple
	;;
	rord $r50 = $r50r51.lo, $r48r49r50r51.z 	#Opcode-lvx_v1-RORD_registerW_registerZ_registerY_simple
	;;
	rord $r51 = $r50r51.hi, 7 	#Opcode-lvx_v1-RORD_registerW_registerZ_unsigned6_simple
	;;
	rorw.sx $r48r49r50r51.t = $r52, $r52r53.lo 	#Opcode-lvx_v1-RORW_signextw_registerW_registerZ_registerY_simple
	;;
	rorw $r52r53r54r55.x = $r53, 7 	#Opcode-lvx_v1-RORW_signextw_registerW_registerZ_unsigned6_simple
	;;
	rswap $r52r53.hi = $mmc 	#Opcode-lvx_v1-RSWAP_registerZ_systemAlone_simple
	;;
	rswap $r52r53r54r55.y = $s0 	#Opcode-lvx_v1-RSWAP_registerZ_systemS3_simple
	;;
	rswap $r54 = $pc 	#Opcode-lvx_v1-RSWAP_registerZ_systemS4_simple
	;;
	sbfd $r54r55.lo = $r52r53r54r55.z, 2305843009213693951 	#Opcode-lvx_v1-SBFD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbfd $r55 = $r54r55.hi, $r52r53r54r55.t 	#Opcode-lvx_v1-SBFD_registerW_registerZ_registerY_simple
	;;
	sbfd $r56 = $r56r57.lo, -64 	#Opcode-lvx_v1-SBFD_registerW_registerZ_signed10_simple
	;;
	sbfd $r56r57r58r59.x = $r57, -8589934592 	#Opcode-lvx_v1-SBFD_registerW_registerZ_upper27_lower10_double
	;;
	sbfq $r28r29 = $r28r29r30r31.lo, $r30r31 	#Opcode-lvx_v1-SBFQ_registerM_registerP_registerO_simple
	;;
	sbfq $r28r29r30r31.hi = $r32r33, 536870911.@ 	#Opcode-lvx_v1-SBFQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfsd $r56r57.hi = $r56r57r58r59.y, $r58 	#Opcode-lvx_v1-SBFSD_registerW_registerZ_registerY_simple
	;;
	sbfsd $r58r59.lo = $r56r57r58r59.z, 536870911 	#Opcode-lvx_v1-SBFSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	sbfsw.sx $r59 = $r58r59.hi, $r56r57r58r59.t 	#Opcode-lvx_v1-SBFSW_signextw_registerW_registerZ_registerY_simple
	;;
	sbfsw $r60 = $r60r61.lo, 536870911 	#Opcode-lvx_v1-SBFSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	sbfusd $r60r61r62r63.x = $r61, $r60r61.hi 	#Opcode-lvx_v1-SBFUSD_registerW_registerZ_registerY_simple
	;;
	sbfusd $r60r61r62r63.y = $r62, 536870911.@ 	#Opcode-lvx_v1-SBFUSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	sbfusw.sx $r62r63.lo = $r60r61r62r63.z, $r63 	#Opcode-lvx_v1-SBFUSW_signextw_registerW_registerZ_registerY_simple
	;;
	sbfusw $r62r63.hi = $r60r61r62r63.t, 536870911 	#Opcode-lvx_v1-SBFUSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	sbfw.sx $r0 = $r0r1.lo, $r0r1r2r3.x 	#Opcode-lvx_v1-SBFW_signextw_registerW_registerZ_registerY_simple
	;;
	sbfw $r1 = $r0r1.hi, 536870911 	#Opcode-lvx_v1-SBFW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	sbmm8d $r0r1r2r3.y = $r2, 2305843009213693951 	#Opcode-lvx_v1-SBMM8D_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbmm8d $r2r3.lo = $r0r1r2r3.z, $r3 	#Opcode-lvx_v1-SBMM8D_registerW_registerZ_registerY_simple
	;;
	sbmm8d $r2r3.hi = $r0r1r2r3.t, -64 	#Opcode-lvx_v1-SBMM8D_registerW_registerZ_signed10_simple
	;;
	sbmm8d $r4 = $r4r5.lo, -8589934592 	#Opcode-lvx_v1-SBMM8D_registerW_registerZ_upper27_lower10_double
	;;
	sbmm8eord $r4r5r6r7.x = $r5, $r4r5.hi 	#Opcode-lvx_v1-SBMM8EORD_registerW_registerZ_registerY_simple
	;;
	sbmm8eord $r4r5r6r7.y = $r6, 536870911 	#Opcode-lvx_v1-SBMM8EORD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	sbmm8 $r6r7.lo = $r4r5r6r7.z, 2305843009213693951 	#Opcode-lvx_v1-SBMM8_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbmm8 $r7 = $r6r7.hi, $r4r5r6r7.t 	#Opcode-lvx_v1-SBMM8_registerW_registerZ_registerY_simple
	;;
	sbmm8 $r8 = $r8r9.lo, -64 	#Opcode-lvx_v1-SBMM8_registerW_registerZ_signed10_simple
	;;
	sbmm8 $r8r9r10r11.x = $r9, -8589934592 	#Opcode-lvx_v1-SBMM8_registerW_registerZ_upper27_lower10_double
	;;
	sbmmt8d $r8r9.hi = $r8r9r10r11.y, 2305843009213693951 	#Opcode-lvx_v1-SBMMT8D_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbmmt8d $r10 = $r10r11.lo, $r8r9r10r11.z 	#Opcode-lvx_v1-SBMMT8D_registerW_registerZ_registerY_simple
	;;
	sbmmt8d $r11 = $r10r11.hi, -64 	#Opcode-lvx_v1-SBMMT8D_registerW_registerZ_signed10_simple
	;;
	sbmmt8d $r8r9r10r11.t = $r12, -8589934592 	#Opcode-lvx_v1-SBMMT8D_registerW_registerZ_upper27_lower10_double
	;;
	sbmmt8eord $sp = $r13, $tp 	#Opcode-lvx_v1-SBMMT8EORD_registerW_registerZ_registerY_simple
	;;
	sbmmt8eord $r14 = $fp, 536870911.@ 	#Opcode-lvx_v1-SBMMT8EORD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	sbmmt8 $r14r15.lo = $r15, 2305843009213693951 	#Opcode-lvx_v1-SBMMT8_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbmmt8 $rp = $r14r15.hi, $r16 	#Opcode-lvx_v1-SBMMT8_registerW_registerZ_registerY_simple
	;;
	sbmmt8 $r16r17.lo = $r16r17r18r19.x, -64 	#Opcode-lvx_v1-SBMMT8_registerW_registerZ_signed10_simple
	;;
	sbmmt8 $r17 = $r16r17.hi, -8589934592 	#Opcode-lvx_v1-SBMMT8_registerW_registerZ_upper27_lower10_double
	;;
	sb 2305843009213693951[$r16r17r18r19.y] = $r18 	#Opcode-lvx_v1-SB_extend27_upper27_lower10_registerZ_registerT_triple
	;;
	sb $r18r19.lo[$r16r17r18r19.z] = $r19 	#Opcode-lvx_v1-SB_registerY_registerZ_registerT_simple
	;;
	sb -64[$r18r19.hi] = $r16r17r18r19.t 	#Opcode-lvx_v1-SB_signed10_registerZ_registerT_simple
	;;
	sb -8589934592[$r20] = $r20r21.lo 	#Opcode-lvx_v1-SB_upper27_lower10_registerZ_registerT_double
	;;
	scall $r20r21r22r23.x 	#Opcode-lvx_v1-SCALL_registerZ_simple
	;;
	scall 511 	#Opcode-lvx_v1-SCALL_sysnumber_simple
	;;
	sd 2305843009213693951[$r21] = $r20r21.hi 	#Opcode-lvx_v1-SD_extend27_upper27_lower10_registerZ_registerT_triple
	;;
	sd $r20r21r22r23.y[$r22] = $r22r23.lo 	#Opcode-lvx_v1-SD_registerY_registerZ_registerT_simple
	;;
	sd -64[$r20r21r22r23.z] = $r23 	#Opcode-lvx_v1-SD_signed10_registerZ_registerT_simple
	;;
	sd -8589934592[$r22r23.hi] = $r20r21r22r23.t 	#Opcode-lvx_v1-SD_upper27_lower10_registerZ_registerT_double
	;;
	set $s28 = $r24 	#Opcode-lvx_v1-SET_systemAlone_registerZ_simple
	;;
	set $ra = $r24r25.lo 	#Opcode-lvx_v1-SET_systemRA_registerZ_simple
	;;
	set $ps = $r24r25r26r27.x 	#Opcode-lvx_v1-SET_systemT3_registerZ_simple
	;;
	set $ps = $r25 	#Opcode-lvx_v1-SET_systemT4_registerZ_simple
	;;
	sh 2305843009213693951[$r24r25.hi] = $r24r25r26r27.y 	#Opcode-lvx_v1-SH_extend27_upper27_lower10_registerZ_registerT_triple
	;;
	sh $r26[$r26r27.lo] = $r24r25r26r27.z 	#Opcode-lvx_v1-SH_registerY_registerZ_registerT_simple
	;;
	sh -64[$r27] = $r26r27.hi 	#Opcode-lvx_v1-SH_signed10_registerZ_registerT_simple
	;;
	sh -8589934592[$r24r25r26r27.t] = $r28 	#Opcode-lvx_v1-SH_upper27_lower10_registerZ_registerT_double
	;;
	signd $r28r29.lo = $r28r29r30r31.x, $r29 	#Opcode-lvx_v1-SIGND_registerW_registerZ_registerY_simple
	;;
	signd $r28r29.hi = $r28r29r30r31.y, 536870911 	#Opcode-lvx_v1-SIGND_registerW_registerZ_upper27_lower5_splat32_double
	;;
	signsd $r30 = $r30r31.lo, $r28r29r30r31.z 	#Opcode-lvx_v1-SIGNSD_registerW_registerZ_registerY_simple
	;;
	signsd $r31 = $r30r31.hi, 536870911.@ 	#Opcode-lvx_v1-SIGNSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	signsw.sx $r28r29r30r31.t = $r32, $r32r33.lo 	#Opcode-lvx_v1-SIGNSW_signextw_registerW_registerZ_registerY_simple
	;;
	signsw $r32r33r34r35.x = $r33, 536870911 	#Opcode-lvx_v1-SIGNSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	signw.sx $r32r33.hi = $r32r33r34r35.y, $r34 	#Opcode-lvx_v1-SIGNW_signextw_registerW_registerZ_registerY_simple
	;;
	signw $r34r35.lo = $r32r33r34r35.z, 536870911 	#Opcode-lvx_v1-SIGNW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	sleep 	#Opcode-lvx_v1-SLEEP_simple
	;;
	slld $r35 = $r34r35.hi, $r32r33r34r35.t 	#Opcode-lvx_v1-SLLD_registerW_registerZ_registerY_simple
	;;
	slld $r36 = $r36r37.lo, 7 	#Opcode-lvx_v1-SLLD_registerW_registerZ_unsigned6_simple
	;;
	sllw.sx $r36r37r38r39.x = $r37, $r36r37.hi 	#Opcode-lvx_v1-SLLW_signextw_registerW_registerZ_registerY_simple
	;;
	sllw $r36r37r38r39.y = $r38, 7 	#Opcode-lvx_v1-SLLW_signextw_registerW_registerZ_unsigned6_simple
	;;
	slsd $r38r39.lo = $r36r37r38r39.z, $r39 	#Opcode-lvx_v1-SLSD_registerW_registerZ_registerY_simple
	;;
	slsd $r38r39.hi = $r36r37r38r39.t, 7 	#Opcode-lvx_v1-SLSD_registerW_registerZ_unsigned6_simple
	;;
	slsw.sx $r40 = $r40r41.lo, $r40r41r42r43.x 	#Opcode-lvx_v1-SLSW_signextw_registerW_registerZ_registerY_simple
	;;
	slsw $r41 = $r40r41.hi, 7 	#Opcode-lvx_v1-SLSW_signextw_registerW_registerZ_unsigned6_simple
	;;
	slusd $r40r41r42r43.y = $r42, $r42r43.lo 	#Opcode-lvx_v1-SLUSD_registerW_registerZ_registerY_simple
	;;
	slusd $r40r41r42r43.z = $r43, 7 	#Opcode-lvx_v1-SLUSD_registerW_registerZ_unsigned6_simple
	;;
	slusw.sx $r42r43.hi = $r40r41r42r43.t, $r44 	#Opcode-lvx_v1-SLUSW_signextw_registerW_registerZ_registerY_simple
	;;
	slusw $r44r45.lo = $r44r45r46r47.x, 7 	#Opcode-lvx_v1-SLUSW_signextw_registerW_registerZ_unsigned6_simple
	;;
	so 2305843009213693951[$r45] = $r36r37r38r39 	#Opcode-lvx_v1-SO_extend27_upper27_lower10_registerZ_registerV_triple
	;;
	so $r44r45.hi[$r44r45r46r47.y] = $r40r41r42r43 	#Opcode-lvx_v1-SO_registerY_registerZ_registerV_simple
	;;
	so -64[$r46] = $r44r45r46r47 	#Opcode-lvx_v1-SO_signed10_registerZ_registerV_simple
	;;
	so -8589934592[$r46r47.lo] = $r48r49r50r51 	#Opcode-lvx_v1-SO_upper27_lower10_registerZ_registerV_double
	;;
	sq 2305843009213693951[$r44r45r46r47.z] = $r32r33r34r35.lo 	#Opcode-lvx_v1-SQ_extend27_upper27_lower10_registerZ_registerU_triple
	;;
	sq $r47[$r46r47.hi] = $r34r35 	#Opcode-lvx_v1-SQ_registerY_registerZ_registerU_simple
	;;
	sq -64[$r44r45r46r47.t] = $r32r33r34r35.hi 	#Opcode-lvx_v1-SQ_signed10_registerZ_registerU_simple
	;;
	sq -8589934592[$r48] = $r36r37 	#Opcode-lvx_v1-SQ_upper27_lower10_registerZ_registerU_double
	;;
	srad $r48r49.lo = $r48r49r50r51.x, $r49 	#Opcode-lvx_v1-SRAD_registerW_registerZ_registerY_simple
	;;
	srad $r48r49.hi = $r48r49r50r51.y, 7 	#Opcode-lvx_v1-SRAD_registerW_registerZ_unsigned6_simple
	;;
	sraw.sx $r50 = $r50r51.lo, $r48r49r50r51.z 	#Opcode-lvx_v1-SRAW_signextw_registerW_registerZ_registerY_simple
	;;
	sraw $r51 = $r50r51.hi, 7 	#Opcode-lvx_v1-SRAW_signextw_registerW_registerZ_unsigned6_simple
	;;
	srld $r48r49r50r51.t = $r52, $r52r53.lo 	#Opcode-lvx_v1-SRLD_registerW_registerZ_registerY_simple
	;;
	srld $r52r53r54r55.x = $r53, 7 	#Opcode-lvx_v1-SRLD_registerW_registerZ_unsigned6_simple
	;;
	srlw.sx $r52r53.hi = $r52r53r54r55.y, $r54 	#Opcode-lvx_v1-SRLW_signextw_registerW_registerZ_registerY_simple
	;;
	srlw $r54r55.lo = $r52r53r54r55.z, 7 	#Opcode-lvx_v1-SRLW_signextw_registerW_registerZ_unsigned6_simple
	;;
	srsd $r55 = $r54r55.hi, $r52r53r54r55.t 	#Opcode-lvx_v1-SRSD_registerW_registerZ_registerY_simple
	;;
	srsd $r56 = $r56r57.lo, 7 	#Opcode-lvx_v1-SRSD_registerW_registerZ_unsigned6_simple
	;;
	srsw.sx $r56r57r58r59.x = $r57, $r56r57.hi 	#Opcode-lvx_v1-SRSW_signextw_registerW_registerZ_registerY_simple
	;;
	srsw $r56r57r58r59.y = $r58, 7 	#Opcode-lvx_v1-SRSW_signextw_registerW_registerZ_unsigned6_simple
	;;
	stop 	#Opcode-lvx_v1-STOP_simple
	;;
	stsud $r58r59.lo = $r56r57r58r59.z, $r59 	#Opcode-lvx_v1-STSUD_registerW_registerZ_registerY_simple
	;;
	stsuw.sx $r58r59.hi = $r56r57r58r59.t, $r60 	#Opcode-lvx_v1-STSUW_signextw_registerW_registerZ_registerY_simple
	;;
	sw 2305843009213693951[$r60r61.lo] = $r60r61r62r63.x 	#Opcode-lvx_v1-SW_extend27_upper27_lower10_registerZ_registerT_triple
	;;
	sw $r61[$r60r61.hi] = $r60r61r62r63.y 	#Opcode-lvx_v1-SW_registerY_registerZ_registerT_simple
	;;
	sw -64[$r62] = $r62r63.lo 	#Opcode-lvx_v1-SW_signed10_registerZ_registerT_simple
	;;
	sw -8589934592[$r60r61r62r63.z] = $r63 	#Opcode-lvx_v1-SW_upper27_lower10_registerZ_registerT_double
	;;
	sxbd $r62r63.hi = $r60r61r62r63.t 	#Opcode-lvx_v1-SXBD_registerW_registerZ_simple
	;;
	sxhd $r0 = $r0r1.lo 	#Opcode-lvx_v1-SXHD_registerW_registerZ_simple
	;;
	sxwd $r0r1r2r3.x = $r1 	#Opcode-lvx_v1-SXWD_registerW_registerZ_simple
	;;
	syncgroup $r0r1.hi 	#Opcode-lvx_v1-SYNCGROUP_registerZ_simple
	;;
	tlbdinval 	#Opcode-lvx_v1-TLBDINVAL_simple
	;;
	tlbiinval 	#Opcode-lvx_v1-TLBIINVAL_simple
	;;
	tlbprobe 	#Opcode-lvx_v1-TLBPROBE_simple
	;;
	tlbread 	#Opcode-lvx_v1-TLBREAD_simple
	;;
	tlbwrite 	#Opcode-lvx_v1-TLBWRITE_simple
	;;
	waitit $r0r1r2r3.y 	#Opcode-lvx_v1-WAITIT_registerZ_simple
	;;
	wfxl $ps, $r2 	#Opcode-lvx_v1-WFXL_systemAlone_registerZ_simple
	;;
	wfxl $pcr, $r2r3.lo 	#Opcode-lvx_v1-WFXL_systemT2_registerZ_simple
	;;
	wfxl $s1, $r0r1r2r3.z 	#Opcode-lvx_v1-WFXL_systemT4_registerZ_simple
	;;
	wfxm $s1, $r3 	#Opcode-lvx_v1-WFXM_systemAlone_registerZ_simple
	;;
	wfxm $s2, $r2r3.hi 	#Opcode-lvx_v1-WFXM_systemT2_registerZ_simple
	;;
	wfxm $pcr, $r0r1r2r3.t 	#Opcode-lvx_v1-WFXM_systemT4_registerZ_simple
	;;
	zxbd $r4 = $r4r5.lo 	#Opcode-lvx_v1-ZXBD_registerW_registerZ_simple
	;;
	zxhd $r4r5r6r7.x = $r5 	#Opcode-lvx_v1-ZXHD_registerW_registerZ_simple
	;;
	zxwd $r4r5.hi = $r4r5r6r7.y 	#Opcode-lvx_v1-ZXWD_registerW_registerZ_simple
	;;
	.endp	main
	.section .text

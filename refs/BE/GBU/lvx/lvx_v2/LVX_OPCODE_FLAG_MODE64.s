	##-----------------------------------------------------------
	## Generating test.s from MDS
	## Copyright (C) 2026 Liesme Tech.
	##-----------------------------------------------------------

#	Option: ''

##	target-core:	lvx-2

	.section .text

	.align 8
	.proc	main
	.global	main
main:
	abdbx $r0r1 = $r0r1r2r3.lo, $r2r3 	#Opcode-lvx_v2-ABDBX_registerM_registerP_registerO_simple
	;;
	abdbx $r0r1r2r3.hi = $r4r5, 536870911 	#Opcode-lvx_v2-ABDBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	abddp $r4r5r6r7.lo = $r6r7, $r4r5r6r7.hi 	#Opcode-lvx_v2-ABDDP_registerM_registerP_registerO_simple
	;;
	abddp $r8r9 = $r8r9r10r11.lo, 536870911.@ 	#Opcode-lvx_v2-ABDDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	abdd $r0 = $r0r1.lo, $r0r1r2r3.x 	#Opcode-lvx_v2-ABDD_registerW_registerZ_registerY_simple
	;;
	abdd $r1 = $r0r1.hi, 536870911 	#Opcode-lvx_v2-ABDD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	abdho $r10r11 = $r8r9r10r11.hi, $r12r13 	#Opcode-lvx_v2-ABDHO_registerM_registerP_registerO_simple
	;;
	abdho $r12r13r14r15.lo = $r14r15, 536870911.@ 	#Opcode-lvx_v2-ABDHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	abdsbx $r12r13r14r15.hi = $r16r17, $r16r17r18r19.lo 	#Opcode-lvx_v2-ABDSBX_registerM_registerP_registerO_simple
	;;
	abdsbx $r18r19 = $r16r17r18r19.hi, 536870911 	#Opcode-lvx_v2-ABDSBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	abdsdp $r20r21 = $r20r21r22r23.lo, $r22r23 	#Opcode-lvx_v2-ABDSDP_registerM_registerP_registerO_simple
	;;
	abdsdp $r20r21r22r23.hi = $r24r25, 536870911.@ 	#Opcode-lvx_v2-ABDSDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	abdsd $r0r1r2r3.y = $r2, $r2r3.lo 	#Opcode-lvx_v2-ABDSD_registerW_registerZ_registerY_simple
	;;
	abdsd $r0r1r2r3.z = $r3, 536870911 	#Opcode-lvx_v2-ABDSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	abdsho $r24r25r26r27.lo = $r26r27, $r24r25r26r27.hi 	#Opcode-lvx_v2-ABDSHO_registerM_registerP_registerO_simple
	;;
	abdsho $r28r29 = $r28r29r30r31.lo, 536870911.@ 	#Opcode-lvx_v2-ABDSHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	abdswq $r30r31 = $r28r29r30r31.hi, $r32r33 	#Opcode-lvx_v2-ABDSWQ_registerM_registerP_registerO_simple
	;;
	abdswq $r32r33r34r35.lo = $r34r35, 536870911 	#Opcode-lvx_v2-ABDSWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	abdsw $r2r3.hi = $r0r1r2r3.t, $r4 	#Opcode-lvx_v2-ABDSW_signextw_registerW_registerZ_registerY_simple
	;;
	abdsw.sx $r4r5.lo = $r4r5r6r7.x, 536870911 	#Opcode-lvx_v2-ABDSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	abdubx $r32r33r34r35.hi = $r36r37, $r36r37r38r39.lo 	#Opcode-lvx_v2-ABDUBX_registerM_registerP_registerO_simple
	;;
	abdubx $r38r39 = $r36r37r38r39.hi, 536870911.@ 	#Opcode-lvx_v2-ABDUBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	abdudp $r40r41 = $r40r41r42r43.lo, $r42r43 	#Opcode-lvx_v2-ABDUDP_registerM_registerP_registerO_simple
	;;
	abdudp $r40r41r42r43.hi = $r44r45, 536870911 	#Opcode-lvx_v2-ABDUDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	abdud $r5 = $r4r5.hi, $r4r5r6r7.y 	#Opcode-lvx_v2-ABDUD_registerW_registerZ_registerY_simple
	;;
	abdud $r6 = $r6r7.lo, 536870911.@ 	#Opcode-lvx_v2-ABDUD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	abduho $r44r45r46r47.lo = $r46r47, $r44r45r46r47.hi 	#Opcode-lvx_v2-ABDUHO_registerM_registerP_registerO_simple
	;;
	abduho $r48r49 = $r48r49r50r51.lo, 536870911 	#Opcode-lvx_v2-ABDUHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	abduwq $r50r51 = $r48r49r50r51.hi, $r52r53 	#Opcode-lvx_v2-ABDUWQ_registerM_registerP_registerO_simple
	;;
	abduwq $r52r53r54r55.lo = $r54r55, 536870911.@ 	#Opcode-lvx_v2-ABDUWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	abduw $r4r5r6r7.z = $r7, $r6r7.hi 	#Opcode-lvx_v2-ABDUW_signextw_registerW_registerZ_registerY_simple
	;;
	abduw.sx $r4r5r6r7.t = $r8, 536870911 	#Opcode-lvx_v2-ABDUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	abdwq $r52r53r54r55.hi = $r56r57, $r56r57r58r59.lo 	#Opcode-lvx_v2-ABDWQ_registerM_registerP_registerO_simple
	;;
	abdwq $r58r59 = $r56r57r58r59.hi, 536870911 	#Opcode-lvx_v2-ABDWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	abdw $r8r9.lo = $r8r9r10r11.x, $r9 	#Opcode-lvx_v2-ABDW_signextw_registerW_registerZ_registerY_simple
	;;
	abdw.sx $r8r9.hi = $r8r9r10r11.y, 536870911 	#Opcode-lvx_v2-ABDW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	absbx $r60r61 = $r60r61r62r63.lo 	#Opcode-lvx_v2-ABSBX_registerM_registerP_simple
	;;
	absdp $r62r63 = $r60r61r62r63.hi 	#Opcode-lvx_v2-ABSDP_registerM_registerP_simple
	;;
	absd $r10 = $r10r11.lo 	#Opcode-lvx_v2-ABSD_registerW_registerZ_simple
	;;
	absho $r0r1 = $r0r1r2r3.lo 	#Opcode-lvx_v2-ABSHO_registerM_registerP_simple
	;;
	abssbx $r2r3 = $r0r1r2r3.hi 	#Opcode-lvx_v2-ABSSBX_registerM_registerP_simple
	;;
	abssdp $r4r5 = $r4r5r6r7.lo 	#Opcode-lvx_v2-ABSSDP_registerM_registerP_simple
	;;
	abssd $r8r9r10r11.z = $r11 	#Opcode-lvx_v2-ABSSD_registerW_registerZ_simple
	;;
	abssho $r6r7 = $r4r5r6r7.hi 	#Opcode-lvx_v2-ABSSHO_registerM_registerP_simple
	;;
	absswq $r8r9 = $r8r9r10r11.lo 	#Opcode-lvx_v2-ABSSWQ_registerM_registerP_simple
	;;
	abssw $r10r11.hi = $r8r9r10r11.t 	#Opcode-lvx_v2-ABSSW_registerW_registerZ_simple
	;;
	abswq $r10r11 = $r8r9r10r11.hi 	#Opcode-lvx_v2-ABSWQ_registerM_registerP_simple
	;;
	absw $r12 = $sp 	#Opcode-lvx_v2-ABSW_registerW_registerZ_simple
	;;
	acswapb.v $r13, -1125899906842624[$tp] = $r12r13 	#Opcode-lvx_v2-ACSWAPB_boolcas_coherency_registerW_extend27_offset27_registerZ_registerO_triple
	;;
	acswapb.g $r14, -8388608[$fp] = $r12r13r14r15.lo 	#Opcode-lvx_v2-ACSWAPB_boolcas_coherency_registerW_offset27_registerZ_registerO_double
	;;
	acswapb.v.s $r14r15.lo, [$r15] = $r14r15 	#Opcode-lvx_v2-ACSWAPB_boolcas_coherency_registerW_registerZ_registerO_simple
	;;
	acswapd $rp, -1125899906842624[$r14r15.hi] = $r12r13r14r15.hi 	#Opcode-lvx_v2-ACSWAPD_boolcas_coherency_registerW_extend27_offset27_registerZ_registerO_triple
	;;
	acswapd.v.g $r16, -8388608[$r16r17.lo] = $r16r17 	#Opcode-lvx_v2-ACSWAPD_boolcas_coherency_registerW_offset27_registerZ_registerO_double
	;;
	acswapd.s $r16r17r18r19.x, [$r17] = $r16r17r18r19.lo 	#Opcode-lvx_v2-ACSWAPD_boolcas_coherency_registerW_registerZ_registerO_simple
	;;
	acswaph.v $r16r17.hi, -1125899906842624[$r16r17r18r19.y] = $r18r19 	#Opcode-lvx_v2-ACSWAPH_boolcas_coherency_registerW_extend27_offset27_registerZ_registerO_triple
	;;
	acswaph.g $r18, -8388608[$r18r19.lo] = $r16r17r18r19.hi 	#Opcode-lvx_v2-ACSWAPH_boolcas_coherency_registerW_offset27_registerZ_registerO_double
	;;
	acswaph.v.s $r16r17r18r19.z, [$r19] = $r20r21 	#Opcode-lvx_v2-ACSWAPH_boolcas_coherency_registerW_registerZ_registerO_simple
	;;
	acswapq $r20r21r22r23.lo, -1125899906842624[$r18r19.hi] = $r0r1r2r3 	#Opcode-lvx_v2-ACSWAPQ_boolcas_coherency_registerM_extend27_offset27_registerZ_registerQ_triple
	;;
	acswapq.v.g $r22r23, -8388608[$r16r17r18r19.t] = $r4r5r6r7 	#Opcode-lvx_v2-ACSWAPQ_boolcas_coherency_registerM_offset27_registerZ_registerQ_double
	;;
	acswapq.s $r20r21r22r23.hi, [$r20] = $r8r9r10r11 	#Opcode-lvx_v2-ACSWAPQ_boolcas_coherency_registerM_registerZ_registerQ_simple
	;;
	acswapw.v $r20r21.lo, -1125899906842624[$r20r21r22r23.x] = $r24r25 	#Opcode-lvx_v2-ACSWAPW_boolcas_coherency_registerW_extend27_offset27_registerZ_registerO_triple
	;;
	acswapw.g $r21, -8388608[$r20r21.hi] = $r24r25r26r27.lo 	#Opcode-lvx_v2-ACSWAPW_boolcas_coherency_registerW_offset27_registerZ_registerO_double
	;;
	acswapw.v.s $r20r21r22r23.y, [$r22] = $r26r27 	#Opcode-lvx_v2-ACSWAPW_boolcas_coherency_registerW_registerZ_registerO_simple
	;;
	addbx $r24r25r26r27.hi = $r28r29, $r28r29r30r31.lo 	#Opcode-lvx_v2-ADDBX_registerM_registerP_registerO_simple
	;;
	addbx $r30r31 = $r28r29r30r31.hi, 536870911.@ 	#Opcode-lvx_v2-ADDBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	adddp $r32r33 = $r32r33r34r35.lo, $r34r35 	#Opcode-lvx_v2-ADDDP_registerM_registerP_registerO_simple
	;;
	adddp $r32r33r34r35.hi = $r36r37, 536870911 	#Opcode-lvx_v2-ADDDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	addd $r22r23.lo = $r20r21r22r23.z, 2305843009213693951 	#Opcode-lvx_v2-ADDD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	addd $r23 = $r22r23.hi, $r20r21r22r23.t 	#Opcode-lvx_v2-ADDD_registerW_registerZ_registerY_simple
	;;
	addd $r24 = $r24r25.lo, -64 	#Opcode-lvx_v2-ADDD_registerW_registerZ_signed10_simple
	;;
	addd $r24r25r26r27.x = $r25, -8589934592 	#Opcode-lvx_v2-ADDD_registerW_registerZ_upper27_lower10_double
	;;
	addho $r36r37r38r39.lo = $r38r39, $r36r37r38r39.hi 	#Opcode-lvx_v2-ADDHO_registerM_registerP_registerO_simple
	;;
	addho $r40r41 = $r40r41r42r43.lo, 536870911.@ 	#Opcode-lvx_v2-ADDHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	addq $r42r43 = $r40r41r42r43.hi, $r44r45 	#Opcode-lvx_v2-ADDQ_registerM_registerP_registerO_simple
	;;
	addq $r44r45r46r47.lo = $r46r47, 536870911 	#Opcode-lvx_v2-ADDQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	addsbx $r44r45r46r47.hi = $r48r49, $r48r49r50r51.lo 	#Opcode-lvx_v2-ADDSBX_registerM_registerP_registerO_simple
	;;
	addsbx $r50r51 = $r48r49r50r51.hi, 536870911.@ 	#Opcode-lvx_v2-ADDSBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	addsdp $r52r53 = $r52r53r54r55.lo, $r54r55 	#Opcode-lvx_v2-ADDSDP_registerM_registerP_registerO_simple
	;;
	addsdp $r52r53r54r55.hi = $r56r57, 536870911 	#Opcode-lvx_v2-ADDSDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	addsd $r24r25.hi = $r24r25r26r27.y, $r26 	#Opcode-lvx_v2-ADDSD_registerW_registerZ_registerY_simple
	;;
	addsd $r26r27.lo = $r24r25r26r27.z, 536870911.@ 	#Opcode-lvx_v2-ADDSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addsho $r56r57r58r59.lo = $r58r59, $r56r57r58r59.hi 	#Opcode-lvx_v2-ADDSHO_registerM_registerP_registerO_simple
	;;
	addsho $r60r61 = $r60r61r62r63.lo, 536870911 	#Opcode-lvx_v2-ADDSHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	addswq $r62r63 = $r60r61r62r63.hi, $r0r1 	#Opcode-lvx_v2-ADDSWQ_registerM_registerP_registerO_simple
	;;
	addswq $r0r1r2r3.lo = $r2r3, 536870911.@ 	#Opcode-lvx_v2-ADDSWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	addsw $r27 = $r26r27.hi, $r24r25r26r27.t 	#Opcode-lvx_v2-ADDSW_signextw_registerW_registerZ_registerY_simple
	;;
	addsw.sx $r28 = $r28r29.lo, 536870911 	#Opcode-lvx_v2-ADDSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addusbx $r0r1r2r3.hi = $r4r5, $r4r5r6r7.lo 	#Opcode-lvx_v2-ADDUSBX_registerM_registerP_registerO_simple
	;;
	addusbx $r6r7 = $r4r5r6r7.hi, 536870911 	#Opcode-lvx_v2-ADDUSBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	addusdp $r8r9 = $r8r9r10r11.lo, $r10r11 	#Opcode-lvx_v2-ADDUSDP_registerM_registerP_registerO_simple
	;;
	addusdp $r8r9r10r11.hi = $r12r13, 536870911.@ 	#Opcode-lvx_v2-ADDUSDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	addusd $r28r29r30r31.x = $r29, $r28r29.hi 	#Opcode-lvx_v2-ADDUSD_registerW_registerZ_registerY_simple
	;;
	addusd $r28r29r30r31.y = $r30, 536870911 	#Opcode-lvx_v2-ADDUSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addusho $r12r13r14r15.lo = $r14r15, $r12r13r14r15.hi 	#Opcode-lvx_v2-ADDUSHO_registerM_registerP_registerO_simple
	;;
	addusho $r16r17 = $r16r17r18r19.lo, 536870911.@ 	#Opcode-lvx_v2-ADDUSHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	adduswq $r18r19 = $r16r17r18r19.hi, $r20r21 	#Opcode-lvx_v2-ADDUSWQ_registerM_registerP_registerO_simple
	;;
	adduswq $r20r21r22r23.lo = $r22r23, 536870911 	#Opcode-lvx_v2-ADDUSWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	addusw $r30r31.lo = $r28r29r30r31.z, $r31 	#Opcode-lvx_v2-ADDUSW_signextw_registerW_registerZ_registerY_simple
	;;
	addusw.sx $r30r31.hi = $r28r29r30r31.t, 536870911 	#Opcode-lvx_v2-ADDUSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addwq $r20r21r22r23.hi = $r24r25, $r24r25r26r27.lo 	#Opcode-lvx_v2-ADDWQ_registerM_registerP_registerO_simple
	;;
	addwq $r26r27 = $r24r25r26r27.hi, 536870911.@ 	#Opcode-lvx_v2-ADDWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	addw $r32 = $r32r33.lo, $r32r33r34r35.x 	#Opcode-lvx_v2-ADDW_signextw_registerW_registerZ_registerY_simple
	;;
	addw.sx $r33 = $r32r33.hi, 536870911 	#Opcode-lvx_v2-ADDW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addx16bx $r28r29 = $r28r29r30r31.lo, $r30r31 	#Opcode-lvx_v2-ADDX16BX_registerM_registerP_registerO_simple
	;;
	addx16bx $r28r29r30r31.hi = $r32r33, 536870911 	#Opcode-lvx_v2-ADDX16BX_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx16dp $r32r33r34r35.lo = $r34r35, $r32r33r34r35.hi 	#Opcode-lvx_v2-ADDX16DP_registerM_registerP_registerO_simple
	;;
	addx16dp $r36r37 = $r36r37r38r39.lo, 536870911.@ 	#Opcode-lvx_v2-ADDX16DP_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx16d $r32r33r34r35.y = $r34, $r34r35.lo 	#Opcode-lvx_v2-ADDX16D_registerW_registerZ_registerY_simple
	;;
	addx16d $r32r33r34r35.z = $r35, 536870911 	#Opcode-lvx_v2-ADDX16D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx16ho $r38r39 = $r36r37r38r39.hi, $r40r41 	#Opcode-lvx_v2-ADDX16HO_registerM_registerP_registerO_simple
	;;
	addx16ho $r40r41r42r43.lo = $r42r43, 536870911.@ 	#Opcode-lvx_v2-ADDX16HO_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx16wq $r40r41r42r43.hi = $r44r45, $r44r45r46r47.lo 	#Opcode-lvx_v2-ADDX16WQ_registerM_registerP_registerO_simple
	;;
	addx16wq $r46r47 = $r44r45r46r47.hi, 536870911 	#Opcode-lvx_v2-ADDX16WQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx16w $r34r35.hi = $r32r33r34r35.t, $r36 	#Opcode-lvx_v2-ADDX16W_signextw_registerW_registerZ_registerY_simple
	;;
	addx16w.sx $r36r37.lo = $r36r37r38r39.x, 536870911 	#Opcode-lvx_v2-ADDX16W_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addx2bx $r48r49 = $r48r49r50r51.lo, $r50r51 	#Opcode-lvx_v2-ADDX2BX_registerM_registerP_registerO_simple
	;;
	addx2bx $r48r49r50r51.hi = $r52r53, 536870911.@ 	#Opcode-lvx_v2-ADDX2BX_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx2dp $r52r53r54r55.lo = $r54r55, $r52r53r54r55.hi 	#Opcode-lvx_v2-ADDX2DP_registerM_registerP_registerO_simple
	;;
	addx2dp $r56r57 = $r56r57r58r59.lo, 536870911 	#Opcode-lvx_v2-ADDX2DP_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx2d $r37 = $r36r37.hi, $r36r37r38r39.y 	#Opcode-lvx_v2-ADDX2D_registerW_registerZ_registerY_simple
	;;
	addx2d $r38 = $r38r39.lo, 536870911.@ 	#Opcode-lvx_v2-ADDX2D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx2ho $r58r59 = $r56r57r58r59.hi, $r60r61 	#Opcode-lvx_v2-ADDX2HO_registerM_registerP_registerO_simple
	;;
	addx2ho $r60r61r62r63.lo = $r62r63, 536870911 	#Opcode-lvx_v2-ADDX2HO_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx2wq $r60r61r62r63.hi = $r0r1, $r0r1r2r3.lo 	#Opcode-lvx_v2-ADDX2WQ_registerM_registerP_registerO_simple
	;;
	addx2wq $r2r3 = $r0r1r2r3.hi, 536870911.@ 	#Opcode-lvx_v2-ADDX2WQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx2w $r36r37r38r39.z = $r39, $r38r39.hi 	#Opcode-lvx_v2-ADDX2W_signextw_registerW_registerZ_registerY_simple
	;;
	addx2w.sx $r36r37r38r39.t = $r40, 536870911 	#Opcode-lvx_v2-ADDX2W_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addx32d $r40r41.lo = $r40r41r42r43.x, $r41 	#Opcode-lvx_v2-ADDX32D_registerW_registerZ_registerY_simple
	;;
	addx32d $r40r41.hi = $r40r41r42r43.y, 536870911 	#Opcode-lvx_v2-ADDX32D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx32w $r42 = $r42r43.lo, $r40r41r42r43.z 	#Opcode-lvx_v2-ADDX32W_signextw_registerW_registerZ_registerY_simple
	;;
	addx32w.sx $r43 = $r42r43.hi, 536870911 	#Opcode-lvx_v2-ADDX32W_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addx4bx $r4r5 = $r4r5r6r7.lo, $r6r7 	#Opcode-lvx_v2-ADDX4BX_registerM_registerP_registerO_simple
	;;
	addx4bx $r4r5r6r7.hi = $r8r9, 536870911.@ 	#Opcode-lvx_v2-ADDX4BX_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx4dp $r8r9r10r11.lo = $r10r11, $r8r9r10r11.hi 	#Opcode-lvx_v2-ADDX4DP_registerM_registerP_registerO_simple
	;;
	addx4dp $r12r13 = $r12r13r14r15.lo, 536870911 	#Opcode-lvx_v2-ADDX4DP_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx4d $r40r41r42r43.t = $r44, $r44r45.lo 	#Opcode-lvx_v2-ADDX4D_registerW_registerZ_registerY_simple
	;;
	addx4d $r44r45r46r47.x = $r45, 536870911.@ 	#Opcode-lvx_v2-ADDX4D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx4ho $r14r15 = $r12r13r14r15.hi, $r16r17 	#Opcode-lvx_v2-ADDX4HO_registerM_registerP_registerO_simple
	;;
	addx4ho $r16r17r18r19.lo = $r18r19, 536870911 	#Opcode-lvx_v2-ADDX4HO_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx4wq $r16r17r18r19.hi = $r20r21, $r20r21r22r23.lo 	#Opcode-lvx_v2-ADDX4WQ_registerM_registerP_registerO_simple
	;;
	addx4wq $r22r23 = $r20r21r22r23.hi, 536870911.@ 	#Opcode-lvx_v2-ADDX4WQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx4w $r44r45.hi = $r44r45r46r47.y, $r46 	#Opcode-lvx_v2-ADDX4W_signextw_registerW_registerZ_registerY_simple
	;;
	addx4w.sx $r46r47.lo = $r44r45r46r47.z, 536870911 	#Opcode-lvx_v2-ADDX4W_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addx64d $r47 = $r46r47.hi, $r44r45r46r47.t 	#Opcode-lvx_v2-ADDX64D_registerW_registerZ_registerY_simple
	;;
	addx64d $r48 = $r48r49.lo, 536870911 	#Opcode-lvx_v2-ADDX64D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx64w $r48r49r50r51.x = $r49, $r48r49.hi 	#Opcode-lvx_v2-ADDX64W_signextw_registerW_registerZ_registerY_simple
	;;
	addx64w.sx $r48r49r50r51.y = $r50, 536870911 	#Opcode-lvx_v2-ADDX64W_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addx8bx $r24r25 = $r24r25r26r27.lo, $r26r27 	#Opcode-lvx_v2-ADDX8BX_registerM_registerP_registerO_simple
	;;
	addx8bx $r24r25r26r27.hi = $r28r29, 536870911.@ 	#Opcode-lvx_v2-ADDX8BX_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx8dp $r28r29r30r31.lo = $r30r31, $r28r29r30r31.hi 	#Opcode-lvx_v2-ADDX8DP_registerM_registerP_registerO_simple
	;;
	addx8dp $r32r33 = $r32r33r34r35.lo, 536870911 	#Opcode-lvx_v2-ADDX8DP_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx8d $r50r51.lo = $r48r49r50r51.z, $r51 	#Opcode-lvx_v2-ADDX8D_registerW_registerZ_registerY_simple
	;;
	addx8d $r50r51.hi = $r48r49r50r51.t, 536870911.@ 	#Opcode-lvx_v2-ADDX8D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx8ho $r34r35 = $r32r33r34r35.hi, $r36r37 	#Opcode-lvx_v2-ADDX8HO_registerM_registerP_registerO_simple
	;;
	addx8ho $r36r37r38r39.lo = $r38r39, 536870911 	#Opcode-lvx_v2-ADDX8HO_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx8wq $r36r37r38r39.hi = $r40r41, $r40r41r42r43.lo 	#Opcode-lvx_v2-ADDX8WQ_registerM_registerP_registerO_simple
	;;
	addx8wq $r42r43 = $r40r41r42r43.hi, 536870911.@ 	#Opcode-lvx_v2-ADDX8WQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	addx8w $r52 = $r52r53.lo, $r52r53r54r55.x 	#Opcode-lvx_v2-ADDX8W_signextw_registerW_registerZ_registerY_simple
	;;
	addx8w.sx $r53 = $r52r53.hi, 536870911 	#Opcode-lvx_v2-ADDX8W_signextw_registerW_registerZ_upper27_lower5_double
	;;
	aladdb -1125899906842624[$r52r53r54r55.y] = $r54 	#Opcode-lvx_v2-ALADDB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aladdb.g -8388608[$r54r55.lo] = $r52r53r54r55.z 	#Opcode-lvx_v2-ALADDB_coherency_offset27_registerZ_registerT_double
	;;
	aladdb.s [$r55] = $r54r55.hi 	#Opcode-lvx_v2-ALADDB_coherency_registerZ_registerT_simple
	;;
	aladdd -1125899906842624[$r52r53r54r55.t] = $r56 	#Opcode-lvx_v2-ALADDD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aladdd.g -8388608[$r56r57.lo] = $r56r57r58r59.x 	#Opcode-lvx_v2-ALADDD_coherency_offset27_registerZ_registerT_double
	;;
	aladdd.s [$r57] = $r56r57.hi 	#Opcode-lvx_v2-ALADDD_coherency_registerZ_registerT_simple
	;;
	aladdh -1125899906842624[$r56r57r58r59.y] = $r58 	#Opcode-lvx_v2-ALADDH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aladdh.g -8388608[$r58r59.lo] = $r56r57r58r59.z 	#Opcode-lvx_v2-ALADDH_coherency_offset27_registerZ_registerT_double
	;;
	aladdh.s [$r59] = $r58r59.hi 	#Opcode-lvx_v2-ALADDH_coherency_registerZ_registerT_simple
	;;
	aladdw -1125899906842624[$r56r57r58r59.t] = $r60 	#Opcode-lvx_v2-ALADDW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aladdw.g -8388608[$r60r61.lo] = $r60r61r62r63.x 	#Opcode-lvx_v2-ALADDW_coherency_offset27_registerZ_registerT_double
	;;
	aladdw.s [$r61] = $r60r61.hi 	#Opcode-lvx_v2-ALADDW_coherency_registerZ_registerT_simple
	;;
	alandb -1125899906842624[$r60r61r62r63.y] = $r62 	#Opcode-lvx_v2-ALANDB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alandb.g -8388608[$r62r63.lo] = $r60r61r62r63.z 	#Opcode-lvx_v2-ALANDB_coherency_offset27_registerZ_registerT_double
	;;
	alandb.s [$r63] = $r62r63.hi 	#Opcode-lvx_v2-ALANDB_coherency_registerZ_registerT_simple
	;;
	alandd -1125899906842624[$r60r61r62r63.t] = $r0 	#Opcode-lvx_v2-ALANDD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alandd.g -8388608[$r0r1.lo] = $r0r1r2r3.x 	#Opcode-lvx_v2-ALANDD_coherency_offset27_registerZ_registerT_double
	;;
	alandd.s [$r1] = $r0r1.hi 	#Opcode-lvx_v2-ALANDD_coherency_registerZ_registerT_simple
	;;
	alandh -1125899906842624[$r0r1r2r3.y] = $r2 	#Opcode-lvx_v2-ALANDH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alandh.g -8388608[$r2r3.lo] = $r0r1r2r3.z 	#Opcode-lvx_v2-ALANDH_coherency_offset27_registerZ_registerT_double
	;;
	alandh.s [$r3] = $r2r3.hi 	#Opcode-lvx_v2-ALANDH_coherency_registerZ_registerT_simple
	;;
	alandw -1125899906842624[$r0r1r2r3.t] = $r4 	#Opcode-lvx_v2-ALANDW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alandw.g -8388608[$r4r5.lo] = $r4r5r6r7.x 	#Opcode-lvx_v2-ALANDW_coherency_offset27_registerZ_registerT_double
	;;
	alandw.s [$r5] = $r4r5.hi 	#Opcode-lvx_v2-ALANDW_coherency_registerZ_registerT_simple
	;;
	alb $r4r5r6r7.y = -1125899906842624[$r6] 	#Opcode-lvx_v2-ALB_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	alb.g $r6r7.lo = -8388608[$r4r5r6r7.z] 	#Opcode-lvx_v2-ALB_coherency_registerW_offset27_registerZ_double
	;;
	alb.s $r7 = [$r6r7.hi] 	#Opcode-lvx_v2-ALB_coherency_registerW_registerZ_simple
	;;
	alclrb $r4r5r6r7.t = -1125899906842624[$r8] 	#Opcode-lvx_v2-ALCLRB_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	alclrb.g $r8r9.lo = -8388608[$r8r9r10r11.x] 	#Opcode-lvx_v2-ALCLRB_coherency_registerW_offset27_registerZ_double
	;;
	alclrb.s $r9 = [$r8r9.hi] 	#Opcode-lvx_v2-ALCLRB_coherency_registerW_registerZ_simple
	;;
	alclrd $r8r9r10r11.y = -1125899906842624[$r10] 	#Opcode-lvx_v2-ALCLRD_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	alclrd.g $r10r11.lo = -8388608[$r8r9r10r11.z] 	#Opcode-lvx_v2-ALCLRD_coherency_registerW_offset27_registerZ_double
	;;
	alclrd.s $r11 = [$r10r11.hi] 	#Opcode-lvx_v2-ALCLRD_coherency_registerW_registerZ_simple
	;;
	alclrh $r8r9r10r11.t = -1125899906842624[$r12] 	#Opcode-lvx_v2-ALCLRH_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	alclrh.g $sp = -8388608[$r13] 	#Opcode-lvx_v2-ALCLRH_coherency_registerW_offset27_registerZ_double
	;;
	alclrh.s $tp = [$r14] 	#Opcode-lvx_v2-ALCLRH_coherency_registerW_registerZ_simple
	;;
	alclrw $fp = -1125899906842624[$r14r15.lo] 	#Opcode-lvx_v2-ALCLRW_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	alclrw.g $r15 = -8388608[$rp] 	#Opcode-lvx_v2-ALCLRW_coherency_registerW_offset27_registerZ_double
	;;
	alclrw.s $r14r15.hi = [$r16] 	#Opcode-lvx_v2-ALCLRW_coherency_registerW_registerZ_simple
	;;
	aldusb -1125899906842624[$r16r17.lo] = $r16r17r18r19.x 	#Opcode-lvx_v2-ALDUSB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aldusb.g -8388608[$r17] = $r16r17.hi 	#Opcode-lvx_v2-ALDUSB_coherency_offset27_registerZ_registerT_double
	;;
	aldusb.s [$r16r17r18r19.y] = $r18 	#Opcode-lvx_v2-ALDUSB_coherency_registerZ_registerT_simple
	;;
	aldusd -1125899906842624[$r18r19.lo] = $r16r17r18r19.z 	#Opcode-lvx_v2-ALDUSD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aldusd.g -8388608[$r19] = $r18r19.hi 	#Opcode-lvx_v2-ALDUSD_coherency_offset27_registerZ_registerT_double
	;;
	aldusd.s [$r16r17r18r19.t] = $r20 	#Opcode-lvx_v2-ALDUSD_coherency_registerZ_registerT_simple
	;;
	aldush -1125899906842624[$r20r21.lo] = $r20r21r22r23.x 	#Opcode-lvx_v2-ALDUSH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aldush.g -8388608[$r21] = $r20r21.hi 	#Opcode-lvx_v2-ALDUSH_coherency_offset27_registerZ_registerT_double
	;;
	aldush.s [$r20r21r22r23.y] = $r22 	#Opcode-lvx_v2-ALDUSH_coherency_registerZ_registerT_simple
	;;
	aldusw -1125899906842624[$r22r23.lo] = $r20r21r22r23.z 	#Opcode-lvx_v2-ALDUSW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aldusw.g -8388608[$r23] = $r22r23.hi 	#Opcode-lvx_v2-ALDUSW_coherency_offset27_registerZ_registerT_double
	;;
	aldusw.s [$r20r21r22r23.t] = $r24 	#Opcode-lvx_v2-ALDUSW_coherency_registerZ_registerT_simple
	;;
	ald $r24r25.lo = -1125899906842624[$r24r25r26r27.x] 	#Opcode-lvx_v2-ALD_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	ald.g $r25 = -8388608[$r24r25.hi] 	#Opcode-lvx_v2-ALD_coherency_registerW_offset27_registerZ_double
	;;
	ald.s $r24r25r26r27.y = [$r26] 	#Opcode-lvx_v2-ALD_coherency_registerW_registerZ_simple
	;;
	aleorb -1125899906842624[$r26r27.lo] = $r24r25r26r27.z 	#Opcode-lvx_v2-ALEORB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aleorb.g -8388608[$r27] = $r26r27.hi 	#Opcode-lvx_v2-ALEORB_coherency_offset27_registerZ_registerT_double
	;;
	aleorb.s [$r24r25r26r27.t] = $r28 	#Opcode-lvx_v2-ALEORB_coherency_registerZ_registerT_simple
	;;
	aleord -1125899906842624[$r28r29.lo] = $r28r29r30r31.x 	#Opcode-lvx_v2-ALEORD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aleord.g -8388608[$r29] = $r28r29.hi 	#Opcode-lvx_v2-ALEORD_coherency_offset27_registerZ_registerT_double
	;;
	aleord.s [$r28r29r30r31.y] = $r30 	#Opcode-lvx_v2-ALEORD_coherency_registerZ_registerT_simple
	;;
	aleorh -1125899906842624[$r30r31.lo] = $r28r29r30r31.z 	#Opcode-lvx_v2-ALEORH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aleorh.g -8388608[$r31] = $r30r31.hi 	#Opcode-lvx_v2-ALEORH_coherency_offset27_registerZ_registerT_double
	;;
	aleorh.s [$r28r29r30r31.t] = $r32 	#Opcode-lvx_v2-ALEORH_coherency_registerZ_registerT_simple
	;;
	aleorw -1125899906842624[$r32r33.lo] = $r32r33r34r35.x 	#Opcode-lvx_v2-ALEORW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aleorw.g -8388608[$r33] = $r32r33.hi 	#Opcode-lvx_v2-ALEORW_coherency_offset27_registerZ_registerT_double
	;;
	aleorw.s [$r32r33r34r35.y] = $r34 	#Opcode-lvx_v2-ALEORW_coherency_registerZ_registerT_simple
	;;
	alh $r34r35.lo = -1125899906842624[$r32r33r34r35.z] 	#Opcode-lvx_v2-ALH_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	alh.g $r35 = -8388608[$r34r35.hi] 	#Opcode-lvx_v2-ALH_coherency_registerW_offset27_registerZ_double
	;;
	alh.s $r32r33r34r35.t = [$r36] 	#Opcode-lvx_v2-ALH_coherency_registerW_registerZ_simple
	;;
	aliorb -1125899906842624[$r36r37.lo] = $r36r37r38r39.x 	#Opcode-lvx_v2-ALIORB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aliorb.g -8388608[$r37] = $r36r37.hi 	#Opcode-lvx_v2-ALIORB_coherency_offset27_registerZ_registerT_double
	;;
	aliorb.s [$r36r37r38r39.y] = $r38 	#Opcode-lvx_v2-ALIORB_coherency_registerZ_registerT_simple
	;;
	aliord -1125899906842624[$r38r39.lo] = $r36r37r38r39.z 	#Opcode-lvx_v2-ALIORD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aliord.g -8388608[$r39] = $r38r39.hi 	#Opcode-lvx_v2-ALIORD_coherency_offset27_registerZ_registerT_double
	;;
	aliord.s [$r36r37r38r39.t] = $r40 	#Opcode-lvx_v2-ALIORD_coherency_registerZ_registerT_simple
	;;
	aliorh -1125899906842624[$r40r41.lo] = $r40r41r42r43.x 	#Opcode-lvx_v2-ALIORH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aliorh.g -8388608[$r41] = $r40r41.hi 	#Opcode-lvx_v2-ALIORH_coherency_offset27_registerZ_registerT_double
	;;
	aliorh.s [$r40r41r42r43.y] = $r42 	#Opcode-lvx_v2-ALIORH_coherency_registerZ_registerT_simple
	;;
	aliorw -1125899906842624[$r42r43.lo] = $r40r41r42r43.z 	#Opcode-lvx_v2-ALIORW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aliorw.g -8388608[$r43] = $r42r43.hi 	#Opcode-lvx_v2-ALIORW_coherency_offset27_registerZ_registerT_double
	;;
	aliorw.s [$r40r41r42r43.t] = $r44 	#Opcode-lvx_v2-ALIORW_coherency_registerZ_registerT_simple
	;;
	almaxb -1125899906842624[$r44r45.lo] = $r44r45r46r47.x 	#Opcode-lvx_v2-ALMAXB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxb.g -8388608[$r45] = $r44r45.hi 	#Opcode-lvx_v2-ALMAXB_coherency_offset27_registerZ_registerT_double
	;;
	almaxb.s [$r44r45r46r47.y] = $r46 	#Opcode-lvx_v2-ALMAXB_coherency_registerZ_registerT_simple
	;;
	almaxd -1125899906842624[$r46r47.lo] = $r44r45r46r47.z 	#Opcode-lvx_v2-ALMAXD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxd.g -8388608[$r47] = $r46r47.hi 	#Opcode-lvx_v2-ALMAXD_coherency_offset27_registerZ_registerT_double
	;;
	almaxd.s [$r44r45r46r47.t] = $r48 	#Opcode-lvx_v2-ALMAXD_coherency_registerZ_registerT_simple
	;;
	almaxh -1125899906842624[$r48r49.lo] = $r48r49r50r51.x 	#Opcode-lvx_v2-ALMAXH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxh.g -8388608[$r49] = $r48r49.hi 	#Opcode-lvx_v2-ALMAXH_coherency_offset27_registerZ_registerT_double
	;;
	almaxh.s [$r48r49r50r51.y] = $r50 	#Opcode-lvx_v2-ALMAXH_coherency_registerZ_registerT_simple
	;;
	almaxub -1125899906842624[$r50r51.lo] = $r48r49r50r51.z 	#Opcode-lvx_v2-ALMAXUB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxub.g -8388608[$r51] = $r50r51.hi 	#Opcode-lvx_v2-ALMAXUB_coherency_offset27_registerZ_registerT_double
	;;
	almaxub.s [$r48r49r50r51.t] = $r52 	#Opcode-lvx_v2-ALMAXUB_coherency_registerZ_registerT_simple
	;;
	almaxud -1125899906842624[$r52r53.lo] = $r52r53r54r55.x 	#Opcode-lvx_v2-ALMAXUD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxud.g -8388608[$r53] = $r52r53.hi 	#Opcode-lvx_v2-ALMAXUD_coherency_offset27_registerZ_registerT_double
	;;
	almaxud.s [$r52r53r54r55.y] = $r54 	#Opcode-lvx_v2-ALMAXUD_coherency_registerZ_registerT_simple
	;;
	almaxuh -1125899906842624[$r54r55.lo] = $r52r53r54r55.z 	#Opcode-lvx_v2-ALMAXUH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxuh.g -8388608[$r55] = $r54r55.hi 	#Opcode-lvx_v2-ALMAXUH_coherency_offset27_registerZ_registerT_double
	;;
	almaxuh.s [$r52r53r54r55.t] = $r56 	#Opcode-lvx_v2-ALMAXUH_coherency_registerZ_registerT_simple
	;;
	almaxuw -1125899906842624[$r56r57.lo] = $r56r57r58r59.x 	#Opcode-lvx_v2-ALMAXUW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxuw.g -8388608[$r57] = $r56r57.hi 	#Opcode-lvx_v2-ALMAXUW_coherency_offset27_registerZ_registerT_double
	;;
	almaxuw.s [$r56r57r58r59.y] = $r58 	#Opcode-lvx_v2-ALMAXUW_coherency_registerZ_registerT_simple
	;;
	almaxw -1125899906842624[$r58r59.lo] = $r56r57r58r59.z 	#Opcode-lvx_v2-ALMAXW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almaxw.g -8388608[$r59] = $r58r59.hi 	#Opcode-lvx_v2-ALMAXW_coherency_offset27_registerZ_registerT_double
	;;
	almaxw.s [$r56r57r58r59.t] = $r60 	#Opcode-lvx_v2-ALMAXW_coherency_registerZ_registerT_simple
	;;
	alminb -1125899906842624[$r60r61.lo] = $r60r61r62r63.x 	#Opcode-lvx_v2-ALMINB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alminb.g -8388608[$r61] = $r60r61.hi 	#Opcode-lvx_v2-ALMINB_coherency_offset27_registerZ_registerT_double
	;;
	alminb.s [$r60r61r62r63.y] = $r62 	#Opcode-lvx_v2-ALMINB_coherency_registerZ_registerT_simple
	;;
	almind -1125899906842624[$r62r63.lo] = $r60r61r62r63.z 	#Opcode-lvx_v2-ALMIND_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	almind.g -8388608[$r63] = $r62r63.hi 	#Opcode-lvx_v2-ALMIND_coherency_offset27_registerZ_registerT_double
	;;
	almind.s [$r60r61r62r63.t] = $r0 	#Opcode-lvx_v2-ALMIND_coherency_registerZ_registerT_simple
	;;
	alminh -1125899906842624[$r0r1.lo] = $r0r1r2r3.x 	#Opcode-lvx_v2-ALMINH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alminh.g -8388608[$r1] = $r0r1.hi 	#Opcode-lvx_v2-ALMINH_coherency_offset27_registerZ_registerT_double
	;;
	alminh.s [$r0r1r2r3.y] = $r2 	#Opcode-lvx_v2-ALMINH_coherency_registerZ_registerT_simple
	;;
	alminub -1125899906842624[$r2r3.lo] = $r0r1r2r3.z 	#Opcode-lvx_v2-ALMINUB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alminub.g -8388608[$r3] = $r2r3.hi 	#Opcode-lvx_v2-ALMINUB_coherency_offset27_registerZ_registerT_double
	;;
	alminub.s [$r0r1r2r3.t] = $r4 	#Opcode-lvx_v2-ALMINUB_coherency_registerZ_registerT_simple
	;;
	alminud -1125899906842624[$r4r5.lo] = $r4r5r6r7.x 	#Opcode-lvx_v2-ALMINUD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alminud.g -8388608[$r5] = $r4r5.hi 	#Opcode-lvx_v2-ALMINUD_coherency_offset27_registerZ_registerT_double
	;;
	alminud.s [$r4r5r6r7.y] = $r6 	#Opcode-lvx_v2-ALMINUD_coherency_registerZ_registerT_simple
	;;
	alminuh -1125899906842624[$r6r7.lo] = $r4r5r6r7.z 	#Opcode-lvx_v2-ALMINUH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alminuh.g -8388608[$r7] = $r6r7.hi 	#Opcode-lvx_v2-ALMINUH_coherency_offset27_registerZ_registerT_double
	;;
	alminuh.s [$r4r5r6r7.t] = $r8 	#Opcode-lvx_v2-ALMINUH_coherency_registerZ_registerT_simple
	;;
	alminuw -1125899906842624[$r8r9.lo] = $r8r9r10r11.x 	#Opcode-lvx_v2-ALMINUW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alminuw.g -8388608[$r9] = $r8r9.hi 	#Opcode-lvx_v2-ALMINUW_coherency_offset27_registerZ_registerT_double
	;;
	alminuw.s [$r8r9r10r11.y] = $r10 	#Opcode-lvx_v2-ALMINUW_coherency_registerZ_registerT_simple
	;;
	alminw -1125899906842624[$r10r11.lo] = $r8r9r10r11.z 	#Opcode-lvx_v2-ALMINW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	alminw.g -8388608[$r11] = $r10r11.hi 	#Opcode-lvx_v2-ALMINW_coherency_offset27_registerZ_registerT_double
	;;
	alminw.s [$r8r9r10r11.t] = $r12 	#Opcode-lvx_v2-ALMINW_coherency_registerZ_registerT_simple
	;;
	alw $sp = -1125899906842624[$r13] 	#Opcode-lvx_v2-ALW_coherency_registerW_extend27_offset27_registerZ_triple
	;;
	alw.g $tp = -8388608[$r14] 	#Opcode-lvx_v2-ALW_coherency_registerW_offset27_registerZ_double
	;;
	alw.s $fp = [$r14r15.lo] 	#Opcode-lvx_v2-ALW_coherency_registerW_registerZ_simple
	;;
	andd $r15 = $rp, 2305843009213693951 	#Opcode-lvx_v2-ANDD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	andd $r14r15.hi = $r16, $r16r17.lo 	#Opcode-lvx_v2-ANDD_registerW_registerZ_registerY_simple
	;;
	andd $r16r17r18r19.x = $r17, -64 	#Opcode-lvx_v2-ANDD_registerW_registerZ_signed10_simple
	;;
	andd $r16r17.hi = $r16r17r18r19.y, -8589934592 	#Opcode-lvx_v2-ANDD_registerW_registerZ_upper27_lower10_double
	;;
	andnd $r18 = $r18r19.lo, 2305843009213693951 	#Opcode-lvx_v2-ANDND_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	andnd $r16r17r18r19.z = $r19, $r18r19.hi 	#Opcode-lvx_v2-ANDND_registerW_registerZ_registerY_simple
	;;
	andnd $r16r17r18r19.t = $r20, -64 	#Opcode-lvx_v2-ANDND_registerW_registerZ_signed10_simple
	;;
	andnd $r20r21.lo = $r20r21r22r23.x, -8589934592 	#Opcode-lvx_v2-ANDND_registerW_registerZ_upper27_lower10_double
	;;
	andnq $r44r45 = $r44r45r46r47.lo, $r46r47 	#Opcode-lvx_v2-ANDNQ_registerM_registerP_registerO_simple
	;;
	andnq $r44r45r46r47.hi = $r48r49, 536870911 	#Opcode-lvx_v2-ANDNQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	andnw $r21 = $r20r21.hi, $r20r21r22r23.y 	#Opcode-lvx_v2-ANDNW_signextw_registerW_registerZ_registerY_simple
	;;
	andnw.sx $r22 = $r22r23.lo, 536870911 	#Opcode-lvx_v2-ANDNW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	andq $r48r49r50r51.lo = $r50r51, $r48r49r50r51.hi 	#Opcode-lvx_v2-ANDQ_registerM_registerP_registerO_simple
	;;
	andq $r52r53 = $r52r53r54r55.lo, 536870911.@ 	#Opcode-lvx_v2-ANDQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	andw $r20r21r22r23.z = $r23, $r22r23.hi 	#Opcode-lvx_v2-ANDW_signextw_registerW_registerZ_registerY_simple
	;;
	andw.sx $r20r21r22r23.t = $r24, 536870911 	#Opcode-lvx_v2-ANDW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	asaddb -1125899906842624[$r24r25.lo] = $r24r25r26r27.x 	#Opcode-lvx_v2-ASADDB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asaddb.g -8388608[$r25] = $r24r25.hi 	#Opcode-lvx_v2-ASADDB_coherency_offset27_registerZ_registerT_double
	;;
	asaddb.s [$r24r25r26r27.y] = $r26 	#Opcode-lvx_v2-ASADDB_coherency_registerZ_registerT_simple
	;;
	asaddd -1125899906842624[$r26r27.lo] = $r24r25r26r27.z 	#Opcode-lvx_v2-ASADDD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asaddd.g -8388608[$r27] = $r26r27.hi 	#Opcode-lvx_v2-ASADDD_coherency_offset27_registerZ_registerT_double
	;;
	asaddd.s [$r24r25r26r27.t] = $r28 	#Opcode-lvx_v2-ASADDD_coherency_registerZ_registerT_simple
	;;
	asaddh -1125899906842624[$r28r29.lo] = $r28r29r30r31.x 	#Opcode-lvx_v2-ASADDH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asaddh.g -8388608[$r29] = $r28r29.hi 	#Opcode-lvx_v2-ASADDH_coherency_offset27_registerZ_registerT_double
	;;
	asaddh.s [$r28r29r30r31.y] = $r30 	#Opcode-lvx_v2-ASADDH_coherency_registerZ_registerT_simple
	;;
	asaddw -1125899906842624[$r30r31.lo] = $r28r29r30r31.z 	#Opcode-lvx_v2-ASADDW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asaddw.g -8388608[$r31] = $r30r31.hi 	#Opcode-lvx_v2-ASADDW_coherency_offset27_registerZ_registerT_double
	;;
	asaddw.s [$r28r29r30r31.t] = $r32 	#Opcode-lvx_v2-ASADDW_coherency_registerZ_registerT_simple
	;;
	asandb -1125899906842624[$r32r33.lo] = $r32r33r34r35.x 	#Opcode-lvx_v2-ASANDB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asandb.g -8388608[$r33] = $r32r33.hi 	#Opcode-lvx_v2-ASANDB_coherency_offset27_registerZ_registerT_double
	;;
	asandb.s [$r32r33r34r35.y] = $r34 	#Opcode-lvx_v2-ASANDB_coherency_registerZ_registerT_simple
	;;
	asandd -1125899906842624[$r34r35.lo] = $r32r33r34r35.z 	#Opcode-lvx_v2-ASANDD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asandd.g -8388608[$r35] = $r34r35.hi 	#Opcode-lvx_v2-ASANDD_coherency_offset27_registerZ_registerT_double
	;;
	asandd.s [$r32r33r34r35.t] = $r36 	#Opcode-lvx_v2-ASANDD_coherency_registerZ_registerT_simple
	;;
	asandh -1125899906842624[$r36r37.lo] = $r36r37r38r39.x 	#Opcode-lvx_v2-ASANDH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asandh.g -8388608[$r37] = $r36r37.hi 	#Opcode-lvx_v2-ASANDH_coherency_offset27_registerZ_registerT_double
	;;
	asandh.s [$r36r37r38r39.y] = $r38 	#Opcode-lvx_v2-ASANDH_coherency_registerZ_registerT_simple
	;;
	asandw -1125899906842624[$r38r39.lo] = $r36r37r38r39.z 	#Opcode-lvx_v2-ASANDW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asandw.g -8388608[$r39] = $r38r39.hi 	#Opcode-lvx_v2-ASANDW_coherency_offset27_registerZ_registerT_double
	;;
	asandw.s [$r36r37r38r39.t] = $r40 	#Opcode-lvx_v2-ASANDW_coherency_registerZ_registerT_simple
	;;
	asb -1125899906842624[$r40r41.lo] = $r40r41r42r43.x 	#Opcode-lvx_v2-ASB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asb.g -8388608[$r41] = $r40r41.hi 	#Opcode-lvx_v2-ASB_coherency_offset27_registerZ_registerT_double
	;;
	asb.s [$r40r41r42r43.y] = $r42 	#Opcode-lvx_v2-ASB_coherency_registerZ_registerT_simple
	;;
	asdusb -1125899906842624[$r42r43.lo] = $r40r41r42r43.z 	#Opcode-lvx_v2-ASDUSB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asdusb.g -8388608[$r43] = $r42r43.hi 	#Opcode-lvx_v2-ASDUSB_coherency_offset27_registerZ_registerT_double
	;;
	asdusb.s [$r40r41r42r43.t] = $r44 	#Opcode-lvx_v2-ASDUSB_coherency_registerZ_registerT_simple
	;;
	asdusd -1125899906842624[$r44r45.lo] = $r44r45r46r47.x 	#Opcode-lvx_v2-ASDUSD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asdusd.g -8388608[$r45] = $r44r45.hi 	#Opcode-lvx_v2-ASDUSD_coherency_offset27_registerZ_registerT_double
	;;
	asdusd.s [$r44r45r46r47.y] = $r46 	#Opcode-lvx_v2-ASDUSD_coherency_registerZ_registerT_simple
	;;
	asdush -1125899906842624[$r46r47.lo] = $r44r45r46r47.z 	#Opcode-lvx_v2-ASDUSH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asdush.g -8388608[$r47] = $r46r47.hi 	#Opcode-lvx_v2-ASDUSH_coherency_offset27_registerZ_registerT_double
	;;
	asdush.s [$r44r45r46r47.t] = $r48 	#Opcode-lvx_v2-ASDUSH_coherency_registerZ_registerT_simple
	;;
	asdusw -1125899906842624[$r48r49.lo] = $r48r49r50r51.x 	#Opcode-lvx_v2-ASDUSW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asdusw.g -8388608[$r49] = $r48r49.hi 	#Opcode-lvx_v2-ASDUSW_coherency_offset27_registerZ_registerT_double
	;;
	asdusw.s [$r48r49r50r51.y] = $r50 	#Opcode-lvx_v2-ASDUSW_coherency_registerZ_registerT_simple
	;;
	asd -1125899906842624[$r50r51.lo] = $r48r49r50r51.z 	#Opcode-lvx_v2-ASD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asd.g -8388608[$r51] = $r50r51.hi 	#Opcode-lvx_v2-ASD_coherency_offset27_registerZ_registerT_double
	;;
	asd.s [$r48r49r50r51.t] = $r52 	#Opcode-lvx_v2-ASD_coherency_registerZ_registerT_simple
	;;
	aseorb -1125899906842624[$r52r53.lo] = $r52r53r54r55.x 	#Opcode-lvx_v2-ASEORB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aseorb.g -8388608[$r53] = $r52r53.hi 	#Opcode-lvx_v2-ASEORB_coherency_offset27_registerZ_registerT_double
	;;
	aseorb.s [$r52r53r54r55.y] = $r54 	#Opcode-lvx_v2-ASEORB_coherency_registerZ_registerT_simple
	;;
	aseord -1125899906842624[$r54r55.lo] = $r52r53r54r55.z 	#Opcode-lvx_v2-ASEORD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aseord.g -8388608[$r55] = $r54r55.hi 	#Opcode-lvx_v2-ASEORD_coherency_offset27_registerZ_registerT_double
	;;
	aseord.s [$r52r53r54r55.t] = $r56 	#Opcode-lvx_v2-ASEORD_coherency_registerZ_registerT_simple
	;;
	aseorh -1125899906842624[$r56r57.lo] = $r56r57r58r59.x 	#Opcode-lvx_v2-ASEORH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aseorh.g -8388608[$r57] = $r56r57.hi 	#Opcode-lvx_v2-ASEORH_coherency_offset27_registerZ_registerT_double
	;;
	aseorh.s [$r56r57r58r59.y] = $r58 	#Opcode-lvx_v2-ASEORH_coherency_registerZ_registerT_simple
	;;
	aseorw -1125899906842624[$r58r59.lo] = $r56r57r58r59.z 	#Opcode-lvx_v2-ASEORW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aseorw.g -8388608[$r59] = $r58r59.hi 	#Opcode-lvx_v2-ASEORW_coherency_offset27_registerZ_registerT_double
	;;
	aseorw.s [$r56r57r58r59.t] = $r60 	#Opcode-lvx_v2-ASEORW_coherency_registerZ_registerT_simple
	;;
	ash -1125899906842624[$r60r61.lo] = $r60r61r62r63.x 	#Opcode-lvx_v2-ASH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	ash.g -8388608[$r61] = $r60r61.hi 	#Opcode-lvx_v2-ASH_coherency_offset27_registerZ_registerT_double
	;;
	ash.s [$r60r61r62r63.y] = $r62 	#Opcode-lvx_v2-ASH_coherency_registerZ_registerT_simple
	;;
	asiorb -1125899906842624[$r62r63.lo] = $r60r61r62r63.z 	#Opcode-lvx_v2-ASIORB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asiorb.g -8388608[$r63] = $r62r63.hi 	#Opcode-lvx_v2-ASIORB_coherency_offset27_registerZ_registerT_double
	;;
	asiorb.s [$r60r61r62r63.t] = $r0 	#Opcode-lvx_v2-ASIORB_coherency_registerZ_registerT_simple
	;;
	asiord -1125899906842624[$r0r1.lo] = $r0r1r2r3.x 	#Opcode-lvx_v2-ASIORD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asiord.g -8388608[$r1] = $r0r1.hi 	#Opcode-lvx_v2-ASIORD_coherency_offset27_registerZ_registerT_double
	;;
	asiord.s [$r0r1r2r3.y] = $r2 	#Opcode-lvx_v2-ASIORD_coherency_registerZ_registerT_simple
	;;
	asiorh -1125899906842624[$r2r3.lo] = $r0r1r2r3.z 	#Opcode-lvx_v2-ASIORH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asiorh.g -8388608[$r3] = $r2r3.hi 	#Opcode-lvx_v2-ASIORH_coherency_offset27_registerZ_registerT_double
	;;
	asiorh.s [$r0r1r2r3.t] = $r4 	#Opcode-lvx_v2-ASIORH_coherency_registerZ_registerT_simple
	;;
	asiorw -1125899906842624[$r4r5.lo] = $r4r5r6r7.x 	#Opcode-lvx_v2-ASIORW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asiorw.g -8388608[$r5] = $r4r5.hi 	#Opcode-lvx_v2-ASIORW_coherency_offset27_registerZ_registerT_double
	;;
	asiorw.s [$r4r5r6r7.y] = $r6 	#Opcode-lvx_v2-ASIORW_coherency_registerZ_registerT_simple
	;;
	asmaxb -1125899906842624[$r6r7.lo] = $r4r5r6r7.z 	#Opcode-lvx_v2-ASMAXB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxb.g -8388608[$r7] = $r6r7.hi 	#Opcode-lvx_v2-ASMAXB_coherency_offset27_registerZ_registerT_double
	;;
	asmaxb.s [$r4r5r6r7.t] = $r8 	#Opcode-lvx_v2-ASMAXB_coherency_registerZ_registerT_simple
	;;
	asmaxd -1125899906842624[$r8r9.lo] = $r8r9r10r11.x 	#Opcode-lvx_v2-ASMAXD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxd.g -8388608[$r9] = $r8r9.hi 	#Opcode-lvx_v2-ASMAXD_coherency_offset27_registerZ_registerT_double
	;;
	asmaxd.s [$r8r9r10r11.y] = $r10 	#Opcode-lvx_v2-ASMAXD_coherency_registerZ_registerT_simple
	;;
	asmaxh -1125899906842624[$r10r11.lo] = $r8r9r10r11.z 	#Opcode-lvx_v2-ASMAXH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxh.g -8388608[$r11] = $r10r11.hi 	#Opcode-lvx_v2-ASMAXH_coherency_offset27_registerZ_registerT_double
	;;
	asmaxh.s [$r8r9r10r11.t] = $r12 	#Opcode-lvx_v2-ASMAXH_coherency_registerZ_registerT_simple
	;;
	asmaxub -1125899906842624[$sp] = $r13 	#Opcode-lvx_v2-ASMAXUB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxub.g -8388608[$tp] = $r14 	#Opcode-lvx_v2-ASMAXUB_coherency_offset27_registerZ_registerT_double
	;;
	asmaxub.s [$fp] = $r14r15.lo 	#Opcode-lvx_v2-ASMAXUB_coherency_registerZ_registerT_simple
	;;
	asmaxud -1125899906842624[$r15] = $rp 	#Opcode-lvx_v2-ASMAXUD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxud.g -8388608[$r14r15.hi] = $r16 	#Opcode-lvx_v2-ASMAXUD_coherency_offset27_registerZ_registerT_double
	;;
	asmaxud.s [$r16r17.lo] = $r16r17r18r19.x 	#Opcode-lvx_v2-ASMAXUD_coherency_registerZ_registerT_simple
	;;
	asmaxuh -1125899906842624[$r17] = $r16r17.hi 	#Opcode-lvx_v2-ASMAXUH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxuh.g -8388608[$r16r17r18r19.y] = $r18 	#Opcode-lvx_v2-ASMAXUH_coherency_offset27_registerZ_registerT_double
	;;
	asmaxuh.s [$r18r19.lo] = $r16r17r18r19.z 	#Opcode-lvx_v2-ASMAXUH_coherency_registerZ_registerT_simple
	;;
	asmaxuw -1125899906842624[$r19] = $r18r19.hi 	#Opcode-lvx_v2-ASMAXUW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxuw.g -8388608[$r16r17r18r19.t] = $r20 	#Opcode-lvx_v2-ASMAXUW_coherency_offset27_registerZ_registerT_double
	;;
	asmaxuw.s [$r20r21.lo] = $r20r21r22r23.x 	#Opcode-lvx_v2-ASMAXUW_coherency_registerZ_registerT_simple
	;;
	asmaxw -1125899906842624[$r21] = $r20r21.hi 	#Opcode-lvx_v2-ASMAXW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmaxw.g -8388608[$r20r21r22r23.y] = $r22 	#Opcode-lvx_v2-ASMAXW_coherency_offset27_registerZ_registerT_double
	;;
	asmaxw.s [$r22r23.lo] = $r20r21r22r23.z 	#Opcode-lvx_v2-ASMAXW_coherency_registerZ_registerT_simple
	;;
	asminb -1125899906842624[$r23] = $r22r23.hi 	#Opcode-lvx_v2-ASMINB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asminb.g -8388608[$r20r21r22r23.t] = $r24 	#Opcode-lvx_v2-ASMINB_coherency_offset27_registerZ_registerT_double
	;;
	asminb.s [$r24r25.lo] = $r24r25r26r27.x 	#Opcode-lvx_v2-ASMINB_coherency_registerZ_registerT_simple
	;;
	asmind -1125899906842624[$r25] = $r24r25.hi 	#Opcode-lvx_v2-ASMIND_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asmind.g -8388608[$r24r25r26r27.y] = $r26 	#Opcode-lvx_v2-ASMIND_coherency_offset27_registerZ_registerT_double
	;;
	asmind.s [$r26r27.lo] = $r24r25r26r27.z 	#Opcode-lvx_v2-ASMIND_coherency_registerZ_registerT_simple
	;;
	asminh -1125899906842624[$r27] = $r26r27.hi 	#Opcode-lvx_v2-ASMINH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asminh.g -8388608[$r24r25r26r27.t] = $r28 	#Opcode-lvx_v2-ASMINH_coherency_offset27_registerZ_registerT_double
	;;
	asminh.s [$r28r29.lo] = $r28r29r30r31.x 	#Opcode-lvx_v2-ASMINH_coherency_registerZ_registerT_simple
	;;
	asminub -1125899906842624[$r29] = $r28r29.hi 	#Opcode-lvx_v2-ASMINUB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asminub.g -8388608[$r28r29r30r31.y] = $r30 	#Opcode-lvx_v2-ASMINUB_coherency_offset27_registerZ_registerT_double
	;;
	asminub.s [$r30r31.lo] = $r28r29r30r31.z 	#Opcode-lvx_v2-ASMINUB_coherency_registerZ_registerT_simple
	;;
	asminud -1125899906842624[$r31] = $r30r31.hi 	#Opcode-lvx_v2-ASMINUD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asminud.g -8388608[$r28r29r30r31.t] = $r32 	#Opcode-lvx_v2-ASMINUD_coherency_offset27_registerZ_registerT_double
	;;
	asminud.s [$r32r33.lo] = $r32r33r34r35.x 	#Opcode-lvx_v2-ASMINUD_coherency_registerZ_registerT_simple
	;;
	asminuh -1125899906842624[$r33] = $r32r33.hi 	#Opcode-lvx_v2-ASMINUH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asminuh.g -8388608[$r32r33r34r35.y] = $r34 	#Opcode-lvx_v2-ASMINUH_coherency_offset27_registerZ_registerT_double
	;;
	asminuh.s [$r34r35.lo] = $r32r33r34r35.z 	#Opcode-lvx_v2-ASMINUH_coherency_registerZ_registerT_simple
	;;
	asminuw -1125899906842624[$r35] = $r34r35.hi 	#Opcode-lvx_v2-ASMINUW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asminuw.g -8388608[$r32r33r34r35.t] = $r36 	#Opcode-lvx_v2-ASMINUW_coherency_offset27_registerZ_registerT_double
	;;
	asminuw.s [$r36r37.lo] = $r36r37r38r39.x 	#Opcode-lvx_v2-ASMINUW_coherency_registerZ_registerT_simple
	;;
	asminw -1125899906842624[$r37] = $r36r37.hi 	#Opcode-lvx_v2-ASMINW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asminw.g -8388608[$r36r37r38r39.y] = $r38 	#Opcode-lvx_v2-ASMINW_coherency_offset27_registerZ_registerT_double
	;;
	asminw.s [$r38r39.lo] = $r36r37r38r39.z 	#Opcode-lvx_v2-ASMINW_coherency_registerZ_registerT_simple
	;;
	aswapb -1125899906842624[$r39] = $r38r39.hi 	#Opcode-lvx_v2-ASWAPB_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aswapb.g -8388608[$r36r37r38r39.t] = $r40 	#Opcode-lvx_v2-ASWAPB_coherency_offset27_registerZ_registerT_double
	;;
	aswapb.s [$r40r41.lo] = $r40r41r42r43.x 	#Opcode-lvx_v2-ASWAPB_coherency_registerZ_registerT_simple
	;;
	aswapd -1125899906842624[$r41] = $r40r41.hi 	#Opcode-lvx_v2-ASWAPD_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aswapd.g -8388608[$r40r41r42r43.y] = $r42 	#Opcode-lvx_v2-ASWAPD_coherency_offset27_registerZ_registerT_double
	;;
	aswapd.s [$r42r43.lo] = $r40r41r42r43.z 	#Opcode-lvx_v2-ASWAPD_coherency_registerZ_registerT_simple
	;;
	aswaph -1125899906842624[$r43] = $r42r43.hi 	#Opcode-lvx_v2-ASWAPH_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aswaph.g -8388608[$r40r41r42r43.t] = $r44 	#Opcode-lvx_v2-ASWAPH_coherency_offset27_registerZ_registerT_double
	;;
	aswaph.s [$r44r45.lo] = $r44r45r46r47.x 	#Opcode-lvx_v2-ASWAPH_coherency_registerZ_registerT_simple
	;;
	aswapw -1125899906842624[$r45] = $r44r45.hi 	#Opcode-lvx_v2-ASWAPW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	aswapw.g -8388608[$r44r45r46r47.y] = $r46 	#Opcode-lvx_v2-ASWAPW_coherency_offset27_registerZ_registerT_double
	;;
	aswapw.s [$r46r47.lo] = $r44r45r46r47.z 	#Opcode-lvx_v2-ASWAPW_coherency_registerZ_registerT_simple
	;;
	asw -1125899906842624[$r47] = $r46r47.hi 	#Opcode-lvx_v2-ASW_coherency_extend27_offset27_registerZ_registerT_triple
	;;
	asw.g -8388608[$r44r45r46r47.t] = $r48 	#Opcode-lvx_v2-ASW_coherency_offset27_registerZ_registerT_double
	;;
	asw.s [$r48r49.lo] = $r48r49r50r51.x 	#Opcode-lvx_v2-ASW_coherency_registerZ_registerT_simple
	;;
	avgbx $r54r55 = $r52r53r54r55.hi, $r56r57 	#Opcode-lvx_v2-AVGBX_registerM_registerP_registerO_simple
	;;
	avgbx $r56r57r58r59.lo = $r58r59, 536870911 	#Opcode-lvx_v2-AVGBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	avgho $r56r57r58r59.hi = $r60r61, $r60r61r62r63.lo 	#Opcode-lvx_v2-AVGHO_registerM_registerP_registerO_simple
	;;
	avgho $r62r63 = $r60r61r62r63.hi, 536870911.@ 	#Opcode-lvx_v2-AVGHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	avgrbx $r0r1 = $r0r1r2r3.lo, $r2r3 	#Opcode-lvx_v2-AVGRBX_registerM_registerP_registerO_simple
	;;
	avgrbx $r0r1r2r3.hi = $r4r5, 536870911 	#Opcode-lvx_v2-AVGRBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	avgrho $r4r5r6r7.lo = $r6r7, $r4r5r6r7.hi 	#Opcode-lvx_v2-AVGRHO_registerM_registerP_registerO_simple
	;;
	avgrho $r8r9 = $r8r9r10r11.lo, 536870911.@ 	#Opcode-lvx_v2-AVGRHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	avgrubx $r10r11 = $r8r9r10r11.hi, $r12r13 	#Opcode-lvx_v2-AVGRUBX_registerM_registerP_registerO_simple
	;;
	avgrubx $r12r13r14r15.lo = $r14r15, 536870911 	#Opcode-lvx_v2-AVGRUBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	avgruho $r12r13r14r15.hi = $r16r17, $r16r17r18r19.lo 	#Opcode-lvx_v2-AVGRUHO_registerM_registerP_registerO_simple
	;;
	avgruho $r18r19 = $r16r17r18r19.hi, 536870911.@ 	#Opcode-lvx_v2-AVGRUHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	avgruwq $r20r21 = $r20r21r22r23.lo, $r22r23 	#Opcode-lvx_v2-AVGRUWQ_registerM_registerP_registerO_simple
	;;
	avgruwq $r20r21r22r23.hi = $r24r25, 536870911 	#Opcode-lvx_v2-AVGRUWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	avgruw $r49 = $r48r49.hi, $r48r49r50r51.y 	#Opcode-lvx_v2-AVGRUW_signextw_registerW_registerZ_registerY_simple
	;;
	avgruw.sx $r50 = $r50r51.lo, 536870911 	#Opcode-lvx_v2-AVGRUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	avgrwq $r24r25r26r27.lo = $r26r27, $r24r25r26r27.hi 	#Opcode-lvx_v2-AVGRWQ_registerM_registerP_registerO_simple
	;;
	avgrwq $r28r29 = $r28r29r30r31.lo, 536870911.@ 	#Opcode-lvx_v2-AVGRWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	avgrw $r48r49r50r51.z = $r51, $r50r51.hi 	#Opcode-lvx_v2-AVGRW_signextw_registerW_registerZ_registerY_simple
	;;
	avgrw.sx $r48r49r50r51.t = $r52, 536870911 	#Opcode-lvx_v2-AVGRW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	avgubx $r30r31 = $r28r29r30r31.hi, $r32r33 	#Opcode-lvx_v2-AVGUBX_registerM_registerP_registerO_simple
	;;
	avgubx $r32r33r34r35.lo = $r34r35, 536870911 	#Opcode-lvx_v2-AVGUBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	avguho $r32r33r34r35.hi = $r36r37, $r36r37r38r39.lo 	#Opcode-lvx_v2-AVGUHO_registerM_registerP_registerO_simple
	;;
	avguho $r38r39 = $r36r37r38r39.hi, 536870911.@ 	#Opcode-lvx_v2-AVGUHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	avguwq $r40r41 = $r40r41r42r43.lo, $r42r43 	#Opcode-lvx_v2-AVGUWQ_registerM_registerP_registerO_simple
	;;
	avguwq $r40r41r42r43.hi = $r44r45, 536870911 	#Opcode-lvx_v2-AVGUWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	avguw $r52r53.lo = $r52r53r54r55.x, $r53 	#Opcode-lvx_v2-AVGUW_signextw_registerW_registerZ_registerY_simple
	;;
	avguw.sx $r52r53.hi = $r52r53r54r55.y, 536870911 	#Opcode-lvx_v2-AVGUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	avgwq $r44r45r46r47.lo = $r46r47, $r44r45r46r47.hi 	#Opcode-lvx_v2-AVGWQ_registerM_registerP_registerO_simple
	;;
	avgwq $r48r49 = $r48r49r50r51.lo, 536870911.@ 	#Opcode-lvx_v2-AVGWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	avgw $r54 = $r54r55.lo, $r52r53r54r55.z 	#Opcode-lvx_v2-AVGW_signextw_registerW_registerZ_registerY_simple
	;;
	avgw.sx $r55 = $r54r55.hi, 536870911 	#Opcode-lvx_v2-AVGW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	await 	#Opcode-lvx_v2-AWAIT_simple
	;;
	barrier 	#Opcode-lvx_v2-BARRIER_simple
	;;
	blend.mt $r52r53r54r55.t? 7 	#Opcode-lvx_v2-BLEND_lanetodo_lanesize_registerZ_activate_simple
	;;
	break 0 	#Opcode-lvx_v2-BREAK_brknumber_simple
	;;
	callx -4503599627370496 	#Opcode-lvx_v2-CALLX_upper27_lower27_double
	;;
	call -33554432 	#Opcode-lvx_v2-CALL_pcrel27s2_simple
	;;
	catdq $r50r51 = $r56, $r56r57.lo 	#Opcode-lvx_v2-CATDQ_registerM_registerZ_registerY_simple
	;;
	cbsdp $r48r49r50r51.hi = $r52r53 	#Opcode-lvx_v2-CBSDP_registerM_registerP_simple
	;;
	cbsd $r56r57r58r59.x = $r57 	#Opcode-lvx_v2-CBSD_registerW_registerZ_simple
	;;
	cbsho $r52r53r54r55.lo = $r54r55 	#Opcode-lvx_v2-CBSHO_registerM_registerP_simple
	;;
	cbswq $r52r53r54r55.hi = $r56r57 	#Opcode-lvx_v2-CBSWQ_registerM_registerP_simple
	;;
	cbsw $r56r57.hi = $r56r57r58r59.y 	#Opcode-lvx_v2-CBSW_registerW_registerZ_simple
	;;
	cbx.dltz $r58? -4398046511104 	#Opcode-lvx_v2-CBX_bcucond_registerZ_upper27_lower17_double
	;;
	cb.dgez $r58r59.lo? -32768 	#Opcode-lvx_v2-CB_bcucond_registerZ_pcrel17s2_simple
	;;
	ccbx.dlt $r56r57r58r59.z, $r59 ? -68719476736 	#Opcode-lvx_v2-CCBX_ccbcomp_registerZ_registerY_upper27_lower11_double
	;;
	ccb.dge $r58r59.hi, $r56r57r58r59.t ? -512 	#Opcode-lvx_v2-CCB_ccbcomp_registerZ_registerY_pcrel11s2_simple
	;;
	clsdp $r56r57r58r59.lo = $r58r59 	#Opcode-lvx_v2-CLSDP_registerM_registerP_simple
	;;
	clsd $r60 = $r60r61.lo 	#Opcode-lvx_v2-CLSD_registerW_registerZ_simple
	;;
	clsho $r56r57r58r59.hi = $r60r61 	#Opcode-lvx_v2-CLSHO_registerM_registerP_simple
	;;
	clswq $r60r61r62r63.lo = $r62r63 	#Opcode-lvx_v2-CLSWQ_registerM_registerP_simple
	;;
	clsw $r60r61r62r63.x = $r61 	#Opcode-lvx_v2-CLSW_registerW_registerZ_simple
	;;
	clzdp $r60r61r62r63.hi = $r0r1 	#Opcode-lvx_v2-CLZDP_registerM_registerP_simple
	;;
	clzd $r60r61.hi = $r60r61r62r63.y 	#Opcode-lvx_v2-CLZD_registerW_registerZ_simple
	;;
	clzho $r0r1r2r3.lo = $r2r3 	#Opcode-lvx_v2-CLZHO_registerM_registerP_simple
	;;
	clzwq $r0r1r2r3.hi = $r4r5 	#Opcode-lvx_v2-CLZWQ_registerM_registerP_simple
	;;
	clzw $r62 = $r62r63.lo 	#Opcode-lvx_v2-CLZW_registerW_registerZ_simple
	;;
	cmovebx.ltz $r4r5r6r7.lo? $r6r7 = $r4r5r6r7.hi 	#Opcode-lvx_v2-CMOVEBX_lanecond_registerP_registerM_registerO_simple
	;;
	cmovebx.gez $r8r9? $r8r9r10r11.lo = 536870911 	#Opcode-lvx_v2-CMOVEBX_lanecond_registerP_registerM_upper27_lower5_splat32_double
	;;
	cmovedp.lez $r10r11? $r8r9r10r11.hi = $r12r13 	#Opcode-lvx_v2-CMOVEDP_lanecond_registerP_registerM_registerO_simple
	;;
	cmovedp.gtz $r12r13r14r15.lo? $r14r15 = 536870911.@ 	#Opcode-lvx_v2-CMOVEDP_lanecond_registerP_registerM_upper27_lower5_splat32_double
	;;
	cmoved.dlez $r60r61r62r63.z? $r63 = $r62r63.hi 	#Opcode-lvx_v2-CMOVED_cmovecond_registerZ_registerW_registerY_simple
	;;
	cmoved.dgtz $r60r61r62r63.t? $r0 = 536870911 	#Opcode-lvx_v2-CMOVED_cmovecond_registerZ_registerW_upper27_lower5_splat32_double
	;;
	cmoveho.eqz $r12r13r14r15.hi? $r16r17 = $r16r17r18r19.lo 	#Opcode-lvx_v2-CMOVEHO_lanecond_registerP_registerM_registerO_simple
	;;
	cmoveho.nez $r18r19? $r16r17r18r19.hi = 536870911.@ 	#Opcode-lvx_v2-CMOVEHO_lanecond_registerP_registerM_upper27_lower5_splat32_double
	;;
	cmoveq.deqz $r0r1.lo? $r20r21 = $r20r21r22r23.lo 	#Opcode-lvx_v2-CMOVEQ_cmovecond_registerZ_registerM_registerO_simple
	;;
	cmovewq.odd $r22r23? $r20r21r22r23.hi = $r24r25 	#Opcode-lvx_v2-CMOVEWQ_lanecond_registerP_registerM_registerO_simple
	;;
	cmovewq.even $r24r25r26r27.lo? $r26r27 = 536870911 	#Opcode-lvx_v2-CMOVEWQ_lanecond_registerP_registerM_upper27_lower5_splat32_double
	;;
	compbx.lt $r0r1r2r3.x = $r24r25r26r27.hi, $r28r29 	#Opcode-lvx_v2-COMPBX_intcomp_registerW_registerP_registerO_simple
	;;
	compbx.ge $r1 = $r28r29r30r31.lo, 536870911.@ 	#Opcode-lvx_v2-COMPBX_intcomp_registerW_registerP_upper27_lower5_splat32_double
	;;
	compdp.ltu $r0r1.hi = $r30r31, $r28r29r30r31.hi 	#Opcode-lvx_v2-COMPDP_intcomp_registerW_registerP_registerO_simple
	;;
	compdp.geu $r0r1r2r3.y = $r32r33, 536870911 	#Opcode-lvx_v2-COMPDP_intcomp_registerW_registerP_upper27_lower5_splat32_double
	;;
	compd.eq $r2 = $r2r3.lo, $r0r1r2r3.z 	#Opcode-lvx_v2-COMPD_intcomp_registerW_registerZ_registerY_simple
	;;
	compd.ne $r3 = $r2r3.hi, 536870911 	#Opcode-lvx_v2-COMPD_intcomp_registerW_registerZ_upper27_lower5_double
	;;
	compho.any $r0r1r2r3.t = $r32r33r34r35.lo, $r34r35 	#Opcode-lvx_v2-COMPHO_intcomp_registerW_registerP_registerO_simple
	;;
	compho.none $r4 = $r32r33r34r35.hi, 536870911.@ 	#Opcode-lvx_v2-COMPHO_intcomp_registerW_registerP_upper27_lower5_splat32_double
	;;
	compnbx.le $r36r37 = $r36r37r38r39.lo, $r38r39 	#Opcode-lvx_v2-COMPNBX_intcomp_registerM_registerP_registerO_simple
	;;
	compnbx.gt $r36r37r38r39.hi = $r40r41, 536870911 	#Opcode-lvx_v2-COMPNBX_intcomp_registerM_registerP_upper27_lower5_splat32_double
	;;
	compndp.leu $r40r41r42r43.lo = $r42r43, $r40r41r42r43.hi 	#Opcode-lvx_v2-COMPNDP_intcomp_registerM_registerP_registerO_simple
	;;
	compndp.gtu $r44r45 = $r44r45r46r47.lo, 536870911.@ 	#Opcode-lvx_v2-COMPNDP_intcomp_registerM_registerP_upper27_lower5_splat32_double
	;;
	compnho.lt $r46r47 = $r44r45r46r47.hi, $r48r49 	#Opcode-lvx_v2-COMPNHO_intcomp_registerM_registerP_registerO_simple
	;;
	compnho.ge $r48r49r50r51.lo = $r50r51, 536870911 	#Opcode-lvx_v2-COMPNHO_intcomp_registerM_registerP_upper27_lower5_splat32_double
	;;
	compnwq.ltu $r48r49r50r51.hi = $r52r53, $r52r53r54r55.lo 	#Opcode-lvx_v2-COMPNWQ_intcomp_registerM_registerP_registerO_simple
	;;
	compnwq.geu $r54r55 = $r52r53r54r55.hi, 536870911.@ 	#Opcode-lvx_v2-COMPNWQ_intcomp_registerM_registerP_upper27_lower5_splat32_double
	;;
	compq.eq $r56r57 = $r56r57r58r59.lo, $r58r59 	#Opcode-lvx_v2-COMPQ_intcomp_registerM_registerP_registerO_simple
	;;
	compwq.ne $r4r5.lo = $r56r57r58r59.hi, $r60r61 	#Opcode-lvx_v2-COMPWQ_intcomp_registerW_registerP_registerO_simple
	;;
	compwq.any $r4r5r6r7.x = $r60r61r62r63.lo, 536870911 	#Opcode-lvx_v2-COMPWQ_intcomp_registerW_registerP_upper27_lower5_splat32_double
	;;
	compw.none $r5 = $r4r5.hi, $r4r5r6r7.y 	#Opcode-lvx_v2-COMPW_intcomp_signextw_registerW_registerZ_registerY_simple
	;;
	compw.le.sx $r6 = $r6r7.lo, 536870911 	#Opcode-lvx_v2-COMPW_intcomp_signextw_registerW_registerZ_upper27_lower5_double
	;;
	copyd $r4r5r6r7.z = $r7 	#Opcode-lvx_v2-COPYD_registerW_registerZ_simple
	;;
	copyo $r12r13r14r15 = $r16r17r18r19 	#Opcode-lvx_v2-COPYO_registerN_registerR_simple
	;;
	copyq $r62r63 = $r6r7.hi, $r4r5r6r7.t 	#Opcode-lvx_v2-COPYQ_registerM_registerZ_registerY_simple
	;;
	copyw $r8 = $r8r9.lo 	#Opcode-lvx_v2-COPYW_signextw_registerW_registerZ_simple
	;;
	crcbellw $r8r9r10r11.x = $r9, $r8r9.hi 	#Opcode-lvx_v2-CRCBELLW_registerW_registerZ_registerY_simple
	;;
	crcbellw $r8r9r10r11.y = $r10, 536870911 	#Opcode-lvx_v2-CRCBELLW_registerW_registerZ_upper27_lower5_double
	;;
	crcbelmw $r10r11.lo = $r8r9r10r11.z, $r11 	#Opcode-lvx_v2-CRCBELMW_registerW_registerZ_registerY_simple
	;;
	crcbelmw $r10r11.hi = $r8r9r10r11.t, 536870911 	#Opcode-lvx_v2-CRCBELMW_registerW_registerZ_upper27_lower5_double
	;;
	crclellw $r12 = $sp, $r13 	#Opcode-lvx_v2-CRCLELLW_registerW_registerZ_registerY_simple
	;;
	crclellw $tp = $r14, 536870911 	#Opcode-lvx_v2-CRCLELLW_registerW_registerZ_upper27_lower5_double
	;;
	crclelmw $fp = $r14r15.lo, $r15 	#Opcode-lvx_v2-CRCLELMW_registerW_registerZ_registerY_simple
	;;
	crclelmw $rp = $r14r15.hi, 536870911 	#Opcode-lvx_v2-CRCLELMW_registerW_registerZ_upper27_lower5_double
	;;
	csrrc $r16 = 511 	#Opcode-lvx_v2-CSRRC_registerZ_csrnumber_simple
	;;
	csrrs $r16r17.lo = 511 	#Opcode-lvx_v2-CSRRS_registerZ_csrnumber_simple
	;;
	csrrw $r16r17r18r19.x = 511 	#Opcode-lvx_v2-CSRRW_registerZ_csrnumber_simple
	;;
	ctzdp $r60r61r62r63.hi = $r0r1 	#Opcode-lvx_v2-CTZDP_registerM_registerP_simple
	;;
	ctzd $r17 = $r16r17.hi 	#Opcode-lvx_v2-CTZD_registerW_registerZ_simple
	;;
	ctzho $r0r1r2r3.lo = $r2r3 	#Opcode-lvx_v2-CTZHO_registerM_registerP_simple
	;;
	ctzwq $r0r1r2r3.hi = $r4r5 	#Opcode-lvx_v2-CTZWQ_registerM_registerP_simple
	;;
	ctzw $r16r17r18r19.y = $r18 	#Opcode-lvx_v2-CTZW_registerW_registerZ_simple
	;;
	d1inval 	#Opcode-lvx_v2-D1INVAL_simple
	;;
	dflushl 2305843009213693951[$r18r19.lo] 	#Opcode-lvx_v2-DFLUSHL_extend27_upper27_lower10_registerZ_triple
	;;
	dflushl $r16r17r18r19.z[$r19] 	#Opcode-lvx_v2-DFLUSHL_registerY_registerZ_simple
	;;
	dflushl -64[$r18r19.hi] 	#Opcode-lvx_v2-DFLUSHL_signed10_registerZ_simple
	;;
	dflushl -8589934592[$r16r17r18r19.t] 	#Opcode-lvx_v2-DFLUSHL_upper27_lower10_registerZ_double
	;;
	dflushsw.l1 $r20, $r20r21.lo 	#Opcode-lvx_v2-DFLUSHSW_cachelev_registerY_registerZ_simple
	;;
	dinvall 2305843009213693951[$r20r21r22r23.x] 	#Opcode-lvx_v2-DINVALL_extend27_upper27_lower10_registerZ_triple
	;;
	dinvall $r21[$r20r21.hi] 	#Opcode-lvx_v2-DINVALL_registerY_registerZ_simple
	;;
	dinvall -64[$r20r21r22r23.y] 	#Opcode-lvx_v2-DINVALL_signed10_registerZ_simple
	;;
	dinvall -8589934592[$r22] 	#Opcode-lvx_v2-DINVALL_upper27_lower10_registerZ_double
	;;
	dinvalsw.l2 $r22r23.lo, $r20r21r22r23.z 	#Opcode-lvx_v2-DINVALSW_cachelev_registerY_registerZ_simple
	;;
	divmodd $r4r5r6r7.lo = $r23, $r22r23.hi 	#Opcode-lvx_v2-DIVMODD_registerM_registerZ_registerY_simple
	;;
	divmodud $r6r7 = $r20r21r22r23.t, $r24 	#Opcode-lvx_v2-DIVMODUD_registerM_registerZ_registerY_simple
	;;
	divmoduw.sx $r4r5r6r7.hi = $r24r25.lo, $r24r25r26r27.x 	#Opcode-lvx_v2-DIVMODUW_signextw_registerM_registerZ_registerY_simple
	;;
	divmodw $r8r9 = $r25, $r24r25.hi 	#Opcode-lvx_v2-DIVMODW_signextw_registerM_registerZ_registerY_simple
	;;
	dpurgel 2305843009213693951[$r24r25r26r27.y] 	#Opcode-lvx_v2-DPURGEL_extend27_upper27_lower10_registerZ_triple
	;;
	dpurgel $r26[$r26r27.lo] 	#Opcode-lvx_v2-DPURGEL_registerY_registerZ_simple
	;;
	dpurgel -64[$r24r25r26r27.z] 	#Opcode-lvx_v2-DPURGEL_signed10_registerZ_simple
	;;
	dpurgel -8589934592[$r27] 	#Opcode-lvx_v2-DPURGEL_upper27_lower10_registerZ_double
	;;
	dpurgesw.l1 $r26r27.hi, $r24r25r26r27.t 	#Opcode-lvx_v2-DPURGESW_cachelev_registerY_registerZ_simple
	;;
	dtouchl 2305843009213693951[$r28] 	#Opcode-lvx_v2-DTOUCHL_extend27_upper27_lower10_registerZ_triple
	;;
	dtouchl $r28r29.lo[$r28r29r30r31.x] 	#Opcode-lvx_v2-DTOUCHL_registerY_registerZ_simple
	;;
	dtouchl -64[$r29] 	#Opcode-lvx_v2-DTOUCHL_signed10_registerZ_simple
	;;
	dtouchl -8589934592[$r28r29.hi] 	#Opcode-lvx_v2-DTOUCHL_upper27_lower10_registerZ_double
	;;
	eord $r28r29r30r31.y = $r30, 2305843009213693951 	#Opcode-lvx_v2-EORD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	eord $r30r31.lo = $r28r29r30r31.z, $r31 	#Opcode-lvx_v2-EORD_registerW_registerZ_registerY_simple
	;;
	eord $r30r31.hi = $r28r29r30r31.t, -64 	#Opcode-lvx_v2-EORD_registerW_registerZ_signed10_simple
	;;
	eord $r32 = $r32r33.lo, -8589934592 	#Opcode-lvx_v2-EORD_registerW_registerZ_upper27_lower10_double
	;;
	eorq $r8r9r10r11.lo = $r10r11, $r8r9r10r11.hi 	#Opcode-lvx_v2-EORQ_registerM_registerP_registerO_simple
	;;
	eorq $r12r13 = $r12r13r14r15.lo, 536870911.@ 	#Opcode-lvx_v2-EORQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	eorw.sx $r32r33r34r35.x = $r33, $r32r33.hi 	#Opcode-lvx_v2-EORW_signextw_registerW_registerZ_registerY_simple
	;;
	eorw $r32r33r34r35.y = $r34, 536870911 	#Opcode-lvx_v2-EORW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	errop 	#Opcode-lvx_v2-ERROP_simple
	;;
	extfs $r34r35.lo = $r32r33r34r35.z, 7, 7 	#Opcode-lvx_v2-EXTFS_registerW_registerZ_stopbit2_stopbit4_startbit_simple
	;;
	extfz $r35 = $r34r35.hi, 7, 7 	#Opcode-lvx_v2-EXTFZ_registerW_registerZ_stopbit2_stopbit4_startbit_simple
	;;
	extlqbho $r14r15 = $r12r13r14r15.hi 	#Opcode-lvx_v2-EXTLQBHO_oddlanes_registerM_registerP_simple
	;;
	extlqhwq.o $r16r17 = $r16r17r18r19.lo 	#Opcode-lvx_v2-EXTLQHWQ_oddlanes_registerM_registerP_simple
	;;
	extlqnbx $r18r19 = $r16r17r18r19.hi 	#Opcode-lvx_v2-EXTLQNBX_oddlanes_registerM_registerP_simple
	;;
	extlqwdp.o $r20r21 = $r20r21r22r23.lo 	#Opcode-lvx_v2-EXTLQWDP_oddlanes_registerM_registerP_simple
	;;
	extlsbho $r22r23 = $r20r21r22r23.hi 	#Opcode-lvx_v2-EXTLSBHO_oddlanes_registerM_registerP_simple
	;;
	extlshwq.o $r24r25 = $r24r25r26r27.lo 	#Opcode-lvx_v2-EXTLSHWQ_oddlanes_registerM_registerP_simple
	;;
	extlsnbx $r26r27 = $r24r25r26r27.hi 	#Opcode-lvx_v2-EXTLSNBX_oddlanes_registerM_registerP_simple
	;;
	extlswdp.o $r28r29 = $r28r29r30r31.lo 	#Opcode-lvx_v2-EXTLSWDP_oddlanes_registerM_registerP_simple
	;;
	extlzbho $r30r31 = $r28r29r30r31.hi 	#Opcode-lvx_v2-EXTLZBHO_oddlanes_registerM_registerP_simple
	;;
	extlzhwq.o $r32r33 = $r32r33r34r35.lo 	#Opcode-lvx_v2-EXTLZHWQ_oddlanes_registerM_registerP_simple
	;;
	extlznbx $r34r35 = $r32r33r34r35.hi 	#Opcode-lvx_v2-EXTLZNBX_oddlanes_registerM_registerP_simple
	;;
	extlzwdp.o $r36r37 = $r36r37r38r39.lo 	#Opcode-lvx_v2-EXTLZWDP_oddlanes_registerM_registerP_simple
	;;
	fabsdp $r38r39 = $r36r37r38r39.hi 	#Opcode-lvx_v2-FABSDP_registerM_registerP_simple
	;;
	fabsd $r32r33r34r35.t = $r36 	#Opcode-lvx_v2-FABSD_registerW_registerZ_simple
	;;
	fabsho $r40r41 = $r40r41r42r43.lo 	#Opcode-lvx_v2-FABSHO_registerM_registerP_simple
	;;
	fabsh $r36r37.lo = $r36r37r38r39.x 	#Opcode-lvx_v2-FABSH_registerW_registerZ_simple
	;;
	fabswp $r37 = $r36r37.hi 	#Opcode-lvx_v2-FABSWP_registerW_registerZ_simple
	;;
	fabswq $r42r43 = $r40r41r42r43.hi 	#Opcode-lvx_v2-FABSWQ_registerM_registerP_simple
	;;
	fabsw $r36r37r38r39.y = $r38 	#Opcode-lvx_v2-FABSW_registerW_registerZ_simple
	;;
	fadddp.rn $r44r45 = $r44r45r46r47.lo, $r46r47 	#Opcode-lvx_v2-FADDDP_floatmode_registerM_registerP_registerO_simple
	;;
	faddd.rz $r38r39.lo = $r36r37r38r39.z, $r39 	#Opcode-lvx_v2-FADDD_floatmode_registerW_registerZ_registerY_simple
	;;
	faddho.rd $r44r45r46r47.hi = $r48r49, $r48r49r50r51.lo 	#Opcode-lvx_v2-FADDHO_floatmode_registerM_registerP_registerO_simple
	;;
	faddh.ru $r38r39.hi = $r36r37r38r39.t, $r40 	#Opcode-lvx_v2-FADDH_floatmode_registerW_registerZ_registerY_simple
	;;
	faddwc.rm $r40r41.lo = $r40r41r42r43.x, $r41 	#Opcode-lvx_v2-FADDWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple
	;;
	faddwq.r5 $r50r51 = $r48r49r50r51.hi, $r52r53 	#Opcode-lvx_v2-FADDWQ_floatmode_registerM_registerP_registerO_simple
	;;
	faddw.ro $r40r41.hi = $r40r41r42r43.y, $r42 	#Opcode-lvx_v2-FADDW_floatmode_registerW_registerZ_registerY_simple
	;;
	fclassd $r42r43.lo = $r40r41r42r43.z 	#Opcode-lvx_v2-FCLASSD_registerW_registerZ_simple
	;;
	fclassh $r43 = $r42r43.hi 	#Opcode-lvx_v2-FCLASSH_registerW_registerZ_simple
	;;
	fclasswp $r40r41r42r43.t = $r44 	#Opcode-lvx_v2-FCLASSWP_registerW_registerZ_simple
	;;
	fclasswq $r52r53r54r55.lo = $r54r55 	#Opcode-lvx_v2-FCLASSWQ_registerM_registerP_simple
	;;
	fclassw $r44r45.lo = $r44r45r46r47.x 	#Opcode-lvx_v2-FCLASSW_registerW_registerZ_simple
	;;
	fcompdp.one $r45 = $r52r53r54r55.hi, $r56r57 	#Opcode-lvx_v2-FCOMPDP_floatcomp_registerW_registerP_registerO_simple
	;;
	fcompdp.ueq $r44r45.hi = $r56r57r58r59.lo, 536870911 	#Opcode-lvx_v2-FCOMPDP_floatcomp_registerW_registerP_upper27_lower5_splat32_double
	;;
	fcompd.oeq $r44r45r46r47.y = $r46, $r46r47.lo 	#Opcode-lvx_v2-FCOMPD_floatcomp_registerW_registerZ_registerY_simple
	;;
	fcompd.une $r44r45r46r47.z = $r47, 536870911 	#Opcode-lvx_v2-FCOMPD_floatcomp_registerW_registerZ_upper27_lower5_double
	;;
	fcompho.olt $r46r47.hi = $r58r59, $r56r57r58r59.hi 	#Opcode-lvx_v2-FCOMPHO_floatcomp_registerW_registerP_registerO_simple
	;;
	fcompho.uge $r44r45r46r47.t = $r60r61, 536870911.@ 	#Opcode-lvx_v2-FCOMPHO_floatcomp_registerW_registerP_upper27_lower5_splat32_double
	;;
	fcomph.oge $r48 = $r48r49.lo, $r48r49r50r51.x 	#Opcode-lvx_v2-FCOMPH_floatcomp_registerW_registerZ_registerY_simple
	;;
	fcomph.ult $r49 = $r48r49.hi, 536870911 	#Opcode-lvx_v2-FCOMPH_floatcomp_registerW_registerZ_upper27_lower5_double
	;;
	fcompndp.one $r60r61r62r63.lo = $r62r63, $r60r61r62r63.hi 	#Opcode-lvx_v2-FCOMPNDP_floatcomp_registerM_registerP_registerO_simple
	;;
	fcompndp.ueq $r0r1 = $r0r1r2r3.lo, 536870911 	#Opcode-lvx_v2-FCOMPNDP_floatcomp_registerM_registerP_upper27_lower5_splat32_double
	;;
	fcompnho.oeq $r2r3 = $r0r1r2r3.hi, $r4r5 	#Opcode-lvx_v2-FCOMPNHO_floatcomp_registerM_registerP_registerO_simple
	;;
	fcompnho.une $r4r5r6r7.lo = $r6r7, 536870911.@ 	#Opcode-lvx_v2-FCOMPNHO_floatcomp_registerM_registerP_upper27_lower5_splat32_double
	;;
	fcompnwq.olt $r4r5r6r7.hi = $r8r9, $r8r9r10r11.lo 	#Opcode-lvx_v2-FCOMPNWQ_floatcomp_registerM_registerP_registerO_simple
	;;
	fcompnwq.uge $r10r11 = $r8r9r10r11.hi, 536870911 	#Opcode-lvx_v2-FCOMPNWQ_floatcomp_registerM_registerP_upper27_lower5_splat32_double
	;;
	fcompwq.oge $r48r49r50r51.y = $r12r13, $r12r13r14r15.lo 	#Opcode-lvx_v2-FCOMPWQ_floatcomp_registerW_registerP_registerO_simple
	;;
	fcompwq.ult $r50 = $r14r15, 536870911.@ 	#Opcode-lvx_v2-FCOMPWQ_floatcomp_registerW_registerP_upper27_lower5_splat32_double
	;;
	fcompw.one $r50r51.lo = $r48r49r50r51.z, $r51 	#Opcode-lvx_v2-FCOMPW_floatcomp_registerW_registerZ_registerY_simple
	;;
	fcompw.ueq $r50r51.hi = $r48r49r50r51.t, 536870911 	#Opcode-lvx_v2-FCOMPW_floatcomp_registerW_registerZ_upper27_lower5_double
	;;
	fdivd $r52 = $r52r53.lo, $r52r53r54r55.x 	#Opcode-lvx_v2-FDIVD_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fdivh.n.rn $r53 = $r52r53.hi, $r52r53r54r55.y 	#Opcode-lvx_v2-FDIVH_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fdivw.rz $r54 = $r54r55.lo, $r52r53r54r55.z 	#Opcode-lvx_v2-FDIVW_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fence 	#Opcode-lvx_v2-FENCE_accesses_simple
	;;
	fextlhwq $r12r13r14r15.hi = $r16r17 	#Opcode-lvx_v2-FEXTLHWQ_oddlanes_registerM_registerP_simple
	;;
	ffmadp.n.rd $r16r17r18r19.lo = $r18r19, $r16r17r18r19.hi 	#Opcode-lvx_v2-FFMADP_fnegate_floatmode_registerM_registerP_registerO_simple
	;;
	ffmad.ru $r55 = $r54r55.hi, $r52r53r54r55.t 	#Opcode-lvx_v2-FFMAD_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmaho.n.rm $r20r21 = $r20r21r22r23.lo, $r22r23 	#Opcode-lvx_v2-FFMAHO_fnegate_floatmode_registerM_registerP_registerO_simple
	;;
	ffmah.r5 $r56 = $r56r57.lo, $r56r57r58r59.x 	#Opcode-lvx_v2-FFMAH_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmawc.c.mi.ro $r57 = $r56r57.hi, $r56r57r58r59.y 	#Opcode-lvx_v2-FFMAWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmawq.n $r20r21r22r23.hi = $r24r25, $r24r25r26r27.lo 	#Opcode-lvx_v2-FFMAWQ_fnegate_floatmode_registerM_registerP_registerO_simple
	;;
	ffmaw.rn $r58 = $r58r59.lo, $r56r57r58r59.z 	#Opcode-lvx_v2-FFMAW_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmsdp.n.rz $r26r27 = $r24r25r26r27.hi, $r28r29 	#Opcode-lvx_v2-FFMSDP_fnegate_floatmode_registerM_registerP_registerO_simple
	;;
	ffmsd.rd $r59 = $r58r59.hi, $r56r57r58r59.t 	#Opcode-lvx_v2-FFMSD_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmsho.n.ru $r28r29r30r31.lo = $r30r31, $r28r29r30r31.hi 	#Opcode-lvx_v2-FFMSHO_fnegate_floatmode_registerM_registerP_registerO_simple
	;;
	ffmsh.rm $r60 = $r60r61.lo, $r60r61r62r63.x 	#Opcode-lvx_v2-FFMSH_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmswq.n.r5 $r32r33 = $r32r33r34r35.lo, $r34r35 	#Opcode-lvx_v2-FFMSWQ_fnegate_floatmode_registerM_registerP_registerO_simple
	;;
	ffmsw.ro $r61 = $r60r61.hi, $r60r61r62r63.y 	#Opcode-lvx_v2-FFMSW_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fixeddp $r32r33r34r35.hi = $r36r37 	#Opcode-lvx_v2-FIXEDDP_floatmode_registerM_registerP_simple
	;;
	fixeddw.rn $r62 = $r62r63.lo 	#Opcode-lvx_v2-FIXEDDW_floatmode_registerW_registerZ_simple
	;;
	fixedd.rz $r60r61r62r63.z = $r63 	#Opcode-lvx_v2-FIXEDD_floatmode_registerW_registerZ_simple
	;;
	fixedho.rd $r36r37r38r39.lo = $r38r39 	#Opcode-lvx_v2-FIXEDHO_floatmode_registerM_registerP_simple
	;;
	fixedudp.ru $r36r37r38r39.hi = $r40r41 	#Opcode-lvx_v2-FIXEDUDP_floatmode_registerM_registerP_simple
	;;
	fixedudw.rm $r62r63.hi = $r60r61r62r63.t 	#Opcode-lvx_v2-FIXEDUDW_floatmode_registerW_registerZ_simple
	;;
	fixedud.r5 $r0 = $r0r1.lo 	#Opcode-lvx_v2-FIXEDUD_floatmode_registerW_registerZ_simple
	;;
	fixeduho.ro $r40r41r42r43.lo = $r42r43 	#Opcode-lvx_v2-FIXEDUHO_floatmode_registerM_registerP_simple
	;;
	fixeduwd $r0r1r2r3.x = $r1 	#Opcode-lvx_v2-FIXEDUWD_floatmode_registerW_registerZ_simple
	;;
	fixeduwp.rn $r0r1.hi = $r0r1r2r3.y 	#Opcode-lvx_v2-FIXEDUWP_floatmode_registerW_registerZ_simple
	;;
	fixeduwq.rz $r40r41r42r43.hi = $r44r45 	#Opcode-lvx_v2-FIXEDUWQ_floatmode_registerM_registerP_simple
	;;
	fixeduw.rd $r2 = $r2r3.lo 	#Opcode-lvx_v2-FIXEDUW_floatmode_registerW_registerZ_simple
	;;
	fixedwd.ru $r0r1r2r3.z = $r3 	#Opcode-lvx_v2-FIXEDWD_floatmode_registerW_registerZ_simple
	;;
	fixedwp.rm $r2r3.hi = $r0r1r2r3.t 	#Opcode-lvx_v2-FIXEDWP_floatmode_registerW_registerZ_simple
	;;
	fixedwq.r5 $r44r45r46r47.lo = $r46r47 	#Opcode-lvx_v2-FIXEDWQ_floatmode_registerM_registerP_simple
	;;
	fixedw.ro $r4 = $r4r5.lo 	#Opcode-lvx_v2-FIXEDW_floatmode_registerW_registerZ_simple
	;;
	floatdp $r44r45r46r47.hi = $r48r49 	#Opcode-lvx_v2-FLOATDP_floatmode_registerM_registerP_simple
	;;
	floatdw.rn $r4r5r6r7.x = $r5 	#Opcode-lvx_v2-FLOATDW_floatmode_registerW_registerZ_simple
	;;
	floatd.rz $r4r5.hi = $r4r5r6r7.y 	#Opcode-lvx_v2-FLOATD_floatmode_registerW_registerZ_simple
	;;
	floatho.rd $r48r49r50r51.lo = $r50r51 	#Opcode-lvx_v2-FLOATHO_floatmode_registerM_registerP_simple
	;;
	floatudp.ru $r48r49r50r51.hi = $r52r53 	#Opcode-lvx_v2-FLOATUDP_floatmode_registerM_registerP_simple
	;;
	floatudw.rm $r6 = $r6r7.lo 	#Opcode-lvx_v2-FLOATUDW_floatmode_registerW_registerZ_simple
	;;
	floatud.r5 $r4r5r6r7.z = $r7 	#Opcode-lvx_v2-FLOATUD_floatmode_registerW_registerZ_simple
	;;
	floatuho.ro $r52r53r54r55.lo = $r54r55 	#Opcode-lvx_v2-FLOATUHO_floatmode_registerM_registerP_simple
	;;
	floatuwd $r6r7.hi = $r4r5r6r7.t 	#Opcode-lvx_v2-FLOATUWD_floatmode_registerW_registerZ_simple
	;;
	floatuwp.rn $r8 = $r8r9.lo 	#Opcode-lvx_v2-FLOATUWP_floatmode_registerW_registerZ_simple
	;;
	floatuwq.rz $r52r53r54r55.hi = $r56r57 	#Opcode-lvx_v2-FLOATUWQ_floatmode_registerM_registerP_simple
	;;
	floatuw.rd $r8r9r10r11.x = $r9 	#Opcode-lvx_v2-FLOATUW_floatmode_registerW_registerZ_simple
	;;
	floatwd.ru $r8r9.hi = $r8r9r10r11.y 	#Opcode-lvx_v2-FLOATWD_floatmode_registerW_registerZ_simple
	;;
	floatwp.rm $r10 = $r10r11.lo 	#Opcode-lvx_v2-FLOATWP_floatmode_registerW_registerZ_simple
	;;
	floatwq.r5 $r56r57r58r59.lo = $r58r59 	#Opcode-lvx_v2-FLOATWQ_floatmode_registerM_registerP_simple
	;;
	floatw.ro $r8r9r10r11.z = $r11 	#Opcode-lvx_v2-FLOATW_floatmode_registerW_registerZ_simple
	;;
	fmaxdp $r56r57r58r59.hi = $r60r61, $r60r61r62r63.lo 	#Opcode-lvx_v2-FMAXDP_registerM_registerP_registerO_simple
	;;
	fmaxd $r10r11.hi = $r8r9r10r11.t, $r12 	#Opcode-lvx_v2-FMAXD_registerW_registerZ_registerY_simple
	;;
	fmaxho $r62r63 = $r60r61r62r63.hi, $r0r1 	#Opcode-lvx_v2-FMAXHO_registerM_registerP_registerO_simple
	;;
	fmaxh $sp = $r13, $tp 	#Opcode-lvx_v2-FMAXH_registerW_registerZ_registerY_simple
	;;
	fmaxndp $r0r1r2r3.lo = $r2r3, $r0r1r2r3.hi 	#Opcode-lvx_v2-FMAXNDP_registerM_registerP_registerO_simple
	;;
	fmaxnd $r14 = $fp, $r14r15.lo 	#Opcode-lvx_v2-FMAXND_registerW_registerZ_registerY_simple
	;;
	fmaxnho $r4r5 = $r4r5r6r7.lo, $r6r7 	#Opcode-lvx_v2-FMAXNHO_registerM_registerP_registerO_simple
	;;
	fmaxnh $r15 = $rp, $r14r15.hi 	#Opcode-lvx_v2-FMAXNH_registerW_registerZ_registerY_simple
	;;
	fmaxnwq $r4r5r6r7.hi = $r8r9, $r8r9r10r11.lo 	#Opcode-lvx_v2-FMAXNWQ_registerM_registerP_registerO_simple
	;;
	fmaxnw $r16 = $r16r17.lo, $r16r17r18r19.x 	#Opcode-lvx_v2-FMAXNW_registerW_registerZ_registerY_simple
	;;
	fmaxwq $r10r11 = $r8r9r10r11.hi, $r12r13 	#Opcode-lvx_v2-FMAXWQ_registerM_registerP_registerO_simple
	;;
	fmaxw $r17 = $r16r17.hi, $r16r17r18r19.y 	#Opcode-lvx_v2-FMAXW_registerW_registerZ_registerY_simple
	;;
	fmindp $r12r13r14r15.lo = $r14r15, $r12r13r14r15.hi 	#Opcode-lvx_v2-FMINDP_registerM_registerP_registerO_simple
	;;
	fmind $r18 = $r18r19.lo, $r16r17r18r19.z 	#Opcode-lvx_v2-FMIND_registerW_registerZ_registerY_simple
	;;
	fminho $r16r17 = $r16r17r18r19.lo, $r18r19 	#Opcode-lvx_v2-FMINHO_registerM_registerP_registerO_simple
	;;
	fminh $r19 = $r18r19.hi, $r16r17r18r19.t 	#Opcode-lvx_v2-FMINH_registerW_registerZ_registerY_simple
	;;
	fminndp $r16r17r18r19.hi = $r20r21, $r20r21r22r23.lo 	#Opcode-lvx_v2-FMINNDP_registerM_registerP_registerO_simple
	;;
	fminnd $r20 = $r20r21.lo, $r20r21r22r23.x 	#Opcode-lvx_v2-FMINND_registerW_registerZ_registerY_simple
	;;
	fminnho $r22r23 = $r20r21r22r23.hi, $r24r25 	#Opcode-lvx_v2-FMINNHO_registerM_registerP_registerO_simple
	;;
	fminnh $r21 = $r20r21.hi, $r20r21r22r23.y 	#Opcode-lvx_v2-FMINNH_registerW_registerZ_registerY_simple
	;;
	fminnwq $r24r25r26r27.lo = $r26r27, $r24r25r26r27.hi 	#Opcode-lvx_v2-FMINNWQ_registerM_registerP_registerO_simple
	;;
	fminnw $r22 = $r22r23.lo, $r20r21r22r23.z 	#Opcode-lvx_v2-FMINNW_registerW_registerZ_registerY_simple
	;;
	fminwq $r28r29 = $r28r29r30r31.lo, $r30r31 	#Opcode-lvx_v2-FMINWQ_registerM_registerP_registerO_simple
	;;
	fminw $r23 = $r22r23.hi, $r20r21r22r23.t 	#Opcode-lvx_v2-FMINW_registerW_registerZ_registerY_simple
	;;
	fmuldp.n $r28r29r30r31.hi = $r32r33, $r32r33r34r35.lo 	#Opcode-lvx_v2-FMULDP_fnegate_floatmode_registerM_registerP_registerO_simple
	;;
	fmuld.rn $r24 = $r24r25.lo, $r24r25r26r27.x 	#Opcode-lvx_v2-FMULD_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fmulho.n.rz $r34r35 = $r32r33r34r35.hi, $r36r37 	#Opcode-lvx_v2-FMULHO_fnegate_floatmode_registerM_registerP_registerO_simple
	;;
	fmulh.rd $r25 = $r24r25.hi, $r24r25r26r27.y 	#Opcode-lvx_v2-FMULH_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fmulwc.ru $r26 = $r26r27.lo, $r24r25r26r27.z 	#Opcode-lvx_v2-FMULWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple
	;;
	fmulwq.n.rm $r36r37r38r39.lo = $r38r39, $r36r37r38r39.hi 	#Opcode-lvx_v2-FMULWQ_fnegate_floatmode_registerM_registerP_registerO_simple
	;;
	fmulw.r5 $r27 = $r26r27.hi, $r24r25r26r27.t 	#Opcode-lvx_v2-FMULW_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fnarrowdwq.ro $r28 = $r40r41 	#Opcode-lvx_v2-FNARROWDWQ_floatmode_registerW_registerP_simple
	;;
	fnarrowdw $r28r29.lo = $r28r29r30r31.x 	#Opcode-lvx_v2-FNARROWDW_floatmode_registerW_registerZ_simple
	;;
	fnarrowwhq.rn $r29 = $r40r41r42r43.lo 	#Opcode-lvx_v2-FNARROWWHQ_ziplanes_floatmode_registerW_registerP_simple
	;;
	fnarrowwh.rz $r28r29.hi = $r28r29r30r31.y 	#Opcode-lvx_v2-FNARROWWH_floatmode_registerW_registerZ_simple
	;;
	fnegdp $r42r43 = $r40r41r42r43.hi 	#Opcode-lvx_v2-FNEGDP_registerM_registerP_simple
	;;
	fnegd $r30 = $r30r31.lo 	#Opcode-lvx_v2-FNEGD_registerW_registerZ_simple
	;;
	fnegho $r44r45 = $r44r45r46r47.lo 	#Opcode-lvx_v2-FNEGHO_registerM_registerP_simple
	;;
	fnegh $r28r29r30r31.z = $r31 	#Opcode-lvx_v2-FNEGH_registerW_registerZ_simple
	;;
	fnegwp $r30r31.hi = $r28r29r30r31.t 	#Opcode-lvx_v2-FNEGWP_registerW_registerZ_simple
	;;
	fnegwq $r46r47 = $r44r45r46r47.hi 	#Opcode-lvx_v2-FNEGWQ_registerM_registerP_simple
	;;
	fnegw $r32 = $r32r33.lo 	#Opcode-lvx_v2-FNEGW_registerW_registerZ_simple
	;;
	fractdwq.z $r48r49 = $r20r21r22r23 	#Opcode-lvx_v2-FRACTDWQ_ziplanes_registerM_registerR_simple
	;;
	fracthbx $r48r49r50r51.lo = $r50r51 	#Opcode-lvx_v2-FRACTHBX_ziplanes_registerM_registerP_simple
	;;
	fractwho.z $r48r49r50r51.hi = $r52r53 	#Opcode-lvx_v2-FRACTWHO_ziplanes_registerM_registerP_simple
	;;
	frintd.rd $r32r33r34r35.x = $r33 	#Opcode-lvx_v2-FRINTD_floatmode_registerW_registerZ_simple
	;;
	frinth.ru $r32r33.hi = $r32r33r34r35.y 	#Opcode-lvx_v2-FRINTH_floatmode_registerW_registerZ_simple
	;;
	frintw.rm $r34 = $r34r35.lo 	#Opcode-lvx_v2-FRINTW_floatmode_registerW_registerZ_simple
	;;
	fsbfdp.r5 $r52r53r54r55.lo = $r54r55, $r52r53r54r55.hi 	#Opcode-lvx_v2-FSBFDP_floatmode_registerM_registerP_registerO_simple
	;;
	fsbfd.ro $r32r33r34r35.z = $r35, $r34r35.hi 	#Opcode-lvx_v2-FSBFD_floatmode_registerW_registerZ_registerY_simple
	;;
	fsbfho $r56r57 = $r56r57r58r59.lo, $r58r59 	#Opcode-lvx_v2-FSBFHO_floatmode_registerM_registerP_registerO_simple
	;;
	fsbfh.rn $r32r33r34r35.t = $r36, $r36r37.lo 	#Opcode-lvx_v2-FSBFH_floatmode_registerW_registerZ_registerY_simple
	;;
	fsbfwc.c.mi.rz $r36r37r38r39.x = $r37, $r36r37.hi 	#Opcode-lvx_v2-FSBFWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple
	;;
	fsbfwq.rd $r56r57r58r59.hi = $r60r61, $r60r61r62r63.lo 	#Opcode-lvx_v2-FSBFWQ_floatmode_registerM_registerP_registerO_simple
	;;
	fsbfw.ru $r36r37r38r39.y = $r38, $r38r39.lo 	#Opcode-lvx_v2-FSBFW_floatmode_registerW_registerZ_registerY_simple
	;;
	fsigndp $r62r63 = $r60r61r62r63.hi, $r0r1 	#Opcode-lvx_v2-FSIGNDP_registerM_registerP_registerO_simple
	;;
	fsignd $r36r37r38r39.z = $r39, $r38r39.hi 	#Opcode-lvx_v2-FSIGND_registerW_registerZ_registerY_simple
	;;
	fsignho $r0r1r2r3.lo = $r2r3, $r0r1r2r3.hi 	#Opcode-lvx_v2-FSIGNHO_registerM_registerP_registerO_simple
	;;
	fsignh $r36r37r38r39.t = $r40, $r40r41.lo 	#Opcode-lvx_v2-FSIGNH_registerW_registerZ_registerY_simple
	;;
	fsignmdp $r4r5 = $r4r5r6r7.lo, $r6r7 	#Opcode-lvx_v2-FSIGNMDP_registerM_registerP_registerO_simple
	;;
	fsignmd $r40r41r42r43.x = $r41, $r40r41.hi 	#Opcode-lvx_v2-FSIGNMD_registerW_registerZ_registerY_simple
	;;
	fsignmho $r4r5r6r7.hi = $r8r9, $r8r9r10r11.lo 	#Opcode-lvx_v2-FSIGNMHO_registerM_registerP_registerO_simple
	;;
	fsignmh $r40r41r42r43.y = $r42, $r42r43.lo 	#Opcode-lvx_v2-FSIGNMH_registerW_registerZ_registerY_simple
	;;
	fsignmwq $r10r11 = $r8r9r10r11.hi, $r12r13 	#Opcode-lvx_v2-FSIGNMWQ_registerM_registerP_registerO_simple
	;;
	fsignmw $r40r41r42r43.z = $r43, $r42r43.hi 	#Opcode-lvx_v2-FSIGNMW_registerW_registerZ_registerY_simple
	;;
	fsignndp $r12r13r14r15.lo = $r14r15, $r12r13r14r15.hi 	#Opcode-lvx_v2-FSIGNNDP_registerM_registerP_registerO_simple
	;;
	fsignnd $r40r41r42r43.t = $r44, $r44r45.lo 	#Opcode-lvx_v2-FSIGNND_registerW_registerZ_registerY_simple
	;;
	fsignnho $r16r17 = $r16r17r18r19.lo, $r18r19 	#Opcode-lvx_v2-FSIGNNHO_registerM_registerP_registerO_simple
	;;
	fsignnh $r44r45r46r47.x = $r45, $r44r45.hi 	#Opcode-lvx_v2-FSIGNNH_registerW_registerZ_registerY_simple
	;;
	fsignnwq $r16r17r18r19.hi = $r20r21, $r20r21r22r23.lo 	#Opcode-lvx_v2-FSIGNNWQ_registerM_registerP_registerO_simple
	;;
	fsignnw $r44r45r46r47.y = $r46, $r46r47.lo 	#Opcode-lvx_v2-FSIGNNW_registerW_registerZ_registerY_simple
	;;
	fsignwq $r22r23 = $r20r21r22r23.hi, $r24r25 	#Opcode-lvx_v2-FSIGNWQ_registerM_registerP_registerO_simple
	;;
	fsignw $r44r45r46r47.z = $r47, $r46r47.hi 	#Opcode-lvx_v2-FSIGNW_registerW_registerZ_registerY_simple
	;;
	fsqrtd.rm $r44r45r46r47.t = $r48 	#Opcode-lvx_v2-FSQRTD_floatmode_registerW_registerZ_simple
	;;
	fsqrth.r5 $r48r49.lo = $r48r49r50r51.x 	#Opcode-lvx_v2-FSQRTH_floatmode_registerW_registerZ_simple
	;;
	fsqrtw.ro $r49 = $r48r49.hi 	#Opcode-lvx_v2-FSQRTW_floatmode_registerW_registerZ_simple
	;;
	fsrecd $r48r49r50r51.y = $r50 	#Opcode-lvx_v2-FSRECD_registerW_registerZ_simple
	;;
	fsrecwp $r50r51.lo = $r48r49r50r51.z 	#Opcode-lvx_v2-FSRECWP_registerW_registerZ_simple
	;;
	fsrecwq $r24r25r26r27.lo = $r26r27 	#Opcode-lvx_v2-FSRECWQ_registerM_registerP_simple
	;;
	fsrecw $r51 = $r50r51.hi 	#Opcode-lvx_v2-FSRECW_registerW_registerZ_simple
	;;
	fsrsrd $r48r49r50r51.t = $r52 	#Opcode-lvx_v2-FSRSRD_registerW_registerZ_simple
	;;
	fsrsrwp $r52r53.lo = $r52r53r54r55.x 	#Opcode-lvx_v2-FSRSRWP_registerW_registerZ_simple
	;;
	fsrsrwq $r24r25r26r27.hi = $r28r29 	#Opcode-lvx_v2-FSRSRWQ_registerM_registerP_simple
	;;
	fsrsrw $r53 = $r52r53.hi 	#Opcode-lvx_v2-FSRSRW_registerW_registerZ_simple
	;;
	fwidenhwq $r28r29r30r31.lo = $r30r31 	#Opcode-lvx_v2-FWIDENHWQ_mostsig_registerM_registerP_simple
	;;
	fwidenhw.m $r52r53r54r55.y = $r54 	#Opcode-lvx_v2-FWIDENHW_mostsig_registerW_registerZ_simple
	;;
	fwidenwdp $r28r29r30r31.hi = $r32r33 	#Opcode-lvx_v2-FWIDENWDP_mostsig_registerM_registerP_simple
	;;
	fwidenwd.m $r54r55.lo = $r52r53r54r55.z 	#Opcode-lvx_v2-FWIDENWD_mostsig_registerW_registerZ_simple
	;;
	get $r55 = $pc 	#Opcode-lvx_v2-GET_registerZ_systemS2_simple
	;;
	get $r54r55.hi = $pc 	#Opcode-lvx_v2-GET_registerZ_systemS3_simple
	;;
	gotox -4503599627370496 	#Opcode-lvx_v2-GOTOX_upper27_lower27_double
	;;
	goto -33554432 	#Opcode-lvx_v2-GOTO_pcrel27s2_simple
	;;
	guard.dnez $r52r53r54r55.t? 7 	#Opcode-lvx_v2-GUARD_execpred_registerZ_activate_simple
	;;
	i1invals 2305843009213693951[$r56] 	#Opcode-lvx_v2-I1INVALS_extend27_upper27_lower10_registerZ_triple
	;;
	i1invals $r56r57.lo[$r56r57r58r59.x] 	#Opcode-lvx_v2-I1INVALS_registerY_registerZ_simple
	;;
	i1invals -64[$r57] 	#Opcode-lvx_v2-I1INVALS_signed10_registerZ_simple
	;;
	i1invals -8589934592[$r56r57.hi] 	#Opcode-lvx_v2-I1INVALS_upper27_lower10_registerZ_double
	;;
	i1inval 	#Opcode-lvx_v2-I1INVAL_simple
	;;
	icall $r56r57r58r59.y 	#Opcode-lvx_v2-ICALL_registerZ_simple
	;;
	iget $r58 	#Opcode-lvx_v2-IGET_registerZ_simple
	;;
	igoto $r58r59.lo 	#Opcode-lvx_v2-IGOTO_registerZ_simple
	;;
	insf $r56r57r58r59.z = $r59, 7, 7 	#Opcode-lvx_v2-INSF_registerW_registerZ_stopbit2_stopbit4_startbit_simple
	;;
	iord $r58r59.hi = $r56r57r58r59.t, 2305843009213693951 	#Opcode-lvx_v2-IORD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	iord $r60 = $r60r61.lo, $r60r61r62r63.x 	#Opcode-lvx_v2-IORD_registerW_registerZ_registerY_simple
	;;
	iord $r61 = $r60r61.hi, -64 	#Opcode-lvx_v2-IORD_registerW_registerZ_signed10_simple
	;;
	iord $r60r61r62r63.y = $r62, -8589934592 	#Opcode-lvx_v2-IORD_registerW_registerZ_upper27_lower10_double
	;;
	iornd $r62r63.lo = $r60r61r62r63.z, 2305843009213693951 	#Opcode-lvx_v2-IORND_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	iornd $r63 = $r62r63.hi, $r60r61r62r63.t 	#Opcode-lvx_v2-IORND_registerW_registerZ_registerY_simple
	;;
	iornd $r0 = $r0r1.lo, -64 	#Opcode-lvx_v2-IORND_registerW_registerZ_signed10_simple
	;;
	iornd $r0r1r2r3.x = $r1, -8589934592 	#Opcode-lvx_v2-IORND_registerW_registerZ_upper27_lower10_double
	;;
	iornq $r32r33r34r35.lo = $r34r35, $r32r33r34r35.hi 	#Opcode-lvx_v2-IORNQ_registerM_registerP_registerO_simple
	;;
	iornq $r36r37 = $r36r37r38r39.lo, 536870911 	#Opcode-lvx_v2-IORNQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	iornw.sx $r0r1.hi = $r0r1r2r3.y, $r2 	#Opcode-lvx_v2-IORNW_signextw_registerW_registerZ_registerY_simple
	;;
	iornw $r2r3.lo = $r0r1r2r3.z, 536870911 	#Opcode-lvx_v2-IORNW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	iorq $r38r39 = $r36r37r38r39.hi, $r40r41 	#Opcode-lvx_v2-IORQ_registerM_registerP_registerO_simple
	;;
	iorq $r40r41r42r43.lo = $r42r43, 536870911.@ 	#Opcode-lvx_v2-IORQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	iorw.sx $r3 = $r2r3.hi, $r0r1r2r3.t 	#Opcode-lvx_v2-IORW_signextw_registerW_registerZ_registerY_simple
	;;
	iorw $r4 = $r4r5.lo, 536870911 	#Opcode-lvx_v2-IORW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	landd $r4r5r6r7.x = $r5, $r4r5.hi 	#Opcode-lvx_v2-LANDD_registerW_registerZ_registerY_simple
	;;
	landw $r4r5r6r7.y = $r6, $r6r7.lo 	#Opcode-lvx_v2-LANDW_registerW_registerZ_registerY_simple
	;;
	lbs $r4r5r6r7.z = 2305843009213693951[$r7] 	#Opcode-lvx_v2-LBS_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lbs.s $r6r7.hi = $r4r5r6r7.t[$r8] 	#Opcode-lvx_v2-LBS_variant_registerW_registerY_registerZ_simple
	;;
	lbs.u $r8r9.lo = -64[$r8r9r10r11.x] 	#Opcode-lvx_v2-LBS_variant_registerW_signed10_registerZ_simple
	;;
	lbs.us $r9 = -8589934592[$r8r9.hi] 	#Opcode-lvx_v2-LBS_variant_registerW_upper27_lower10_registerZ_double
	;;
	lbz $r8r9r10r11.y = 2305843009213693951[$r10] 	#Opcode-lvx_v2-LBZ_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lbz.s $r10r11.lo = $r8r9r10r11.z[$r11] 	#Opcode-lvx_v2-LBZ_variant_registerW_registerY_registerZ_simple
	;;
	lbz.u $r10r11.hi = -64[$r8r9r10r11.t] 	#Opcode-lvx_v2-LBZ_variant_registerW_signed10_registerZ_simple
	;;
	lbz.us $r12 = -8589934592[$sp] 	#Opcode-lvx_v2-LBZ_variant_registerW_upper27_lower10_registerZ_double
	;;
	ld $r13 = 2305843009213693951[$tp] 	#Opcode-lvx_v2-LD_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	ld.s $r14 = $fp[$r14r15.lo] 	#Opcode-lvx_v2-LD_variant_registerW_registerY_registerZ_simple
	;;
	ld.u $r15 = -64[$rp] 	#Opcode-lvx_v2-LD_variant_registerW_signed10_registerZ_simple
	;;
	ld.us $r14r15.hi = -8589934592[$r16] 	#Opcode-lvx_v2-LD_variant_registerW_upper27_lower10_registerZ_double
	;;
	lhs $r16r17.lo = 2305843009213693951[$r16r17r18r19.x] 	#Opcode-lvx_v2-LHS_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lhs.s $r17 = $r16r17.hi[$r16r17r18r19.y] 	#Opcode-lvx_v2-LHS_variant_registerW_registerY_registerZ_simple
	;;
	lhs.u $r18 = -64[$r18r19.lo] 	#Opcode-lvx_v2-LHS_variant_registerW_signed10_registerZ_simple
	;;
	lhs.us $r16r17r18r19.z = -8589934592[$r19] 	#Opcode-lvx_v2-LHS_variant_registerW_upper27_lower10_registerZ_double
	;;
	lhz $r18r19.hi = 2305843009213693951[$r16r17r18r19.t] 	#Opcode-lvx_v2-LHZ_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lhz.s $r20 = $r20r21.lo[$r20r21r22r23.x] 	#Opcode-lvx_v2-LHZ_variant_registerW_registerY_registerZ_simple
	;;
	lhz.u $r21 = -64[$r20r21.hi] 	#Opcode-lvx_v2-LHZ_variant_registerW_signed10_registerZ_simple
	;;
	lhz.us $r20r21r22r23.y = -8589934592[$r22] 	#Opcode-lvx_v2-LHZ_variant_registerW_upper27_lower10_registerZ_double
	;;
	liord $r22r23.lo = $r20r21r22r23.z, $r23 	#Opcode-lvx_v2-LIORD_registerW_registerZ_registerY_simple
	;;
	liorw $r22r23.hi = $r20r21r22r23.t, $r24 	#Opcode-lvx_v2-LIORW_registerW_registerZ_registerY_simple
	;;
	lnandd $r24r25.lo = $r24r25r26r27.x, $r25 	#Opcode-lvx_v2-LNANDD_registerW_registerZ_registerY_simple
	;;
	lnandw $r24r25.hi = $r24r25r26r27.y, $r26 	#Opcode-lvx_v2-LNANDW_registerW_registerZ_registerY_simple
	;;
	lniord $r26r27.lo = $r24r25r26r27.z, $r27 	#Opcode-lvx_v2-LNIORD_registerW_registerZ_registerY_simple
	;;
	lniorw $r26r27.hi = $r24r25r26r27.t, $r28 	#Opcode-lvx_v2-LNIORW_registerW_registerZ_registerY_simple
	;;
	loopdo $r28r29.lo, -32768 	#Opcode-lvx_v2-LOOPDO_registerZ_pcrel17s2_simple
	;;
	lo $r24r25r26r27 = 2305843009213693951[$r28r29r30r31.x] 	#Opcode-lvx_v2-LO_variant_registerN_extend27_upper27_lower10_registerZ_triple
	;;
	lo.s $r28r29r30r31 = $r29[$r28r29.hi] 	#Opcode-lvx_v2-LO_variant_registerN_registerY_registerZ_simple
	;;
	lo.u $r32r33r34r35 = -64[$r28r29r30r31.y] 	#Opcode-lvx_v2-LO_variant_registerN_signed10_registerZ_simple
	;;
	lo.us $r36r37r38r39 = -8589934592[$r30] 	#Opcode-lvx_v2-LO_variant_registerN_upper27_lower10_registerZ_double
	;;
	lq $r40r41r42r43.hi = 2305843009213693951[$r30r31.lo] 	#Opcode-lvx_v2-LQ_variant_registerM_extend27_upper27_lower10_registerZ_triple
	;;
	lq.s $r44r45 = $r28r29r30r31.z[$r31] 	#Opcode-lvx_v2-LQ_variant_registerM_registerY_registerZ_simple
	;;
	lq.u $r44r45r46r47.lo = -64[$r30r31.hi] 	#Opcode-lvx_v2-LQ_variant_registerM_signed10_registerZ_simple
	;;
	lq.us $r46r47 = -8589934592[$r28r29r30r31.t] 	#Opcode-lvx_v2-LQ_variant_registerM_upper27_lower10_registerZ_double
	;;
	lws $r32 = 2305843009213693951[$r32r33.lo] 	#Opcode-lvx_v2-LWS_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lws.s $r32r33r34r35.x = $r33[$r32r33.hi] 	#Opcode-lvx_v2-LWS_variant_registerW_registerY_registerZ_simple
	;;
	lws.u $r32r33r34r35.y = -64[$r34] 	#Opcode-lvx_v2-LWS_variant_registerW_signed10_registerZ_simple
	;;
	lws.us $r34r35.lo = -8589934592[$r32r33r34r35.z] 	#Opcode-lvx_v2-LWS_variant_registerW_upper27_lower10_registerZ_double
	;;
	lwz $r35 = 2305843009213693951[$r34r35.hi] 	#Opcode-lvx_v2-LWZ_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lwz.s $r32r33r34r35.t = $r36[$r36r37.lo] 	#Opcode-lvx_v2-LWZ_variant_registerW_registerY_registerZ_simple
	;;
	lwz.u $r36r37r38r39.x = -64[$r37] 	#Opcode-lvx_v2-LWZ_variant_registerW_signed10_registerZ_simple
	;;
	lwz.us $r36r37.hi = -8589934592[$r36r37r38r39.y] 	#Opcode-lvx_v2-LWZ_variant_registerW_upper27_lower10_registerZ_double
	;;
	maddbho $r44r45r46r47.hi = $r0, $r0r1.lo 	#Opcode-lvx_v2-MADDBHO_widemult_registerM_registerZe_registerYe_simple
	;;
	maddbho.u $r48r49 = $r1, $r0r1.hi 	#Opcode-lvx_v2-MADDBHO_widemult_registerM_registerZo_registerYo_simple
	;;
	madddp $r48r49r50r51.lo = $r50r51, $r48r49r50r51.hi 	#Opcode-lvx_v2-MADDDP_highmult_registerM_registerP_registerO_simple
	;;
	madddq.su $r52r53 = $r38, $r38r39.lo 	#Opcode-lvx_v2-MADDDQ_widemult_registerM_registerZ_registerY_simple
	;;
	madddt $r52r53r54r55.lo = $r36r37r38r39.z, $r39 	#Opcode-lvx_v2-MADDDT_registerM_registerZ_registerY_simple
	;;
	maddd.h $r38r39.hi = $r36r37r38r39.t, $r40 	#Opcode-lvx_v2-MADDD_highmult_registerW_registerZ_registerY_simple
	;;
	maddd.hu $r40r41.lo = $r40r41r42r43.x, 536870911 	#Opcode-lvx_v2-MADDD_highmult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	maddhwq $r54r55 = $r0r1r2r3.x, $r2 	#Opcode-lvx_v2-MADDHWQ_widemult_registerM_registerZe_registerYe_simple
	;;
	maddhwq.u $r52r53r54r55.hi = $r0r1r2r3.y, $r3 	#Opcode-lvx_v2-MADDHWQ_widemult_registerM_registerZo_registerYo_simple
	;;
	maddsudt $r56r57 = $r41, $r40r41.hi 	#Opcode-lvx_v2-MADDSUDT_registerM_registerZ_registerY_simple
	;;
	maddsuwd $r40r41r42r43.y = $r42, $r42r43.lo 	#Opcode-lvx_v2-MADDSUWD_registerW_registerZ_registerY_simple
	;;
	maddsuwd $r40r41r42r43.z = $r43, 536870911 	#Opcode-lvx_v2-MADDSUWD_registerW_registerZ_upper27_lower5_double
	;;
	maddudt $r56r57r58r59.lo = $r42r43.hi, $r40r41r42r43.t 	#Opcode-lvx_v2-MADDUDT_registerM_registerZ_registerY_simple
	;;
	madduwd $r44 = $r44r45.lo, $r44r45r46r47.x 	#Opcode-lvx_v2-MADDUWD_registerW_registerZ_registerY_simple
	;;
	madduwd $r45 = $r44r45.hi, 536870911 	#Opcode-lvx_v2-MADDUWD_registerW_registerZ_upper27_lower5_double
	;;
	maddwdp.su $r58r59 = $r2r3.lo, $r0r1r2r3.z 	#Opcode-lvx_v2-MADDWDP_widemult_registerM_registerZe_registerYe_simple
	;;
	maddwdp $r56r57r58r59.hi = $r2r3.hi, $r0r1r2r3.t 	#Opcode-lvx_v2-MADDWDP_widemult_registerM_registerZo_registerYo_simple
	;;
	maddwd.u $r44r45r46r47.y = $r46, $r46r47.lo 	#Opcode-lvx_v2-MADDWD_widemult_registerW_registerZ_registerY_simple
	;;
	maddwd.su $r44r45r46r47.z = $r47, 536870911.@ 	#Opcode-lvx_v2-MADDWD_widemult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	maddw.hsu.sx $r46r47.hi = $r44r45r46r47.t, $r48 	#Opcode-lvx_v2-MADDW_highmult_signextw_registerW_registerZ_registerY_simple
	;;
	maddw $r48r49.lo = $r48r49r50r51.x, 536870911 	#Opcode-lvx_v2-MADDW_highmult_signextw_registerW_registerZ_upper27_lower5_double
	;;
	maddxbho.o $r60r61 = $r60r61r62r63.lo, $r62r63 	#Opcode-lvx_v2-MADDXBHO_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	maddxhwq.u $r60r61r62r63.hi = $r0r1, $r0r1r2r3.lo 	#Opcode-lvx_v2-MADDXHWQ_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	maddxwdp.o.su $r2r3 = $r0r1r2r3.hi, $r4r5 	#Opcode-lvx_v2-MADDXWDP_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	make $r49 = 2305843009213693951 	#Opcode-lvx_v2-MAKE_registerW_extend27_upper27_lower10_triple
	;;
	make $r48r49.hi = -549755813888 	#Opcode-lvx_v2-MAKE_registerW_extend6_upper27_lower10_double
	;;
	make $r48r49r50r51.y = -4096 	#Opcode-lvx_v2-MAKE_registerW_signed16_simple
	;;
	maxbx $r4r5r6r7.lo = $r6r7, $r4r5r6r7.hi 	#Opcode-lvx_v2-MAXBX_registerM_registerP_registerO_simple
	;;
	maxbx $r8r9 = $r8r9r10r11.lo, 536870911 	#Opcode-lvx_v2-MAXBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	maxdp $r10r11 = $r8r9r10r11.hi, $r12r13 	#Opcode-lvx_v2-MAXDP_registerM_registerP_registerO_simple
	;;
	maxdp $r12r13r14r15.lo = $r14r15, 536870911.@ 	#Opcode-lvx_v2-MAXDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	maxd $r50 = $r50r51.lo, 2305843009213693951 	#Opcode-lvx_v2-MAXD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	maxd $r48r49r50r51.z = $r51, $r50r51.hi 	#Opcode-lvx_v2-MAXD_registerW_registerZ_registerY_simple
	;;
	maxd $r48r49r50r51.t = $r52, -64 	#Opcode-lvx_v2-MAXD_registerW_registerZ_signed10_simple
	;;
	maxd $r52r53.lo = $r52r53r54r55.x, -8589934592 	#Opcode-lvx_v2-MAXD_registerW_registerZ_upper27_lower10_double
	;;
	maxho $r12r13r14r15.hi = $r16r17, $r16r17r18r19.lo 	#Opcode-lvx_v2-MAXHO_registerM_registerP_registerO_simple
	;;
	maxho $r18r19 = $r16r17r18r19.hi, 536870911 	#Opcode-lvx_v2-MAXHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	maxubx $r20r21 = $r20r21r22r23.lo, $r22r23 	#Opcode-lvx_v2-MAXUBX_registerM_registerP_registerO_simple
	;;
	maxubx $r20r21r22r23.hi = $r24r25, 536870911.@ 	#Opcode-lvx_v2-MAXUBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	maxudp $r24r25r26r27.lo = $r26r27, $r24r25r26r27.hi 	#Opcode-lvx_v2-MAXUDP_registerM_registerP_registerO_simple
	;;
	maxudp $r28r29 = $r28r29r30r31.lo, 536870911 	#Opcode-lvx_v2-MAXUDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	maxud $r53 = $r52r53.hi, 2305843009213693951 	#Opcode-lvx_v2-MAXUD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	maxud $r52r53r54r55.y = $r54, $r54r55.lo 	#Opcode-lvx_v2-MAXUD_registerW_registerZ_registerY_simple
	;;
	maxud $r52r53r54r55.z = $r55, -64 	#Opcode-lvx_v2-MAXUD_registerW_registerZ_signed10_simple
	;;
	maxud $r54r55.hi = $r52r53r54r55.t, -8589934592 	#Opcode-lvx_v2-MAXUD_registerW_registerZ_upper27_lower10_double
	;;
	maxuho $r30r31 = $r28r29r30r31.hi, $r32r33 	#Opcode-lvx_v2-MAXUHO_registerM_registerP_registerO_simple
	;;
	maxuho $r32r33r34r35.lo = $r34r35, 536870911.@ 	#Opcode-lvx_v2-MAXUHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	maxuwq $r32r33r34r35.hi = $r36r37, $r36r37r38r39.lo 	#Opcode-lvx_v2-MAXUWQ_registerM_registerP_registerO_simple
	;;
	maxuwq $r38r39 = $r36r37r38r39.hi, 536870911 	#Opcode-lvx_v2-MAXUWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	maxuw.sx $r56 = $r56r57.lo, $r56r57r58r59.x 	#Opcode-lvx_v2-MAXUW_signextw_registerW_registerZ_registerY_simple
	;;
	maxuw $r57 = $r56r57.hi, 536870911 	#Opcode-lvx_v2-MAXUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	maxwq $r40r41 = $r40r41r42r43.lo, $r42r43 	#Opcode-lvx_v2-MAXWQ_registerM_registerP_registerO_simple
	;;
	maxwq $r40r41r42r43.hi = $r44r45, 536870911.@ 	#Opcode-lvx_v2-MAXWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	maxw.sx $r56r57r58r59.y = $r58, $r58r59.lo 	#Opcode-lvx_v2-MAXW_signextw_registerW_registerZ_registerY_simple
	;;
	maxw $r56r57r58r59.z = $r59, 536870911 	#Opcode-lvx_v2-MAXW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	minbx $r44r45r46r47.lo = $r46r47, $r44r45r46r47.hi 	#Opcode-lvx_v2-MINBX_registerM_registerP_registerO_simple
	;;
	minbx $r48r49 = $r48r49r50r51.lo, 536870911 	#Opcode-lvx_v2-MINBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	mindp $r50r51 = $r48r49r50r51.hi, $r52r53 	#Opcode-lvx_v2-MINDP_registerM_registerP_registerO_simple
	;;
	mindp $r52r53r54r55.lo = $r54r55, 536870911.@ 	#Opcode-lvx_v2-MINDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	mind $r58r59.hi = $r56r57r58r59.t, 2305843009213693951 	#Opcode-lvx_v2-MIND_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	mind $r60 = $r60r61.lo, $r60r61r62r63.x 	#Opcode-lvx_v2-MIND_registerW_registerZ_registerY_simple
	;;
	mind $r61 = $r60r61.hi, -64 	#Opcode-lvx_v2-MIND_registerW_registerZ_signed10_simple
	;;
	mind $r60r61r62r63.y = $r62, -8589934592 	#Opcode-lvx_v2-MIND_registerW_registerZ_upper27_lower10_double
	;;
	minho $r52r53r54r55.hi = $r56r57, $r56r57r58r59.lo 	#Opcode-lvx_v2-MINHO_registerM_registerP_registerO_simple
	;;
	minho $r58r59 = $r56r57r58r59.hi, 536870911 	#Opcode-lvx_v2-MINHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	minubx $r60r61 = $r60r61r62r63.lo, $r62r63 	#Opcode-lvx_v2-MINUBX_registerM_registerP_registerO_simple
	;;
	minubx $r60r61r62r63.hi = $r0r1, 536870911.@ 	#Opcode-lvx_v2-MINUBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	minudp $r0r1r2r3.lo = $r2r3, $r0r1r2r3.hi 	#Opcode-lvx_v2-MINUDP_registerM_registerP_registerO_simple
	;;
	minudp $r4r5 = $r4r5r6r7.lo, 536870911 	#Opcode-lvx_v2-MINUDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	minud $r62r63.lo = $r60r61r62r63.z, 2305843009213693951 	#Opcode-lvx_v2-MINUD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	minud $r63 = $r62r63.hi, $r60r61r62r63.t 	#Opcode-lvx_v2-MINUD_registerW_registerZ_registerY_simple
	;;
	minud $r0 = $r0r1.lo, -64 	#Opcode-lvx_v2-MINUD_registerW_registerZ_signed10_simple
	;;
	minud $r0r1r2r3.x = $r1, -8589934592 	#Opcode-lvx_v2-MINUD_registerW_registerZ_upper27_lower10_double
	;;
	minuho $r6r7 = $r4r5r6r7.hi, $r8r9 	#Opcode-lvx_v2-MINUHO_registerM_registerP_registerO_simple
	;;
	minuho $r8r9r10r11.lo = $r10r11, 536870911.@ 	#Opcode-lvx_v2-MINUHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	minuwq $r8r9r10r11.hi = $r12r13, $r12r13r14r15.lo 	#Opcode-lvx_v2-MINUWQ_registerM_registerP_registerO_simple
	;;
	minuwq $r14r15 = $r12r13r14r15.hi, 536870911 	#Opcode-lvx_v2-MINUWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	minuw.sx $r0r1.hi = $r0r1r2r3.y, $r2 	#Opcode-lvx_v2-MINUW_signextw_registerW_registerZ_registerY_simple
	;;
	minuw $r2r3.lo = $r0r1r2r3.z, 536870911 	#Opcode-lvx_v2-MINUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	minwq $r16r17 = $r16r17r18r19.lo, $r18r19 	#Opcode-lvx_v2-MINWQ_registerM_registerP_registerO_simple
	;;
	minwq $r16r17r18r19.hi = $r20r21, 536870911.@ 	#Opcode-lvx_v2-MINWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	minw.sx $r3 = $r2r3.hi, $r0r1r2r3.t 	#Opcode-lvx_v2-MINW_signextw_registerW_registerZ_registerY_simple
	;;
	minw $r4 = $r4r5.lo, 536870911 	#Opcode-lvx_v2-MINW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	msbfbho $r20r21r22r23.lo = $r4, $r4r5.lo 	#Opcode-lvx_v2-MSBFBHO_widemult_registerM_registerZe_registerYe_simple
	;;
	msbfbho.u $r22r23 = $r5, $r4r5.hi 	#Opcode-lvx_v2-MSBFBHO_widemult_registerM_registerZo_registerYo_simple
	;;
	msbfdp.h $r20r21r22r23.hi = $r24r25, $r24r25r26r27.lo 	#Opcode-lvx_v2-MSBFDP_highmult_registerM_registerP_registerO_simple
	;;
	msbfdq.su $r26r27 = $r4r5r6r7.x, $r5 	#Opcode-lvx_v2-MSBFDQ_widemult_registerM_registerZ_registerY_simple
	;;
	msbfdt $r24r25r26r27.hi = $r4r5.hi, $r4r5r6r7.y 	#Opcode-lvx_v2-MSBFDT_registerM_registerZ_registerY_simple
	;;
	msbfd.hu $r6 = $r6r7.lo, $r4r5r6r7.z 	#Opcode-lvx_v2-MSBFD_highmult_registerW_registerZ_registerY_simple
	;;
	msbfd.hsu $r7 = $r6r7.hi, 536870911 	#Opcode-lvx_v2-MSBFD_highmult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	msbfhwq $r28r29 = $r4r5r6r7.x, $r6 	#Opcode-lvx_v2-MSBFHWQ_widemult_registerM_registerZe_registerYe_simple
	;;
	msbfhwq.u $r28r29r30r31.lo = $r4r5r6r7.y, $r7 	#Opcode-lvx_v2-MSBFHWQ_widemult_registerM_registerZo_registerYo_simple
	;;
	msbfsudt $r30r31 = $r4r5r6r7.t, $r8 	#Opcode-lvx_v2-MSBFSUDT_registerM_registerZ_registerY_simple
	;;
	msbfsuwd $r8r9.lo = $r8r9r10r11.x, $r9 	#Opcode-lvx_v2-MSBFSUWD_registerW_registerZ_registerY_simple
	;;
	msbfsuwd $r8r9.hi = $r8r9r10r11.y, 536870911 	#Opcode-lvx_v2-MSBFSUWD_registerW_registerZ_upper27_lower5_double
	;;
	msbfudt $r28r29r30r31.hi = $r10, $r10r11.lo 	#Opcode-lvx_v2-MSBFUDT_registerM_registerZ_registerY_simple
	;;
	msbfuwd $r8r9r10r11.z = $r11, $r10r11.hi 	#Opcode-lvx_v2-MSBFUWD_registerW_registerZ_registerY_simple
	;;
	msbfuwd $r8r9r10r11.t = $r12, 536870911 	#Opcode-lvx_v2-MSBFUWD_registerW_registerZ_upper27_lower5_double
	;;
	msbfwdp.su $r32r33 = $r6r7.lo, $r4r5r6r7.z 	#Opcode-lvx_v2-MSBFWDP_widemult_registerM_registerZe_registerYe_simple
	;;
	msbfwdp $r32r33r34r35.lo = $r6r7.hi, $r4r5r6r7.t 	#Opcode-lvx_v2-MSBFWDP_widemult_registerM_registerZo_registerYo_simple
	;;
	msbfwd.u $sp = $r13, $tp 	#Opcode-lvx_v2-MSBFWD_widemult_registerW_registerZ_registerY_simple
	;;
	msbfwd.su $r14 = $fp, 536870911.@ 	#Opcode-lvx_v2-MSBFWD_widemult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	msbfw.sx $r14r15.lo = $r15, $rp 	#Opcode-lvx_v2-MSBFW_highmult_signextw_registerW_registerZ_registerY_simple
	;;
	msbfw.h $r14r15.hi = $r16, 536870911 	#Opcode-lvx_v2-MSBFW_highmult_signextw_registerW_registerZ_upper27_lower5_double
	;;
	msbfxbho $r34r35 = $r32r33r34r35.hi, $r36r37 	#Opcode-lvx_v2-MSBFXBHO_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	msbfxhwq.o.u $r36r37r38r39.lo = $r38r39, $r36r37r38r39.hi 	#Opcode-lvx_v2-MSBFXHWQ_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	msbfxwdp.su $r40r41 = $r40r41r42r43.lo, $r42r43 	#Opcode-lvx_v2-MSBFXWDP_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	mulbho $r40r41r42r43.hi = $r8, $r8r9.lo 	#Opcode-lvx_v2-MULBHO_widemult_registerM_registerZe_registerYe_simple
	;;
	mulbho.u $r44r45 = $r9, $r8r9.hi 	#Opcode-lvx_v2-MULBHO_widemult_registerM_registerZo_registerYo_simple
	;;
	muldp.hu $r44r45r46r47.lo = $r46r47, $r44r45r46r47.hi 	#Opcode-lvx_v2-MULDP_highmult_registerM_registerP_registerO_simple
	;;
	muldq.su $r48r49 = $r16r17.lo, $r16r17r18r19.x 	#Opcode-lvx_v2-MULDQ_widemult_registerM_registerZ_registerY_simple
	;;
	muldt $r48r49r50r51.lo = $r17, $r16r17.hi 	#Opcode-lvx_v2-MULDT_registerM_registerZ_registerY_simple
	;;
	muld.hsu $r16r17r18r19.y = $r18, $r18r19.lo 	#Opcode-lvx_v2-MULD_highmult_registerW_registerZ_registerY_simple
	;;
	muld $r16r17r18r19.z = $r19, 536870911 	#Opcode-lvx_v2-MULD_highmult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	mulho.h $r50r51 = $r48r49r50r51.hi, $r52r53 	#Opcode-lvx_v2-MULHO_highmult_registerM_registerP_registerO_simple
	;;
	mulhwq $r52r53r54r55.lo = $r8r9r10r11.x, $r10 	#Opcode-lvx_v2-MULHWQ_widemult_registerM_registerZe_registerYe_simple
	;;
	mulhwq.u $r54r55 = $r8r9r10r11.y, $r11 	#Opcode-lvx_v2-MULHWQ_widemult_registerM_registerZo_registerYo_simple
	;;
	mulnbho.su $r52r53r54r55.hi = $r10r11.lo, $r8r9r10r11.z 	#Opcode-lvx_v2-MULNBHO_widemult_registerM_registerZe_registerYe_simple
	;;
	mulnbho $r56r57 = $r10r11.hi, $r8r9r10r11.t 	#Opcode-lvx_v2-MULNBHO_widemult_registerM_registerZo_registerYo_simple
	;;
	mulndp.hu $r56r57r58r59.lo = $r58r59, $r56r57r58r59.hi 	#Opcode-lvx_v2-MULNDP_highmult_registerM_registerP_registerO_simple
	;;
	mulndq.u $r60r61 = $r18r19.hi, $r16r17r18r19.t 	#Opcode-lvx_v2-MULNDQ_widemult_registerM_registerZ_registerY_simple
	;;
	mulnd.hsu $r20 = $r20r21.lo, $r20r21r22r23.x 	#Opcode-lvx_v2-MULND_highmult_registerW_registerZ_registerY_simple
	;;
	mulnd $r21 = $r20r21.hi, 536870911.@ 	#Opcode-lvx_v2-MULND_highmult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	mulnho.h $r60r61r62r63.lo = $r62r63, $r60r61r62r63.hi 	#Opcode-lvx_v2-MULNHO_highmult_registerM_registerP_registerO_simple
	;;
	mulnhwq.su $r0r1 = $r12, $sp 	#Opcode-lvx_v2-MULNHWQ_widemult_registerM_registerZe_registerYe_simple
	;;
	mulnhwq $r0r1r2r3.lo = $r13, $tp 	#Opcode-lvx_v2-MULNHWQ_widemult_registerM_registerZo_registerYo_simple
	;;
	mulnwdp.u $r2r3 = $r14, $fp 	#Opcode-lvx_v2-MULNWDP_widemult_registerM_registerZe_registerYe_simple
	;;
	mulnwdp.su $r0r1r2r3.hi = $r15, $rp 	#Opcode-lvx_v2-MULNWDP_widemult_registerM_registerZo_registerYo_simple
	;;
	mulnwd $r20r21r22r23.y = $r22, $r22r23.lo 	#Opcode-lvx_v2-MULNWD_widemult_registerW_registerZ_registerY_simple
	;;
	mulnwd.u $r20r21r22r23.z = $r23, 536870911 	#Opcode-lvx_v2-MULNWD_widemult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	mulnwq.hu $r4r5 = $r4r5r6r7.lo, $r6r7 	#Opcode-lvx_v2-MULNWQ_highmult_registerM_registerP_registerO_simple
	;;
	mulnw.hsu.sx $r22r23.hi = $r20r21r22r23.t, $r24 	#Opcode-lvx_v2-MULNW_highmult_signextw_registerW_registerZ_registerY_simple
	;;
	mulnw $r24r25.lo = $r24r25r26r27.x, 536870911 	#Opcode-lvx_v2-MULNW_highmult_signextw_registerW_registerZ_upper27_lower5_double
	;;
	mulnxbho.o.su $r4r5r6r7.hi = $r8r9, $r8r9r10r11.lo 	#Opcode-lvx_v2-MULNXBHO_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	mulnxhwq $r10r11 = $r8r9r10r11.hi, $r12r13 	#Opcode-lvx_v2-MULNXHWQ_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	mulnxwdp.o.u $r12r13r14r15.lo = $r14r15, $r12r13r14r15.hi 	#Opcode-lvx_v2-MULNXWDP_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	mulsudt $r16r17 = $r25, $r24r25.hi 	#Opcode-lvx_v2-MULSUDT_registerM_registerZ_registerY_simple
	;;
	mulsuwd $r24r25r26r27.y = $r26, $r26r27.lo 	#Opcode-lvx_v2-MULSUWD_registerW_registerZ_registerY_simple
	;;
	mulsuwd $r24r25r26r27.z = $r27, 536870911 	#Opcode-lvx_v2-MULSUWD_registerW_registerZ_upper27_lower5_double
	;;
	muludt $r16r17r18r19.lo = $r26r27.hi, $r24r25r26r27.t 	#Opcode-lvx_v2-MULUDT_registerM_registerZ_registerY_simple
	;;
	muluwd $r28 = $r28r29.lo, $r28r29r30r31.x 	#Opcode-lvx_v2-MULUWD_registerW_registerZ_registerY_simple
	;;
	muluwd $r29 = $r28r29.hi, 536870911 	#Opcode-lvx_v2-MULUWD_registerW_registerZ_upper27_lower5_double
	;;
	mulwdp.su $r18r19 = $r14r15.lo, $r16 	#Opcode-lvx_v2-MULWDP_widemult_registerM_registerZe_registerYe_simple
	;;
	mulwdp $r16r17r18r19.hi = $r14r15.hi, $r17 	#Opcode-lvx_v2-MULWDP_widemult_registerM_registerZo_registerYo_simple
	;;
	mulwd.u $r28r29r30r31.y = $r30, $r30r31.lo 	#Opcode-lvx_v2-MULWD_widemult_registerW_registerZ_registerY_simple
	;;
	mulwd.su $r28r29r30r31.z = $r31, 536870911.@ 	#Opcode-lvx_v2-MULWD_widemult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	mulwq.h $r20r21 = $r20r21r22r23.lo, $r22r23 	#Opcode-lvx_v2-MULWQ_highmult_registerM_registerP_registerO_simple
	;;
	mulw.hu.sx $r30r31.hi = $r28r29r30r31.t, $r32 	#Opcode-lvx_v2-MULW_highmult_signextw_registerW_registerZ_registerY_simple
	;;
	mulw.hsu $r32r33.lo = $r32r33r34r35.x, 536870911 	#Opcode-lvx_v2-MULW_highmult_signextw_registerW_registerZ_upper27_lower5_double
	;;
	mulxbho $r20r21r22r23.hi = $r24r25, $r24r25r26r27.lo 	#Opcode-lvx_v2-MULXBHO_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	mulxhwq.o.u $r26r27 = $r24r25r26r27.hi, $r28r29 	#Opcode-lvx_v2-MULXHWQ_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	mulxwdp.su $r28r29r30r31.lo = $r30r31, $r28r29r30r31.hi 	#Opcode-lvx_v2-MULXWDP_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	nandd $r33 = $r32r33.hi, 2305843009213693951 	#Opcode-lvx_v2-NANDD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	nandd $r32r33r34r35.y = $r34, $r34r35.lo 	#Opcode-lvx_v2-NANDD_registerW_registerZ_registerY_simple
	;;
	nandd $r32r33r34r35.z = $r35, -64 	#Opcode-lvx_v2-NANDD_registerW_registerZ_signed10_simple
	;;
	nandd $r34r35.hi = $r32r33r34r35.t, -8589934592 	#Opcode-lvx_v2-NANDD_registerW_registerZ_upper27_lower10_double
	;;
	nandq $r32r33 = $r32r33r34r35.lo, $r34r35 	#Opcode-lvx_v2-NANDQ_registerM_registerP_registerO_simple
	;;
	nandq $r32r33r34r35.hi = $r36r37, 536870911 	#Opcode-lvx_v2-NANDQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	nandw.sx $r36 = $r36r37.lo, $r36r37r38r39.x 	#Opcode-lvx_v2-NANDW_signextw_registerW_registerZ_registerY_simple
	;;
	nandw $r37 = $r36r37.hi, 536870911 	#Opcode-lvx_v2-NANDW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	negbx $r36r37r38r39.lo = $r38r39 	#Opcode-lvx_v2-NEGBX_registerM_registerP_simple
	;;
	negdp $r36r37r38r39.hi = $r40r41 	#Opcode-lvx_v2-NEGDP_registerM_registerP_simple
	;;
	negd $r36r37r38r39.y = $r38 	#Opcode-lvx_v2-NEGD_registerW_registerZ_simple
	;;
	negho $r40r41r42r43.lo = $r42r43 	#Opcode-lvx_v2-NEGHO_registerM_registerP_simple
	;;
	negq $r40r41r42r43.hi = $r44r45 	#Opcode-lvx_v2-NEGQ_registerM_registerP_simple
	;;
	negsbx $r44r45r46r47.lo = $r46r47 	#Opcode-lvx_v2-NEGSBX_registerM_registerP_simple
	;;
	negsdp $r44r45r46r47.hi = $r48r49 	#Opcode-lvx_v2-NEGSDP_registerM_registerP_simple
	;;
	negsd $r38r39.lo = $r36r37r38r39.z 	#Opcode-lvx_v2-NEGSD_registerW_registerZ_simple
	;;
	negsho $r48r49r50r51.lo = $r50r51 	#Opcode-lvx_v2-NEGSHO_registerM_registerP_simple
	;;
	negswq $r48r49r50r51.hi = $r52r53 	#Opcode-lvx_v2-NEGSWQ_registerM_registerP_simple
	;;
	negsw $r39 = $r38r39.hi 	#Opcode-lvx_v2-NEGSW_registerW_registerZ_simple
	;;
	negwq $r52r53r54r55.lo = $r54r55 	#Opcode-lvx_v2-NEGWQ_registerM_registerP_simple
	;;
	negw $r36r37r38r39.t = $r40 	#Opcode-lvx_v2-NEGW_registerW_registerZ_simple
	;;
	neord $r40r41.lo = $r40r41r42r43.x, 2305843009213693951 	#Opcode-lvx_v2-NEORD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	neord $r41 = $r40r41.hi, $r40r41r42r43.y 	#Opcode-lvx_v2-NEORD_registerW_registerZ_registerY_simple
	;;
	neord $r42 = $r42r43.lo, -64 	#Opcode-lvx_v2-NEORD_registerW_registerZ_signed10_simple
	;;
	neord $r40r41r42r43.z = $r43, -8589934592 	#Opcode-lvx_v2-NEORD_registerW_registerZ_upper27_lower10_double
	;;
	neorq $r52r53r54r55.hi = $r56r57, $r56r57r58r59.lo 	#Opcode-lvx_v2-NEORQ_registerM_registerP_registerO_simple
	;;
	neorq $r58r59 = $r56r57r58r59.hi, 536870911.@ 	#Opcode-lvx_v2-NEORQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	neorw.sx $r42r43.hi = $r40r41r42r43.t, $r44 	#Opcode-lvx_v2-NEORW_signextw_registerW_registerZ_registerY_simple
	;;
	neorw $r44r45.lo = $r44r45r46r47.x, 536870911 	#Opcode-lvx_v2-NEORW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	niord $r45 = $r44r45.hi, 2305843009213693951 	#Opcode-lvx_v2-NIORD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	niord $r44r45r46r47.y = $r46, $r46r47.lo 	#Opcode-lvx_v2-NIORD_registerW_registerZ_registerY_simple
	;;
	niord $r44r45r46r47.z = $r47, -64 	#Opcode-lvx_v2-NIORD_registerW_registerZ_signed10_simple
	;;
	niord $r46r47.hi = $r44r45r46r47.t, -8589934592 	#Opcode-lvx_v2-NIORD_registerW_registerZ_upper27_lower10_double
	;;
	niorq $r60r61 = $r60r61r62r63.lo, $r62r63 	#Opcode-lvx_v2-NIORQ_registerM_registerP_registerO_simple
	;;
	niorq $r60r61r62r63.hi = $r0r1, 536870911 	#Opcode-lvx_v2-NIORQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	niorw.sx $r48 = $r48r49.lo, $r48r49r50r51.x 	#Opcode-lvx_v2-NIORW_signextw_registerW_registerZ_registerY_simple
	;;
	niorw $r49 = $r48r49.hi, 536870911 	#Opcode-lvx_v2-NIORW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	nop 	#Opcode-lvx_v2-NOP_simple
	;;
	notd $r48r49r50r51.y = $r50 	#Opcode-lvx_v2-NOTD_registerW_registerZ_simple
	;;
	notq $r0r1r2r3.lo = $r2r3 	#Opcode-lvx_v2-NOTQ_registerM_registerP_simple
	;;
	notw $r50r51.lo = $r48r49r50r51.z 	#Opcode-lvx_v2-NOTW_registerW_registerZ_simple
	;;
	pcrel $r51 = 2305843009213693951 	#Opcode-lvx_v2-PCREL_registerW_extend27_upper27_lower10_triple
	;;
	pcrel $r50r51.hi = -549755813888 	#Opcode-lvx_v2-PCREL_registerW_extend6_upper27_lower10_double
	;;
	pcrel $r48r49r50r51.t = -4096 	#Opcode-lvx_v2-PCREL_registerW_signed16_simple
	;;
	ret 	#Opcode-lvx_v2-RET_simple
	;;
	rfe 	#Opcode-lvx_v2-RFE_simple
	;;
	rold $r52 = $r52r53.lo, $r52r53r54r55.x 	#Opcode-lvx_v2-ROLD_registerW_registerZ_registerY_simple
	;;
	rold $r53 = $r52r53.hi, 7 	#Opcode-lvx_v2-ROLD_registerW_registerZ_unsigned6_simple
	;;
	rolwq $r0r1r2r3.hi = $r4r5, $r52r53r54r55.y 	#Opcode-lvx_v2-ROLWQ_registerM_registerP_registerY_simple
	;;
	rolwq $r4r5r6r7.lo = $r6r7, 7 	#Opcode-lvx_v2-ROLWQ_registerM_registerP_unsigned6_simple
	;;
	rolw.sx $r54 = $r54r55.lo, $r52r53r54r55.z 	#Opcode-lvx_v2-ROLW_signextw_registerW_registerZ_registerY_simple
	;;
	rolw $r55 = $r54r55.hi, 7 	#Opcode-lvx_v2-ROLW_signextw_registerW_registerZ_unsigned6_simple
	;;
	rord $r52r53r54r55.t = $r56, $r56r57.lo 	#Opcode-lvx_v2-RORD_registerW_registerZ_registerY_simple
	;;
	rord $r56r57r58r59.x = $r57, 7 	#Opcode-lvx_v2-RORD_registerW_registerZ_unsigned6_simple
	;;
	rorwq $r4r5r6r7.hi = $r8r9, $r56r57.hi 	#Opcode-lvx_v2-RORWQ_registerM_registerP_registerY_simple
	;;
	rorwq $r8r9r10r11.lo = $r10r11, 7 	#Opcode-lvx_v2-RORWQ_registerM_registerP_unsigned6_simple
	;;
	rorw.sx $r56r57r58r59.y = $r58, $r58r59.lo 	#Opcode-lvx_v2-RORW_signextw_registerW_registerZ_registerY_simple
	;;
	rorw $r56r57r58r59.z = $r59, 7 	#Opcode-lvx_v2-RORW_signextw_registerW_registerZ_unsigned6_simple
	;;
	rswap $r58r59.hi = $mmc 	#Opcode-lvx_v2-RSWAP_registerZ_systemAlone_simple
	;;
	rswap $r56r57r58r59.t = $s0 	#Opcode-lvx_v2-RSWAP_registerZ_systemS3_simple
	;;
	rswap $r60 = $pc 	#Opcode-lvx_v2-RSWAP_registerZ_systemS4_simple
	;;
	sbfbx $r8r9r10r11.hi = $r12r13, $r12r13r14r15.lo 	#Opcode-lvx_v2-SBFBX_registerM_registerP_registerO_simple
	;;
	sbfbx $r14r15 = $r12r13r14r15.hi, 536870911.@ 	#Opcode-lvx_v2-SBFBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfdp $r16r17 = $r16r17r18r19.lo, $r18r19 	#Opcode-lvx_v2-SBFDP_registerM_registerP_registerO_simple
	;;
	sbfdp $r16r17r18r19.hi = $r20r21, 536870911 	#Opcode-lvx_v2-SBFDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfd $r60r61.lo = $r60r61r62r63.x, 2305843009213693951 	#Opcode-lvx_v2-SBFD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbfd $r61 = $r60r61.hi, $r60r61r62r63.y 	#Opcode-lvx_v2-SBFD_registerW_registerZ_registerY_simple
	;;
	sbfd $r62 = $r62r63.lo, -64 	#Opcode-lvx_v2-SBFD_registerW_registerZ_signed10_simple
	;;
	sbfd $r60r61r62r63.z = $r63, -8589934592 	#Opcode-lvx_v2-SBFD_registerW_registerZ_upper27_lower10_double
	;;
	sbfho $r20r21r22r23.lo = $r22r23, $r20r21r22r23.hi 	#Opcode-lvx_v2-SBFHO_registerM_registerP_registerO_simple
	;;
	sbfho $r24r25 = $r24r25r26r27.lo, 536870911.@ 	#Opcode-lvx_v2-SBFHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfq $r26r27 = $r24r25r26r27.hi, $r28r29 	#Opcode-lvx_v2-SBFQ_registerM_registerP_registerO_simple
	;;
	sbfq $r28r29r30r31.lo = $r30r31, 536870911 	#Opcode-lvx_v2-SBFQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfsbx $r28r29r30r31.hi = $r32r33, $r32r33r34r35.lo 	#Opcode-lvx_v2-SBFSBX_registerM_registerP_registerO_simple
	;;
	sbfsbx $r34r35 = $r32r33r34r35.hi, 536870911.@ 	#Opcode-lvx_v2-SBFSBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfsdp $r36r37 = $r36r37r38r39.lo, $r38r39 	#Opcode-lvx_v2-SBFSDP_registerM_registerP_registerO_simple
	;;
	sbfsdp $r36r37r38r39.hi = $r40r41, 536870911 	#Opcode-lvx_v2-SBFSDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfsd $r62r63.hi = $r60r61r62r63.t, $r0 	#Opcode-lvx_v2-SBFSD_registerW_registerZ_registerY_simple
	;;
	sbfsd $r0r1.lo = $r0r1r2r3.x, 536870911.@ 	#Opcode-lvx_v2-SBFSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	sbfsho $r40r41r42r43.lo = $r42r43, $r40r41r42r43.hi 	#Opcode-lvx_v2-SBFSHO_registerM_registerP_registerO_simple
	;;
	sbfsho $r44r45 = $r44r45r46r47.lo, 536870911 	#Opcode-lvx_v2-SBFSHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfswq $r46r47 = $r44r45r46r47.hi, $r48r49 	#Opcode-lvx_v2-SBFSWQ_registerM_registerP_registerO_simple
	;;
	sbfswq $r48r49r50r51.lo = $r50r51, 536870911.@ 	#Opcode-lvx_v2-SBFSWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfsw.sx $r1 = $r0r1.hi, $r0r1r2r3.y 	#Opcode-lvx_v2-SBFSW_signextw_registerW_registerZ_registerY_simple
	;;
	sbfsw $r2 = $r2r3.lo, 536870911 	#Opcode-lvx_v2-SBFSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	sbfusbx $r48r49r50r51.hi = $r52r53, $r52r53r54r55.lo 	#Opcode-lvx_v2-SBFUSBX_registerM_registerP_registerO_simple
	;;
	sbfusbx $r54r55 = $r52r53r54r55.hi, 536870911 	#Opcode-lvx_v2-SBFUSBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfusdp $r56r57 = $r56r57r58r59.lo, $r58r59 	#Opcode-lvx_v2-SBFUSDP_registerM_registerP_registerO_simple
	;;
	sbfusdp $r56r57r58r59.hi = $r60r61, 536870911.@ 	#Opcode-lvx_v2-SBFUSDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfusd $r0r1r2r3.z = $r3, $r2r3.hi 	#Opcode-lvx_v2-SBFUSD_registerW_registerZ_registerY_simple
	;;
	sbfusd $r0r1r2r3.t = $r4, 536870911 	#Opcode-lvx_v2-SBFUSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	sbfusho $r60r61r62r63.lo = $r62r63, $r60r61r62r63.hi 	#Opcode-lvx_v2-SBFUSHO_registerM_registerP_registerO_simple
	;;
	sbfusho $r0r1 = $r0r1r2r3.lo, 536870911.@ 	#Opcode-lvx_v2-SBFUSHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfuswq $r2r3 = $r0r1r2r3.hi, $r4r5 	#Opcode-lvx_v2-SBFUSWQ_registerM_registerP_registerO_simple
	;;
	sbfuswq $r4r5r6r7.lo = $r6r7, 536870911 	#Opcode-lvx_v2-SBFUSWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfusw.sx $r4r5.lo = $r4r5r6r7.x, $r5 	#Opcode-lvx_v2-SBFUSW_signextw_registerW_registerZ_registerY_simple
	;;
	sbfusw $r4r5.hi = $r4r5r6r7.y, 536870911 	#Opcode-lvx_v2-SBFUSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	sbfwq $r4r5r6r7.hi = $r8r9, $r8r9r10r11.lo 	#Opcode-lvx_v2-SBFWQ_registerM_registerP_registerO_simple
	;;
	sbfwq $r10r11 = $r8r9r10r11.hi, 536870911.@ 	#Opcode-lvx_v2-SBFWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfw.sx $r6 = $r6r7.lo, $r4r5r6r7.z 	#Opcode-lvx_v2-SBFW_signextw_registerW_registerZ_registerY_simple
	;;
	sbfw $r7 = $r6r7.hi, 536870911 	#Opcode-lvx_v2-SBFW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	sbmm8dp $r12r13 = $r12r13r14r15.lo, $r14r15 	#Opcode-lvx_v2-SBMM8DP_registerM_registerP_registerO_simple
	;;
	sbmm8dp $r12r13r14r15.hi = $r16r17, 536870911 	#Opcode-lvx_v2-SBMM8DP_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbmm8d $r4r5r6r7.t = $r8, 2305843009213693951 	#Opcode-lvx_v2-SBMM8D_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbmm8d $r8r9.lo = $r8r9r10r11.x, $r9 	#Opcode-lvx_v2-SBMM8D_registerW_registerZ_registerY_simple
	;;
	sbmm8d $r8r9.hi = $r8r9r10r11.y, -64 	#Opcode-lvx_v2-SBMM8D_registerW_registerZ_signed10_simple
	;;
	sbmm8d $r10 = $r10r11.lo, -8589934592 	#Opcode-lvx_v2-SBMM8D_registerW_registerZ_upper27_lower10_double
	;;
	sbmm8eordp $r16r17r18r19.lo = $r18r19, $r16r17r18r19.hi 	#Opcode-lvx_v2-SBMM8EORDP_registerM_registerP_registerO_simple
	;;
	sbmm8eordp $r20r21 = $r20r21r22r23.lo, 536870911.@ 	#Opcode-lvx_v2-SBMM8EORDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbmm8eord $r8r9r10r11.z = $r11, $r10r11.hi 	#Opcode-lvx_v2-SBMM8EORD_registerW_registerZ_registerY_simple
	;;
	sbmm8eord $r8r9r10r11.t = $r12, 536870911 	#Opcode-lvx_v2-SBMM8EORD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	sbmm8 $sp = $r13, 2305843009213693951 	#Opcode-lvx_v2-SBMM8_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbmm8 $tp = $r14, $fp 	#Opcode-lvx_v2-SBMM8_registerW_registerZ_registerY_simple
	;;
	sbmm8 $r14r15.lo = $r15, -64 	#Opcode-lvx_v2-SBMM8_registerW_registerZ_signed10_simple
	;;
	sbmm8 $rp = $r14r15.hi, -8589934592 	#Opcode-lvx_v2-SBMM8_registerW_registerZ_upper27_lower10_double
	;;
	sbmmt8dp $r22r23 = $r20r21r22r23.hi, $r24r25 	#Opcode-lvx_v2-SBMMT8DP_registerM_registerP_registerO_simple
	;;
	sbmmt8dp $r24r25r26r27.lo = $r26r27, 536870911.@ 	#Opcode-lvx_v2-SBMMT8DP_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbmmt8d $r16 = $r16r17.lo, 2305843009213693951 	#Opcode-lvx_v2-SBMMT8D_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbmmt8d $r16r17r18r19.x = $r17, $r16r17.hi 	#Opcode-lvx_v2-SBMMT8D_registerW_registerZ_registerY_simple
	;;
	sbmmt8d $r16r17r18r19.y = $r18, -64 	#Opcode-lvx_v2-SBMMT8D_registerW_registerZ_signed10_simple
	;;
	sbmmt8d $r18r19.lo = $r16r17r18r19.z, -8589934592 	#Opcode-lvx_v2-SBMMT8D_registerW_registerZ_upper27_lower10_double
	;;
	sbmmt8eordp $r24r25r26r27.hi = $r28r29, $r28r29r30r31.lo 	#Opcode-lvx_v2-SBMMT8EORDP_registerM_registerP_registerO_simple
	;;
	sbmmt8eordp $r30r31 = $r28r29r30r31.hi, 536870911 	#Opcode-lvx_v2-SBMMT8EORDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbmmt8eord $r19 = $r18r19.hi, $r16r17r18r19.t 	#Opcode-lvx_v2-SBMMT8EORD_registerW_registerZ_registerY_simple
	;;
	sbmmt8eord $r20 = $r20r21.lo, 536870911.@ 	#Opcode-lvx_v2-SBMMT8EORD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	sbmmt8 $r20r21r22r23.x = $r21, 2305843009213693951 	#Opcode-lvx_v2-SBMMT8_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbmmt8 $r20r21.hi = $r20r21r22r23.y, $r22 	#Opcode-lvx_v2-SBMMT8_registerW_registerZ_registerY_simple
	;;
	sbmmt8 $r22r23.lo = $r20r21r22r23.z, -64 	#Opcode-lvx_v2-SBMMT8_registerW_registerZ_signed10_simple
	;;
	sbmmt8 $r23 = $r22r23.hi, -8589934592 	#Opcode-lvx_v2-SBMMT8_registerW_registerZ_upper27_lower10_double
	;;
	sb 2305843009213693951[$r20r21r22r23.t] = $r24 	#Opcode-lvx_v2-SB_extend27_upper27_lower10_registerZ_registerT_triple
	;;
	sb $r24r25.lo[$r24r25r26r27.x] = $r25 	#Opcode-lvx_v2-SB_registerY_registerZ_registerT_simple
	;;
	sb -64[$r24r25.hi] = $r24r25r26r27.y 	#Opcode-lvx_v2-SB_signed10_registerZ_registerT_simple
	;;
	sb -8589934592[$r26] = $r26r27.lo 	#Opcode-lvx_v2-SB_upper27_lower10_registerZ_registerT_double
	;;
	scall $r24r25r26r27.z 	#Opcode-lvx_v2-SCALL_registerZ_simple
	;;
	scall 511 	#Opcode-lvx_v2-SCALL_sysnumber_simple
	;;
	sd 2305843009213693951[$r27] = $r26r27.hi 	#Opcode-lvx_v2-SD_extend27_upper27_lower10_registerZ_registerT_triple
	;;
	sd $r24r25r26r27.t[$r28] = $r28r29.lo 	#Opcode-lvx_v2-SD_registerY_registerZ_registerT_simple
	;;
	sd -64[$r28r29r30r31.x] = $r29 	#Opcode-lvx_v2-SD_signed10_registerZ_registerT_simple
	;;
	sd -8589934592[$r28r29.hi] = $r28r29r30r31.y 	#Opcode-lvx_v2-SD_upper27_lower10_registerZ_registerT_double
	;;
	set $s28 = $r30 	#Opcode-lvx_v2-SET_systemAlone_registerZ_simple
	;;
	set $ra = $r30r31.lo 	#Opcode-lvx_v2-SET_systemRA_registerZ_simple
	;;
	set $ps = $r28r29r30r31.z 	#Opcode-lvx_v2-SET_systemT3_registerZ_simple
	;;
	set $ps = $r31 	#Opcode-lvx_v2-SET_systemT4_registerZ_simple
	;;
	sh 2305843009213693951[$r30r31.hi] = $r28r29r30r31.t 	#Opcode-lvx_v2-SH_extend27_upper27_lower10_registerZ_registerT_triple
	;;
	sh $r32[$r32r33.lo] = $r32r33r34r35.x 	#Opcode-lvx_v2-SH_registerY_registerZ_registerT_simple
	;;
	sh -64[$r33] = $r32r33.hi 	#Opcode-lvx_v2-SH_signed10_registerZ_registerT_simple
	;;
	sh -8589934592[$r32r33r34r35.y] = $r34 	#Opcode-lvx_v2-SH_upper27_lower10_registerZ_registerT_double
	;;
	signbx $r32r33 = $r32r33r34r35.lo, $r34r35 	#Opcode-lvx_v2-SIGNBX_registerM_registerP_registerO_simple
	;;
	signbx $r32r33r34r35.hi = $r36r37, 536870911 	#Opcode-lvx_v2-SIGNBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	signdp $r36r37r38r39.lo = $r38r39, $r36r37r38r39.hi 	#Opcode-lvx_v2-SIGNDP_registerM_registerP_registerO_simple
	;;
	signdp $r40r41 = $r40r41r42r43.lo, 536870911.@ 	#Opcode-lvx_v2-SIGNDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	signd $r34r35.lo = $r32r33r34r35.z, $r35 	#Opcode-lvx_v2-SIGND_registerW_registerZ_registerY_simple
	;;
	signd $r34r35.hi = $r32r33r34r35.t, 536870911 	#Opcode-lvx_v2-SIGND_registerW_registerZ_upper27_lower5_splat32_double
	;;
	signho $r42r43 = $r40r41r42r43.hi, $r44r45 	#Opcode-lvx_v2-SIGNHO_registerM_registerP_registerO_simple
	;;
	signho $r44r45r46r47.lo = $r46r47, 536870911.@ 	#Opcode-lvx_v2-SIGNHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	signsbx $r44r45r46r47.hi = $r48r49, $r48r49r50r51.lo 	#Opcode-lvx_v2-SIGNSBX_registerM_registerP_registerO_simple
	;;
	signsbx $r50r51 = $r48r49r50r51.hi, 536870911 	#Opcode-lvx_v2-SIGNSBX_registerM_registerP_upper27_lower5_splat32_double
	;;
	signsdp $r52r53 = $r52r53r54r55.lo, $r54r55 	#Opcode-lvx_v2-SIGNSDP_registerM_registerP_registerO_simple
	;;
	signsdp $r52r53r54r55.hi = $r56r57, 536870911.@ 	#Opcode-lvx_v2-SIGNSDP_registerM_registerP_upper27_lower5_splat32_double
	;;
	signsd $r36 = $r36r37.lo, $r36r37r38r39.x 	#Opcode-lvx_v2-SIGNSD_registerW_registerZ_registerY_simple
	;;
	signsd $r37 = $r36r37.hi, 536870911 	#Opcode-lvx_v2-SIGNSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	signsho $r56r57r58r59.lo = $r58r59, $r56r57r58r59.hi 	#Opcode-lvx_v2-SIGNSHO_registerM_registerP_registerO_simple
	;;
	signsho $r60r61 = $r60r61r62r63.lo, 536870911.@ 	#Opcode-lvx_v2-SIGNSHO_registerM_registerP_upper27_lower5_splat32_double
	;;
	signswq $r62r63 = $r60r61r62r63.hi, $r0r1 	#Opcode-lvx_v2-SIGNSWQ_registerM_registerP_registerO_simple
	;;
	signswq $r0r1r2r3.lo = $r2r3, 536870911 	#Opcode-lvx_v2-SIGNSWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	signsw.sx $r36r37r38r39.y = $r38, $r38r39.lo 	#Opcode-lvx_v2-SIGNSW_signextw_registerW_registerZ_registerY_simple
	;;
	signsw $r36r37r38r39.z = $r39, 536870911 	#Opcode-lvx_v2-SIGNSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	signwq $r0r1r2r3.hi = $r4r5, $r4r5r6r7.lo 	#Opcode-lvx_v2-SIGNWQ_registerM_registerP_registerO_simple
	;;
	signwq $r6r7 = $r4r5r6r7.hi, 536870911.@ 	#Opcode-lvx_v2-SIGNWQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	signw.sx $r38r39.hi = $r36r37r38r39.t, $r40 	#Opcode-lvx_v2-SIGNW_signextw_registerW_registerZ_registerY_simple
	;;
	signw $r40r41.lo = $r40r41r42r43.x, 536870911 	#Opcode-lvx_v2-SIGNW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	sleep 	#Opcode-lvx_v2-SLEEP_simple
	;;
	sllbx $r8r9 = $r8r9r10r11.lo, $r41 	#Opcode-lvx_v2-SLLBX_registerM_registerP_registerY_simple
	;;
	sllbx $r10r11 = $r8r9r10r11.hi, 7 	#Opcode-lvx_v2-SLLBX_registerM_registerP_unsigned6_simple
	;;
	slldp $r12r13 = $r12r13r14r15.lo, $r14r15 	#Opcode-lvx_v2-SLLDP_registerM_registerP_registerO_simple
	;;
	slldp $r12r13r14r15.hi = $r16r17, 7 	#Opcode-lvx_v2-SLLDP_registerM_registerP_unsigned6_simple
	;;
	slld $r40r41.hi = $r40r41r42r43.y, $r42 	#Opcode-lvx_v2-SLLD_registerW_registerZ_registerY_simple
	;;
	slld $r42r43.lo = $r40r41r42r43.z, 7 	#Opcode-lvx_v2-SLLD_registerW_registerZ_unsigned6_simple
	;;
	sllho $r16r17r18r19.lo = $r18r19, $r43 	#Opcode-lvx_v2-SLLHO_registerM_registerP_registerY_simple
	;;
	sllho $r16r17r18r19.hi = $r20r21, 7 	#Opcode-lvx_v2-SLLHO_registerM_registerP_unsigned6_simple
	;;
	sllwq $r20r21r22r23.lo = $r22r23, $r42r43.hi 	#Opcode-lvx_v2-SLLWQ_registerM_registerP_registerY_simple
	;;
	sllwq $r20r21r22r23.hi = $r24r25, 7 	#Opcode-lvx_v2-SLLWQ_registerM_registerP_unsigned6_simple
	;;
	sllw.sx $r40r41r42r43.t = $r44, $r44r45.lo 	#Opcode-lvx_v2-SLLW_signextw_registerW_registerZ_registerY_simple
	;;
	sllw $r44r45r46r47.x = $r45, 7 	#Opcode-lvx_v2-SLLW_signextw_registerW_registerZ_unsigned6_simple
	;;
	slsbx $r24r25r26r27.lo = $r26r27, $r44r45.hi 	#Opcode-lvx_v2-SLSBX_registerM_registerP_registerY_simple
	;;
	slsbx $r24r25r26r27.hi = $r28r29, 7 	#Opcode-lvx_v2-SLSBX_registerM_registerP_unsigned6_simple
	;;
	slsdp $r28r29r30r31.lo = $r30r31, $r28r29r30r31.hi 	#Opcode-lvx_v2-SLSDP_registerM_registerP_registerO_simple
	;;
	slsdp $r32r33 = $r32r33r34r35.lo, 7 	#Opcode-lvx_v2-SLSDP_registerM_registerP_unsigned6_simple
	;;
	slsd $r44r45r46r47.y = $r46, $r46r47.lo 	#Opcode-lvx_v2-SLSD_registerW_registerZ_registerY_simple
	;;
	slsd $r44r45r46r47.z = $r47, 7 	#Opcode-lvx_v2-SLSD_registerW_registerZ_unsigned6_simple
	;;
	slsho $r34r35 = $r32r33r34r35.hi, $r46r47.hi 	#Opcode-lvx_v2-SLSHO_registerM_registerP_registerY_simple
	;;
	slsho $r36r37 = $r36r37r38r39.lo, 7 	#Opcode-lvx_v2-SLSHO_registerM_registerP_unsigned6_simple
	;;
	slswq $r38r39 = $r36r37r38r39.hi, $r44r45r46r47.t 	#Opcode-lvx_v2-SLSWQ_registerM_registerP_registerY_simple
	;;
	slswq $r40r41 = $r40r41r42r43.lo, 7 	#Opcode-lvx_v2-SLSWQ_registerM_registerP_unsigned6_simple
	;;
	slsw.sx $r48 = $r48r49.lo, $r48r49r50r51.x 	#Opcode-lvx_v2-SLSW_signextw_registerW_registerZ_registerY_simple
	;;
	slsw $r49 = $r48r49.hi, 7 	#Opcode-lvx_v2-SLSW_signextw_registerW_registerZ_unsigned6_simple
	;;
	slusbx $r42r43 = $r40r41r42r43.hi, $r48r49r50r51.y 	#Opcode-lvx_v2-SLUSBX_registerM_registerP_registerY_simple
	;;
	slusbx $r44r45 = $r44r45r46r47.lo, 7 	#Opcode-lvx_v2-SLUSBX_registerM_registerP_unsigned6_simple
	;;
	slusdp $r46r47 = $r44r45r46r47.hi, $r48r49 	#Opcode-lvx_v2-SLUSDP_registerM_registerP_registerO_simple
	;;
	slusdp $r48r49r50r51.lo = $r50r51, 7 	#Opcode-lvx_v2-SLUSDP_registerM_registerP_unsigned6_simple
	;;
	slusd $r50 = $r50r51.lo, $r48r49r50r51.z 	#Opcode-lvx_v2-SLUSD_registerW_registerZ_registerY_simple
	;;
	slusd $r51 = $r50r51.hi, 7 	#Opcode-lvx_v2-SLUSD_registerW_registerZ_unsigned6_simple
	;;
	slusho $r48r49r50r51.hi = $r52r53, $r48r49r50r51.t 	#Opcode-lvx_v2-SLUSHO_registerM_registerP_registerY_simple
	;;
	slusho $r52r53r54r55.lo = $r54r55, 7 	#Opcode-lvx_v2-SLUSHO_registerM_registerP_unsigned6_simple
	;;
	sluswq $r52r53r54r55.hi = $r56r57, $r52 	#Opcode-lvx_v2-SLUSWQ_registerM_registerP_registerY_simple
	;;
	sluswq $r56r57r58r59.lo = $r58r59, 7 	#Opcode-lvx_v2-SLUSWQ_registerM_registerP_unsigned6_simple
	;;
	slusw.sx $r52r53.lo = $r52r53r54r55.x, $r53 	#Opcode-lvx_v2-SLUSW_signextw_registerW_registerZ_registerY_simple
	;;
	slusw $r52r53.hi = $r52r53r54r55.y, 7 	#Opcode-lvx_v2-SLUSW_signextw_registerW_registerZ_unsigned6_simple
	;;
	so 2305843009213693951[$r54] = $r40r41r42r43 	#Opcode-lvx_v2-SO_extend27_upper27_lower10_registerZ_registerV_triple
	;;
	so $r54r55.lo[$r52r53r54r55.z] = $r44r45r46r47 	#Opcode-lvx_v2-SO_registerY_registerZ_registerV_simple
	;;
	so -64[$r55] = $r48r49r50r51 	#Opcode-lvx_v2-SO_signed10_registerZ_registerV_simple
	;;
	so -8589934592[$r54r55.hi] = $r52r53r54r55 	#Opcode-lvx_v2-SO_upper27_lower10_registerZ_registerV_double
	;;
	sq 2305843009213693951[$r52r53r54r55.t] = $r56r57r58r59.hi 	#Opcode-lvx_v2-SQ_extend27_upper27_lower10_registerZ_registerU_triple
	;;
	sq $r56[$r56r57.lo] = $r60r61 	#Opcode-lvx_v2-SQ_registerY_registerZ_registerU_simple
	;;
	sq -64[$r56r57r58r59.x] = $r60r61r62r63.lo 	#Opcode-lvx_v2-SQ_signed10_registerZ_registerU_simple
	;;
	sq -8589934592[$r57] = $r62r63 	#Opcode-lvx_v2-SQ_upper27_lower10_registerZ_registerU_double
	;;
	srabx $r60r61r62r63.hi = $r0r1, $r56r57.hi 	#Opcode-lvx_v2-SRABX_registerM_registerP_registerY_simple
	;;
	srabx $r0r1r2r3.lo = $r2r3, 7 	#Opcode-lvx_v2-SRABX_registerM_registerP_unsigned6_simple
	;;
	sradp $r0r1r2r3.hi = $r4r5, $r4r5r6r7.lo 	#Opcode-lvx_v2-SRADP_registerM_registerP_registerO_simple
	;;
	sradp $r6r7 = $r4r5r6r7.hi, 7 	#Opcode-lvx_v2-SRADP_registerM_registerP_unsigned6_simple
	;;
	srad $r56r57r58r59.y = $r58, $r58r59.lo 	#Opcode-lvx_v2-SRAD_registerW_registerZ_registerY_simple
	;;
	srad $r56r57r58r59.z = $r59, 7 	#Opcode-lvx_v2-SRAD_registerW_registerZ_unsigned6_simple
	;;
	sraho $r8r9 = $r8r9r10r11.lo, $r58r59.hi 	#Opcode-lvx_v2-SRAHO_registerM_registerP_registerY_simple
	;;
	sraho $r10r11 = $r8r9r10r11.hi, 7 	#Opcode-lvx_v2-SRAHO_registerM_registerP_unsigned6_simple
	;;
	srawq $r12r13 = $r12r13r14r15.lo, $r56r57r58r59.t 	#Opcode-lvx_v2-SRAWQ_registerM_registerP_registerY_simple
	;;
	srawq $r14r15 = $r12r13r14r15.hi, 7 	#Opcode-lvx_v2-SRAWQ_registerM_registerP_unsigned6_simple
	;;
	sraw.sx $r60 = $r60r61.lo, $r60r61r62r63.x 	#Opcode-lvx_v2-SRAW_signextw_registerW_registerZ_registerY_simple
	;;
	sraw $r61 = $r60r61.hi, 7 	#Opcode-lvx_v2-SRAW_signextw_registerW_registerZ_unsigned6_simple
	;;
	srlbx $r16r17 = $r16r17r18r19.lo, $r60r61r62r63.y 	#Opcode-lvx_v2-SRLBX_registerM_registerP_registerY_simple
	;;
	srlbx $r18r19 = $r16r17r18r19.hi, 7 	#Opcode-lvx_v2-SRLBX_registerM_registerP_unsigned6_simple
	;;
	srldp $r20r21 = $r20r21r22r23.lo, $r22r23 	#Opcode-lvx_v2-SRLDP_registerM_registerP_registerO_simple
	;;
	srldp $r20r21r22r23.hi = $r24r25, 7 	#Opcode-lvx_v2-SRLDP_registerM_registerP_unsigned6_simple
	;;
	srld $r62 = $r62r63.lo, $r60r61r62r63.z 	#Opcode-lvx_v2-SRLD_registerW_registerZ_registerY_simple
	;;
	srld $r63 = $r62r63.hi, 7 	#Opcode-lvx_v2-SRLD_registerW_registerZ_unsigned6_simple
	;;
	srlho $r24r25r26r27.lo = $r26r27, $r60r61r62r63.t 	#Opcode-lvx_v2-SRLHO_registerM_registerP_registerY_simple
	;;
	srlho $r24r25r26r27.hi = $r28r29, 7 	#Opcode-lvx_v2-SRLHO_registerM_registerP_unsigned6_simple
	;;
	srlwq $r28r29r30r31.lo = $r30r31, $r0 	#Opcode-lvx_v2-SRLWQ_registerM_registerP_registerY_simple
	;;
	srlwq $r28r29r30r31.hi = $r32r33, 7 	#Opcode-lvx_v2-SRLWQ_registerM_registerP_unsigned6_simple
	;;
	srlw.sx $r0r1.lo = $r0r1r2r3.x, $r1 	#Opcode-lvx_v2-SRLW_signextw_registerW_registerZ_registerY_simple
	;;
	srlw $r0r1.hi = $r0r1r2r3.y, 7 	#Opcode-lvx_v2-SRLW_signextw_registerW_registerZ_unsigned6_simple
	;;
	srsbx $r32r33r34r35.lo = $r34r35, $r2 	#Opcode-lvx_v2-SRSBX_registerM_registerP_registerY_simple
	;;
	srsbx $r32r33r34r35.hi = $r36r37, 7 	#Opcode-lvx_v2-SRSBX_registerM_registerP_unsigned6_simple
	;;
	srsdp $r36r37r38r39.lo = $r38r39, $r36r37r38r39.hi 	#Opcode-lvx_v2-SRSDP_registerM_registerP_registerO_simple
	;;
	srsdp $r40r41 = $r40r41r42r43.lo, 7 	#Opcode-lvx_v2-SRSDP_registerM_registerP_unsigned6_simple
	;;
	srsd $r2r3.lo = $r0r1r2r3.z, $r3 	#Opcode-lvx_v2-SRSD_registerW_registerZ_registerY_simple
	;;
	srsd $r2r3.hi = $r0r1r2r3.t, 7 	#Opcode-lvx_v2-SRSD_registerW_registerZ_unsigned6_simple
	;;
	srsho $r42r43 = $r40r41r42r43.hi, $r4 	#Opcode-lvx_v2-SRSHO_registerM_registerP_registerY_simple
	;;
	srsho $r44r45 = $r44r45r46r47.lo, 7 	#Opcode-lvx_v2-SRSHO_registerM_registerP_unsigned6_simple
	;;
	srswq $r46r47 = $r44r45r46r47.hi, $r4r5.lo 	#Opcode-lvx_v2-SRSWQ_registerM_registerP_registerY_simple
	;;
	srswq $r48r49 = $r48r49r50r51.lo, 7 	#Opcode-lvx_v2-SRSWQ_registerM_registerP_unsigned6_simple
	;;
	srsw.sx $r4r5r6r7.x = $r5, $r4r5.hi 	#Opcode-lvx_v2-SRSW_signextw_registerW_registerZ_registerY_simple
	;;
	srsw $r4r5r6r7.y = $r6, 7 	#Opcode-lvx_v2-SRSW_signextw_registerW_registerZ_unsigned6_simple
	;;
	stop 	#Opcode-lvx_v2-STOP_simple
	;;
	stsudp $r50r51 = $r48r49r50r51.hi, $r52r53 	#Opcode-lvx_v2-STSUDP_registerM_registerP_registerO_simple
	;;
	stsud $r6r7.lo = $r4r5r6r7.z, $r7 	#Opcode-lvx_v2-STSUD_registerW_registerZ_registerY_simple
	;;
	stsuho $r52r53r54r55.lo = $r54r55, $r52r53r54r55.hi 	#Opcode-lvx_v2-STSUHO_registerM_registerP_registerO_simple
	;;
	stsuwq $r56r57 = $r56r57r58r59.lo, $r58r59 	#Opcode-lvx_v2-STSUWQ_registerM_registerP_registerO_simple
	;;
	stsuw.sx $r6r7.hi = $r4r5r6r7.t, $r8 	#Opcode-lvx_v2-STSUW_signextw_registerW_registerZ_registerY_simple
	;;
	sw 2305843009213693951[$r8r9.lo] = $r8r9r10r11.x 	#Opcode-lvx_v2-SW_extend27_upper27_lower10_registerZ_registerT_triple
	;;
	sw $r9[$r8r9.hi] = $r8r9r10r11.y 	#Opcode-lvx_v2-SW_registerY_registerZ_registerT_simple
	;;
	sw -64[$r10] = $r10r11.lo 	#Opcode-lvx_v2-SW_signed10_registerZ_registerT_simple
	;;
	sw -8589934592[$r8r9r10r11.z] = $r11 	#Opcode-lvx_v2-SW_upper27_lower10_registerZ_registerT_double
	;;
	sxbd $r10r11.hi = $r8r9r10r11.t 	#Opcode-lvx_v2-SXBD_registerW_registerZ_simple
	;;
	sxhd $r12 = $sp 	#Opcode-lvx_v2-SXHD_registerW_registerZ_simple
	;;
	sxwd $r13 = $tp 	#Opcode-lvx_v2-SXWD_registerW_registerZ_simple
	;;
	syncgroup $r14 	#Opcode-lvx_v2-SYNCGROUP_registerZ_simple
	;;
	tlbdinval 	#Opcode-lvx_v2-TLBDINVAL_simple
	;;
	tlbiinval 	#Opcode-lvx_v2-TLBIINVAL_simple
	;;
	tlbprobe 	#Opcode-lvx_v2-TLBPROBE_simple
	;;
	tlbread 	#Opcode-lvx_v2-TLBREAD_simple
	;;
	tlbwrite 	#Opcode-lvx_v2-TLBWRITE_simple
	;;
	truncdwq $r56r57r58r59.hi = $r56r57r58r59 	#Opcode-lvx_v2-TRUNCDWQ_ziplanes_registerM_registerR_simple
	;;
	trunchbx.z $r60r61 = $r60r61r62r63.lo 	#Opcode-lvx_v2-TRUNCHBX_ziplanes_registerM_registerP_simple
	;;
	truncwho $r62r63 = $r60r61r62r63.hi 	#Opcode-lvx_v2-TRUNCWHO_ziplanes_registerM_registerP_simple
	;;
	waitit $fp 	#Opcode-lvx_v2-WAITIT_registerZ_simple
	;;
	wfxl $ps, $r14r15.lo 	#Opcode-lvx_v2-WFXL_systemAlone_registerZ_simple
	;;
	wfxl $pcr, $r15 	#Opcode-lvx_v2-WFXL_systemT2_registerZ_simple
	;;
	wfxl $s1, $rp 	#Opcode-lvx_v2-WFXL_systemT4_registerZ_simple
	;;
	wfxm $s1, $r14r15.hi 	#Opcode-lvx_v2-WFXM_systemAlone_registerZ_simple
	;;
	wfxm $s2, $r16 	#Opcode-lvx_v2-WFXM_systemT2_registerZ_simple
	;;
	wfxm $pcr, $r16r17.lo 	#Opcode-lvx_v2-WFXM_systemT4_registerZ_simple
	;;
	widenqbho $r0r1 = $r0r1r2r3.lo 	#Opcode-lvx_v2-WIDENQBHO_mostsig_registerM_registerP_simple
	;;
	widenqhwq.m $r2r3 = $r0r1r2r3.hi 	#Opcode-lvx_v2-WIDENQHWQ_mostsig_registerM_registerP_simple
	;;
	widenqwdp $r4r5 = $r4r5r6r7.lo 	#Opcode-lvx_v2-WIDENQWDP_mostsig_registerM_registerP_simple
	;;
	widensbho.m $r6r7 = $r4r5r6r7.hi 	#Opcode-lvx_v2-WIDENSBHO_mostsig_registerM_registerP_simple
	;;
	widenshwq $r8r9 = $r8r9r10r11.lo 	#Opcode-lvx_v2-WIDENSHWQ_mostsig_registerM_registerP_simple
	;;
	widenswdp.m $r10r11 = $r8r9r10r11.hi 	#Opcode-lvx_v2-WIDENSWDP_mostsig_registerM_registerP_simple
	;;
	widenzbho $r12r13 = $r12r13r14r15.lo 	#Opcode-lvx_v2-WIDENZBHO_mostsig_registerM_registerP_simple
	;;
	widenzhwq.m $r14r15 = $r12r13r14r15.hi 	#Opcode-lvx_v2-WIDENZHWQ_mostsig_registerM_registerP_simple
	;;
	widenzwdp $r16r17 = $r16r17r18r19.lo 	#Opcode-lvx_v2-WIDENZWDP_mostsig_registerM_registerP_simple
	;;
	xaccesso $r60r61r62r63 = $a0..a1, $r16r17r18r19.x 	#Opcode-lvx_v2-XACCESSO_registerN_registerCg_registerZ_simple
	;;
	xaccesso $r0r1r2r3 = $a0..a3, $r17 	#Opcode-lvx_v2-XACCESSO_registerN_registerCh_registerZ_simple
	;;
	xaccesso $r4r5r6r7 = $a0..a7, $r16r17.hi 	#Opcode-lvx_v2-XACCESSO_registerN_registerCi_registerZ_simple
	;;
	xaccesso $r8r9r10r11 = $a0..a15, $r16r17r18r19.y 	#Opcode-lvx_v2-XACCESSO_registerN_registerCj_registerZ_simple
	;;
	xaccesso $r12r13r14r15 = $a0..a31, $r18 	#Opcode-lvx_v2-XACCESSO_registerN_registerCk_registerZ_simple
	;;
	xaccesso $r16r17r18r19 = $a0..a63, $r18r19.lo 	#Opcode-lvx_v2-XACCESSO_registerN_registerCl_registerZ_simple
	;;
	xaligno $a0 = $a2..a3, $r16r17r18r19.z 	#Opcode-lvx_v2-XALIGNO_registerA_registerCg_registerZ_simple
	;;
	xaligno $a0a1.lo = $a4..a7, $r19 	#Opcode-lvx_v2-XALIGNO_registerA_registerCh_registerZ_simple
	;;
	xaligno $a0a1a2a3.x = $a8..a15, $r18r19.hi 	#Opcode-lvx_v2-XALIGNO_registerA_registerCi_registerZ_simple
	;;
	xaligno $a1 = $a16..a31, $r16r17r18r19.t 	#Opcode-lvx_v2-XALIGNO_registerA_registerCj_registerZ_simple
	;;
	xaligno $a0a1.hi = $a32..a63, $r20 	#Opcode-lvx_v2-XALIGNO_registerA_registerCk_registerZ_simple
	;;
	xaligno $a0a1a2a3.y = $a0..a63, $r20r21.lo 	#Opcode-lvx_v2-XALIGNO_registerA_registerCl_registerZ_simple
	;;
	xcopyo $a2 = $a2a3.lo 	#Opcode-lvx_v2-XCOPYO_registerA_registerC_simple
	;;
	xlo.q0 $a0a1a2a3 = 2305843009213693951[$r20r21r22r23.x] 	#Opcode-lvx_v2-XLO_variant_qindex_registerGq_extend27_upper27_lower10_registerZ_triple
	;;
	xlo.s.q1 $a4a5a6a7 = $r21[$r20r21.hi] 	#Opcode-lvx_v2-XLO_variant_qindex_registerGq_registerY_registerZ_simple
	;;
	xlo.u.q2 $a8a9a10a11 = -64[$r20r21r22r23.y] 	#Opcode-lvx_v2-XLO_variant_qindex_registerGq_signed10_registerZ_simple
	;;
	xlo.us.q3 $a12a13a14a15 = -8589934592[$r22] 	#Opcode-lvx_v2-XLO_variant_qindex_registerGq_upper27_lower10_registerZ_double
	;;
	xlo $a0a1a2a3.z = 2305843009213693951[$r22r23.lo] 	#Opcode-lvx_v2-XLO_variant_registerG_extend27_upper27_lower10_registerZ_triple
	;;
	xlo.s $a3 = $r20r21r22r23.z[$r23] 	#Opcode-lvx_v2-XLO_variant_registerG_registerY_registerZ_simple
	;;
	xlo.u $a2a3.hi = -64[$r22r23.hi] 	#Opcode-lvx_v2-XLO_variant_registerG_signed10_registerZ_simple
	;;
	xlo.us $a0a1a2a3.t = -8589934592[$r20r21r22r23.t] 	#Opcode-lvx_v2-XLO_variant_registerG_upper27_lower10_registerZ_double
	;;
	xmovefd $r24 = $a0_x 	#Opcode-lvx_v2-XMOVEFD_registerW_registerCc_qselectC_simple
	;;
	xmovefo $r20r21r22r23 = $a4 	#Opcode-lvx_v2-XMOVEFO_registerN_registerC_simple
	;;
	xmovefq $r18r19 = $a0_lo 	#Opcode-lvx_v2-XMOVEFQ_registerM_registerCb_hselectC_simple
	;;
	xmovetd $a0_t = $r24r25.lo 	#Opcode-lvx_v2-XMOVETD_registerAt_registerZ_simple
	;;
	xmovetd $a0_x = $r24r25r26r27.x 	#Opcode-lvx_v2-XMOVETD_registerAx_registerZ_simple
	;;
	xmovetd $a0_y = $r25 	#Opcode-lvx_v2-XMOVETD_registerAy_registerZ_simple
	;;
	xmovetd $a0_z = $r24r25.hi 	#Opcode-lvx_v2-XMOVETD_registerAz_registerZ_simple
	;;
	xmoveto $a4a5.lo = $r16r17r18r19.hi, $r20r21 	#Opcode-lvx_v2-XMOVETO_registerA_registerP_registerO_simple
	;;
	xmovetq $a0_lo = $r24r25r26r27.y, $r26 	#Opcode-lvx_v2-XMOVETQ_registerAE_registerZ_registerY_simple
	;;
	xmovetq $a0_hi = $r26r27.lo, $r24r25r26r27.z 	#Opcode-lvx_v2-XMOVETQ_registerAO_registerZ_registerY_simple
	;;
	xplb $a4..a5, $r27 = -1125899906842624[$r26r27.hi] 	#Opcode-lvx_v2-XPLB_variant_registerGg_registerY_extend27_offset27_registerZ_triple
	;;
	xplb.s $a6..a7, $r24r25r26r27.t = -8388608[$r28] 	#Opcode-lvx_v2-XPLB_variant_registerGg_registerY_offset27_registerZ_double
	;;
	xplb.u $a8..a9, $r28r29.lo = [$r28r29r30r31.x] 	#Opcode-lvx_v2-XPLB_variant_registerGg_registerY_registerZ_simple
	;;
	xplb.us $a8..a11, $r29 = -1125899906842624[$r28r29.hi] 	#Opcode-lvx_v2-XPLB_variant_registerGh_registerY_extend27_offset27_registerZ_triple
	;;
	xplb $a12..a15, $r28r29r30r31.y = -8388608[$r30] 	#Opcode-lvx_v2-XPLB_variant_registerGh_registerY_offset27_registerZ_double
	;;
	xplb.s $a16..a19, $r30r31.lo = [$r28r29r30r31.z] 	#Opcode-lvx_v2-XPLB_variant_registerGh_registerY_registerZ_simple
	;;
	xplb.u $a16..a23, $r31 = -1125899906842624[$r30r31.hi] 	#Opcode-lvx_v2-XPLB_variant_registerGi_registerY_extend27_offset27_registerZ_triple
	;;
	xplb.us $a24..a31, $r28r29r30r31.t = -8388608[$r32] 	#Opcode-lvx_v2-XPLB_variant_registerGi_registerY_offset27_registerZ_double
	;;
	xplb $a32..a39, $r32r33.lo = [$r32r33r34r35.x] 	#Opcode-lvx_v2-XPLB_variant_registerGi_registerY_registerZ_simple
	;;
	xplb.s $a32..a47, $r33 = -1125899906842624[$r32r33.hi] 	#Opcode-lvx_v2-XPLB_variant_registerGj_registerY_extend27_offset27_registerZ_triple
	;;
	xplb.u $a48..a63, $r32r33r34r35.y = -8388608[$r34] 	#Opcode-lvx_v2-XPLB_variant_registerGj_registerY_offset27_registerZ_double
	;;
	xplb.us $a0..a15, $r34r35.lo = [$r32r33r34r35.z] 	#Opcode-lvx_v2-XPLB_variant_registerGj_registerY_registerZ_simple
	;;
	xplb $a0..a31, $r35 = -1125899906842624[$r34r35.hi] 	#Opcode-lvx_v2-XPLB_variant_registerGk_registerY_extend27_offset27_registerZ_triple
	;;
	xplb.s $a32..a63, $r32r33r34r35.t = -8388608[$r36] 	#Opcode-lvx_v2-XPLB_variant_registerGk_registerY_offset27_registerZ_double
	;;
	xplb.u $a0..a31, $r36r37.lo = [$r36r37r38r39.x] 	#Opcode-lvx_v2-XPLB_variant_registerGk_registerY_registerZ_simple
	;;
	xplb.us $a0..a63, $r37 = -1125899906842624[$r36r37.hi] 	#Opcode-lvx_v2-XPLB_variant_registerGl_registerY_extend27_offset27_registerZ_triple
	;;
	xplb $a0..a63, $r36r37r38r39.y = -8388608[$r38] 	#Opcode-lvx_v2-XPLB_variant_registerGl_registerY_offset27_registerZ_double
	;;
	xplb.s $a0..a63, $r38r39.lo = [$r36r37r38r39.z] 	#Opcode-lvx_v2-XPLB_variant_registerGl_registerY_registerZ_simple
	;;
	xpld.u $a10..a11, $r39 = -1125899906842624[$r38r39.hi] 	#Opcode-lvx_v2-XPLD_variant_registerGg_registerY_extend27_offset27_registerZ_triple
	;;
	xpld.us $a12..a13, $r36r37r38r39.t = -8388608[$r40] 	#Opcode-lvx_v2-XPLD_variant_registerGg_registerY_offset27_registerZ_double
	;;
	xpld $a14..a15, $r40r41.lo = [$r40r41r42r43.x] 	#Opcode-lvx_v2-XPLD_variant_registerGg_registerY_registerZ_simple
	;;
	xpld.s $a20..a23, $r41 = -1125899906842624[$r40r41.hi] 	#Opcode-lvx_v2-XPLD_variant_registerGh_registerY_extend27_offset27_registerZ_triple
	;;
	xpld.u $a24..a27, $r40r41r42r43.y = -8388608[$r42] 	#Opcode-lvx_v2-XPLD_variant_registerGh_registerY_offset27_registerZ_double
	;;
	xpld.us $a28..a31, $r42r43.lo = [$r40r41r42r43.z] 	#Opcode-lvx_v2-XPLD_variant_registerGh_registerY_registerZ_simple
	;;
	xpld $a40..a47, $r43 = -1125899906842624[$r42r43.hi] 	#Opcode-lvx_v2-XPLD_variant_registerGi_registerY_extend27_offset27_registerZ_triple
	;;
	xpld.s $a48..a55, $r40r41r42r43.t = -8388608[$r44] 	#Opcode-lvx_v2-XPLD_variant_registerGi_registerY_offset27_registerZ_double
	;;
	xpld.u $a56..a63, $r44r45.lo = [$r44r45r46r47.x] 	#Opcode-lvx_v2-XPLD_variant_registerGi_registerY_registerZ_simple
	;;
	xpld.us $a16..a31, $r45 = -1125899906842624[$r44r45.hi] 	#Opcode-lvx_v2-XPLD_variant_registerGj_registerY_extend27_offset27_registerZ_triple
	;;
	xpld $a32..a47, $r44r45r46r47.y = -8388608[$r46] 	#Opcode-lvx_v2-XPLD_variant_registerGj_registerY_offset27_registerZ_double
	;;
	xpld.s $a48..a63, $r46r47.lo = [$r44r45r46r47.z] 	#Opcode-lvx_v2-XPLD_variant_registerGj_registerY_registerZ_simple
	;;
	xpld.u $a32..a63, $r47 = -1125899906842624[$r46r47.hi] 	#Opcode-lvx_v2-XPLD_variant_registerGk_registerY_extend27_offset27_registerZ_triple
	;;
	xpld.us $a0..a31, $r44r45r46r47.t = -8388608[$r48] 	#Opcode-lvx_v2-XPLD_variant_registerGk_registerY_offset27_registerZ_double
	;;
	xpld $a32..a63, $r48r49.lo = [$r48r49r50r51.x] 	#Opcode-lvx_v2-XPLD_variant_registerGk_registerY_registerZ_simple
	;;
	xpld.s $a0..a63, $r49 = -1125899906842624[$r48r49.hi] 	#Opcode-lvx_v2-XPLD_variant_registerGl_registerY_extend27_offset27_registerZ_triple
	;;
	xpld.u $a0..a63, $r48r49r50r51.y = -8388608[$r50] 	#Opcode-lvx_v2-XPLD_variant_registerGl_registerY_offset27_registerZ_double
	;;
	xpld.us $a0..a63, $r50r51.lo = [$r48r49r50r51.z] 	#Opcode-lvx_v2-XPLD_variant_registerGl_registerY_registerZ_simple
	;;
	xplh $a16..a17, $r51 = -1125899906842624[$r50r51.hi] 	#Opcode-lvx_v2-XPLH_variant_registerGg_registerY_extend27_offset27_registerZ_triple
	;;
	xplh.s $a18..a19, $r48r49r50r51.t = -8388608[$r52] 	#Opcode-lvx_v2-XPLH_variant_registerGg_registerY_offset27_registerZ_double
	;;
	xplh.u $a20..a21, $r52r53.lo = [$r52r53r54r55.x] 	#Opcode-lvx_v2-XPLH_variant_registerGg_registerY_registerZ_simple
	;;
	xplh.us $a32..a35, $r53 = -1125899906842624[$r52r53.hi] 	#Opcode-lvx_v2-XPLH_variant_registerGh_registerY_extend27_offset27_registerZ_triple
	;;
	xplh $a36..a39, $r52r53r54r55.y = -8388608[$r54] 	#Opcode-lvx_v2-XPLH_variant_registerGh_registerY_offset27_registerZ_double
	;;
	xplh.s $a40..a43, $r54r55.lo = [$r52r53r54r55.z] 	#Opcode-lvx_v2-XPLH_variant_registerGh_registerY_registerZ_simple
	;;
	xplh.u $a0..a7, $r55 = -1125899906842624[$r54r55.hi] 	#Opcode-lvx_v2-XPLH_variant_registerGi_registerY_extend27_offset27_registerZ_triple
	;;
	xplh.us $a8..a15, $r52r53r54r55.t = -8388608[$r56] 	#Opcode-lvx_v2-XPLH_variant_registerGi_registerY_offset27_registerZ_double
	;;
	xplh $a16..a23, $r56r57.lo = [$r56r57r58r59.x] 	#Opcode-lvx_v2-XPLH_variant_registerGi_registerY_registerZ_simple
	;;
	xplh.s $a0..a15, $r57 = -1125899906842624[$r56r57.hi] 	#Opcode-lvx_v2-XPLH_variant_registerGj_registerY_extend27_offset27_registerZ_triple
	;;
	xplh.u $a16..a31, $r56r57r58r59.y = -8388608[$r58] 	#Opcode-lvx_v2-XPLH_variant_registerGj_registerY_offset27_registerZ_double
	;;
	xplh.us $a32..a47, $r58r59.lo = [$r56r57r58r59.z] 	#Opcode-lvx_v2-XPLH_variant_registerGj_registerY_registerZ_simple
	;;
	xplh $a0..a31, $r59 = -1125899906842624[$r58r59.hi] 	#Opcode-lvx_v2-XPLH_variant_registerGk_registerY_extend27_offset27_registerZ_triple
	;;
	xplh.s $a32..a63, $r56r57r58r59.t = -8388608[$r60] 	#Opcode-lvx_v2-XPLH_variant_registerGk_registerY_offset27_registerZ_double
	;;
	xplh.u $a0..a31, $r60r61.lo = [$r60r61r62r63.x] 	#Opcode-lvx_v2-XPLH_variant_registerGk_registerY_registerZ_simple
	;;
	xplh.us $a0..a63, $r61 = -1125899906842624[$r60r61.hi] 	#Opcode-lvx_v2-XPLH_variant_registerGl_registerY_extend27_offset27_registerZ_triple
	;;
	xplh $a0..a63, $r60r61r62r63.y = -8388608[$r62] 	#Opcode-lvx_v2-XPLH_variant_registerGl_registerY_offset27_registerZ_double
	;;
	xplh.s $a0..a63, $r62r63.lo = [$r60r61r62r63.z] 	#Opcode-lvx_v2-XPLH_variant_registerGl_registerY_registerZ_simple
	;;
	xplo.u $a22..a23, $r63 = -1125899906842624[$r62r63.hi] 	#Opcode-lvx_v2-XPLO_variant_registerGg_registerY_extend27_offset27_registerZ_triple
	;;
	xplo.us $a24..a25, $r60r61r62r63.t = -8388608[$r0] 	#Opcode-lvx_v2-XPLO_variant_registerGg_registerY_offset27_registerZ_double
	;;
	xplo $a26..a27, $r0r1.lo = [$r0r1r2r3.x] 	#Opcode-lvx_v2-XPLO_variant_registerGg_registerY_registerZ_simple
	;;
	xplo.s $a44..a47, $r1 = -1125899906842624[$r0r1.hi] 	#Opcode-lvx_v2-XPLO_variant_registerGh_registerY_extend27_offset27_registerZ_triple
	;;
	xplo.u $a48..a51, $r0r1r2r3.y = -8388608[$r2] 	#Opcode-lvx_v2-XPLO_variant_registerGh_registerY_offset27_registerZ_double
	;;
	xplo.us $a52..a55, $r2r3.lo = [$r0r1r2r3.z] 	#Opcode-lvx_v2-XPLO_variant_registerGh_registerY_registerZ_simple
	;;
	xplo $a24..a31, $r3 = -1125899906842624[$r2r3.hi] 	#Opcode-lvx_v2-XPLO_variant_registerGi_registerY_extend27_offset27_registerZ_triple
	;;
	xplo.s $a32..a39, $r0r1r2r3.t = -8388608[$r4] 	#Opcode-lvx_v2-XPLO_variant_registerGi_registerY_offset27_registerZ_double
	;;
	xplo.u $a40..a47, $r4r5.lo = [$r4r5r6r7.x] 	#Opcode-lvx_v2-XPLO_variant_registerGi_registerY_registerZ_simple
	;;
	xplo.us $a48..a63, $r5 = -1125899906842624[$r4r5.hi] 	#Opcode-lvx_v2-XPLO_variant_registerGj_registerY_extend27_offset27_registerZ_triple
	;;
	xplo $a0..a15, $r4r5r6r7.y = -8388608[$r6] 	#Opcode-lvx_v2-XPLO_variant_registerGj_registerY_offset27_registerZ_double
	;;
	xplo.s $a16..a31, $r6r7.lo = [$r4r5r6r7.z] 	#Opcode-lvx_v2-XPLO_variant_registerGj_registerY_registerZ_simple
	;;
	xplo.u $a32..a63, $r7 = -1125899906842624[$r6r7.hi] 	#Opcode-lvx_v2-XPLO_variant_registerGk_registerY_extend27_offset27_registerZ_triple
	;;
	xplo.us $a0..a31, $r4r5r6r7.t = -8388608[$r8] 	#Opcode-lvx_v2-XPLO_variant_registerGk_registerY_offset27_registerZ_double
	;;
	xplo $a32..a63, $r8r9.lo = [$r8r9r10r11.x] 	#Opcode-lvx_v2-XPLO_variant_registerGk_registerY_registerZ_simple
	;;
	xplo.s $a0..a63, $r9 = -1125899906842624[$r8r9.hi] 	#Opcode-lvx_v2-XPLO_variant_registerGl_registerY_extend27_offset27_registerZ_triple
	;;
	xplo.u $a0..a63, $r8r9r10r11.y = -8388608[$r10] 	#Opcode-lvx_v2-XPLO_variant_registerGl_registerY_offset27_registerZ_double
	;;
	xplo.us $a0..a63, $r10r11.lo = [$r8r9r10r11.z] 	#Opcode-lvx_v2-XPLO_variant_registerGl_registerY_registerZ_simple
	;;
	xplq $a28..a29, $r11 = -1125899906842624[$r10r11.hi] 	#Opcode-lvx_v2-XPLQ_variant_registerGg_registerY_extend27_offset27_registerZ_triple
	;;
	xplq.s $a30..a31, $r8r9r10r11.t = -8388608[$r12] 	#Opcode-lvx_v2-XPLQ_variant_registerGg_registerY_offset27_registerZ_double
	;;
	xplq.u $a32..a33, $sp = [$r13] 	#Opcode-lvx_v2-XPLQ_variant_registerGg_registerY_registerZ_simple
	;;
	xplq.us $a56..a59, $tp = -1125899906842624[$r14] 	#Opcode-lvx_v2-XPLQ_variant_registerGh_registerY_extend27_offset27_registerZ_triple
	;;
	xplq $a60..a63, $fp = -8388608[$r14r15.lo] 	#Opcode-lvx_v2-XPLQ_variant_registerGh_registerY_offset27_registerZ_double
	;;
	xplq.s $a0..a3, $r15 = [$rp] 	#Opcode-lvx_v2-XPLQ_variant_registerGh_registerY_registerZ_simple
	;;
	xplq.u $a48..a55, $r14r15.hi = -1125899906842624[$r16] 	#Opcode-lvx_v2-XPLQ_variant_registerGi_registerY_extend27_offset27_registerZ_triple
	;;
	xplq.us $a56..a63, $r16r17.lo = -8388608[$r16r17r18r19.x] 	#Opcode-lvx_v2-XPLQ_variant_registerGi_registerY_offset27_registerZ_double
	;;
	xplq $a0..a7, $r17 = [$r16r17.hi] 	#Opcode-lvx_v2-XPLQ_variant_registerGi_registerY_registerZ_simple
	;;
	xplq.s $a32..a47, $r16r17r18r19.y = -1125899906842624[$r18] 	#Opcode-lvx_v2-XPLQ_variant_registerGj_registerY_extend27_offset27_registerZ_triple
	;;
	xplq.u $a48..a63, $r18r19.lo = -8388608[$r16r17r18r19.z] 	#Opcode-lvx_v2-XPLQ_variant_registerGj_registerY_offset27_registerZ_double
	;;
	xplq.us $a0..a15, $r19 = [$r18r19.hi] 	#Opcode-lvx_v2-XPLQ_variant_registerGj_registerY_registerZ_simple
	;;
	xplq $a0..a31, $r16r17r18r19.t = -1125899906842624[$r20] 	#Opcode-lvx_v2-XPLQ_variant_registerGk_registerY_extend27_offset27_registerZ_triple
	;;
	xplq.s $a32..a63, $r20r21.lo = -8388608[$r20r21r22r23.x] 	#Opcode-lvx_v2-XPLQ_variant_registerGk_registerY_offset27_registerZ_double
	;;
	xplq.u $a0..a31, $r21 = [$r20r21.hi] 	#Opcode-lvx_v2-XPLQ_variant_registerGk_registerY_registerZ_simple
	;;
	xplq.us $a0..a63, $r20r21r22r23.y = -1125899906842624[$r22] 	#Opcode-lvx_v2-XPLQ_variant_registerGl_registerY_extend27_offset27_registerZ_triple
	;;
	xplq $a0..a63, $r22r23.lo = -8388608[$r20r21r22r23.z] 	#Opcode-lvx_v2-XPLQ_variant_registerGl_registerY_offset27_registerZ_double
	;;
	xplq.s $a0..a63, $r23 = [$r22r23.hi] 	#Opcode-lvx_v2-XPLQ_variant_registerGl_registerY_registerZ_simple
	;;
	xplw.u $a34..a35, $r20r21r22r23.t = -1125899906842624[$r24] 	#Opcode-lvx_v2-XPLW_variant_registerGg_registerY_extend27_offset27_registerZ_triple
	;;
	xplw.us $a36..a37, $r24r25.lo = -8388608[$r24r25r26r27.x] 	#Opcode-lvx_v2-XPLW_variant_registerGg_registerY_offset27_registerZ_double
	;;
	xplw $a38..a39, $r25 = [$r24r25.hi] 	#Opcode-lvx_v2-XPLW_variant_registerGg_registerY_registerZ_simple
	;;
	xplw.s $a4..a7, $r24r25r26r27.y = -1125899906842624[$r26] 	#Opcode-lvx_v2-XPLW_variant_registerGh_registerY_extend27_offset27_registerZ_triple
	;;
	xplw.u $a8..a11, $r26r27.lo = -8388608[$r24r25r26r27.z] 	#Opcode-lvx_v2-XPLW_variant_registerGh_registerY_offset27_registerZ_double
	;;
	xplw.us $a12..a15, $r27 = [$r26r27.hi] 	#Opcode-lvx_v2-XPLW_variant_registerGh_registerY_registerZ_simple
	;;
	xplw $a8..a15, $r24r25r26r27.t = -1125899906842624[$r28] 	#Opcode-lvx_v2-XPLW_variant_registerGi_registerY_extend27_offset27_registerZ_triple
	;;
	xplw.s $a16..a23, $r28r29.lo = -8388608[$r28r29r30r31.x] 	#Opcode-lvx_v2-XPLW_variant_registerGi_registerY_offset27_registerZ_double
	;;
	xplw.u $a24..a31, $r29 = [$r28r29.hi] 	#Opcode-lvx_v2-XPLW_variant_registerGi_registerY_registerZ_simple
	;;
	xplw.us $a16..a31, $r28r29r30r31.y = -1125899906842624[$r30] 	#Opcode-lvx_v2-XPLW_variant_registerGj_registerY_extend27_offset27_registerZ_triple
	;;
	xplw $a32..a47, $r30r31.lo = -8388608[$r28r29r30r31.z] 	#Opcode-lvx_v2-XPLW_variant_registerGj_registerY_offset27_registerZ_double
	;;
	xplw.s $a48..a63, $r31 = [$r30r31.hi] 	#Opcode-lvx_v2-XPLW_variant_registerGj_registerY_registerZ_simple
	;;
	xplw.u $a32..a63, $r28r29r30r31.t = -1125899906842624[$r32] 	#Opcode-lvx_v2-XPLW_variant_registerGk_registerY_extend27_offset27_registerZ_triple
	;;
	xplw.us $a0..a31, $r32r33.lo = -8388608[$r32r33r34r35.x] 	#Opcode-lvx_v2-XPLW_variant_registerGk_registerY_offset27_registerZ_double
	;;
	xplw $a32..a63, $r33 = [$r32r33.hi] 	#Opcode-lvx_v2-XPLW_variant_registerGk_registerY_registerZ_simple
	;;
	xplw.s $a0..a63, $r32r33r34r35.y = -1125899906842624[$r34] 	#Opcode-lvx_v2-XPLW_variant_registerGl_registerY_extend27_offset27_registerZ_triple
	;;
	xplw.u $a0..a63, $r34r35.lo = -8388608[$r32r33r34r35.z] 	#Opcode-lvx_v2-XPLW_variant_registerGl_registerY_offset27_registerZ_double
	;;
	xplw.us $a0..a63, $r35 = [$r34r35.hi] 	#Opcode-lvx_v2-XPLW_variant_registerGl_registerY_registerZ_simple
	;;
	xso 2305843009213693951[$r32r33r34r35.t] = $a4a5a6a7.x 	#Opcode-lvx_v2-XSO_extend27_upper27_lower10_registerZ_registerE_triple
	;;
	xso.q0 2305843009213693951[$r36] = $a16a17a18a19 	#Opcode-lvx_v2-XSO_qindex_extend27_upper27_lower10_registerZ_registerEq_triple
	;;
	xso.q1 $r36r37.lo[$r36r37r38r39.x] = $a20a21a22a23 	#Opcode-lvx_v2-XSO_qindex_registerY_registerZ_registerEq_simple
	;;
	xso.q2 -64[$r37] = $a24a25a26a27 	#Opcode-lvx_v2-XSO_qindex_signed10_registerZ_registerEq_simple
	;;
	xso.q3 -8589934592[$r36r37.hi] = $a28a29a30a31 	#Opcode-lvx_v2-XSO_qindex_upper27_lower10_registerZ_registerEq_double
	;;
	xso $r36r37r38r39.y[$r38] = $a5 	#Opcode-lvx_v2-XSO_registerY_registerZ_registerE_simple
	;;
	xso -64[$r38r39.lo] = $a4a5.hi 	#Opcode-lvx_v2-XSO_signed10_registerZ_registerE_simple
	;;
	xso -8589934592[$r36r37r38r39.z] = $a4a5a6a7.y 	#Opcode-lvx_v2-XSO_upper27_lower10_registerZ_registerE_double
	;;
	zxbd $r39 = $r38r39.hi 	#Opcode-lvx_v2-ZXBD_registerW_registerZ_simple
	;;
	zxhd $r36r37r38r39.t = $r40 	#Opcode-lvx_v2-ZXHD_registerW_registerZ_simple
	;;
	zxwd $r40r41.lo = $r40r41r42r43.x 	#Opcode-lvx_v2-ZXWD_registerW_registerZ_simple
	;;
	.endp	main
	.section .text

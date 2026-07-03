	##-----------------------------------------------------------
	## Generating test.s from MDS
	## (c) Copyright 2010-2018 Kalray SA.
	##-----------------------------------------------------------

#	Option: '-m32'

##	target-core:	lvx-1

	.section .text

	.align 8
	.proc	main
	.global	main
main:
	abdbo $r0 = $r0r1.lo, $r0r1r2r3.x 	#Opcode-lvx_v1-ABDBO_registerWe_registerZe_registerYe_simple
	;;
	abdbo $r2 = $r2r3.lo, 536870911 	#Opcode-lvx_v1-ABDBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	abdbo $r1 = $r0r1.hi, $r0r1r2r3.y 	#Opcode-lvx_v1-ABDBO_registerWo_registerZo_registerYo_simple
	;;
	abdbo $r3 = $r2r3.hi, 536870911.@ 	#Opcode-lvx_v1-ABDBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	abdd $r0 = $r0r1.lo, $r0r1r2r3.x 	#Opcode-lvx_v1-ABDD_registerW_registerZ_registerY_simple
	;;
	abdd $r1 = $r0r1.hi, 536870911 	#Opcode-lvx_v1-ABDD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	abdhq $r0r1r2r3.z = $r4, $r4r5.lo 	#Opcode-lvx_v1-ABDHQ_registerWe_registerZe_registerYe_simple
	;;
	abdhq $r4r5r6r7.x = $r6, 536870911.@ 	#Opcode-lvx_v1-ABDHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	abdhq $r0r1r2r3.t = $r5, $r4r5.hi 	#Opcode-lvx_v1-ABDHQ_registerWo_registerZo_registerYo_simple
	;;
	abdhq $r4r5r6r7.y = $r7, 536870911 	#Opcode-lvx_v1-ABDHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	abdsbo $r6r7.lo = $r4r5r6r7.z, $r8 	#Opcode-lvx_v1-ABDSBO_registerWe_registerZe_registerYe_simple
	;;
	abdsbo $r8r9.lo = $r8r9r10r11.x, 536870911.@ 	#Opcode-lvx_v1-ABDSBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	abdsbo $r6r7.hi = $r4r5r6r7.t, $r9 	#Opcode-lvx_v1-ABDSBO_registerWo_registerZo_registerYo_simple
	;;
	abdsbo $r8r9.hi = $r8r9r10r11.y, 536870911 	#Opcode-lvx_v1-ABDSBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	abdsd $r0r1r2r3.y = $r2, $r2r3.lo 	#Opcode-lvx_v1-ABDSD_registerW_registerZ_registerY_simple
	;;
	abdsd $r0r1r2r3.z = $r3, 536870911.@ 	#Opcode-lvx_v1-ABDSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	abdshq $r10 = $r10r11.lo, $r8r9r10r11.z 	#Opcode-lvx_v1-ABDSHQ_registerWe_registerZe_registerYe_simple
	;;
	abdshq $r12 = $sp, 536870911 	#Opcode-lvx_v1-ABDSHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	abdshq $r11 = $r10r11.hi, $r8r9r10r11.t 	#Opcode-lvx_v1-ABDSHQ_registerWo_registerZo_registerYo_simple
	;;
	abdshq $r13 = $tp, 536870911.@ 	#Opcode-lvx_v1-ABDSHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	abdswp $r14 = $fp, $r14r15.lo 	#Opcode-lvx_v1-ABDSWP_registerWe_registerZe_registerYe_simple
	;;
	abdswp $r16 = $r16r17.lo, 536870911 	#Opcode-lvx_v1-ABDSWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	abdswp $r15 = $rp, $r14r15.hi 	#Opcode-lvx_v1-ABDSWP_registerWo_registerZo_registerYo_simple
	;;
	abdswp $r17 = $r16r17.hi, 536870911.@ 	#Opcode-lvx_v1-ABDSWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	abdsw $r2r3.hi = $r0r1r2r3.t, $r4 	#Opcode-lvx_v1-ABDSW_signextw_registerW_registerZ_registerY_simple
	;;
	abdsw.sx $r4r5.lo = $r4r5r6r7.x, 536870911 	#Opcode-lvx_v1-ABDSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	abdubo $r16r17r18r19.x = $r18, $r18r19.lo 	#Opcode-lvx_v1-ABDUBO_registerWe_registerZe_registerYe_simple
	;;
	abdubo $r16r17r18r19.z = $r20, 536870911 	#Opcode-lvx_v1-ABDUBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	abdubo $r16r17r18r19.y = $r19, $r18r19.hi 	#Opcode-lvx_v1-ABDUBO_registerWo_registerZo_registerYo_simple
	;;
	abdubo $r16r17r18r19.t = $r21, 536870911.@ 	#Opcode-lvx_v1-ABDUBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	abdud $r5 = $r4r5.hi, $r4r5r6r7.y 	#Opcode-lvx_v1-ABDUD_registerW_registerZ_registerY_simple
	;;
	abdud $r6 = $r6r7.lo, 536870911 	#Opcode-lvx_v1-ABDUD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	abduhq $r20r21.lo = $r20r21r22r23.x, $r22 	#Opcode-lvx_v1-ABDUHQ_registerWe_registerZe_registerYe_simple
	;;
	abduhq $r22r23.lo = $r20r21r22r23.z, 536870911.@ 	#Opcode-lvx_v1-ABDUHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	abduhq $r20r21.hi = $r20r21r22r23.y, $r23 	#Opcode-lvx_v1-ABDUHQ_registerWo_registerZo_registerYo_simple
	;;
	abduhq $r22r23.hi = $r20r21r22r23.t, 536870911 	#Opcode-lvx_v1-ABDUHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	abduwp $r24 = $r24r25.lo, $r24r25r26r27.x 	#Opcode-lvx_v1-ABDUWP_registerWe_registerZe_registerYe_simple
	;;
	abduwp $r26 = $r26r27.lo, 536870911.@ 	#Opcode-lvx_v1-ABDUWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	abduwp $r25 = $r24r25.hi, $r24r25r26r27.y 	#Opcode-lvx_v1-ABDUWP_registerWo_registerZo_registerYo_simple
	;;
	abduwp $r27 = $r26r27.hi, 536870911 	#Opcode-lvx_v1-ABDUWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	abduw $r4r5r6r7.z = $r7, $r6r7.hi 	#Opcode-lvx_v1-ABDUW_signextw_registerW_registerZ_registerY_simple
	;;
	abduw.sx $r4r5r6r7.t = $r8, 536870911 	#Opcode-lvx_v1-ABDUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	abdwp $r24r25r26r27.z = $r28, $r28r29.lo 	#Opcode-lvx_v1-ABDWP_registerWe_registerZe_registerYe_simple
	;;
	abdwp $r28r29r30r31.x = $r30, 536870911.@ 	#Opcode-lvx_v1-ABDWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	abdwp $r24r25r26r27.t = $r29, $r28r29.hi 	#Opcode-lvx_v1-ABDWP_registerWo_registerZo_registerYo_simple
	;;
	abdwp $r28r29r30r31.y = $r31, 536870911 	#Opcode-lvx_v1-ABDWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	abdw $r8r9.lo = $r8r9r10r11.x, $r9 	#Opcode-lvx_v1-ABDW_signextw_registerW_registerZ_registerY_simple
	;;
	abdw.sx $r8r9.hi = $r8r9r10r11.y, 536870911 	#Opcode-lvx_v1-ABDW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	absbo $r30r31.lo = $r28r29r30r31.z 	#Opcode-lvx_v1-ABSBO_registerWe_registerZe_simple
	;;
	absbo $r30r31.hi = $r28r29r30r31.t 	#Opcode-lvx_v1-ABSBO_registerWo_registerZo_simple
	;;
	absd $r10 = $r10r11.lo 	#Opcode-lvx_v1-ABSD_registerW_registerZ_simple
	;;
	abshq $r32 = $r32r33.lo 	#Opcode-lvx_v1-ABSHQ_registerWe_registerZe_simple
	;;
	abshq $r33 = $r32r33.hi 	#Opcode-lvx_v1-ABSHQ_registerWo_registerZo_simple
	;;
	abssbo $r32r33r34r35.x = $r34 	#Opcode-lvx_v1-ABSSBO_registerWe_registerZe_simple
	;;
	abssbo $r32r33r34r35.y = $r35 	#Opcode-lvx_v1-ABSSBO_registerWo_registerZo_simple
	;;
	abssd $r8r9r10r11.z = $r11 	#Opcode-lvx_v1-ABSSD_registerW_registerZ_simple
	;;
	absshq $r34r35.lo = $r32r33r34r35.z 	#Opcode-lvx_v1-ABSSHQ_registerWe_registerZe_simple
	;;
	absshq $r34r35.hi = $r32r33r34r35.t 	#Opcode-lvx_v1-ABSSHQ_registerWo_registerZo_simple
	;;
	absswp $r36 = $r36r37.lo 	#Opcode-lvx_v1-ABSSWP_registerWe_registerZe_simple
	;;
	absswp $r37 = $r36r37.hi 	#Opcode-lvx_v1-ABSSWP_registerWo_registerZo_simple
	;;
	abssw $r10r11.hi = $r8r9r10r11.t 	#Opcode-lvx_v1-ABSSW_registerW_registerZ_simple
	;;
	abswp $r36r37r38r39.x = $r38 	#Opcode-lvx_v1-ABSWP_registerWe_registerZe_simple
	;;
	abswp $r36r37r38r39.y = $r39 	#Opcode-lvx_v1-ABSWP_registerWo_registerZo_simple
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
	addbo $r38r39.lo = $r36r37r38r39.z, $r40 	#Opcode-lvx_v1-ADDBO_registerWe_registerZe_registerYe_simple
	;;
	addbo $r40r41.lo = $r40r41r42r43.x, 536870911.@ 	#Opcode-lvx_v1-ADDBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addbo $r38r39.hi = $r36r37r38r39.t, $r41 	#Opcode-lvx_v1-ADDBO_registerWo_registerZo_registerYo_simple
	;;
	addbo $r40r41.hi = $r40r41r42r43.y, 536870911 	#Opcode-lvx_v1-ADDBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addd $r22r23.lo = $r20r21r22r23.z, 2305843009213693951 	#Opcode-lvx_v1-ADDD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	addd $r23 = $r22r23.hi, $r20r21r22r23.t 	#Opcode-lvx_v1-ADDD_registerW_registerZ_registerY_simple
	;;
	addd $r24 = $r24r25.lo, -64 	#Opcode-lvx_v1-ADDD_registerW_registerZ_signed10_simple
	;;
	addd $r24r25r26r27.x = $r25, -8589934592 	#Opcode-lvx_v1-ADDD_registerW_registerZ_upper27_lower10_double
	;;
	addhq $r42 = $r42r43.lo, $r40r41r42r43.z 	#Opcode-lvx_v1-ADDHQ_registerWe_registerZe_registerYe_simple
	;;
	addhq $r44 = $r44r45.lo, 536870911.@ 	#Opcode-lvx_v1-ADDHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addhq $r43 = $r42r43.hi, $r40r41r42r43.t 	#Opcode-lvx_v1-ADDHQ_registerWo_registerZo_registerYo_simple
	;;
	addhq $r45 = $r44r45.hi, 536870911 	#Opcode-lvx_v1-ADDHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addq $r12r13r14r15.hi = $r16r17, $r16r17r18r19.lo 	#Opcode-lvx_v1-ADDQ_registerM_registerP_registerO_simple
	;;
	addq $r18r19 = $r16r17r18r19.hi, 536870911.@ 	#Opcode-lvx_v1-ADDQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	addsbo $r44r45r46r47.x = $r46, $r46r47.lo 	#Opcode-lvx_v1-ADDSBO_registerWe_registerZe_registerYe_simple
	;;
	addsbo $r44r45r46r47.z = $r48, 536870911 	#Opcode-lvx_v1-ADDSBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addsbo $r44r45r46r47.y = $r47, $r46r47.hi 	#Opcode-lvx_v1-ADDSBO_registerWo_registerZo_registerYo_simple
	;;
	addsbo $r44r45r46r47.t = $r49, 536870911.@ 	#Opcode-lvx_v1-ADDSBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addsd $r24r25.hi = $r24r25r26r27.y, $r26 	#Opcode-lvx_v1-ADDSD_registerW_registerZ_registerY_simple
	;;
	addsd $r26r27.lo = $r24r25r26r27.z, 536870911 	#Opcode-lvx_v1-ADDSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addshq $r48r49.lo = $r48r49r50r51.x, $r50 	#Opcode-lvx_v1-ADDSHQ_registerWe_registerZe_registerYe_simple
	;;
	addshq $r50r51.lo = $r48r49r50r51.z, 536870911.@ 	#Opcode-lvx_v1-ADDSHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addshq $r48r49.hi = $r48r49r50r51.y, $r51 	#Opcode-lvx_v1-ADDSHQ_registerWo_registerZo_registerYo_simple
	;;
	addshq $r50r51.hi = $r48r49r50r51.t, 536870911 	#Opcode-lvx_v1-ADDSHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addswp $r52 = $r52r53.lo, $r52r53r54r55.x 	#Opcode-lvx_v1-ADDSWP_registerWe_registerZe_registerYe_simple
	;;
	addswp $r54 = $r54r55.lo, 536870911.@ 	#Opcode-lvx_v1-ADDSWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addswp $r53 = $r52r53.hi, $r52r53r54r55.y 	#Opcode-lvx_v1-ADDSWP_registerWo_registerZo_registerYo_simple
	;;
	addswp $r55 = $r54r55.hi, 536870911 	#Opcode-lvx_v1-ADDSWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addsw $r27 = $r26r27.hi, $r24r25r26r27.t 	#Opcode-lvx_v1-ADDSW_signextw_registerW_registerZ_registerY_simple
	;;
	addsw.sx $r28 = $r28r29.lo, 536870911 	#Opcode-lvx_v1-ADDSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addusbo $r52r53r54r55.z = $r56, $r56r57.lo 	#Opcode-lvx_v1-ADDUSBO_registerWe_registerZe_registerYe_simple
	;;
	addusbo $r56r57r58r59.x = $r58, 536870911.@ 	#Opcode-lvx_v1-ADDUSBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addusbo $r52r53r54r55.t = $r57, $r56r57.hi 	#Opcode-lvx_v1-ADDUSBO_registerWo_registerZo_registerYo_simple
	;;
	addusbo $r56r57r58r59.y = $r59, 536870911 	#Opcode-lvx_v1-ADDUSBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addusd $r28r29r30r31.x = $r29, $r28r29.hi 	#Opcode-lvx_v1-ADDUSD_registerW_registerZ_registerY_simple
	;;
	addusd $r28r29r30r31.y = $r30, 536870911.@ 	#Opcode-lvx_v1-ADDUSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addushq $r58r59.lo = $r56r57r58r59.z, $r60 	#Opcode-lvx_v1-ADDUSHQ_registerWe_registerZe_registerYe_simple
	;;
	addushq $r60r61.lo = $r60r61r62r63.x, 536870911 	#Opcode-lvx_v1-ADDUSHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addushq $r58r59.hi = $r56r57r58r59.t, $r61 	#Opcode-lvx_v1-ADDUSHQ_registerWo_registerZo_registerYo_simple
	;;
	addushq $r60r61.hi = $r60r61r62r63.y, 536870911.@ 	#Opcode-lvx_v1-ADDUSHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	adduswp $r62 = $r62r63.lo, $r60r61r62r63.z 	#Opcode-lvx_v1-ADDUSWP_registerWe_registerZe_registerYe_simple
	;;
	adduswp $r0 = $r0r1.lo, 536870911 	#Opcode-lvx_v1-ADDUSWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	adduswp $r63 = $r62r63.hi, $r60r61r62r63.t 	#Opcode-lvx_v1-ADDUSWP_registerWo_registerZo_registerYo_simple
	;;
	adduswp $r1 = $r0r1.hi, 536870911.@ 	#Opcode-lvx_v1-ADDUSWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addusw $r30r31.lo = $r28r29r30r31.z, $r31 	#Opcode-lvx_v1-ADDUSW_signextw_registerW_registerZ_registerY_simple
	;;
	addusw.sx $r30r31.hi = $r28r29r30r31.t, 536870911 	#Opcode-lvx_v1-ADDUSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addwp $r0r1r2r3.x = $r2, $r2r3.lo 	#Opcode-lvx_v1-ADDWP_registerWe_registerZe_registerYe_simple
	;;
	addwp $r0r1r2r3.z = $r4, 536870911 	#Opcode-lvx_v1-ADDWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addwp $r0r1r2r3.y = $r3, $r2r3.hi 	#Opcode-lvx_v1-ADDWP_registerWo_registerZo_registerYo_simple
	;;
	addwp $r0r1r2r3.t = $r5, 536870911.@ 	#Opcode-lvx_v1-ADDWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addw $r32 = $r32r33.lo, $r32r33r34r35.x 	#Opcode-lvx_v1-ADDW_signextw_registerW_registerZ_registerY_simple
	;;
	addw.sx $r33 = $r32r33.hi, 536870911 	#Opcode-lvx_v1-ADDW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addx16bo $r4r5.lo = $r4r5r6r7.x, $r6 	#Opcode-lvx_v1-ADDX16BO_registerWe_registerZe_registerYe_simple
	;;
	addx16bo $r6r7.lo = $r4r5r6r7.z, 536870911 	#Opcode-lvx_v1-ADDX16BO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addx16bo $r4r5.hi = $r4r5r6r7.y, $r7 	#Opcode-lvx_v1-ADDX16BO_registerWo_registerZo_registerYo_simple
	;;
	addx16bo $r6r7.hi = $r4r5r6r7.t, 536870911.@ 	#Opcode-lvx_v1-ADDX16BO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addx16d $r32r33r34r35.y = $r34, $r34r35.lo 	#Opcode-lvx_v1-ADDX16D_registerW_registerZ_registerY_simple
	;;
	addx16d $r32r33r34r35.z = $r35, 536870911 	#Opcode-lvx_v1-ADDX16D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx16hq $r8 = $r8r9.lo, $r8r9r10r11.x 	#Opcode-lvx_v1-ADDX16HQ_registerWe_registerZe_registerYe_simple
	;;
	addx16hq $r10 = $r10r11.lo, 536870911.@ 	#Opcode-lvx_v1-ADDX16HQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addx16hq $r9 = $r8r9.hi, $r8r9r10r11.y 	#Opcode-lvx_v1-ADDX16HQ_registerWo_registerZo_registerYo_simple
	;;
	addx16hq $r11 = $r10r11.hi, 536870911 	#Opcode-lvx_v1-ADDX16HQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addx16wp $r8r9r10r11.z = $r12, $sp 	#Opcode-lvx_v1-ADDX16WP_registerWe_registerZe_registerYe_simple
	;;
	addx16wp $r14 = $fp, 536870911.@ 	#Opcode-lvx_v1-ADDX16WP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addx16wp $r8r9r10r11.t = $r13, $tp 	#Opcode-lvx_v1-ADDX16WP_registerWo_registerZo_registerYo_simple
	;;
	addx16wp $r15 = $rp, 536870911 	#Opcode-lvx_v1-ADDX16WP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addx16w $r34r35.hi = $r32r33r34r35.t, $r36 	#Opcode-lvx_v1-ADDX16W_signextw_registerW_registerZ_registerY_simple
	;;
	addx16w.sx $r36r37.lo = $r36r37r38r39.x, 536870911 	#Opcode-lvx_v1-ADDX16W_signextw_registerW_registerZ_upper27_lower5_double
	;;
	addx2bo $r14r15.lo = $r16, $r16r17.lo 	#Opcode-lvx_v1-ADDX2BO_registerWe_registerZe_registerYe_simple
	;;
	addx2bo $r16r17r18r19.x = $r18, 536870911.@ 	#Opcode-lvx_v1-ADDX2BO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addx2bo $r14r15.hi = $r17, $r16r17.hi 	#Opcode-lvx_v1-ADDX2BO_registerWo_registerZo_registerYo_simple
	;;
	addx2bo $r16r17r18r19.y = $r19, 536870911 	#Opcode-lvx_v1-ADDX2BO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addx2d $r37 = $r36r37.hi, $r36r37r38r39.y 	#Opcode-lvx_v1-ADDX2D_registerW_registerZ_registerY_simple
	;;
	addx2d $r38 = $r38r39.lo, 536870911.@ 	#Opcode-lvx_v1-ADDX2D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx2hq $r18r19.lo = $r16r17r18r19.z, $r20 	#Opcode-lvx_v1-ADDX2HQ_registerWe_registerZe_registerYe_simple
	;;
	addx2hq $r20r21.lo = $r20r21r22r23.x, 536870911 	#Opcode-lvx_v1-ADDX2HQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addx2hq $r18r19.hi = $r16r17r18r19.t, $r21 	#Opcode-lvx_v1-ADDX2HQ_registerWo_registerZo_registerYo_simple
	;;
	addx2hq $r20r21.hi = $r20r21r22r23.y, 536870911.@ 	#Opcode-lvx_v1-ADDX2HQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addx2wp $r22 = $r22r23.lo, $r20r21r22r23.z 	#Opcode-lvx_v1-ADDX2WP_registerWe_registerZe_registerYe_simple
	;;
	addx2wp $r24 = $r24r25.lo, 536870911 	#Opcode-lvx_v1-ADDX2WP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addx2wp $r23 = $r22r23.hi, $r20r21r22r23.t 	#Opcode-lvx_v1-ADDX2WP_registerWo_registerZo_registerYo_simple
	;;
	addx2wp $r25 = $r24r25.hi, 536870911.@ 	#Opcode-lvx_v1-ADDX2WP_registerWo_registerZo_upper27_lower5_splat32_double
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
	addx4bo $r24r25r26r27.x = $r26, $r26r27.lo 	#Opcode-lvx_v1-ADDX4BO_registerWe_registerZe_registerYe_simple
	;;
	addx4bo $r24r25r26r27.z = $r28, 536870911.@ 	#Opcode-lvx_v1-ADDX4BO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addx4bo $r24r25r26r27.y = $r27, $r26r27.hi 	#Opcode-lvx_v1-ADDX4BO_registerWo_registerZo_registerYo_simple
	;;
	addx4bo $r24r25r26r27.t = $r29, 536870911 	#Opcode-lvx_v1-ADDX4BO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addx4d $r40r41r42r43.t = $r44, $r44r45.lo 	#Opcode-lvx_v1-ADDX4D_registerW_registerZ_registerY_simple
	;;
	addx4d $r44r45r46r47.x = $r45, 536870911.@ 	#Opcode-lvx_v1-ADDX4D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx4hq $r28r29.lo = $r28r29r30r31.x, $r30 	#Opcode-lvx_v1-ADDX4HQ_registerWe_registerZe_registerYe_simple
	;;
	addx4hq $r30r31.lo = $r28r29r30r31.z, 536870911 	#Opcode-lvx_v1-ADDX4HQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addx4hq $r28r29.hi = $r28r29r30r31.y, $r31 	#Opcode-lvx_v1-ADDX4HQ_registerWo_registerZo_registerYo_simple
	;;
	addx4hq $r30r31.hi = $r28r29r30r31.t, 536870911.@ 	#Opcode-lvx_v1-ADDX4HQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addx4wp $r32 = $r32r33.lo, $r32r33r34r35.x 	#Opcode-lvx_v1-ADDX4WP_registerWe_registerZe_registerYe_simple
	;;
	addx4wp $r34 = $r34r35.lo, 536870911 	#Opcode-lvx_v1-ADDX4WP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addx4wp $r33 = $r32r33.hi, $r32r33r34r35.y 	#Opcode-lvx_v1-ADDX4WP_registerWo_registerZo_registerYo_simple
	;;
	addx4wp $r35 = $r34r35.hi, 536870911.@ 	#Opcode-lvx_v1-ADDX4WP_registerWo_registerZo_upper27_lower5_splat32_double
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
	addx8bo $r32r33r34r35.z = $r36, $r36r37.lo 	#Opcode-lvx_v1-ADDX8BO_registerWe_registerZe_registerYe_simple
	;;
	addx8bo $r36r37r38r39.x = $r38, 536870911.@ 	#Opcode-lvx_v1-ADDX8BO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addx8bo $r32r33r34r35.t = $r37, $r36r37.hi 	#Opcode-lvx_v1-ADDX8BO_registerWo_registerZo_registerYo_simple
	;;
	addx8bo $r36r37r38r39.y = $r39, 536870911 	#Opcode-lvx_v1-ADDX8BO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addx8d $r50r51.lo = $r48r49r50r51.z, $r51 	#Opcode-lvx_v1-ADDX8D_registerW_registerZ_registerY_simple
	;;
	addx8d $r50r51.hi = $r48r49r50r51.t, 536870911.@ 	#Opcode-lvx_v1-ADDX8D_registerW_registerZ_upper27_lower5_splat32_double
	;;
	addx8hq $r38r39.lo = $r36r37r38r39.z, $r40 	#Opcode-lvx_v1-ADDX8HQ_registerWe_registerZe_registerYe_simple
	;;
	addx8hq $r40r41.lo = $r40r41r42r43.x, 536870911 	#Opcode-lvx_v1-ADDX8HQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addx8hq $r38r39.hi = $r36r37r38r39.t, $r41 	#Opcode-lvx_v1-ADDX8HQ_registerWo_registerZo_registerYo_simple
	;;
	addx8hq $r40r41.hi = $r40r41r42r43.y, 536870911.@ 	#Opcode-lvx_v1-ADDX8HQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	addx8wp $r42 = $r42r43.lo, $r40r41r42r43.z 	#Opcode-lvx_v1-ADDX8WP_registerWe_registerZe_registerYe_simple
	;;
	addx8wp $r44 = $r44r45.lo, 536870911 	#Opcode-lvx_v1-ADDX8WP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	addx8wp $r43 = $r42r43.hi, $r40r41r42r43.t 	#Opcode-lvx_v1-ADDX8WP_registerWo_registerZo_registerYo_simple
	;;
	addx8wp $r45 = $r44r45.hi, 536870911.@ 	#Opcode-lvx_v1-ADDX8WP_registerWo_registerZo_upper27_lower5_splat32_double
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
	avgbo $r44r45r46r47.x = $r46, $r46r47.lo 	#Opcode-lvx_v1-AVGBO_registerWe_registerZe_registerYe_simple
	;;
	avgbo $r44r45r46r47.z = $r48, 536870911 	#Opcode-lvx_v1-AVGBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	avgbo $r44r45r46r47.y = $r47, $r46r47.hi 	#Opcode-lvx_v1-AVGBO_registerWo_registerZo_registerYo_simple
	;;
	avgbo $r44r45r46r47.t = $r49, 536870911.@ 	#Opcode-lvx_v1-AVGBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	avghq $r48r49.lo = $r48r49r50r51.x, $r50 	#Opcode-lvx_v1-AVGHQ_registerWe_registerZe_registerYe_simple
	;;
	avghq $r50r51.lo = $r48r49r50r51.z, 536870911 	#Opcode-lvx_v1-AVGHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	avghq $r48r49.hi = $r48r49r50r51.y, $r51 	#Opcode-lvx_v1-AVGHQ_registerWo_registerZo_registerYo_simple
	;;
	avghq $r50r51.hi = $r48r49r50r51.t, 536870911.@ 	#Opcode-lvx_v1-AVGHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	avgrbo $r52 = $r52r53.lo, $r52r53r54r55.x 	#Opcode-lvx_v1-AVGRBO_registerWe_registerZe_registerYe_simple
	;;
	avgrbo $r54 = $r54r55.lo, 536870911 	#Opcode-lvx_v1-AVGRBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	avgrbo $r53 = $r52r53.hi, $r52r53r54r55.y 	#Opcode-lvx_v1-AVGRBO_registerWo_registerZo_registerYo_simple
	;;
	avgrbo $r55 = $r54r55.hi, 536870911.@ 	#Opcode-lvx_v1-AVGRBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	avgrhq $r52r53r54r55.z = $r56, $r56r57.lo 	#Opcode-lvx_v1-AVGRHQ_registerWe_registerZe_registerYe_simple
	;;
	avgrhq $r56r57r58r59.x = $r58, 536870911 	#Opcode-lvx_v1-AVGRHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	avgrhq $r52r53r54r55.t = $r57, $r56r57.hi 	#Opcode-lvx_v1-AVGRHQ_registerWo_registerZo_registerYo_simple
	;;
	avgrhq $r56r57r58r59.y = $r59, 536870911.@ 	#Opcode-lvx_v1-AVGRHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	avgrubo $r58r59.lo = $r56r57r58r59.z, $r60 	#Opcode-lvx_v1-AVGRUBO_registerWe_registerZe_registerYe_simple
	;;
	avgrubo $r60r61.lo = $r60r61r62r63.x, 536870911 	#Opcode-lvx_v1-AVGRUBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	avgrubo $r58r59.hi = $r56r57r58r59.t, $r61 	#Opcode-lvx_v1-AVGRUBO_registerWo_registerZo_registerYo_simple
	;;
	avgrubo $r60r61.hi = $r60r61r62r63.y, 536870911.@ 	#Opcode-lvx_v1-AVGRUBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	avgruhq $r62 = $r62r63.lo, $r60r61r62r63.z 	#Opcode-lvx_v1-AVGRUHQ_registerWe_registerZe_registerYe_simple
	;;
	avgruhq $r0 = $r0r1.lo, 536870911 	#Opcode-lvx_v1-AVGRUHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	avgruhq $r63 = $r62r63.hi, $r60r61r62r63.t 	#Opcode-lvx_v1-AVGRUHQ_registerWo_registerZo_registerYo_simple
	;;
	avgruhq $r1 = $r0r1.hi, 536870911.@ 	#Opcode-lvx_v1-AVGRUHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	avgruwp $r0r1r2r3.x = $r2, $r2r3.lo 	#Opcode-lvx_v1-AVGRUWP_registerWe_registerZe_registerYe_simple
	;;
	avgruwp $r0r1r2r3.z = $r4, 536870911 	#Opcode-lvx_v1-AVGRUWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	avgruwp $r0r1r2r3.y = $r3, $r2r3.hi 	#Opcode-lvx_v1-AVGRUWP_registerWo_registerZo_registerYo_simple
	;;
	avgruwp $r0r1r2r3.t = $r5, 536870911.@ 	#Opcode-lvx_v1-AVGRUWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	avgruw $r49 = $r48r49.hi, $r48r49r50r51.y 	#Opcode-lvx_v1-AVGRUW_signextw_registerW_registerZ_registerY_simple
	;;
	avgruw.sx $r50 = $r50r51.lo, 536870911 	#Opcode-lvx_v1-AVGRUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	avgrwp $r4r5.lo = $r4r5r6r7.x, $r6 	#Opcode-lvx_v1-AVGRWP_registerWe_registerZe_registerYe_simple
	;;
	avgrwp $r6r7.lo = $r4r5r6r7.z, 536870911 	#Opcode-lvx_v1-AVGRWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	avgrwp $r4r5.hi = $r4r5r6r7.y, $r7 	#Opcode-lvx_v1-AVGRWP_registerWo_registerZo_registerYo_simple
	;;
	avgrwp $r6r7.hi = $r4r5r6r7.t, 536870911.@ 	#Opcode-lvx_v1-AVGRWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	avgrw $r48r49r50r51.z = $r51, $r50r51.hi 	#Opcode-lvx_v1-AVGRW_signextw_registerW_registerZ_registerY_simple
	;;
	avgrw.sx $r48r49r50r51.t = $r52, 536870911 	#Opcode-lvx_v1-AVGRW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	avgubo $r8 = $r8r9.lo, $r8r9r10r11.x 	#Opcode-lvx_v1-AVGUBO_registerWe_registerZe_registerYe_simple
	;;
	avgubo $r10 = $r10r11.lo, 536870911 	#Opcode-lvx_v1-AVGUBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	avgubo $r9 = $r8r9.hi, $r8r9r10r11.y 	#Opcode-lvx_v1-AVGUBO_registerWo_registerZo_registerYo_simple
	;;
	avgubo $r11 = $r10r11.hi, 536870911.@ 	#Opcode-lvx_v1-AVGUBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	avguhq $r8r9r10r11.z = $r12, $sp 	#Opcode-lvx_v1-AVGUHQ_registerWe_registerZe_registerYe_simple
	;;
	avguhq $r14 = $fp, 536870911 	#Opcode-lvx_v1-AVGUHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	avguhq $r8r9r10r11.t = $r13, $tp 	#Opcode-lvx_v1-AVGUHQ_registerWo_registerZo_registerYo_simple
	;;
	avguhq $r15 = $rp, 536870911.@ 	#Opcode-lvx_v1-AVGUHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	avguwp $r14r15.lo = $r16, $r16r17.lo 	#Opcode-lvx_v1-AVGUWP_registerWe_registerZe_registerYe_simple
	;;
	avguwp $r16r17r18r19.x = $r18, 536870911 	#Opcode-lvx_v1-AVGUWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	avguwp $r14r15.hi = $r17, $r16r17.hi 	#Opcode-lvx_v1-AVGUWP_registerWo_registerZo_registerYo_simple
	;;
	avguwp $r16r17r18r19.y = $r19, 536870911.@ 	#Opcode-lvx_v1-AVGUWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	avguw $r52r53.lo = $r52r53r54r55.x, $r53 	#Opcode-lvx_v1-AVGUW_signextw_registerW_registerZ_registerY_simple
	;;
	avguw.sx $r52r53.hi = $r52r53r54r55.y, 536870911 	#Opcode-lvx_v1-AVGUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	avgwp $r18r19.lo = $r16r17r18r19.z, $r20 	#Opcode-lvx_v1-AVGWP_registerWe_registerZe_registerYe_simple
	;;
	avgwp $r20r21.lo = $r20r21r22r23.x, 536870911 	#Opcode-lvx_v1-AVGWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	avgwp $r18r19.hi = $r16r17r18r19.t, $r21 	#Opcode-lvx_v1-AVGWP_registerWo_registerZo_registerYo_simple
	;;
	avgwp $r20r21.hi = $r20r21r22r23.y, 536870911.@ 	#Opcode-lvx_v1-AVGWP_registerWo_registerZo_upper27_lower5_splat32_double
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
	cbshq $r22 = $r22r23.lo 	#Opcode-lvx_v1-CBSHQ_registerWe_registerZe_simple
	;;
	cbshq $r23 = $r22r23.hi 	#Opcode-lvx_v1-CBSHQ_registerWo_registerZo_simple
	;;
	cbswp $r20r21r22r23.z = $r24 	#Opcode-lvx_v1-CBSWP_registerWe_registerZe_simple
	;;
	cbswp $r20r21r22r23.t = $r25 	#Opcode-lvx_v1-CBSWP_registerWo_registerZo_simple
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
	clshq $r24r25.lo = $r24r25r26r27.x 	#Opcode-lvx_v1-CLSHQ_registerWe_registerZe_simple
	;;
	clshq $r24r25.hi = $r24r25r26r27.y 	#Opcode-lvx_v1-CLSHQ_registerWo_registerZo_simple
	;;
	clswp $r26 = $r26r27.lo 	#Opcode-lvx_v1-CLSWP_registerWe_registerZe_simple
	;;
	clswp $r27 = $r26r27.hi 	#Opcode-lvx_v1-CLSWP_registerWo_registerZo_simple
	;;
	clsw $r60r61r62r63.x = $r61 	#Opcode-lvx_v1-CLSW_registerW_registerZ_simple
	;;
	clzd $r60r61.hi = $r60r61r62r63.y 	#Opcode-lvx_v1-CLZD_registerW_registerZ_simple
	;;
	clzhq $r24r25r26r27.z = $r28 	#Opcode-lvx_v1-CLZHQ_registerWe_registerZe_simple
	;;
	clzhq $r24r25r26r27.t = $r29 	#Opcode-lvx_v1-CLZHQ_registerWo_registerZo_simple
	;;
	clzwp $r28r29.lo = $r28r29r30r31.x 	#Opcode-lvx_v1-CLZWP_registerWe_registerZe_simple
	;;
	clzwp $r28r29.hi = $r28r29r30r31.y 	#Opcode-lvx_v1-CLZWP_registerWo_registerZo_simple
	;;
	clzw $r62 = $r62r63.lo 	#Opcode-lvx_v1-CLZW_registerW_registerZ_simple
	;;
	cmovebo.ltz $r30? $r30r31.lo = $r28r29r30r31.z 	#Opcode-lvx_v1-CMOVEBO_lanecond_registerZe_registerWe_registerYe_simple
	;;
	cmovebo.gez $r32? $r32r33.lo = 536870911 	#Opcode-lvx_v1-CMOVEBO_lanecond_registerZe_registerWe_upper27_lower5_splat32_double
	;;
	cmovebo.lez $r31? $r30r31.hi = $r28r29r30r31.t 	#Opcode-lvx_v1-CMOVEBO_lanecond_registerZo_registerWo_registerYo_simple
	;;
	cmovebo.gtz $r33? $r32r33.hi = 536870911.@ 	#Opcode-lvx_v1-CMOVEBO_lanecond_registerZo_registerWo_upper27_lower5_splat32_double
	;;
	cmoved.dlez $r60r61r62r63.z? $r63 = $r62r63.hi 	#Opcode-lvx_v1-CMOVED_cmovecond_registerZ_registerW_registerY_simple
	;;
	cmoved.dgtz $r60r61r62r63.t? $r0 = 536870911 	#Opcode-lvx_v1-CMOVED_cmovecond_registerZ_registerW_upper27_lower5_splat32_double
	;;
	cmovehq.eqz $r32r33r34r35.x? $r34 = $r34r35.lo 	#Opcode-lvx_v1-CMOVEHQ_lanecond_registerZe_registerWe_registerYe_simple
	;;
	cmovehq.nez $r32r33r34r35.z? $r36 = 536870911.@ 	#Opcode-lvx_v1-CMOVEHQ_lanecond_registerZe_registerWe_upper27_lower5_splat32_double
	;;
	cmovehq.odd $r32r33r34r35.y? $r35 = $r34r35.hi 	#Opcode-lvx_v1-CMOVEHQ_lanecond_registerZo_registerWo_registerYo_simple
	;;
	cmovehq.even $r32r33r34r35.t? $r37 = 536870911 	#Opcode-lvx_v1-CMOVEHQ_lanecond_registerZo_registerWo_upper27_lower5_splat32_double
	;;
	cmoveq.deqz $r0r1.lo? $r28r29r30r31.hi = $r32r33 	#Opcode-lvx_v1-CMOVEQ_cmovecond_registerZ_registerM_registerO_simple
	;;
	cmovewp.ltz $r36r37.lo? $r36r37r38r39.x = $r38 	#Opcode-lvx_v1-CMOVEWP_lanecond_registerZe_registerWe_registerYe_simple
	;;
	cmovewp.gez $r38r39.lo? $r36r37r38r39.z = 536870911.@ 	#Opcode-lvx_v1-CMOVEWP_lanecond_registerZe_registerWe_upper27_lower5_splat32_double
	;;
	cmovewp.lez $r36r37.hi? $r36r37r38r39.y = $r39 	#Opcode-lvx_v1-CMOVEWP_lanecond_registerZo_registerWo_registerYo_simple
	;;
	cmovewp.gtz $r38r39.hi? $r36r37r38r39.t = 536870911 	#Opcode-lvx_v1-CMOVEWP_lanecond_registerZo_registerWo_upper27_lower5_splat32_double
	;;
	compbo.lt $r40 = $r40r41.lo, $r40r41r42r43.x 	#Opcode-lvx_v1-COMPBO_intcomp_registerWe_registerZe_registerYe_simple
	;;
	compbo.ge $r42 = $r42r43.lo, 536870911.@ 	#Opcode-lvx_v1-COMPBO_intcomp_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	compbo.ltu $r41 = $r40r41.hi, $r40r41r42r43.y 	#Opcode-lvx_v1-COMPBO_intcomp_registerWo_registerZo_registerYo_simple
	;;
	compbo.geu $r43 = $r42r43.hi, 536870911 	#Opcode-lvx_v1-COMPBO_intcomp_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	compd.eq $r0r1r2r3.x = $r1, $r0r1.hi 	#Opcode-lvx_v1-COMPD_intcomp_registerW_registerZ_registerY_simple
	;;
	compd.ne $r0r1r2r3.y = $r2, 536870911 	#Opcode-lvx_v1-COMPD_intcomp_registerW_registerZ_upper27_lower5_double
	;;
	comphq.any $r40r41r42r43.z = $r44, $r44r45.lo 	#Opcode-lvx_v1-COMPHQ_intcomp_registerWe_registerZe_registerYe_simple
	;;
	comphq.none $r44r45r46r47.x = $r46, 536870911.@ 	#Opcode-lvx_v1-COMPHQ_intcomp_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	comphq.le $r40r41r42r43.t = $r45, $r44r45.hi 	#Opcode-lvx_v1-COMPHQ_intcomp_registerWo_registerZo_registerYo_simple
	;;
	comphq.gt $r44r45r46r47.y = $r47, 536870911 	#Opcode-lvx_v1-COMPHQ_intcomp_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	compnbo.leu $r46r47.lo = $r44r45r46r47.z, $r48 	#Opcode-lvx_v1-COMPNBO_intcomp_registerWe_registerZe_registerYe_simple
	;;
	compnbo.gtu $r48r49.lo = $r48r49r50r51.x, 536870911.@ 	#Opcode-lvx_v1-COMPNBO_intcomp_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	compnbo.lt $r46r47.hi = $r44r45r46r47.t, $r49 	#Opcode-lvx_v1-COMPNBO_intcomp_registerWo_registerZo_registerYo_simple
	;;
	compnbo.ge $r48r49.hi = $r48r49r50r51.y, 536870911 	#Opcode-lvx_v1-COMPNBO_intcomp_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	compnd.ltu $r50 = $r50r51.lo, $r48r49r50r51.z 	#Opcode-lvx_v1-COMPND_intcomp_registerWe_registerZe_registerYe_simple
	;;
	compnd.geu $r52 = $r52r53.lo, 536870911.@ 	#Opcode-lvx_v1-COMPND_intcomp_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	compnd.eq $r51 = $r50r51.hi, $r48r49r50r51.t 	#Opcode-lvx_v1-COMPND_intcomp_registerWo_registerZo_registerYo_simple
	;;
	compnd.ne $r53 = $r52r53.hi, 536870911 	#Opcode-lvx_v1-COMPND_intcomp_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	compnhq.any $r52r53r54r55.x = $r54, $r54r55.lo 	#Opcode-lvx_v1-COMPNHQ_intcomp_registerWe_registerZe_registerYe_simple
	;;
	compnhq.none $r52r53r54r55.z = $r56, 536870911.@ 	#Opcode-lvx_v1-COMPNHQ_intcomp_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	compnhq.le $r52r53r54r55.y = $r55, $r54r55.hi 	#Opcode-lvx_v1-COMPNHQ_intcomp_registerWo_registerZo_registerYo_simple
	;;
	compnhq.gt $r52r53r54r55.t = $r57, 536870911 	#Opcode-lvx_v1-COMPNHQ_intcomp_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	compnwp.leu $r56r57.lo = $r56r57r58r59.x, $r58 	#Opcode-lvx_v1-COMPNWP_intcomp_registerWe_registerZe_registerYe_simple
	;;
	compnwp.gtu $r58r59.lo = $r56r57r58r59.z, 536870911.@ 	#Opcode-lvx_v1-COMPNWP_intcomp_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	compnwp.lt $r56r57.hi = $r56r57r58r59.y, $r59 	#Opcode-lvx_v1-COMPNWP_intcomp_registerWo_registerZo_registerYo_simple
	;;
	compnwp.ge $r58r59.hi = $r56r57r58r59.t, 536870911 	#Opcode-lvx_v1-COMPNWP_intcomp_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	compq.ltu $r32r33r34r35.lo = $r34r35, $r32r33r34r35.hi 	#Opcode-lvx_v1-COMPQ_intcomp_registerM_registerP_registerO_simple
	;;
	compwp.geu $r60 = $r60r61.lo, $r60r61r62r63.x 	#Opcode-lvx_v1-COMPWP_intcomp_registerWe_registerZe_registerYe_simple
	;;
	compwp.eq $r62 = $r62r63.lo, 536870911.@ 	#Opcode-lvx_v1-COMPWP_intcomp_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	compwp.ne $r61 = $r60r61.hi, $r60r61r62r63.y 	#Opcode-lvx_v1-COMPWP_intcomp_registerWo_registerZo_registerYo_simple
	;;
	compwp.any $r63 = $r62r63.hi, 536870911 	#Opcode-lvx_v1-COMPWP_intcomp_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	compw.none $r2r3.lo = $r0r1r2r3.z, $r3 	#Opcode-lvx_v1-COMPW_intcomp_signextw_registerW_registerZ_registerY_simple
	;;
	compw.le.sx $r2r3.hi = $r0r1r2r3.t, 536870911 	#Opcode-lvx_v1-COMPW_intcomp_signextw_registerW_registerZ_upper27_lower5_double
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
	ctzd $r13 = $tp 	#Opcode-lvx_v1-CTZD_registerW_registerZ_simple
	;;
	ctzhq $r60r61r62r63.z = $r0 	#Opcode-lvx_v1-CTZHQ_registerWe_registerZe_simple
	;;
	ctzhq $r60r61r62r63.t = $r1 	#Opcode-lvx_v1-CTZHQ_registerWo_registerZo_simple
	;;
	ctzwp $r0r1.lo = $r0r1r2r3.x 	#Opcode-lvx_v1-CTZWP_registerWe_registerZe_simple
	;;
	ctzwp $r0r1.hi = $r0r1r2r3.y 	#Opcode-lvx_v1-CTZWP_registerWo_registerZo_simple
	;;
	ctzw $r14 = $fp 	#Opcode-lvx_v1-CTZW_registerW_registerZ_simple
	;;
	d1inval 	#Opcode-lvx_v1-D1INVAL_simple
	;;
	dflushl 2305843009213693951[$r14r15.lo] 	#Opcode-lvx_v1-DFLUSHL_extend27_upper27_lower10_registerZ_triple
	;;
	dflushl $r15[$rp] 	#Opcode-lvx_v1-DFLUSHL_registerY_registerZ_simple
	;;
	dflushl -64[$r14r15.hi] 	#Opcode-lvx_v1-DFLUSHL_signed10_registerZ_simple
	;;
	dflushl -8589934592[$r16] 	#Opcode-lvx_v1-DFLUSHL_upper27_lower10_registerZ_double
	;;
	dflushsw.l1 $r16r17.lo, $r16r17r18r19.x 	#Opcode-lvx_v1-DFLUSHSW_cachelev_registerY_registerZ_simple
	;;
	dinvall 2305843009213693951[$r17] 	#Opcode-lvx_v1-DINVALL_extend27_upper27_lower10_registerZ_triple
	;;
	dinvall $r16r17.hi[$r16r17r18r19.y] 	#Opcode-lvx_v1-DINVALL_registerY_registerZ_simple
	;;
	dinvall -64[$r18] 	#Opcode-lvx_v1-DINVALL_signed10_registerZ_simple
	;;
	dinvall -8589934592[$r18r19.lo] 	#Opcode-lvx_v1-DINVALL_upper27_lower10_registerZ_double
	;;
	dinvalsw.l2 $r16r17r18r19.z, $r19 	#Opcode-lvx_v1-DINVALSW_cachelev_registerY_registerZ_simple
	;;
	divmodd $r36r37r38r39.lo = $r18r19.hi, $r16r17r18r19.t 	#Opcode-lvx_v1-DIVMODD_registerM_registerZ_registerY_simple
	;;
	divmodud $r38r39 = $r20, $r20r21.lo 	#Opcode-lvx_v1-DIVMODUD_registerM_registerZ_registerY_simple
	;;
	divmoduw.sx $r36r37r38r39.hi = $r20r21r22r23.x, $r21 	#Opcode-lvx_v1-DIVMODUW_signextw_registerM_registerZ_registerY_simple
	;;
	divmodw $r40r41 = $r20r21.hi, $r20r21r22r23.y 	#Opcode-lvx_v1-DIVMODW_signextw_registerM_registerZ_registerY_simple
	;;
	dpurgel 2305843009213693951[$r22] 	#Opcode-lvx_v1-DPURGEL_extend27_upper27_lower10_registerZ_triple
	;;
	dpurgel $r22r23.lo[$r20r21r22r23.z] 	#Opcode-lvx_v1-DPURGEL_registerY_registerZ_simple
	;;
	dpurgel -64[$r23] 	#Opcode-lvx_v1-DPURGEL_signed10_registerZ_simple
	;;
	dpurgel -8589934592[$r22r23.hi] 	#Opcode-lvx_v1-DPURGEL_upper27_lower10_registerZ_double
	;;
	dpurgesw.l1 $r20r21r22r23.t, $r24 	#Opcode-lvx_v1-DPURGESW_cachelev_registerY_registerZ_simple
	;;
	dtouchl 2305843009213693951[$r24r25.lo] 	#Opcode-lvx_v1-DTOUCHL_extend27_upper27_lower10_registerZ_triple
	;;
	dtouchl $r24r25r26r27.x[$r25] 	#Opcode-lvx_v1-DTOUCHL_registerY_registerZ_simple
	;;
	dtouchl -64[$r24r25.hi] 	#Opcode-lvx_v1-DTOUCHL_signed10_registerZ_simple
	;;
	dtouchl -8589934592[$r24r25r26r27.y] 	#Opcode-lvx_v1-DTOUCHL_upper27_lower10_registerZ_double
	;;
	eord $r26 = $r26r27.lo, 2305843009213693951 	#Opcode-lvx_v1-EORD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	eord $r24r25r26r27.z = $r27, $r26r27.hi 	#Opcode-lvx_v1-EORD_registerW_registerZ_registerY_simple
	;;
	eord $r24r25r26r27.t = $r28, -64 	#Opcode-lvx_v1-EORD_registerW_registerZ_signed10_simple
	;;
	eord $r28r29.lo = $r28r29r30r31.x, -8589934592 	#Opcode-lvx_v1-EORD_registerW_registerZ_upper27_lower10_double
	;;
	eorq $r40r41r42r43.lo = $r42r43, $r40r41r42r43.hi 	#Opcode-lvx_v1-EORQ_registerM_registerP_registerO_simple
	;;
	eorq $r44r45 = $r44r45r46r47.lo, 536870911.@ 	#Opcode-lvx_v1-EORQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	eorw.sx $r29 = $r28r29.hi, $r28r29r30r31.y 	#Opcode-lvx_v1-EORW_signextw_registerW_registerZ_registerY_simple
	;;
	eorw $r30 = $r30r31.lo, 536870911 	#Opcode-lvx_v1-EORW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	errop 	#Opcode-lvx_v1-ERROP_simple
	;;
	extfs $r28r29r30r31.z = $r31, 7, 7 	#Opcode-lvx_v1-EXTFS_registerW_registerZ_stopbit2_stopbit4_startbit_simple
	;;
	extfz $r30r31.hi = $r28r29r30r31.t, 7, 7 	#Opcode-lvx_v1-EXTFZ_registerW_registerZ_stopbit2_stopbit4_startbit_simple
	;;
	extlqbho $r46r47 = $r44r45r46r47.hi 	#Opcode-lvx_v1-EXTLQBHO_oddlanes_registerM_registerP_simple
	;;
	extlqhwq.o $r48r49 = $r48r49r50r51.lo 	#Opcode-lvx_v1-EXTLQHWQ_oddlanes_registerM_registerP_simple
	;;
	extlqnbx $r50r51 = $r48r49r50r51.hi 	#Opcode-lvx_v1-EXTLQNBX_oddlanes_registerM_registerP_simple
	;;
	extlqwdp.o $r52r53 = $r52r53r54r55.lo 	#Opcode-lvx_v1-EXTLQWDP_oddlanes_registerM_registerP_simple
	;;
	extlsbho $r54r55 = $r52r53r54r55.hi 	#Opcode-lvx_v1-EXTLSBHO_oddlanes_registerM_registerP_simple
	;;
	extlshwq.o $r56r57 = $r56r57r58r59.lo 	#Opcode-lvx_v1-EXTLSHWQ_oddlanes_registerM_registerP_simple
	;;
	extlsnbx $r58r59 = $r56r57r58r59.hi 	#Opcode-lvx_v1-EXTLSNBX_oddlanes_registerM_registerP_simple
	;;
	extlswdp.o $r60r61 = $r60r61r62r63.lo 	#Opcode-lvx_v1-EXTLSWDP_oddlanes_registerM_registerP_simple
	;;
	extlzbho $r62r63 = $r60r61r62r63.hi 	#Opcode-lvx_v1-EXTLZBHO_oddlanes_registerM_registerP_simple
	;;
	extlzhwq.o $r0r1 = $r0r1r2r3.lo 	#Opcode-lvx_v1-EXTLZHWQ_oddlanes_registerM_registerP_simple
	;;
	extlznbx $r2r3 = $r0r1r2r3.hi 	#Opcode-lvx_v1-EXTLZNBX_oddlanes_registerM_registerP_simple
	;;
	extlzwdp.o $r4r5 = $r4r5r6r7.lo 	#Opcode-lvx_v1-EXTLZWDP_oddlanes_registerM_registerP_simple
	;;
	fabsd $r32 = $r32r33.lo 	#Opcode-lvx_v1-FABSD_registerW_registerZ_simple
	;;
	fabshq $r2 = $r2r3.lo 	#Opcode-lvx_v1-FABSHQ_registerWe_registerZe_simple
	;;
	fabshq $r3 = $r2r3.hi 	#Opcode-lvx_v1-FABSHQ_registerWo_registerZo_simple
	;;
	fabsh $r32r33r34r35.x = $r33 	#Opcode-lvx_v1-FABSH_registerW_registerZ_simple
	;;
	fabswp $r32r33.hi = $r32r33r34r35.y 	#Opcode-lvx_v1-FABSWP_registerW_registerZ_simple
	;;
	fabsw $r34 = $r34r35.lo 	#Opcode-lvx_v1-FABSW_registerW_registerZ_simple
	;;
	faddd.rn $r32r33r34r35.z = $r35, $r34r35.hi 	#Opcode-lvx_v1-FADDD_floatmode_registerW_registerZ_registerY_simple
	;;
	faddhq.rz $r0r1r2r3.z = $r4, $r4r5.lo 	#Opcode-lvx_v1-FADDHQ_floatmode_registerWe_registerZe_registerYe_simple
	;;
	faddhq.rd $r0r1r2r3.t = $r5, $r4r5.hi 	#Opcode-lvx_v1-FADDHQ_floatmode_registerWo_registerZo_registerYo_simple
	;;
	faddh.ru $r32r33r34r35.t = $r36, $r36r37.lo 	#Opcode-lvx_v1-FADDH_floatmode_registerW_registerZ_registerY_simple
	;;
	faddwc.rm $r36r37r38r39.x = $r37, $r36r37.hi 	#Opcode-lvx_v1-FADDWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple
	;;
	faddwp.r5 $r4r5r6r7.x = $r6, $r6r7.lo 	#Opcode-lvx_v1-FADDWP_floatmode_registerWe_registerZe_registerYe_simple
	;;
	faddwp.ro $r4r5r6r7.y = $r7, $r6r7.hi 	#Opcode-lvx_v1-FADDWP_floatmode_registerWo_registerZo_registerYo_simple
	;;
	faddw $r36r37r38r39.y = $r38, $r38r39.lo 	#Opcode-lvx_v1-FADDW_floatmode_registerW_registerZ_registerY_simple
	;;
	fclassd $r36r37r38r39.z = $r39 	#Opcode-lvx_v1-FCLASSD_registerW_registerZ_simple
	;;
	fclasshq $r4r5r6r7.z = $r8 	#Opcode-lvx_v1-FCLASSHQ_registerWe_registerZe_simple
	;;
	fclasshq $r4r5r6r7.t = $r9 	#Opcode-lvx_v1-FCLASSHQ_registerWo_registerZo_simple
	;;
	fclassh $r38r39.hi = $r36r37r38r39.t 	#Opcode-lvx_v1-FCLASSH_registerW_registerZ_simple
	;;
	fclasswp $r40 = $r40r41.lo 	#Opcode-lvx_v1-FCLASSWP_registerW_registerZ_simple
	;;
	fclassw $r40r41r42r43.x = $r41 	#Opcode-lvx_v1-FCLASSW_registerW_registerZ_simple
	;;
	fcompd.one $r40r41.hi = $r40r41r42r43.y, $r42 	#Opcode-lvx_v1-FCOMPD_floatcomp_registerW_registerZ_registerY_simple
	;;
	fcompd.ueq $r42r43.lo = $r40r41r42r43.z, 536870911 	#Opcode-lvx_v1-FCOMPD_floatcomp_registerW_registerZ_upper27_lower5_double
	;;
	fcomphq.oeq $r8r9.lo = $r8r9r10r11.x, $r10 	#Opcode-lvx_v1-FCOMPHQ_floatcomp_registerWe_registerZe_registerYe_simple
	;;
	fcomphq.une $r10r11.lo = $r8r9r10r11.z, 536870911 	#Opcode-lvx_v1-FCOMPHQ_floatcomp_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	fcomphq.olt $r8r9.hi = $r8r9r10r11.y, $r11 	#Opcode-lvx_v1-FCOMPHQ_floatcomp_registerWo_registerZo_registerYo_simple
	;;
	fcomphq.uge $r10r11.hi = $r8r9r10r11.t, 536870911.@ 	#Opcode-lvx_v1-FCOMPHQ_floatcomp_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	fcomph.oge $r43 = $r42r43.hi, $r40r41r42r43.t 	#Opcode-lvx_v1-FCOMPH_floatcomp_registerW_registerZ_registerY_simple
	;;
	fcomph.ult $r44 = $r44r45.lo, 536870911 	#Opcode-lvx_v1-FCOMPH_floatcomp_registerW_registerZ_upper27_lower5_double
	;;
	fcompnd.one $r12 = $sp, $r14 	#Opcode-lvx_v1-FCOMPND_floatcomp_registerWe_registerZe_registerYe_simple
	;;
	fcompnd.ueq $fp = $r14r15.lo, 536870911 	#Opcode-lvx_v1-FCOMPND_floatcomp_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	fcompnd.oeq $r13 = $tp, $r15 	#Opcode-lvx_v1-FCOMPND_floatcomp_registerWo_registerZo_registerYo_simple
	;;
	fcompnd.une $rp = $r14r15.hi, 536870911.@ 	#Opcode-lvx_v1-FCOMPND_floatcomp_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	fcompnhq.olt $r16 = $r16r17.lo, $r16r17r18r19.x 	#Opcode-lvx_v1-FCOMPNHQ_floatcomp_registerWe_registerZe_registerYe_simple
	;;
	fcompnhq.uge $r18 = $r18r19.lo, 536870911 	#Opcode-lvx_v1-FCOMPNHQ_floatcomp_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	fcompnhq.oge $r17 = $r16r17.hi, $r16r17r18r19.y 	#Opcode-lvx_v1-FCOMPNHQ_floatcomp_registerWo_registerZo_registerYo_simple
	;;
	fcompnhq.ult $r19 = $r18r19.hi, 536870911.@ 	#Opcode-lvx_v1-FCOMPNHQ_floatcomp_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	fcompnwp.one $r16r17r18r19.z = $r20, $r20r21.lo 	#Opcode-lvx_v1-FCOMPNWP_floatcomp_registerWe_registerZe_registerYe_simple
	;;
	fcompnwp.ueq $r20r21r22r23.x = $r22, 536870911 	#Opcode-lvx_v1-FCOMPNWP_floatcomp_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	fcompnwp.oeq $r16r17r18r19.t = $r21, $r20r21.hi 	#Opcode-lvx_v1-FCOMPNWP_floatcomp_registerWo_registerZo_registerYo_simple
	;;
	fcompnwp.une $r20r21r22r23.y = $r23, 536870911.@ 	#Opcode-lvx_v1-FCOMPNWP_floatcomp_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	fcompwp.olt $r22r23.lo = $r20r21r22r23.z, $r24 	#Opcode-lvx_v1-FCOMPWP_floatcomp_registerWe_registerZe_registerYe_simple
	;;
	fcompwp.uge $r24r25.lo = $r24r25r26r27.x, 536870911 	#Opcode-lvx_v1-FCOMPWP_floatcomp_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	fcompwp.oge $r22r23.hi = $r20r21r22r23.t, $r25 	#Opcode-lvx_v1-FCOMPWP_floatcomp_registerWo_registerZo_registerYo_simple
	;;
	fcompwp.ult $r24r25.hi = $r24r25r26r27.y, 536870911.@ 	#Opcode-lvx_v1-FCOMPWP_floatcomp_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	fcompw.one $r44r45r46r47.x = $r45, $r44r45.hi 	#Opcode-lvx_v1-FCOMPW_floatcomp_registerW_registerZ_registerY_simple
	;;
	fcompw.ueq $r44r45r46r47.y = $r46, 536870911 	#Opcode-lvx_v1-FCOMPW_floatcomp_registerW_registerZ_upper27_lower5_double
	;;
	fdivd.rn $r46r47.lo = $r44r45r46r47.z, $r47 	#Opcode-lvx_v1-FDIVD_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fdivh.n.rz $r46r47.hi = $r44r45r46r47.t, $r48 	#Opcode-lvx_v1-FDIVH_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fdivw.rd $r48r49.lo = $r48r49r50r51.x, $r49 	#Opcode-lvx_v1-FDIVW_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fence 	#Opcode-lvx_v1-FENCE_accesses_simple
	;;
	fextlhwq $r6r7 = $r4r5r6r7.hi 	#Opcode-lvx_v1-FEXTLHWQ_oddlanes_registerM_registerP_simple
	;;
	ffmad.n.ru $r48r49.hi = $r48r49r50r51.y, $r50 	#Opcode-lvx_v1-FFMAD_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmahq.rm $r26 = $r26r27.lo, $r24r25r26r27.z 	#Opcode-lvx_v1-FFMAHQ_fnegate_floatmode_registerWe_registerZe_registerYe_simple
	;;
	ffmahq.n.r5 $r27 = $r26r27.hi, $r24r25r26r27.t 	#Opcode-lvx_v1-FFMAHQ_fnegate_floatmode_registerWo_registerZo_registerYo_simple
	;;
	ffmah.ro $r50r51.lo = $r48r49r50r51.z, $r51 	#Opcode-lvx_v1-FFMAH_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmawc.c.mi $r50r51.hi = $r48r49r50r51.t, $r52 	#Opcode-lvx_v1-FFMAWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmawp.n.rn $r28 = $r28r29.lo, $r28r29r30r31.x 	#Opcode-lvx_v1-FFMAWP_fnegate_floatmode_registerWe_registerZe_registerYe_simple
	;;
	ffmawp.rz $r29 = $r28r29.hi, $r28r29r30r31.y 	#Opcode-lvx_v1-FFMAWP_fnegate_floatmode_registerWo_registerZo_registerYo_simple
	;;
	ffmaw.n.rd $r52r53.lo = $r52r53r54r55.x, $r53 	#Opcode-lvx_v1-FFMAW_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmsd.ru $r52r53.hi = $r52r53r54r55.y, $r54 	#Opcode-lvx_v1-FFMSD_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmshq.n.rm $r30 = $r30r31.lo, $r28r29r30r31.z 	#Opcode-lvx_v1-FFMSHQ_fnegate_floatmode_registerWe_registerZe_registerYe_simple
	;;
	ffmshq.r5 $r31 = $r30r31.hi, $r28r29r30r31.t 	#Opcode-lvx_v1-FFMSHQ_fnegate_floatmode_registerWo_registerZo_registerYo_simple
	;;
	ffmsh.n.ro $r54r55.lo = $r52r53r54r55.z, $r55 	#Opcode-lvx_v1-FFMSH_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	ffmswp $r32 = $r32r33.lo, $r32r33r34r35.x 	#Opcode-lvx_v1-FFMSWP_fnegate_floatmode_registerWe_registerZe_registerYe_simple
	;;
	ffmswp.n.rn $r33 = $r32r33.hi, $r32r33r34r35.y 	#Opcode-lvx_v1-FFMSWP_fnegate_floatmode_registerWo_registerZo_registerYo_simple
	;;
	ffmsw.rz $r54r55.hi = $r52r53r54r55.t, $r56 	#Opcode-lvx_v1-FFMSW_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fixeddw.rd $r56r57.lo = $r56r57r58r59.x 	#Opcode-lvx_v1-FIXEDDW_floatmode_registerW_registerZ_simple
	;;
	fixedd.ru $r57 = $r56r57.hi 	#Opcode-lvx_v1-FIXEDD_floatmode_registerW_registerZ_simple
	;;
	fixedhq.rm $r34 = $r34r35.lo 	#Opcode-lvx_v1-FIXEDHQ_floatmode_registerWe_registerZe_simple
	;;
	fixedhq.r5 $r35 = $r34r35.hi 	#Opcode-lvx_v1-FIXEDHQ_floatmode_registerWo_registerZo_simple
	;;
	fixedudw.ro $r56r57r58r59.y = $r58 	#Opcode-lvx_v1-FIXEDUDW_floatmode_registerW_registerZ_simple
	;;
	fixedud $r58r59.lo = $r56r57r58r59.z 	#Opcode-lvx_v1-FIXEDUD_floatmode_registerW_registerZ_simple
	;;
	fixeduhq.rn $r32r33r34r35.z = $r36 	#Opcode-lvx_v1-FIXEDUHQ_floatmode_registerWe_registerZe_simple
	;;
	fixeduhq.rz $r32r33r34r35.t = $r37 	#Opcode-lvx_v1-FIXEDUHQ_floatmode_registerWo_registerZo_simple
	;;
	fixeduwd.rd $r59 = $r58r59.hi 	#Opcode-lvx_v1-FIXEDUWD_floatmode_registerW_registerZ_simple
	;;
	fixeduwp.ru $r56r57r58r59.t = $r60 	#Opcode-lvx_v1-FIXEDUWP_floatmode_registerW_registerZ_simple
	;;
	fixeduw.rm $r60r61.lo = $r60r61r62r63.x 	#Opcode-lvx_v1-FIXEDUW_floatmode_registerW_registerZ_simple
	;;
	fixedwd.r5 $r61 = $r60r61.hi 	#Opcode-lvx_v1-FIXEDWD_floatmode_registerW_registerZ_simple
	;;
	fixedwp.ro $r60r61r62r63.y = $r62 	#Opcode-lvx_v1-FIXEDWP_floatmode_registerW_registerZ_simple
	;;
	fixedw $r62r63.lo = $r60r61r62r63.z 	#Opcode-lvx_v1-FIXEDW_floatmode_registerW_registerZ_simple
	;;
	floatdw.rn $r63 = $r62r63.hi 	#Opcode-lvx_v1-FLOATDW_floatmode_registerW_registerZ_simple
	;;
	floatd.rz $r60r61r62r63.t = $r0 	#Opcode-lvx_v1-FLOATD_floatmode_registerW_registerZ_simple
	;;
	floathq.rd $r36r37.lo = $r36r37r38r39.x 	#Opcode-lvx_v1-FLOATHQ_floatmode_registerWe_registerZe_simple
	;;
	floathq.ru $r36r37.hi = $r36r37r38r39.y 	#Opcode-lvx_v1-FLOATHQ_floatmode_registerWo_registerZo_simple
	;;
	floatudw.rm $r0r1.lo = $r0r1r2r3.x 	#Opcode-lvx_v1-FLOATUDW_floatmode_registerW_registerZ_simple
	;;
	floatud.r5 $r1 = $r0r1.hi 	#Opcode-lvx_v1-FLOATUD_floatmode_registerW_registerZ_simple
	;;
	floatuhq.ro $r38 = $r38r39.lo 	#Opcode-lvx_v1-FLOATUHQ_floatmode_registerWe_registerZe_simple
	;;
	floatuhq $r39 = $r38r39.hi 	#Opcode-lvx_v1-FLOATUHQ_floatmode_registerWo_registerZo_simple
	;;
	floatuwd.rn $r0r1r2r3.y = $r2 	#Opcode-lvx_v1-FLOATUWD_floatmode_registerW_registerZ_simple
	;;
	floatuwp.rz $r2r3.lo = $r0r1r2r3.z 	#Opcode-lvx_v1-FLOATUWP_floatmode_registerW_registerZ_simple
	;;
	floatuw.rd $r3 = $r2r3.hi 	#Opcode-lvx_v1-FLOATUW_floatmode_registerW_registerZ_simple
	;;
	floatwd.ru $r0r1r2r3.t = $r4 	#Opcode-lvx_v1-FLOATWD_floatmode_registerW_registerZ_simple
	;;
	floatwp.rm $r4r5.lo = $r4r5r6r7.x 	#Opcode-lvx_v1-FLOATWP_floatmode_registerW_registerZ_simple
	;;
	floatw.r5 $r5 = $r4r5.hi 	#Opcode-lvx_v1-FLOATW_floatmode_registerW_registerZ_simple
	;;
	fmaxd $r4r5r6r7.y = $r6, $r6r7.lo 	#Opcode-lvx_v1-FMAXD_registerW_registerZ_registerY_simple
	;;
	fmaxhq $r36r37r38r39.z = $r40, $r40r41.lo 	#Opcode-lvx_v1-FMAXHQ_registerWe_registerZe_registerYe_simple
	;;
	fmaxhq $r36r37r38r39.t = $r41, $r40r41.hi 	#Opcode-lvx_v1-FMAXHQ_registerWo_registerZo_registerYo_simple
	;;
	fmaxh $r4r5r6r7.z = $r7, $r6r7.hi 	#Opcode-lvx_v1-FMAXH_registerW_registerZ_registerY_simple
	;;
	fmaxnd $r4r5r6r7.t = $r8, $r8r9.lo 	#Opcode-lvx_v1-FMAXND_registerW_registerZ_registerY_simple
	;;
	fmaxnhq $r40r41r42r43.x = $r42, $r42r43.lo 	#Opcode-lvx_v1-FMAXNHQ_registerWe_registerZe_registerYe_simple
	;;
	fmaxnhq $r40r41r42r43.y = $r43, $r42r43.hi 	#Opcode-lvx_v1-FMAXNHQ_registerWo_registerZo_registerYo_simple
	;;
	fmaxnh $r8r9r10r11.x = $r9, $r8r9.hi 	#Opcode-lvx_v1-FMAXNH_registerW_registerZ_registerY_simple
	;;
	fmaxnwp $r40r41r42r43.z = $r44, $r44r45.lo 	#Opcode-lvx_v1-FMAXNWP_registerWe_registerZe_registerYe_simple
	;;
	fmaxnwp $r40r41r42r43.t = $r45, $r44r45.hi 	#Opcode-lvx_v1-FMAXNWP_registerWo_registerZo_registerYo_simple
	;;
	fmaxnw $r8r9r10r11.y = $r10, $r10r11.lo 	#Opcode-lvx_v1-FMAXNW_registerW_registerZ_registerY_simple
	;;
	fmaxwp $r44r45r46r47.x = $r46, $r46r47.lo 	#Opcode-lvx_v1-FMAXWP_registerWe_registerZe_registerYe_simple
	;;
	fmaxwp $r44r45r46r47.y = $r47, $r46r47.hi 	#Opcode-lvx_v1-FMAXWP_registerWo_registerZo_registerYo_simple
	;;
	fmaxw $r8r9r10r11.z = $r11, $r10r11.hi 	#Opcode-lvx_v1-FMAXW_registerW_registerZ_registerY_simple
	;;
	fmind $r8r9r10r11.t = $r12, $sp 	#Opcode-lvx_v1-FMIND_registerW_registerZ_registerY_simple
	;;
	fminhq $r44r45r46r47.z = $r48, $r48r49.lo 	#Opcode-lvx_v1-FMINHQ_registerWe_registerZe_registerYe_simple
	;;
	fminhq $r44r45r46r47.t = $r49, $r48r49.hi 	#Opcode-lvx_v1-FMINHQ_registerWo_registerZo_registerYo_simple
	;;
	fminh $r13 = $tp, $r14 	#Opcode-lvx_v1-FMINH_registerW_registerZ_registerY_simple
	;;
	fminnd $fp = $r14r15.lo, $r15 	#Opcode-lvx_v1-FMINND_registerW_registerZ_registerY_simple
	;;
	fminnhq $r48r49r50r51.x = $r50, $r50r51.lo 	#Opcode-lvx_v1-FMINNHQ_registerWe_registerZe_registerYe_simple
	;;
	fminnhq $r48r49r50r51.y = $r51, $r50r51.hi 	#Opcode-lvx_v1-FMINNHQ_registerWo_registerZo_registerYo_simple
	;;
	fminnh $rp = $r14r15.hi, $r16 	#Opcode-lvx_v1-FMINNH_registerW_registerZ_registerY_simple
	;;
	fminnwp $r48r49r50r51.z = $r52, $r52r53.lo 	#Opcode-lvx_v1-FMINNWP_registerWe_registerZe_registerYe_simple
	;;
	fminnwp $r48r49r50r51.t = $r53, $r52r53.hi 	#Opcode-lvx_v1-FMINNWP_registerWo_registerZo_registerYo_simple
	;;
	fminnw $r16r17.lo = $r16r17r18r19.x, $r17 	#Opcode-lvx_v1-FMINNW_registerW_registerZ_registerY_simple
	;;
	fminwp $r52r53r54r55.x = $r54, $r54r55.lo 	#Opcode-lvx_v1-FMINWP_registerWe_registerZe_registerYe_simple
	;;
	fminwp $r52r53r54r55.y = $r55, $r54r55.hi 	#Opcode-lvx_v1-FMINWP_registerWo_registerZo_registerYo_simple
	;;
	fminw $r16r17.hi = $r16r17r18r19.y, $r18 	#Opcode-lvx_v1-FMINW_registerW_registerZ_registerY_simple
	;;
	fmuld.n.ro $r18r19.lo = $r16r17r18r19.z, $r19 	#Opcode-lvx_v1-FMULD_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fmulhq $r52r53r54r55.z = $r56, $r56r57.lo 	#Opcode-lvx_v1-FMULHQ_fnegate_floatmode_registerWe_registerZe_registerYe_simple
	;;
	fmulhq.n.rn $r52r53r54r55.t = $r57, $r56r57.hi 	#Opcode-lvx_v1-FMULHQ_fnegate_floatmode_registerWo_registerZo_registerYo_simple
	;;
	fmulh.rz $r18r19.hi = $r16r17r18r19.t, $r20 	#Opcode-lvx_v1-FMULH_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fmulwc.rd $r20r21.lo = $r20r21r22r23.x, $r21 	#Opcode-lvx_v1-FMULWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple
	;;
	fmulwp.n.ru $r56r57r58r59.x = $r58, $r58r59.lo 	#Opcode-lvx_v1-FMULWP_fnegate_floatmode_registerWe_registerZe_registerYe_simple
	;;
	fmulwp.rm $r56r57r58r59.y = $r59, $r58r59.hi 	#Opcode-lvx_v1-FMULWP_fnegate_floatmode_registerWo_registerZo_registerYo_simple
	;;
	fmulw.n.r5 $r20r21.hi = $r20r21r22r23.y, $r22 	#Opcode-lvx_v1-FMULW_fnegate_floatmode_registerW_registerZ_registerY_simple
	;;
	fnarrowdwp.ro $r22r23.lo = $r8r9 	#Opcode-lvx_v1-FNARROWDWP_floatmode_registerW_registerP_simple
	;;
	fnarrowdw $r20r21r22r23.z = $r23 	#Opcode-lvx_v1-FNARROWDW_floatmode_registerW_registerZ_simple
	;;
	fnarrowwhq.rn $r22r23.hi = $r8r9r10r11.lo 	#Opcode-lvx_v1-FNARROWWHQ_ziplanes_floatmode_registerW_registerP_simple
	;;
	fnarrowwh.rz $r20r21r22r23.t = $r24 	#Opcode-lvx_v1-FNARROWWH_floatmode_registerW_registerZ_simple
	;;
	fnegd $r24r25.lo = $r24r25r26r27.x 	#Opcode-lvx_v1-FNEGD_registerW_registerZ_simple
	;;
	fneghq $r56r57r58r59.z = $r60 	#Opcode-lvx_v1-FNEGHQ_registerWe_registerZe_simple
	;;
	fneghq $r56r57r58r59.t = $r61 	#Opcode-lvx_v1-FNEGHQ_registerWo_registerZo_simple
	;;
	fnegh $r25 = $r24r25.hi 	#Opcode-lvx_v1-FNEGH_registerW_registerZ_simple
	;;
	fnegwp $r24r25r26r27.y = $r26 	#Opcode-lvx_v1-FNEGWP_registerW_registerZ_simple
	;;
	fnegw $r26r27.lo = $r24r25r26r27.z 	#Opcode-lvx_v1-FNEGW_registerW_registerZ_simple
	;;
	fractdwp $r27 = $r10r11 	#Opcode-lvx_v1-FRACTDWP_registerW_registerP_simple
	;;
	fracthbo.z $r26r27.hi = $r8r9r10r11.hi 	#Opcode-lvx_v1-FRACTHBO_ziplanes_registerW_registerP_simple
	;;
	fractwhq $r24r25r26r27.t = $r12r13 	#Opcode-lvx_v1-FRACTWHQ_ziplanes_registerW_registerP_simple
	;;
	frintd.rd $r28 = $r28r29.lo 	#Opcode-lvx_v1-FRINTD_floatmode_registerW_registerZ_simple
	;;
	frinth.ru $r28r29r30r31.x = $r29 	#Opcode-lvx_v1-FRINTH_floatmode_registerW_registerZ_simple
	;;
	frintw.rm $r28r29.hi = $r28r29r30r31.y 	#Opcode-lvx_v1-FRINTW_floatmode_registerW_registerZ_simple
	;;
	fsbfd.r5 $r30 = $r30r31.lo, $r28r29r30r31.z 	#Opcode-lvx_v1-FSBFD_floatmode_registerW_registerZ_registerY_simple
	;;
	fsbfhq.ro $r60r61.lo = $r60r61r62r63.x, $r62 	#Opcode-lvx_v1-FSBFHQ_floatmode_registerWe_registerZe_registerYe_simple
	;;
	fsbfhq $r60r61.hi = $r60r61r62r63.y, $r63 	#Opcode-lvx_v1-FSBFHQ_floatmode_registerWo_registerZo_registerYo_simple
	;;
	fsbfh.rn $r31 = $r30r31.hi, $r28r29r30r31.t 	#Opcode-lvx_v1-FSBFH_floatmode_registerW_registerZ_registerY_simple
	;;
	fsbfwc.c.mi.rz $r32 = $r32r33.lo, $r32r33r34r35.x 	#Opcode-lvx_v1-FSBFWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple
	;;
	fsbfwp.rd $r62r63.lo = $r60r61r62r63.z, $r0 	#Opcode-lvx_v1-FSBFWP_floatmode_registerWe_registerZe_registerYe_simple
	;;
	fsbfwp.ru $r62r63.hi = $r60r61r62r63.t, $r1 	#Opcode-lvx_v1-FSBFWP_floatmode_registerWo_registerZo_registerYo_simple
	;;
	fsbfw.rm $r33 = $r32r33.hi, $r32r33r34r35.y 	#Opcode-lvx_v1-FSBFW_floatmode_registerW_registerZ_registerY_simple
	;;
	fsignd $r34 = $r34r35.lo, $r32r33r34r35.z 	#Opcode-lvx_v1-FSIGND_registerW_registerZ_registerY_simple
	;;
	fsignhq $r0r1.lo = $r0r1r2r3.x, $r2 	#Opcode-lvx_v1-FSIGNHQ_registerWe_registerZe_registerYe_simple
	;;
	fsignhq $r0r1.hi = $r0r1r2r3.y, $r3 	#Opcode-lvx_v1-FSIGNHQ_registerWo_registerZo_registerYo_simple
	;;
	fsignh $r35 = $r34r35.hi, $r32r33r34r35.t 	#Opcode-lvx_v1-FSIGNH_registerW_registerZ_registerY_simple
	;;
	fsignmd $r36 = $r36r37.lo, $r36r37r38r39.x 	#Opcode-lvx_v1-FSIGNMD_registerW_registerZ_registerY_simple
	;;
	fsignmhq $r2r3.lo = $r0r1r2r3.z, $r4 	#Opcode-lvx_v1-FSIGNMHQ_registerWe_registerZe_registerYe_simple
	;;
	fsignmhq $r2r3.hi = $r0r1r2r3.t, $r5 	#Opcode-lvx_v1-FSIGNMHQ_registerWo_registerZo_registerYo_simple
	;;
	fsignmh $r37 = $r36r37.hi, $r36r37r38r39.y 	#Opcode-lvx_v1-FSIGNMH_registerW_registerZ_registerY_simple
	;;
	fsignmwp $r4r5.lo = $r4r5r6r7.x, $r6 	#Opcode-lvx_v1-FSIGNMWP_registerWe_registerZe_registerYe_simple
	;;
	fsignmwp $r4r5.hi = $r4r5r6r7.y, $r7 	#Opcode-lvx_v1-FSIGNMWP_registerWo_registerZo_registerYo_simple
	;;
	fsignmw $r38 = $r38r39.lo, $r36r37r38r39.z 	#Opcode-lvx_v1-FSIGNMW_registerW_registerZ_registerY_simple
	;;
	fsignnd $r39 = $r38r39.hi, $r36r37r38r39.t 	#Opcode-lvx_v1-FSIGNND_registerW_registerZ_registerY_simple
	;;
	fsignnhq $r6r7.lo = $r4r5r6r7.z, $r8 	#Opcode-lvx_v1-FSIGNNHQ_registerWe_registerZe_registerYe_simple
	;;
	fsignnhq $r6r7.hi = $r4r5r6r7.t, $r9 	#Opcode-lvx_v1-FSIGNNHQ_registerWo_registerZo_registerYo_simple
	;;
	fsignnh $r40 = $r40r41.lo, $r40r41r42r43.x 	#Opcode-lvx_v1-FSIGNNH_registerW_registerZ_registerY_simple
	;;
	fsignnwp $r8r9.lo = $r8r9r10r11.x, $r10 	#Opcode-lvx_v1-FSIGNNWP_registerWe_registerZe_registerYe_simple
	;;
	fsignnwp $r8r9.hi = $r8r9r10r11.y, $r11 	#Opcode-lvx_v1-FSIGNNWP_registerWo_registerZo_registerYo_simple
	;;
	fsignnw $r41 = $r40r41.hi, $r40r41r42r43.y 	#Opcode-lvx_v1-FSIGNNW_registerW_registerZ_registerY_simple
	;;
	fsignwp $r10r11.lo = $r8r9r10r11.z, $r12 	#Opcode-lvx_v1-FSIGNWP_registerWe_registerZe_registerYe_simple
	;;
	fsignwp $r10r11.hi = $r8r9r10r11.t, $r13 	#Opcode-lvx_v1-FSIGNWP_registerWo_registerZo_registerYo_simple
	;;
	fsignw $r42 = $r42r43.lo, $r40r41r42r43.z 	#Opcode-lvx_v1-FSIGNW_registerW_registerZ_registerY_simple
	;;
	fsqrtd.r5 $r43 = $r42r43.hi 	#Opcode-lvx_v1-FSQRTD_floatmode_registerW_registerZ_simple
	;;
	fsqrth.ro $r40r41r42r43.t = $r44 	#Opcode-lvx_v1-FSQRTH_floatmode_registerW_registerZ_simple
	;;
	fsqrtw $r44r45.lo = $r44r45r46r47.x 	#Opcode-lvx_v1-FSQRTW_floatmode_registerW_registerZ_simple
	;;
	fsrecd $r45 = $r44r45.hi 	#Opcode-lvx_v1-FSRECD_registerW_registerZ_simple
	;;
	fsrecwp $r44r45r46r47.y = $r46 	#Opcode-lvx_v1-FSRECWP_registerW_registerZ_simple
	;;
	fsrecw $r46r47.lo = $r44r45r46r47.z 	#Opcode-lvx_v1-FSRECW_registerW_registerZ_simple
	;;
	fsrsrd $r47 = $r46r47.hi 	#Opcode-lvx_v1-FSRSRD_registerW_registerZ_simple
	;;
	fsrsrwp $r44r45r46r47.t = $r48 	#Opcode-lvx_v1-FSRSRWP_registerW_registerZ_simple
	;;
	fsrsrw $r48r49.lo = $r48r49r50r51.x 	#Opcode-lvx_v1-FSRSRW_registerW_registerZ_simple
	;;
	fwidenhwq $r12r13r14r15.lo = $r14r15 	#Opcode-lvx_v1-FWIDENHWQ_mostsig_registerM_registerP_simple
	;;
	fwidenhw.m $r49 = $r48r49.hi 	#Opcode-lvx_v1-FWIDENHW_mostsig_registerW_registerZ_simple
	;;
	fwidenwd $r48r49r50r51.y = $r50 	#Opcode-lvx_v1-FWIDENWD_mostsig_registerW_registerZ_simple
	;;
	get $r50r51.lo = $pc 	#Opcode-lvx_v1-GET_registerZ_systemS2_simple
	;;
	get $r48r49r50r51.z = $pc 	#Opcode-lvx_v1-GET_registerZ_systemS3_simple
	;;
	gotox -4503599627370496 	#Opcode-lvx_v1-GOTOX_upper27_lower27_double
	;;
	goto -33554432 	#Opcode-lvx_v1-GOTO_pcrel27s2_simple
	;;
	guard.dnez $r51? 7 	#Opcode-lvx_v1-GUARD_execpred_registerZ_activate_simple
	;;
	i1invals 2305843009213693951[$r50r51.hi] 	#Opcode-lvx_v1-I1INVALS_extend27_upper27_lower10_registerZ_triple
	;;
	i1invals $r48r49r50r51.t[$r52] 	#Opcode-lvx_v1-I1INVALS_registerY_registerZ_simple
	;;
	i1invals -64[$r52r53.lo] 	#Opcode-lvx_v1-I1INVALS_signed10_registerZ_simple
	;;
	i1invals -8589934592[$r52r53r54r55.x] 	#Opcode-lvx_v1-I1INVALS_upper27_lower10_registerZ_double
	;;
	i1inval 	#Opcode-lvx_v1-I1INVAL_simple
	;;
	icall $r53 	#Opcode-lvx_v1-ICALL_registerZ_simple
	;;
	iget $r52r53.hi 	#Opcode-lvx_v1-IGET_registerZ_simple
	;;
	igoto $r52r53r54r55.y 	#Opcode-lvx_v1-IGOTO_registerZ_simple
	;;
	insf $r54 = $r54r55.lo, 7, 7 	#Opcode-lvx_v1-INSF_registerW_registerZ_stopbit2_stopbit4_startbit_simple
	;;
	iord $r52r53r54r55.z = $r55, 2305843009213693951 	#Opcode-lvx_v1-IORD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	iord $r54r55.hi = $r52r53r54r55.t, $r56 	#Opcode-lvx_v1-IORD_registerW_registerZ_registerY_simple
	;;
	iord $r56r57.lo = $r56r57r58r59.x, -64 	#Opcode-lvx_v1-IORD_registerW_registerZ_signed10_simple
	;;
	iord $r57 = $r56r57.hi, -8589934592 	#Opcode-lvx_v1-IORD_registerW_registerZ_upper27_lower10_double
	;;
	iornd $r56r57r58r59.y = $r58, 2305843009213693951 	#Opcode-lvx_v1-IORND_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	iornd $r58r59.lo = $r56r57r58r59.z, $r59 	#Opcode-lvx_v1-IORND_registerW_registerZ_registerY_simple
	;;
	iornd $r58r59.hi = $r56r57r58r59.t, -64 	#Opcode-lvx_v1-IORND_registerW_registerZ_signed10_simple
	;;
	iornd $r60 = $r60r61.lo, -8589934592 	#Opcode-lvx_v1-IORND_registerW_registerZ_upper27_lower10_double
	;;
	iornq $r12r13r14r15.hi = $r16r17, $r16r17r18r19.lo 	#Opcode-lvx_v1-IORNQ_registerM_registerP_registerO_simple
	;;
	iornq $r18r19 = $r16r17r18r19.hi, 536870911 	#Opcode-lvx_v1-IORNQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	iornw.sx $r60r61r62r63.x = $r61, $r60r61.hi 	#Opcode-lvx_v1-IORNW_signextw_registerW_registerZ_registerY_simple
	;;
	iornw $r60r61r62r63.y = $r62, 536870911 	#Opcode-lvx_v1-IORNW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	iorq $r20r21 = $r20r21r22r23.lo, $r22r23 	#Opcode-lvx_v1-IORQ_registerM_registerP_registerO_simple
	;;
	iorq $r20r21r22r23.hi = $r24r25, 536870911.@ 	#Opcode-lvx_v1-IORQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	iorw.sx $r62r63.lo = $r60r61r62r63.z, $r63 	#Opcode-lvx_v1-IORW_signextw_registerW_registerZ_registerY_simple
	;;
	iorw $r62r63.hi = $r60r61r62r63.t, 536870911 	#Opcode-lvx_v1-IORW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	landd $r0 = $r0r1.lo, $r0r1r2r3.x 	#Opcode-lvx_v1-LANDD_registerW_registerZ_registerY_simple
	;;
	landw $r1 = $r0r1.hi, $r0r1r2r3.y 	#Opcode-lvx_v1-LANDW_registerW_registerZ_registerY_simple
	;;
	lbs $r2 = 2305843009213693951[$r2r3.lo] 	#Opcode-lvx_v1-LBS_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lbs.s $r0r1r2r3.z = $r3[$r2r3.hi] 	#Opcode-lvx_v1-LBS_variant_registerW_registerY_registerZ_simple
	;;
	lbs.u $r0r1r2r3.t = -64[$r4] 	#Opcode-lvx_v1-LBS_variant_registerW_signed10_registerZ_simple
	;;
	lbs.us $r4r5.lo = -8589934592[$r4r5r6r7.x] 	#Opcode-lvx_v1-LBS_variant_registerW_upper27_lower10_registerZ_double
	;;
	lbz $r5 = 2305843009213693951[$r4r5.hi] 	#Opcode-lvx_v1-LBZ_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lbz.s $r4r5r6r7.y = $r6[$r6r7.lo] 	#Opcode-lvx_v1-LBZ_variant_registerW_registerY_registerZ_simple
	;;
	lbz.u $r4r5r6r7.z = -64[$r7] 	#Opcode-lvx_v1-LBZ_variant_registerW_signed10_registerZ_simple
	;;
	lbz.us $r6r7.hi = -8589934592[$r4r5r6r7.t] 	#Opcode-lvx_v1-LBZ_variant_registerW_upper27_lower10_registerZ_double
	;;
	ld $r8 = 2305843009213693951[$r8r9.lo] 	#Opcode-lvx_v1-LD_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	ld.s $r8r9r10r11.x = $r9[$r8r9.hi] 	#Opcode-lvx_v1-LD_variant_registerW_registerY_registerZ_simple
	;;
	ld.u $r8r9r10r11.y = -64[$r10] 	#Opcode-lvx_v1-LD_variant_registerW_signed10_registerZ_simple
	;;
	ld.us $r10r11.lo = -8589934592[$r8r9r10r11.z] 	#Opcode-lvx_v1-LD_variant_registerW_upper27_lower10_registerZ_double
	;;
	lhs $r11 = 2305843009213693951[$r10r11.hi] 	#Opcode-lvx_v1-LHS_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lhs.s $r8r9r10r11.t = $r12[$sp] 	#Opcode-lvx_v1-LHS_variant_registerW_registerY_registerZ_simple
	;;
	lhs.u $r13 = -64[$tp] 	#Opcode-lvx_v1-LHS_variant_registerW_signed10_registerZ_simple
	;;
	lhs.us $r14 = -8589934592[$fp] 	#Opcode-lvx_v1-LHS_variant_registerW_upper27_lower10_registerZ_double
	;;
	lhz $r14r15.lo = 2305843009213693951[$r15] 	#Opcode-lvx_v1-LHZ_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lhz.s $rp = $r14r15.hi[$r16] 	#Opcode-lvx_v1-LHZ_variant_registerW_registerY_registerZ_simple
	;;
	lhz.u $r16r17.lo = -64[$r16r17r18r19.x] 	#Opcode-lvx_v1-LHZ_variant_registerW_signed10_registerZ_simple
	;;
	lhz.us $r17 = -8589934592[$r16r17.hi] 	#Opcode-lvx_v1-LHZ_variant_registerW_upper27_lower10_registerZ_double
	;;
	liord $r16r17r18r19.y = $r18, $r18r19.lo 	#Opcode-lvx_v1-LIORD_registerW_registerZ_registerY_simple
	;;
	liorw $r16r17r18r19.z = $r19, $r18r19.hi 	#Opcode-lvx_v1-LIORW_registerW_registerZ_registerY_simple
	;;
	lnandd $r16r17r18r19.t = $r20, $r20r21.lo 	#Opcode-lvx_v1-LNANDD_registerW_registerZ_registerY_simple
	;;
	lnandw $r20r21r22r23.x = $r21, $r20r21.hi 	#Opcode-lvx_v1-LNANDW_registerW_registerZ_registerY_simple
	;;
	lniord $r20r21r22r23.y = $r22, $r22r23.lo 	#Opcode-lvx_v1-LNIORD_registerW_registerZ_registerY_simple
	;;
	lniorw $r20r21r22r23.z = $r23, $r22r23.hi 	#Opcode-lvx_v1-LNIORW_registerW_registerZ_registerY_simple
	;;
	loopdo $r20r21r22r23.t, -32768 	#Opcode-lvx_v1-LOOPDO_registerZ_pcrel17s2_simple
	;;
	lo $r20r21r22r23 = 2305843009213693951[$r24] 	#Opcode-lvx_v1-LO_variant_registerN_extend27_upper27_lower10_registerZ_triple
	;;
	lo.s $r24r25r26r27 = $r24r25.lo[$r24r25r26r27.x] 	#Opcode-lvx_v1-LO_variant_registerN_registerY_registerZ_simple
	;;
	lo.u $r28r29r30r31 = -64[$r25] 	#Opcode-lvx_v1-LO_variant_registerN_signed10_registerZ_simple
	;;
	lo.us $r32r33r34r35 = -8589934592[$r24r25.hi] 	#Opcode-lvx_v1-LO_variant_registerN_upper27_lower10_registerZ_double
	;;
	lq $r24r25r26r27.lo = 2305843009213693951[$r24r25r26r27.y] 	#Opcode-lvx_v1-LQ_variant_registerM_extend27_upper27_lower10_registerZ_triple
	;;
	lq.s $r26r27 = $r26[$r26r27.lo] 	#Opcode-lvx_v1-LQ_variant_registerM_registerY_registerZ_simple
	;;
	lq.u $r24r25r26r27.hi = -64[$r24r25r26r27.z] 	#Opcode-lvx_v1-LQ_variant_registerM_signed10_registerZ_simple
	;;
	lq.us $r28r29 = -8589934592[$r27] 	#Opcode-lvx_v1-LQ_variant_registerM_upper27_lower10_registerZ_double
	;;
	lws $r26r27.hi = 2305843009213693951[$r24r25r26r27.t] 	#Opcode-lvx_v1-LWS_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lws.s $r28 = $r28r29.lo[$r28r29r30r31.x] 	#Opcode-lvx_v1-LWS_variant_registerW_registerY_registerZ_simple
	;;
	lws.u $r29 = -64[$r28r29.hi] 	#Opcode-lvx_v1-LWS_variant_registerW_signed10_registerZ_simple
	;;
	lws.us $r28r29r30r31.y = -8589934592[$r30] 	#Opcode-lvx_v1-LWS_variant_registerW_upper27_lower10_registerZ_double
	;;
	lwz $r30r31.lo = 2305843009213693951[$r28r29r30r31.z] 	#Opcode-lvx_v1-LWZ_variant_registerW_extend27_upper27_lower10_registerZ_triple
	;;
	lwz.s $r31 = $r30r31.hi[$r28r29r30r31.t] 	#Opcode-lvx_v1-LWZ_variant_registerW_registerY_registerZ_simple
	;;
	lwz.u $r32 = -64[$r32r33.lo] 	#Opcode-lvx_v1-LWZ_variant_registerW_signed10_registerZ_simple
	;;
	lwz.us $r32r33r34r35.x = -8589934592[$r33] 	#Opcode-lvx_v1-LWZ_variant_registerW_upper27_lower10_registerZ_double
	;;
	maddbho $r28r29r30r31.lo = $sp, $r14 	#Opcode-lvx_v1-MADDBHO_widemult_registerM_registerZe_registerYe_simple
	;;
	maddbho.u $r30r31 = $tp, $r15 	#Opcode-lvx_v1-MADDBHO_widemult_registerM_registerZo_registerYo_simple
	;;
	madddq.su $r28r29r30r31.hi = $r32r33.hi, $r32r33r34r35.y 	#Opcode-lvx_v1-MADDDQ_widemult_registerM_registerZ_registerY_simple
	;;
	madddt $r32r33 = $r34, $r34r35.lo 	#Opcode-lvx_v1-MADDDT_registerM_registerZ_registerY_simple
	;;
	maddd $r32r33r34r35.z = $r35, $r34r35.hi 	#Opcode-lvx_v1-MADDD_highmult_registerW_registerZ_registerY_simple
	;;
	maddd.h $r32r33r34r35.t = $r36, 536870911 	#Opcode-lvx_v1-MADDD_highmult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	maddhq.hu $fp = $r14r15.lo, $r16 	#Opcode-lvx_v1-MADDHQ_highmult_registerWe_registerZe_registerYe_simple
	;;
	maddhq.hsu $rp = $r14r15.hi, $r17 	#Opcode-lvx_v1-MADDHQ_highmult_registerWo_registerZo_registerYo_simple
	;;
	maddhwq $r32r33r34r35.lo = $r16r17.lo, $r16r17r18r19.x 	#Opcode-lvx_v1-MADDHWQ_widemult_registerM_registerZe_registerYe_simple
	;;
	maddhwq.u $r34r35 = $r16r17.hi, $r16r17r18r19.y 	#Opcode-lvx_v1-MADDHWQ_widemult_registerM_registerZo_registerYo_simple
	;;
	maddsudt $r32r33r34r35.hi = $r36r37.lo, $r36r37r38r39.x 	#Opcode-lvx_v1-MADDSUDT_registerM_registerZ_registerY_simple
	;;
	maddsuwd $r37 = $r36r37.hi, $r36r37r38r39.y 	#Opcode-lvx_v1-MADDSUWD_registerW_registerZ_registerY_simple
	;;
	maddsuwd $r38 = $r38r39.lo, 536870911 	#Opcode-lvx_v1-MADDSUWD_registerW_registerZ_upper27_lower5_double
	;;
	maddudt $r36r37 = $r36r37r38r39.z, $r39 	#Opcode-lvx_v1-MADDUDT_registerM_registerZ_registerY_simple
	;;
	madduwd $r38r39.hi = $r36r37r38r39.t, $r40 	#Opcode-lvx_v1-MADDUWD_registerW_registerZ_registerY_simple
	;;
	madduwd $r40r41.lo = $r40r41r42r43.x, 536870911 	#Opcode-lvx_v1-MADDUWD_registerW_registerZ_upper27_lower5_double
	;;
	maddwdp.su $r36r37r38r39.lo = $r18, $r18r19.lo 	#Opcode-lvx_v1-MADDWDP_widemult_registerM_registerZe_registerYe_simple
	;;
	maddwdp $r38r39 = $r19, $r18r19.hi 	#Opcode-lvx_v1-MADDWDP_widemult_registerM_registerZo_registerYo_simple
	;;
	maddwd.u $r41 = $r40r41.hi, $r40r41r42r43.y 	#Opcode-lvx_v1-MADDWD_widemult_registerW_registerZ_registerY_simple
	;;
	maddwd.su $r42 = $r42r43.lo, 536870911.@ 	#Opcode-lvx_v1-MADDWD_widemult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	maddwp $r16r17r18r19.z = $r20, $r20r21.lo 	#Opcode-lvx_v1-MADDWP_highmult_registerWe_registerZe_registerYe_simple
	;;
	maddwp.h $r16r17r18r19.t = $r21, $r20r21.hi 	#Opcode-lvx_v1-MADDWP_highmult_registerWo_registerZo_registerYo_simple
	;;
	maddw.hu.sx $r40r41r42r43.z = $r43, $r42r43.hi 	#Opcode-lvx_v1-MADDW_highmult_signextw_registerW_registerZ_registerY_simple
	;;
	maddw.hsu $r40r41r42r43.t = $r44, 536870911 	#Opcode-lvx_v1-MADDW_highmult_signextw_registerW_registerZ_upper27_lower5_double
	;;
	maddxbho.o $r36r37r38r39.hi = $r40r41, $r40r41r42r43.lo 	#Opcode-lvx_v1-MADDXBHO_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	maddxhwq.u $r42r43 = $r40r41r42r43.hi, $r44r45 	#Opcode-lvx_v1-MADDXHWQ_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	maddxwdp.o.su $r44r45r46r47.lo = $r46r47, $r44r45r46r47.hi 	#Opcode-lvx_v1-MADDXWDP_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	make $r44r45.lo = 2305843009213693951 	#Opcode-lvx_v1-MAKE_registerW_extend27_upper27_lower10_triple
	;;
	make $r44r45r46r47.x = -549755813888 	#Opcode-lvx_v1-MAKE_registerW_extend6_upper27_lower10_double
	;;
	make $r45 = -4096 	#Opcode-lvx_v1-MAKE_registerW_signed16_simple
	;;
	maxbo $r20r21r22r23.x = $r22, $r22r23.lo 	#Opcode-lvx_v1-MAXBO_registerWe_registerZe_registerYe_simple
	;;
	maxbo $r20r21r22r23.z = $r24, 536870911 	#Opcode-lvx_v1-MAXBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	maxbo $r20r21r22r23.y = $r23, $r22r23.hi 	#Opcode-lvx_v1-MAXBO_registerWo_registerZo_registerYo_simple
	;;
	maxbo $r20r21r22r23.t = $r25, 536870911.@ 	#Opcode-lvx_v1-MAXBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	maxd $r44r45.hi = $r44r45r46r47.y, 2305843009213693951 	#Opcode-lvx_v1-MAXD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	maxd $r46 = $r46r47.lo, $r44r45r46r47.z 	#Opcode-lvx_v1-MAXD_registerW_registerZ_registerY_simple
	;;
	maxd $r47 = $r46r47.hi, -64 	#Opcode-lvx_v1-MAXD_registerW_registerZ_signed10_simple
	;;
	maxd $r44r45r46r47.t = $r48, -8589934592 	#Opcode-lvx_v1-MAXD_registerW_registerZ_upper27_lower10_double
	;;
	maxhq $r24r25.lo = $r24r25r26r27.x, $r26 	#Opcode-lvx_v1-MAXHQ_registerWe_registerZe_registerYe_simple
	;;
	maxhq $r26r27.lo = $r24r25r26r27.z, 536870911 	#Opcode-lvx_v1-MAXHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	maxhq $r24r25.hi = $r24r25r26r27.y, $r27 	#Opcode-lvx_v1-MAXHQ_registerWo_registerZo_registerYo_simple
	;;
	maxhq $r26r27.hi = $r24r25r26r27.t, 536870911.@ 	#Opcode-lvx_v1-MAXHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	maxubo $r28 = $r28r29.lo, $r28r29r30r31.x 	#Opcode-lvx_v1-MAXUBO_registerWe_registerZe_registerYe_simple
	;;
	maxubo $r30 = $r30r31.lo, 536870911 	#Opcode-lvx_v1-MAXUBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	maxubo $r29 = $r28r29.hi, $r28r29r30r31.y 	#Opcode-lvx_v1-MAXUBO_registerWo_registerZo_registerYo_simple
	;;
	maxubo $r31 = $r30r31.hi, 536870911.@ 	#Opcode-lvx_v1-MAXUBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	maxud $r48r49.lo = $r48r49r50r51.x, 2305843009213693951 	#Opcode-lvx_v1-MAXUD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	maxud $r49 = $r48r49.hi, $r48r49r50r51.y 	#Opcode-lvx_v1-MAXUD_registerW_registerZ_registerY_simple
	;;
	maxud $r50 = $r50r51.lo, -64 	#Opcode-lvx_v1-MAXUD_registerW_registerZ_signed10_simple
	;;
	maxud $r48r49r50r51.z = $r51, -8589934592 	#Opcode-lvx_v1-MAXUD_registerW_registerZ_upper27_lower10_double
	;;
	maxuhq $r28r29r30r31.z = $r32, $r32r33.lo 	#Opcode-lvx_v1-MAXUHQ_registerWe_registerZe_registerYe_simple
	;;
	maxuhq $r32r33r34r35.x = $r34, 536870911 	#Opcode-lvx_v1-MAXUHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	maxuhq $r28r29r30r31.t = $r33, $r32r33.hi 	#Opcode-lvx_v1-MAXUHQ_registerWo_registerZo_registerYo_simple
	;;
	maxuhq $r32r33r34r35.y = $r35, 536870911.@ 	#Opcode-lvx_v1-MAXUHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	maxuwp $r34r35.lo = $r32r33r34r35.z, $r36 	#Opcode-lvx_v1-MAXUWP_registerWe_registerZe_registerYe_simple
	;;
	maxuwp $r36r37.lo = $r36r37r38r39.x, 536870911 	#Opcode-lvx_v1-MAXUWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	maxuwp $r34r35.hi = $r32r33r34r35.t, $r37 	#Opcode-lvx_v1-MAXUWP_registerWo_registerZo_registerYo_simple
	;;
	maxuwp $r36r37.hi = $r36r37r38r39.y, 536870911.@ 	#Opcode-lvx_v1-MAXUWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	maxuw.sx $r50r51.hi = $r48r49r50r51.t, $r52 	#Opcode-lvx_v1-MAXUW_signextw_registerW_registerZ_registerY_simple
	;;
	maxuw $r52r53.lo = $r52r53r54r55.x, 536870911 	#Opcode-lvx_v1-MAXUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	maxwp $r38 = $r38r39.lo, $r36r37r38r39.z 	#Opcode-lvx_v1-MAXWP_registerWe_registerZe_registerYe_simple
	;;
	maxwp $r40 = $r40r41.lo, 536870911 	#Opcode-lvx_v1-MAXWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	maxwp $r39 = $r38r39.hi, $r36r37r38r39.t 	#Opcode-lvx_v1-MAXWP_registerWo_registerZo_registerYo_simple
	;;
	maxwp $r41 = $r40r41.hi, 536870911.@ 	#Opcode-lvx_v1-MAXWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	maxw.sx $r53 = $r52r53.hi, $r52r53r54r55.y 	#Opcode-lvx_v1-MAXW_signextw_registerW_registerZ_registerY_simple
	;;
	maxw $r54 = $r54r55.lo, 536870911 	#Opcode-lvx_v1-MAXW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	minbo $r40r41r42r43.x = $r42, $r42r43.lo 	#Opcode-lvx_v1-MINBO_registerWe_registerZe_registerYe_simple
	;;
	minbo $r40r41r42r43.z = $r44, 536870911 	#Opcode-lvx_v1-MINBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	minbo $r40r41r42r43.y = $r43, $r42r43.hi 	#Opcode-lvx_v1-MINBO_registerWo_registerZo_registerYo_simple
	;;
	minbo $r40r41r42r43.t = $r45, 536870911.@ 	#Opcode-lvx_v1-MINBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	mind $r52r53r54r55.z = $r55, 2305843009213693951 	#Opcode-lvx_v1-MIND_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	mind $r54r55.hi = $r52r53r54r55.t, $r56 	#Opcode-lvx_v1-MIND_registerW_registerZ_registerY_simple
	;;
	mind $r56r57.lo = $r56r57r58r59.x, -64 	#Opcode-lvx_v1-MIND_registerW_registerZ_signed10_simple
	;;
	mind $r57 = $r56r57.hi, -8589934592 	#Opcode-lvx_v1-MIND_registerW_registerZ_upper27_lower10_double
	;;
	minhq $r44r45.lo = $r44r45r46r47.x, $r46 	#Opcode-lvx_v1-MINHQ_registerWe_registerZe_registerYe_simple
	;;
	minhq $r46r47.lo = $r44r45r46r47.z, 536870911 	#Opcode-lvx_v1-MINHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	minhq $r44r45.hi = $r44r45r46r47.y, $r47 	#Opcode-lvx_v1-MINHQ_registerWo_registerZo_registerYo_simple
	;;
	minhq $r46r47.hi = $r44r45r46r47.t, 536870911.@ 	#Opcode-lvx_v1-MINHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	minubo $r48 = $r48r49.lo, $r48r49r50r51.x 	#Opcode-lvx_v1-MINUBO_registerWe_registerZe_registerYe_simple
	;;
	minubo $r50 = $r50r51.lo, 536870911 	#Opcode-lvx_v1-MINUBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	minubo $r49 = $r48r49.hi, $r48r49r50r51.y 	#Opcode-lvx_v1-MINUBO_registerWo_registerZo_registerYo_simple
	;;
	minubo $r51 = $r50r51.hi, 536870911.@ 	#Opcode-lvx_v1-MINUBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	minud $r56r57r58r59.y = $r58, 2305843009213693951 	#Opcode-lvx_v1-MINUD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	minud $r58r59.lo = $r56r57r58r59.z, $r59 	#Opcode-lvx_v1-MINUD_registerW_registerZ_registerY_simple
	;;
	minud $r58r59.hi = $r56r57r58r59.t, -64 	#Opcode-lvx_v1-MINUD_registerW_registerZ_signed10_simple
	;;
	minud $r60 = $r60r61.lo, -8589934592 	#Opcode-lvx_v1-MINUD_registerW_registerZ_upper27_lower10_double
	;;
	minuhq $r48r49r50r51.z = $r52, $r52r53.lo 	#Opcode-lvx_v1-MINUHQ_registerWe_registerZe_registerYe_simple
	;;
	minuhq $r52r53r54r55.x = $r54, 536870911 	#Opcode-lvx_v1-MINUHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	minuhq $r48r49r50r51.t = $r53, $r52r53.hi 	#Opcode-lvx_v1-MINUHQ_registerWo_registerZo_registerYo_simple
	;;
	minuhq $r52r53r54r55.y = $r55, 536870911.@ 	#Opcode-lvx_v1-MINUHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	minuwp $r54r55.lo = $r52r53r54r55.z, $r56 	#Opcode-lvx_v1-MINUWP_registerWe_registerZe_registerYe_simple
	;;
	minuwp $r56r57.lo = $r56r57r58r59.x, 536870911 	#Opcode-lvx_v1-MINUWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	minuwp $r54r55.hi = $r52r53r54r55.t, $r57 	#Opcode-lvx_v1-MINUWP_registerWo_registerZo_registerYo_simple
	;;
	minuwp $r56r57.hi = $r56r57r58r59.y, 536870911.@ 	#Opcode-lvx_v1-MINUWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	minuw.sx $r60r61r62r63.x = $r61, $r60r61.hi 	#Opcode-lvx_v1-MINUW_signextw_registerW_registerZ_registerY_simple
	;;
	minuw $r60r61r62r63.y = $r62, 536870911 	#Opcode-lvx_v1-MINUW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	minwp $r58 = $r58r59.lo, $r56r57r58r59.z 	#Opcode-lvx_v1-MINWP_registerWe_registerZe_registerYe_simple
	;;
	minwp $r60 = $r60r61.lo, 536870911 	#Opcode-lvx_v1-MINWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	minwp $r59 = $r58r59.hi, $r56r57r58r59.t 	#Opcode-lvx_v1-MINWP_registerWo_registerZo_registerYo_simple
	;;
	minwp $r61 = $r60r61.hi, 536870911.@ 	#Opcode-lvx_v1-MINWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	minw.sx $r62r63.lo = $r60r61r62r63.z, $r63 	#Opcode-lvx_v1-MINW_signextw_registerW_registerZ_registerY_simple
	;;
	minw $r62r63.hi = $r60r61r62r63.t, 536870911 	#Opcode-lvx_v1-MINW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	msbfbho $r48r49 = $r60r61r62r63.x, $r62 	#Opcode-lvx_v1-MSBFBHO_widemult_registerM_registerZe_registerYe_simple
	;;
	msbfbho.u $r48r49r50r51.lo = $r60r61r62r63.y, $r63 	#Opcode-lvx_v1-MSBFBHO_widemult_registerM_registerZo_registerYo_simple
	;;
	msbfdq.su $r50r51 = $r0, $r0r1.lo 	#Opcode-lvx_v1-MSBFDQ_widemult_registerM_registerZ_registerY_simple
	;;
	msbfdt $r48r49r50r51.hi = $r0r1r2r3.x, $r1 	#Opcode-lvx_v1-MSBFDT_registerM_registerZ_registerY_simple
	;;
	msbfd $r0r1.hi = $r0r1r2r3.y, $r2 	#Opcode-lvx_v1-MSBFD_highmult_registerW_registerZ_registerY_simple
	;;
	msbfd.h $r2r3.lo = $r0r1r2r3.z, 536870911 	#Opcode-lvx_v1-MSBFD_highmult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	msbfhq.hu $r62r63.lo = $r60r61r62r63.z, $r0 	#Opcode-lvx_v1-MSBFHQ_highmult_registerWe_registerZe_registerYe_simple
	;;
	msbfhq.hsu $r62r63.hi = $r60r61r62r63.t, $r1 	#Opcode-lvx_v1-MSBFHQ_highmult_registerWo_registerZo_registerYo_simple
	;;
	msbfhwq $r52r53 = $r0r1.lo, $r0r1r2r3.x 	#Opcode-lvx_v1-MSBFHWQ_widemult_registerM_registerZe_registerYe_simple
	;;
	msbfhwq.u $r52r53r54r55.lo = $r0r1.hi, $r0r1r2r3.y 	#Opcode-lvx_v1-MSBFHWQ_widemult_registerM_registerZo_registerYo_simple
	;;
	msbfsudt $r54r55 = $r3, $r2r3.hi 	#Opcode-lvx_v1-MSBFSUDT_registerM_registerZ_registerY_simple
	;;
	msbfsuwd $r0r1r2r3.t = $r4, $r4r5.lo 	#Opcode-lvx_v1-MSBFSUWD_registerW_registerZ_registerY_simple
	;;
	msbfsuwd $r4r5r6r7.x = $r5, 536870911 	#Opcode-lvx_v1-MSBFSUWD_registerW_registerZ_upper27_lower5_double
	;;
	msbfudt $r52r53r54r55.hi = $r4r5.hi, $r4r5r6r7.y 	#Opcode-lvx_v1-MSBFUDT_registerM_registerZ_registerY_simple
	;;
	msbfuwd $r6 = $r6r7.lo, $r4r5r6r7.z 	#Opcode-lvx_v1-MSBFUWD_registerW_registerZ_registerY_simple
	;;
	msbfuwd $r7 = $r6r7.hi, 536870911 	#Opcode-lvx_v1-MSBFUWD_registerW_registerZ_upper27_lower5_double
	;;
	msbfwdp.su $r56r57 = $r2, $r2r3.lo 	#Opcode-lvx_v1-MSBFWDP_widemult_registerM_registerZe_registerYe_simple
	;;
	msbfwdp $r56r57r58r59.lo = $r3, $r2r3.hi 	#Opcode-lvx_v1-MSBFWDP_widemult_registerM_registerZo_registerYo_simple
	;;
	msbfwd.u $r4r5r6r7.t = $r8, $r8r9.lo 	#Opcode-lvx_v1-MSBFWD_widemult_registerW_registerZ_registerY_simple
	;;
	msbfwd.su $r8r9r10r11.x = $r9, 536870911.@ 	#Opcode-lvx_v1-MSBFWD_widemult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	msbfwp $r0r1r2r3.z = $r4, $r4r5.lo 	#Opcode-lvx_v1-MSBFWP_highmult_registerWe_registerZe_registerYe_simple
	;;
	msbfwp.h $r0r1r2r3.t = $r5, $r4r5.hi 	#Opcode-lvx_v1-MSBFWP_highmult_registerWo_registerZo_registerYo_simple
	;;
	msbfw.hu.sx $r8r9.hi = $r8r9r10r11.y, $r10 	#Opcode-lvx_v1-MSBFW_highmult_signextw_registerW_registerZ_registerY_simple
	;;
	msbfw.hsu $r10r11.lo = $r8r9r10r11.z, 536870911 	#Opcode-lvx_v1-MSBFW_highmult_signextw_registerW_registerZ_upper27_lower5_double
	;;
	msbfxbho $r58r59 = $r56r57r58r59.hi, $r60r61 	#Opcode-lvx_v1-MSBFXBHO_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	msbfxhwq.o.u $r60r61r62r63.lo = $r62r63, $r60r61r62r63.hi 	#Opcode-lvx_v1-MSBFXHWQ_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	msbfxwdp.su $r0r1 = $r0r1r2r3.lo, $r2r3 	#Opcode-lvx_v1-MSBFXWDP_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	mulbho $r0r1r2r3.hi = $r4r5r6r7.x, $r6 	#Opcode-lvx_v1-MULBHO_widemult_registerM_registerZe_registerYe_simple
	;;
	mulbho.u $r4r5 = $r4r5r6r7.y, $r7 	#Opcode-lvx_v1-MULBHO_widemult_registerM_registerZo_registerYo_simple
	;;
	muldq.su $r4r5r6r7.lo = $r11, $r10r11.hi 	#Opcode-lvx_v1-MULDQ_widemult_registerM_registerZ_registerY_simple
	;;
	muldt $r6r7 = $r8r9r10r11.t, $r12 	#Opcode-lvx_v1-MULDT_registerM_registerZ_registerY_simple
	;;
	muld $sp = $r13, $tp 	#Opcode-lvx_v1-MULD_highmult_registerW_registerZ_registerY_simple
	;;
	muld.h $r14 = $fp, 536870911 	#Opcode-lvx_v1-MULD_highmult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	mulhq.hu $r6r7.lo = $r4r5r6r7.z, $r8 	#Opcode-lvx_v1-MULHQ_highmult_registerWe_registerZe_registerYe_simple
	;;
	mulhq.hsu $r6r7.hi = $r4r5r6r7.t, $r9 	#Opcode-lvx_v1-MULHQ_highmult_registerWo_registerZo_registerYo_simple
	;;
	mulhwq $r4r5r6r7.hi = $r8r9.lo, $r8r9r10r11.x 	#Opcode-lvx_v1-MULHWQ_widemult_registerM_registerZe_registerYe_simple
	;;
	mulhwq.u $r8r9 = $r8r9.hi, $r8r9r10r11.y 	#Opcode-lvx_v1-MULHWQ_widemult_registerM_registerZo_registerYo_simple
	;;
	mulnbho.su $r8r9r10r11.lo = $r10, $r10r11.lo 	#Opcode-lvx_v1-MULNBHO_widemult_registerM_registerZe_registerYe_simple
	;;
	mulnbho $r10r11 = $r11, $r10r11.hi 	#Opcode-lvx_v1-MULNBHO_widemult_registerM_registerZo_registerYo_simple
	;;
	mulndq.u $r8r9r10r11.hi = $r14r15.lo, $r15 	#Opcode-lvx_v1-MULNDQ_widemult_registerM_registerZ_registerY_simple
	;;
	mulnd $rp = $r14r15.hi, $r16 	#Opcode-lvx_v1-MULND_highmult_registerW_registerZ_registerY_simple
	;;
	mulnd.h $r16r17.lo = $r16r17r18r19.x, 536870911.@ 	#Opcode-lvx_v1-MULND_highmult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	mulnhq.hu $r8r9r10r11.z = $r12, $sp 	#Opcode-lvx_v1-MULNHQ_highmult_registerWe_registerZe_registerYe_simple
	;;
	mulnhq.hsu $r8r9r10r11.t = $r13, $tp 	#Opcode-lvx_v1-MULNHQ_highmult_registerWo_registerZo_registerYo_simple
	;;
	mulnhwq.su $r12r13 = $r14, $fp 	#Opcode-lvx_v1-MULNHWQ_widemult_registerM_registerZe_registerYe_simple
	;;
	mulnhwq $r12r13r14r15.lo = $r15, $rp 	#Opcode-lvx_v1-MULNHWQ_widemult_registerM_registerZo_registerYo_simple
	;;
	mulnwdp.u $r14r15 = $r14r15.lo, $r16 	#Opcode-lvx_v1-MULNWDP_widemult_registerM_registerZe_registerYe_simple
	;;
	mulnwdp.su $r12r13r14r15.hi = $r14r15.hi, $r17 	#Opcode-lvx_v1-MULNWDP_widemult_registerM_registerZo_registerYo_simple
	;;
	mulnwd $r17 = $r16r17.hi, $r16r17r18r19.y 	#Opcode-lvx_v1-MULNWD_widemult_registerW_registerZ_registerY_simple
	;;
	mulnwd.u $r18 = $r18r19.lo, 536870911 	#Opcode-lvx_v1-MULNWD_widemult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	mulnwp $r16r17.lo = $r16r17r18r19.x, $r18 	#Opcode-lvx_v1-MULNWP_highmult_registerWe_registerZe_registerYe_simple
	;;
	mulnwp.h $r16r17.hi = $r16r17r18r19.y, $r19 	#Opcode-lvx_v1-MULNWP_highmult_registerWo_registerZo_registerYo_simple
	;;
	mulnw.hu.sx $r16r17r18r19.z = $r19, $r18r19.hi 	#Opcode-lvx_v1-MULNW_highmult_signextw_registerW_registerZ_registerY_simple
	;;
	mulnw.hsu $r16r17r18r19.t = $r20, 536870911 	#Opcode-lvx_v1-MULNW_highmult_signextw_registerW_registerZ_upper27_lower5_double
	;;
	mulnxbho.o.su $r16r17 = $r16r17r18r19.lo, $r18r19 	#Opcode-lvx_v1-MULNXBHO_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	mulnxhwq $r16r17r18r19.hi = $r20r21, $r20r21r22r23.lo 	#Opcode-lvx_v1-MULNXHWQ_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	mulnxwdp.o.u $r22r23 = $r20r21r22r23.hi, $r24r25 	#Opcode-lvx_v1-MULNXWDP_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	mulsudt $r24r25r26r27.lo = $r20r21.lo, $r20r21r22r23.x 	#Opcode-lvx_v1-MULSUDT_registerM_registerZ_registerY_simple
	;;
	mulsuwd $r21 = $r20r21.hi, $r20r21r22r23.y 	#Opcode-lvx_v1-MULSUWD_registerW_registerZ_registerY_simple
	;;
	mulsuwd $r22 = $r22r23.lo, 536870911 	#Opcode-lvx_v1-MULSUWD_registerW_registerZ_upper27_lower5_double
	;;
	muludt $r26r27 = $r20r21r22r23.z, $r23 	#Opcode-lvx_v1-MULUDT_registerM_registerZ_registerY_simple
	;;
	muluwd $r22r23.hi = $r20r21r22r23.t, $r24 	#Opcode-lvx_v1-MULUWD_registerW_registerZ_registerY_simple
	;;
	muluwd $r24r25.lo = $r24r25r26r27.x, 536870911 	#Opcode-lvx_v1-MULUWD_registerW_registerZ_upper27_lower5_double
	;;
	mulwdp.su $r24r25r26r27.hi = $r18r19.lo, $r16r17r18r19.z 	#Opcode-lvx_v1-MULWDP_widemult_registerM_registerZe_registerYe_simple
	;;
	mulwdp $r28r29 = $r18r19.hi, $r16r17r18r19.t 	#Opcode-lvx_v1-MULWDP_widemult_registerM_registerZo_registerYo_simple
	;;
	mulwd.u $r25 = $r24r25.hi, $r24r25r26r27.y 	#Opcode-lvx_v1-MULWD_widemult_registerW_registerZ_registerY_simple
	;;
	mulwd.su $r26 = $r26r27.lo, 536870911.@ 	#Opcode-lvx_v1-MULWD_widemult_registerW_registerZ_upper27_lower5_splat32_double
	;;
	mulwp $r20 = $r20r21.lo, $r20r21r22r23.x 	#Opcode-lvx_v1-MULWP_highmult_registerWe_registerZe_registerYe_simple
	;;
	mulwp.h $r21 = $r20r21.hi, $r20r21r22r23.y 	#Opcode-lvx_v1-MULWP_highmult_registerWo_registerZo_registerYo_simple
	;;
	mulw.hu.sx $r24r25r26r27.z = $r27, $r26r27.hi 	#Opcode-lvx_v1-MULW_highmult_signextw_registerW_registerZ_registerY_simple
	;;
	mulw.hsu $r24r25r26r27.t = $r28, 536870911 	#Opcode-lvx_v1-MULW_highmult_signextw_registerW_registerZ_upper27_lower5_double
	;;
	mulxbho $r28r29r30r31.lo = $r30r31, $r28r29r30r31.hi 	#Opcode-lvx_v1-MULXBHO_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	mulxhwq.o.u $r32r33 = $r32r33r34r35.lo, $r34r35 	#Opcode-lvx_v1-MULXHWQ_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	mulxwdp.su $r32r33r34r35.hi = $r36r37, $r36r37r38r39.lo 	#Opcode-lvx_v1-MULXWDP_oddlanes_widemult_registerM_registerP_registerO_simple
	;;
	nandd $r28r29.lo = $r28r29r30r31.x, 2305843009213693951 	#Opcode-lvx_v1-NANDD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	nandd $r29 = $r28r29.hi, $r28r29r30r31.y 	#Opcode-lvx_v1-NANDD_registerW_registerZ_registerY_simple
	;;
	nandd $r30 = $r30r31.lo, -64 	#Opcode-lvx_v1-NANDD_registerW_registerZ_signed10_simple
	;;
	nandd $r28r29r30r31.z = $r31, -8589934592 	#Opcode-lvx_v1-NANDD_registerW_registerZ_upper27_lower10_double
	;;
	nandq $r38r39 = $r36r37r38r39.hi, $r40r41 	#Opcode-lvx_v1-NANDQ_registerM_registerP_registerO_simple
	;;
	nandq $r40r41r42r43.lo = $r42r43, 536870911 	#Opcode-lvx_v1-NANDQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	nandw.sx $r30r31.hi = $r28r29r30r31.t, $r32 	#Opcode-lvx_v1-NANDW_signextw_registerW_registerZ_registerY_simple
	;;
	nandw $r32r33.lo = $r32r33r34r35.x, 536870911 	#Opcode-lvx_v1-NANDW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	negbo $r22 = $r22r23.lo 	#Opcode-lvx_v1-NEGBO_registerWe_registerZe_simple
	;;
	negbo $r23 = $r22r23.hi 	#Opcode-lvx_v1-NEGBO_registerWo_registerZo_simple
	;;
	negd $r33 = $r32r33.hi 	#Opcode-lvx_v1-NEGD_registerW_registerZ_simple
	;;
	neghq $r20r21r22r23.z = $r24 	#Opcode-lvx_v1-NEGHQ_registerWe_registerZe_simple
	;;
	neghq $r20r21r22r23.t = $r25 	#Opcode-lvx_v1-NEGHQ_registerWo_registerZo_simple
	;;
	negq $r40r41r42r43.hi = $r44r45 	#Opcode-lvx_v1-NEGQ_registerM_registerP_simple
	;;
	negsbo $r24r25.lo = $r24r25r26r27.x 	#Opcode-lvx_v1-NEGSBO_registerWe_registerZe_simple
	;;
	negsbo $r24r25.hi = $r24r25r26r27.y 	#Opcode-lvx_v1-NEGSBO_registerWo_registerZo_simple
	;;
	negsd $r32r33r34r35.y = $r34 	#Opcode-lvx_v1-NEGSD_registerW_registerZ_simple
	;;
	negshq $r26 = $r26r27.lo 	#Opcode-lvx_v1-NEGSHQ_registerWe_registerZe_simple
	;;
	negshq $r27 = $r26r27.hi 	#Opcode-lvx_v1-NEGSHQ_registerWo_registerZo_simple
	;;
	negswp $r24r25r26r27.z = $r28 	#Opcode-lvx_v1-NEGSWP_registerWe_registerZe_simple
	;;
	negswp $r24r25r26r27.t = $r29 	#Opcode-lvx_v1-NEGSWP_registerWo_registerZo_simple
	;;
	negsw $r34r35.lo = $r32r33r34r35.z 	#Opcode-lvx_v1-NEGSW_registerW_registerZ_simple
	;;
	negwp $r28r29.lo = $r28r29r30r31.x 	#Opcode-lvx_v1-NEGWP_registerWe_registerZe_simple
	;;
	negwp $r28r29.hi = $r28r29r30r31.y 	#Opcode-lvx_v1-NEGWP_registerWo_registerZo_simple
	;;
	negw $r35 = $r34r35.hi 	#Opcode-lvx_v1-NEGW_registerW_registerZ_simple
	;;
	neord $r32r33r34r35.t = $r36, 2305843009213693951 	#Opcode-lvx_v1-NEORD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	neord $r36r37.lo = $r36r37r38r39.x, $r37 	#Opcode-lvx_v1-NEORD_registerW_registerZ_registerY_simple
	;;
	neord $r36r37.hi = $r36r37r38r39.y, -64 	#Opcode-lvx_v1-NEORD_registerW_registerZ_signed10_simple
	;;
	neord $r38 = $r38r39.lo, -8589934592 	#Opcode-lvx_v1-NEORD_registerW_registerZ_upper27_lower10_double
	;;
	neorq $r44r45r46r47.lo = $r46r47, $r44r45r46r47.hi 	#Opcode-lvx_v1-NEORQ_registerM_registerP_registerO_simple
	;;
	neorq $r48r49 = $r48r49r50r51.lo, 536870911.@ 	#Opcode-lvx_v1-NEORQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	neorw.sx $r36r37r38r39.z = $r39, $r38r39.hi 	#Opcode-lvx_v1-NEORW_signextw_registerW_registerZ_registerY_simple
	;;
	neorw $r36r37r38r39.t = $r40, 536870911 	#Opcode-lvx_v1-NEORW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	niord $r40r41.lo = $r40r41r42r43.x, 2305843009213693951 	#Opcode-lvx_v1-NIORD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	niord $r41 = $r40r41.hi, $r40r41r42r43.y 	#Opcode-lvx_v1-NIORD_registerW_registerZ_registerY_simple
	;;
	niord $r42 = $r42r43.lo, -64 	#Opcode-lvx_v1-NIORD_registerW_registerZ_signed10_simple
	;;
	niord $r40r41r42r43.z = $r43, -8589934592 	#Opcode-lvx_v1-NIORD_registerW_registerZ_upper27_lower10_double
	;;
	niorq $r50r51 = $r48r49r50r51.hi, $r52r53 	#Opcode-lvx_v1-NIORQ_registerM_registerP_registerO_simple
	;;
	niorq $r52r53r54r55.lo = $r54r55, 536870911 	#Opcode-lvx_v1-NIORQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	niorw.sx $r42r43.hi = $r40r41r42r43.t, $r44 	#Opcode-lvx_v1-NIORW_signextw_registerW_registerZ_registerY_simple
	;;
	niorw $r44r45.lo = $r44r45r46r47.x, 536870911 	#Opcode-lvx_v1-NIORW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	nop 	#Opcode-lvx_v1-NOP_simple
	;;
	notd $r45 = $r44r45.hi 	#Opcode-lvx_v1-NOTD_registerW_registerZ_simple
	;;
	notq $r52r53r54r55.hi = $r56r57 	#Opcode-lvx_v1-NOTQ_registerM_registerP_simple
	;;
	notw $r44r45r46r47.y = $r46 	#Opcode-lvx_v1-NOTW_registerW_registerZ_simple
	;;
	pcrel $r46r47.lo = 2305843009213693951 	#Opcode-lvx_v1-PCREL_registerW_extend27_upper27_lower10_triple
	;;
	pcrel $r44r45r46r47.z = -549755813888 	#Opcode-lvx_v1-PCREL_registerW_extend6_upper27_lower10_double
	;;
	pcrel $r47 = -4096 	#Opcode-lvx_v1-PCREL_registerW_signed16_simple
	;;
	ret 	#Opcode-lvx_v1-RET_simple
	;;
	rfe 	#Opcode-lvx_v1-RFE_simple
	;;
	rold $r46r47.hi = $r44r45r46r47.t, $r48 	#Opcode-lvx_v1-ROLD_registerW_registerZ_registerY_simple
	;;
	rold $r48r49.lo = $r48r49r50r51.x, 7 	#Opcode-lvx_v1-ROLD_registerW_registerZ_unsigned6_simple
	;;
	rolwp $r30 = $r30r31.lo, $r49 	#Opcode-lvx_v1-ROLWP_registerWe_registerZe_registerY_simple
	;;
	rolwp $r28r29r30r31.z = $r32, 7 	#Opcode-lvx_v1-ROLWP_registerWe_registerZe_unsigned6_simple
	;;
	rolwp $r31 = $r30r31.hi, $r48r49.hi 	#Opcode-lvx_v1-ROLWP_registerWo_registerZo_registerY_simple
	;;
	rolwp $r28r29r30r31.t = $r33, 7 	#Opcode-lvx_v1-ROLWP_registerWo_registerZo_unsigned6_simple
	;;
	rolw.sx $r48r49r50r51.y = $r50, $r50r51.lo 	#Opcode-lvx_v1-ROLW_signextw_registerW_registerZ_registerY_simple
	;;
	rolw $r48r49r50r51.z = $r51, 7 	#Opcode-lvx_v1-ROLW_signextw_registerW_registerZ_unsigned6_simple
	;;
	rord $r50r51.hi = $r48r49r50r51.t, $r52 	#Opcode-lvx_v1-RORD_registerW_registerZ_registerY_simple
	;;
	rord $r52r53.lo = $r52r53r54r55.x, 7 	#Opcode-lvx_v1-RORD_registerW_registerZ_unsigned6_simple
	;;
	rorwp $r32r33.lo = $r32r33r34r35.x, $r53 	#Opcode-lvx_v1-RORWP_registerWe_registerZe_registerY_simple
	;;
	rorwp $r34 = $r34r35.lo, 7 	#Opcode-lvx_v1-RORWP_registerWe_registerZe_unsigned6_simple
	;;
	rorwp $r32r33.hi = $r32r33r34r35.y, $r52r53.hi 	#Opcode-lvx_v1-RORWP_registerWo_registerZo_registerY_simple
	;;
	rorwp $r35 = $r34r35.hi, 7 	#Opcode-lvx_v1-RORWP_registerWo_registerZo_unsigned6_simple
	;;
	rorw.sx $r52r53r54r55.y = $r54, $r54r55.lo 	#Opcode-lvx_v1-RORW_signextw_registerW_registerZ_registerY_simple
	;;
	rorw $r52r53r54r55.z = $r55, 7 	#Opcode-lvx_v1-RORW_signextw_registerW_registerZ_unsigned6_simple
	;;
	rswap $r54r55.hi = $mmc 	#Opcode-lvx_v1-RSWAP_registerZ_systemAlone_simple
	;;
	rswap $r52r53r54r55.t = $s0 	#Opcode-lvx_v1-RSWAP_registerZ_systemS3_simple
	;;
	rswap $r56 = $pc 	#Opcode-lvx_v1-RSWAP_registerZ_systemS4_simple
	;;
	sbfbo $r32r33r34r35.z = $r36, $r36r37.lo 	#Opcode-lvx_v1-SBFBO_registerWe_registerZe_registerYe_simple
	;;
	sbfbo $r36r37r38r39.x = $r38, 536870911.@ 	#Opcode-lvx_v1-SBFBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	sbfbo $r32r33r34r35.t = $r37, $r36r37.hi 	#Opcode-lvx_v1-SBFBO_registerWo_registerZo_registerYo_simple
	;;
	sbfbo $r36r37r38r39.y = $r39, 536870911 	#Opcode-lvx_v1-SBFBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	sbfd $r56r57.lo = $r56r57r58r59.x, 2305843009213693951 	#Opcode-lvx_v1-SBFD_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbfd $r57 = $r56r57.hi, $r56r57r58r59.y 	#Opcode-lvx_v1-SBFD_registerW_registerZ_registerY_simple
	;;
	sbfd $r58 = $r58r59.lo, -64 	#Opcode-lvx_v1-SBFD_registerW_registerZ_signed10_simple
	;;
	sbfd $r56r57r58r59.z = $r59, -8589934592 	#Opcode-lvx_v1-SBFD_registerW_registerZ_upper27_lower10_double
	;;
	sbfhq $r38r39.lo = $r36r37r38r39.z, $r40 	#Opcode-lvx_v1-SBFHQ_registerWe_registerZe_registerYe_simple
	;;
	sbfhq $r40r41.lo = $r40r41r42r43.x, 536870911.@ 	#Opcode-lvx_v1-SBFHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	sbfhq $r38r39.hi = $r36r37r38r39.t, $r41 	#Opcode-lvx_v1-SBFHQ_registerWo_registerZo_registerYo_simple
	;;
	sbfhq $r40r41.hi = $r40r41r42r43.y, 536870911 	#Opcode-lvx_v1-SBFHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	sbfq $r56r57r58r59.lo = $r58r59, $r56r57r58r59.hi 	#Opcode-lvx_v1-SBFQ_registerM_registerP_registerO_simple
	;;
	sbfq $r60r61 = $r60r61r62r63.lo, 536870911.@ 	#Opcode-lvx_v1-SBFQ_registerM_registerP_upper27_lower5_splat32_double
	;;
	sbfsbo $r42 = $r42r43.lo, $r40r41r42r43.z 	#Opcode-lvx_v1-SBFSBO_registerWe_registerZe_registerYe_simple
	;;
	sbfsbo $r44 = $r44r45.lo, 536870911 	#Opcode-lvx_v1-SBFSBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	sbfsbo $r43 = $r42r43.hi, $r40r41r42r43.t 	#Opcode-lvx_v1-SBFSBO_registerWo_registerZo_registerYo_simple
	;;
	sbfsbo $r45 = $r44r45.hi, 536870911.@ 	#Opcode-lvx_v1-SBFSBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	sbfsd $r58r59.hi = $r56r57r58r59.t, $r60 	#Opcode-lvx_v1-SBFSD_registerW_registerZ_registerY_simple
	;;
	sbfsd $r60r61.lo = $r60r61r62r63.x, 536870911 	#Opcode-lvx_v1-SBFSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	sbfshq $r44r45r46r47.x = $r46, $r46r47.lo 	#Opcode-lvx_v1-SBFSHQ_registerWe_registerZe_registerYe_simple
	;;
	sbfshq $r44r45r46r47.z = $r48, 536870911.@ 	#Opcode-lvx_v1-SBFSHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	sbfshq $r44r45r46r47.y = $r47, $r46r47.hi 	#Opcode-lvx_v1-SBFSHQ_registerWo_registerZo_registerYo_simple
	;;
	sbfshq $r44r45r46r47.t = $r49, 536870911 	#Opcode-lvx_v1-SBFSHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	sbfswp $r48r49.lo = $r48r49r50r51.x, $r50 	#Opcode-lvx_v1-SBFSWP_registerWe_registerZe_registerYe_simple
	;;
	sbfswp $r50r51.lo = $r48r49r50r51.z, 536870911.@ 	#Opcode-lvx_v1-SBFSWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	sbfswp $r48r49.hi = $r48r49r50r51.y, $r51 	#Opcode-lvx_v1-SBFSWP_registerWo_registerZo_registerYo_simple
	;;
	sbfswp $r50r51.hi = $r48r49r50r51.t, 536870911 	#Opcode-lvx_v1-SBFSWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	sbfsw.sx $r61 = $r60r61.hi, $r60r61r62r63.y 	#Opcode-lvx_v1-SBFSW_signextw_registerW_registerZ_registerY_simple
	;;
	sbfsw $r62 = $r62r63.lo, 536870911 	#Opcode-lvx_v1-SBFSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	sbfusbo $r52 = $r52r53.lo, $r52r53r54r55.x 	#Opcode-lvx_v1-SBFUSBO_registerWe_registerZe_registerYe_simple
	;;
	sbfusbo $r54 = $r54r55.lo, 536870911.@ 	#Opcode-lvx_v1-SBFUSBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	sbfusbo $r53 = $r52r53.hi, $r52r53r54r55.y 	#Opcode-lvx_v1-SBFUSBO_registerWo_registerZo_registerYo_simple
	;;
	sbfusbo $r55 = $r54r55.hi, 536870911 	#Opcode-lvx_v1-SBFUSBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	sbfusd $r60r61r62r63.z = $r63, $r62r63.hi 	#Opcode-lvx_v1-SBFUSD_registerW_registerZ_registerY_simple
	;;
	sbfusd $r60r61r62r63.t = $r0, 536870911.@ 	#Opcode-lvx_v1-SBFUSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	sbfushq $r52r53r54r55.z = $r56, $r56r57.lo 	#Opcode-lvx_v1-SBFUSHQ_registerWe_registerZe_registerYe_simple
	;;
	sbfushq $r56r57r58r59.x = $r58, 536870911 	#Opcode-lvx_v1-SBFUSHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	sbfushq $r52r53r54r55.t = $r57, $r56r57.hi 	#Opcode-lvx_v1-SBFUSHQ_registerWo_registerZo_registerYo_simple
	;;
	sbfushq $r56r57r58r59.y = $r59, 536870911.@ 	#Opcode-lvx_v1-SBFUSHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	sbfuswp $r58r59.lo = $r56r57r58r59.z, $r60 	#Opcode-lvx_v1-SBFUSWP_registerWe_registerZe_registerYe_simple
	;;
	sbfuswp $r60r61.lo = $r60r61r62r63.x, 536870911 	#Opcode-lvx_v1-SBFUSWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	sbfuswp $r58r59.hi = $r56r57r58r59.t, $r61 	#Opcode-lvx_v1-SBFUSWP_registerWo_registerZo_registerYo_simple
	;;
	sbfuswp $r60r61.hi = $r60r61r62r63.y, 536870911.@ 	#Opcode-lvx_v1-SBFUSWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	sbfusw.sx $r0r1.lo = $r0r1r2r3.x, $r1 	#Opcode-lvx_v1-SBFUSW_signextw_registerW_registerZ_registerY_simple
	;;
	sbfusw $r0r1.hi = $r0r1r2r3.y, 536870911 	#Opcode-lvx_v1-SBFUSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	sbfwp $r62 = $r62r63.lo, $r60r61r62r63.z 	#Opcode-lvx_v1-SBFWP_registerWe_registerZe_registerYe_simple
	;;
	sbfwp $r0 = $r0r1.lo, 536870911 	#Opcode-lvx_v1-SBFWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	sbfwp $r63 = $r62r63.hi, $r60r61r62r63.t 	#Opcode-lvx_v1-SBFWP_registerWo_registerZo_registerYo_simple
	;;
	sbfwp $r1 = $r0r1.hi, 536870911.@ 	#Opcode-lvx_v1-SBFWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	sbfw.sx $r2 = $r2r3.lo, $r0r1r2r3.z 	#Opcode-lvx_v1-SBFW_signextw_registerW_registerZ_registerY_simple
	;;
	sbfw $r3 = $r2r3.hi, 536870911 	#Opcode-lvx_v1-SBFW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	sbmm8d $r0r1r2r3.t = $r4, 2305843009213693951 	#Opcode-lvx_v1-SBMM8D_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbmm8d $r4r5.lo = $r4r5r6r7.x, $r5 	#Opcode-lvx_v1-SBMM8D_registerW_registerZ_registerY_simple
	;;
	sbmm8d $r4r5.hi = $r4r5r6r7.y, -64 	#Opcode-lvx_v1-SBMM8D_registerW_registerZ_signed10_simple
	;;
	sbmm8d $r6 = $r6r7.lo, -8589934592 	#Opcode-lvx_v1-SBMM8D_registerW_registerZ_upper27_lower10_double
	;;
	sbmm8eord $r4r5r6r7.z = $r7, $r6r7.hi 	#Opcode-lvx_v1-SBMM8EORD_registerW_registerZ_registerY_simple
	;;
	sbmm8eord $r4r5r6r7.t = $r8, 536870911 	#Opcode-lvx_v1-SBMM8EORD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	sbmm8 $r8r9.lo = $r8r9r10r11.x, 2305843009213693951 	#Opcode-lvx_v1-SBMM8_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbmm8 $r9 = $r8r9.hi, $r8r9r10r11.y 	#Opcode-lvx_v1-SBMM8_registerW_registerZ_registerY_simple
	;;
	sbmm8 $r10 = $r10r11.lo, -64 	#Opcode-lvx_v1-SBMM8_registerW_registerZ_signed10_simple
	;;
	sbmm8 $r8r9r10r11.z = $r11, -8589934592 	#Opcode-lvx_v1-SBMM8_registerW_registerZ_upper27_lower10_double
	;;
	sbmmt8d $r10r11.hi = $r8r9r10r11.t, 2305843009213693951 	#Opcode-lvx_v1-SBMMT8D_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbmmt8d $r12 = $sp, $r13 	#Opcode-lvx_v1-SBMMT8D_registerW_registerZ_registerY_simple
	;;
	sbmmt8d $tp = $r14, -64 	#Opcode-lvx_v1-SBMMT8D_registerW_registerZ_signed10_simple
	;;
	sbmmt8d $fp = $r14r15.lo, -8589934592 	#Opcode-lvx_v1-SBMMT8D_registerW_registerZ_upper27_lower10_double
	;;
	sbmmt8eord $r15 = $rp, $r14r15.hi 	#Opcode-lvx_v1-SBMMT8EORD_registerW_registerZ_registerY_simple
	;;
	sbmmt8eord $r16 = $r16r17.lo, 536870911.@ 	#Opcode-lvx_v1-SBMMT8EORD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	sbmmt8 $r16r17r18r19.x = $r17, 2305843009213693951 	#Opcode-lvx_v1-SBMMT8_registerW_registerZ_extend27_upper27_lower10_triple
	;;
	sbmmt8 $r16r17.hi = $r16r17r18r19.y, $r18 	#Opcode-lvx_v1-SBMMT8_registerW_registerZ_registerY_simple
	;;
	sbmmt8 $r18r19.lo = $r16r17r18r19.z, -64 	#Opcode-lvx_v1-SBMMT8_registerW_registerZ_signed10_simple
	;;
	sbmmt8 $r19 = $r18r19.hi, -8589934592 	#Opcode-lvx_v1-SBMMT8_registerW_registerZ_upper27_lower10_double
	;;
	sb 2305843009213693951[$r16r17r18r19.t] = $r20 	#Opcode-lvx_v1-SB_extend27_upper27_lower10_registerZ_registerT_triple
	;;
	sb $r20r21.lo[$r20r21r22r23.x] = $r21 	#Opcode-lvx_v1-SB_registerY_registerZ_registerT_simple
	;;
	sb -64[$r20r21.hi] = $r20r21r22r23.y 	#Opcode-lvx_v1-SB_signed10_registerZ_registerT_simple
	;;
	sb -8589934592[$r22] = $r22r23.lo 	#Opcode-lvx_v1-SB_upper27_lower10_registerZ_registerT_double
	;;
	scall $r20r21r22r23.z 	#Opcode-lvx_v1-SCALL_registerZ_simple
	;;
	scall 511 	#Opcode-lvx_v1-SCALL_sysnumber_simple
	;;
	sd 2305843009213693951[$r23] = $r22r23.hi 	#Opcode-lvx_v1-SD_extend27_upper27_lower10_registerZ_registerT_triple
	;;
	sd $r20r21r22r23.t[$r24] = $r24r25.lo 	#Opcode-lvx_v1-SD_registerY_registerZ_registerT_simple
	;;
	sd -64[$r24r25r26r27.x] = $r25 	#Opcode-lvx_v1-SD_signed10_registerZ_registerT_simple
	;;
	sd -8589934592[$r24r25.hi] = $r24r25r26r27.y 	#Opcode-lvx_v1-SD_upper27_lower10_registerZ_registerT_double
	;;
	set $s28 = $r26 	#Opcode-lvx_v1-SET_systemAlone_registerZ_simple
	;;
	set $ra = $r26r27.lo 	#Opcode-lvx_v1-SET_systemRA_registerZ_simple
	;;
	set $ps = $r24r25r26r27.z 	#Opcode-lvx_v1-SET_systemT3_registerZ_simple
	;;
	set $ps = $r27 	#Opcode-lvx_v1-SET_systemT4_registerZ_simple
	;;
	sh 2305843009213693951[$r26r27.hi] = $r24r25r26r27.t 	#Opcode-lvx_v1-SH_extend27_upper27_lower10_registerZ_registerT_triple
	;;
	sh $r28[$r28r29.lo] = $r28r29r30r31.x 	#Opcode-lvx_v1-SH_registerY_registerZ_registerT_simple
	;;
	sh -64[$r29] = $r28r29.hi 	#Opcode-lvx_v1-SH_signed10_registerZ_registerT_simple
	;;
	sh -8589934592[$r28r29r30r31.y] = $r30 	#Opcode-lvx_v1-SH_upper27_lower10_registerZ_registerT_double
	;;
	signbo $r0r1r2r3.x = $r2, $r2r3.lo 	#Opcode-lvx_v1-SIGNBO_registerWe_registerZe_registerYe_simple
	;;
	signbo $r0r1r2r3.z = $r4, 536870911 	#Opcode-lvx_v1-SIGNBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	signbo $r0r1r2r3.y = $r3, $r2r3.hi 	#Opcode-lvx_v1-SIGNBO_registerWo_registerZo_registerYo_simple
	;;
	signbo $r0r1r2r3.t = $r5, 536870911.@ 	#Opcode-lvx_v1-SIGNBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	signd $r30r31.lo = $r28r29r30r31.z, $r31 	#Opcode-lvx_v1-SIGND_registerW_registerZ_registerY_simple
	;;
	signd $r30r31.hi = $r28r29r30r31.t, 536870911 	#Opcode-lvx_v1-SIGND_registerW_registerZ_upper27_lower5_splat32_double
	;;
	signhq $r4r5.lo = $r4r5r6r7.x, $r6 	#Opcode-lvx_v1-SIGNHQ_registerWe_registerZe_registerYe_simple
	;;
	signhq $r6r7.lo = $r4r5r6r7.z, 536870911.@ 	#Opcode-lvx_v1-SIGNHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	signhq $r4r5.hi = $r4r5r6r7.y, $r7 	#Opcode-lvx_v1-SIGNHQ_registerWo_registerZo_registerYo_simple
	;;
	signhq $r6r7.hi = $r4r5r6r7.t, 536870911 	#Opcode-lvx_v1-SIGNHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	signsbo $r8 = $r8r9.lo, $r8r9r10r11.x 	#Opcode-lvx_v1-SIGNSBO_registerWe_registerZe_registerYe_simple
	;;
	signsbo $r10 = $r10r11.lo, 536870911.@ 	#Opcode-lvx_v1-SIGNSBO_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	signsbo $r9 = $r8r9.hi, $r8r9r10r11.y 	#Opcode-lvx_v1-SIGNSBO_registerWo_registerZo_registerYo_simple
	;;
	signsbo $r11 = $r10r11.hi, 536870911 	#Opcode-lvx_v1-SIGNSBO_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	signsd $r32 = $r32r33.lo, $r32r33r34r35.x 	#Opcode-lvx_v1-SIGNSD_registerW_registerZ_registerY_simple
	;;
	signsd $r33 = $r32r33.hi, 536870911.@ 	#Opcode-lvx_v1-SIGNSD_registerW_registerZ_upper27_lower5_splat32_double
	;;
	signshq $r8r9r10r11.z = $r12, $sp 	#Opcode-lvx_v1-SIGNSHQ_registerWe_registerZe_registerYe_simple
	;;
	signshq $r14 = $fp, 536870911 	#Opcode-lvx_v1-SIGNSHQ_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	signshq $r8r9r10r11.t = $r13, $tp 	#Opcode-lvx_v1-SIGNSHQ_registerWo_registerZo_registerYo_simple
	;;
	signshq $r15 = $rp, 536870911.@ 	#Opcode-lvx_v1-SIGNSHQ_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	signswp $r14r15.lo = $r16, $r16r17.lo 	#Opcode-lvx_v1-SIGNSWP_registerWe_registerZe_registerYe_simple
	;;
	signswp $r16r17r18r19.x = $r18, 536870911 	#Opcode-lvx_v1-SIGNSWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	signswp $r14r15.hi = $r17, $r16r17.hi 	#Opcode-lvx_v1-SIGNSWP_registerWo_registerZo_registerYo_simple
	;;
	signswp $r16r17r18r19.y = $r19, 536870911.@ 	#Opcode-lvx_v1-SIGNSWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	signsw.sx $r32r33r34r35.y = $r34, $r34r35.lo 	#Opcode-lvx_v1-SIGNSW_signextw_registerW_registerZ_registerY_simple
	;;
	signsw $r32r33r34r35.z = $r35, 536870911 	#Opcode-lvx_v1-SIGNSW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	signwp $r18r19.lo = $r16r17r18r19.z, $r20 	#Opcode-lvx_v1-SIGNWP_registerWe_registerZe_registerYe_simple
	;;
	signwp $r20r21.lo = $r20r21r22r23.x, 536870911 	#Opcode-lvx_v1-SIGNWP_registerWe_registerZe_upper27_lower5_splat32_double
	;;
	signwp $r18r19.hi = $r16r17r18r19.t, $r21 	#Opcode-lvx_v1-SIGNWP_registerWo_registerZo_registerYo_simple
	;;
	signwp $r20r21.hi = $r20r21r22r23.y, 536870911.@ 	#Opcode-lvx_v1-SIGNWP_registerWo_registerZo_upper27_lower5_splat32_double
	;;
	signw.sx $r34r35.hi = $r32r33r34r35.t, $r36 	#Opcode-lvx_v1-SIGNW_signextw_registerW_registerZ_registerY_simple
	;;
	signw $r36r37.lo = $r36r37r38r39.x, 536870911 	#Opcode-lvx_v1-SIGNW_signextw_registerW_registerZ_upper27_lower5_double
	;;
	sleep 	#Opcode-lvx_v1-SLEEP_simple
	;;
	sllbo $r22 = $r22r23.lo, $r37 	#Opcode-lvx_v1-SLLBO_registerWe_registerZe_registerY_simple
	;;
	sllbo $r20r21r22r23.z = $r24, 7 	#Opcode-lvx_v1-SLLBO_registerWe_registerZe_unsigned6_simple
	;;
	sllbo $r23 = $r22r23.hi, $r36r37.hi 	#Opcode-lvx_v1-SLLBO_registerWo_registerZo_registerY_simple
	;;
	sllbo $r20r21r22r23.t = $r25, 7 	#Opcode-lvx_v1-SLLBO_registerWo_registerZo_unsigned6_simple
	;;
	slld $r36r37r38r39.y = $r38, $r38r39.lo 	#Opcode-lvx_v1-SLLD_registerW_registerZ_registerY_simple
	;;
	slld $r36r37r38r39.z = $r39, 7 	#Opcode-lvx_v1-SLLD_registerW_registerZ_unsigned6_simple
	;;
	sllhq $r24r25.lo = $r24r25r26r27.x, $r38r39.hi 	#Opcode-lvx_v1-SLLHQ_registerWe_registerZe_registerY_simple
	;;
	sllhq $r26 = $r26r27.lo, 7 	#Opcode-lvx_v1-SLLHQ_registerWe_registerZe_unsigned6_simple
	;;
	sllhq $r24r25.hi = $r24r25r26r27.y, $r36r37r38r39.t 	#Opcode-lvx_v1-SLLHQ_registerWo_registerZo_registerY_simple
	;;
	sllhq $r27 = $r26r27.hi, 7 	#Opcode-lvx_v1-SLLHQ_registerWo_registerZo_unsigned6_simple
	;;
	sllwp $r24r25r26r27.z = $r28, $r40 	#Opcode-lvx_v1-SLLWP_registerWe_registerZe_registerY_simple
	;;
	sllwp $r28r29.lo = $r28r29r30r31.x, 7 	#Opcode-lvx_v1-SLLWP_registerWe_registerZe_unsigned6_simple
	;;
	sllwp $r24r25r26r27.t = $r29, $r40r41.lo 	#Opcode-lvx_v1-SLLWP_registerWo_registerZo_registerY_simple
	;;
	sllwp $r28r29.hi = $r28r29r30r31.y, 7 	#Opcode-lvx_v1-SLLWP_registerWo_registerZo_unsigned6_simple
	;;
	sllw.sx $r40r41r42r43.x = $r41, $r40r41.hi 	#Opcode-lvx_v1-SLLW_signextw_registerW_registerZ_registerY_simple
	;;
	sllw $r40r41r42r43.y = $r42, 7 	#Opcode-lvx_v1-SLLW_signextw_registerW_registerZ_unsigned6_simple
	;;
	slsbo $r30 = $r30r31.lo, $r42r43.lo 	#Opcode-lvx_v1-SLSBO_registerWe_registerZe_registerY_simple
	;;
	slsbo $r28r29r30r31.z = $r32, 7 	#Opcode-lvx_v1-SLSBO_registerWe_registerZe_unsigned6_simple
	;;
	slsbo $r31 = $r30r31.hi, $r40r41r42r43.z 	#Opcode-lvx_v1-SLSBO_registerWo_registerZo_registerY_simple
	;;
	slsbo $r28r29r30r31.t = $r33, 7 	#Opcode-lvx_v1-SLSBO_registerWo_registerZo_unsigned6_simple
	;;
	slsd $r43 = $r42r43.hi, $r40r41r42r43.t 	#Opcode-lvx_v1-SLSD_registerW_registerZ_registerY_simple
	;;
	slsd $r44 = $r44r45.lo, 7 	#Opcode-lvx_v1-SLSD_registerW_registerZ_unsigned6_simple
	;;
	slshq $r32r33.lo = $r32r33r34r35.x, $r44r45r46r47.x 	#Opcode-lvx_v1-SLSHQ_registerWe_registerZe_registerY_simple
	;;
	slshq $r34 = $r34r35.lo, 7 	#Opcode-lvx_v1-SLSHQ_registerWe_registerZe_unsigned6_simple
	;;
	slshq $r32r33.hi = $r32r33r34r35.y, $r45 	#Opcode-lvx_v1-SLSHQ_registerWo_registerZo_registerY_simple
	;;
	slshq $r35 = $r34r35.hi, 7 	#Opcode-lvx_v1-SLSHQ_registerWo_registerZo_unsigned6_simple
	;;
	slswp $r32r33r34r35.z = $r36, $r44r45.hi 	#Opcode-lvx_v1-SLSWP_registerWe_registerZe_registerY_simple
	;;
	slswp $r36r37.lo = $r36r37r38r39.x, 7 	#Opcode-lvx_v1-SLSWP_registerWe_registerZe_unsigned6_simple
	;;
	slswp $r32r33r34r35.t = $r37, $r44r45r46r47.y 	#Opcode-lvx_v1-SLSWP_registerWo_registerZo_registerY_simple
	;;
	slswp $r36r37.hi = $r36r37r38r39.y, 7 	#Opcode-lvx_v1-SLSWP_registerWo_registerZo_unsigned6_simple
	;;
	slsw.sx $r46 = $r46r47.lo, $r44r45r46r47.z 	#Opcode-lvx_v1-SLSW_signextw_registerW_registerZ_registerY_simple
	;;
	slsw $r47 = $r46r47.hi, 7 	#Opcode-lvx_v1-SLSW_signextw_registerW_registerZ_unsigned6_simple
	;;
	slusbo $r38 = $r38r39.lo, $r44r45r46r47.t 	#Opcode-lvx_v1-SLUSBO_registerWe_registerZe_registerY_simple
	;;
	slusbo $r36r37r38r39.z = $r40, 7 	#Opcode-lvx_v1-SLUSBO_registerWe_registerZe_unsigned6_simple
	;;
	slusbo $r39 = $r38r39.hi, $r48 	#Opcode-lvx_v1-SLUSBO_registerWo_registerZo_registerY_simple
	;;
	slusbo $r36r37r38r39.t = $r41, 7 	#Opcode-lvx_v1-SLUSBO_registerWo_registerZo_unsigned6_simple
	;;
	slusd $r48r49.lo = $r48r49r50r51.x, $r49 	#Opcode-lvx_v1-SLUSD_registerW_registerZ_registerY_simple
	;;
	slusd $r48r49.hi = $r48r49r50r51.y, 7 	#Opcode-lvx_v1-SLUSD_registerW_registerZ_unsigned6_simple
	;;
	slushq $r40r41.lo = $r40r41r42r43.x, $r50 	#Opcode-lvx_v1-SLUSHQ_registerWe_registerZe_registerY_simple
	;;
	slushq $r42 = $r42r43.lo, 7 	#Opcode-lvx_v1-SLUSHQ_registerWe_registerZe_unsigned6_simple
	;;
	slushq $r40r41.hi = $r40r41r42r43.y, $r50r51.lo 	#Opcode-lvx_v1-SLUSHQ_registerWo_registerZo_registerY_simple
	;;
	slushq $r43 = $r42r43.hi, 7 	#Opcode-lvx_v1-SLUSHQ_registerWo_registerZo_unsigned6_simple
	;;
	sluswp $r40r41r42r43.z = $r44, $r48r49r50r51.z 	#Opcode-lvx_v1-SLUSWP_registerWe_registerZe_registerY_simple
	;;
	sluswp $r44r45.lo = $r44r45r46r47.x, 7 	#Opcode-lvx_v1-SLUSWP_registerWe_registerZe_unsigned6_simple
	;;
	sluswp $r40r41r42r43.t = $r45, $r51 	#Opcode-lvx_v1-SLUSWP_registerWo_registerZo_registerY_simple
	;;
	sluswp $r44r45.hi = $r44r45r46r47.y, 7 	#Opcode-lvx_v1-SLUSWP_registerWo_registerZo_unsigned6_simple
	;;
	slusw.sx $r50r51.hi = $r48r49r50r51.t, $r52 	#Opcode-lvx_v1-SLUSW_signextw_registerW_registerZ_registerY_simple
	;;
	slusw $r52r53.lo = $r52r53r54r55.x, 7 	#Opcode-lvx_v1-SLUSW_signextw_registerW_registerZ_unsigned6_simple
	;;
	so 2305843009213693951[$r53] = $r36r37r38r39 	#Opcode-lvx_v1-SO_extend27_upper27_lower10_registerZ_registerV_triple
	;;
	so $r52r53.hi[$r52r53r54r55.y] = $r40r41r42r43 	#Opcode-lvx_v1-SO_registerY_registerZ_registerV_simple
	;;
	so -64[$r54] = $r44r45r46r47 	#Opcode-lvx_v1-SO_signed10_registerZ_registerV_simple
	;;
	so -8589934592[$r54r55.lo] = $r48r49r50r51 	#Opcode-lvx_v1-SO_upper27_lower10_registerZ_registerV_double
	;;
	sq 2305843009213693951[$r52r53r54r55.z] = $r62r63 	#Opcode-lvx_v1-SQ_extend27_upper27_lower10_registerZ_registerU_triple
	;;
	sq $r55[$r54r55.hi] = $r60r61r62r63.hi 	#Opcode-lvx_v1-SQ_registerY_registerZ_registerU_simple
	;;
	sq -64[$r52r53r54r55.t] = $r0r1 	#Opcode-lvx_v1-SQ_signed10_registerZ_registerU_simple
	;;
	sq -8589934592[$r56] = $r0r1r2r3.lo 	#Opcode-lvx_v1-SQ_upper27_lower10_registerZ_registerU_double
	;;
	srabo $r46 = $r46r47.lo, $r56r57.lo 	#Opcode-lvx_v1-SRABO_registerWe_registerZe_registerY_simple
	;;
	srabo $r44r45r46r47.z = $r48, 7 	#Opcode-lvx_v1-SRABO_registerWe_registerZe_unsigned6_simple
	;;
	srabo $r47 = $r46r47.hi, $r56r57r58r59.x 	#Opcode-lvx_v1-SRABO_registerWo_registerZo_registerY_simple
	;;
	srabo $r44r45r46r47.t = $r49, 7 	#Opcode-lvx_v1-SRABO_registerWo_registerZo_unsigned6_simple
	;;
	srad $r57 = $r56r57.hi, $r56r57r58r59.y 	#Opcode-lvx_v1-SRAD_registerW_registerZ_registerY_simple
	;;
	srad $r58 = $r58r59.lo, 7 	#Opcode-lvx_v1-SRAD_registerW_registerZ_unsigned6_simple
	;;
	srahq $r48r49.lo = $r48r49r50r51.x, $r56r57r58r59.z 	#Opcode-lvx_v1-SRAHQ_registerWe_registerZe_registerY_simple
	;;
	srahq $r50 = $r50r51.lo, 7 	#Opcode-lvx_v1-SRAHQ_registerWe_registerZe_unsigned6_simple
	;;
	srahq $r48r49.hi = $r48r49r50r51.y, $r59 	#Opcode-lvx_v1-SRAHQ_registerWo_registerZo_registerY_simple
	;;
	srahq $r51 = $r50r51.hi, 7 	#Opcode-lvx_v1-SRAHQ_registerWo_registerZo_unsigned6_simple
	;;
	srawp $r48r49r50r51.z = $r52, $r58r59.hi 	#Opcode-lvx_v1-SRAWP_registerWe_registerZe_registerY_simple
	;;
	srawp $r52r53.lo = $r52r53r54r55.x, 7 	#Opcode-lvx_v1-SRAWP_registerWe_registerZe_unsigned6_simple
	;;
	srawp $r48r49r50r51.t = $r53, $r56r57r58r59.t 	#Opcode-lvx_v1-SRAWP_registerWo_registerZo_registerY_simple
	;;
	srawp $r52r53.hi = $r52r53r54r55.y, 7 	#Opcode-lvx_v1-SRAWP_registerWo_registerZo_unsigned6_simple
	;;
	sraw.sx $r60 = $r60r61.lo, $r60r61r62r63.x 	#Opcode-lvx_v1-SRAW_signextw_registerW_registerZ_registerY_simple
	;;
	sraw $r61 = $r60r61.hi, 7 	#Opcode-lvx_v1-SRAW_signextw_registerW_registerZ_unsigned6_simple
	;;
	srlbo $r54 = $r54r55.lo, $r60r61r62r63.y 	#Opcode-lvx_v1-SRLBO_registerWe_registerZe_registerY_simple
	;;
	srlbo $r52r53r54r55.z = $r56, 7 	#Opcode-lvx_v1-SRLBO_registerWe_registerZe_unsigned6_simple
	;;
	srlbo $r55 = $r54r55.hi, $r62 	#Opcode-lvx_v1-SRLBO_registerWo_registerZo_registerY_simple
	;;
	srlbo $r52r53r54r55.t = $r57, 7 	#Opcode-lvx_v1-SRLBO_registerWo_registerZo_unsigned6_simple
	;;
	srld $r62r63.lo = $r60r61r62r63.z, $r63 	#Opcode-lvx_v1-SRLD_registerW_registerZ_registerY_simple
	;;
	srld $r62r63.hi = $r60r61r62r63.t, 7 	#Opcode-lvx_v1-SRLD_registerW_registerZ_unsigned6_simple
	;;
	srlhq $r56r57.lo = $r56r57r58r59.x, $r0 	#Opcode-lvx_v1-SRLHQ_registerWe_registerZe_registerY_simple
	;;
	srlhq $r58 = $r58r59.lo, 7 	#Opcode-lvx_v1-SRLHQ_registerWe_registerZe_unsigned6_simple
	;;
	srlhq $r56r57.hi = $r56r57r58r59.y, $r0r1.lo 	#Opcode-lvx_v1-SRLHQ_registerWo_registerZo_registerY_simple
	;;
	srlhq $r59 = $r58r59.hi, 7 	#Opcode-lvx_v1-SRLHQ_registerWo_registerZo_unsigned6_simple
	;;
	srlwp $r56r57r58r59.z = $r60, $r0r1r2r3.x 	#Opcode-lvx_v1-SRLWP_registerWe_registerZe_registerY_simple
	;;
	srlwp $r60r61.lo = $r60r61r62r63.x, 7 	#Opcode-lvx_v1-SRLWP_registerWe_registerZe_unsigned6_simple
	;;
	srlwp $r56r57r58r59.t = $r61, $r1 	#Opcode-lvx_v1-SRLWP_registerWo_registerZo_registerY_simple
	;;
	srlwp $r60r61.hi = $r60r61r62r63.y, 7 	#Opcode-lvx_v1-SRLWP_registerWo_registerZo_unsigned6_simple
	;;
	srlw.sx $r0r1.hi = $r0r1r2r3.y, $r2 	#Opcode-lvx_v1-SRLW_signextw_registerW_registerZ_registerY_simple
	;;
	srlw $r2r3.lo = $r0r1r2r3.z, 7 	#Opcode-lvx_v1-SRLW_signextw_registerW_registerZ_unsigned6_simple
	;;
	srsbo $r62 = $r62r63.lo, $r3 	#Opcode-lvx_v1-SRSBO_registerWe_registerZe_registerY_simple
	;;
	srsbo $r60r61r62r63.z = $r0, 7 	#Opcode-lvx_v1-SRSBO_registerWe_registerZe_unsigned6_simple
	;;
	srsbo $r63 = $r62r63.hi, $r2r3.hi 	#Opcode-lvx_v1-SRSBO_registerWo_registerZo_registerY_simple
	;;
	srsbo $r60r61r62r63.t = $r1, 7 	#Opcode-lvx_v1-SRSBO_registerWo_registerZo_unsigned6_simple
	;;
	srsd $r0r1r2r3.t = $r4, $r4r5.lo 	#Opcode-lvx_v1-SRSD_registerW_registerZ_registerY_simple
	;;
	srsd $r4r5r6r7.x = $r5, 7 	#Opcode-lvx_v1-SRSD_registerW_registerZ_unsigned6_simple
	;;
	srshq $r0r1.lo = $r0r1r2r3.x, $r4r5.hi 	#Opcode-lvx_v1-SRSHQ_registerWe_registerZe_registerY_simple
	;;
	srshq $r2 = $r2r3.lo, 7 	#Opcode-lvx_v1-SRSHQ_registerWe_registerZe_unsigned6_simple
	;;
	srshq $r0r1.hi = $r0r1r2r3.y, $r4r5r6r7.y 	#Opcode-lvx_v1-SRSHQ_registerWo_registerZo_registerY_simple
	;;
	srshq $r3 = $r2r3.hi, 7 	#Opcode-lvx_v1-SRSHQ_registerWo_registerZo_unsigned6_simple
	;;
	srswp $r0r1r2r3.z = $r4, $r6 	#Opcode-lvx_v1-SRSWP_registerWe_registerZe_registerY_simple
	;;
	srswp $r4r5.lo = $r4r5r6r7.x, 7 	#Opcode-lvx_v1-SRSWP_registerWe_registerZe_unsigned6_simple
	;;
	srswp $r0r1r2r3.t = $r5, $r6r7.lo 	#Opcode-lvx_v1-SRSWP_registerWo_registerZo_registerY_simple
	;;
	srswp $r4r5.hi = $r4r5r6r7.y, 7 	#Opcode-lvx_v1-SRSWP_registerWo_registerZo_unsigned6_simple
	;;
	srsw.sx $r4r5r6r7.z = $r7, $r6r7.hi 	#Opcode-lvx_v1-SRSW_signextw_registerW_registerZ_registerY_simple
	;;
	srsw $r4r5r6r7.t = $r8, 7 	#Opcode-lvx_v1-SRSW_signextw_registerW_registerZ_unsigned6_simple
	;;
	stop 	#Opcode-lvx_v1-STOP_simple
	;;
	stsud $r8r9.lo = $r8r9r10r11.x, $r9 	#Opcode-lvx_v1-STSUD_registerW_registerZ_registerY_simple
	;;
	stsuhq $r6 = $r6r7.lo, $r4r5r6r7.z 	#Opcode-lvx_v1-STSUHQ_registerWe_registerZe_registerYe_simple
	;;
	stsuhq $r7 = $r6r7.hi, $r4r5r6r7.t 	#Opcode-lvx_v1-STSUHQ_registerWo_registerZo_registerYo_simple
	;;
	stsuwp $r8 = $r8r9.lo, $r8r9r10r11.x 	#Opcode-lvx_v1-STSUWP_registerWe_registerZe_registerYe_simple
	;;
	stsuwp $r9 = $r8r9.hi, $r8r9r10r11.y 	#Opcode-lvx_v1-STSUWP_registerWo_registerZo_registerYo_simple
	;;
	stsuw.sx $r8r9.hi = $r8r9r10r11.y, $r10 	#Opcode-lvx_v1-STSUW_signextw_registerW_registerZ_registerY_simple
	;;
	sw 2305843009213693951[$r10r11.lo] = $r8r9r10r11.z 	#Opcode-lvx_v1-SW_extend27_upper27_lower10_registerZ_registerT_triple
	;;
	sw $r11[$r10r11.hi] = $r8r9r10r11.t 	#Opcode-lvx_v1-SW_registerY_registerZ_registerT_simple
	;;
	sw -64[$r12] = $sp 	#Opcode-lvx_v1-SW_signed10_registerZ_registerT_simple
	;;
	sw -8589934592[$r13] = $tp 	#Opcode-lvx_v1-SW_upper27_lower10_registerZ_registerT_double
	;;
	sxbd $r14 = $fp 	#Opcode-lvx_v1-SXBD_registerW_registerZ_simple
	;;
	sxhd $r14r15.lo = $r15 	#Opcode-lvx_v1-SXHD_registerW_registerZ_simple
	;;
	sxwd $rp = $r14r15.hi 	#Opcode-lvx_v1-SXWD_registerW_registerZ_simple
	;;
	syncgroup $r16 	#Opcode-lvx_v1-SYNCGROUP_registerZ_simple
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
	truncdwp $r16r17.lo = $r2r3 	#Opcode-lvx_v1-TRUNCDWP_registerW_registerP_simple
	;;
	trunchbo.z $r16r17r18r19.x = $r0r1r2r3.hi 	#Opcode-lvx_v1-TRUNCHBO_ziplanes_registerW_registerP_simple
	;;
	truncwhq $r17 = $r4r5 	#Opcode-lvx_v1-TRUNCWHQ_ziplanes_registerW_registerP_simple
	;;
	waitit $r16r17.hi 	#Opcode-lvx_v1-WAITIT_registerZ_simple
	;;
	wfxl $ps, $r16r17r18r19.y 	#Opcode-lvx_v1-WFXL_systemAlone_registerZ_simple
	;;
	wfxl $pcr, $r18 	#Opcode-lvx_v1-WFXL_systemT2_registerZ_simple
	;;
	wfxl $s1, $r18r19.lo 	#Opcode-lvx_v1-WFXL_systemT4_registerZ_simple
	;;
	wfxm $s1, $r16r17r18r19.z 	#Opcode-lvx_v1-WFXM_systemAlone_registerZ_simple
	;;
	wfxm $s2, $r19 	#Opcode-lvx_v1-WFXM_systemT2_registerZ_simple
	;;
	wfxm $pcr, $r18r19.hi 	#Opcode-lvx_v1-WFXM_systemT4_registerZ_simple
	;;
	widenqbho.m $r4r5r6r7.lo = $r6r7 	#Opcode-lvx_v1-WIDENQBHO_mostsig_registerM_registerP_simple
	;;
	widenqhwq $r4r5r6r7.hi = $r8r9 	#Opcode-lvx_v1-WIDENQHWQ_mostsig_registerM_registerP_simple
	;;
	widenqwdp.m $r8r9r10r11.lo = $r10r11 	#Opcode-lvx_v1-WIDENQWDP_mostsig_registerM_registerP_simple
	;;
	widensbho $r8r9r10r11.hi = $r12r13 	#Opcode-lvx_v1-WIDENSBHO_mostsig_registerM_registerP_simple
	;;
	widenshwq.m $r12r13r14r15.lo = $r14r15 	#Opcode-lvx_v1-WIDENSHWQ_mostsig_registerM_registerP_simple
	;;
	widenswdp $r12r13r14r15.hi = $r16r17 	#Opcode-lvx_v1-WIDENSWDP_mostsig_registerM_registerP_simple
	;;
	widenzbho.m $r16r17r18r19.lo = $r18r19 	#Opcode-lvx_v1-WIDENZBHO_mostsig_registerM_registerP_simple
	;;
	widenzhwq $r16r17r18r19.hi = $r20r21 	#Opcode-lvx_v1-WIDENZHWQ_mostsig_registerM_registerP_simple
	;;
	widenzwdp.m $r20r21r22r23.lo = $r22r23 	#Opcode-lvx_v1-WIDENZWDP_mostsig_registerM_registerP_simple
	;;
	xaccesso $r52r53r54r55 = $a0..a1, $r16r17r18r19.t 	#Opcode-lvx_v1-XACCESSO_registerN_registerCg_registerZ_simple
	;;
	xaccesso $r56r57r58r59 = $a0..a3, $r20 	#Opcode-lvx_v1-XACCESSO_registerN_registerCh_registerZ_simple
	;;
	xaccesso $r60r61r62r63 = $a0..a7, $r20r21.lo 	#Opcode-lvx_v1-XACCESSO_registerN_registerCi_registerZ_simple
	;;
	xaccesso $r0r1r2r3 = $a0..a15, $r20r21r22r23.x 	#Opcode-lvx_v1-XACCESSO_registerN_registerCj_registerZ_simple
	;;
	xaccesso $r4r5r6r7 = $a0..a31, $r21 	#Opcode-lvx_v1-XACCESSO_registerN_registerCk_registerZ_simple
	;;
	xaccesso $r8r9r10r11 = $a0..a63, $r20r21.hi 	#Opcode-lvx_v1-XACCESSO_registerN_registerCl_registerZ_simple
	;;
	xaligno $a0 = $a2..a3, $r20r21r22r23.y 	#Opcode-lvx_v1-XALIGNO_registerA_registerCg_registerZ_simple
	;;
	xaligno $a0a1.lo = $a4..a7, $r22 	#Opcode-lvx_v1-XALIGNO_registerA_registerCh_registerZ_simple
	;;
	xaligno $a0a1a2a3.x = $a8..a15, $r22r23.lo 	#Opcode-lvx_v1-XALIGNO_registerA_registerCi_registerZ_simple
	;;
	xaligno $a1 = $a16..a31, $r20r21r22r23.z 	#Opcode-lvx_v1-XALIGNO_registerA_registerCj_registerZ_simple
	;;
	xaligno $a0a1.hi = $a32..a63, $r23 	#Opcode-lvx_v1-XALIGNO_registerA_registerCk_registerZ_simple
	;;
	xaligno $a0a1a2a3.y = $a0..a63, $r22r23.hi 	#Opcode-lvx_v1-XALIGNO_registerA_registerCl_registerZ_simple
	;;
	xcopyo $a2 = $a2a3.lo 	#Opcode-lvx_v1-XCOPYO_registerA_registerC_simple
	;;
	xlo.q0 $a0a1a2a3 = 2305843009213693951[$r20r21r22r23.t] 	#Opcode-lvx_v1-XLO_variant_qindex_registerGq_extend27_upper27_lower10_registerZ_triple
	;;
	xlo.s.q1 $a4a5a6a7 = $r24[$r24r25.lo] 	#Opcode-lvx_v1-XLO_variant_qindex_registerGq_registerY_registerZ_simple
	;;
	xlo.u.q2 $a8a9a10a11 = -64[$r24r25r26r27.x] 	#Opcode-lvx_v1-XLO_variant_qindex_registerGq_signed10_registerZ_simple
	;;
	xlo.us.q3 $a12a13a14a15 = -8589934592[$r25] 	#Opcode-lvx_v1-XLO_variant_qindex_registerGq_upper27_lower10_registerZ_double
	;;
	xlo $a0a1a2a3.z = 2305843009213693951[$r24r25.hi] 	#Opcode-lvx_v1-XLO_variant_registerG_extend27_upper27_lower10_registerZ_triple
	;;
	xlo.s $a3 = $r24r25r26r27.y[$r26] 	#Opcode-lvx_v1-XLO_variant_registerG_registerY_registerZ_simple
	;;
	xlo.u $a2a3.hi = -64[$r26r27.lo] 	#Opcode-lvx_v1-XLO_variant_registerG_signed10_registerZ_simple
	;;
	xlo.us $a0a1a2a3.t = -8589934592[$r24r25r26r27.z] 	#Opcode-lvx_v1-XLO_variant_registerG_upper27_lower10_registerZ_double
	;;
	xmovefd $r27 = $a0_x 	#Opcode-lvx_v1-XMOVEFD_registerW_registerCc_qselectC_simple
	;;
	xmovefo $r12r13r14r15 = $a4 	#Opcode-lvx_v1-XMOVEFO_registerN_registerC_simple
	;;
	xmovefq $r20r21r22r23.hi = $a0_lo 	#Opcode-lvx_v1-XMOVEFQ_registerM_registerCb_hselectC_simple
	;;
	xmovetd $a0_t = $r26r27.hi 	#Opcode-lvx_v1-XMOVETD_registerAt_registerZ_simple
	;;
	xmovetd $a0_x = $r24r25r26r27.t 	#Opcode-lvx_v1-XMOVETD_registerAx_registerZ_simple
	;;
	xmovetd $a0_y = $r28 	#Opcode-lvx_v1-XMOVETD_registerAy_registerZ_simple
	;;
	xmovetd $a0_z = $r28r29.lo 	#Opcode-lvx_v1-XMOVETD_registerAz_registerZ_simple
	;;
	xmoveto $a4a5.lo = $r24r25, $r24r25r26r27.lo 	#Opcode-lvx_v1-XMOVETO_registerA_registerP_registerO_simple
	;;
	xmovetq $a0_lo = $r28r29r30r31.x, $r29 	#Opcode-lvx_v1-XMOVETQ_registerAE_registerZ_registerY_simple
	;;
	xmovetq $a0_hi = $r28r29.hi, $r28r29r30r31.y 	#Opcode-lvx_v1-XMOVETQ_registerAO_registerZ_registerY_simple
	;;
	xplb $a4..a5, $r30 = -1125899906842624[$r30r31.lo] 	#Opcode-lvx_v1-XPLB_variant_registerGg_registerY_extend27_offset27_registerZ_triple
	;;
	xplb.s $a6..a7, $r28r29r30r31.z = -8388608[$r31] 	#Opcode-lvx_v1-XPLB_variant_registerGg_registerY_offset27_registerZ_double
	;;
	xplb.u $a8..a9, $r30r31.hi = [$r28r29r30r31.t] 	#Opcode-lvx_v1-XPLB_variant_registerGg_registerY_registerZ_simple
	;;
	xplb.us $a8..a11, $r32 = -1125899906842624[$r32r33.lo] 	#Opcode-lvx_v1-XPLB_variant_registerGh_registerY_extend27_offset27_registerZ_triple
	;;
	xplb $a12..a15, $r32r33r34r35.x = -8388608[$r33] 	#Opcode-lvx_v1-XPLB_variant_registerGh_registerY_offset27_registerZ_double
	;;
	xplb.s $a16..a19, $r32r33.hi = [$r32r33r34r35.y] 	#Opcode-lvx_v1-XPLB_variant_registerGh_registerY_registerZ_simple
	;;
	xplb.u $a16..a23, $r34 = -1125899906842624[$r34r35.lo] 	#Opcode-lvx_v1-XPLB_variant_registerGi_registerY_extend27_offset27_registerZ_triple
	;;
	xplb.us $a24..a31, $r32r33r34r35.z = -8388608[$r35] 	#Opcode-lvx_v1-XPLB_variant_registerGi_registerY_offset27_registerZ_double
	;;
	xplb $a32..a39, $r34r35.hi = [$r32r33r34r35.t] 	#Opcode-lvx_v1-XPLB_variant_registerGi_registerY_registerZ_simple
	;;
	xplb.s $a32..a47, $r36 = -1125899906842624[$r36r37.lo] 	#Opcode-lvx_v1-XPLB_variant_registerGj_registerY_extend27_offset27_registerZ_triple
	;;
	xplb.u $a48..a63, $r36r37r38r39.x = -8388608[$r37] 	#Opcode-lvx_v1-XPLB_variant_registerGj_registerY_offset27_registerZ_double
	;;
	xplb.us $a0..a15, $r36r37.hi = [$r36r37r38r39.y] 	#Opcode-lvx_v1-XPLB_variant_registerGj_registerY_registerZ_simple
	;;
	xplb $a0..a31, $r38 = -1125899906842624[$r38r39.lo] 	#Opcode-lvx_v1-XPLB_variant_registerGk_registerY_extend27_offset27_registerZ_triple
	;;
	xplb.s $a32..a63, $r36r37r38r39.z = -8388608[$r39] 	#Opcode-lvx_v1-XPLB_variant_registerGk_registerY_offset27_registerZ_double
	;;
	xplb.u $a0..a31, $r38r39.hi = [$r36r37r38r39.t] 	#Opcode-lvx_v1-XPLB_variant_registerGk_registerY_registerZ_simple
	;;
	xplb.us $a0..a63, $r40 = -1125899906842624[$r40r41.lo] 	#Opcode-lvx_v1-XPLB_variant_registerGl_registerY_extend27_offset27_registerZ_triple
	;;
	xplb $a0..a63, $r40r41r42r43.x = -8388608[$r41] 	#Opcode-lvx_v1-XPLB_variant_registerGl_registerY_offset27_registerZ_double
	;;
	xplb.s $a0..a63, $r40r41.hi = [$r40r41r42r43.y] 	#Opcode-lvx_v1-XPLB_variant_registerGl_registerY_registerZ_simple
	;;
	xpld.u $a10..a11, $r42 = -1125899906842624[$r42r43.lo] 	#Opcode-lvx_v1-XPLD_variant_registerGg_registerY_extend27_offset27_registerZ_triple
	;;
	xpld.us $a12..a13, $r40r41r42r43.z = -8388608[$r43] 	#Opcode-lvx_v1-XPLD_variant_registerGg_registerY_offset27_registerZ_double
	;;
	xpld $a14..a15, $r42r43.hi = [$r40r41r42r43.t] 	#Opcode-lvx_v1-XPLD_variant_registerGg_registerY_registerZ_simple
	;;
	xpld.s $a20..a23, $r44 = -1125899906842624[$r44r45.lo] 	#Opcode-lvx_v1-XPLD_variant_registerGh_registerY_extend27_offset27_registerZ_triple
	;;
	xpld.u $a24..a27, $r44r45r46r47.x = -8388608[$r45] 	#Opcode-lvx_v1-XPLD_variant_registerGh_registerY_offset27_registerZ_double
	;;
	xpld.us $a28..a31, $r44r45.hi = [$r44r45r46r47.y] 	#Opcode-lvx_v1-XPLD_variant_registerGh_registerY_registerZ_simple
	;;
	xpld $a40..a47, $r46 = -1125899906842624[$r46r47.lo] 	#Opcode-lvx_v1-XPLD_variant_registerGi_registerY_extend27_offset27_registerZ_triple
	;;
	xpld.s $a48..a55, $r44r45r46r47.z = -8388608[$r47] 	#Opcode-lvx_v1-XPLD_variant_registerGi_registerY_offset27_registerZ_double
	;;
	xpld.u $a56..a63, $r46r47.hi = [$r44r45r46r47.t] 	#Opcode-lvx_v1-XPLD_variant_registerGi_registerY_registerZ_simple
	;;
	xpld.us $a16..a31, $r48 = -1125899906842624[$r48r49.lo] 	#Opcode-lvx_v1-XPLD_variant_registerGj_registerY_extend27_offset27_registerZ_triple
	;;
	xpld $a32..a47, $r48r49r50r51.x = -8388608[$r49] 	#Opcode-lvx_v1-XPLD_variant_registerGj_registerY_offset27_registerZ_double
	;;
	xpld.s $a48..a63, $r48r49.hi = [$r48r49r50r51.y] 	#Opcode-lvx_v1-XPLD_variant_registerGj_registerY_registerZ_simple
	;;
	xpld.u $a32..a63, $r50 = -1125899906842624[$r50r51.lo] 	#Opcode-lvx_v1-XPLD_variant_registerGk_registerY_extend27_offset27_registerZ_triple
	;;
	xpld.us $a0..a31, $r48r49r50r51.z = -8388608[$r51] 	#Opcode-lvx_v1-XPLD_variant_registerGk_registerY_offset27_registerZ_double
	;;
	xpld $a32..a63, $r50r51.hi = [$r48r49r50r51.t] 	#Opcode-lvx_v1-XPLD_variant_registerGk_registerY_registerZ_simple
	;;
	xpld.s $a0..a63, $r52 = -1125899906842624[$r52r53.lo] 	#Opcode-lvx_v1-XPLD_variant_registerGl_registerY_extend27_offset27_registerZ_triple
	;;
	xpld.u $a0..a63, $r52r53r54r55.x = -8388608[$r53] 	#Opcode-lvx_v1-XPLD_variant_registerGl_registerY_offset27_registerZ_double
	;;
	xpld.us $a0..a63, $r52r53.hi = [$r52r53r54r55.y] 	#Opcode-lvx_v1-XPLD_variant_registerGl_registerY_registerZ_simple
	;;
	xplh $a16..a17, $r54 = -1125899906842624[$r54r55.lo] 	#Opcode-lvx_v1-XPLH_variant_registerGg_registerY_extend27_offset27_registerZ_triple
	;;
	xplh.s $a18..a19, $r52r53r54r55.z = -8388608[$r55] 	#Opcode-lvx_v1-XPLH_variant_registerGg_registerY_offset27_registerZ_double
	;;
	xplh.u $a20..a21, $r54r55.hi = [$r52r53r54r55.t] 	#Opcode-lvx_v1-XPLH_variant_registerGg_registerY_registerZ_simple
	;;
	xplh.us $a32..a35, $r56 = -1125899906842624[$r56r57.lo] 	#Opcode-lvx_v1-XPLH_variant_registerGh_registerY_extend27_offset27_registerZ_triple
	;;
	xplh $a36..a39, $r56r57r58r59.x = -8388608[$r57] 	#Opcode-lvx_v1-XPLH_variant_registerGh_registerY_offset27_registerZ_double
	;;
	xplh.s $a40..a43, $r56r57.hi = [$r56r57r58r59.y] 	#Opcode-lvx_v1-XPLH_variant_registerGh_registerY_registerZ_simple
	;;
	xplh.u $a0..a7, $r58 = -1125899906842624[$r58r59.lo] 	#Opcode-lvx_v1-XPLH_variant_registerGi_registerY_extend27_offset27_registerZ_triple
	;;
	xplh.us $a8..a15, $r56r57r58r59.z = -8388608[$r59] 	#Opcode-lvx_v1-XPLH_variant_registerGi_registerY_offset27_registerZ_double
	;;
	xplh $a16..a23, $r58r59.hi = [$r56r57r58r59.t] 	#Opcode-lvx_v1-XPLH_variant_registerGi_registerY_registerZ_simple
	;;
	xplh.s $a0..a15, $r60 = -1125899906842624[$r60r61.lo] 	#Opcode-lvx_v1-XPLH_variant_registerGj_registerY_extend27_offset27_registerZ_triple
	;;
	xplh.u $a16..a31, $r60r61r62r63.x = -8388608[$r61] 	#Opcode-lvx_v1-XPLH_variant_registerGj_registerY_offset27_registerZ_double
	;;
	xplh.us $a32..a47, $r60r61.hi = [$r60r61r62r63.y] 	#Opcode-lvx_v1-XPLH_variant_registerGj_registerY_registerZ_simple
	;;
	xplh $a0..a31, $r62 = -1125899906842624[$r62r63.lo] 	#Opcode-lvx_v1-XPLH_variant_registerGk_registerY_extend27_offset27_registerZ_triple
	;;
	xplh.s $a32..a63, $r60r61r62r63.z = -8388608[$r63] 	#Opcode-lvx_v1-XPLH_variant_registerGk_registerY_offset27_registerZ_double
	;;
	xplh.u $a0..a31, $r62r63.hi = [$r60r61r62r63.t] 	#Opcode-lvx_v1-XPLH_variant_registerGk_registerY_registerZ_simple
	;;
	xplh.us $a0..a63, $r0 = -1125899906842624[$r0r1.lo] 	#Opcode-lvx_v1-XPLH_variant_registerGl_registerY_extend27_offset27_registerZ_triple
	;;
	xplh $a0..a63, $r0r1r2r3.x = -8388608[$r1] 	#Opcode-lvx_v1-XPLH_variant_registerGl_registerY_offset27_registerZ_double
	;;
	xplh.s $a0..a63, $r0r1.hi = [$r0r1r2r3.y] 	#Opcode-lvx_v1-XPLH_variant_registerGl_registerY_registerZ_simple
	;;
	xplo.u $a22..a23, $r2 = -1125899906842624[$r2r3.lo] 	#Opcode-lvx_v1-XPLO_variant_registerGg_registerY_extend27_offset27_registerZ_triple
	;;
	xplo.us $a24..a25, $r0r1r2r3.z = -8388608[$r3] 	#Opcode-lvx_v1-XPLO_variant_registerGg_registerY_offset27_registerZ_double
	;;
	xplo $a26..a27, $r2r3.hi = [$r0r1r2r3.t] 	#Opcode-lvx_v1-XPLO_variant_registerGg_registerY_registerZ_simple
	;;
	xplo.s $a44..a47, $r4 = -1125899906842624[$r4r5.lo] 	#Opcode-lvx_v1-XPLO_variant_registerGh_registerY_extend27_offset27_registerZ_triple
	;;
	xplo.u $a48..a51, $r4r5r6r7.x = -8388608[$r5] 	#Opcode-lvx_v1-XPLO_variant_registerGh_registerY_offset27_registerZ_double
	;;
	xplo.us $a52..a55, $r4r5.hi = [$r4r5r6r7.y] 	#Opcode-lvx_v1-XPLO_variant_registerGh_registerY_registerZ_simple
	;;
	xplo $a24..a31, $r6 = -1125899906842624[$r6r7.lo] 	#Opcode-lvx_v1-XPLO_variant_registerGi_registerY_extend27_offset27_registerZ_triple
	;;
	xplo.s $a32..a39, $r4r5r6r7.z = -8388608[$r7] 	#Opcode-lvx_v1-XPLO_variant_registerGi_registerY_offset27_registerZ_double
	;;
	xplo.u $a40..a47, $r6r7.hi = [$r4r5r6r7.t] 	#Opcode-lvx_v1-XPLO_variant_registerGi_registerY_registerZ_simple
	;;
	xplo.us $a48..a63, $r8 = -1125899906842624[$r8r9.lo] 	#Opcode-lvx_v1-XPLO_variant_registerGj_registerY_extend27_offset27_registerZ_triple
	;;
	xplo $a0..a15, $r8r9r10r11.x = -8388608[$r9] 	#Opcode-lvx_v1-XPLO_variant_registerGj_registerY_offset27_registerZ_double
	;;
	xplo.s $a16..a31, $r8r9.hi = [$r8r9r10r11.y] 	#Opcode-lvx_v1-XPLO_variant_registerGj_registerY_registerZ_simple
	;;
	xplo.u $a32..a63, $r10 = -1125899906842624[$r10r11.lo] 	#Opcode-lvx_v1-XPLO_variant_registerGk_registerY_extend27_offset27_registerZ_triple
	;;
	xplo.us $a0..a31, $r8r9r10r11.z = -8388608[$r11] 	#Opcode-lvx_v1-XPLO_variant_registerGk_registerY_offset27_registerZ_double
	;;
	xplo $a32..a63, $r10r11.hi = [$r8r9r10r11.t] 	#Opcode-lvx_v1-XPLO_variant_registerGk_registerY_registerZ_simple
	;;
	xplo.s $a0..a63, $r12 = -1125899906842624[$sp] 	#Opcode-lvx_v1-XPLO_variant_registerGl_registerY_extend27_offset27_registerZ_triple
	;;
	xplo.u $a0..a63, $r13 = -8388608[$tp] 	#Opcode-lvx_v1-XPLO_variant_registerGl_registerY_offset27_registerZ_double
	;;
	xplo.us $a0..a63, $r14 = [$fp] 	#Opcode-lvx_v1-XPLO_variant_registerGl_registerY_registerZ_simple
	;;
	xplq $a28..a29, $r14r15.lo = -1125899906842624[$r15] 	#Opcode-lvx_v1-XPLQ_variant_registerGg_registerY_extend27_offset27_registerZ_triple
	;;
	xplq.s $a30..a31, $rp = -8388608[$r14r15.hi] 	#Opcode-lvx_v1-XPLQ_variant_registerGg_registerY_offset27_registerZ_double
	;;
	xplq.u $a32..a33, $r16 = [$r16r17.lo] 	#Opcode-lvx_v1-XPLQ_variant_registerGg_registerY_registerZ_simple
	;;
	xplq.us $a56..a59, $r16r17r18r19.x = -1125899906842624[$r17] 	#Opcode-lvx_v1-XPLQ_variant_registerGh_registerY_extend27_offset27_registerZ_triple
	;;
	xplq $a60..a63, $r16r17.hi = -8388608[$r16r17r18r19.y] 	#Opcode-lvx_v1-XPLQ_variant_registerGh_registerY_offset27_registerZ_double
	;;
	xplq.s $a0..a3, $r18 = [$r18r19.lo] 	#Opcode-lvx_v1-XPLQ_variant_registerGh_registerY_registerZ_simple
	;;
	xplq.u $a48..a55, $r16r17r18r19.z = -1125899906842624[$r19] 	#Opcode-lvx_v1-XPLQ_variant_registerGi_registerY_extend27_offset27_registerZ_triple
	;;
	xplq.us $a56..a63, $r18r19.hi = -8388608[$r16r17r18r19.t] 	#Opcode-lvx_v1-XPLQ_variant_registerGi_registerY_offset27_registerZ_double
	;;
	xplq $a0..a7, $r20 = [$r20r21.lo] 	#Opcode-lvx_v1-XPLQ_variant_registerGi_registerY_registerZ_simple
	;;
	xplq.s $a32..a47, $r20r21r22r23.x = -1125899906842624[$r21] 	#Opcode-lvx_v1-XPLQ_variant_registerGj_registerY_extend27_offset27_registerZ_triple
	;;
	xplq.u $a48..a63, $r20r21.hi = -8388608[$r20r21r22r23.y] 	#Opcode-lvx_v1-XPLQ_variant_registerGj_registerY_offset27_registerZ_double
	;;
	xplq.us $a0..a15, $r22 = [$r22r23.lo] 	#Opcode-lvx_v1-XPLQ_variant_registerGj_registerY_registerZ_simple
	;;
	xplq $a0..a31, $r20r21r22r23.z = -1125899906842624[$r23] 	#Opcode-lvx_v1-XPLQ_variant_registerGk_registerY_extend27_offset27_registerZ_triple
	;;
	xplq.s $a32..a63, $r22r23.hi = -8388608[$r20r21r22r23.t] 	#Opcode-lvx_v1-XPLQ_variant_registerGk_registerY_offset27_registerZ_double
	;;
	xplq.u $a0..a31, $r24 = [$r24r25.lo] 	#Opcode-lvx_v1-XPLQ_variant_registerGk_registerY_registerZ_simple
	;;
	xplq.us $a0..a63, $r24r25r26r27.x = -1125899906842624[$r25] 	#Opcode-lvx_v1-XPLQ_variant_registerGl_registerY_extend27_offset27_registerZ_triple
	;;
	xplq $a0..a63, $r24r25.hi = -8388608[$r24r25r26r27.y] 	#Opcode-lvx_v1-XPLQ_variant_registerGl_registerY_offset27_registerZ_double
	;;
	xplq.s $a0..a63, $r26 = [$r26r27.lo] 	#Opcode-lvx_v1-XPLQ_variant_registerGl_registerY_registerZ_simple
	;;
	xplw.u $a34..a35, $r24r25r26r27.z = -1125899906842624[$r27] 	#Opcode-lvx_v1-XPLW_variant_registerGg_registerY_extend27_offset27_registerZ_triple
	;;
	xplw.us $a36..a37, $r26r27.hi = -8388608[$r24r25r26r27.t] 	#Opcode-lvx_v1-XPLW_variant_registerGg_registerY_offset27_registerZ_double
	;;
	xplw $a38..a39, $r28 = [$r28r29.lo] 	#Opcode-lvx_v1-XPLW_variant_registerGg_registerY_registerZ_simple
	;;
	xplw.s $a4..a7, $r28r29r30r31.x = -1125899906842624[$r29] 	#Opcode-lvx_v1-XPLW_variant_registerGh_registerY_extend27_offset27_registerZ_triple
	;;
	xplw.u $a8..a11, $r28r29.hi = -8388608[$r28r29r30r31.y] 	#Opcode-lvx_v1-XPLW_variant_registerGh_registerY_offset27_registerZ_double
	;;
	xplw.us $a12..a15, $r30 = [$r30r31.lo] 	#Opcode-lvx_v1-XPLW_variant_registerGh_registerY_registerZ_simple
	;;
	xplw $a8..a15, $r28r29r30r31.z = -1125899906842624[$r31] 	#Opcode-lvx_v1-XPLW_variant_registerGi_registerY_extend27_offset27_registerZ_triple
	;;
	xplw.s $a16..a23, $r30r31.hi = -8388608[$r28r29r30r31.t] 	#Opcode-lvx_v1-XPLW_variant_registerGi_registerY_offset27_registerZ_double
	;;
	xplw.u $a24..a31, $r32 = [$r32r33.lo] 	#Opcode-lvx_v1-XPLW_variant_registerGi_registerY_registerZ_simple
	;;
	xplw.us $a16..a31, $r32r33r34r35.x = -1125899906842624[$r33] 	#Opcode-lvx_v1-XPLW_variant_registerGj_registerY_extend27_offset27_registerZ_triple
	;;
	xplw $a32..a47, $r32r33.hi = -8388608[$r32r33r34r35.y] 	#Opcode-lvx_v1-XPLW_variant_registerGj_registerY_offset27_registerZ_double
	;;
	xplw.s $a48..a63, $r34 = [$r34r35.lo] 	#Opcode-lvx_v1-XPLW_variant_registerGj_registerY_registerZ_simple
	;;
	xplw.u $a32..a63, $r32r33r34r35.z = -1125899906842624[$r35] 	#Opcode-lvx_v1-XPLW_variant_registerGk_registerY_extend27_offset27_registerZ_triple
	;;
	xplw.us $a0..a31, $r34r35.hi = -8388608[$r32r33r34r35.t] 	#Opcode-lvx_v1-XPLW_variant_registerGk_registerY_offset27_registerZ_double
	;;
	xplw $a32..a63, $r36 = [$r36r37.lo] 	#Opcode-lvx_v1-XPLW_variant_registerGk_registerY_registerZ_simple
	;;
	xplw.s $a0..a63, $r36r37r38r39.x = -1125899906842624[$r37] 	#Opcode-lvx_v1-XPLW_variant_registerGl_registerY_extend27_offset27_registerZ_triple
	;;
	xplw.u $a0..a63, $r36r37.hi = -8388608[$r36r37r38r39.y] 	#Opcode-lvx_v1-XPLW_variant_registerGl_registerY_offset27_registerZ_double
	;;
	xplw.us $a0..a63, $r38 = [$r38r39.lo] 	#Opcode-lvx_v1-XPLW_variant_registerGl_registerY_registerZ_simple
	;;
	xso 2305843009213693951[$r36r37r38r39.z] = $a4a5a6a7.x 	#Opcode-lvx_v1-XSO_extend27_upper27_lower10_registerZ_registerE_triple
	;;
	xso.q0 2305843009213693951[$r39] = $a16a17a18a19 	#Opcode-lvx_v1-XSO_qindex_extend27_upper27_lower10_registerZ_registerEq_triple
	;;
	xso.q1 $r38r39.hi[$r36r37r38r39.t] = $a20a21a22a23 	#Opcode-lvx_v1-XSO_qindex_registerY_registerZ_registerEq_simple
	;;
	xso.q2 -64[$r40] = $a24a25a26a27 	#Opcode-lvx_v1-XSO_qindex_signed10_registerZ_registerEq_simple
	;;
	xso.q3 -8589934592[$r40r41.lo] = $a28a29a30a31 	#Opcode-lvx_v1-XSO_qindex_upper27_lower10_registerZ_registerEq_double
	;;
	xso $r40r41r42r43.x[$r41] = $a5 	#Opcode-lvx_v1-XSO_registerY_registerZ_registerE_simple
	;;
	xso -64[$r40r41.hi] = $a4a5.hi 	#Opcode-lvx_v1-XSO_signed10_registerZ_registerE_simple
	;;
	xso -8589934592[$r40r41r42r43.y] = $a4a5a6a7.y 	#Opcode-lvx_v1-XSO_upper27_lower10_registerZ_registerE_double
	;;
	zxbd $r42 = $r42r43.lo 	#Opcode-lvx_v1-ZXBD_registerW_registerZ_simple
	;;
	zxhd $r40r41r42r43.z = $r43 	#Opcode-lvx_v1-ZXHD_registerW_registerZ_simple
	;;
	zxwd $r42r43.hi = $r40r41r42r43.t 	#Opcode-lvx_v1-ZXWD_registerW_registerZ_simple
	;;
	.endp	main
	.section .text

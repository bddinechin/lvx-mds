/* (c) Copyright 2010-2025 Kalray SA. */
struct reg_desc {
	char *name;
	char *desc;
};

struct reg_desc lvx_v1_mds_registers_description[] = {
	{"pc", "<reg name=\"pc\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=0 */
	{"ps", ""
		"<struct id=\"ps_type\" size=\"4\">\n"
			"<field name=\"pl\" start=\"0\" end=\"1\" />\n"
			"<field name=\"et\" start=\"2\" end=\"2\" />\n"
			"<field name=\"htd\" start=\"3\" end=\"3\" />\n"
			"<field name=\"ie\" start=\"4\" end=\"4\" />\n"
			"<field name=\"hle\" start=\"5\" end=\"5\" />\n"
			"<field name=\"sre\" start=\"6\" end=\"6\" />\n"
			"<field name=\"daus\" start=\"7\" end=\"7\" />\n"
			"<field name=\"ice\" start=\"8\" end=\"8\" />\n"
			"<field name=\"use\" start=\"9\" end=\"9\" />\n"
			"<field name=\"dce\" start=\"10\" end=\"10\" />\n"
			"<field name=\"mme\" start=\"11\" end=\"11\" />\n"
			"<field name=\"il\" start=\"12\" end=\"13\" />\n"
			"<field name=\"vs\" start=\"14\" end=\"15\" />\n"
			"<field name=\"v64\" start=\"16\" end=\"16\" />\n"
			"<field name=\"l2e\" start=\"17\" end=\"17\" />\n"
			"<field name=\"sme\" start=\"18\" end=\"18\" />\n"
			"<field name=\"smr\" start=\"19\" end=\"19\" />\n"
			"<field name=\"pmj\" start=\"20\" end=\"23\" />\n"
			"<field name=\"mmup\" start=\"24\" end=\"24\" />\n"
		"</struct>\n"
		"<reg name=\"ps\" regnum=\"%d\" bitsize=\"32\" type=\"ps_type\" />"}, /* regno=1 */
	{"pcr", ""
		"<struct id=\"pcr_type\" size=\"8\">\n"
			"<field name=\"pid\" start=\"0\" end=\"7\" />\n"
			"<field name=\"cid\" start=\"8\" end=\"15\" />\n"
			"<field name=\"mid\" start=\"16\" end=\"23\" />\n"
			"<field name=\"car\" start=\"24\" end=\"27\" />\n"
			"<field name=\"cma\" start=\"28\" end=\"31\" />\n"
			"<field name=\"sv\" start=\"32\" end=\"39\" />\n"
			"<field name=\"st\" start=\"40\" end=\"43\" />\n"
			"<field name=\"bm\" start=\"44\" end=\"51\" />\n"
			"<field name=\"coe\" start=\"52\" end=\"52\" />\n"
			"<field name=\"l1ce\" start=\"53\" end=\"53\" />\n"
			"<field name=\"dsem\" start=\"54\" end=\"54\" />\n"
			"<field name=\"tpce\" start=\"55\" end=\"55\" />\n"
			"<field name=\"tpcum\" start=\"56\" end=\"56\" />\n"
			"<field name=\"tpcis\" start=\"57\" end=\"57\" />\n"
		"</struct>\n"
		"<reg name=\"pcr\" regnum=\"%d\" bitsize=\"64\" type=\"pcr_type\" />"}, /* regno=2 */
	{"ra", "<reg name=\"ra\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=3 */
	{"cs", ""
		"<struct id=\"cs_type\" size=\"8\">\n"
			"<field name=\"ic\" start=\"0\" end=\"0\" />\n"
			"<field name=\"io\" start=\"1\" end=\"1\" />\n"
			"<field name=\"dz\" start=\"2\" end=\"2\" />\n"
			"<field name=\"ov\" start=\"3\" end=\"3\" />\n"
			"<field name=\"un\" start=\"4\" end=\"4\" />\n"
			"<field name=\"in\" start=\"5\" end=\"5\" />\n"
			"<field name=\"rm\" start=\"16\" end=\"18\" />\n"
			"<field name=\"xrm\" start=\"20\" end=\"21\" />\n"
			"<field name=\"xmf\" start=\"24\" end=\"24\" />\n"
			"<field name=\"cc\" start=\"32\" end=\"47\" />\n"
		"</struct>\n"
		"<reg name=\"cs\" regnum=\"%d\" bitsize=\"64\" type=\"cs_type\" />"}, /* regno=4 */
	{"csit", ""
		"<struct id=\"csit_type\" size=\"4\">\n"
			"<field name=\"icie\" start=\"0\" end=\"0\" />\n"
			"<field name=\"ioie\" start=\"1\" end=\"1\" />\n"
			"<field name=\"dzie\" start=\"2\" end=\"2\" />\n"
			"<field name=\"ovie\" start=\"3\" end=\"3\" />\n"
			"<field name=\"unie\" start=\"4\" end=\"4\" />\n"
			"<field name=\"inie\" start=\"5\" end=\"5\" />\n"
			"<field name=\"xioie\" start=\"9\" end=\"9\" />\n"
			"<field name=\"xdzie\" start=\"10\" end=\"10\" />\n"
			"<field name=\"xovie\" start=\"11\" end=\"11\" />\n"
			"<field name=\"xunie\" start=\"12\" end=\"12\" />\n"
			"<field name=\"xinie\" start=\"13\" end=\"13\" />\n"
			"<field name=\"aeir\" start=\"16\" end=\"16\" />\n"
			"<field name=\"aec\" start=\"17\" end=\"19\" />\n"
			"<field name=\"spcv\" start=\"20\" end=\"20\" />\n"
		"</struct>\n"
		"<reg name=\"csit\" regnum=\"%d\" bitsize=\"32\" type=\"csit_type\" />"}, /* regno=5 */
	{"aespc", ""
		"<struct id=\"aespc_type\" size=\"8\">\n"
			"<field name=\"aespc\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"aespc\" regnum=\"%d\" bitsize=\"64\" type=\"aespc_type\" />"}, /* regno=6 */
	{"ls", "<reg name=\"ls\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=7 */
	{"le", "<reg name=\"le\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=8 */
	{"lc", "<reg name=\"lc\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=9 */
	{"ipe", ""
		"<struct id=\"ipe_type\" size=\"8\">\n"
			"<field name=\"fe\" start=\"0\" end=\"15\" />\n"
			"<field name=\"be\" start=\"16\" end=\"31\" />\n"
			"<field name=\"fm\" start=\"32\" end=\"47\" />\n"
			"<field name=\"bm\" start=\"48\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"ipe\" regnum=\"%d\" bitsize=\"64\" type=\"ipe_type\" />"}, /* regno=10 */
	{"men", ""
		"<struct id=\"men_type\" size=\"8\">\n"
			"<field name=\"men\" start=\"0\" end=\"15\" />\n"
		"</struct>\n"
		"<reg name=\"men\" regnum=\"%d\" bitsize=\"64\" type=\"men_type\" />"}, /* regno=11 */
	{"pmc", ""
		"<struct id=\"pmc_type\" size=\"8\">\n"
			"<field name=\"pm0c\" start=\"0\" end=\"5\" />\n"
			"<field name=\"pm1c\" start=\"7\" end=\"12\" />\n"
			"<field name=\"pm2c\" start=\"14\" end=\"19\" />\n"
			"<field name=\"pm3c\" start=\"21\" end=\"26\" />\n"
			"<field name=\"sav\" start=\"30\" end=\"30\" />\n"
			"<field name=\"pm0ie\" start=\"32\" end=\"32\" />\n"
			"<field name=\"pm1ie\" start=\"33\" end=\"33\" />\n"
			"<field name=\"pm2ie\" start=\"34\" end=\"34\" />\n"
			"<field name=\"pm3ie\" start=\"35\" end=\"35\" />\n"
			"<field name=\"sat\" start=\"36\" end=\"37\" />\n"
			"<field name=\"saf\" start=\"38\" end=\"40\" />\n"
		"</struct>\n"
		"<reg name=\"pmc\" regnum=\"%d\" bitsize=\"64\" type=\"pmc_type\" />"}, /* regno=12 */
	{"pm0", ""
		"<struct id=\"pm0_type\" size=\"8\">\n"
			"<field name=\"pm0\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm0\" regnum=\"%d\" bitsize=\"64\" type=\"pm0_type\" />"}, /* regno=13 */
	{"pm1", ""
		"<struct id=\"pm1_type\" size=\"8\">\n"
			"<field name=\"pm1\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm1\" regnum=\"%d\" bitsize=\"64\" type=\"pm1_type\" />"}, /* regno=14 */
	{"pm2", ""
		"<struct id=\"pm2_type\" size=\"8\">\n"
			"<field name=\"pm2\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm2\" regnum=\"%d\" bitsize=\"64\" type=\"pm2_type\" />"}, /* regno=15 */
	{"pm3", ""
		"<struct id=\"pm3_type\" size=\"8\">\n"
			"<field name=\"pm3\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm3\" regnum=\"%d\" bitsize=\"64\" type=\"pm3_type\" />"}, /* regno=16 */
	{"pmsa", ""
		"<struct id=\"pmsa_type\" size=\"8\">\n"
			"<field name=\"pmsa\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pmsa\" regnum=\"%d\" bitsize=\"64\" type=\"pmsa_type\" />"}, /* regno=17 */
	{"tcr", ""
		"<struct id=\"tcr_type\" size=\"4\">\n"
			"<field name=\"t0ce\" start=\"16\" end=\"16\" />\n"
			"<field name=\"t1ce\" start=\"17\" end=\"17\" />\n"
			"<field name=\"t0ie\" start=\"18\" end=\"18\" />\n"
			"<field name=\"t1ie\" start=\"19\" end=\"19\" />\n"
			"<field name=\"t0st\" start=\"20\" end=\"20\" />\n"
			"<field name=\"t1st\" start=\"21\" end=\"21\" />\n"
			"<field name=\"t0si\" start=\"22\" end=\"22\" />\n"
			"<field name=\"t1si\" start=\"23\" end=\"23\" />\n"
			"<field name=\"wce\" start=\"24\" end=\"24\" />\n"
			"<field name=\"wie\" start=\"25\" end=\"25\" />\n"
			"<field name=\"wui\" start=\"26\" end=\"26\" />\n"
			"<field name=\"wus\" start=\"27\" end=\"27\" />\n"
			"<field name=\"wsi\" start=\"28\" end=\"28\" />\n"
		"</struct>\n"
		"<reg name=\"tcr\" regnum=\"%d\" bitsize=\"32\" type=\"tcr_type\" />"}, /* regno=18 */
	{"t0v", ""
		"<struct id=\"t0v_type\" size=\"8\">\n"
			"<field name=\"t0v\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"t0v\" regnum=\"%d\" bitsize=\"64\" type=\"t0v_type\" />"}, /* regno=19 */
	{"t1v", ""
		"<struct id=\"t1v_type\" size=\"8\">\n"
			"<field name=\"t1v\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"t1v\" regnum=\"%d\" bitsize=\"64\" type=\"t1v_type\" />"}, /* regno=20 */
	{"t0r", ""
		"<struct id=\"t0r_type\" size=\"8\">\n"
			"<field name=\"t0r\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"t0r\" regnum=\"%d\" bitsize=\"64\" type=\"t0r_type\" />"}, /* regno=21 */
	{"t1r", ""
		"<struct id=\"t1r_type\" size=\"8\">\n"
			"<field name=\"t1r\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"t1r\" regnum=\"%d\" bitsize=\"64\" type=\"t1r_type\" />"}, /* regno=22 */
	{"wdv", ""
		"<struct id=\"wdv_type\" size=\"8\">\n"
			"<field name=\"wdv\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"wdv\" regnum=\"%d\" bitsize=\"64\" type=\"wdv_type\" />"}, /* regno=23 */
	{"wdr", ""
		"<struct id=\"wdr_type\" size=\"8\">\n"
			"<field name=\"wdr\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"wdr\" regnum=\"%d\" bitsize=\"64\" type=\"wdr_type\" />"}, /* regno=24 */
	{"ile", ""
		"<struct id=\"ile_type\" size=\"8\">\n"
			"<field name=\"it0\" start=\"0\" end=\"0\" />\n"
			"<field name=\"it1\" start=\"1\" end=\"1\" />\n"
			"<field name=\"it2\" start=\"2\" end=\"2\" />\n"
			"<field name=\"it3\" start=\"3\" end=\"3\" />\n"
			"<field name=\"it4\" start=\"4\" end=\"4\" />\n"
			"<field name=\"it5\" start=\"5\" end=\"5\" />\n"
			"<field name=\"it6\" start=\"6\" end=\"6\" />\n"
			"<field name=\"it7\" start=\"7\" end=\"7\" />\n"
			"<field name=\"it8\" start=\"8\" end=\"8\" />\n"
			"<field name=\"it9\" start=\"9\" end=\"9\" />\n"
			"<field name=\"it10\" start=\"10\" end=\"10\" />\n"
			"<field name=\"it11\" start=\"11\" end=\"11\" />\n"
			"<field name=\"it12\" start=\"12\" end=\"12\" />\n"
			"<field name=\"it13\" start=\"13\" end=\"13\" />\n"
			"<field name=\"it14\" start=\"14\" end=\"14\" />\n"
			"<field name=\"it15\" start=\"15\" end=\"15\" />\n"
			"<field name=\"it16\" start=\"16\" end=\"16\" />\n"
			"<field name=\"it17\" start=\"17\" end=\"17\" />\n"
			"<field name=\"it18\" start=\"18\" end=\"18\" />\n"
			"<field name=\"it19\" start=\"19\" end=\"19\" />\n"
			"<field name=\"it20\" start=\"20\" end=\"20\" />\n"
			"<field name=\"it21\" start=\"21\" end=\"21\" />\n"
			"<field name=\"it22\" start=\"22\" end=\"22\" />\n"
			"<field name=\"it23\" start=\"23\" end=\"23\" />\n"
			"<field name=\"it24\" start=\"24\" end=\"24\" />\n"
			"<field name=\"it25\" start=\"25\" end=\"25\" />\n"
			"<field name=\"it26\" start=\"26\" end=\"26\" />\n"
			"<field name=\"it27\" start=\"27\" end=\"27\" />\n"
			"<field name=\"it28\" start=\"28\" end=\"28\" />\n"
			"<field name=\"it29\" start=\"29\" end=\"29\" />\n"
			"<field name=\"it30\" start=\"30\" end=\"30\" />\n"
			"<field name=\"it31\" start=\"31\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"ile\" regnum=\"%d\" bitsize=\"64\" type=\"ile_type\" />"}, /* regno=25 */
	{"ill", ""
		"<struct id=\"ill_type\" size=\"8\">\n"
			"<field name=\"it0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"it1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"it2\" start=\"4\" end=\"5\" />\n"
			"<field name=\"it3\" start=\"6\" end=\"7\" />\n"
			"<field name=\"it4\" start=\"8\" end=\"9\" />\n"
			"<field name=\"it5\" start=\"10\" end=\"11\" />\n"
			"<field name=\"it6\" start=\"12\" end=\"13\" />\n"
			"<field name=\"it7\" start=\"14\" end=\"15\" />\n"
			"<field name=\"it8\" start=\"16\" end=\"17\" />\n"
			"<field name=\"it9\" start=\"18\" end=\"19\" />\n"
			"<field name=\"it10\" start=\"20\" end=\"21\" />\n"
			"<field name=\"it11\" start=\"22\" end=\"23\" />\n"
			"<field name=\"it12\" start=\"24\" end=\"25\" />\n"
			"<field name=\"it13\" start=\"26\" end=\"27\" />\n"
			"<field name=\"it14\" start=\"28\" end=\"29\" />\n"
			"<field name=\"it15\" start=\"30\" end=\"31\" />\n"
			"<field name=\"it16\" start=\"32\" end=\"33\" />\n"
			"<field name=\"it17\" start=\"34\" end=\"35\" />\n"
			"<field name=\"it18\" start=\"36\" end=\"37\" />\n"
			"<field name=\"it19\" start=\"38\" end=\"39\" />\n"
			"<field name=\"it20\" start=\"40\" end=\"41\" />\n"
			"<field name=\"it21\" start=\"42\" end=\"43\" />\n"
			"<field name=\"it22\" start=\"44\" end=\"45\" />\n"
			"<field name=\"it23\" start=\"46\" end=\"47\" />\n"
			"<field name=\"it24\" start=\"48\" end=\"49\" />\n"
			"<field name=\"it25\" start=\"50\" end=\"51\" />\n"
			"<field name=\"it26\" start=\"52\" end=\"53\" />\n"
			"<field name=\"it27\" start=\"54\" end=\"55\" />\n"
			"<field name=\"it28\" start=\"56\" end=\"57\" />\n"
			"<field name=\"it29\" start=\"58\" end=\"59\" />\n"
			"<field name=\"it30\" start=\"60\" end=\"61\" />\n"
			"<field name=\"it31\" start=\"62\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"ill\" regnum=\"%d\" bitsize=\"64\" type=\"ill_type\" />"}, /* regno=26 */
	{"ilr", ""
		"<struct id=\"ilr_type\" size=\"8\">\n"
			"<field name=\"it0\" start=\"0\" end=\"0\" />\n"
			"<field name=\"it1\" start=\"1\" end=\"1\" />\n"
			"<field name=\"it2\" start=\"2\" end=\"2\" />\n"
			"<field name=\"it3\" start=\"3\" end=\"3\" />\n"
			"<field name=\"it4\" start=\"4\" end=\"4\" />\n"
			"<field name=\"it5\" start=\"5\" end=\"5\" />\n"
			"<field name=\"it6\" start=\"6\" end=\"6\" />\n"
			"<field name=\"it7\" start=\"7\" end=\"7\" />\n"
			"<field name=\"it8\" start=\"8\" end=\"8\" />\n"
			"<field name=\"it9\" start=\"9\" end=\"9\" />\n"
			"<field name=\"it10\" start=\"10\" end=\"10\" />\n"
			"<field name=\"it11\" start=\"11\" end=\"11\" />\n"
			"<field name=\"it12\" start=\"12\" end=\"12\" />\n"
			"<field name=\"it13\" start=\"13\" end=\"13\" />\n"
			"<field name=\"it14\" start=\"14\" end=\"14\" />\n"
			"<field name=\"it15\" start=\"15\" end=\"15\" />\n"
			"<field name=\"it16\" start=\"16\" end=\"16\" />\n"
			"<field name=\"it17\" start=\"17\" end=\"17\" />\n"
			"<field name=\"it18\" start=\"18\" end=\"18\" />\n"
			"<field name=\"it19\" start=\"19\" end=\"19\" />\n"
			"<field name=\"it20\" start=\"20\" end=\"20\" />\n"
			"<field name=\"it21\" start=\"21\" end=\"21\" />\n"
			"<field name=\"it22\" start=\"22\" end=\"22\" />\n"
			"<field name=\"it23\" start=\"23\" end=\"23\" />\n"
			"<field name=\"it24\" start=\"24\" end=\"24\" />\n"
			"<field name=\"it25\" start=\"25\" end=\"25\" />\n"
			"<field name=\"it26\" start=\"26\" end=\"26\" />\n"
			"<field name=\"it27\" start=\"27\" end=\"27\" />\n"
			"<field name=\"it28\" start=\"28\" end=\"28\" />\n"
			"<field name=\"it29\" start=\"29\" end=\"29\" />\n"
			"<field name=\"it30\" start=\"30\" end=\"30\" />\n"
			"<field name=\"it31\" start=\"31\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"ilr\" regnum=\"%d\" bitsize=\"64\" type=\"ilr_type\" />"}, /* regno=27 */
	{"mmc", ""
		"<struct id=\"mmc_type\" size=\"4\">\n"
			"<field name=\"asn\" start=\"0\" end=\"8\" />\n"
			"<field name=\"s\" start=\"9\" end=\"9\" />\n"
			"<field name=\"sne\" start=\"14\" end=\"14\" />\n"
			"<field name=\"spe\" start=\"15\" end=\"15\" />\n"
			"<field name=\"ptc\" start=\"16\" end=\"17\" />\n"
			"<field name=\"sw\" start=\"18\" end=\"21\" />\n"
			"<field name=\"ss\" start=\"22\" end=\"27\" />\n"
			"<field name=\"sb\" start=\"28\" end=\"28\" />\n"
			"<field name=\"par\" start=\"30\" end=\"30\" />\n"
			"<field name=\"e\" start=\"31\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"mmc\" regnum=\"%d\" bitsize=\"32\" type=\"mmc_type\" />"}, /* regno=28 */
	{"tel", ""
		"<struct id=\"tel_type\" size=\"8\">\n"
			"<field name=\"es\" start=\"0\" end=\"1\" />\n"
			"<field name=\"cp2\" start=\"2\" end=\"5\" />\n"
			"<field name=\"pa2\" start=\"6\" end=\"9\" />\n"
			"<field name=\"ps\" start=\"10\" end=\"11\" />\n"
			"<field name=\"fn\" start=\"12\" end=\"39\" />\n"
		"</struct>\n"
		"<reg name=\"tel\" regnum=\"%d\" bitsize=\"64\" type=\"tel_type\" />"}, /* regno=29 */
	{"teh", ""
		"<struct id=\"teh_type\" size=\"8\">\n"
			"<field name=\"asn\" start=\"0\" end=\"8\" />\n"
			"<field name=\"g\" start=\"9\" end=\"9\" />\n"
			"<field name=\"vs\" start=\"10\" end=\"11\" />\n"
			"<field name=\"pn\" start=\"12\" end=\"40\" />\n"
		"</struct>\n"
		"<reg name=\"teh\" regnum=\"%d\" bitsize=\"64\" type=\"teh_type\" />"}, /* regno=30 */
	{"ixc", ""
		"<struct id=\"ixc_type\" size=\"4\">\n"
			"<field name=\"fcb\" start=\"0\" end=\"0\" />\n"
			"<field name=\"sfb\" start=\"8\" end=\"8\" />\n"
			"<field name=\"bcb\" start=\"16\" end=\"16\" />\n"
		"</struct>\n"
		"<reg name=\"ixc\" regnum=\"%d\" bitsize=\"32\" type=\"ixc_type\" />"}, /* regno=31 */
	{"syo", ""
		"<struct id=\"syo_type\" size=\"4\">\n"
			"<field name=\"q0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"q1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"q2\" start=\"4\" end=\"5\" />\n"
			"<field name=\"q3\" start=\"6\" end=\"7\" />\n"
		"</struct>\n"
		"<reg name=\"syo\" regnum=\"%d\" bitsize=\"32\" type=\"syo_type\" />"}, /* regno=32 */
	{"hto", ""
		"<struct id=\"hto_type\" size=\"4\">\n"
			"<field name=\"opc\" start=\"0\" end=\"1\" />\n"
			"<field name=\"dmis\" start=\"2\" end=\"3\" />\n"
			"<field name=\"psys\" start=\"4\" end=\"5\" />\n"
			"<field name=\"dsys\" start=\"6\" end=\"7\" />\n"
			"<field name=\"deccg\" start=\"8\" end=\"9\" />\n"
			"<field name=\"seccg\" start=\"10\" end=\"11\" />\n"
			"<field name=\"nomap\" start=\"12\" end=\"13\" />\n"
			"<field name=\"prot\" start=\"14\" end=\"15\" />\n"
			"<field name=\"w2cl\" start=\"16\" end=\"17\" />\n"
			"<field name=\"a2cl\" start=\"18\" end=\"19\" />\n"
			"<field name=\"de\" start=\"20\" end=\"21\" />\n"
			"<field name=\"vsfr\" start=\"22\" end=\"23\" />\n"
			"<field name=\"plo\" start=\"24\" end=\"25\" />\n"
		"</struct>\n"
		"<reg name=\"hto\" regnum=\"%d\" bitsize=\"32\" type=\"hto_type\" />"}, /* regno=33 */
	{"ito", ""
		"<struct id=\"ito_type\" size=\"8\">\n"
			"<field name=\"it0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"it1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"it2\" start=\"4\" end=\"5\" />\n"
			"<field name=\"it3\" start=\"6\" end=\"7\" />\n"
			"<field name=\"it4\" start=\"8\" end=\"9\" />\n"
			"<field name=\"it5\" start=\"10\" end=\"11\" />\n"
			"<field name=\"it6\" start=\"12\" end=\"13\" />\n"
			"<field name=\"it7\" start=\"14\" end=\"15\" />\n"
			"<field name=\"it8\" start=\"16\" end=\"17\" />\n"
			"<field name=\"it9\" start=\"18\" end=\"19\" />\n"
			"<field name=\"it10\" start=\"20\" end=\"21\" />\n"
			"<field name=\"it11\" start=\"22\" end=\"23\" />\n"
			"<field name=\"it12\" start=\"24\" end=\"25\" />\n"
			"<field name=\"it13\" start=\"26\" end=\"27\" />\n"
			"<field name=\"it14\" start=\"28\" end=\"29\" />\n"
			"<field name=\"it15\" start=\"30\" end=\"31\" />\n"
			"<field name=\"it16\" start=\"32\" end=\"33\" />\n"
			"<field name=\"it17\" start=\"34\" end=\"35\" />\n"
			"<field name=\"it18\" start=\"36\" end=\"37\" />\n"
			"<field name=\"it19\" start=\"38\" end=\"39\" />\n"
			"<field name=\"it20\" start=\"40\" end=\"41\" />\n"
			"<field name=\"it21\" start=\"42\" end=\"43\" />\n"
			"<field name=\"it22\" start=\"44\" end=\"45\" />\n"
			"<field name=\"it23\" start=\"46\" end=\"47\" />\n"
			"<field name=\"it24\" start=\"48\" end=\"49\" />\n"
			"<field name=\"it25\" start=\"50\" end=\"51\" />\n"
			"<field name=\"it26\" start=\"52\" end=\"53\" />\n"
			"<field name=\"it27\" start=\"54\" end=\"55\" />\n"
			"<field name=\"it28\" start=\"56\" end=\"57\" />\n"
			"<field name=\"it29\" start=\"58\" end=\"59\" />\n"
			"<field name=\"it30\" start=\"60\" end=\"61\" />\n"
			"<field name=\"it31\" start=\"62\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"ito\" regnum=\"%d\" bitsize=\"64\" type=\"ito_type\" />"}, /* regno=34 */
	{"do", ""
		"<struct id=\"do_type\" size=\"4\">\n"
			"<field name=\"b0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"b1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"w0\" start=\"4\" end=\"5\" />\n"
			"<field name=\"w1\" start=\"6\" end=\"7\" />\n"
			"<field name=\"b2\" start=\"8\" end=\"9\" />\n"
			"<field name=\"b3\" start=\"10\" end=\"11\" />\n"
			"<field name=\"w2\" start=\"12\" end=\"13\" />\n"
			"<field name=\"w3\" start=\"14\" end=\"15\" />\n"
			"<field name=\"bi0\" start=\"16\" end=\"17\" />\n"
			"<field name=\"bi1\" start=\"18\" end=\"19\" />\n"
			"<field name=\"bi2\" start=\"20\" end=\"21\" />\n"
			"<field name=\"bi3\" start=\"22\" end=\"23\" />\n"
		"</struct>\n"
		"<reg name=\"do\" regnum=\"%d\" bitsize=\"32\" type=\"do_type\" />"}, /* regno=35 */
	{"mo", ""
		"<struct id=\"mo_type\" size=\"8\">\n"
			"<field name=\"mmi\" start=\"0\" end=\"1\" />\n"
			"<field name=\"rfe\" start=\"2\" end=\"3\" />\n"
			"<field name=\"stop\" start=\"4\" end=\"5\" />\n"
			"<field name=\"sync\" start=\"6\" end=\"7\" />\n"
			"<field name=\"pcr\" start=\"8\" end=\"9\" />\n"
			"<field name=\"msg\" start=\"10\" end=\"11\" />\n"
			"<field name=\"men\" start=\"12\" end=\"13\" />\n"
			"<field name=\"mes\" start=\"14\" end=\"15\" />\n"
			"<field name=\"csit\" start=\"16\" end=\"17\" />\n"
			"<field name=\"t0\" start=\"18\" end=\"19\" />\n"
			"<field name=\"t1\" start=\"20\" end=\"21\" />\n"
			"<field name=\"wd\" start=\"22\" end=\"23\" />\n"
			"<field name=\"pm0\" start=\"24\" end=\"25\" />\n"
			"<field name=\"pm1\" start=\"26\" end=\"27\" />\n"
			"<field name=\"pm2\" start=\"28\" end=\"29\" />\n"
			"<field name=\"pm3\" start=\"30\" end=\"31\" />\n"
			"<field name=\"pmit\" start=\"32\" end=\"33\" />\n"
			"<field name=\"comm\" start=\"34\" end=\"35\" />\n"
			"<field name=\"tpcm\" start=\"36\" end=\"37\" />\n"
			"<field name=\"disw\" start=\"38\" end=\"39\" />\n"
			"<field name=\"pm4\" start=\"40\" end=\"41\" />\n"
			"<field name=\"pm5\" start=\"42\" end=\"43\" />\n"
			"<field name=\"pm6\" start=\"44\" end=\"45\" />\n"
			"<field name=\"pm7\" start=\"46\" end=\"47\" />\n"
			"<field name=\"srhpc\" start=\"48\" end=\"49\" />\n"
		"</struct>\n"
		"<reg name=\"mo\" regnum=\"%d\" bitsize=\"64\" type=\"mo_type\" />"}, /* regno=36 */
	{"pso", ""
		"<struct id=\"pso_type\" size=\"8\">\n"
			"<field name=\"pl0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"pl1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"et\" start=\"4\" end=\"5\" />\n"
			"<field name=\"htd\" start=\"6\" end=\"7\" />\n"
			"<field name=\"ie\" start=\"8\" end=\"9\" />\n"
			"<field name=\"hle\" start=\"10\" end=\"11\" />\n"
			"<field name=\"sre\" start=\"12\" end=\"13\" />\n"
			"<field name=\"daus\" start=\"14\" end=\"15\" />\n"
			"<field name=\"ice\" start=\"16\" end=\"17\" />\n"
			"<field name=\"use\" start=\"18\" end=\"19\" />\n"
			"<field name=\"dce\" start=\"20\" end=\"21\" />\n"
			"<field name=\"mme\" start=\"22\" end=\"23\" />\n"
			"<field name=\"il0\" start=\"24\" end=\"25\" />\n"
			"<field name=\"il1\" start=\"26\" end=\"27\" />\n"
			"<field name=\"vs0\" start=\"28\" end=\"29\" />\n"
			"<field name=\"vs1\" start=\"30\" end=\"31\" />\n"
			"<field name=\"l2e\" start=\"34\" end=\"35\" />\n"
			"<field name=\"sme\" start=\"36\" end=\"37\" />\n"
			"<field name=\"smr\" start=\"38\" end=\"39\" />\n"
			"<field name=\"pmj0\" start=\"40\" end=\"41\" />\n"
			"<field name=\"pmj1\" start=\"42\" end=\"43\" />\n"
			"<field name=\"pmj2\" start=\"44\" end=\"45\" />\n"
			"<field name=\"pmj3\" start=\"46\" end=\"47\" />\n"
			"<field name=\"mmup\" start=\"48\" end=\"49\" />\n"
		"</struct>\n"
		"<reg name=\"pso\" regnum=\"%d\" bitsize=\"64\" type=\"pso_type\" />"}, /* regno=37 */
	{"tpcm0", ""
		"<struct id=\"tpcm0_type\" size=\"8\">\n"
			"<field name=\"tpcm_0\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"tpcm0\" regnum=\"%d\" bitsize=\"64\" type=\"tpcm0_type\" />"}, /* regno=38 */
	{"tpcm1", ""
		"<struct id=\"tpcm1_type\" size=\"8\">\n"
			"<field name=\"tpcm_1\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"tpcm1\" regnum=\"%d\" bitsize=\"64\" type=\"tpcm1_type\" />"}, /* regno=39 */
	{"res40", "<reg name=\"res40\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=40 */
	{"dba0", ""
		"<struct id=\"dba0_type\" size=\"8\">\n"
			"<field name=\"dba0\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dba0\" regnum=\"%d\" bitsize=\"64\" type=\"dba0_type\" />"}, /* regno=41 */
	{"dba1", ""
		"<struct id=\"dba1_type\" size=\"8\">\n"
			"<field name=\"dba1\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dba1\" regnum=\"%d\" bitsize=\"64\" type=\"dba1_type\" />"}, /* regno=42 */
	{"dwa0", ""
		"<struct id=\"dwa0_type\" size=\"8\">\n"
			"<field name=\"dwa0\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dwa0\" regnum=\"%d\" bitsize=\"64\" type=\"dwa0_type\" />"}, /* regno=43 */
	{"dwa1", ""
		"<struct id=\"dwa1_type\" size=\"8\">\n"
			"<field name=\"dwa1\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dwa1\" regnum=\"%d\" bitsize=\"64\" type=\"dwa1_type\" />"}, /* regno=44 */
	{"mes", ""
		"<struct id=\"mes_type\" size=\"4\">\n"
			"<field name=\"pse\" start=\"0\" end=\"0\" />\n"
			"<field name=\"pilsy\" start=\"1\" end=\"1\" />\n"
			"<field name=\"pilde\" start=\"2\" end=\"2\" />\n"
			"<field name=\"pilpa\" start=\"3\" end=\"3\" />\n"
			"<field name=\"dse\" start=\"4\" end=\"4\" />\n"
			"<field name=\"dilsy\" start=\"5\" end=\"5\" />\n"
			"<field name=\"dilde\" start=\"6\" end=\"6\" />\n"
			"<field name=\"dilpa\" start=\"7\" end=\"7\" />\n"
			"<field name=\"ddee\" start=\"8\" end=\"8\" />\n"
			"<field name=\"dsye\" start=\"9\" end=\"9\" />\n"
		"</struct>\n"
		"<reg name=\"mes\" regnum=\"%d\" bitsize=\"32\" type=\"mes_type\" />"}, /* regno=45 */
	{"ws", ""
		"<struct id=\"ws_type\" size=\"4\">\n"
			"<field name=\"wu0\" start=\"0\" end=\"0\" />\n"
			"<field name=\"wu1\" start=\"1\" end=\"1\" />\n"
			"<field name=\"wu2\" start=\"2\" end=\"2\" />\n"
		"</struct>\n"
		"<reg name=\"ws\" regnum=\"%d\" bitsize=\"32\" type=\"ws_type\" />"}, /* regno=46 */
	{"dc0", ""
		"<struct id=\"dc0_type\" size=\"8\">\n"
			"<field name=\"be\" start=\"0\" end=\"0\" />\n"
			"<field name=\"we\" start=\"1\" end=\"1\" />\n"
			"<field name=\"wtyp\" start=\"2\" end=\"3\" />\n"
			"<field name=\"wsz\" start=\"4\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"dc0\" regnum=\"%d\" bitsize=\"64\" type=\"dc0_type\" />"}, /* regno=47 */
	{"dc1", ""
		"<struct id=\"dc1_type\" size=\"8\">\n"
			"<field name=\"be\" start=\"0\" end=\"0\" />\n"
			"<field name=\"we\" start=\"1\" end=\"1\" />\n"
			"<field name=\"wtyp\" start=\"2\" end=\"3\" />\n"
			"<field name=\"wsz\" start=\"4\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"dc1\" regnum=\"%d\" bitsize=\"64\" type=\"dc1_type\" />"}, /* regno=48 */
	{"dc2", ""
		"<struct id=\"dc2_type\" size=\"8\">\n"
			"<field name=\"be\" start=\"0\" end=\"0\" />\n"
			"<field name=\"we\" start=\"1\" end=\"1\" />\n"
			"<field name=\"wtyp\" start=\"2\" end=\"3\" />\n"
			"<field name=\"wsz\" start=\"4\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"dc2\" regnum=\"%d\" bitsize=\"64\" type=\"dc2_type\" />"}, /* regno=49 */
	{"dc3", ""
		"<struct id=\"dc3_type\" size=\"8\">\n"
			"<field name=\"be\" start=\"0\" end=\"0\" />\n"
			"<field name=\"we\" start=\"1\" end=\"1\" />\n"
			"<field name=\"wtyp\" start=\"2\" end=\"3\" />\n"
			"<field name=\"wsz\" start=\"4\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"dc3\" regnum=\"%d\" bitsize=\"64\" type=\"dc3_type\" />"}, /* regno=50 */
	{"dba2", ""
		"<struct id=\"dba2_type\" size=\"8\">\n"
			"<field name=\"dba2\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dba2\" regnum=\"%d\" bitsize=\"64\" type=\"dba2_type\" />"}, /* regno=51 */
	{"dba3", ""
		"<struct id=\"dba3_type\" size=\"8\">\n"
			"<field name=\"dba3\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dba3\" regnum=\"%d\" bitsize=\"64\" type=\"dba3_type\" />"}, /* regno=52 */
	{"dwa2", ""
		"<struct id=\"dwa2_type\" size=\"8\">\n"
			"<field name=\"dwa2\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dwa2\" regnum=\"%d\" bitsize=\"64\" type=\"dwa2_type\" />"}, /* regno=53 */
	{"dwa3", ""
		"<struct id=\"dwa3_type\" size=\"8\">\n"
			"<field name=\"dwa3\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dwa3\" regnum=\"%d\" bitsize=\"64\" type=\"dwa3_type\" />"}, /* regno=54 */
	{"tpcm2", ""
		"<struct id=\"tpcm2_type\" size=\"8\">\n"
			"<field name=\"tpcm_2\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"tpcm2\" regnum=\"%d\" bitsize=\"64\" type=\"tpcm2_type\" />"}, /* regno=55 */
	{"tpcmc", ""
		"<struct id=\"tpcmc_type\" size=\"8\">\n"
			"<field name=\"tpcm_pld\" start=\"0\" end=\"4\" />\n"
			"<field name=\"tpcm_sts\" start=\"5\" end=\"6\" />\n"
		"</struct>\n"
		"<reg name=\"tpcmc\" regnum=\"%d\" bitsize=\"64\" type=\"tpcmc_type\" />"}, /* regno=56 */
	{"pm4", ""
		"<struct id=\"pm4_type\" size=\"8\">\n"
			"<field name=\"pm4\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm4\" regnum=\"%d\" bitsize=\"64\" type=\"pm4_type\" />"}, /* regno=57 */
	{"pm5", ""
		"<struct id=\"pm5_type\" size=\"8\">\n"
			"<field name=\"pm5\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm5\" regnum=\"%d\" bitsize=\"64\" type=\"pm5_type\" />"}, /* regno=58 */
	{"pm6", ""
		"<struct id=\"pm6_type\" size=\"8\">\n"
			"<field name=\"pm6\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm6\" regnum=\"%d\" bitsize=\"64\" type=\"pm6_type\" />"}, /* regno=59 */
	{"pm7", ""
		"<struct id=\"pm7_type\" size=\"8\">\n"
			"<field name=\"pm7\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm7\" regnum=\"%d\" bitsize=\"64\" type=\"pm7_type\" />"}, /* regno=60 */
	{"pmc2", ""
		"<struct id=\"pmc2_type\" size=\"8\">\n"
			"<field name=\"pm4c\" start=\"0\" end=\"5\" />\n"
			"<field name=\"pm5c\" start=\"7\" end=\"12\" />\n"
			"<field name=\"pm6c\" start=\"14\" end=\"19\" />\n"
			"<field name=\"pm7c\" start=\"21\" end=\"26\" />\n"
			"<field name=\"pm4ie\" start=\"32\" end=\"32\" />\n"
			"<field name=\"pm5ie\" start=\"33\" end=\"33\" />\n"
			"<field name=\"pm6ie\" start=\"34\" end=\"34\" />\n"
			"<field name=\"pm7ie\" start=\"35\" end=\"35\" />\n"
		"</struct>\n"
		"<reg name=\"pmc2\" regnum=\"%d\" bitsize=\"64\" type=\"pmc2_type\" />"}, /* regno=61 */
	{"srhpc", ""
		"<struct id=\"srhpc_type\" size=\"8\">\n"
			"<field name=\"srhpc\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"srhpc\" regnum=\"%d\" bitsize=\"64\" type=\"srhpc_type\" />"}, /* regno=62 */
	{"frcc", "<reg name=\"frcc\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=63 */
	{"spc_pl0", "<reg name=\"spc_pl0\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=64 */
	{"spc_pl1", "<reg name=\"spc_pl1\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=65 */
	{"spc_pl2", "<reg name=\"spc_pl2\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=66 */
	{"spc_pl3", "<reg name=\"spc_pl3\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=67 */
	{"sps_pl0", ""
		"<struct id=\"sps_pl0_type\" size=\"4\">\n"
			"<field name=\"pl\" start=\"0\" end=\"1\" />\n"
			"<field name=\"et\" start=\"2\" end=\"2\" />\n"
			"<field name=\"htd\" start=\"3\" end=\"3\" />\n"
			"<field name=\"ie\" start=\"4\" end=\"4\" />\n"
			"<field name=\"hle\" start=\"5\" end=\"5\" />\n"
			"<field name=\"sre\" start=\"6\" end=\"6\" />\n"
			"<field name=\"daus\" start=\"7\" end=\"7\" />\n"
			"<field name=\"ice\" start=\"8\" end=\"8\" />\n"
			"<field name=\"use\" start=\"9\" end=\"9\" />\n"
			"<field name=\"dce\" start=\"10\" end=\"10\" />\n"
			"<field name=\"mme\" start=\"11\" end=\"11\" />\n"
			"<field name=\"il\" start=\"12\" end=\"13\" />\n"
			"<field name=\"vs\" start=\"14\" end=\"15\" />\n"
			"<field name=\"v64\" start=\"16\" end=\"16\" />\n"
			"<field name=\"l2e\" start=\"17\" end=\"17\" />\n"
			"<field name=\"sme\" start=\"18\" end=\"18\" />\n"
			"<field name=\"smr\" start=\"19\" end=\"19\" />\n"
			"<field name=\"pmj\" start=\"20\" end=\"23\" />\n"
			"<field name=\"mmup\" start=\"24\" end=\"24\" />\n"
		"</struct>\n"
		"<reg name=\"sps_pl0\" regnum=\"%d\" bitsize=\"32\" type=\"sps_pl0_type\" />"}, /* regno=68 */
	{"sps_pl1", ""
		"<struct id=\"sps_pl1_type\" size=\"4\">\n"
			"<field name=\"pl\" start=\"0\" end=\"1\" />\n"
			"<field name=\"et\" start=\"2\" end=\"2\" />\n"
			"<field name=\"htd\" start=\"3\" end=\"3\" />\n"
			"<field name=\"ie\" start=\"4\" end=\"4\" />\n"
			"<field name=\"hle\" start=\"5\" end=\"5\" />\n"
			"<field name=\"sre\" start=\"6\" end=\"6\" />\n"
			"<field name=\"daus\" start=\"7\" end=\"7\" />\n"
			"<field name=\"ice\" start=\"8\" end=\"8\" />\n"
			"<field name=\"use\" start=\"9\" end=\"9\" />\n"
			"<field name=\"dce\" start=\"10\" end=\"10\" />\n"
			"<field name=\"mme\" start=\"11\" end=\"11\" />\n"
			"<field name=\"il\" start=\"12\" end=\"13\" />\n"
			"<field name=\"vs\" start=\"14\" end=\"15\" />\n"
			"<field name=\"v64\" start=\"16\" end=\"16\" />\n"
			"<field name=\"l2e\" start=\"17\" end=\"17\" />\n"
			"<field name=\"sme\" start=\"18\" end=\"18\" />\n"
			"<field name=\"smr\" start=\"19\" end=\"19\" />\n"
			"<field name=\"pmj\" start=\"20\" end=\"23\" />\n"
			"<field name=\"mmup\" start=\"24\" end=\"24\" />\n"
		"</struct>\n"
		"<reg name=\"sps_pl1\" regnum=\"%d\" bitsize=\"32\" type=\"sps_pl1_type\" />"}, /* regno=69 */
	{"sps_pl2", ""
		"<struct id=\"sps_pl2_type\" size=\"4\">\n"
			"<field name=\"pl\" start=\"0\" end=\"1\" />\n"
			"<field name=\"et\" start=\"2\" end=\"2\" />\n"
			"<field name=\"htd\" start=\"3\" end=\"3\" />\n"
			"<field name=\"ie\" start=\"4\" end=\"4\" />\n"
			"<field name=\"hle\" start=\"5\" end=\"5\" />\n"
			"<field name=\"sre\" start=\"6\" end=\"6\" />\n"
			"<field name=\"daus\" start=\"7\" end=\"7\" />\n"
			"<field name=\"ice\" start=\"8\" end=\"8\" />\n"
			"<field name=\"use\" start=\"9\" end=\"9\" />\n"
			"<field name=\"dce\" start=\"10\" end=\"10\" />\n"
			"<field name=\"mme\" start=\"11\" end=\"11\" />\n"
			"<field name=\"il\" start=\"12\" end=\"13\" />\n"
			"<field name=\"vs\" start=\"14\" end=\"15\" />\n"
			"<field name=\"v64\" start=\"16\" end=\"16\" />\n"
			"<field name=\"l2e\" start=\"17\" end=\"17\" />\n"
			"<field name=\"sme\" start=\"18\" end=\"18\" />\n"
			"<field name=\"smr\" start=\"19\" end=\"19\" />\n"
			"<field name=\"pmj\" start=\"20\" end=\"23\" />\n"
			"<field name=\"mmup\" start=\"24\" end=\"24\" />\n"
		"</struct>\n"
		"<reg name=\"sps_pl2\" regnum=\"%d\" bitsize=\"32\" type=\"sps_pl2_type\" />"}, /* regno=70 */
	{"sps_pl3", ""
		"<struct id=\"sps_pl3_type\" size=\"4\">\n"
			"<field name=\"pl\" start=\"0\" end=\"1\" />\n"
			"<field name=\"et\" start=\"2\" end=\"2\" />\n"
			"<field name=\"htd\" start=\"3\" end=\"3\" />\n"
			"<field name=\"ie\" start=\"4\" end=\"4\" />\n"
			"<field name=\"hle\" start=\"5\" end=\"5\" />\n"
			"<field name=\"sre\" start=\"6\" end=\"6\" />\n"
			"<field name=\"daus\" start=\"7\" end=\"7\" />\n"
			"<field name=\"ice\" start=\"8\" end=\"8\" />\n"
			"<field name=\"use\" start=\"9\" end=\"9\" />\n"
			"<field name=\"dce\" start=\"10\" end=\"10\" />\n"
			"<field name=\"mme\" start=\"11\" end=\"11\" />\n"
			"<field name=\"il\" start=\"12\" end=\"13\" />\n"
			"<field name=\"vs\" start=\"14\" end=\"15\" />\n"
			"<field name=\"v64\" start=\"16\" end=\"16\" />\n"
			"<field name=\"l2e\" start=\"17\" end=\"17\" />\n"
			"<field name=\"sme\" start=\"18\" end=\"18\" />\n"
			"<field name=\"smr\" start=\"19\" end=\"19\" />\n"
			"<field name=\"pmj\" start=\"20\" end=\"23\" />\n"
			"<field name=\"mmup\" start=\"24\" end=\"24\" />\n"
		"</struct>\n"
		"<reg name=\"sps_pl3\" regnum=\"%d\" bitsize=\"32\" type=\"sps_pl3_type\" />"}, /* regno=71 */
	{"ea_pl0", "<reg name=\"ea_pl0\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=72 */
	{"ea_pl1", "<reg name=\"ea_pl1\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=73 */
	{"ea_pl2", "<reg name=\"ea_pl2\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=74 */
	{"ea_pl3", "<reg name=\"ea_pl3\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=75 */
	{"ev_pl0", "<reg name=\"ev_pl0\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=76 */
	{"ev_pl1", "<reg name=\"ev_pl1\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=77 */
	{"ev_pl2", "<reg name=\"ev_pl2\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=78 */
	{"ev_pl3", "<reg name=\"ev_pl3\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=79 */
	{"sr_pl0", "<reg name=\"sr_pl0\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=80 */
	{"sr_pl1", "<reg name=\"sr_pl1\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=81 */
	{"sr_pl2", "<reg name=\"sr_pl2\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=82 */
	{"sr_pl3", "<reg name=\"sr_pl3\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=83 */
	{"es_pl0", ""
		"<struct id=\"es_pl0_type\" size=\"8\">\n"
			"<field name=\"ec\" start=\"0\" end=\"3\" />\n"
			"<field name=\"oapl\" start=\"4\" end=\"5\" />\n"
			"<field name=\"ed\" start=\"4\" end=\"63\" />\n"
			"<field name=\"orpl\" start=\"6\" end=\"7\" />\n"
			"<field name=\"ptapl\" start=\"8\" end=\"9\" />\n"
			"<field name=\"ptrpl\" start=\"10\" end=\"11\" />\n"
			"<field name=\"dcv2\" start=\"12\" end=\"14\" />\n"
			"<field name=\"itn\" start=\"12\" end=\"16\" />\n"
			"<field name=\"htc\" start=\"12\" end=\"16\" />\n"
			"<field name=\"sn\" start=\"12\" end=\"23\" />\n"
			"<field name=\"wbn\" start=\"15\" end=\"16\" />\n"
			"<field name=\"sfrt\" start=\"17\" end=\"17\" />\n"
			"<field name=\"itl\" start=\"17\" end=\"18\" />\n"
			"<field name=\"sfri\" start=\"18\" end=\"20\" />\n"
			"<field name=\"iti\" start=\"19\" end=\"28\" />\n"
			"<field name=\"gprp\" start=\"21\" end=\"26\" />\n"
			"<field name=\"sfrp\" start=\"27\" end=\"35\" />\n"
			"<field name=\"dht\" start=\"36\" end=\"36\" />\n"
			"<field name=\"drx\" start=\"37\" end=\"37\" />\n"
			"<field name=\"daf\" start=\"38\" end=\"38\" />\n"
			"<field name=\"rwx\" start=\"39\" end=\"41\" />\n"
			"<field name=\"nta\" start=\"42\" end=\"42\" />\n"
			"<field name=\"uca\" start=\"43\" end=\"43\" />\n"
			"<field name=\"as\" start=\"44\" end=\"49\" />\n"
			"<field name=\"bs\" start=\"50\" end=\"53\" />\n"
			"<field name=\"dri\" start=\"54\" end=\"59\" />\n"
			"<field name=\"pic\" start=\"60\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"es_pl0\" regnum=\"%d\" bitsize=\"64\" type=\"es_pl0_type\" />"}, /* regno=84 */
	{"es_pl1", ""
		"<struct id=\"es_pl1_type\" size=\"8\">\n"
			"<field name=\"ec\" start=\"0\" end=\"3\" />\n"
			"<field name=\"oapl\" start=\"4\" end=\"5\" />\n"
			"<field name=\"ed\" start=\"4\" end=\"63\" />\n"
			"<field name=\"orpl\" start=\"6\" end=\"7\" />\n"
			"<field name=\"ptapl\" start=\"8\" end=\"9\" />\n"
			"<field name=\"ptrpl\" start=\"10\" end=\"11\" />\n"
			"<field name=\"dcv2\" start=\"12\" end=\"14\" />\n"
			"<field name=\"itn\" start=\"12\" end=\"16\" />\n"
			"<field name=\"htc\" start=\"12\" end=\"16\" />\n"
			"<field name=\"sn\" start=\"12\" end=\"23\" />\n"
			"<field name=\"wbn\" start=\"15\" end=\"16\" />\n"
			"<field name=\"sfrt\" start=\"17\" end=\"17\" />\n"
			"<field name=\"itl\" start=\"17\" end=\"18\" />\n"
			"<field name=\"sfri\" start=\"18\" end=\"20\" />\n"
			"<field name=\"iti\" start=\"19\" end=\"28\" />\n"
			"<field name=\"gprp\" start=\"21\" end=\"26\" />\n"
			"<field name=\"sfrp\" start=\"27\" end=\"35\" />\n"
			"<field name=\"dht\" start=\"36\" end=\"36\" />\n"
			"<field name=\"drx\" start=\"37\" end=\"37\" />\n"
			"<field name=\"daf\" start=\"38\" end=\"38\" />\n"
			"<field name=\"rwx\" start=\"39\" end=\"41\" />\n"
			"<field name=\"nta\" start=\"42\" end=\"42\" />\n"
			"<field name=\"uca\" start=\"43\" end=\"43\" />\n"
			"<field name=\"as\" start=\"44\" end=\"49\" />\n"
			"<field name=\"bs\" start=\"50\" end=\"53\" />\n"
			"<field name=\"dri\" start=\"54\" end=\"59\" />\n"
			"<field name=\"pic\" start=\"60\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"es_pl1\" regnum=\"%d\" bitsize=\"64\" type=\"es_pl1_type\" />"}, /* regno=85 */
	{"es_pl2", ""
		"<struct id=\"es_pl2_type\" size=\"8\">\n"
			"<field name=\"ec\" start=\"0\" end=\"3\" />\n"
			"<field name=\"oapl\" start=\"4\" end=\"5\" />\n"
			"<field name=\"ed\" start=\"4\" end=\"63\" />\n"
			"<field name=\"orpl\" start=\"6\" end=\"7\" />\n"
			"<field name=\"ptapl\" start=\"8\" end=\"9\" />\n"
			"<field name=\"ptrpl\" start=\"10\" end=\"11\" />\n"
			"<field name=\"dcv2\" start=\"12\" end=\"14\" />\n"
			"<field name=\"itn\" start=\"12\" end=\"16\" />\n"
			"<field name=\"htc\" start=\"12\" end=\"16\" />\n"
			"<field name=\"sn\" start=\"12\" end=\"23\" />\n"
			"<field name=\"wbn\" start=\"15\" end=\"16\" />\n"
			"<field name=\"sfrt\" start=\"17\" end=\"17\" />\n"
			"<field name=\"itl\" start=\"17\" end=\"18\" />\n"
			"<field name=\"sfri\" start=\"18\" end=\"20\" />\n"
			"<field name=\"iti\" start=\"19\" end=\"28\" />\n"
			"<field name=\"gprp\" start=\"21\" end=\"26\" />\n"
			"<field name=\"sfrp\" start=\"27\" end=\"35\" />\n"
			"<field name=\"dht\" start=\"36\" end=\"36\" />\n"
			"<field name=\"drx\" start=\"37\" end=\"37\" />\n"
			"<field name=\"daf\" start=\"38\" end=\"38\" />\n"
			"<field name=\"rwx\" start=\"39\" end=\"41\" />\n"
			"<field name=\"nta\" start=\"42\" end=\"42\" />\n"
			"<field name=\"uca\" start=\"43\" end=\"43\" />\n"
			"<field name=\"as\" start=\"44\" end=\"49\" />\n"
			"<field name=\"bs\" start=\"50\" end=\"53\" />\n"
			"<field name=\"dri\" start=\"54\" end=\"59\" />\n"
			"<field name=\"pic\" start=\"60\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"es_pl2\" regnum=\"%d\" bitsize=\"64\" type=\"es_pl2_type\" />"}, /* regno=86 */
	{"es_pl3", ""
		"<struct id=\"es_pl3_type\" size=\"8\">\n"
			"<field name=\"ec\" start=\"0\" end=\"3\" />\n"
			"<field name=\"oapl\" start=\"4\" end=\"5\" />\n"
			"<field name=\"ed\" start=\"4\" end=\"63\" />\n"
			"<field name=\"orpl\" start=\"6\" end=\"7\" />\n"
			"<field name=\"ptapl\" start=\"8\" end=\"9\" />\n"
			"<field name=\"ptrpl\" start=\"10\" end=\"11\" />\n"
			"<field name=\"dcv2\" start=\"12\" end=\"14\" />\n"
			"<field name=\"itn\" start=\"12\" end=\"16\" />\n"
			"<field name=\"htc\" start=\"12\" end=\"16\" />\n"
			"<field name=\"sn\" start=\"12\" end=\"23\" />\n"
			"<field name=\"wbn\" start=\"15\" end=\"16\" />\n"
			"<field name=\"sfrt\" start=\"17\" end=\"17\" />\n"
			"<field name=\"itl\" start=\"17\" end=\"18\" />\n"
			"<field name=\"sfri\" start=\"18\" end=\"20\" />\n"
			"<field name=\"iti\" start=\"19\" end=\"28\" />\n"
			"<field name=\"gprp\" start=\"21\" end=\"26\" />\n"
			"<field name=\"sfrp\" start=\"27\" end=\"35\" />\n"
			"<field name=\"dht\" start=\"36\" end=\"36\" />\n"
			"<field name=\"drx\" start=\"37\" end=\"37\" />\n"
			"<field name=\"daf\" start=\"38\" end=\"38\" />\n"
			"<field name=\"rwx\" start=\"39\" end=\"41\" />\n"
			"<field name=\"nta\" start=\"42\" end=\"42\" />\n"
			"<field name=\"uca\" start=\"43\" end=\"43\" />\n"
			"<field name=\"as\" start=\"44\" end=\"49\" />\n"
			"<field name=\"bs\" start=\"50\" end=\"53\" />\n"
			"<field name=\"dri\" start=\"54\" end=\"59\" />\n"
			"<field name=\"pic\" start=\"60\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"es_pl3\" regnum=\"%d\" bitsize=\"64\" type=\"es_pl3_type\" />"}, /* regno=87 */
	{"sid_pl0", ""
		"<struct id=\"sid_pl0_type\" size=\"4\">\n"
			"<field name=\"sid\" start=\"0\" end=\"8\" />\n"
		"</struct>\n"
		"<reg name=\"sid_pl0\" regnum=\"%d\" bitsize=\"32\" type=\"sid_pl0_type\" />"}, /* regno=88 */
	{"sid_pl1", ""
		"<struct id=\"sid_pl1_type\" size=\"4\">\n"
			"<field name=\"sid\" start=\"0\" end=\"8\" />\n"
		"</struct>\n"
		"<reg name=\"sid_pl1\" regnum=\"%d\" bitsize=\"32\" type=\"sid_pl1_type\" />"}, /* regno=89 */
	{"sid_pl2", ""
		"<struct id=\"sid_pl2_type\" size=\"4\">\n"
			"<field name=\"sid\" start=\"0\" end=\"8\" />\n"
		"</struct>\n"
		"<reg name=\"sid_pl2\" regnum=\"%d\" bitsize=\"32\" type=\"sid_pl2_type\" />"}, /* regno=90 */
	{"sid_pl3", ""
		"<struct id=\"sid_pl3_type\" size=\"4\">\n"
			"<field name=\"sid\" start=\"0\" end=\"8\" />\n"
		"</struct>\n"
		"<reg name=\"sid_pl3\" regnum=\"%d\" bitsize=\"32\" type=\"sid_pl3_type\" />"}, /* regno=91 */
	{"sr1_pl0", "<reg name=\"sr1_pl0\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=92 */
	{"sr1_pl1", "<reg name=\"sr1_pl1\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=93 */
	{"sr1_pl2", "<reg name=\"sr1_pl2\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=94 */
	{"sr1_pl3", "<reg name=\"sr1_pl3\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=95 */
	{"syow", ""
		"<struct id=\"syow_type\" size=\"4\">\n"
			"<field name=\"q0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"q1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"q2\" start=\"4\" end=\"5\" />\n"
			"<field name=\"q3\" start=\"6\" end=\"7\" />\n"
		"</struct>\n"
		"<reg name=\"syow\" regnum=\"%d\" bitsize=\"32\" type=\"syow_type\" />"}, /* regno=96 */
	{"htow", ""
		"<struct id=\"htow_type\" size=\"4\">\n"
			"<field name=\"opc\" start=\"0\" end=\"1\" />\n"
			"<field name=\"dmis\" start=\"2\" end=\"3\" />\n"
			"<field name=\"psys\" start=\"4\" end=\"5\" />\n"
			"<field name=\"dsys\" start=\"6\" end=\"7\" />\n"
			"<field name=\"deccg\" start=\"8\" end=\"9\" />\n"
			"<field name=\"seccg\" start=\"10\" end=\"11\" />\n"
			"<field name=\"nomap\" start=\"12\" end=\"13\" />\n"
			"<field name=\"prot\" start=\"14\" end=\"15\" />\n"
			"<field name=\"w2cl\" start=\"16\" end=\"17\" />\n"
			"<field name=\"a2cl\" start=\"18\" end=\"19\" />\n"
			"<field name=\"de\" start=\"20\" end=\"21\" />\n"
			"<field name=\"vsfr\" start=\"22\" end=\"23\" />\n"
			"<field name=\"plo\" start=\"24\" end=\"25\" />\n"
		"</struct>\n"
		"<reg name=\"htow\" regnum=\"%d\" bitsize=\"32\" type=\"htow_type\" />"}, /* regno=97 */
	{"itow", ""
		"<struct id=\"itow_type\" size=\"8\">\n"
			"<field name=\"it0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"it1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"it2\" start=\"4\" end=\"5\" />\n"
			"<field name=\"it3\" start=\"6\" end=\"7\" />\n"
			"<field name=\"it4\" start=\"8\" end=\"9\" />\n"
			"<field name=\"it5\" start=\"10\" end=\"11\" />\n"
			"<field name=\"it6\" start=\"12\" end=\"13\" />\n"
			"<field name=\"it7\" start=\"14\" end=\"15\" />\n"
			"<field name=\"it8\" start=\"16\" end=\"17\" />\n"
			"<field name=\"it9\" start=\"18\" end=\"19\" />\n"
			"<field name=\"it10\" start=\"20\" end=\"21\" />\n"
			"<field name=\"it11\" start=\"22\" end=\"23\" />\n"
			"<field name=\"it12\" start=\"24\" end=\"25\" />\n"
			"<field name=\"it13\" start=\"26\" end=\"27\" />\n"
			"<field name=\"it14\" start=\"28\" end=\"29\" />\n"
			"<field name=\"it15\" start=\"30\" end=\"31\" />\n"
			"<field name=\"it16\" start=\"32\" end=\"33\" />\n"
			"<field name=\"it17\" start=\"34\" end=\"35\" />\n"
			"<field name=\"it18\" start=\"36\" end=\"37\" />\n"
			"<field name=\"it19\" start=\"38\" end=\"39\" />\n"
			"<field name=\"it20\" start=\"40\" end=\"41\" />\n"
			"<field name=\"it21\" start=\"42\" end=\"43\" />\n"
			"<field name=\"it22\" start=\"44\" end=\"45\" />\n"
			"<field name=\"it23\" start=\"46\" end=\"47\" />\n"
			"<field name=\"it24\" start=\"48\" end=\"49\" />\n"
			"<field name=\"it25\" start=\"50\" end=\"51\" />\n"
			"<field name=\"it26\" start=\"52\" end=\"53\" />\n"
			"<field name=\"it27\" start=\"54\" end=\"55\" />\n"
			"<field name=\"it28\" start=\"56\" end=\"57\" />\n"
			"<field name=\"it29\" start=\"58\" end=\"59\" />\n"
			"<field name=\"it30\" start=\"60\" end=\"61\" />\n"
			"<field name=\"it31\" start=\"62\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"itow\" regnum=\"%d\" bitsize=\"64\" type=\"itow_type\" />"}, /* regno=98 */
	{"dow", ""
		"<struct id=\"dow_type\" size=\"4\">\n"
			"<field name=\"b0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"b1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"w0\" start=\"4\" end=\"5\" />\n"
			"<field name=\"w1\" start=\"6\" end=\"7\" />\n"
			"<field name=\"b2\" start=\"8\" end=\"9\" />\n"
			"<field name=\"b3\" start=\"10\" end=\"11\" />\n"
			"<field name=\"w2\" start=\"12\" end=\"13\" />\n"
			"<field name=\"w3\" start=\"14\" end=\"15\" />\n"
			"<field name=\"bi0\" start=\"16\" end=\"17\" />\n"
			"<field name=\"bi1\" start=\"18\" end=\"19\" />\n"
			"<field name=\"bi2\" start=\"20\" end=\"21\" />\n"
			"<field name=\"bi3\" start=\"22\" end=\"23\" />\n"
		"</struct>\n"
		"<reg name=\"dow\" regnum=\"%d\" bitsize=\"32\" type=\"dow_type\" />"}, /* regno=99 */
	{"mow", ""
		"<struct id=\"mow_type\" size=\"8\">\n"
			"<field name=\"mmi\" start=\"0\" end=\"1\" />\n"
			"<field name=\"rfe\" start=\"2\" end=\"3\" />\n"
			"<field name=\"stop\" start=\"4\" end=\"5\" />\n"
			"<field name=\"sync\" start=\"6\" end=\"7\" />\n"
			"<field name=\"pcr\" start=\"8\" end=\"9\" />\n"
			"<field name=\"msg\" start=\"10\" end=\"11\" />\n"
			"<field name=\"men\" start=\"12\" end=\"13\" />\n"
			"<field name=\"mes\" start=\"14\" end=\"15\" />\n"
			"<field name=\"csit\" start=\"16\" end=\"17\" />\n"
			"<field name=\"t0\" start=\"18\" end=\"19\" />\n"
			"<field name=\"t1\" start=\"20\" end=\"21\" />\n"
			"<field name=\"wd\" start=\"22\" end=\"23\" />\n"
			"<field name=\"pm0\" start=\"24\" end=\"25\" />\n"
			"<field name=\"pm1\" start=\"26\" end=\"27\" />\n"
			"<field name=\"pm2\" start=\"28\" end=\"29\" />\n"
			"<field name=\"pm3\" start=\"30\" end=\"31\" />\n"
			"<field name=\"pmit\" start=\"32\" end=\"33\" />\n"
			"<field name=\"comm\" start=\"34\" end=\"35\" />\n"
			"<field name=\"tpcm\" start=\"36\" end=\"37\" />\n"
			"<field name=\"disw\" start=\"38\" end=\"39\" />\n"
			"<field name=\"pm4\" start=\"40\" end=\"41\" />\n"
			"<field name=\"pm5\" start=\"42\" end=\"43\" />\n"
			"<field name=\"pm6\" start=\"44\" end=\"45\" />\n"
			"<field name=\"pm7\" start=\"46\" end=\"47\" />\n"
			"<field name=\"srhpc\" start=\"48\" end=\"49\" />\n"
		"</struct>\n"
		"<reg name=\"mow\" regnum=\"%d\" bitsize=\"64\" type=\"mow_type\" />"}, /* regno=100 */
	{"psow", ""
		"<struct id=\"psow_type\" size=\"8\">\n"
			"<field name=\"pl0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"pl1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"et\" start=\"4\" end=\"5\" />\n"
			"<field name=\"htd\" start=\"6\" end=\"7\" />\n"
			"<field name=\"ie\" start=\"8\" end=\"9\" />\n"
			"<field name=\"hle\" start=\"10\" end=\"11\" />\n"
			"<field name=\"sre\" start=\"12\" end=\"13\" />\n"
			"<field name=\"daus\" start=\"14\" end=\"15\" />\n"
			"<field name=\"ice\" start=\"16\" end=\"17\" />\n"
			"<field name=\"use\" start=\"18\" end=\"19\" />\n"
			"<field name=\"dce\" start=\"20\" end=\"21\" />\n"
			"<field name=\"mme\" start=\"22\" end=\"23\" />\n"
			"<field name=\"il0\" start=\"24\" end=\"25\" />\n"
			"<field name=\"il1\" start=\"26\" end=\"27\" />\n"
			"<field name=\"vs0\" start=\"28\" end=\"29\" />\n"
			"<field name=\"vs1\" start=\"30\" end=\"31\" />\n"
			"<field name=\"l2e\" start=\"34\" end=\"35\" />\n"
			"<field name=\"sme\" start=\"36\" end=\"37\" />\n"
			"<field name=\"smr\" start=\"38\" end=\"39\" />\n"
			"<field name=\"pmj0\" start=\"40\" end=\"41\" />\n"
			"<field name=\"pmj1\" start=\"42\" end=\"43\" />\n"
			"<field name=\"pmj2\" start=\"44\" end=\"45\" />\n"
			"<field name=\"pmj3\" start=\"46\" end=\"47\" />\n"
			"<field name=\"mmup\" start=\"48\" end=\"49\" />\n"
		"</struct>\n"
		"<reg name=\"psow\" regnum=\"%d\" bitsize=\"64\" type=\"psow_type\" />"}, /* regno=101 */
	{"res102", "<reg name=\"res102\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=102 */
	{"res103", "<reg name=\"res103\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=103 */
	{"tpcc_pl0", ""
		"<struct id=\"tpcc_pl0_type\" size=\"4\">\n"
			"<field name=\"tpcc\" start=\"0\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"tpcc_pl0\" regnum=\"%d\" bitsize=\"32\" type=\"tpcc_pl0_type\" />"}, /* regno=104 */
	{"tpcc_pl1", ""
		"<struct id=\"tpcc_pl1_type\" size=\"4\">\n"
			"<field name=\"tpcc\" start=\"0\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"tpcc_pl1\" regnum=\"%d\" bitsize=\"32\" type=\"tpcc_pl1_type\" />"}, /* regno=105 */
	{"tpcc_pl2", ""
		"<struct id=\"tpcc_pl2_type\" size=\"4\">\n"
			"<field name=\"tpcc\" start=\"0\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"tpcc_pl2\" regnum=\"%d\" bitsize=\"32\" type=\"tpcc_pl2_type\" />"}, /* regno=106 */
	{"tpcc_pl3", ""
		"<struct id=\"tpcc_pl3_type\" size=\"4\">\n"
			"<field name=\"tpcc\" start=\"0\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"tpcc_pl3\" regnum=\"%d\" bitsize=\"32\" type=\"tpcc_pl3_type\" />"}, /* regno=107 */
	{"res108", "<reg name=\"res108\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=108 */
	{"res109", "<reg name=\"res109\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=109 */
	{"res110", "<reg name=\"res110\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=110 */
	{"res111", "<reg name=\"res111\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=111 */
	{"res112", "<reg name=\"res112\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=112 */
	{"res113", "<reg name=\"res113\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=113 */
	{"res114", "<reg name=\"res114\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=114 */
	{"res115", "<reg name=\"res115\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=115 */
	{"res116", "<reg name=\"res116\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=116 */
	{"res117", "<reg name=\"res117\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=117 */
	{"res118", "<reg name=\"res118\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=118 */
	{"res119", "<reg name=\"res119\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=119 */
	{"res120", "<reg name=\"res120\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=120 */
	{"res121", "<reg name=\"res121\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=121 */
	{"res122", "<reg name=\"res122\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=122 */
	{"res123", "<reg name=\"res123\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=123 */
	{"res124", "<reg name=\"res124\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=124 */
	{"res125", "<reg name=\"res125\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=125 */
	{"res126", "<reg name=\"res126\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=126 */
	{"res127", "<reg name=\"res127\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=127 */
	{"spc", "<reg name=\"spc\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=128 */
	{"res129", "<reg name=\"res129\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=129 */
	{"res130", "<reg name=\"res130\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=130 */
	{"res131", "<reg name=\"res131\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=131 */
	{"sps", ""
		"<struct id=\"sps_type\" size=\"4\">\n"
			"<field name=\"pl\" start=\"0\" end=\"1\" />\n"
			"<field name=\"et\" start=\"2\" end=\"2\" />\n"
			"<field name=\"htd\" start=\"3\" end=\"3\" />\n"
			"<field name=\"ie\" start=\"4\" end=\"4\" />\n"
			"<field name=\"hle\" start=\"5\" end=\"5\" />\n"
			"<field name=\"sre\" start=\"6\" end=\"6\" />\n"
			"<field name=\"daus\" start=\"7\" end=\"7\" />\n"
			"<field name=\"ice\" start=\"8\" end=\"8\" />\n"
			"<field name=\"use\" start=\"9\" end=\"9\" />\n"
			"<field name=\"dce\" start=\"10\" end=\"10\" />\n"
			"<field name=\"mme\" start=\"11\" end=\"11\" />\n"
			"<field name=\"il\" start=\"12\" end=\"13\" />\n"
			"<field name=\"vs\" start=\"14\" end=\"15\" />\n"
			"<field name=\"v64\" start=\"16\" end=\"16\" />\n"
			"<field name=\"l2e\" start=\"17\" end=\"17\" />\n"
			"<field name=\"sme\" start=\"18\" end=\"18\" />\n"
			"<field name=\"smr\" start=\"19\" end=\"19\" />\n"
			"<field name=\"pmj\" start=\"20\" end=\"23\" />\n"
			"<field name=\"mmup\" start=\"24\" end=\"24\" />\n"
		"</struct>\n"
		"<reg name=\"sps\" regnum=\"%d\" bitsize=\"32\" type=\"sps_type\" />"}, /* regno=132 */
	{"res133", "<reg name=\"res133\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=133 */
	{"res134", "<reg name=\"res134\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=134 */
	{"res135", "<reg name=\"res135\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=135 */
	{"ea", "<reg name=\"ea\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=136 */
	{"res137", "<reg name=\"res137\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=137 */
	{"res138", "<reg name=\"res138\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=138 */
	{"res139", "<reg name=\"res139\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=139 */
	{"ev", "<reg name=\"ev\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=140 */
	{"res141", "<reg name=\"res141\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=141 */
	{"res142", "<reg name=\"res142\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=142 */
	{"res143", "<reg name=\"res143\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=143 */
	{"sr", "<reg name=\"sr\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=144 */
	{"res145", "<reg name=\"res145\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=145 */
	{"res146", "<reg name=\"res146\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=146 */
	{"res147", "<reg name=\"res147\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=147 */
	{"es", ""
		"<struct id=\"es_type\" size=\"8\">\n"
			"<field name=\"ec\" start=\"0\" end=\"3\" />\n"
			"<field name=\"oapl\" start=\"4\" end=\"5\" />\n"
			"<field name=\"ed\" start=\"4\" end=\"63\" />\n"
			"<field name=\"orpl\" start=\"6\" end=\"7\" />\n"
			"<field name=\"ptapl\" start=\"8\" end=\"9\" />\n"
			"<field name=\"ptrpl\" start=\"10\" end=\"11\" />\n"
			"<field name=\"dcv2\" start=\"12\" end=\"14\" />\n"
			"<field name=\"itn\" start=\"12\" end=\"16\" />\n"
			"<field name=\"htc\" start=\"12\" end=\"16\" />\n"
			"<field name=\"sn\" start=\"12\" end=\"23\" />\n"
			"<field name=\"wbn\" start=\"15\" end=\"16\" />\n"
			"<field name=\"sfrt\" start=\"17\" end=\"17\" />\n"
			"<field name=\"itl\" start=\"17\" end=\"18\" />\n"
			"<field name=\"sfri\" start=\"18\" end=\"20\" />\n"
			"<field name=\"iti\" start=\"19\" end=\"28\" />\n"
			"<field name=\"gprp\" start=\"21\" end=\"26\" />\n"
			"<field name=\"sfrp\" start=\"27\" end=\"35\" />\n"
			"<field name=\"dht\" start=\"36\" end=\"36\" />\n"
			"<field name=\"drx\" start=\"37\" end=\"37\" />\n"
			"<field name=\"daf\" start=\"38\" end=\"38\" />\n"
			"<field name=\"rwx\" start=\"39\" end=\"41\" />\n"
			"<field name=\"nta\" start=\"42\" end=\"42\" />\n"
			"<field name=\"uca\" start=\"43\" end=\"43\" />\n"
			"<field name=\"as\" start=\"44\" end=\"49\" />\n"
			"<field name=\"bs\" start=\"50\" end=\"53\" />\n"
			"<field name=\"dri\" start=\"54\" end=\"59\" />\n"
			"<field name=\"pic\" start=\"60\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"es\" regnum=\"%d\" bitsize=\"64\" type=\"es_type\" />"}, /* regno=148 */
	{"res149", "<reg name=\"res149\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=149 */
	{"res150", "<reg name=\"res150\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=150 */
	{"res151", "<reg name=\"res151\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=151 */
	{"sid", ""
		"<struct id=\"sid_type\" size=\"4\">\n"
			"<field name=\"sid\" start=\"0\" end=\"8\" />\n"
		"</struct>\n"
		"<reg name=\"sid\" regnum=\"%d\" bitsize=\"32\" type=\"sid_type\" />"}, /* regno=152 */
	{"res153", "<reg name=\"res153\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=153 */
	{"res154", "<reg name=\"res154\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=154 */
	{"res155", "<reg name=\"res155\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=155 */
	{"sr1", "<reg name=\"sr1\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=156 */
	{"res157", "<reg name=\"res157\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=157 */
	{"res158", "<reg name=\"res158\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=158 */
	{"res159", "<reg name=\"res159\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=159 */
	{"res160", "<reg name=\"res160\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=160 */
	{"res161", "<reg name=\"res161\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=161 */
	{"res162", "<reg name=\"res162\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=162 */
	{"res163", "<reg name=\"res163\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=163 */
	{"res164", "<reg name=\"res164\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=164 */
	{"res165", "<reg name=\"res165\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=165 */
	{"res166", "<reg name=\"res166\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=166 */
	{"res167", "<reg name=\"res167\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=167 */
	{"tpcc", ""
		"<struct id=\"tpcc_type\" size=\"4\">\n"
			"<field name=\"tpcc\" start=\"0\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"tpcc\" regnum=\"%d\" bitsize=\"32\" type=\"tpcc_type\" />"}, /* regno=168 */
	{"res169", "<reg name=\"res169\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=169 */
	{"res170", "<reg name=\"res170\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=170 */
	{"res171", "<reg name=\"res171\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=171 */
	{"res172", "<reg name=\"res172\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=172 */
	{"res173", "<reg name=\"res173\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=173 */
	{"res174", "<reg name=\"res174\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=174 */
	{"res175", "<reg name=\"res175\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=175 */
	{"res176", "<reg name=\"res176\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=176 */
	{"res177", "<reg name=\"res177\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=177 */
	{"res178", "<reg name=\"res178\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=178 */
	{"res179", "<reg name=\"res179\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=179 */
	{"res180", "<reg name=\"res180\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=180 */
	{"res181", "<reg name=\"res181\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=181 */
	{"res182", "<reg name=\"res182\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=182 */
	{"res183", "<reg name=\"res183\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=183 */
	{"res184", "<reg name=\"res184\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=184 */
	{"res185", "<reg name=\"res185\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=185 */
	{"res186", "<reg name=\"res186\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=186 */
	{"res187", "<reg name=\"res187\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=187 */
	{"res188", "<reg name=\"res188\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=188 */
	{"res189", "<reg name=\"res189\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=189 */
	{"res190", "<reg name=\"res190\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=190 */
	{"res191", "<reg name=\"res191\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=191 */
	{"r0", "<reg name=\"r0\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=192 */
	{"r1", "<reg name=\"r1\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=193 */
	{"r2", "<reg name=\"r2\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=194 */
	{"r3", "<reg name=\"r3\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=195 */
	{"r4", "<reg name=\"r4\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=196 */
	{"r5", "<reg name=\"r5\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=197 */
	{"r6", "<reg name=\"r6\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=198 */
	{"r7", "<reg name=\"r7\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=199 */
	{"r8", "<reg name=\"r8\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=200 */
	{"r9", "<reg name=\"r9\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=201 */
	{"r10", "<reg name=\"r10\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=202 */
	{"r11", "<reg name=\"r11\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=203 */
	{"r12", "<reg name=\"r12\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=204 */
	{"r13", "<reg name=\"r13\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=205 */
	{"r14", "<reg name=\"r14\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=206 */
	{"r15", "<reg name=\"r15\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=207 */
	{"r16", "<reg name=\"r16\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=208 */
	{"r17", "<reg name=\"r17\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=209 */
	{"r18", "<reg name=\"r18\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=210 */
	{"r19", "<reg name=\"r19\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=211 */
	{"r20", "<reg name=\"r20\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=212 */
	{"r21", "<reg name=\"r21\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=213 */
	{"r22", "<reg name=\"r22\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=214 */
	{"r23", "<reg name=\"r23\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=215 */
	{"r24", "<reg name=\"r24\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=216 */
	{"r25", "<reg name=\"r25\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=217 */
	{"r26", "<reg name=\"r26\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=218 */
	{"r27", "<reg name=\"r27\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=219 */
	{"r28", "<reg name=\"r28\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=220 */
	{"r29", "<reg name=\"r29\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=221 */
	{"r30", "<reg name=\"r30\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=222 */
	{"r31", "<reg name=\"r31\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=223 */
	{"r32", "<reg name=\"r32\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=224 */
	{"r33", "<reg name=\"r33\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=225 */
	{"r34", "<reg name=\"r34\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=226 */
	{"r35", "<reg name=\"r35\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=227 */
	{"r36", "<reg name=\"r36\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=228 */
	{"r37", "<reg name=\"r37\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=229 */
	{"r38", "<reg name=\"r38\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=230 */
	{"r39", "<reg name=\"r39\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=231 */
	{"r40", "<reg name=\"r40\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=232 */
	{"r41", "<reg name=\"r41\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=233 */
	{"r42", "<reg name=\"r42\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=234 */
	{"r43", "<reg name=\"r43\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=235 */
	{"r44", "<reg name=\"r44\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=236 */
	{"r45", "<reg name=\"r45\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=237 */
	{"r46", "<reg name=\"r46\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=238 */
	{"r47", "<reg name=\"r47\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=239 */
	{"r48", "<reg name=\"r48\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=240 */
	{"r49", "<reg name=\"r49\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=241 */
	{"r50", "<reg name=\"r50\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=242 */
	{"r51", "<reg name=\"r51\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=243 */
	{"r52", "<reg name=\"r52\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=244 */
	{"r53", "<reg name=\"r53\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=245 */
	{"r54", "<reg name=\"r54\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=246 */
	{"r55", "<reg name=\"r55\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=247 */
	{"r56", "<reg name=\"r56\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=248 */
	{"r57", "<reg name=\"r57\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=249 */
	{"r58", "<reg name=\"r58\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=250 */
	{"r59", "<reg name=\"r59\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=251 */
	{"r60", "<reg name=\"r60\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=252 */
	{"r61", "<reg name=\"r61\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=253 */
	{"r62", "<reg name=\"r62\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=254 */
	{"r63", "<reg name=\"r63\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=255 */
	{"a0_x", "<reg name=\"a0_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=256 */
	{"a0_y", "<reg name=\"a0_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=257 */
	{"a0_z", "<reg name=\"a0_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=258 */
	{"a0_t", "<reg name=\"a0_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=259 */
	{"a1_x", "<reg name=\"a1_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=260 */
	{"a1_y", "<reg name=\"a1_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=261 */
	{"a1_z", "<reg name=\"a1_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=262 */
	{"a1_t", "<reg name=\"a1_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=263 */
	{"a2_x", "<reg name=\"a2_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=264 */
	{"a2_y", "<reg name=\"a2_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=265 */
	{"a2_z", "<reg name=\"a2_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=266 */
	{"a2_t", "<reg name=\"a2_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=267 */
	{"a3_x", "<reg name=\"a3_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=268 */
	{"a3_y", "<reg name=\"a3_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=269 */
	{"a3_z", "<reg name=\"a3_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=270 */
	{"a3_t", "<reg name=\"a3_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=271 */
	{"a4_x", "<reg name=\"a4_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=272 */
	{"a4_y", "<reg name=\"a4_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=273 */
	{"a4_z", "<reg name=\"a4_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=274 */
	{"a4_t", "<reg name=\"a4_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=275 */
	{"a5_x", "<reg name=\"a5_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=276 */
	{"a5_y", "<reg name=\"a5_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=277 */
	{"a5_z", "<reg name=\"a5_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=278 */
	{"a5_t", "<reg name=\"a5_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=279 */
	{"a6_x", "<reg name=\"a6_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=280 */
	{"a6_y", "<reg name=\"a6_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=281 */
	{"a6_z", "<reg name=\"a6_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=282 */
	{"a6_t", "<reg name=\"a6_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=283 */
	{"a7_x", "<reg name=\"a7_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=284 */
	{"a7_y", "<reg name=\"a7_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=285 */
	{"a7_z", "<reg name=\"a7_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=286 */
	{"a7_t", "<reg name=\"a7_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=287 */
	{"a8_x", "<reg name=\"a8_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=288 */
	{"a8_y", "<reg name=\"a8_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=289 */
	{"a8_z", "<reg name=\"a8_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=290 */
	{"a8_t", "<reg name=\"a8_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=291 */
	{"a9_x", "<reg name=\"a9_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=292 */
	{"a9_y", "<reg name=\"a9_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=293 */
	{"a9_z", "<reg name=\"a9_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=294 */
	{"a9_t", "<reg name=\"a9_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=295 */
	{"a10_x", "<reg name=\"a10_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=296 */
	{"a10_y", "<reg name=\"a10_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=297 */
	{"a10_z", "<reg name=\"a10_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=298 */
	{"a10_t", "<reg name=\"a10_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=299 */
	{"a11_x", "<reg name=\"a11_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=300 */
	{"a11_y", "<reg name=\"a11_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=301 */
	{"a11_z", "<reg name=\"a11_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=302 */
	{"a11_t", "<reg name=\"a11_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=303 */
	{"a12_x", "<reg name=\"a12_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=304 */
	{"a12_y", "<reg name=\"a12_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=305 */
	{"a12_z", "<reg name=\"a12_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=306 */
	{"a12_t", "<reg name=\"a12_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=307 */
	{"a13_x", "<reg name=\"a13_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=308 */
	{"a13_y", "<reg name=\"a13_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=309 */
	{"a13_z", "<reg name=\"a13_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=310 */
	{"a13_t", "<reg name=\"a13_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=311 */
	{"a14_x", "<reg name=\"a14_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=312 */
	{"a14_y", "<reg name=\"a14_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=313 */
	{"a14_z", "<reg name=\"a14_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=314 */
	{"a14_t", "<reg name=\"a14_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=315 */
	{"a15_x", "<reg name=\"a15_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=316 */
	{"a15_y", "<reg name=\"a15_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=317 */
	{"a15_z", "<reg name=\"a15_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=318 */
	{"a15_t", "<reg name=\"a15_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=319 */
	{"a16_x", "<reg name=\"a16_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=320 */
	{"a16_y", "<reg name=\"a16_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=321 */
	{"a16_z", "<reg name=\"a16_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=322 */
	{"a16_t", "<reg name=\"a16_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=323 */
	{"a17_x", "<reg name=\"a17_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=324 */
	{"a17_y", "<reg name=\"a17_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=325 */
	{"a17_z", "<reg name=\"a17_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=326 */
	{"a17_t", "<reg name=\"a17_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=327 */
	{"a18_x", "<reg name=\"a18_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=328 */
	{"a18_y", "<reg name=\"a18_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=329 */
	{"a18_z", "<reg name=\"a18_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=330 */
	{"a18_t", "<reg name=\"a18_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=331 */
	{"a19_x", "<reg name=\"a19_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=332 */
	{"a19_y", "<reg name=\"a19_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=333 */
	{"a19_z", "<reg name=\"a19_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=334 */
	{"a19_t", "<reg name=\"a19_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=335 */
	{"a20_x", "<reg name=\"a20_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=336 */
	{"a20_y", "<reg name=\"a20_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=337 */
	{"a20_z", "<reg name=\"a20_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=338 */
	{"a20_t", "<reg name=\"a20_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=339 */
	{"a21_x", "<reg name=\"a21_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=340 */
	{"a21_y", "<reg name=\"a21_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=341 */
	{"a21_z", "<reg name=\"a21_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=342 */
	{"a21_t", "<reg name=\"a21_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=343 */
	{"a22_x", "<reg name=\"a22_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=344 */
	{"a22_y", "<reg name=\"a22_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=345 */
	{"a22_z", "<reg name=\"a22_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=346 */
	{"a22_t", "<reg name=\"a22_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=347 */
	{"a23_x", "<reg name=\"a23_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=348 */
	{"a23_y", "<reg name=\"a23_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=349 */
	{"a23_z", "<reg name=\"a23_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=350 */
	{"a23_t", "<reg name=\"a23_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=351 */
	{"a24_x", "<reg name=\"a24_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=352 */
	{"a24_y", "<reg name=\"a24_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=353 */
	{"a24_z", "<reg name=\"a24_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=354 */
	{"a24_t", "<reg name=\"a24_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=355 */
	{"a25_x", "<reg name=\"a25_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=356 */
	{"a25_y", "<reg name=\"a25_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=357 */
	{"a25_z", "<reg name=\"a25_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=358 */
	{"a25_t", "<reg name=\"a25_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=359 */
	{"a26_x", "<reg name=\"a26_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=360 */
	{"a26_y", "<reg name=\"a26_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=361 */
	{"a26_z", "<reg name=\"a26_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=362 */
	{"a26_t", "<reg name=\"a26_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=363 */
	{"a27_x", "<reg name=\"a27_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=364 */
	{"a27_y", "<reg name=\"a27_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=365 */
	{"a27_z", "<reg name=\"a27_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=366 */
	{"a27_t", "<reg name=\"a27_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=367 */
	{"a28_x", "<reg name=\"a28_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=368 */
	{"a28_y", "<reg name=\"a28_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=369 */
	{"a28_z", "<reg name=\"a28_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=370 */
	{"a28_t", "<reg name=\"a28_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=371 */
	{"a29_x", "<reg name=\"a29_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=372 */
	{"a29_y", "<reg name=\"a29_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=373 */
	{"a29_z", "<reg name=\"a29_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=374 */
	{"a29_t", "<reg name=\"a29_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=375 */
	{"a30_x", "<reg name=\"a30_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=376 */
	{"a30_y", "<reg name=\"a30_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=377 */
	{"a30_z", "<reg name=\"a30_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=378 */
	{"a30_t", "<reg name=\"a30_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=379 */
	{"a31_x", "<reg name=\"a31_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=380 */
	{"a31_y", "<reg name=\"a31_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=381 */
	{"a31_z", "<reg name=\"a31_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=382 */
	{"a31_t", "<reg name=\"a31_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=383 */
	{"a32_x", "<reg name=\"a32_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=384 */
	{"a32_y", "<reg name=\"a32_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=385 */
	{"a32_z", "<reg name=\"a32_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=386 */
	{"a32_t", "<reg name=\"a32_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=387 */
	{"a33_x", "<reg name=\"a33_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=388 */
	{"a33_y", "<reg name=\"a33_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=389 */
	{"a33_z", "<reg name=\"a33_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=390 */
	{"a33_t", "<reg name=\"a33_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=391 */
	{"a34_x", "<reg name=\"a34_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=392 */
	{"a34_y", "<reg name=\"a34_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=393 */
	{"a34_z", "<reg name=\"a34_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=394 */
	{"a34_t", "<reg name=\"a34_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=395 */
	{"a35_x", "<reg name=\"a35_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=396 */
	{"a35_y", "<reg name=\"a35_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=397 */
	{"a35_z", "<reg name=\"a35_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=398 */
	{"a35_t", "<reg name=\"a35_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=399 */
	{"a36_x", "<reg name=\"a36_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=400 */
	{"a36_y", "<reg name=\"a36_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=401 */
	{"a36_z", "<reg name=\"a36_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=402 */
	{"a36_t", "<reg name=\"a36_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=403 */
	{"a37_x", "<reg name=\"a37_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=404 */
	{"a37_y", "<reg name=\"a37_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=405 */
	{"a37_z", "<reg name=\"a37_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=406 */
	{"a37_t", "<reg name=\"a37_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=407 */
	{"a38_x", "<reg name=\"a38_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=408 */
	{"a38_y", "<reg name=\"a38_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=409 */
	{"a38_z", "<reg name=\"a38_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=410 */
	{"a38_t", "<reg name=\"a38_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=411 */
	{"a39_x", "<reg name=\"a39_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=412 */
	{"a39_y", "<reg name=\"a39_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=413 */
	{"a39_z", "<reg name=\"a39_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=414 */
	{"a39_t", "<reg name=\"a39_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=415 */
	{"a40_x", "<reg name=\"a40_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=416 */
	{"a40_y", "<reg name=\"a40_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=417 */
	{"a40_z", "<reg name=\"a40_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=418 */
	{"a40_t", "<reg name=\"a40_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=419 */
	{"a41_x", "<reg name=\"a41_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=420 */
	{"a41_y", "<reg name=\"a41_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=421 */
	{"a41_z", "<reg name=\"a41_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=422 */
	{"a41_t", "<reg name=\"a41_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=423 */
	{"a42_x", "<reg name=\"a42_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=424 */
	{"a42_y", "<reg name=\"a42_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=425 */
	{"a42_z", "<reg name=\"a42_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=426 */
	{"a42_t", "<reg name=\"a42_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=427 */
	{"a43_x", "<reg name=\"a43_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=428 */
	{"a43_y", "<reg name=\"a43_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=429 */
	{"a43_z", "<reg name=\"a43_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=430 */
	{"a43_t", "<reg name=\"a43_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=431 */
	{"a44_x", "<reg name=\"a44_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=432 */
	{"a44_y", "<reg name=\"a44_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=433 */
	{"a44_z", "<reg name=\"a44_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=434 */
	{"a44_t", "<reg name=\"a44_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=435 */
	{"a45_x", "<reg name=\"a45_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=436 */
	{"a45_y", "<reg name=\"a45_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=437 */
	{"a45_z", "<reg name=\"a45_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=438 */
	{"a45_t", "<reg name=\"a45_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=439 */
	{"a46_x", "<reg name=\"a46_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=440 */
	{"a46_y", "<reg name=\"a46_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=441 */
	{"a46_z", "<reg name=\"a46_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=442 */
	{"a46_t", "<reg name=\"a46_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=443 */
	{"a47_x", "<reg name=\"a47_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=444 */
	{"a47_y", "<reg name=\"a47_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=445 */
	{"a47_z", "<reg name=\"a47_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=446 */
	{"a47_t", "<reg name=\"a47_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=447 */
	{"a48_x", "<reg name=\"a48_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=448 */
	{"a48_y", "<reg name=\"a48_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=449 */
	{"a48_z", "<reg name=\"a48_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=450 */
	{"a48_t", "<reg name=\"a48_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=451 */
	{"a49_x", "<reg name=\"a49_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=452 */
	{"a49_y", "<reg name=\"a49_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=453 */
	{"a49_z", "<reg name=\"a49_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=454 */
	{"a49_t", "<reg name=\"a49_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=455 */
	{"a50_x", "<reg name=\"a50_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=456 */
	{"a50_y", "<reg name=\"a50_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=457 */
	{"a50_z", "<reg name=\"a50_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=458 */
	{"a50_t", "<reg name=\"a50_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=459 */
	{"a51_x", "<reg name=\"a51_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=460 */
	{"a51_y", "<reg name=\"a51_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=461 */
	{"a51_z", "<reg name=\"a51_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=462 */
	{"a51_t", "<reg name=\"a51_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=463 */
	{"a52_x", "<reg name=\"a52_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=464 */
	{"a52_y", "<reg name=\"a52_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=465 */
	{"a52_z", "<reg name=\"a52_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=466 */
	{"a52_t", "<reg name=\"a52_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=467 */
	{"a53_x", "<reg name=\"a53_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=468 */
	{"a53_y", "<reg name=\"a53_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=469 */
	{"a53_z", "<reg name=\"a53_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=470 */
	{"a53_t", "<reg name=\"a53_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=471 */
	{"a54_x", "<reg name=\"a54_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=472 */
	{"a54_y", "<reg name=\"a54_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=473 */
	{"a54_z", "<reg name=\"a54_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=474 */
	{"a54_t", "<reg name=\"a54_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=475 */
	{"a55_x", "<reg name=\"a55_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=476 */
	{"a55_y", "<reg name=\"a55_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=477 */
	{"a55_z", "<reg name=\"a55_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=478 */
	{"a55_t", "<reg name=\"a55_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=479 */
	{"a56_x", "<reg name=\"a56_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=480 */
	{"a56_y", "<reg name=\"a56_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=481 */
	{"a56_z", "<reg name=\"a56_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=482 */
	{"a56_t", "<reg name=\"a56_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=483 */
	{"a57_x", "<reg name=\"a57_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=484 */
	{"a57_y", "<reg name=\"a57_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=485 */
	{"a57_z", "<reg name=\"a57_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=486 */
	{"a57_t", "<reg name=\"a57_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=487 */
	{"a58_x", "<reg name=\"a58_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=488 */
	{"a58_y", "<reg name=\"a58_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=489 */
	{"a58_z", "<reg name=\"a58_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=490 */
	{"a58_t", "<reg name=\"a58_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=491 */
	{"a59_x", "<reg name=\"a59_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=492 */
	{"a59_y", "<reg name=\"a59_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=493 */
	{"a59_z", "<reg name=\"a59_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=494 */
	{"a59_t", "<reg name=\"a59_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=495 */
	{"a60_x", "<reg name=\"a60_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=496 */
	{"a60_y", "<reg name=\"a60_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=497 */
	{"a60_z", "<reg name=\"a60_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=498 */
	{"a60_t", "<reg name=\"a60_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=499 */
	{"a61_x", "<reg name=\"a61_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=500 */
	{"a61_y", "<reg name=\"a61_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=501 */
	{"a61_z", "<reg name=\"a61_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=502 */
	{"a61_t", "<reg name=\"a61_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=503 */
	{"a62_x", "<reg name=\"a62_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=504 */
	{"a62_y", "<reg name=\"a62_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=505 */
	{"a62_z", "<reg name=\"a62_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=506 */
	{"a62_t", "<reg name=\"a62_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=507 */
	{"a63_x", "<reg name=\"a63_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=508 */
	{"a63_y", "<reg name=\"a63_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=509 */
	{"a63_z", "<reg name=\"a63_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=510 */
	{"a63_t", "<reg name=\"a63_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=511 */
	{0},
};

int lvx_v1_mds_registers_size[] = {
	64 /*pc*/,32 /*ps*/,64 /*pcr*/,64 /*ra*/,64 /*cs*/,32 /*csit*/,64 /*aespc*/,64 /*ls*/,64 /*le*/,64 /*lc*/,
	64 /*ipe*/,64 /*men*/,64 /*pmc*/,64 /*pm0*/,64 /*pm1*/,64 /*pm2*/,64 /*pm3*/,64 /*pmsa*/,32 /*tcr*/,64 /*t0v*/,
	64 /*t1v*/,64 /*t0r*/,64 /*t1r*/,64 /*wdv*/,64 /*wdr*/,64 /*ile*/,64 /*ill*/,64 /*ilr*/,32 /*mmc*/,64 /*tel*/,
	64 /*teh*/,32 /*ixc*/,32 /*syo*/,32 /*hto*/,64 /*ito*/,32 /*do*/,64 /*mo*/,64 /*pso*/,64 /*tpcm0*/,64 /*tpcm1*/,
	64 /*res40*/,64 /*dba0*/,64 /*dba1*/,64 /*dwa0*/,64 /*dwa1*/,32 /*mes*/,32 /*ws*/,64 /*dc0*/,64 /*dc1*/,64 /*dc2*/,
	64 /*dc3*/,64 /*dba2*/,64 /*dba3*/,64 /*dwa2*/,64 /*dwa3*/,64 /*tpcm2*/,64 /*tpcmc*/,64 /*pm4*/,64 /*pm5*/,64 /*pm6*/,
	64 /*pm7*/,64 /*pmc2*/,64 /*srhpc*/,64 /*frcc*/,64 /*spc_pl0*/,64 /*spc_pl1*/,64 /*spc_pl2*/,64 /*spc_pl3*/,32 /*sps_pl0*/,32 /*sps_pl1*/,
	32 /*sps_pl2*/,32 /*sps_pl3*/,64 /*ea_pl0*/,64 /*ea_pl1*/,64 /*ea_pl2*/,64 /*ea_pl3*/,64 /*ev_pl0*/,64 /*ev_pl1*/,64 /*ev_pl2*/,64 /*ev_pl3*/,
	64 /*sr_pl0*/,64 /*sr_pl1*/,64 /*sr_pl2*/,64 /*sr_pl3*/,64 /*es_pl0*/,64 /*es_pl1*/,64 /*es_pl2*/,64 /*es_pl3*/,32 /*sid_pl0*/,32 /*sid_pl1*/,
	32 /*sid_pl2*/,32 /*sid_pl3*/,64 /*sr1_pl0*/,64 /*sr1_pl1*/,64 /*sr1_pl2*/,64 /*sr1_pl3*/,32 /*syow*/,32 /*htow*/,64 /*itow*/,32 /*dow*/,
	64 /*mow*/,64 /*psow*/,64 /*res102*/,64 /*res103*/,32 /*tpcc_pl0*/,32 /*tpcc_pl1*/,32 /*tpcc_pl2*/,32 /*tpcc_pl3*/,64 /*res108*/,64 /*res109*/,
	64 /*res110*/,64 /*res111*/,64 /*res112*/,64 /*res113*/,64 /*res114*/,64 /*res115*/,64 /*res116*/,64 /*res117*/,64 /*res118*/,64 /*res119*/,
	64 /*res120*/,64 /*res121*/,64 /*res122*/,64 /*res123*/,64 /*res124*/,64 /*res125*/,64 /*res126*/,64 /*res127*/,64 /*spc*/,64 /*res129*/,
	64 /*res130*/,64 /*res131*/,32 /*sps*/,64 /*res133*/,64 /*res134*/,64 /*res135*/,64 /*ea*/,64 /*res137*/,64 /*res138*/,64 /*res139*/,
	64 /*ev*/,64 /*res141*/,64 /*res142*/,64 /*res143*/,64 /*sr*/,64 /*res145*/,64 /*res146*/,64 /*res147*/,64 /*es*/,64 /*res149*/,
	64 /*res150*/,64 /*res151*/,32 /*sid*/,64 /*res153*/,64 /*res154*/,64 /*res155*/,64 /*sr1*/,64 /*res157*/,64 /*res158*/,64 /*res159*/,
	64 /*res160*/,64 /*res161*/,64 /*res162*/,64 /*res163*/,64 /*res164*/,64 /*res165*/,64 /*res166*/,64 /*res167*/,32 /*tpcc*/,64 /*res169*/,
	64 /*res170*/,64 /*res171*/,64 /*res172*/,64 /*res173*/,64 /*res174*/,64 /*res175*/,64 /*res176*/,64 /*res177*/,64 /*res178*/,64 /*res179*/,
	64 /*res180*/,64 /*res181*/,64 /*res182*/,64 /*res183*/,64 /*res184*/,64 /*res185*/,64 /*res186*/,64 /*res187*/,64 /*res188*/,64 /*res189*/,
	64 /*res190*/,64 /*res191*/,64 /*r0*/,64 /*r1*/,64 /*r2*/,64 /*r3*/,64 /*r4*/,64 /*r5*/,64 /*r6*/,64 /*r7*/,
	64 /*r8*/,64 /*r9*/,64 /*r10*/,64 /*r11*/,64 /*r12*/,64 /*r13*/,64 /*r14*/,64 /*r15*/,64 /*r16*/,64 /*r17*/,
	64 /*r18*/,64 /*r19*/,64 /*r20*/,64 /*r21*/,64 /*r22*/,64 /*r23*/,64 /*r24*/,64 /*r25*/,64 /*r26*/,64 /*r27*/,
	64 /*r28*/,64 /*r29*/,64 /*r30*/,64 /*r31*/,64 /*r32*/,64 /*r33*/,64 /*r34*/,64 /*r35*/,64 /*r36*/,64 /*r37*/,
	64 /*r38*/,64 /*r39*/,64 /*r40*/,64 /*r41*/,64 /*r42*/,64 /*r43*/,64 /*r44*/,64 /*r45*/,64 /*r46*/,64 /*r47*/,
	64 /*r48*/,64 /*r49*/,64 /*r50*/,64 /*r51*/,64 /*r52*/,64 /*r53*/,64 /*r54*/,64 /*r55*/,64 /*r56*/,64 /*r57*/,
	64 /*r58*/,64 /*r59*/,64 /*r60*/,64 /*r61*/,64 /*r62*/,64 /*r63*/,64 /*a0_x*/,64 /*a0_y*/,64 /*a0_z*/,64 /*a0_t*/,
	64 /*a1_x*/,64 /*a1_y*/,64 /*a1_z*/,64 /*a1_t*/,64 /*a2_x*/,64 /*a2_y*/,64 /*a2_z*/,64 /*a2_t*/,64 /*a3_x*/,64 /*a3_y*/,
	64 /*a3_z*/,64 /*a3_t*/,64 /*a4_x*/,64 /*a4_y*/,64 /*a4_z*/,64 /*a4_t*/,64 /*a5_x*/,64 /*a5_y*/,64 /*a5_z*/,64 /*a5_t*/,
	64 /*a6_x*/,64 /*a6_y*/,64 /*a6_z*/,64 /*a6_t*/,64 /*a7_x*/,64 /*a7_y*/,64 /*a7_z*/,64 /*a7_t*/,64 /*a8_x*/,64 /*a8_y*/,
	64 /*a8_z*/,64 /*a8_t*/,64 /*a9_x*/,64 /*a9_y*/,64 /*a9_z*/,64 /*a9_t*/,64 /*a10_x*/,64 /*a10_y*/,64 /*a10_z*/,64 /*a10_t*/,
	64 /*a11_x*/,64 /*a11_y*/,64 /*a11_z*/,64 /*a11_t*/,64 /*a12_x*/,64 /*a12_y*/,64 /*a12_z*/,64 /*a12_t*/,64 /*a13_x*/,64 /*a13_y*/,
	64 /*a13_z*/,64 /*a13_t*/,64 /*a14_x*/,64 /*a14_y*/,64 /*a14_z*/,64 /*a14_t*/,64 /*a15_x*/,64 /*a15_y*/,64 /*a15_z*/,64 /*a15_t*/,
	64 /*a16_x*/,64 /*a16_y*/,64 /*a16_z*/,64 /*a16_t*/,64 /*a17_x*/,64 /*a17_y*/,64 /*a17_z*/,64 /*a17_t*/,64 /*a18_x*/,64 /*a18_y*/,
	64 /*a18_z*/,64 /*a18_t*/,64 /*a19_x*/,64 /*a19_y*/,64 /*a19_z*/,64 /*a19_t*/,64 /*a20_x*/,64 /*a20_y*/,64 /*a20_z*/,64 /*a20_t*/,
	64 /*a21_x*/,64 /*a21_y*/,64 /*a21_z*/,64 /*a21_t*/,64 /*a22_x*/,64 /*a22_y*/,64 /*a22_z*/,64 /*a22_t*/,64 /*a23_x*/,64 /*a23_y*/,
	64 /*a23_z*/,64 /*a23_t*/,64 /*a24_x*/,64 /*a24_y*/,64 /*a24_z*/,64 /*a24_t*/,64 /*a25_x*/,64 /*a25_y*/,64 /*a25_z*/,64 /*a25_t*/,
	64 /*a26_x*/,64 /*a26_y*/,64 /*a26_z*/,64 /*a26_t*/,64 /*a27_x*/,64 /*a27_y*/,64 /*a27_z*/,64 /*a27_t*/,64 /*a28_x*/,64 /*a28_y*/,
	64 /*a28_z*/,64 /*a28_t*/,64 /*a29_x*/,64 /*a29_y*/,64 /*a29_z*/,64 /*a29_t*/,64 /*a30_x*/,64 /*a30_y*/,64 /*a30_z*/,64 /*a30_t*/,
	64 /*a31_x*/,64 /*a31_y*/,64 /*a31_z*/,64 /*a31_t*/,64 /*a32_x*/,64 /*a32_y*/,64 /*a32_z*/,64 /*a32_t*/,64 /*a33_x*/,64 /*a33_y*/,
	64 /*a33_z*/,64 /*a33_t*/,64 /*a34_x*/,64 /*a34_y*/,64 /*a34_z*/,64 /*a34_t*/,64 /*a35_x*/,64 /*a35_y*/,64 /*a35_z*/,64 /*a35_t*/,
	64 /*a36_x*/,64 /*a36_y*/,64 /*a36_z*/,64 /*a36_t*/,64 /*a37_x*/,64 /*a37_y*/,64 /*a37_z*/,64 /*a37_t*/,64 /*a38_x*/,64 /*a38_y*/,
	64 /*a38_z*/,64 /*a38_t*/,64 /*a39_x*/,64 /*a39_y*/,64 /*a39_z*/,64 /*a39_t*/,64 /*a40_x*/,64 /*a40_y*/,64 /*a40_z*/,64 /*a40_t*/,
	64 /*a41_x*/,64 /*a41_y*/,64 /*a41_z*/,64 /*a41_t*/,64 /*a42_x*/,64 /*a42_y*/,64 /*a42_z*/,64 /*a42_t*/,64 /*a43_x*/,64 /*a43_y*/,
	64 /*a43_z*/,64 /*a43_t*/,64 /*a44_x*/,64 /*a44_y*/,64 /*a44_z*/,64 /*a44_t*/,64 /*a45_x*/,64 /*a45_y*/,64 /*a45_z*/,64 /*a45_t*/,
	64 /*a46_x*/,64 /*a46_y*/,64 /*a46_z*/,64 /*a46_t*/,64 /*a47_x*/,64 /*a47_y*/,64 /*a47_z*/,64 /*a47_t*/,64 /*a48_x*/,64 /*a48_y*/,
	64 /*a48_z*/,64 /*a48_t*/,64 /*a49_x*/,64 /*a49_y*/,64 /*a49_z*/,64 /*a49_t*/,64 /*a50_x*/,64 /*a50_y*/,64 /*a50_z*/,64 /*a50_t*/,
	64 /*a51_x*/,64 /*a51_y*/,64 /*a51_z*/,64 /*a51_t*/,64 /*a52_x*/,64 /*a52_y*/,64 /*a52_z*/,64 /*a52_t*/,64 /*a53_x*/,64 /*a53_y*/,
	64 /*a53_z*/,64 /*a53_t*/,64 /*a54_x*/,64 /*a54_y*/,64 /*a54_z*/,64 /*a54_t*/,64 /*a55_x*/,64 /*a55_y*/,64 /*a55_z*/,64 /*a55_t*/,
	64 /*a56_x*/,64 /*a56_y*/,64 /*a56_z*/,64 /*a56_t*/,64 /*a57_x*/,64 /*a57_y*/,64 /*a57_z*/,64 /*a57_t*/,64 /*a58_x*/,64 /*a58_y*/,
	64 /*a58_z*/,64 /*a58_t*/,64 /*a59_x*/,64 /*a59_y*/,64 /*a59_z*/,64 /*a59_t*/,64 /*a60_x*/,64 /*a60_y*/,64 /*a60_z*/,64 /*a60_t*/,
	64 /*a61_x*/,64 /*a61_y*/,64 /*a61_z*/,64 /*a61_t*/,64 /*a62_x*/,64 /*a62_y*/,64 /*a62_z*/,64 /*a62_t*/,64 /*a63_x*/,64 /*a63_y*/,
	64 /*a63_z*/,64 /*a63_t*/,
	0,
};

struct reg_desc lvx_v2_mds_registers_description[] = {
	{"pc", "<reg name=\"pc\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=0 */
	{"ps", ""
		"<struct id=\"ps_type\" size=\"4\">\n"
			"<field name=\"pl\" start=\"0\" end=\"1\" />\n"
			"<field name=\"et\" start=\"2\" end=\"2\" />\n"
			"<field name=\"htd\" start=\"3\" end=\"3\" />\n"
			"<field name=\"ie\" start=\"4\" end=\"4\" />\n"
			"<field name=\"hle\" start=\"5\" end=\"5\" />\n"
			"<field name=\"sre\" start=\"6\" end=\"6\" />\n"
			"<field name=\"daus\" start=\"7\" end=\"7\" />\n"
			"<field name=\"ice\" start=\"8\" end=\"8\" />\n"
			"<field name=\"use\" start=\"9\" end=\"9\" />\n"
			"<field name=\"dce\" start=\"10\" end=\"10\" />\n"
			"<field name=\"mme\" start=\"11\" end=\"11\" />\n"
			"<field name=\"il\" start=\"12\" end=\"13\" />\n"
			"<field name=\"vs\" start=\"14\" end=\"15\" />\n"
			"<field name=\"v64\" start=\"16\" end=\"16\" />\n"
			"<field name=\"l2e\" start=\"17\" end=\"17\" />\n"
			"<field name=\"sme\" start=\"18\" end=\"18\" />\n"
			"<field name=\"smr\" start=\"19\" end=\"19\" />\n"
			"<field name=\"pmj\" start=\"20\" end=\"23\" />\n"
			"<field name=\"mmup\" start=\"24\" end=\"24\" />\n"
		"</struct>\n"
		"<reg name=\"ps\" regnum=\"%d\" bitsize=\"32\" type=\"ps_type\" />"}, /* regno=1 */
	{"pcr", ""
		"<struct id=\"pcr_type\" size=\"8\">\n"
			"<field name=\"pid\" start=\"0\" end=\"7\" />\n"
			"<field name=\"cid\" start=\"8\" end=\"15\" />\n"
			"<field name=\"mid\" start=\"16\" end=\"23\" />\n"
			"<field name=\"car\" start=\"24\" end=\"27\" />\n"
			"<field name=\"cma\" start=\"28\" end=\"31\" />\n"
			"<field name=\"sv\" start=\"32\" end=\"39\" />\n"
			"<field name=\"st\" start=\"40\" end=\"43\" />\n"
			"<field name=\"bm\" start=\"44\" end=\"51\" />\n"
			"<field name=\"coe\" start=\"52\" end=\"52\" />\n"
			"<field name=\"l1ce\" start=\"53\" end=\"53\" />\n"
			"<field name=\"dsem\" start=\"54\" end=\"54\" />\n"
			"<field name=\"tpce\" start=\"55\" end=\"55\" />\n"
			"<field name=\"tpcum\" start=\"56\" end=\"56\" />\n"
			"<field name=\"tpcis\" start=\"57\" end=\"57\" />\n"
		"</struct>\n"
		"<reg name=\"pcr\" regnum=\"%d\" bitsize=\"64\" type=\"pcr_type\" />"}, /* regno=2 */
	{"ra", "<reg name=\"ra\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=3 */
	{"cs", ""
		"<struct id=\"cs_type\" size=\"8\">\n"
			"<field name=\"ic\" start=\"0\" end=\"0\" />\n"
			"<field name=\"io\" start=\"1\" end=\"1\" />\n"
			"<field name=\"dz\" start=\"2\" end=\"2\" />\n"
			"<field name=\"ov\" start=\"3\" end=\"3\" />\n"
			"<field name=\"un\" start=\"4\" end=\"4\" />\n"
			"<field name=\"in\" start=\"5\" end=\"5\" />\n"
			"<field name=\"rm\" start=\"16\" end=\"18\" />\n"
			"<field name=\"xrm\" start=\"20\" end=\"21\" />\n"
			"<field name=\"xmf\" start=\"24\" end=\"24\" />\n"
			"<field name=\"cc\" start=\"32\" end=\"47\" />\n"
		"</struct>\n"
		"<reg name=\"cs\" regnum=\"%d\" bitsize=\"64\" type=\"cs_type\" />"}, /* regno=4 */
	{"csit", ""
		"<struct id=\"csit_type\" size=\"4\">\n"
			"<field name=\"icie\" start=\"0\" end=\"0\" />\n"
			"<field name=\"ioie\" start=\"1\" end=\"1\" />\n"
			"<field name=\"dzie\" start=\"2\" end=\"2\" />\n"
			"<field name=\"ovie\" start=\"3\" end=\"3\" />\n"
			"<field name=\"unie\" start=\"4\" end=\"4\" />\n"
			"<field name=\"inie\" start=\"5\" end=\"5\" />\n"
			"<field name=\"xioie\" start=\"9\" end=\"9\" />\n"
			"<field name=\"xdzie\" start=\"10\" end=\"10\" />\n"
			"<field name=\"xovie\" start=\"11\" end=\"11\" />\n"
			"<field name=\"xunie\" start=\"12\" end=\"12\" />\n"
			"<field name=\"xinie\" start=\"13\" end=\"13\" />\n"
			"<field name=\"aeir\" start=\"16\" end=\"16\" />\n"
			"<field name=\"aec\" start=\"17\" end=\"19\" />\n"
			"<field name=\"spcv\" start=\"20\" end=\"20\" />\n"
		"</struct>\n"
		"<reg name=\"csit\" regnum=\"%d\" bitsize=\"32\" type=\"csit_type\" />"}, /* regno=5 */
	{"aespc", ""
		"<struct id=\"aespc_type\" size=\"8\">\n"
			"<field name=\"aespc\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"aespc\" regnum=\"%d\" bitsize=\"64\" type=\"aespc_type\" />"}, /* regno=6 */
	{"ls", "<reg name=\"ls\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=7 */
	{"le", "<reg name=\"le\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=8 */
	{"lc", "<reg name=\"lc\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=9 */
	{"ipe", ""
		"<struct id=\"ipe_type\" size=\"8\">\n"
			"<field name=\"fe\" start=\"0\" end=\"15\" />\n"
			"<field name=\"be\" start=\"16\" end=\"31\" />\n"
			"<field name=\"fm\" start=\"32\" end=\"47\" />\n"
			"<field name=\"bm\" start=\"48\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"ipe\" regnum=\"%d\" bitsize=\"64\" type=\"ipe_type\" />"}, /* regno=10 */
	{"men", ""
		"<struct id=\"men_type\" size=\"8\">\n"
			"<field name=\"men\" start=\"0\" end=\"15\" />\n"
		"</struct>\n"
		"<reg name=\"men\" regnum=\"%d\" bitsize=\"64\" type=\"men_type\" />"}, /* regno=11 */
	{"pmc", ""
		"<struct id=\"pmc_type\" size=\"8\">\n"
			"<field name=\"pm0c\" start=\"0\" end=\"5\" />\n"
			"<field name=\"pm1c\" start=\"7\" end=\"12\" />\n"
			"<field name=\"pm2c\" start=\"14\" end=\"19\" />\n"
			"<field name=\"pm3c\" start=\"21\" end=\"26\" />\n"
			"<field name=\"sav\" start=\"30\" end=\"30\" />\n"
			"<field name=\"pm0ie\" start=\"32\" end=\"32\" />\n"
			"<field name=\"pm1ie\" start=\"33\" end=\"33\" />\n"
			"<field name=\"pm2ie\" start=\"34\" end=\"34\" />\n"
			"<field name=\"pm3ie\" start=\"35\" end=\"35\" />\n"
			"<field name=\"sat\" start=\"36\" end=\"37\" />\n"
			"<field name=\"saf\" start=\"38\" end=\"40\" />\n"
		"</struct>\n"
		"<reg name=\"pmc\" regnum=\"%d\" bitsize=\"64\" type=\"pmc_type\" />"}, /* regno=12 */
	{"pm0", ""
		"<struct id=\"pm0_type\" size=\"8\">\n"
			"<field name=\"pm0\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm0\" regnum=\"%d\" bitsize=\"64\" type=\"pm0_type\" />"}, /* regno=13 */
	{"pm1", ""
		"<struct id=\"pm1_type\" size=\"8\">\n"
			"<field name=\"pm1\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm1\" regnum=\"%d\" bitsize=\"64\" type=\"pm1_type\" />"}, /* regno=14 */
	{"pm2", ""
		"<struct id=\"pm2_type\" size=\"8\">\n"
			"<field name=\"pm2\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm2\" regnum=\"%d\" bitsize=\"64\" type=\"pm2_type\" />"}, /* regno=15 */
	{"pm3", ""
		"<struct id=\"pm3_type\" size=\"8\">\n"
			"<field name=\"pm3\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm3\" regnum=\"%d\" bitsize=\"64\" type=\"pm3_type\" />"}, /* regno=16 */
	{"pmsa", ""
		"<struct id=\"pmsa_type\" size=\"8\">\n"
			"<field name=\"pmsa\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pmsa\" regnum=\"%d\" bitsize=\"64\" type=\"pmsa_type\" />"}, /* regno=17 */
	{"tcr", ""
		"<struct id=\"tcr_type\" size=\"4\">\n"
			"<field name=\"t0ce\" start=\"16\" end=\"16\" />\n"
			"<field name=\"t1ce\" start=\"17\" end=\"17\" />\n"
			"<field name=\"t0ie\" start=\"18\" end=\"18\" />\n"
			"<field name=\"t1ie\" start=\"19\" end=\"19\" />\n"
			"<field name=\"t0st\" start=\"20\" end=\"20\" />\n"
			"<field name=\"t1st\" start=\"21\" end=\"21\" />\n"
			"<field name=\"t0si\" start=\"22\" end=\"22\" />\n"
			"<field name=\"t1si\" start=\"23\" end=\"23\" />\n"
			"<field name=\"wce\" start=\"24\" end=\"24\" />\n"
			"<field name=\"wie\" start=\"25\" end=\"25\" />\n"
			"<field name=\"wui\" start=\"26\" end=\"26\" />\n"
			"<field name=\"wus\" start=\"27\" end=\"27\" />\n"
			"<field name=\"wsi\" start=\"28\" end=\"28\" />\n"
		"</struct>\n"
		"<reg name=\"tcr\" regnum=\"%d\" bitsize=\"32\" type=\"tcr_type\" />"}, /* regno=18 */
	{"t0v", ""
		"<struct id=\"t0v_type\" size=\"8\">\n"
			"<field name=\"t0v\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"t0v\" regnum=\"%d\" bitsize=\"64\" type=\"t0v_type\" />"}, /* regno=19 */
	{"t1v", ""
		"<struct id=\"t1v_type\" size=\"8\">\n"
			"<field name=\"t1v\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"t1v\" regnum=\"%d\" bitsize=\"64\" type=\"t1v_type\" />"}, /* regno=20 */
	{"t0r", ""
		"<struct id=\"t0r_type\" size=\"8\">\n"
			"<field name=\"t0r\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"t0r\" regnum=\"%d\" bitsize=\"64\" type=\"t0r_type\" />"}, /* regno=21 */
	{"t1r", ""
		"<struct id=\"t1r_type\" size=\"8\">\n"
			"<field name=\"t1r\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"t1r\" regnum=\"%d\" bitsize=\"64\" type=\"t1r_type\" />"}, /* regno=22 */
	{"wdv", ""
		"<struct id=\"wdv_type\" size=\"8\">\n"
			"<field name=\"wdv\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"wdv\" regnum=\"%d\" bitsize=\"64\" type=\"wdv_type\" />"}, /* regno=23 */
	{"wdr", ""
		"<struct id=\"wdr_type\" size=\"8\">\n"
			"<field name=\"wdr\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"wdr\" regnum=\"%d\" bitsize=\"64\" type=\"wdr_type\" />"}, /* regno=24 */
	{"ile", ""
		"<struct id=\"ile_type\" size=\"8\">\n"
			"<field name=\"it0\" start=\"0\" end=\"0\" />\n"
			"<field name=\"it1\" start=\"1\" end=\"1\" />\n"
			"<field name=\"it2\" start=\"2\" end=\"2\" />\n"
			"<field name=\"it3\" start=\"3\" end=\"3\" />\n"
			"<field name=\"it4\" start=\"4\" end=\"4\" />\n"
			"<field name=\"it5\" start=\"5\" end=\"5\" />\n"
			"<field name=\"it6\" start=\"6\" end=\"6\" />\n"
			"<field name=\"it7\" start=\"7\" end=\"7\" />\n"
			"<field name=\"it8\" start=\"8\" end=\"8\" />\n"
			"<field name=\"it9\" start=\"9\" end=\"9\" />\n"
			"<field name=\"it10\" start=\"10\" end=\"10\" />\n"
			"<field name=\"it11\" start=\"11\" end=\"11\" />\n"
			"<field name=\"it12\" start=\"12\" end=\"12\" />\n"
			"<field name=\"it13\" start=\"13\" end=\"13\" />\n"
			"<field name=\"it14\" start=\"14\" end=\"14\" />\n"
			"<field name=\"it15\" start=\"15\" end=\"15\" />\n"
			"<field name=\"it16\" start=\"16\" end=\"16\" />\n"
			"<field name=\"it17\" start=\"17\" end=\"17\" />\n"
			"<field name=\"it18\" start=\"18\" end=\"18\" />\n"
			"<field name=\"it19\" start=\"19\" end=\"19\" />\n"
			"<field name=\"it20\" start=\"20\" end=\"20\" />\n"
			"<field name=\"it21\" start=\"21\" end=\"21\" />\n"
			"<field name=\"it22\" start=\"22\" end=\"22\" />\n"
			"<field name=\"it23\" start=\"23\" end=\"23\" />\n"
			"<field name=\"it24\" start=\"24\" end=\"24\" />\n"
			"<field name=\"it25\" start=\"25\" end=\"25\" />\n"
			"<field name=\"it26\" start=\"26\" end=\"26\" />\n"
			"<field name=\"it27\" start=\"27\" end=\"27\" />\n"
			"<field name=\"it28\" start=\"28\" end=\"28\" />\n"
			"<field name=\"it29\" start=\"29\" end=\"29\" />\n"
			"<field name=\"it30\" start=\"30\" end=\"30\" />\n"
			"<field name=\"it31\" start=\"31\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"ile\" regnum=\"%d\" bitsize=\"64\" type=\"ile_type\" />"}, /* regno=25 */
	{"ill", ""
		"<struct id=\"ill_type\" size=\"8\">\n"
			"<field name=\"it0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"it1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"it2\" start=\"4\" end=\"5\" />\n"
			"<field name=\"it3\" start=\"6\" end=\"7\" />\n"
			"<field name=\"it4\" start=\"8\" end=\"9\" />\n"
			"<field name=\"it5\" start=\"10\" end=\"11\" />\n"
			"<field name=\"it6\" start=\"12\" end=\"13\" />\n"
			"<field name=\"it7\" start=\"14\" end=\"15\" />\n"
			"<field name=\"it8\" start=\"16\" end=\"17\" />\n"
			"<field name=\"it9\" start=\"18\" end=\"19\" />\n"
			"<field name=\"it10\" start=\"20\" end=\"21\" />\n"
			"<field name=\"it11\" start=\"22\" end=\"23\" />\n"
			"<field name=\"it12\" start=\"24\" end=\"25\" />\n"
			"<field name=\"it13\" start=\"26\" end=\"27\" />\n"
			"<field name=\"it14\" start=\"28\" end=\"29\" />\n"
			"<field name=\"it15\" start=\"30\" end=\"31\" />\n"
			"<field name=\"it16\" start=\"32\" end=\"33\" />\n"
			"<field name=\"it17\" start=\"34\" end=\"35\" />\n"
			"<field name=\"it18\" start=\"36\" end=\"37\" />\n"
			"<field name=\"it19\" start=\"38\" end=\"39\" />\n"
			"<field name=\"it20\" start=\"40\" end=\"41\" />\n"
			"<field name=\"it21\" start=\"42\" end=\"43\" />\n"
			"<field name=\"it22\" start=\"44\" end=\"45\" />\n"
			"<field name=\"it23\" start=\"46\" end=\"47\" />\n"
			"<field name=\"it24\" start=\"48\" end=\"49\" />\n"
			"<field name=\"it25\" start=\"50\" end=\"51\" />\n"
			"<field name=\"it26\" start=\"52\" end=\"53\" />\n"
			"<field name=\"it27\" start=\"54\" end=\"55\" />\n"
			"<field name=\"it28\" start=\"56\" end=\"57\" />\n"
			"<field name=\"it29\" start=\"58\" end=\"59\" />\n"
			"<field name=\"it30\" start=\"60\" end=\"61\" />\n"
			"<field name=\"it31\" start=\"62\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"ill\" regnum=\"%d\" bitsize=\"64\" type=\"ill_type\" />"}, /* regno=26 */
	{"ilr", ""
		"<struct id=\"ilr_type\" size=\"8\">\n"
			"<field name=\"it0\" start=\"0\" end=\"0\" />\n"
			"<field name=\"it1\" start=\"1\" end=\"1\" />\n"
			"<field name=\"it2\" start=\"2\" end=\"2\" />\n"
			"<field name=\"it3\" start=\"3\" end=\"3\" />\n"
			"<field name=\"it4\" start=\"4\" end=\"4\" />\n"
			"<field name=\"it5\" start=\"5\" end=\"5\" />\n"
			"<field name=\"it6\" start=\"6\" end=\"6\" />\n"
			"<field name=\"it7\" start=\"7\" end=\"7\" />\n"
			"<field name=\"it8\" start=\"8\" end=\"8\" />\n"
			"<field name=\"it9\" start=\"9\" end=\"9\" />\n"
			"<field name=\"it10\" start=\"10\" end=\"10\" />\n"
			"<field name=\"it11\" start=\"11\" end=\"11\" />\n"
			"<field name=\"it12\" start=\"12\" end=\"12\" />\n"
			"<field name=\"it13\" start=\"13\" end=\"13\" />\n"
			"<field name=\"it14\" start=\"14\" end=\"14\" />\n"
			"<field name=\"it15\" start=\"15\" end=\"15\" />\n"
			"<field name=\"it16\" start=\"16\" end=\"16\" />\n"
			"<field name=\"it17\" start=\"17\" end=\"17\" />\n"
			"<field name=\"it18\" start=\"18\" end=\"18\" />\n"
			"<field name=\"it19\" start=\"19\" end=\"19\" />\n"
			"<field name=\"it20\" start=\"20\" end=\"20\" />\n"
			"<field name=\"it21\" start=\"21\" end=\"21\" />\n"
			"<field name=\"it22\" start=\"22\" end=\"22\" />\n"
			"<field name=\"it23\" start=\"23\" end=\"23\" />\n"
			"<field name=\"it24\" start=\"24\" end=\"24\" />\n"
			"<field name=\"it25\" start=\"25\" end=\"25\" />\n"
			"<field name=\"it26\" start=\"26\" end=\"26\" />\n"
			"<field name=\"it27\" start=\"27\" end=\"27\" />\n"
			"<field name=\"it28\" start=\"28\" end=\"28\" />\n"
			"<field name=\"it29\" start=\"29\" end=\"29\" />\n"
			"<field name=\"it30\" start=\"30\" end=\"30\" />\n"
			"<field name=\"it31\" start=\"31\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"ilr\" regnum=\"%d\" bitsize=\"64\" type=\"ilr_type\" />"}, /* regno=27 */
	{"mmc", ""
		"<struct id=\"mmc_type\" size=\"4\">\n"
			"<field name=\"asn\" start=\"0\" end=\"8\" />\n"
			"<field name=\"s\" start=\"9\" end=\"9\" />\n"
			"<field name=\"sne\" start=\"14\" end=\"14\" />\n"
			"<field name=\"spe\" start=\"15\" end=\"15\" />\n"
			"<field name=\"ptc\" start=\"16\" end=\"17\" />\n"
			"<field name=\"sw\" start=\"18\" end=\"21\" />\n"
			"<field name=\"ss\" start=\"22\" end=\"27\" />\n"
			"<field name=\"sb\" start=\"28\" end=\"28\" />\n"
			"<field name=\"par\" start=\"30\" end=\"30\" />\n"
			"<field name=\"e\" start=\"31\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"mmc\" regnum=\"%d\" bitsize=\"32\" type=\"mmc_type\" />"}, /* regno=28 */
	{"tel", ""
		"<struct id=\"tel_type\" size=\"8\">\n"
			"<field name=\"es\" start=\"0\" end=\"1\" />\n"
			"<field name=\"cp2\" start=\"2\" end=\"5\" />\n"
			"<field name=\"pa2\" start=\"6\" end=\"9\" />\n"
			"<field name=\"ps\" start=\"10\" end=\"11\" />\n"
			"<field name=\"fn\" start=\"12\" end=\"39\" />\n"
		"</struct>\n"
		"<reg name=\"tel\" regnum=\"%d\" bitsize=\"64\" type=\"tel_type\" />"}, /* regno=29 */
	{"teh", ""
		"<struct id=\"teh_type\" size=\"8\">\n"
			"<field name=\"asn\" start=\"0\" end=\"8\" />\n"
			"<field name=\"g\" start=\"9\" end=\"9\" />\n"
			"<field name=\"vs\" start=\"10\" end=\"11\" />\n"
			"<field name=\"pn\" start=\"12\" end=\"40\" />\n"
		"</struct>\n"
		"<reg name=\"teh\" regnum=\"%d\" bitsize=\"64\" type=\"teh_type\" />"}, /* regno=30 */
	{"ixc", ""
		"<struct id=\"ixc_type\" size=\"4\">\n"
			"<field name=\"fcb\" start=\"0\" end=\"0\" />\n"
			"<field name=\"sfb\" start=\"8\" end=\"8\" />\n"
			"<field name=\"bcb\" start=\"16\" end=\"16\" />\n"
		"</struct>\n"
		"<reg name=\"ixc\" regnum=\"%d\" bitsize=\"32\" type=\"ixc_type\" />"}, /* regno=31 */
	{"syo", ""
		"<struct id=\"syo_type\" size=\"4\">\n"
			"<field name=\"q0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"q1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"q2\" start=\"4\" end=\"5\" />\n"
			"<field name=\"q3\" start=\"6\" end=\"7\" />\n"
		"</struct>\n"
		"<reg name=\"syo\" regnum=\"%d\" bitsize=\"32\" type=\"syo_type\" />"}, /* regno=32 */
	{"hto", ""
		"<struct id=\"hto_type\" size=\"4\">\n"
			"<field name=\"opc\" start=\"0\" end=\"1\" />\n"
			"<field name=\"dmis\" start=\"2\" end=\"3\" />\n"
			"<field name=\"psys\" start=\"4\" end=\"5\" />\n"
			"<field name=\"dsys\" start=\"6\" end=\"7\" />\n"
			"<field name=\"deccg\" start=\"8\" end=\"9\" />\n"
			"<field name=\"seccg\" start=\"10\" end=\"11\" />\n"
			"<field name=\"nomap\" start=\"12\" end=\"13\" />\n"
			"<field name=\"prot\" start=\"14\" end=\"15\" />\n"
			"<field name=\"w2cl\" start=\"16\" end=\"17\" />\n"
			"<field name=\"a2cl\" start=\"18\" end=\"19\" />\n"
			"<field name=\"de\" start=\"20\" end=\"21\" />\n"
			"<field name=\"vsfr\" start=\"22\" end=\"23\" />\n"
			"<field name=\"plo\" start=\"24\" end=\"25\" />\n"
		"</struct>\n"
		"<reg name=\"hto\" regnum=\"%d\" bitsize=\"32\" type=\"hto_type\" />"}, /* regno=33 */
	{"ito", ""
		"<struct id=\"ito_type\" size=\"8\">\n"
			"<field name=\"it0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"it1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"it2\" start=\"4\" end=\"5\" />\n"
			"<field name=\"it3\" start=\"6\" end=\"7\" />\n"
			"<field name=\"it4\" start=\"8\" end=\"9\" />\n"
			"<field name=\"it5\" start=\"10\" end=\"11\" />\n"
			"<field name=\"it6\" start=\"12\" end=\"13\" />\n"
			"<field name=\"it7\" start=\"14\" end=\"15\" />\n"
			"<field name=\"it8\" start=\"16\" end=\"17\" />\n"
			"<field name=\"it9\" start=\"18\" end=\"19\" />\n"
			"<field name=\"it10\" start=\"20\" end=\"21\" />\n"
			"<field name=\"it11\" start=\"22\" end=\"23\" />\n"
			"<field name=\"it12\" start=\"24\" end=\"25\" />\n"
			"<field name=\"it13\" start=\"26\" end=\"27\" />\n"
			"<field name=\"it14\" start=\"28\" end=\"29\" />\n"
			"<field name=\"it15\" start=\"30\" end=\"31\" />\n"
			"<field name=\"it16\" start=\"32\" end=\"33\" />\n"
			"<field name=\"it17\" start=\"34\" end=\"35\" />\n"
			"<field name=\"it18\" start=\"36\" end=\"37\" />\n"
			"<field name=\"it19\" start=\"38\" end=\"39\" />\n"
			"<field name=\"it20\" start=\"40\" end=\"41\" />\n"
			"<field name=\"it21\" start=\"42\" end=\"43\" />\n"
			"<field name=\"it22\" start=\"44\" end=\"45\" />\n"
			"<field name=\"it23\" start=\"46\" end=\"47\" />\n"
			"<field name=\"it24\" start=\"48\" end=\"49\" />\n"
			"<field name=\"it25\" start=\"50\" end=\"51\" />\n"
			"<field name=\"it26\" start=\"52\" end=\"53\" />\n"
			"<field name=\"it27\" start=\"54\" end=\"55\" />\n"
			"<field name=\"it28\" start=\"56\" end=\"57\" />\n"
			"<field name=\"it29\" start=\"58\" end=\"59\" />\n"
			"<field name=\"it30\" start=\"60\" end=\"61\" />\n"
			"<field name=\"it31\" start=\"62\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"ito\" regnum=\"%d\" bitsize=\"64\" type=\"ito_type\" />"}, /* regno=34 */
	{"do", ""
		"<struct id=\"do_type\" size=\"4\">\n"
			"<field name=\"b0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"b1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"w0\" start=\"4\" end=\"5\" />\n"
			"<field name=\"w1\" start=\"6\" end=\"7\" />\n"
			"<field name=\"b2\" start=\"8\" end=\"9\" />\n"
			"<field name=\"b3\" start=\"10\" end=\"11\" />\n"
			"<field name=\"w2\" start=\"12\" end=\"13\" />\n"
			"<field name=\"w3\" start=\"14\" end=\"15\" />\n"
			"<field name=\"bi0\" start=\"16\" end=\"17\" />\n"
			"<field name=\"bi1\" start=\"18\" end=\"19\" />\n"
			"<field name=\"bi2\" start=\"20\" end=\"21\" />\n"
			"<field name=\"bi3\" start=\"22\" end=\"23\" />\n"
		"</struct>\n"
		"<reg name=\"do\" regnum=\"%d\" bitsize=\"32\" type=\"do_type\" />"}, /* regno=35 */
	{"mo", ""
		"<struct id=\"mo_type\" size=\"8\">\n"
			"<field name=\"mmi\" start=\"0\" end=\"1\" />\n"
			"<field name=\"rfe\" start=\"2\" end=\"3\" />\n"
			"<field name=\"stop\" start=\"4\" end=\"5\" />\n"
			"<field name=\"sync\" start=\"6\" end=\"7\" />\n"
			"<field name=\"pcr\" start=\"8\" end=\"9\" />\n"
			"<field name=\"msg\" start=\"10\" end=\"11\" />\n"
			"<field name=\"men\" start=\"12\" end=\"13\" />\n"
			"<field name=\"mes\" start=\"14\" end=\"15\" />\n"
			"<field name=\"csit\" start=\"16\" end=\"17\" />\n"
			"<field name=\"t0\" start=\"18\" end=\"19\" />\n"
			"<field name=\"t1\" start=\"20\" end=\"21\" />\n"
			"<field name=\"wd\" start=\"22\" end=\"23\" />\n"
			"<field name=\"pm0\" start=\"24\" end=\"25\" />\n"
			"<field name=\"pm1\" start=\"26\" end=\"27\" />\n"
			"<field name=\"pm2\" start=\"28\" end=\"29\" />\n"
			"<field name=\"pm3\" start=\"30\" end=\"31\" />\n"
			"<field name=\"pmit\" start=\"32\" end=\"33\" />\n"
			"<field name=\"comm\" start=\"34\" end=\"35\" />\n"
			"<field name=\"tpcm\" start=\"36\" end=\"37\" />\n"
			"<field name=\"disw\" start=\"38\" end=\"39\" />\n"
			"<field name=\"pm4\" start=\"40\" end=\"41\" />\n"
			"<field name=\"pm5\" start=\"42\" end=\"43\" />\n"
			"<field name=\"pm6\" start=\"44\" end=\"45\" />\n"
			"<field name=\"pm7\" start=\"46\" end=\"47\" />\n"
			"<field name=\"srhpc\" start=\"48\" end=\"49\" />\n"
		"</struct>\n"
		"<reg name=\"mo\" regnum=\"%d\" bitsize=\"64\" type=\"mo_type\" />"}, /* regno=36 */
	{"pso", ""
		"<struct id=\"pso_type\" size=\"8\">\n"
			"<field name=\"pl0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"pl1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"et\" start=\"4\" end=\"5\" />\n"
			"<field name=\"htd\" start=\"6\" end=\"7\" />\n"
			"<field name=\"ie\" start=\"8\" end=\"9\" />\n"
			"<field name=\"hle\" start=\"10\" end=\"11\" />\n"
			"<field name=\"sre\" start=\"12\" end=\"13\" />\n"
			"<field name=\"daus\" start=\"14\" end=\"15\" />\n"
			"<field name=\"ice\" start=\"16\" end=\"17\" />\n"
			"<field name=\"use\" start=\"18\" end=\"19\" />\n"
			"<field name=\"dce\" start=\"20\" end=\"21\" />\n"
			"<field name=\"mme\" start=\"22\" end=\"23\" />\n"
			"<field name=\"il0\" start=\"24\" end=\"25\" />\n"
			"<field name=\"il1\" start=\"26\" end=\"27\" />\n"
			"<field name=\"vs0\" start=\"28\" end=\"29\" />\n"
			"<field name=\"vs1\" start=\"30\" end=\"31\" />\n"
			"<field name=\"l2e\" start=\"34\" end=\"35\" />\n"
			"<field name=\"sme\" start=\"36\" end=\"37\" />\n"
			"<field name=\"smr\" start=\"38\" end=\"39\" />\n"
			"<field name=\"pmj0\" start=\"40\" end=\"41\" />\n"
			"<field name=\"pmj1\" start=\"42\" end=\"43\" />\n"
			"<field name=\"pmj2\" start=\"44\" end=\"45\" />\n"
			"<field name=\"pmj3\" start=\"46\" end=\"47\" />\n"
			"<field name=\"mmup\" start=\"48\" end=\"49\" />\n"
		"</struct>\n"
		"<reg name=\"pso\" regnum=\"%d\" bitsize=\"64\" type=\"pso_type\" />"}, /* regno=37 */
	{"tpcm0", ""
		"<struct id=\"tpcm0_type\" size=\"8\">\n"
			"<field name=\"tpcm_0\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"tpcm0\" regnum=\"%d\" bitsize=\"64\" type=\"tpcm0_type\" />"}, /* regno=38 */
	{"tpcm1", ""
		"<struct id=\"tpcm1_type\" size=\"8\">\n"
			"<field name=\"tpcm_1\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"tpcm1\" regnum=\"%d\" bitsize=\"64\" type=\"tpcm1_type\" />"}, /* regno=39 */
	{"res40", "<reg name=\"res40\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=40 */
	{"dba0", ""
		"<struct id=\"dba0_type\" size=\"8\">\n"
			"<field name=\"dba0\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dba0\" regnum=\"%d\" bitsize=\"64\" type=\"dba0_type\" />"}, /* regno=41 */
	{"dba1", ""
		"<struct id=\"dba1_type\" size=\"8\">\n"
			"<field name=\"dba1\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dba1\" regnum=\"%d\" bitsize=\"64\" type=\"dba1_type\" />"}, /* regno=42 */
	{"dwa0", ""
		"<struct id=\"dwa0_type\" size=\"8\">\n"
			"<field name=\"dwa0\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dwa0\" regnum=\"%d\" bitsize=\"64\" type=\"dwa0_type\" />"}, /* regno=43 */
	{"dwa1", ""
		"<struct id=\"dwa1_type\" size=\"8\">\n"
			"<field name=\"dwa1\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dwa1\" regnum=\"%d\" bitsize=\"64\" type=\"dwa1_type\" />"}, /* regno=44 */
	{"mes", ""
		"<struct id=\"mes_type\" size=\"4\">\n"
			"<field name=\"pse\" start=\"0\" end=\"0\" />\n"
			"<field name=\"pilsy\" start=\"1\" end=\"1\" />\n"
			"<field name=\"pilde\" start=\"2\" end=\"2\" />\n"
			"<field name=\"pilpa\" start=\"3\" end=\"3\" />\n"
			"<field name=\"dse\" start=\"4\" end=\"4\" />\n"
			"<field name=\"dilsy\" start=\"5\" end=\"5\" />\n"
			"<field name=\"dilde\" start=\"6\" end=\"6\" />\n"
			"<field name=\"dilpa\" start=\"7\" end=\"7\" />\n"
			"<field name=\"ddee\" start=\"8\" end=\"8\" />\n"
			"<field name=\"dsye\" start=\"9\" end=\"9\" />\n"
		"</struct>\n"
		"<reg name=\"mes\" regnum=\"%d\" bitsize=\"32\" type=\"mes_type\" />"}, /* regno=45 */
	{"ws", ""
		"<struct id=\"ws_type\" size=\"4\">\n"
			"<field name=\"wu0\" start=\"0\" end=\"0\" />\n"
			"<field name=\"wu1\" start=\"1\" end=\"1\" />\n"
			"<field name=\"wu2\" start=\"2\" end=\"2\" />\n"
		"</struct>\n"
		"<reg name=\"ws\" regnum=\"%d\" bitsize=\"32\" type=\"ws_type\" />"}, /* regno=46 */
	{"dc0", ""
		"<struct id=\"dc0_type\" size=\"8\">\n"
			"<field name=\"be\" start=\"0\" end=\"0\" />\n"
			"<field name=\"we\" start=\"1\" end=\"1\" />\n"
			"<field name=\"wtyp\" start=\"2\" end=\"3\" />\n"
			"<field name=\"wsz\" start=\"4\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"dc0\" regnum=\"%d\" bitsize=\"64\" type=\"dc0_type\" />"}, /* regno=47 */
	{"dc1", ""
		"<struct id=\"dc1_type\" size=\"8\">\n"
			"<field name=\"be\" start=\"0\" end=\"0\" />\n"
			"<field name=\"we\" start=\"1\" end=\"1\" />\n"
			"<field name=\"wtyp\" start=\"2\" end=\"3\" />\n"
			"<field name=\"wsz\" start=\"4\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"dc1\" regnum=\"%d\" bitsize=\"64\" type=\"dc1_type\" />"}, /* regno=48 */
	{"dc2", ""
		"<struct id=\"dc2_type\" size=\"8\">\n"
			"<field name=\"be\" start=\"0\" end=\"0\" />\n"
			"<field name=\"we\" start=\"1\" end=\"1\" />\n"
			"<field name=\"wtyp\" start=\"2\" end=\"3\" />\n"
			"<field name=\"wsz\" start=\"4\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"dc2\" regnum=\"%d\" bitsize=\"64\" type=\"dc2_type\" />"}, /* regno=49 */
	{"dc3", ""
		"<struct id=\"dc3_type\" size=\"8\">\n"
			"<field name=\"be\" start=\"0\" end=\"0\" />\n"
			"<field name=\"we\" start=\"1\" end=\"1\" />\n"
			"<field name=\"wtyp\" start=\"2\" end=\"3\" />\n"
			"<field name=\"wsz\" start=\"4\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"dc3\" regnum=\"%d\" bitsize=\"64\" type=\"dc3_type\" />"}, /* regno=50 */
	{"dba2", ""
		"<struct id=\"dba2_type\" size=\"8\">\n"
			"<field name=\"dba2\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dba2\" regnum=\"%d\" bitsize=\"64\" type=\"dba2_type\" />"}, /* regno=51 */
	{"dba3", ""
		"<struct id=\"dba3_type\" size=\"8\">\n"
			"<field name=\"dba3\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dba3\" regnum=\"%d\" bitsize=\"64\" type=\"dba3_type\" />"}, /* regno=52 */
	{"dwa2", ""
		"<struct id=\"dwa2_type\" size=\"8\">\n"
			"<field name=\"dwa2\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dwa2\" regnum=\"%d\" bitsize=\"64\" type=\"dwa2_type\" />"}, /* regno=53 */
	{"dwa3", ""
		"<struct id=\"dwa3_type\" size=\"8\">\n"
			"<field name=\"dwa3\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"dwa3\" regnum=\"%d\" bitsize=\"64\" type=\"dwa3_type\" />"}, /* regno=54 */
	{"tpcm2", ""
		"<struct id=\"tpcm2_type\" size=\"8\">\n"
			"<field name=\"tpcm_2\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"tpcm2\" regnum=\"%d\" bitsize=\"64\" type=\"tpcm2_type\" />"}, /* regno=55 */
	{"tpcmc", ""
		"<struct id=\"tpcmc_type\" size=\"8\">\n"
			"<field name=\"tpcm_pld\" start=\"0\" end=\"4\" />\n"
			"<field name=\"tpcm_sts\" start=\"5\" end=\"6\" />\n"
		"</struct>\n"
		"<reg name=\"tpcmc\" regnum=\"%d\" bitsize=\"64\" type=\"tpcmc_type\" />"}, /* regno=56 */
	{"pm4", ""
		"<struct id=\"pm4_type\" size=\"8\">\n"
			"<field name=\"pm4\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm4\" regnum=\"%d\" bitsize=\"64\" type=\"pm4_type\" />"}, /* regno=57 */
	{"pm5", ""
		"<struct id=\"pm5_type\" size=\"8\">\n"
			"<field name=\"pm5\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm5\" regnum=\"%d\" bitsize=\"64\" type=\"pm5_type\" />"}, /* regno=58 */
	{"pm6", ""
		"<struct id=\"pm6_type\" size=\"8\">\n"
			"<field name=\"pm6\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm6\" regnum=\"%d\" bitsize=\"64\" type=\"pm6_type\" />"}, /* regno=59 */
	{"pm7", ""
		"<struct id=\"pm7_type\" size=\"8\">\n"
			"<field name=\"pm7\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"pm7\" regnum=\"%d\" bitsize=\"64\" type=\"pm7_type\" />"}, /* regno=60 */
	{"pmc2", ""
		"<struct id=\"pmc2_type\" size=\"8\">\n"
			"<field name=\"pm4c\" start=\"0\" end=\"5\" />\n"
			"<field name=\"pm5c\" start=\"7\" end=\"12\" />\n"
			"<field name=\"pm6c\" start=\"14\" end=\"19\" />\n"
			"<field name=\"pm7c\" start=\"21\" end=\"26\" />\n"
			"<field name=\"pm4ie\" start=\"32\" end=\"32\" />\n"
			"<field name=\"pm5ie\" start=\"33\" end=\"33\" />\n"
			"<field name=\"pm6ie\" start=\"34\" end=\"34\" />\n"
			"<field name=\"pm7ie\" start=\"35\" end=\"35\" />\n"
		"</struct>\n"
		"<reg name=\"pmc2\" regnum=\"%d\" bitsize=\"64\" type=\"pmc2_type\" />"}, /* regno=61 */
	{"srhpc", ""
		"<struct id=\"srhpc_type\" size=\"8\">\n"
			"<field name=\"srhpc\" start=\"0\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"srhpc\" regnum=\"%d\" bitsize=\"64\" type=\"srhpc_type\" />"}, /* regno=62 */
	{"frcc", "<reg name=\"frcc\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=63 */
	{"spc_pl0", "<reg name=\"spc_pl0\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=64 */
	{"spc_pl1", "<reg name=\"spc_pl1\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=65 */
	{"spc_pl2", "<reg name=\"spc_pl2\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=66 */
	{"spc_pl3", "<reg name=\"spc_pl3\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=67 */
	{"sps_pl0", ""
		"<struct id=\"sps_pl0_type\" size=\"4\">\n"
			"<field name=\"pl\" start=\"0\" end=\"1\" />\n"
			"<field name=\"et\" start=\"2\" end=\"2\" />\n"
			"<field name=\"htd\" start=\"3\" end=\"3\" />\n"
			"<field name=\"ie\" start=\"4\" end=\"4\" />\n"
			"<field name=\"hle\" start=\"5\" end=\"5\" />\n"
			"<field name=\"sre\" start=\"6\" end=\"6\" />\n"
			"<field name=\"daus\" start=\"7\" end=\"7\" />\n"
			"<field name=\"ice\" start=\"8\" end=\"8\" />\n"
			"<field name=\"use\" start=\"9\" end=\"9\" />\n"
			"<field name=\"dce\" start=\"10\" end=\"10\" />\n"
			"<field name=\"mme\" start=\"11\" end=\"11\" />\n"
			"<field name=\"il\" start=\"12\" end=\"13\" />\n"
			"<field name=\"vs\" start=\"14\" end=\"15\" />\n"
			"<field name=\"v64\" start=\"16\" end=\"16\" />\n"
			"<field name=\"l2e\" start=\"17\" end=\"17\" />\n"
			"<field name=\"sme\" start=\"18\" end=\"18\" />\n"
			"<field name=\"smr\" start=\"19\" end=\"19\" />\n"
			"<field name=\"pmj\" start=\"20\" end=\"23\" />\n"
			"<field name=\"mmup\" start=\"24\" end=\"24\" />\n"
		"</struct>\n"
		"<reg name=\"sps_pl0\" regnum=\"%d\" bitsize=\"32\" type=\"sps_pl0_type\" />"}, /* regno=68 */
	{"sps_pl1", ""
		"<struct id=\"sps_pl1_type\" size=\"4\">\n"
			"<field name=\"pl\" start=\"0\" end=\"1\" />\n"
			"<field name=\"et\" start=\"2\" end=\"2\" />\n"
			"<field name=\"htd\" start=\"3\" end=\"3\" />\n"
			"<field name=\"ie\" start=\"4\" end=\"4\" />\n"
			"<field name=\"hle\" start=\"5\" end=\"5\" />\n"
			"<field name=\"sre\" start=\"6\" end=\"6\" />\n"
			"<field name=\"daus\" start=\"7\" end=\"7\" />\n"
			"<field name=\"ice\" start=\"8\" end=\"8\" />\n"
			"<field name=\"use\" start=\"9\" end=\"9\" />\n"
			"<field name=\"dce\" start=\"10\" end=\"10\" />\n"
			"<field name=\"mme\" start=\"11\" end=\"11\" />\n"
			"<field name=\"il\" start=\"12\" end=\"13\" />\n"
			"<field name=\"vs\" start=\"14\" end=\"15\" />\n"
			"<field name=\"v64\" start=\"16\" end=\"16\" />\n"
			"<field name=\"l2e\" start=\"17\" end=\"17\" />\n"
			"<field name=\"sme\" start=\"18\" end=\"18\" />\n"
			"<field name=\"smr\" start=\"19\" end=\"19\" />\n"
			"<field name=\"pmj\" start=\"20\" end=\"23\" />\n"
			"<field name=\"mmup\" start=\"24\" end=\"24\" />\n"
		"</struct>\n"
		"<reg name=\"sps_pl1\" regnum=\"%d\" bitsize=\"32\" type=\"sps_pl1_type\" />"}, /* regno=69 */
	{"sps_pl2", ""
		"<struct id=\"sps_pl2_type\" size=\"4\">\n"
			"<field name=\"pl\" start=\"0\" end=\"1\" />\n"
			"<field name=\"et\" start=\"2\" end=\"2\" />\n"
			"<field name=\"htd\" start=\"3\" end=\"3\" />\n"
			"<field name=\"ie\" start=\"4\" end=\"4\" />\n"
			"<field name=\"hle\" start=\"5\" end=\"5\" />\n"
			"<field name=\"sre\" start=\"6\" end=\"6\" />\n"
			"<field name=\"daus\" start=\"7\" end=\"7\" />\n"
			"<field name=\"ice\" start=\"8\" end=\"8\" />\n"
			"<field name=\"use\" start=\"9\" end=\"9\" />\n"
			"<field name=\"dce\" start=\"10\" end=\"10\" />\n"
			"<field name=\"mme\" start=\"11\" end=\"11\" />\n"
			"<field name=\"il\" start=\"12\" end=\"13\" />\n"
			"<field name=\"vs\" start=\"14\" end=\"15\" />\n"
			"<field name=\"v64\" start=\"16\" end=\"16\" />\n"
			"<field name=\"l2e\" start=\"17\" end=\"17\" />\n"
			"<field name=\"sme\" start=\"18\" end=\"18\" />\n"
			"<field name=\"smr\" start=\"19\" end=\"19\" />\n"
			"<field name=\"pmj\" start=\"20\" end=\"23\" />\n"
			"<field name=\"mmup\" start=\"24\" end=\"24\" />\n"
		"</struct>\n"
		"<reg name=\"sps_pl2\" regnum=\"%d\" bitsize=\"32\" type=\"sps_pl2_type\" />"}, /* regno=70 */
	{"sps_pl3", ""
		"<struct id=\"sps_pl3_type\" size=\"4\">\n"
			"<field name=\"pl\" start=\"0\" end=\"1\" />\n"
			"<field name=\"et\" start=\"2\" end=\"2\" />\n"
			"<field name=\"htd\" start=\"3\" end=\"3\" />\n"
			"<field name=\"ie\" start=\"4\" end=\"4\" />\n"
			"<field name=\"hle\" start=\"5\" end=\"5\" />\n"
			"<field name=\"sre\" start=\"6\" end=\"6\" />\n"
			"<field name=\"daus\" start=\"7\" end=\"7\" />\n"
			"<field name=\"ice\" start=\"8\" end=\"8\" />\n"
			"<field name=\"use\" start=\"9\" end=\"9\" />\n"
			"<field name=\"dce\" start=\"10\" end=\"10\" />\n"
			"<field name=\"mme\" start=\"11\" end=\"11\" />\n"
			"<field name=\"il\" start=\"12\" end=\"13\" />\n"
			"<field name=\"vs\" start=\"14\" end=\"15\" />\n"
			"<field name=\"v64\" start=\"16\" end=\"16\" />\n"
			"<field name=\"l2e\" start=\"17\" end=\"17\" />\n"
			"<field name=\"sme\" start=\"18\" end=\"18\" />\n"
			"<field name=\"smr\" start=\"19\" end=\"19\" />\n"
			"<field name=\"pmj\" start=\"20\" end=\"23\" />\n"
			"<field name=\"mmup\" start=\"24\" end=\"24\" />\n"
		"</struct>\n"
		"<reg name=\"sps_pl3\" regnum=\"%d\" bitsize=\"32\" type=\"sps_pl3_type\" />"}, /* regno=71 */
	{"ea_pl0", "<reg name=\"ea_pl0\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=72 */
	{"ea_pl1", "<reg name=\"ea_pl1\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=73 */
	{"ea_pl2", "<reg name=\"ea_pl2\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=74 */
	{"ea_pl3", "<reg name=\"ea_pl3\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=75 */
	{"ev_pl0", "<reg name=\"ev_pl0\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=76 */
	{"ev_pl1", "<reg name=\"ev_pl1\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=77 */
	{"ev_pl2", "<reg name=\"ev_pl2\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=78 */
	{"ev_pl3", "<reg name=\"ev_pl3\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=79 */
	{"sr_pl0", "<reg name=\"sr_pl0\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=80 */
	{"sr_pl1", "<reg name=\"sr_pl1\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=81 */
	{"sr_pl2", "<reg name=\"sr_pl2\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=82 */
	{"sr_pl3", "<reg name=\"sr_pl3\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=83 */
	{"es_pl0", ""
		"<struct id=\"es_pl0_type\" size=\"8\">\n"
			"<field name=\"ec\" start=\"0\" end=\"3\" />\n"
			"<field name=\"oapl\" start=\"4\" end=\"5\" />\n"
			"<field name=\"ed\" start=\"4\" end=\"63\" />\n"
			"<field name=\"orpl\" start=\"6\" end=\"7\" />\n"
			"<field name=\"ptapl\" start=\"8\" end=\"9\" />\n"
			"<field name=\"ptrpl\" start=\"10\" end=\"11\" />\n"
			"<field name=\"dcv2\" start=\"12\" end=\"14\" />\n"
			"<field name=\"itn\" start=\"12\" end=\"16\" />\n"
			"<field name=\"htc\" start=\"12\" end=\"16\" />\n"
			"<field name=\"sn\" start=\"12\" end=\"23\" />\n"
			"<field name=\"wbn\" start=\"15\" end=\"16\" />\n"
			"<field name=\"sfrt\" start=\"17\" end=\"17\" />\n"
			"<field name=\"itl\" start=\"17\" end=\"18\" />\n"
			"<field name=\"sfri\" start=\"18\" end=\"20\" />\n"
			"<field name=\"iti\" start=\"19\" end=\"28\" />\n"
			"<field name=\"gprp\" start=\"21\" end=\"26\" />\n"
			"<field name=\"sfrp\" start=\"27\" end=\"35\" />\n"
			"<field name=\"dht\" start=\"36\" end=\"36\" />\n"
			"<field name=\"drx\" start=\"37\" end=\"37\" />\n"
			"<field name=\"daf\" start=\"38\" end=\"38\" />\n"
			"<field name=\"rwx\" start=\"39\" end=\"41\" />\n"
			"<field name=\"nta\" start=\"42\" end=\"42\" />\n"
			"<field name=\"uca\" start=\"43\" end=\"43\" />\n"
			"<field name=\"as\" start=\"44\" end=\"49\" />\n"
			"<field name=\"bs\" start=\"50\" end=\"53\" />\n"
			"<field name=\"dri\" start=\"54\" end=\"59\" />\n"
			"<field name=\"pic\" start=\"60\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"es_pl0\" regnum=\"%d\" bitsize=\"64\" type=\"es_pl0_type\" />"}, /* regno=84 */
	{"es_pl1", ""
		"<struct id=\"es_pl1_type\" size=\"8\">\n"
			"<field name=\"ec\" start=\"0\" end=\"3\" />\n"
			"<field name=\"oapl\" start=\"4\" end=\"5\" />\n"
			"<field name=\"ed\" start=\"4\" end=\"63\" />\n"
			"<field name=\"orpl\" start=\"6\" end=\"7\" />\n"
			"<field name=\"ptapl\" start=\"8\" end=\"9\" />\n"
			"<field name=\"ptrpl\" start=\"10\" end=\"11\" />\n"
			"<field name=\"dcv2\" start=\"12\" end=\"14\" />\n"
			"<field name=\"itn\" start=\"12\" end=\"16\" />\n"
			"<field name=\"htc\" start=\"12\" end=\"16\" />\n"
			"<field name=\"sn\" start=\"12\" end=\"23\" />\n"
			"<field name=\"wbn\" start=\"15\" end=\"16\" />\n"
			"<field name=\"sfrt\" start=\"17\" end=\"17\" />\n"
			"<field name=\"itl\" start=\"17\" end=\"18\" />\n"
			"<field name=\"sfri\" start=\"18\" end=\"20\" />\n"
			"<field name=\"iti\" start=\"19\" end=\"28\" />\n"
			"<field name=\"gprp\" start=\"21\" end=\"26\" />\n"
			"<field name=\"sfrp\" start=\"27\" end=\"35\" />\n"
			"<field name=\"dht\" start=\"36\" end=\"36\" />\n"
			"<field name=\"drx\" start=\"37\" end=\"37\" />\n"
			"<field name=\"daf\" start=\"38\" end=\"38\" />\n"
			"<field name=\"rwx\" start=\"39\" end=\"41\" />\n"
			"<field name=\"nta\" start=\"42\" end=\"42\" />\n"
			"<field name=\"uca\" start=\"43\" end=\"43\" />\n"
			"<field name=\"as\" start=\"44\" end=\"49\" />\n"
			"<field name=\"bs\" start=\"50\" end=\"53\" />\n"
			"<field name=\"dri\" start=\"54\" end=\"59\" />\n"
			"<field name=\"pic\" start=\"60\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"es_pl1\" regnum=\"%d\" bitsize=\"64\" type=\"es_pl1_type\" />"}, /* regno=85 */
	{"es_pl2", ""
		"<struct id=\"es_pl2_type\" size=\"8\">\n"
			"<field name=\"ec\" start=\"0\" end=\"3\" />\n"
			"<field name=\"oapl\" start=\"4\" end=\"5\" />\n"
			"<field name=\"ed\" start=\"4\" end=\"63\" />\n"
			"<field name=\"orpl\" start=\"6\" end=\"7\" />\n"
			"<field name=\"ptapl\" start=\"8\" end=\"9\" />\n"
			"<field name=\"ptrpl\" start=\"10\" end=\"11\" />\n"
			"<field name=\"dcv2\" start=\"12\" end=\"14\" />\n"
			"<field name=\"itn\" start=\"12\" end=\"16\" />\n"
			"<field name=\"htc\" start=\"12\" end=\"16\" />\n"
			"<field name=\"sn\" start=\"12\" end=\"23\" />\n"
			"<field name=\"wbn\" start=\"15\" end=\"16\" />\n"
			"<field name=\"sfrt\" start=\"17\" end=\"17\" />\n"
			"<field name=\"itl\" start=\"17\" end=\"18\" />\n"
			"<field name=\"sfri\" start=\"18\" end=\"20\" />\n"
			"<field name=\"iti\" start=\"19\" end=\"28\" />\n"
			"<field name=\"gprp\" start=\"21\" end=\"26\" />\n"
			"<field name=\"sfrp\" start=\"27\" end=\"35\" />\n"
			"<field name=\"dht\" start=\"36\" end=\"36\" />\n"
			"<field name=\"drx\" start=\"37\" end=\"37\" />\n"
			"<field name=\"daf\" start=\"38\" end=\"38\" />\n"
			"<field name=\"rwx\" start=\"39\" end=\"41\" />\n"
			"<field name=\"nta\" start=\"42\" end=\"42\" />\n"
			"<field name=\"uca\" start=\"43\" end=\"43\" />\n"
			"<field name=\"as\" start=\"44\" end=\"49\" />\n"
			"<field name=\"bs\" start=\"50\" end=\"53\" />\n"
			"<field name=\"dri\" start=\"54\" end=\"59\" />\n"
			"<field name=\"pic\" start=\"60\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"es_pl2\" regnum=\"%d\" bitsize=\"64\" type=\"es_pl2_type\" />"}, /* regno=86 */
	{"es_pl3", ""
		"<struct id=\"es_pl3_type\" size=\"8\">\n"
			"<field name=\"ec\" start=\"0\" end=\"3\" />\n"
			"<field name=\"oapl\" start=\"4\" end=\"5\" />\n"
			"<field name=\"ed\" start=\"4\" end=\"63\" />\n"
			"<field name=\"orpl\" start=\"6\" end=\"7\" />\n"
			"<field name=\"ptapl\" start=\"8\" end=\"9\" />\n"
			"<field name=\"ptrpl\" start=\"10\" end=\"11\" />\n"
			"<field name=\"dcv2\" start=\"12\" end=\"14\" />\n"
			"<field name=\"itn\" start=\"12\" end=\"16\" />\n"
			"<field name=\"htc\" start=\"12\" end=\"16\" />\n"
			"<field name=\"sn\" start=\"12\" end=\"23\" />\n"
			"<field name=\"wbn\" start=\"15\" end=\"16\" />\n"
			"<field name=\"sfrt\" start=\"17\" end=\"17\" />\n"
			"<field name=\"itl\" start=\"17\" end=\"18\" />\n"
			"<field name=\"sfri\" start=\"18\" end=\"20\" />\n"
			"<field name=\"iti\" start=\"19\" end=\"28\" />\n"
			"<field name=\"gprp\" start=\"21\" end=\"26\" />\n"
			"<field name=\"sfrp\" start=\"27\" end=\"35\" />\n"
			"<field name=\"dht\" start=\"36\" end=\"36\" />\n"
			"<field name=\"drx\" start=\"37\" end=\"37\" />\n"
			"<field name=\"daf\" start=\"38\" end=\"38\" />\n"
			"<field name=\"rwx\" start=\"39\" end=\"41\" />\n"
			"<field name=\"nta\" start=\"42\" end=\"42\" />\n"
			"<field name=\"uca\" start=\"43\" end=\"43\" />\n"
			"<field name=\"as\" start=\"44\" end=\"49\" />\n"
			"<field name=\"bs\" start=\"50\" end=\"53\" />\n"
			"<field name=\"dri\" start=\"54\" end=\"59\" />\n"
			"<field name=\"pic\" start=\"60\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"es_pl3\" regnum=\"%d\" bitsize=\"64\" type=\"es_pl3_type\" />"}, /* regno=87 */
	{"sid_pl0", ""
		"<struct id=\"sid_pl0_type\" size=\"4\">\n"
			"<field name=\"sid\" start=\"0\" end=\"8\" />\n"
		"</struct>\n"
		"<reg name=\"sid_pl0\" regnum=\"%d\" bitsize=\"32\" type=\"sid_pl0_type\" />"}, /* regno=88 */
	{"sid_pl1", ""
		"<struct id=\"sid_pl1_type\" size=\"4\">\n"
			"<field name=\"sid\" start=\"0\" end=\"8\" />\n"
		"</struct>\n"
		"<reg name=\"sid_pl1\" regnum=\"%d\" bitsize=\"32\" type=\"sid_pl1_type\" />"}, /* regno=89 */
	{"sid_pl2", ""
		"<struct id=\"sid_pl2_type\" size=\"4\">\n"
			"<field name=\"sid\" start=\"0\" end=\"8\" />\n"
		"</struct>\n"
		"<reg name=\"sid_pl2\" regnum=\"%d\" bitsize=\"32\" type=\"sid_pl2_type\" />"}, /* regno=90 */
	{"sid_pl3", ""
		"<struct id=\"sid_pl3_type\" size=\"4\">\n"
			"<field name=\"sid\" start=\"0\" end=\"8\" />\n"
		"</struct>\n"
		"<reg name=\"sid_pl3\" regnum=\"%d\" bitsize=\"32\" type=\"sid_pl3_type\" />"}, /* regno=91 */
	{"sr1_pl0", "<reg name=\"sr1_pl0\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=92 */
	{"sr1_pl1", "<reg name=\"sr1_pl1\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=93 */
	{"sr1_pl2", "<reg name=\"sr1_pl2\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=94 */
	{"sr1_pl3", "<reg name=\"sr1_pl3\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=95 */
	{"syow", ""
		"<struct id=\"syow_type\" size=\"4\">\n"
			"<field name=\"q0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"q1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"q2\" start=\"4\" end=\"5\" />\n"
			"<field name=\"q3\" start=\"6\" end=\"7\" />\n"
		"</struct>\n"
		"<reg name=\"syow\" regnum=\"%d\" bitsize=\"32\" type=\"syow_type\" />"}, /* regno=96 */
	{"htow", ""
		"<struct id=\"htow_type\" size=\"4\">\n"
			"<field name=\"opc\" start=\"0\" end=\"1\" />\n"
			"<field name=\"dmis\" start=\"2\" end=\"3\" />\n"
			"<field name=\"psys\" start=\"4\" end=\"5\" />\n"
			"<field name=\"dsys\" start=\"6\" end=\"7\" />\n"
			"<field name=\"deccg\" start=\"8\" end=\"9\" />\n"
			"<field name=\"seccg\" start=\"10\" end=\"11\" />\n"
			"<field name=\"nomap\" start=\"12\" end=\"13\" />\n"
			"<field name=\"prot\" start=\"14\" end=\"15\" />\n"
			"<field name=\"w2cl\" start=\"16\" end=\"17\" />\n"
			"<field name=\"a2cl\" start=\"18\" end=\"19\" />\n"
			"<field name=\"de\" start=\"20\" end=\"21\" />\n"
			"<field name=\"vsfr\" start=\"22\" end=\"23\" />\n"
			"<field name=\"plo\" start=\"24\" end=\"25\" />\n"
		"</struct>\n"
		"<reg name=\"htow\" regnum=\"%d\" bitsize=\"32\" type=\"htow_type\" />"}, /* regno=97 */
	{"itow", ""
		"<struct id=\"itow_type\" size=\"8\">\n"
			"<field name=\"it0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"it1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"it2\" start=\"4\" end=\"5\" />\n"
			"<field name=\"it3\" start=\"6\" end=\"7\" />\n"
			"<field name=\"it4\" start=\"8\" end=\"9\" />\n"
			"<field name=\"it5\" start=\"10\" end=\"11\" />\n"
			"<field name=\"it6\" start=\"12\" end=\"13\" />\n"
			"<field name=\"it7\" start=\"14\" end=\"15\" />\n"
			"<field name=\"it8\" start=\"16\" end=\"17\" />\n"
			"<field name=\"it9\" start=\"18\" end=\"19\" />\n"
			"<field name=\"it10\" start=\"20\" end=\"21\" />\n"
			"<field name=\"it11\" start=\"22\" end=\"23\" />\n"
			"<field name=\"it12\" start=\"24\" end=\"25\" />\n"
			"<field name=\"it13\" start=\"26\" end=\"27\" />\n"
			"<field name=\"it14\" start=\"28\" end=\"29\" />\n"
			"<field name=\"it15\" start=\"30\" end=\"31\" />\n"
			"<field name=\"it16\" start=\"32\" end=\"33\" />\n"
			"<field name=\"it17\" start=\"34\" end=\"35\" />\n"
			"<field name=\"it18\" start=\"36\" end=\"37\" />\n"
			"<field name=\"it19\" start=\"38\" end=\"39\" />\n"
			"<field name=\"it20\" start=\"40\" end=\"41\" />\n"
			"<field name=\"it21\" start=\"42\" end=\"43\" />\n"
			"<field name=\"it22\" start=\"44\" end=\"45\" />\n"
			"<field name=\"it23\" start=\"46\" end=\"47\" />\n"
			"<field name=\"it24\" start=\"48\" end=\"49\" />\n"
			"<field name=\"it25\" start=\"50\" end=\"51\" />\n"
			"<field name=\"it26\" start=\"52\" end=\"53\" />\n"
			"<field name=\"it27\" start=\"54\" end=\"55\" />\n"
			"<field name=\"it28\" start=\"56\" end=\"57\" />\n"
			"<field name=\"it29\" start=\"58\" end=\"59\" />\n"
			"<field name=\"it30\" start=\"60\" end=\"61\" />\n"
			"<field name=\"it31\" start=\"62\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"itow\" regnum=\"%d\" bitsize=\"64\" type=\"itow_type\" />"}, /* regno=98 */
	{"dow", ""
		"<struct id=\"dow_type\" size=\"4\">\n"
			"<field name=\"b0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"b1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"w0\" start=\"4\" end=\"5\" />\n"
			"<field name=\"w1\" start=\"6\" end=\"7\" />\n"
			"<field name=\"b2\" start=\"8\" end=\"9\" />\n"
			"<field name=\"b3\" start=\"10\" end=\"11\" />\n"
			"<field name=\"w2\" start=\"12\" end=\"13\" />\n"
			"<field name=\"w3\" start=\"14\" end=\"15\" />\n"
			"<field name=\"bi0\" start=\"16\" end=\"17\" />\n"
			"<field name=\"bi1\" start=\"18\" end=\"19\" />\n"
			"<field name=\"bi2\" start=\"20\" end=\"21\" />\n"
			"<field name=\"bi3\" start=\"22\" end=\"23\" />\n"
		"</struct>\n"
		"<reg name=\"dow\" regnum=\"%d\" bitsize=\"32\" type=\"dow_type\" />"}, /* regno=99 */
	{"mow", ""
		"<struct id=\"mow_type\" size=\"8\">\n"
			"<field name=\"mmi\" start=\"0\" end=\"1\" />\n"
			"<field name=\"rfe\" start=\"2\" end=\"3\" />\n"
			"<field name=\"stop\" start=\"4\" end=\"5\" />\n"
			"<field name=\"sync\" start=\"6\" end=\"7\" />\n"
			"<field name=\"pcr\" start=\"8\" end=\"9\" />\n"
			"<field name=\"msg\" start=\"10\" end=\"11\" />\n"
			"<field name=\"men\" start=\"12\" end=\"13\" />\n"
			"<field name=\"mes\" start=\"14\" end=\"15\" />\n"
			"<field name=\"csit\" start=\"16\" end=\"17\" />\n"
			"<field name=\"t0\" start=\"18\" end=\"19\" />\n"
			"<field name=\"t1\" start=\"20\" end=\"21\" />\n"
			"<field name=\"wd\" start=\"22\" end=\"23\" />\n"
			"<field name=\"pm0\" start=\"24\" end=\"25\" />\n"
			"<field name=\"pm1\" start=\"26\" end=\"27\" />\n"
			"<field name=\"pm2\" start=\"28\" end=\"29\" />\n"
			"<field name=\"pm3\" start=\"30\" end=\"31\" />\n"
			"<field name=\"pmit\" start=\"32\" end=\"33\" />\n"
			"<field name=\"comm\" start=\"34\" end=\"35\" />\n"
			"<field name=\"tpcm\" start=\"36\" end=\"37\" />\n"
			"<field name=\"disw\" start=\"38\" end=\"39\" />\n"
			"<field name=\"pm4\" start=\"40\" end=\"41\" />\n"
			"<field name=\"pm5\" start=\"42\" end=\"43\" />\n"
			"<field name=\"pm6\" start=\"44\" end=\"45\" />\n"
			"<field name=\"pm7\" start=\"46\" end=\"47\" />\n"
			"<field name=\"srhpc\" start=\"48\" end=\"49\" />\n"
		"</struct>\n"
		"<reg name=\"mow\" regnum=\"%d\" bitsize=\"64\" type=\"mow_type\" />"}, /* regno=100 */
	{"psow", ""
		"<struct id=\"psow_type\" size=\"8\">\n"
			"<field name=\"pl0\" start=\"0\" end=\"1\" />\n"
			"<field name=\"pl1\" start=\"2\" end=\"3\" />\n"
			"<field name=\"et\" start=\"4\" end=\"5\" />\n"
			"<field name=\"htd\" start=\"6\" end=\"7\" />\n"
			"<field name=\"ie\" start=\"8\" end=\"9\" />\n"
			"<field name=\"hle\" start=\"10\" end=\"11\" />\n"
			"<field name=\"sre\" start=\"12\" end=\"13\" />\n"
			"<field name=\"daus\" start=\"14\" end=\"15\" />\n"
			"<field name=\"ice\" start=\"16\" end=\"17\" />\n"
			"<field name=\"use\" start=\"18\" end=\"19\" />\n"
			"<field name=\"dce\" start=\"20\" end=\"21\" />\n"
			"<field name=\"mme\" start=\"22\" end=\"23\" />\n"
			"<field name=\"il0\" start=\"24\" end=\"25\" />\n"
			"<field name=\"il1\" start=\"26\" end=\"27\" />\n"
			"<field name=\"vs0\" start=\"28\" end=\"29\" />\n"
			"<field name=\"vs1\" start=\"30\" end=\"31\" />\n"
			"<field name=\"l2e\" start=\"34\" end=\"35\" />\n"
			"<field name=\"sme\" start=\"36\" end=\"37\" />\n"
			"<field name=\"smr\" start=\"38\" end=\"39\" />\n"
			"<field name=\"pmj0\" start=\"40\" end=\"41\" />\n"
			"<field name=\"pmj1\" start=\"42\" end=\"43\" />\n"
			"<field name=\"pmj2\" start=\"44\" end=\"45\" />\n"
			"<field name=\"pmj3\" start=\"46\" end=\"47\" />\n"
			"<field name=\"mmup\" start=\"48\" end=\"49\" />\n"
		"</struct>\n"
		"<reg name=\"psow\" regnum=\"%d\" bitsize=\"64\" type=\"psow_type\" />"}, /* regno=101 */
	{"res102", "<reg name=\"res102\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=102 */
	{"res103", "<reg name=\"res103\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=103 */
	{"tpcc_pl0", ""
		"<struct id=\"tpcc_pl0_type\" size=\"4\">\n"
			"<field name=\"tpcc\" start=\"0\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"tpcc_pl0\" regnum=\"%d\" bitsize=\"32\" type=\"tpcc_pl0_type\" />"}, /* regno=104 */
	{"tpcc_pl1", ""
		"<struct id=\"tpcc_pl1_type\" size=\"4\">\n"
			"<field name=\"tpcc\" start=\"0\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"tpcc_pl1\" regnum=\"%d\" bitsize=\"32\" type=\"tpcc_pl1_type\" />"}, /* regno=105 */
	{"tpcc_pl2", ""
		"<struct id=\"tpcc_pl2_type\" size=\"4\">\n"
			"<field name=\"tpcc\" start=\"0\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"tpcc_pl2\" regnum=\"%d\" bitsize=\"32\" type=\"tpcc_pl2_type\" />"}, /* regno=106 */
	{"tpcc_pl3", ""
		"<struct id=\"tpcc_pl3_type\" size=\"4\">\n"
			"<field name=\"tpcc\" start=\"0\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"tpcc_pl3\" regnum=\"%d\" bitsize=\"32\" type=\"tpcc_pl3_type\" />"}, /* regno=107 */
	{"res108", "<reg name=\"res108\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=108 */
	{"res109", "<reg name=\"res109\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=109 */
	{"res110", "<reg name=\"res110\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=110 */
	{"res111", "<reg name=\"res111\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=111 */
	{"res112", "<reg name=\"res112\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=112 */
	{"res113", "<reg name=\"res113\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=113 */
	{"res114", "<reg name=\"res114\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=114 */
	{"res115", "<reg name=\"res115\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=115 */
	{"res116", "<reg name=\"res116\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=116 */
	{"res117", "<reg name=\"res117\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=117 */
	{"res118", "<reg name=\"res118\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=118 */
	{"res119", "<reg name=\"res119\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=119 */
	{"res120", "<reg name=\"res120\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=120 */
	{"res121", "<reg name=\"res121\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=121 */
	{"res122", "<reg name=\"res122\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=122 */
	{"res123", "<reg name=\"res123\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=123 */
	{"res124", "<reg name=\"res124\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=124 */
	{"res125", "<reg name=\"res125\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=125 */
	{"res126", "<reg name=\"res126\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=126 */
	{"res127", "<reg name=\"res127\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=127 */
	{"spc", "<reg name=\"spc\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=128 */
	{"res129", "<reg name=\"res129\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=129 */
	{"res130", "<reg name=\"res130\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=130 */
	{"res131", "<reg name=\"res131\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=131 */
	{"sps", ""
		"<struct id=\"sps_type\" size=\"4\">\n"
			"<field name=\"pl\" start=\"0\" end=\"1\" />\n"
			"<field name=\"et\" start=\"2\" end=\"2\" />\n"
			"<field name=\"htd\" start=\"3\" end=\"3\" />\n"
			"<field name=\"ie\" start=\"4\" end=\"4\" />\n"
			"<field name=\"hle\" start=\"5\" end=\"5\" />\n"
			"<field name=\"sre\" start=\"6\" end=\"6\" />\n"
			"<field name=\"daus\" start=\"7\" end=\"7\" />\n"
			"<field name=\"ice\" start=\"8\" end=\"8\" />\n"
			"<field name=\"use\" start=\"9\" end=\"9\" />\n"
			"<field name=\"dce\" start=\"10\" end=\"10\" />\n"
			"<field name=\"mme\" start=\"11\" end=\"11\" />\n"
			"<field name=\"il\" start=\"12\" end=\"13\" />\n"
			"<field name=\"vs\" start=\"14\" end=\"15\" />\n"
			"<field name=\"v64\" start=\"16\" end=\"16\" />\n"
			"<field name=\"l2e\" start=\"17\" end=\"17\" />\n"
			"<field name=\"sme\" start=\"18\" end=\"18\" />\n"
			"<field name=\"smr\" start=\"19\" end=\"19\" />\n"
			"<field name=\"pmj\" start=\"20\" end=\"23\" />\n"
			"<field name=\"mmup\" start=\"24\" end=\"24\" />\n"
		"</struct>\n"
		"<reg name=\"sps\" regnum=\"%d\" bitsize=\"32\" type=\"sps_type\" />"}, /* regno=132 */
	{"res133", "<reg name=\"res133\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=133 */
	{"res134", "<reg name=\"res134\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=134 */
	{"res135", "<reg name=\"res135\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=135 */
	{"ea", "<reg name=\"ea\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=136 */
	{"res137", "<reg name=\"res137\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=137 */
	{"res138", "<reg name=\"res138\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=138 */
	{"res139", "<reg name=\"res139\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=139 */
	{"ev", "<reg name=\"ev\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=140 */
	{"res141", "<reg name=\"res141\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=141 */
	{"res142", "<reg name=\"res142\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=142 */
	{"res143", "<reg name=\"res143\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=143 */
	{"sr", "<reg name=\"sr\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=144 */
	{"res145", "<reg name=\"res145\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=145 */
	{"res146", "<reg name=\"res146\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=146 */
	{"res147", "<reg name=\"res147\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=147 */
	{"es", ""
		"<struct id=\"es_type\" size=\"8\">\n"
			"<field name=\"ec\" start=\"0\" end=\"3\" />\n"
			"<field name=\"oapl\" start=\"4\" end=\"5\" />\n"
			"<field name=\"ed\" start=\"4\" end=\"63\" />\n"
			"<field name=\"orpl\" start=\"6\" end=\"7\" />\n"
			"<field name=\"ptapl\" start=\"8\" end=\"9\" />\n"
			"<field name=\"ptrpl\" start=\"10\" end=\"11\" />\n"
			"<field name=\"dcv2\" start=\"12\" end=\"14\" />\n"
			"<field name=\"itn\" start=\"12\" end=\"16\" />\n"
			"<field name=\"htc\" start=\"12\" end=\"16\" />\n"
			"<field name=\"sn\" start=\"12\" end=\"23\" />\n"
			"<field name=\"wbn\" start=\"15\" end=\"16\" />\n"
			"<field name=\"sfrt\" start=\"17\" end=\"17\" />\n"
			"<field name=\"itl\" start=\"17\" end=\"18\" />\n"
			"<field name=\"sfri\" start=\"18\" end=\"20\" />\n"
			"<field name=\"iti\" start=\"19\" end=\"28\" />\n"
			"<field name=\"gprp\" start=\"21\" end=\"26\" />\n"
			"<field name=\"sfrp\" start=\"27\" end=\"35\" />\n"
			"<field name=\"dht\" start=\"36\" end=\"36\" />\n"
			"<field name=\"drx\" start=\"37\" end=\"37\" />\n"
			"<field name=\"daf\" start=\"38\" end=\"38\" />\n"
			"<field name=\"rwx\" start=\"39\" end=\"41\" />\n"
			"<field name=\"nta\" start=\"42\" end=\"42\" />\n"
			"<field name=\"uca\" start=\"43\" end=\"43\" />\n"
			"<field name=\"as\" start=\"44\" end=\"49\" />\n"
			"<field name=\"bs\" start=\"50\" end=\"53\" />\n"
			"<field name=\"dri\" start=\"54\" end=\"59\" />\n"
			"<field name=\"pic\" start=\"60\" end=\"63\" />\n"
		"</struct>\n"
		"<reg name=\"es\" regnum=\"%d\" bitsize=\"64\" type=\"es_type\" />"}, /* regno=148 */
	{"res149", "<reg name=\"res149\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=149 */
	{"res150", "<reg name=\"res150\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=150 */
	{"res151", "<reg name=\"res151\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=151 */
	{"sid", ""
		"<struct id=\"sid_type\" size=\"4\">\n"
			"<field name=\"sid\" start=\"0\" end=\"8\" />\n"
		"</struct>\n"
		"<reg name=\"sid\" regnum=\"%d\" bitsize=\"32\" type=\"sid_type\" />"}, /* regno=152 */
	{"res153", "<reg name=\"res153\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=153 */
	{"res154", "<reg name=\"res154\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=154 */
	{"res155", "<reg name=\"res155\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=155 */
	{"sr1", "<reg name=\"sr1\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=156 */
	{"res157", "<reg name=\"res157\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=157 */
	{"res158", "<reg name=\"res158\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=158 */
	{"res159", "<reg name=\"res159\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=159 */
	{"res160", "<reg name=\"res160\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=160 */
	{"res161", "<reg name=\"res161\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=161 */
	{"res162", "<reg name=\"res162\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=162 */
	{"res163", "<reg name=\"res163\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=163 */
	{"res164", "<reg name=\"res164\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=164 */
	{"res165", "<reg name=\"res165\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=165 */
	{"res166", "<reg name=\"res166\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=166 */
	{"res167", "<reg name=\"res167\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=167 */
	{"tpcc", ""
		"<struct id=\"tpcc_type\" size=\"4\">\n"
			"<field name=\"tpcc\" start=\"0\" end=\"31\" />\n"
		"</struct>\n"
		"<reg name=\"tpcc\" regnum=\"%d\" bitsize=\"32\" type=\"tpcc_type\" />"}, /* regno=168 */
	{"res169", "<reg name=\"res169\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=169 */
	{"res170", "<reg name=\"res170\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=170 */
	{"res171", "<reg name=\"res171\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=171 */
	{"res172", "<reg name=\"res172\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=172 */
	{"res173", "<reg name=\"res173\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=173 */
	{"res174", "<reg name=\"res174\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=174 */
	{"res175", "<reg name=\"res175\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=175 */
	{"res176", "<reg name=\"res176\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=176 */
	{"res177", "<reg name=\"res177\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=177 */
	{"res178", "<reg name=\"res178\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=178 */
	{"res179", "<reg name=\"res179\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=179 */
	{"res180", "<reg name=\"res180\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=180 */
	{"res181", "<reg name=\"res181\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=181 */
	{"res182", "<reg name=\"res182\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=182 */
	{"res183", "<reg name=\"res183\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=183 */
	{"res184", "<reg name=\"res184\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=184 */
	{"res185", "<reg name=\"res185\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=185 */
	{"res186", "<reg name=\"res186\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=186 */
	{"res187", "<reg name=\"res187\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=187 */
	{"res188", "<reg name=\"res188\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=188 */
	{"res189", "<reg name=\"res189\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=189 */
	{"res190", "<reg name=\"res190\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=190 */
	{"res191", "<reg name=\"res191\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=191 */
	{"r0", "<reg name=\"r0\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=192 */
	{"r1", "<reg name=\"r1\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=193 */
	{"r2", "<reg name=\"r2\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=194 */
	{"r3", "<reg name=\"r3\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=195 */
	{"r4", "<reg name=\"r4\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=196 */
	{"r5", "<reg name=\"r5\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=197 */
	{"r6", "<reg name=\"r6\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=198 */
	{"r7", "<reg name=\"r7\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=199 */
	{"r8", "<reg name=\"r8\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=200 */
	{"r9", "<reg name=\"r9\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=201 */
	{"r10", "<reg name=\"r10\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=202 */
	{"r11", "<reg name=\"r11\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=203 */
	{"r12", "<reg name=\"r12\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=204 */
	{"r13", "<reg name=\"r13\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=205 */
	{"r14", "<reg name=\"r14\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=206 */
	{"r15", "<reg name=\"r15\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=207 */
	{"r16", "<reg name=\"r16\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=208 */
	{"r17", "<reg name=\"r17\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=209 */
	{"r18", "<reg name=\"r18\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=210 */
	{"r19", "<reg name=\"r19\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=211 */
	{"r20", "<reg name=\"r20\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=212 */
	{"r21", "<reg name=\"r21\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=213 */
	{"r22", "<reg name=\"r22\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=214 */
	{"r23", "<reg name=\"r23\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=215 */
	{"r24", "<reg name=\"r24\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=216 */
	{"r25", "<reg name=\"r25\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=217 */
	{"r26", "<reg name=\"r26\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=218 */
	{"r27", "<reg name=\"r27\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=219 */
	{"r28", "<reg name=\"r28\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=220 */
	{"r29", "<reg name=\"r29\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=221 */
	{"r30", "<reg name=\"r30\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=222 */
	{"r31", "<reg name=\"r31\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=223 */
	{"r32", "<reg name=\"r32\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=224 */
	{"r33", "<reg name=\"r33\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=225 */
	{"r34", "<reg name=\"r34\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=226 */
	{"r35", "<reg name=\"r35\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=227 */
	{"r36", "<reg name=\"r36\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=228 */
	{"r37", "<reg name=\"r37\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=229 */
	{"r38", "<reg name=\"r38\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=230 */
	{"r39", "<reg name=\"r39\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=231 */
	{"r40", "<reg name=\"r40\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=232 */
	{"r41", "<reg name=\"r41\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=233 */
	{"r42", "<reg name=\"r42\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=234 */
	{"r43", "<reg name=\"r43\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=235 */
	{"r44", "<reg name=\"r44\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=236 */
	{"r45", "<reg name=\"r45\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=237 */
	{"r46", "<reg name=\"r46\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=238 */
	{"r47", "<reg name=\"r47\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=239 */
	{"r48", "<reg name=\"r48\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=240 */
	{"r49", "<reg name=\"r49\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=241 */
	{"r50", "<reg name=\"r50\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=242 */
	{"r51", "<reg name=\"r51\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=243 */
	{"r52", "<reg name=\"r52\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=244 */
	{"r53", "<reg name=\"r53\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=245 */
	{"r54", "<reg name=\"r54\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=246 */
	{"r55", "<reg name=\"r55\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=247 */
	{"r56", "<reg name=\"r56\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=248 */
	{"r57", "<reg name=\"r57\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=249 */
	{"r58", "<reg name=\"r58\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=250 */
	{"r59", "<reg name=\"r59\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=251 */
	{"r60", "<reg name=\"r60\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=252 */
	{"r61", "<reg name=\"r61\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=253 */
	{"r62", "<reg name=\"r62\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=254 */
	{"r63", "<reg name=\"r63\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=255 */
	{"a0_x", "<reg name=\"a0_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=256 */
	{"a0_y", "<reg name=\"a0_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=257 */
	{"a0_z", "<reg name=\"a0_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=258 */
	{"a0_t", "<reg name=\"a0_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=259 */
	{"a1_x", "<reg name=\"a1_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=260 */
	{"a1_y", "<reg name=\"a1_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=261 */
	{"a1_z", "<reg name=\"a1_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=262 */
	{"a1_t", "<reg name=\"a1_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=263 */
	{"a2_x", "<reg name=\"a2_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=264 */
	{"a2_y", "<reg name=\"a2_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=265 */
	{"a2_z", "<reg name=\"a2_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=266 */
	{"a2_t", "<reg name=\"a2_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=267 */
	{"a3_x", "<reg name=\"a3_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=268 */
	{"a3_y", "<reg name=\"a3_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=269 */
	{"a3_z", "<reg name=\"a3_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=270 */
	{"a3_t", "<reg name=\"a3_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=271 */
	{"a4_x", "<reg name=\"a4_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=272 */
	{"a4_y", "<reg name=\"a4_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=273 */
	{"a4_z", "<reg name=\"a4_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=274 */
	{"a4_t", "<reg name=\"a4_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=275 */
	{"a5_x", "<reg name=\"a5_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=276 */
	{"a5_y", "<reg name=\"a5_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=277 */
	{"a5_z", "<reg name=\"a5_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=278 */
	{"a5_t", "<reg name=\"a5_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=279 */
	{"a6_x", "<reg name=\"a6_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=280 */
	{"a6_y", "<reg name=\"a6_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=281 */
	{"a6_z", "<reg name=\"a6_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=282 */
	{"a6_t", "<reg name=\"a6_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=283 */
	{"a7_x", "<reg name=\"a7_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=284 */
	{"a7_y", "<reg name=\"a7_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=285 */
	{"a7_z", "<reg name=\"a7_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=286 */
	{"a7_t", "<reg name=\"a7_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=287 */
	{"a8_x", "<reg name=\"a8_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=288 */
	{"a8_y", "<reg name=\"a8_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=289 */
	{"a8_z", "<reg name=\"a8_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=290 */
	{"a8_t", "<reg name=\"a8_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=291 */
	{"a9_x", "<reg name=\"a9_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=292 */
	{"a9_y", "<reg name=\"a9_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=293 */
	{"a9_z", "<reg name=\"a9_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=294 */
	{"a9_t", "<reg name=\"a9_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=295 */
	{"a10_x", "<reg name=\"a10_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=296 */
	{"a10_y", "<reg name=\"a10_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=297 */
	{"a10_z", "<reg name=\"a10_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=298 */
	{"a10_t", "<reg name=\"a10_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=299 */
	{"a11_x", "<reg name=\"a11_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=300 */
	{"a11_y", "<reg name=\"a11_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=301 */
	{"a11_z", "<reg name=\"a11_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=302 */
	{"a11_t", "<reg name=\"a11_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=303 */
	{"a12_x", "<reg name=\"a12_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=304 */
	{"a12_y", "<reg name=\"a12_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=305 */
	{"a12_z", "<reg name=\"a12_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=306 */
	{"a12_t", "<reg name=\"a12_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=307 */
	{"a13_x", "<reg name=\"a13_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=308 */
	{"a13_y", "<reg name=\"a13_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=309 */
	{"a13_z", "<reg name=\"a13_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=310 */
	{"a13_t", "<reg name=\"a13_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=311 */
	{"a14_x", "<reg name=\"a14_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=312 */
	{"a14_y", "<reg name=\"a14_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=313 */
	{"a14_z", "<reg name=\"a14_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=314 */
	{"a14_t", "<reg name=\"a14_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=315 */
	{"a15_x", "<reg name=\"a15_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=316 */
	{"a15_y", "<reg name=\"a15_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=317 */
	{"a15_z", "<reg name=\"a15_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=318 */
	{"a15_t", "<reg name=\"a15_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=319 */
	{"a16_x", "<reg name=\"a16_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=320 */
	{"a16_y", "<reg name=\"a16_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=321 */
	{"a16_z", "<reg name=\"a16_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=322 */
	{"a16_t", "<reg name=\"a16_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=323 */
	{"a17_x", "<reg name=\"a17_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=324 */
	{"a17_y", "<reg name=\"a17_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=325 */
	{"a17_z", "<reg name=\"a17_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=326 */
	{"a17_t", "<reg name=\"a17_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=327 */
	{"a18_x", "<reg name=\"a18_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=328 */
	{"a18_y", "<reg name=\"a18_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=329 */
	{"a18_z", "<reg name=\"a18_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=330 */
	{"a18_t", "<reg name=\"a18_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=331 */
	{"a19_x", "<reg name=\"a19_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=332 */
	{"a19_y", "<reg name=\"a19_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=333 */
	{"a19_z", "<reg name=\"a19_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=334 */
	{"a19_t", "<reg name=\"a19_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=335 */
	{"a20_x", "<reg name=\"a20_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=336 */
	{"a20_y", "<reg name=\"a20_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=337 */
	{"a20_z", "<reg name=\"a20_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=338 */
	{"a20_t", "<reg name=\"a20_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=339 */
	{"a21_x", "<reg name=\"a21_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=340 */
	{"a21_y", "<reg name=\"a21_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=341 */
	{"a21_z", "<reg name=\"a21_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=342 */
	{"a21_t", "<reg name=\"a21_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=343 */
	{"a22_x", "<reg name=\"a22_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=344 */
	{"a22_y", "<reg name=\"a22_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=345 */
	{"a22_z", "<reg name=\"a22_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=346 */
	{"a22_t", "<reg name=\"a22_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=347 */
	{"a23_x", "<reg name=\"a23_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=348 */
	{"a23_y", "<reg name=\"a23_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=349 */
	{"a23_z", "<reg name=\"a23_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=350 */
	{"a23_t", "<reg name=\"a23_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=351 */
	{"a24_x", "<reg name=\"a24_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=352 */
	{"a24_y", "<reg name=\"a24_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=353 */
	{"a24_z", "<reg name=\"a24_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=354 */
	{"a24_t", "<reg name=\"a24_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=355 */
	{"a25_x", "<reg name=\"a25_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=356 */
	{"a25_y", "<reg name=\"a25_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=357 */
	{"a25_z", "<reg name=\"a25_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=358 */
	{"a25_t", "<reg name=\"a25_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=359 */
	{"a26_x", "<reg name=\"a26_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=360 */
	{"a26_y", "<reg name=\"a26_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=361 */
	{"a26_z", "<reg name=\"a26_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=362 */
	{"a26_t", "<reg name=\"a26_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=363 */
	{"a27_x", "<reg name=\"a27_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=364 */
	{"a27_y", "<reg name=\"a27_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=365 */
	{"a27_z", "<reg name=\"a27_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=366 */
	{"a27_t", "<reg name=\"a27_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=367 */
	{"a28_x", "<reg name=\"a28_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=368 */
	{"a28_y", "<reg name=\"a28_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=369 */
	{"a28_z", "<reg name=\"a28_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=370 */
	{"a28_t", "<reg name=\"a28_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=371 */
	{"a29_x", "<reg name=\"a29_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=372 */
	{"a29_y", "<reg name=\"a29_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=373 */
	{"a29_z", "<reg name=\"a29_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=374 */
	{"a29_t", "<reg name=\"a29_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=375 */
	{"a30_x", "<reg name=\"a30_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=376 */
	{"a30_y", "<reg name=\"a30_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=377 */
	{"a30_z", "<reg name=\"a30_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=378 */
	{"a30_t", "<reg name=\"a30_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=379 */
	{"a31_x", "<reg name=\"a31_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=380 */
	{"a31_y", "<reg name=\"a31_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=381 */
	{"a31_z", "<reg name=\"a31_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=382 */
	{"a31_t", "<reg name=\"a31_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=383 */
	{"a32_x", "<reg name=\"a32_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=384 */
	{"a32_y", "<reg name=\"a32_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=385 */
	{"a32_z", "<reg name=\"a32_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=386 */
	{"a32_t", "<reg name=\"a32_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=387 */
	{"a33_x", "<reg name=\"a33_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=388 */
	{"a33_y", "<reg name=\"a33_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=389 */
	{"a33_z", "<reg name=\"a33_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=390 */
	{"a33_t", "<reg name=\"a33_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=391 */
	{"a34_x", "<reg name=\"a34_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=392 */
	{"a34_y", "<reg name=\"a34_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=393 */
	{"a34_z", "<reg name=\"a34_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=394 */
	{"a34_t", "<reg name=\"a34_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=395 */
	{"a35_x", "<reg name=\"a35_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=396 */
	{"a35_y", "<reg name=\"a35_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=397 */
	{"a35_z", "<reg name=\"a35_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=398 */
	{"a35_t", "<reg name=\"a35_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=399 */
	{"a36_x", "<reg name=\"a36_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=400 */
	{"a36_y", "<reg name=\"a36_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=401 */
	{"a36_z", "<reg name=\"a36_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=402 */
	{"a36_t", "<reg name=\"a36_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=403 */
	{"a37_x", "<reg name=\"a37_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=404 */
	{"a37_y", "<reg name=\"a37_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=405 */
	{"a37_z", "<reg name=\"a37_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=406 */
	{"a37_t", "<reg name=\"a37_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=407 */
	{"a38_x", "<reg name=\"a38_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=408 */
	{"a38_y", "<reg name=\"a38_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=409 */
	{"a38_z", "<reg name=\"a38_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=410 */
	{"a38_t", "<reg name=\"a38_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=411 */
	{"a39_x", "<reg name=\"a39_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=412 */
	{"a39_y", "<reg name=\"a39_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=413 */
	{"a39_z", "<reg name=\"a39_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=414 */
	{"a39_t", "<reg name=\"a39_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=415 */
	{"a40_x", "<reg name=\"a40_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=416 */
	{"a40_y", "<reg name=\"a40_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=417 */
	{"a40_z", "<reg name=\"a40_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=418 */
	{"a40_t", "<reg name=\"a40_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=419 */
	{"a41_x", "<reg name=\"a41_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=420 */
	{"a41_y", "<reg name=\"a41_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=421 */
	{"a41_z", "<reg name=\"a41_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=422 */
	{"a41_t", "<reg name=\"a41_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=423 */
	{"a42_x", "<reg name=\"a42_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=424 */
	{"a42_y", "<reg name=\"a42_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=425 */
	{"a42_z", "<reg name=\"a42_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=426 */
	{"a42_t", "<reg name=\"a42_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=427 */
	{"a43_x", "<reg name=\"a43_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=428 */
	{"a43_y", "<reg name=\"a43_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=429 */
	{"a43_z", "<reg name=\"a43_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=430 */
	{"a43_t", "<reg name=\"a43_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=431 */
	{"a44_x", "<reg name=\"a44_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=432 */
	{"a44_y", "<reg name=\"a44_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=433 */
	{"a44_z", "<reg name=\"a44_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=434 */
	{"a44_t", "<reg name=\"a44_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=435 */
	{"a45_x", "<reg name=\"a45_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=436 */
	{"a45_y", "<reg name=\"a45_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=437 */
	{"a45_z", "<reg name=\"a45_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=438 */
	{"a45_t", "<reg name=\"a45_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=439 */
	{"a46_x", "<reg name=\"a46_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=440 */
	{"a46_y", "<reg name=\"a46_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=441 */
	{"a46_z", "<reg name=\"a46_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=442 */
	{"a46_t", "<reg name=\"a46_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=443 */
	{"a47_x", "<reg name=\"a47_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=444 */
	{"a47_y", "<reg name=\"a47_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=445 */
	{"a47_z", "<reg name=\"a47_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=446 */
	{"a47_t", "<reg name=\"a47_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=447 */
	{"a48_x", "<reg name=\"a48_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=448 */
	{"a48_y", "<reg name=\"a48_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=449 */
	{"a48_z", "<reg name=\"a48_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=450 */
	{"a48_t", "<reg name=\"a48_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=451 */
	{"a49_x", "<reg name=\"a49_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=452 */
	{"a49_y", "<reg name=\"a49_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=453 */
	{"a49_z", "<reg name=\"a49_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=454 */
	{"a49_t", "<reg name=\"a49_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=455 */
	{"a50_x", "<reg name=\"a50_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=456 */
	{"a50_y", "<reg name=\"a50_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=457 */
	{"a50_z", "<reg name=\"a50_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=458 */
	{"a50_t", "<reg name=\"a50_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=459 */
	{"a51_x", "<reg name=\"a51_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=460 */
	{"a51_y", "<reg name=\"a51_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=461 */
	{"a51_z", "<reg name=\"a51_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=462 */
	{"a51_t", "<reg name=\"a51_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=463 */
	{"a52_x", "<reg name=\"a52_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=464 */
	{"a52_y", "<reg name=\"a52_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=465 */
	{"a52_z", "<reg name=\"a52_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=466 */
	{"a52_t", "<reg name=\"a52_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=467 */
	{"a53_x", "<reg name=\"a53_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=468 */
	{"a53_y", "<reg name=\"a53_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=469 */
	{"a53_z", "<reg name=\"a53_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=470 */
	{"a53_t", "<reg name=\"a53_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=471 */
	{"a54_x", "<reg name=\"a54_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=472 */
	{"a54_y", "<reg name=\"a54_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=473 */
	{"a54_z", "<reg name=\"a54_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=474 */
	{"a54_t", "<reg name=\"a54_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=475 */
	{"a55_x", "<reg name=\"a55_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=476 */
	{"a55_y", "<reg name=\"a55_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=477 */
	{"a55_z", "<reg name=\"a55_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=478 */
	{"a55_t", "<reg name=\"a55_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=479 */
	{"a56_x", "<reg name=\"a56_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=480 */
	{"a56_y", "<reg name=\"a56_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=481 */
	{"a56_z", "<reg name=\"a56_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=482 */
	{"a56_t", "<reg name=\"a56_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=483 */
	{"a57_x", "<reg name=\"a57_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=484 */
	{"a57_y", "<reg name=\"a57_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=485 */
	{"a57_z", "<reg name=\"a57_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=486 */
	{"a57_t", "<reg name=\"a57_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=487 */
	{"a58_x", "<reg name=\"a58_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=488 */
	{"a58_y", "<reg name=\"a58_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=489 */
	{"a58_z", "<reg name=\"a58_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=490 */
	{"a58_t", "<reg name=\"a58_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=491 */
	{"a59_x", "<reg name=\"a59_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=492 */
	{"a59_y", "<reg name=\"a59_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=493 */
	{"a59_z", "<reg name=\"a59_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=494 */
	{"a59_t", "<reg name=\"a59_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=495 */
	{"a60_x", "<reg name=\"a60_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=496 */
	{"a60_y", "<reg name=\"a60_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=497 */
	{"a60_z", "<reg name=\"a60_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=498 */
	{"a60_t", "<reg name=\"a60_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=499 */
	{"a61_x", "<reg name=\"a61_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=500 */
	{"a61_y", "<reg name=\"a61_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=501 */
	{"a61_z", "<reg name=\"a61_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=502 */
	{"a61_t", "<reg name=\"a61_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=503 */
	{"a62_x", "<reg name=\"a62_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=504 */
	{"a62_y", "<reg name=\"a62_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=505 */
	{"a62_z", "<reg name=\"a62_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=506 */
	{"a62_t", "<reg name=\"a62_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=507 */
	{"a63_x", "<reg name=\"a63_x\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=508 */
	{"a63_y", "<reg name=\"a63_y\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=509 */
	{"a63_z", "<reg name=\"a63_z\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=510 */
	{"a63_t", "<reg name=\"a63_t\" regnum=\"%d\" bitsize=\"64\" type=\"int\" />"}, /* regno=511 */
	{0},
};

int lvx_v2_mds_registers_size[] = {
	64 /*pc*/,32 /*ps*/,64 /*pcr*/,64 /*ra*/,64 /*cs*/,32 /*csit*/,64 /*aespc*/,64 /*ls*/,64 /*le*/,64 /*lc*/,
	64 /*ipe*/,64 /*men*/,64 /*pmc*/,64 /*pm0*/,64 /*pm1*/,64 /*pm2*/,64 /*pm3*/,64 /*pmsa*/,32 /*tcr*/,64 /*t0v*/,
	64 /*t1v*/,64 /*t0r*/,64 /*t1r*/,64 /*wdv*/,64 /*wdr*/,64 /*ile*/,64 /*ill*/,64 /*ilr*/,32 /*mmc*/,64 /*tel*/,
	64 /*teh*/,32 /*ixc*/,32 /*syo*/,32 /*hto*/,64 /*ito*/,32 /*do*/,64 /*mo*/,64 /*pso*/,64 /*tpcm0*/,64 /*tpcm1*/,
	64 /*res40*/,64 /*dba0*/,64 /*dba1*/,64 /*dwa0*/,64 /*dwa1*/,32 /*mes*/,32 /*ws*/,64 /*dc0*/,64 /*dc1*/,64 /*dc2*/,
	64 /*dc3*/,64 /*dba2*/,64 /*dba3*/,64 /*dwa2*/,64 /*dwa3*/,64 /*tpcm2*/,64 /*tpcmc*/,64 /*pm4*/,64 /*pm5*/,64 /*pm6*/,
	64 /*pm7*/,64 /*pmc2*/,64 /*srhpc*/,64 /*frcc*/,64 /*spc_pl0*/,64 /*spc_pl1*/,64 /*spc_pl2*/,64 /*spc_pl3*/,32 /*sps_pl0*/,32 /*sps_pl1*/,
	32 /*sps_pl2*/,32 /*sps_pl3*/,64 /*ea_pl0*/,64 /*ea_pl1*/,64 /*ea_pl2*/,64 /*ea_pl3*/,64 /*ev_pl0*/,64 /*ev_pl1*/,64 /*ev_pl2*/,64 /*ev_pl3*/,
	64 /*sr_pl0*/,64 /*sr_pl1*/,64 /*sr_pl2*/,64 /*sr_pl3*/,64 /*es_pl0*/,64 /*es_pl1*/,64 /*es_pl2*/,64 /*es_pl3*/,32 /*sid_pl0*/,32 /*sid_pl1*/,
	32 /*sid_pl2*/,32 /*sid_pl3*/,64 /*sr1_pl0*/,64 /*sr1_pl1*/,64 /*sr1_pl2*/,64 /*sr1_pl3*/,32 /*syow*/,32 /*htow*/,64 /*itow*/,32 /*dow*/,
	64 /*mow*/,64 /*psow*/,64 /*res102*/,64 /*res103*/,32 /*tpcc_pl0*/,32 /*tpcc_pl1*/,32 /*tpcc_pl2*/,32 /*tpcc_pl3*/,64 /*res108*/,64 /*res109*/,
	64 /*res110*/,64 /*res111*/,64 /*res112*/,64 /*res113*/,64 /*res114*/,64 /*res115*/,64 /*res116*/,64 /*res117*/,64 /*res118*/,64 /*res119*/,
	64 /*res120*/,64 /*res121*/,64 /*res122*/,64 /*res123*/,64 /*res124*/,64 /*res125*/,64 /*res126*/,64 /*res127*/,64 /*spc*/,64 /*res129*/,
	64 /*res130*/,64 /*res131*/,32 /*sps*/,64 /*res133*/,64 /*res134*/,64 /*res135*/,64 /*ea*/,64 /*res137*/,64 /*res138*/,64 /*res139*/,
	64 /*ev*/,64 /*res141*/,64 /*res142*/,64 /*res143*/,64 /*sr*/,64 /*res145*/,64 /*res146*/,64 /*res147*/,64 /*es*/,64 /*res149*/,
	64 /*res150*/,64 /*res151*/,32 /*sid*/,64 /*res153*/,64 /*res154*/,64 /*res155*/,64 /*sr1*/,64 /*res157*/,64 /*res158*/,64 /*res159*/,
	64 /*res160*/,64 /*res161*/,64 /*res162*/,64 /*res163*/,64 /*res164*/,64 /*res165*/,64 /*res166*/,64 /*res167*/,32 /*tpcc*/,64 /*res169*/,
	64 /*res170*/,64 /*res171*/,64 /*res172*/,64 /*res173*/,64 /*res174*/,64 /*res175*/,64 /*res176*/,64 /*res177*/,64 /*res178*/,64 /*res179*/,
	64 /*res180*/,64 /*res181*/,64 /*res182*/,64 /*res183*/,64 /*res184*/,64 /*res185*/,64 /*res186*/,64 /*res187*/,64 /*res188*/,64 /*res189*/,
	64 /*res190*/,64 /*res191*/,64 /*r0*/,64 /*r1*/,64 /*r2*/,64 /*r3*/,64 /*r4*/,64 /*r5*/,64 /*r6*/,64 /*r7*/,
	64 /*r8*/,64 /*r9*/,64 /*r10*/,64 /*r11*/,64 /*r12*/,64 /*r13*/,64 /*r14*/,64 /*r15*/,64 /*r16*/,64 /*r17*/,
	64 /*r18*/,64 /*r19*/,64 /*r20*/,64 /*r21*/,64 /*r22*/,64 /*r23*/,64 /*r24*/,64 /*r25*/,64 /*r26*/,64 /*r27*/,
	64 /*r28*/,64 /*r29*/,64 /*r30*/,64 /*r31*/,64 /*r32*/,64 /*r33*/,64 /*r34*/,64 /*r35*/,64 /*r36*/,64 /*r37*/,
	64 /*r38*/,64 /*r39*/,64 /*r40*/,64 /*r41*/,64 /*r42*/,64 /*r43*/,64 /*r44*/,64 /*r45*/,64 /*r46*/,64 /*r47*/,
	64 /*r48*/,64 /*r49*/,64 /*r50*/,64 /*r51*/,64 /*r52*/,64 /*r53*/,64 /*r54*/,64 /*r55*/,64 /*r56*/,64 /*r57*/,
	64 /*r58*/,64 /*r59*/,64 /*r60*/,64 /*r61*/,64 /*r62*/,64 /*r63*/,64 /*a0_x*/,64 /*a0_y*/,64 /*a0_z*/,64 /*a0_t*/,
	64 /*a1_x*/,64 /*a1_y*/,64 /*a1_z*/,64 /*a1_t*/,64 /*a2_x*/,64 /*a2_y*/,64 /*a2_z*/,64 /*a2_t*/,64 /*a3_x*/,64 /*a3_y*/,
	64 /*a3_z*/,64 /*a3_t*/,64 /*a4_x*/,64 /*a4_y*/,64 /*a4_z*/,64 /*a4_t*/,64 /*a5_x*/,64 /*a5_y*/,64 /*a5_z*/,64 /*a5_t*/,
	64 /*a6_x*/,64 /*a6_y*/,64 /*a6_z*/,64 /*a6_t*/,64 /*a7_x*/,64 /*a7_y*/,64 /*a7_z*/,64 /*a7_t*/,64 /*a8_x*/,64 /*a8_y*/,
	64 /*a8_z*/,64 /*a8_t*/,64 /*a9_x*/,64 /*a9_y*/,64 /*a9_z*/,64 /*a9_t*/,64 /*a10_x*/,64 /*a10_y*/,64 /*a10_z*/,64 /*a10_t*/,
	64 /*a11_x*/,64 /*a11_y*/,64 /*a11_z*/,64 /*a11_t*/,64 /*a12_x*/,64 /*a12_y*/,64 /*a12_z*/,64 /*a12_t*/,64 /*a13_x*/,64 /*a13_y*/,
	64 /*a13_z*/,64 /*a13_t*/,64 /*a14_x*/,64 /*a14_y*/,64 /*a14_z*/,64 /*a14_t*/,64 /*a15_x*/,64 /*a15_y*/,64 /*a15_z*/,64 /*a15_t*/,
	64 /*a16_x*/,64 /*a16_y*/,64 /*a16_z*/,64 /*a16_t*/,64 /*a17_x*/,64 /*a17_y*/,64 /*a17_z*/,64 /*a17_t*/,64 /*a18_x*/,64 /*a18_y*/,
	64 /*a18_z*/,64 /*a18_t*/,64 /*a19_x*/,64 /*a19_y*/,64 /*a19_z*/,64 /*a19_t*/,64 /*a20_x*/,64 /*a20_y*/,64 /*a20_z*/,64 /*a20_t*/,
	64 /*a21_x*/,64 /*a21_y*/,64 /*a21_z*/,64 /*a21_t*/,64 /*a22_x*/,64 /*a22_y*/,64 /*a22_z*/,64 /*a22_t*/,64 /*a23_x*/,64 /*a23_y*/,
	64 /*a23_z*/,64 /*a23_t*/,64 /*a24_x*/,64 /*a24_y*/,64 /*a24_z*/,64 /*a24_t*/,64 /*a25_x*/,64 /*a25_y*/,64 /*a25_z*/,64 /*a25_t*/,
	64 /*a26_x*/,64 /*a26_y*/,64 /*a26_z*/,64 /*a26_t*/,64 /*a27_x*/,64 /*a27_y*/,64 /*a27_z*/,64 /*a27_t*/,64 /*a28_x*/,64 /*a28_y*/,
	64 /*a28_z*/,64 /*a28_t*/,64 /*a29_x*/,64 /*a29_y*/,64 /*a29_z*/,64 /*a29_t*/,64 /*a30_x*/,64 /*a30_y*/,64 /*a30_z*/,64 /*a30_t*/,
	64 /*a31_x*/,64 /*a31_y*/,64 /*a31_z*/,64 /*a31_t*/,64 /*a32_x*/,64 /*a32_y*/,64 /*a32_z*/,64 /*a32_t*/,64 /*a33_x*/,64 /*a33_y*/,
	64 /*a33_z*/,64 /*a33_t*/,64 /*a34_x*/,64 /*a34_y*/,64 /*a34_z*/,64 /*a34_t*/,64 /*a35_x*/,64 /*a35_y*/,64 /*a35_z*/,64 /*a35_t*/,
	64 /*a36_x*/,64 /*a36_y*/,64 /*a36_z*/,64 /*a36_t*/,64 /*a37_x*/,64 /*a37_y*/,64 /*a37_z*/,64 /*a37_t*/,64 /*a38_x*/,64 /*a38_y*/,
	64 /*a38_z*/,64 /*a38_t*/,64 /*a39_x*/,64 /*a39_y*/,64 /*a39_z*/,64 /*a39_t*/,64 /*a40_x*/,64 /*a40_y*/,64 /*a40_z*/,64 /*a40_t*/,
	64 /*a41_x*/,64 /*a41_y*/,64 /*a41_z*/,64 /*a41_t*/,64 /*a42_x*/,64 /*a42_y*/,64 /*a42_z*/,64 /*a42_t*/,64 /*a43_x*/,64 /*a43_y*/,
	64 /*a43_z*/,64 /*a43_t*/,64 /*a44_x*/,64 /*a44_y*/,64 /*a44_z*/,64 /*a44_t*/,64 /*a45_x*/,64 /*a45_y*/,64 /*a45_z*/,64 /*a45_t*/,
	64 /*a46_x*/,64 /*a46_y*/,64 /*a46_z*/,64 /*a46_t*/,64 /*a47_x*/,64 /*a47_y*/,64 /*a47_z*/,64 /*a47_t*/,64 /*a48_x*/,64 /*a48_y*/,
	64 /*a48_z*/,64 /*a48_t*/,64 /*a49_x*/,64 /*a49_y*/,64 /*a49_z*/,64 /*a49_t*/,64 /*a50_x*/,64 /*a50_y*/,64 /*a50_z*/,64 /*a50_t*/,
	64 /*a51_x*/,64 /*a51_y*/,64 /*a51_z*/,64 /*a51_t*/,64 /*a52_x*/,64 /*a52_y*/,64 /*a52_z*/,64 /*a52_t*/,64 /*a53_x*/,64 /*a53_y*/,
	64 /*a53_z*/,64 /*a53_t*/,64 /*a54_x*/,64 /*a54_y*/,64 /*a54_z*/,64 /*a54_t*/,64 /*a55_x*/,64 /*a55_y*/,64 /*a55_z*/,64 /*a55_t*/,
	64 /*a56_x*/,64 /*a56_y*/,64 /*a56_z*/,64 /*a56_t*/,64 /*a57_x*/,64 /*a57_y*/,64 /*a57_z*/,64 /*a57_t*/,64 /*a58_x*/,64 /*a58_y*/,
	64 /*a58_z*/,64 /*a58_t*/,64 /*a59_x*/,64 /*a59_y*/,64 /*a59_z*/,64 /*a59_t*/,64 /*a60_x*/,64 /*a60_y*/,64 /*a60_z*/,64 /*a60_t*/,
	64 /*a61_x*/,64 /*a61_y*/,64 /*a61_z*/,64 /*a61_t*/,64 /*a62_x*/,64 /*a62_y*/,64 /*a62_z*/,64 /*a62_t*/,64 /*a63_x*/,64 /*a63_y*/,
	64 /*a63_z*/,64 /*a63_t*/,
	0,
};
static inline struct reg_desc*
get_register_descriptions (const char *arch)
{
	if (strcmp (arch, "lvx-1") == 0)
		return lvx_v1_mds_registers_description;
	if (strcmp (arch, "lvx-2") == 0)
		return lvx_v2_mds_registers_description;
	return NULL;
}

static inline int*
get_register_sizes (const char *arch)
{
	if (strcmp (arch, "lvx-1") == 0)
		return lvx_v1_mds_registers_size;
	if (strcmp (arch, "lvx-2") == 0)
		return lvx_v2_mds_registers_size;
	return NULL;
}


/* Register constants referenced by the generated bodies. Values are irrelevant to
   a differential test -- both generations see the same ones -- but they must be
   distinct so that a bug which swaps two registers still shows up. */
enum {
  Register_lvx_v1_P0 = 7,
  Register_lvx_v1_PC = 14,
  Register_lvx_v1_Q0 = 21,
  Register_lvx_v1_R0 = 28,
};

/* LAO accessors the generated bodies use.  A differential test only needs them to
   be deterministic and identical on both sides, so identity is fine. */
#define ModifierMember_value(x) ((uint64_t)(x))

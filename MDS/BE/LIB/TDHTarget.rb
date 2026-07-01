#!/usr/bin/env ruby

module TDHTarget

  # Generate core specific macros
  def macros()

    puts <<EOT

/* Defines constant to set value of register's bit field
 * It works only for 32 bits LSB of SFR registers (WFXL).
 * Example: Set PMJ field of MMC register to 6:
 *          K1_SFR_WFXL_VALUE(MMC_PMJ, 6);
 */
#define K1_SFR_WFXL_VALUE(reg_field, value) (((((uint64_t)value << K1_SFR_##reg_field##_SHIFT) & K1_SFR_##reg_field##_MASK) << 32) | K1_SFR_##reg_field##_MASK)

/* Defines new source value with inserted register field value
 * Same behavior as insf instruction.
 * Example: Set Page Number in TEH register:
 *          entry.teh = K1_SFR_SET_FIELD(entry.teh, TEH_PN, va >> 12);
 */
#define K1_SFR_SET_FIELD(source, reg_field, value) (((uint64_t)(value) << K1_SFR_##reg_field##_SHIFT) & K1_SFR_##reg_field##_MASK) | ((source) & ~K1_SFR_##reg_field##_MASK)

/* Get register field value from source
 * Same behavior as extfz instruction.
 * Example: Get Page Number from TEH register:
 *          pn = K1_SFR_GET_FIELD(entry.teh, TEH_PN);
 */
#define K1_SFR_GET_FIELD(source, reg_field) (((uint64_t)(source) & K1_SFR_##reg_field##_MASK) >> K1_SFR_##reg_field##_SHIFT)

EOT

  end

end

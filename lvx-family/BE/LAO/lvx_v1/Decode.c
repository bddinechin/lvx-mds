/*
 * lvx/Decode.c
 *  (c) Copyright 2010-2018 Kalray SA.
 * Automatically generated from the Machine Description System (MDS).
 */

#include "MDT/MDT_.h"

#ifdef $XCC__h
#ifndef NDECODE
extern Opcode
Decode_Decoding_lvx_v1_double(const void *buffer);
#endif//NDECODE
#endif//$XCC__h

#ifndef NDECODE
Opcode
Decode_Decoding_lvx_v1_double(const void *buffer)
{
  const uint32_t *codeWords = (const uint32_t *)buffer;
  uint32_t codeWord_0 = codeWords[0];
  uint32_t codeWord_1 = codeWords[1];
  switch ((codeWord_0 >> 28) & 0x0000000f) {
  case 0x00000008:
    switch ((codeWord_1 >> 27) & 0x0000000f) {
    case 0x00000000:
      switch ((codeWord_0 >> 27) & 0x00000001) {
      case 0x00000000:
        return Opcode_lvx_v1_CCBX_ccbcomp_registerZ_registerY_upper27_lower11_double;
      case 0x00000001:
        return Opcode_lvx_v1_CBX_bcucond_registerZ_upper27_lower17_double;
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000009:
    switch ((codeWord_1 >> 27) & 0x0000000f) {
    case 0x00000000:
      switch ((codeWord_0 >> 27) & 0x00000001) {
      case 0x00000000:
        return Opcode_lvx_v1_GOTOX_upper27_lower27_double;
      case 0x00000001:
        return Opcode_lvx_v1_CALLX_upper27_lower27_double;
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000000a:
    switch ((codeWord_0 >> 16) & 0x00000003) {
    case 0x00000000:
      switch ((codeWord_0 >> 26) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LBZ_variant_registerW_upper27_lower10_registerZ_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LBS_variant_registerW_upper27_lower10_registerZ_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LHZ_variant_registerW_upper27_lower10_registerZ_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LHS_variant_registerW_upper27_lower10_registerZ_double;
        default:
          break;
        }
        return Opcode__UNDEF;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 26) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_XLO_variant_registerG_upper27_lower10_registerZ_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_XLO_variant_qindex_registerGq_upper27_lower10_registerZ_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000003:
      switch ((codeWord_0 >> 13) & 0x00000007) {
      case 0x00000000:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLB_variant_registerGg_registerY_offset27_registerZ_double;
            case 0x00000001:
              switch ((codeWord_0 >> 19) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLB_variant_registerGh_registerY_offset27_registerZ_double;
              case 0x00000001:
                switch ((codeWord_0 >> 20) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLB_variant_registerGi_registerY_offset27_registerZ_double;
                case 0x00000001:
                  switch ((codeWord_0 >> 21) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLB_variant_registerGj_registerY_offset27_registerZ_double;
                  case 0x00000001:
                    switch ((codeWord_0 >> 22) & 0x00000001) {
                    case 0x00000000:
                      return Opcode_lvx_v1_XPLB_variant_registerGk_registerY_offset27_registerZ_double;
                    case 0x00000001:
                      return Opcode_lvx_v1_XPLB_variant_registerGl_registerY_offset27_registerZ_double;
                      break;
                    }
                    return Opcode__UNDEF;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLH_variant_registerGg_registerY_offset27_registerZ_double;
            case 0x00000001:
              switch ((codeWord_0 >> 19) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLH_variant_registerGh_registerY_offset27_registerZ_double;
              case 0x00000001:
                switch ((codeWord_0 >> 20) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLH_variant_registerGi_registerY_offset27_registerZ_double;
                case 0x00000001:
                  switch ((codeWord_0 >> 21) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLH_variant_registerGj_registerY_offset27_registerZ_double;
                  case 0x00000001:
                    switch ((codeWord_0 >> 22) & 0x00000001) {
                    case 0x00000000:
                      return Opcode_lvx_v1_XPLH_variant_registerGk_registerY_offset27_registerZ_double;
                    case 0x00000001:
                      return Opcode_lvx_v1_XPLH_variant_registerGl_registerY_offset27_registerZ_double;
                      break;
                    }
                    return Opcode__UNDEF;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLW_variant_registerGg_registerY_offset27_registerZ_double;
            case 0x00000001:
              switch ((codeWord_0 >> 19) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLW_variant_registerGh_registerY_offset27_registerZ_double;
              case 0x00000001:
                switch ((codeWord_0 >> 20) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLW_variant_registerGi_registerY_offset27_registerZ_double;
                case 0x00000001:
                  switch ((codeWord_0 >> 21) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLW_variant_registerGj_registerY_offset27_registerZ_double;
                  case 0x00000001:
                    switch ((codeWord_0 >> 22) & 0x00000001) {
                    case 0x00000000:
                      return Opcode_lvx_v1_XPLW_variant_registerGk_registerY_offset27_registerZ_double;
                    case 0x00000001:
                      return Opcode_lvx_v1_XPLW_variant_registerGl_registerY_offset27_registerZ_double;
                      break;
                    }
                    return Opcode__UNDEF;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLD_variant_registerGg_registerY_offset27_registerZ_double;
            case 0x00000001:
              switch ((codeWord_0 >> 19) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLD_variant_registerGh_registerY_offset27_registerZ_double;
              case 0x00000001:
                switch ((codeWord_0 >> 20) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLD_variant_registerGi_registerY_offset27_registerZ_double;
                case 0x00000001:
                  switch ((codeWord_0 >> 21) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLD_variant_registerGj_registerY_offset27_registerZ_double;
                  case 0x00000001:
                    switch ((codeWord_0 >> 22) & 0x00000001) {
                    case 0x00000000:
                      return Opcode_lvx_v1_XPLD_variant_registerGk_registerY_offset27_registerZ_double;
                    case 0x00000001:
                      return Opcode_lvx_v1_XPLD_variant_registerGl_registerY_offset27_registerZ_double;
                      break;
                    }
                    return Opcode__UNDEF;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000004:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLQ_variant_registerGg_registerY_offset27_registerZ_double;
            case 0x00000001:
              switch ((codeWord_0 >> 19) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLQ_variant_registerGh_registerY_offset27_registerZ_double;
              case 0x00000001:
                switch ((codeWord_0 >> 20) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLQ_variant_registerGi_registerY_offset27_registerZ_double;
                case 0x00000001:
                  switch ((codeWord_0 >> 21) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLQ_variant_registerGj_registerY_offset27_registerZ_double;
                  case 0x00000001:
                    switch ((codeWord_0 >> 22) & 0x00000001) {
                    case 0x00000000:
                      return Opcode_lvx_v1_XPLQ_variant_registerGk_registerY_offset27_registerZ_double;
                    case 0x00000001:
                      return Opcode_lvx_v1_XPLQ_variant_registerGl_registerY_offset27_registerZ_double;
                      break;
                    }
                    return Opcode__UNDEF;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000005:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLO_variant_registerGg_registerY_offset27_registerZ_double;
            case 0x00000001:
              switch ((codeWord_0 >> 19) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLO_variant_registerGh_registerY_offset27_registerZ_double;
              case 0x00000001:
                switch ((codeWord_0 >> 20) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLO_variant_registerGi_registerY_offset27_registerZ_double;
                case 0x00000001:
                  switch ((codeWord_0 >> 21) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLO_variant_registerGj_registerY_offset27_registerZ_double;
                  case 0x00000001:
                    switch ((codeWord_0 >> 22) & 0x00000001) {
                    case 0x00000000:
                      return Opcode_lvx_v1_XPLO_variant_registerGk_registerY_offset27_registerZ_double;
                    case 0x00000001:
                      return Opcode_lvx_v1_XPLO_variant_registerGl_registerY_offset27_registerZ_double;
                      break;
                    }
                    return Opcode__UNDEF;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000000b:
    switch ((codeWord_0 >> 16) & 0x00000003) {
    case 0x00000000:
      switch ((codeWord_0 >> 26) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LWZ_variant_registerW_upper27_lower10_registerZ_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LWS_variant_registerW_upper27_lower10_registerZ_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LD_variant_registerW_upper27_lower10_registerZ_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_LQ_variant_registerM_upper27_lower10_registerZ_double;
          case 0x00000001:
            switch ((codeWord_0 >> 19) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_LO_variant_registerN_upper27_lower10_registerZ_double;
            case 0x00000001:
              switch ((codeWord_0 >> 20) & 0x0000003f) {
              case 0x00000000:
                return Opcode_lvx_v1_DTOUCHL_upper27_lower10_registerZ_double;
              case 0x00000001:
                return Opcode_lvx_v1_DINVALL_upper27_lower10_registerZ_double;
              case 0x00000002:
                return Opcode_lvx_v1_DPURGEL_upper27_lower10_registerZ_double;
              case 0x00000003:
                return Opcode_lvx_v1_DFLUSHL_upper27_lower10_registerZ_double;
              case 0x00000005:
                return Opcode_lvx_v1_I1INVALS_upper27_lower10_registerZ_double;
              default:
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 24) & 0x0000000f) {
      case 0x00000000:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_SB_upper27_lower10_registerZ_registerT_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_SH_upper27_lower10_registerZ_registerT_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_SW_upper27_lower10_registerZ_registerT_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_SD_upper27_lower10_registerZ_registerT_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000004:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_SQ_upper27_lower10_registerZ_registerU_double;
          case 0x00000001:
            switch ((codeWord_0 >> 19) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SO_upper27_lower10_registerZ_registerV_double;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000005:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_XSO_upper27_lower10_registerZ_registerE_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000007:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_XSO_qindex_upper27_lower10_registerZ_registerEq_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000003:
      switch ((codeWord_0 >> 13) & 0x00000007) {
      case 0x00000000:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 7) & 0x0000001f) {
              case 0x00000000:
                return Opcode_lvx_v1_ALB_coherency_registerW_offset27_registerZ_double;
              case 0x00000001:
                return Opcode_lvx_v1_ALCLRB_coherency_registerW_offset27_registerZ_double;
              case 0x00000002:
                return Opcode_lvx_v1_ASWAPB_coherency_offset27_registerZ_registerT_double;
              case 0x00000004:
                return Opcode_lvx_v1_ALADDB_coherency_offset27_registerZ_registerT_double;
              case 0x00000005:
                return Opcode_lvx_v1_ALANDB_coherency_offset27_registerZ_registerT_double;
              case 0x00000006:
                return Opcode_lvx_v1_ALIORB_coherency_offset27_registerZ_registerT_double;
              case 0x00000007:
                return Opcode_lvx_v1_ALEORB_coherency_offset27_registerZ_registerT_double;
              case 0x00000008:
                return Opcode_lvx_v1_ALMINB_coherency_offset27_registerZ_registerT_double;
              case 0x00000009:
                return Opcode_lvx_v1_ALMAXB_coherency_offset27_registerZ_registerT_double;
              case 0x0000000a:
                return Opcode_lvx_v1_ALMINUB_coherency_offset27_registerZ_registerT_double;
              case 0x0000000b:
                return Opcode_lvx_v1_ALMAXUB_coherency_offset27_registerZ_registerT_double;
              case 0x0000000e:
                return Opcode_lvx_v1_ALDUSB_coherency_offset27_registerZ_registerT_double;
              case 0x00000010:
                return Opcode_lvx_v1_ASB_coherency_offset27_registerZ_registerT_double;
              case 0x00000014:
                return Opcode_lvx_v1_ASADDB_coherency_offset27_registerZ_registerT_double;
              case 0x00000015:
                return Opcode_lvx_v1_ASANDB_coherency_offset27_registerZ_registerT_double;
              case 0x00000016:
                return Opcode_lvx_v1_ASIORB_coherency_offset27_registerZ_registerT_double;
              case 0x00000017:
                return Opcode_lvx_v1_ASEORB_coherency_offset27_registerZ_registerT_double;
              case 0x00000018:
                return Opcode_lvx_v1_ASMINB_coherency_offset27_registerZ_registerT_double;
              case 0x00000019:
                return Opcode_lvx_v1_ASMAXB_coherency_offset27_registerZ_registerT_double;
              case 0x0000001a:
                return Opcode_lvx_v1_ASMINUB_coherency_offset27_registerZ_registerT_double;
              case 0x0000001b:
                return Opcode_lvx_v1_ASMAXUB_coherency_offset27_registerZ_registerT_double;
              case 0x0000001e:
                return Opcode_lvx_v1_ASDUSB_coherency_offset27_registerZ_registerT_double;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              return Opcode_lvx_v1_ACSWAPB_boolcas_coherency_registerW_offset27_registerZ_registerO_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 7) & 0x0000001f) {
              case 0x00000000:
                return Opcode_lvx_v1_ALH_coherency_registerW_offset27_registerZ_double;
              case 0x00000001:
                return Opcode_lvx_v1_ALCLRH_coherency_registerW_offset27_registerZ_double;
              case 0x00000002:
                return Opcode_lvx_v1_ASWAPH_coherency_offset27_registerZ_registerT_double;
              case 0x00000004:
                return Opcode_lvx_v1_ALADDH_coherency_offset27_registerZ_registerT_double;
              case 0x00000005:
                return Opcode_lvx_v1_ALANDH_coherency_offset27_registerZ_registerT_double;
              case 0x00000006:
                return Opcode_lvx_v1_ALIORH_coherency_offset27_registerZ_registerT_double;
              case 0x00000007:
                return Opcode_lvx_v1_ALEORH_coherency_offset27_registerZ_registerT_double;
              case 0x00000008:
                return Opcode_lvx_v1_ALMINH_coherency_offset27_registerZ_registerT_double;
              case 0x00000009:
                return Opcode_lvx_v1_ALMAXH_coherency_offset27_registerZ_registerT_double;
              case 0x0000000a:
                return Opcode_lvx_v1_ALMINUH_coherency_offset27_registerZ_registerT_double;
              case 0x0000000b:
                return Opcode_lvx_v1_ALMAXUH_coherency_offset27_registerZ_registerT_double;
              case 0x0000000e:
                return Opcode_lvx_v1_ALDUSH_coherency_offset27_registerZ_registerT_double;
              case 0x00000010:
                return Opcode_lvx_v1_ASH_coherency_offset27_registerZ_registerT_double;
              case 0x00000014:
                return Opcode_lvx_v1_ASADDH_coherency_offset27_registerZ_registerT_double;
              case 0x00000015:
                return Opcode_lvx_v1_ASANDH_coherency_offset27_registerZ_registerT_double;
              case 0x00000016:
                return Opcode_lvx_v1_ASIORH_coherency_offset27_registerZ_registerT_double;
              case 0x00000017:
                return Opcode_lvx_v1_ASEORH_coherency_offset27_registerZ_registerT_double;
              case 0x00000018:
                return Opcode_lvx_v1_ASMINH_coherency_offset27_registerZ_registerT_double;
              case 0x00000019:
                return Opcode_lvx_v1_ASMAXH_coherency_offset27_registerZ_registerT_double;
              case 0x0000001a:
                return Opcode_lvx_v1_ASMINUH_coherency_offset27_registerZ_registerT_double;
              case 0x0000001b:
                return Opcode_lvx_v1_ASMAXUH_coherency_offset27_registerZ_registerT_double;
              case 0x0000001e:
                return Opcode_lvx_v1_ASDUSH_coherency_offset27_registerZ_registerT_double;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              return Opcode_lvx_v1_ACSWAPH_boolcas_coherency_registerW_offset27_registerZ_registerO_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 7) & 0x0000001f) {
              case 0x00000000:
                return Opcode_lvx_v1_ALW_coherency_registerW_offset27_registerZ_double;
              case 0x00000001:
                return Opcode_lvx_v1_ALCLRW_coherency_registerW_offset27_registerZ_double;
              case 0x00000002:
                return Opcode_lvx_v1_ASWAPW_coherency_offset27_registerZ_registerT_double;
              case 0x00000004:
                return Opcode_lvx_v1_ALADDW_coherency_offset27_registerZ_registerT_double;
              case 0x00000005:
                return Opcode_lvx_v1_ALANDW_coherency_offset27_registerZ_registerT_double;
              case 0x00000006:
                return Opcode_lvx_v1_ALIORW_coherency_offset27_registerZ_registerT_double;
              case 0x00000007:
                return Opcode_lvx_v1_ALEORW_coherency_offset27_registerZ_registerT_double;
              case 0x00000008:
                return Opcode_lvx_v1_ALMINW_coherency_offset27_registerZ_registerT_double;
              case 0x00000009:
                return Opcode_lvx_v1_ALMAXW_coherency_offset27_registerZ_registerT_double;
              case 0x0000000a:
                return Opcode_lvx_v1_ALMINUW_coherency_offset27_registerZ_registerT_double;
              case 0x0000000b:
                return Opcode_lvx_v1_ALMAXUW_coherency_offset27_registerZ_registerT_double;
              case 0x0000000e:
                return Opcode_lvx_v1_ALDUSW_coherency_offset27_registerZ_registerT_double;
              case 0x00000010:
                return Opcode_lvx_v1_ASW_coherency_offset27_registerZ_registerT_double;
              case 0x00000014:
                return Opcode_lvx_v1_ASADDW_coherency_offset27_registerZ_registerT_double;
              case 0x00000015:
                return Opcode_lvx_v1_ASANDW_coherency_offset27_registerZ_registerT_double;
              case 0x00000016:
                return Opcode_lvx_v1_ASIORW_coherency_offset27_registerZ_registerT_double;
              case 0x00000017:
                return Opcode_lvx_v1_ASEORW_coherency_offset27_registerZ_registerT_double;
              case 0x00000018:
                return Opcode_lvx_v1_ASMINW_coherency_offset27_registerZ_registerT_double;
              case 0x00000019:
                return Opcode_lvx_v1_ASMAXW_coherency_offset27_registerZ_registerT_double;
              case 0x0000001a:
                return Opcode_lvx_v1_ASMINUW_coherency_offset27_registerZ_registerT_double;
              case 0x0000001b:
                return Opcode_lvx_v1_ASMAXUW_coherency_offset27_registerZ_registerT_double;
              case 0x0000001e:
                return Opcode_lvx_v1_ASDUSW_coherency_offset27_registerZ_registerT_double;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              return Opcode_lvx_v1_ACSWAPW_boolcas_coherency_registerW_offset27_registerZ_registerO_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 7) & 0x0000001f) {
              case 0x00000000:
                return Opcode_lvx_v1_ALD_coherency_registerW_offset27_registerZ_double;
              case 0x00000001:
                return Opcode_lvx_v1_ALCLRD_coherency_registerW_offset27_registerZ_double;
              case 0x00000002:
                return Opcode_lvx_v1_ASWAPD_coherency_offset27_registerZ_registerT_double;
              case 0x00000004:
                return Opcode_lvx_v1_ALADDD_coherency_offset27_registerZ_registerT_double;
              case 0x00000005:
                return Opcode_lvx_v1_ALANDD_coherency_offset27_registerZ_registerT_double;
              case 0x00000006:
                return Opcode_lvx_v1_ALIORD_coherency_offset27_registerZ_registerT_double;
              case 0x00000007:
                return Opcode_lvx_v1_ALEORD_coherency_offset27_registerZ_registerT_double;
              case 0x00000008:
                return Opcode_lvx_v1_ALMIND_coherency_offset27_registerZ_registerT_double;
              case 0x00000009:
                return Opcode_lvx_v1_ALMAXD_coherency_offset27_registerZ_registerT_double;
              case 0x0000000a:
                return Opcode_lvx_v1_ALMINUD_coherency_offset27_registerZ_registerT_double;
              case 0x0000000b:
                return Opcode_lvx_v1_ALMAXUD_coherency_offset27_registerZ_registerT_double;
              case 0x0000000e:
                return Opcode_lvx_v1_ALDUSD_coherency_offset27_registerZ_registerT_double;
              case 0x00000010:
                return Opcode_lvx_v1_ASD_coherency_offset27_registerZ_registerT_double;
              case 0x00000014:
                return Opcode_lvx_v1_ASADDD_coherency_offset27_registerZ_registerT_double;
              case 0x00000015:
                return Opcode_lvx_v1_ASANDD_coherency_offset27_registerZ_registerT_double;
              case 0x00000016:
                return Opcode_lvx_v1_ASIORD_coherency_offset27_registerZ_registerT_double;
              case 0x00000017:
                return Opcode_lvx_v1_ASEORD_coherency_offset27_registerZ_registerT_double;
              case 0x00000018:
                return Opcode_lvx_v1_ASMIND_coherency_offset27_registerZ_registerT_double;
              case 0x00000019:
                return Opcode_lvx_v1_ASMAXD_coherency_offset27_registerZ_registerT_double;
              case 0x0000001a:
                return Opcode_lvx_v1_ASMINUD_coherency_offset27_registerZ_registerT_double;
              case 0x0000001b:
                return Opcode_lvx_v1_ASMAXUD_coherency_offset27_registerZ_registerT_double;
              case 0x0000001e:
                return Opcode_lvx_v1_ASDUSD_coherency_offset27_registerZ_registerT_double;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              return Opcode_lvx_v1_ACSWAPD_boolcas_coherency_registerW_offset27_registerZ_registerO_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000004:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_ACSWAPQ_boolcas_coherency_registerM_offset27_registerZ_registerQ_double;
              default:
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000000e:
    switch ((codeWord_0 >> 16) & 0x00000003) {
    case 0x00000000:
      switch ((codeWord_0 >> 24) & 0x0000000f) {
      case 0x00000000:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_MAKE_registerW_extend6_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_PCREL_registerW_extend6_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_ADDD_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_SBFD_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000004:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_MIND_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000005:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_MAXD_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000006:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_MINUD_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000007:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_MAXUD_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000008:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_ANDD_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000009:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_NANDD_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000a:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_IORD_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000b:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_NIORD_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000c:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_EORD_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000d:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_NEORD_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000e:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_ANDND_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000f:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_IORND_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 24) & 0x0000000f) {
      case 0x0000000e:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_SBMM8D_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000f:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_SBMMT8D_registerW_registerZ_upper27_lower10_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000002:
      switch ((codeWord_0 >> 12) & 0x0000000f) {
      case 0x00000000:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_SIGND_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_SIGNSD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ADDD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_SBFD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000004:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MIND_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000005:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MAXD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000006:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MINUD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000007:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MAXUD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000008:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ANDD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000009:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_NANDD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000a:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_IORD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000b:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_NIORD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000c:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_EORD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000d:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_NEORD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000e:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ANDND_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000f:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_IORND_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000002:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              return Opcode_lvx_v1_ADDQ_registerM_registerP_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              return Opcode_lvx_v1_SBFQ_registerM_registerP_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000008:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              return Opcode_lvx_v1_ANDQ_registerM_registerP_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000009:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              return Opcode_lvx_v1_NANDQ_registerM_registerP_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000a:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              return Opcode_lvx_v1_IORQ_registerM_registerP_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000b:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              return Opcode_lvx_v1_NIORQ_registerM_registerP_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000c:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              return Opcode_lvx_v1_EORQ_registerM_registerP_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000d:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              return Opcode_lvx_v1_NEORQ_registerM_registerP_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000e:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              return Opcode_lvx_v1_ANDNQ_registerM_registerP_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000f:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              return Opcode_lvx_v1_IORNQ_registerM_registerP_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 24) & 0x0000000f) {
          case 0x0000000c:
            return Opcode_lvx_v1_SBMM8EORD_registerW_registerZ_upper27_lower5_splat32_double;
          case 0x0000000d:
            return Opcode_lvx_v1_SBMMT8EORD_registerW_registerZ_upper27_lower5_splat32_double;
          case 0x0000000e:
            return Opcode_lvx_v1_SBMM8D_registerW_registerZ_upper27_lower5_splat32_double;
          case 0x0000000f:
            return Opcode_lvx_v1_SBMMT8D_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_COMPD_intcomp_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000004:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x0000000c:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ABDD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000d:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ABDUD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000e:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ABDSD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000006:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_CMOVED_cmovecond_registerZ_registerW_upper27_lower5_splat32_double;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000a:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ADDX2D_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ADDX4D_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ADDX8D_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ADDX16D_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000004:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ADDX32D_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000005:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ADDX64D_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000008:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ADDSD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000009:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_SBFSD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000a:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ADDUSD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000b:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_SBFUSD_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000c:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MULD_highmult_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MULND_highmult_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MADDD_highmult_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MSBFD_highmult_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000e:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x00000003) {
            case 0x00000001:
              switch ((codeWord_0 >> 11) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MULUWD_registerW_registerZ_upper27_lower5_double;
              default:
                return Opcode_lvx_v1_MULWD_widemult_registerW_registerZ_upper27_lower5_splat32_double;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000002:
              switch ((codeWord_0 >> 11) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MULSUWD_registerW_registerZ_upper27_lower5_double;
              default:
                return Opcode_lvx_v1_MULWD_widemult_registerW_registerZ_upper27_lower5_splat32_double;
                break;
              }
              return Opcode__UNDEF;
            default:
              return Opcode_lvx_v1_MULWD_widemult_registerW_registerZ_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MULNWD_widemult_registerW_registerZ_upper27_lower5_splat32_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x00000003) {
            case 0x00000001:
              switch ((codeWord_0 >> 11) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MADDUWD_registerW_registerZ_upper27_lower5_double;
              default:
                return Opcode_lvx_v1_MADDWD_widemult_registerW_registerZ_upper27_lower5_splat32_double;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000002:
              switch ((codeWord_0 >> 11) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MADDSUWD_registerW_registerZ_upper27_lower5_double;
              default:
                return Opcode_lvx_v1_MADDWD_widemult_registerW_registerZ_upper27_lower5_splat32_double;
                break;
              }
              return Opcode__UNDEF;
            default:
              return Opcode_lvx_v1_MADDWD_widemult_registerW_registerZ_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x00000003) {
            case 0x00000001:
              switch ((codeWord_0 >> 11) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MSBFUWD_registerW_registerZ_upper27_lower5_double;
              default:
                return Opcode_lvx_v1_MSBFWD_widemult_registerW_registerZ_upper27_lower5_splat32_double;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000002:
              switch ((codeWord_0 >> 11) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MSBFSUWD_registerW_registerZ_upper27_lower5_double;
              default:
                return Opcode_lvx_v1_MSBFWD_widemult_registerW_registerZ_upper27_lower5_splat32_double;
                break;
              }
              return Opcode__UNDEF;
            default:
              return Opcode_lvx_v1_MSBFWD_widemult_registerW_registerZ_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000003:
      switch ((codeWord_0 >> 13) & 0x00000007) {
      case 0x00000000:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SIGNW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SIGNSW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000004:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MINW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000005:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MAXW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000006:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MINUW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000007:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MAXUW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000008:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ANDW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000009:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_NANDW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000a:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_IORW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000b:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_NIORW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000c:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_EORW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000d:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_NEORW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000e:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ANDNW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000f:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_IORNW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 11) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_AVGW_signextw_registerW_registerZ_upper27_lower5_double;
            case 0x0000000d:
              return Opcode_lvx_v1_AVGUW_signextw_registerW_registerZ_upper27_lower5_double;
            case 0x0000000e:
              return Opcode_lvx_v1_AVGRW_signextw_registerW_registerZ_upper27_lower5_double;
            case 0x0000000f:
              return Opcode_lvx_v1_AVGRUW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              return Opcode_lvx_v1_COMPW_intcomp_signextw_registerW_registerZ_upper27_lower5_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000004:
          switch ((codeWord_0 >> 11) & 0x00000003) {
          case 0x00000002:
            switch ((codeWord_1 >> 29) & 0x00000003) {
            case 0x00000000:
              return Opcode_lvx_v1_CRCBELMW_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000005:
          switch ((codeWord_0 >> 11) & 0x00000003) {
          case 0x00000002:
            switch ((codeWord_1 >> 29) & 0x00000003) {
            case 0x00000000:
              return Opcode_lvx_v1_CRCBELLW_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000006:
          switch ((codeWord_0 >> 11) & 0x00000003) {
          case 0x00000002:
            switch ((codeWord_1 >> 29) & 0x00000003) {
            case 0x00000000:
              return Opcode_lvx_v1_CRCLELMW_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000007:
          switch ((codeWord_0 >> 11) & 0x00000003) {
          case 0x00000002:
            switch ((codeWord_1 >> 29) & 0x00000003) {
            case 0x00000000:
              return Opcode_lvx_v1_CRCLELLW_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000c:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ABDW_signextw_registerW_registerZ_upper27_lower5_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000d:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ABDUW_signextw_registerW_registerZ_upper27_lower5_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000e:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ABDSW_signextw_registerW_registerZ_upper27_lower5_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000005:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX2W_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX4W_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX8W_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX16W_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000004:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX32W_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000005:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX64W_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000008:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDSW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000009:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFSW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000a:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDUSW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000b:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFUSW_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000006:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MULW_highmult_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MULNW_highmult_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MADDW_highmult_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_1 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 11) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MSBFW_highmult_signextw_registerW_registerZ_upper27_lower5_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
      break;
    }
    return Opcode__UNDEF;
  case 0x0000000f:
    switch ((codeWord_0 >> 12) & 0x0000003f) {
    case 0x00000004:
      switch ((codeWord_1 >> 29) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 11) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 27) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_FCOMPD_floatcomp_registerW_registerZ_upper27_lower5_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000014:
      switch ((codeWord_1 >> 29) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 11) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 27) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_FCOMPW_floatcomp_registerW_registerZ_upper27_lower5_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000015:
      switch ((codeWord_1 >> 29) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 11) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 27) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_FCOMPH_floatcomp_registerW_registerZ_upper27_lower5_double;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000020:
      switch ((codeWord_0 >> 24) & 0x0000000f) {
      case 0x00000000:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SIGNWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SIGNWP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SIGNSWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SIGNSWP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDWP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SBFWP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000004:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MINWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_MINWP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000005:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MAXWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_MAXWP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000006:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MINUWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_MINUWP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000007:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MAXUWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_MAXUWP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000021:
      switch ((codeWord_0 >> 24) & 0x0000000f) {
      case 0x00000000:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SIGNHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SIGNHQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SIGNBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SIGNBO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SIGNSHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SIGNSHQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SIGNSBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SIGNSBO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDHQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDBO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SBFHQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SBFBO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000004:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MINHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_MINHQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MINBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_MINBO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000005:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MAXHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_MAXHQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MAXBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_MAXBO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000006:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MINUHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_MINUHQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MINUBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_MINUBO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000007:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MAXUHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_MAXUHQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MAXUBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_MAXUBO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000022:
      switch ((codeWord_1 >> 29) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_AVGWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000d:
              return Opcode_lvx_v1_AVGUWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000e:
              return Opcode_lvx_v1_AVGRWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000f:
              return Opcode_lvx_v1_AVGRUWP_registerWe_registerZe_upper27_lower5_splat32_double;
            default:
              return Opcode_lvx_v1_COMPWP_intcomp_registerWe_registerZe_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_AVGWP_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000d:
              return Opcode_lvx_v1_AVGUWP_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000e:
              return Opcode_lvx_v1_AVGRWP_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000f:
              return Opcode_lvx_v1_AVGRUWP_registerWo_registerZo_upper27_lower5_splat32_double;
            default:
              return Opcode_lvx_v1_COMPWP_intcomp_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000023:
      switch ((codeWord_1 >> 29) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_AVGHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000d:
              return Opcode_lvx_v1_AVGUHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000e:
              return Opcode_lvx_v1_AVGRHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000f:
              return Opcode_lvx_v1_AVGRUHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            default:
              return Opcode_lvx_v1_COMPHQ_intcomp_registerWe_registerZe_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_AVGHQ_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000d:
              return Opcode_lvx_v1_AVGUHQ_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000e:
              return Opcode_lvx_v1_AVGRHQ_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000f:
              return Opcode_lvx_v1_AVGRUHQ_registerWo_registerZo_upper27_lower5_splat32_double;
            default:
              return Opcode_lvx_v1_COMPHQ_intcomp_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_AVGBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000d:
              return Opcode_lvx_v1_AVGUBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000e:
              return Opcode_lvx_v1_AVGRBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000f:
              return Opcode_lvx_v1_AVGRUBO_registerWe_registerZe_upper27_lower5_splat32_double;
            default:
              return Opcode_lvx_v1_COMPBO_intcomp_registerWe_registerZe_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_AVGBO_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000d:
              return Opcode_lvx_v1_AVGUBO_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000e:
              return Opcode_lvx_v1_AVGRBO_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000f:
              return Opcode_lvx_v1_AVGRUBO_registerWo_registerZo_upper27_lower5_splat32_double;
            default:
              return Opcode_lvx_v1_COMPBO_intcomp_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000024:
      switch ((codeWord_1 >> 29) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_COMPND_intcomp_registerWe_registerZe_upper27_lower5_splat32_double;
          case 0x00000001:
            return Opcode_lvx_v1_COMPND_intcomp_registerWo_registerZo_upper27_lower5_splat32_double;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_ABDWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000d:
              return Opcode_lvx_v1_ABDUWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000e:
              return Opcode_lvx_v1_ABDSWP_registerWe_registerZe_upper27_lower5_splat32_double;
            default:
              return Opcode_lvx_v1_COMPNWP_intcomp_registerWe_registerZe_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_ABDWP_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000d:
              return Opcode_lvx_v1_ABDUWP_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000e:
              return Opcode_lvx_v1_ABDSWP_registerWo_registerZo_upper27_lower5_splat32_double;
            default:
              return Opcode_lvx_v1_COMPNWP_intcomp_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000025:
      switch ((codeWord_1 >> 29) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_ABDHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000d:
              return Opcode_lvx_v1_ABDUHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000e:
              return Opcode_lvx_v1_ABDSHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            default:
              return Opcode_lvx_v1_COMPNHQ_intcomp_registerWe_registerZe_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_ABDHQ_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000d:
              return Opcode_lvx_v1_ABDUHQ_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000e:
              return Opcode_lvx_v1_ABDSHQ_registerWo_registerZo_upper27_lower5_splat32_double;
            default:
              return Opcode_lvx_v1_COMPNHQ_intcomp_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_ABDBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000d:
              return Opcode_lvx_v1_ABDUBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x0000000e:
              return Opcode_lvx_v1_ABDSBO_registerWe_registerZe_upper27_lower5_splat32_double;
            default:
              return Opcode_lvx_v1_COMPNBO_intcomp_registerWe_registerZe_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_ABDBO_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000d:
              return Opcode_lvx_v1_ABDUBO_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x0000000e:
              return Opcode_lvx_v1_ABDSBO_registerWo_registerZo_upper27_lower5_splat32_double;
            default:
              return Opcode_lvx_v1_COMPNBO_intcomp_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000026:
      switch ((codeWord_1 >> 29) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_CMOVEWP_lanecond_registerZe_registerWe_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_CMOVEWP_lanecond_registerZo_registerWo_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000027:
      switch ((codeWord_1 >> 29) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_CMOVEHQ_lanecond_registerZe_registerWe_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_CMOVEHQ_lanecond_registerZo_registerWo_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_CMOVEBO_lanecond_registerZe_registerWe_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_CMOVEBO_lanecond_registerZo_registerWo_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x0000002a:
      switch ((codeWord_0 >> 24) & 0x0000000f) {
      case 0x00000000:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX2WP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX2WP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX4WP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX4WP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX8WP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX8WP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX16WP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX16WP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000008:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDSWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDSWP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000009:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFSWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SBFSWP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000a:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDUSWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDUSWP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000b:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFUSWP_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SBFUSWP_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x0000002b:
      switch ((codeWord_0 >> 24) & 0x0000000f) {
      case 0x00000000:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX2HQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX2HQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX2BO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX2BO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX4HQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX4HQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX4BO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX4BO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX8HQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX8HQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX8BO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX8BO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX16HQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX16HQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX16BO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX16BO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000008:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDSHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDSHQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDSBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDSBO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000009:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFSHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SBFSHQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFSBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SBFSBO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000a:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDUSHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDUSHQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDUSBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_ADDUSBO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000b:
        switch ((codeWord_1 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFUSHQ_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SBFUSHQ_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFUSBO_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_SBFUSBO_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000033:
      switch ((codeWord_1 >> 29) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 27) & 0x00000001) {
            case 0x00000001:
              return Opcode_lvx_v1_FCOMPNWP_floatcomp_registerWe_registerZe_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 27) & 0x00000001) {
            case 0x00000001:
              return Opcode_lvx_v1_FCOMPNWP_floatcomp_registerWo_registerZo_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000035:
      switch ((codeWord_1 >> 29) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 27) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FCOMPWP_floatcomp_registerWe_registerZe_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 27) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FCOMPWP_floatcomp_registerWo_registerZo_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 27) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FCOMPHQ_floatcomp_registerWe_registerZe_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_FCOMPNHQ_floatcomp_registerWe_registerZe_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 27) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FCOMPHQ_floatcomp_registerWo_registerZo_upper27_lower5_splat32_double;
            case 0x00000001:
              return Opcode_lvx_v1_FCOMPNHQ_floatcomp_registerWo_registerZo_upper27_lower5_splat32_double;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000036:
      switch ((codeWord_1 >> 29) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 27) & 0x00000001) {
            case 0x00000001:
              return Opcode_lvx_v1_FCOMPND_floatcomp_registerWe_registerZe_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 27) & 0x00000001) {
            case 0x00000001:
              return Opcode_lvx_v1_FCOMPND_floatcomp_registerWo_registerZo_upper27_lower5_splat32_double;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  default:
    break;
  }
  return Opcode__UNDEF;
}
#endif//NDECODE

#ifdef $XCC__h
#ifndef NDECODE
extern Opcode
Decode_Decoding_lvx_v1_riscv(const void *buffer);
#endif//NDECODE
#endif//$XCC__h

#ifndef NDECODE
Opcode
Decode_Decoding_lvx_v1_riscv(const void *buffer)
{
  const uint32_t *codeWords = (const uint32_t *)buffer;
  uint32_t codeWord_0 = codeWords[0];
  switch ((codeWord_0 >> 0) & 0x0000007f) {
  case 0x00000003:
    switch ((codeWord_0 >> 12) & 0x00000007) {
    case 0x00000000:
      return Opcode_lvx_v1_LB_rd_i_11_0_rs1_riscv;
    case 0x00000001:
      return Opcode_lvx_v1_LH_rd_i_11_0_rs1_riscv;
    case 0x00000002:
      return Opcode_lvx_v1_LW_rd_i_11_0_rs1_riscv;
    case 0x00000003:
      return Opcode_lvx_v1_LD_rd_i_11_0_rs1_riscv;
    case 0x00000004:
      return Opcode_lvx_v1_LBU_rd_i_11_0_rs1_riscv;
    case 0x00000005:
      return Opcode_lvx_v1_LHU_rd_i_11_0_rs1_riscv;
    case 0x00000006:
      return Opcode_lvx_v1_LWU_rd_i_11_0_rs1_riscv;
    case 0x00000007:
      switch ((codeWord_0 >> 7) & 0x00000001) {
      case 0x00000000:
        return Opcode_lvx_v1_KV_LQ_rd_pair_i_11_0_rs1_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
      break;
    }
    return Opcode__UNDEF;
  case 0x00000007:
    switch ((codeWord_0 >> 12) & 0x00000007) {
    case 0x00000002:
      return Opcode_lvx_v1_FLW_frd_i_11_0_rs1_riscv;
    case 0x00000003:
      return Opcode_lvx_v1_FLD_frd_i_11_0_rs1_riscv;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000000f:
    switch ((codeWord_0 >> 7) & 0x000000ff) {
    case 0x00000000:
      switch ((codeWord_0 >> 15) & 0x0000001f) {
      case 0x00000000:
        switch ((codeWord_0 >> 28) & 0x0000000f) {
        case 0x00000000:
          return Opcode_lvx_v1_FENCE_MEM_pred_succ_riscv;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000020:
      switch ((codeWord_0 >> 15) & 0x0001ffff) {
      case 0x00000000:
        return Opcode_lvx_v1_FENCE_I_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000040:
      switch ((codeWord_0 >> 20) & 0x00000fff) {
      case 0x00000000:
        return Opcode_lvx_v1_CBO_INVAL_rs1_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_CBO_CLEAN_rs1_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_CBO_FLUSH_rs1_riscv;
      case 0x00000004:
        return Opcode_lvx_v1_CBO_ZERO_rs1_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000013:
    switch ((codeWord_0 >> 12) & 0x00000007) {
    case 0x00000000:
      switch ((codeWord_0 >> 20) & 0x00000fff) {
      case 0x00000000:
        switch ((codeWord_0 >> 7) & 0x0000001f) {
        case 0x00000000:
          switch ((codeWord_0 >> 15) & 0x0000001f) {
          case 0x00000000:
            return Opcode_lvx_v1_NOP_riscv;
          default:
            return Opcode_lvx_v1_MV_rd_rs1_riscv;
            break;
          }
          return Opcode__UNDEF;
        default:
          return Opcode_lvx_v1_MV_rd_rs1_riscv;
          break;
        }
        return Opcode__UNDEF;
      default:
        switch ((codeWord_0 >> 15) & 0x0000001f) {
        case 0x00000000:
          return Opcode_lvx_v1_LI_rd_i_11_0_riscv;
        default:
          return Opcode_lvx_v1_ADDI_rd_rs1_i_11_0_riscv;
          break;
        }
        return Opcode__UNDEF;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 26) & 0x0000003f) {
      case 0x00000000:
        return Opcode_lvx_v1_SLLI_rd_rs1_i_5_0_riscv;
      case 0x0000000a:
        return Opcode_lvx_v1_BSETI_rd_rs1_i_5_0_riscv;
      case 0x00000012:
        return Opcode_lvx_v1_BCLRI_rd_rs1_i_5_0_riscv;
      case 0x00000018:
        switch ((codeWord_0 >> 20) & 0x0000003f) {
        case 0x00000000:
          return Opcode_lvx_v1_CLZ_rd_rs1_riscv;
        case 0x00000001:
          return Opcode_lvx_v1_CTZ_rd_rs1_riscv;
        case 0x00000002:
          return Opcode_lvx_v1_CPOP_rd_rs1_riscv;
        case 0x00000004:
          return Opcode_lvx_v1_SEXT_B_rd_rs1_riscv;
        case 0x00000005:
          return Opcode_lvx_v1_SEXT_H_rd_rs1_riscv;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000001a:
        return Opcode_lvx_v1_BINVI_rd_rs1_i_5_0_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000002:
      return Opcode_lvx_v1_SLTI_rd_rs1_i_11_0_riscv;
    case 0x00000003:
      switch ((codeWord_0 >> 20) & 0x00000fff) {
      case 0x00000001:
        return Opcode_lvx_v1_SEQZ_rd_rs1_riscv;
      default:
        return Opcode_lvx_v1_SLTIU_rd_rs1_i_11_0_riscv;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000004:
      switch ((codeWord_0 >> 20) & 0x00000fff) {
      case 0x00000fff:
        return Opcode_lvx_v1_NOT_rd_rs1_riscv;
      default:
        return Opcode_lvx_v1_XORI_rd_rs1_i_11_0_riscv;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000005:
      switch ((codeWord_0 >> 26) & 0x0000003f) {
      case 0x00000000:
        return Opcode_lvx_v1_SRLI_rd_rs1_i_5_0_riscv;
      case 0x0000000a:
        switch ((codeWord_0 >> 20) & 0x0000003f) {
        case 0x00000007:
          return Opcode_lvx_v1_ORC_B_rd_rs1_riscv;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000010:
        return Opcode_lvx_v1_SRAI_rd_rs1_i_5_0_riscv;
      case 0x00000012:
        return Opcode_lvx_v1_BEXTI_rd_rs1_i_5_0_riscv;
      case 0x00000018:
        return Opcode_lvx_v1_RORI_rd_rs1_i_5_0_riscv;
      case 0x0000001a:
        switch ((codeWord_0 >> 20) & 0x0000003f) {
        case 0x00000038:
          return Opcode_lvx_v1_REV8_rd_rs1_riscv;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000006:
      switch ((codeWord_0 >> 7) & 0x0000001f) {
      case 0x00000000:
        switch ((codeWord_0 >> 20) & 0x0000001f) {
        case 0x00000000:
          return Opcode_lvx_v1_PREFETCH_I_i_11_5_rs1_riscv;
        case 0x00000001:
          return Opcode_lvx_v1_PREFETCH_R_i_11_5_rs1_riscv;
        case 0x00000003:
          return Opcode_lvx_v1_PREFETCH_W_i_11_5_rs1_riscv;
        default:
          return Opcode_lvx_v1_ORI_rd_rs1_i_11_0_riscv;
          break;
        }
        return Opcode__UNDEF;
      default:
        return Opcode_lvx_v1_ORI_rd_rs1_i_11_0_riscv;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000007:
      return Opcode_lvx_v1_ANDI_rd_rs1_i_11_0_riscv;
      break;
    }
    return Opcode__UNDEF;
  case 0x00000017:
    return Opcode_lvx_v1_AUIPC_rd_i_31_12_riscv;
  case 0x0000001b:
    switch ((codeWord_0 >> 12) & 0x00000007) {
    case 0x00000000:
      switch ((codeWord_0 >> 20) & 0x00000fff) {
      case 0x00000000:
        return Opcode_lvx_v1_SEXT_W_rd_rs1_riscv;
      default:
        return Opcode_lvx_v1_ADDIW_rd_rs1_i_11_0_riscv;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 26) & 0x0000003f) {
      case 0x00000000:
        switch ((codeWord_0 >> 25) & 0x00000001) {
        case 0x00000000:
          return Opcode_lvx_v1_SLLIW_rd_rs1_i_4_0_riscv;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        return Opcode_lvx_v1_SLLI_UW_rd_rs1_i_5_0_riscv;
      case 0x00000018:
        switch ((codeWord_0 >> 20) & 0x0000003f) {
        case 0x00000000:
          return Opcode_lvx_v1_CLZW_rd_rs1_riscv;
        case 0x00000001:
          return Opcode_lvx_v1_CTZW_rd_rs1_riscv;
        case 0x00000002:
          return Opcode_lvx_v1_CPOPW_rd_rs1_riscv;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000005:
      switch ((codeWord_0 >> 25) & 0x0000007f) {
      case 0x00000000:
        return Opcode_lvx_v1_SRLIW_rd_rs1_i_4_0_riscv;
      case 0x00000020:
        return Opcode_lvx_v1_SRAIW_rd_rs1_i_4_0_riscv;
      case 0x00000030:
        return Opcode_lvx_v1_RORIW_rd_rs1_i_4_0_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000023:
    switch ((codeWord_0 >> 12) & 0x00000007) {
    case 0x00000000:
      return Opcode_lvx_v1_SB_rs2_i_11_5_i_4_0s_rs1_riscv;
    case 0x00000001:
      return Opcode_lvx_v1_SH_rs2_i_11_5_i_4_0s_rs1_riscv;
    case 0x00000002:
      return Opcode_lvx_v1_SW_rs2_i_11_5_i_4_0s_rs1_riscv;
    case 0x00000003:
      return Opcode_lvx_v1_SD_rs2_i_11_5_i_4_0s_rs1_riscv;
    case 0x00000004:
      switch ((codeWord_0 >> 20) & 0x00000001) {
      case 0x00000000:
        return Opcode_lvx_v1_KV_SQ_rs2_pair_i_11_5_i_4_0s_rs1_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000027:
    switch ((codeWord_0 >> 12) & 0x00000007) {
    case 0x00000002:
      return Opcode_lvx_v1_FSW_frs2_i_11_5_i_4_0s_rs1_riscv;
    case 0x00000003:
      return Opcode_lvx_v1_FSD_frs2_i_11_5_i_4_0s_rs1_riscv;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000002f:
    switch ((codeWord_0 >> 27) & 0x0000001f) {
    case 0x00000000:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_AMOADD_B_acqrel_rd_rs2_rs1_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_AMOADD_H_acqrel_rd_rs2_rs1_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_AMOADD_W_acqrel_rd_rs2_rs1_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_AMOADD_D_acqrel_rd_rs2_rs1_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_AMOSWAP_B_acqrel_rd_rs2_rs1_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_AMOSWAP_H_acqrel_rd_rs2_rs1_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_AMOSWAP_W_acqrel_rd_rs2_rs1_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_AMOSWAP_D_acqrel_rd_rs2_rs1_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000002:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000000:
        switch ((codeWord_0 >> 12) & 0x00000007) {
        case 0x00000002:
          return Opcode_lvx_v1_LR_W_acqrel_rd_rs1_riscv;
        case 0x00000003:
          return Opcode_lvx_v1_LR_D_acqrel_rd_rs1_riscv;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000003:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000002:
        return Opcode_lvx_v1_SC_W_acqrel_rd_rs2_rs1_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_SC_D_acqrel_rd_rs2_rs1_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000004:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_AMOXOR_B_acqrel_rd_rs2_rs1_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_AMOXOR_H_acqrel_rd_rs2_rs1_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_AMOXOR_W_acqrel_rd_rs2_rs1_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_AMOXOR_D_acqrel_rd_rs2_rs1_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000005:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_AMOCAS_B_acqrel_rd_rs2_rs1_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_AMOCAS_H_acqrel_rd_rs2_rs1_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_AMOCAS_W_acqrel_rd_rs2_rs1_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_AMOCAS_D_acqrel_rd_rs2_rs1_riscv;
      case 0x00000004:
        switch ((codeWord_0 >> 7) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 20) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_AMOCAS_Q_acqrel_rd_pair_rs2_pair_rs1_riscv;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000008:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_AMOOR_B_acqrel_rd_rs2_rs1_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_AMOOR_H_acqrel_rd_rs2_rs1_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_AMOOR_W_acqrel_rd_rs2_rs1_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_AMOOR_D_acqrel_rd_rs2_rs1_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x0000000c:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_AMOAND_B_acqrel_rd_rs2_rs1_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_AMOAND_H_acqrel_rd_rs2_rs1_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_AMOAND_W_acqrel_rd_rs2_rs1_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_AMOAND_D_acqrel_rd_rs2_rs1_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000010:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_AMOMIN_B_acqrel_rd_rs2_rs1_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_AMOMIN_H_acqrel_rd_rs2_rs1_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_AMOMIN_W_acqrel_rd_rs2_rs1_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_AMOMIN_D_acqrel_rd_rs2_rs1_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000014:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_AMOMAX_B_acqrel_rd_rs2_rs1_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_AMOMAX_H_acqrel_rd_rs2_rs1_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_AMOMAX_W_acqrel_rd_rs2_rs1_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_AMOMAX_D_acqrel_rd_rs2_rs1_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000018:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_AMOMINU_B_acqrel_rd_rs2_rs1_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_AMOMINU_H_acqrel_rd_rs2_rs1_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_AMOMINU_W_acqrel_rd_rs2_rs1_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_AMOMINU_D_acqrel_rd_rs2_rs1_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x0000001c:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_AMOMAXU_B_acqrel_rd_rs2_rs1_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_AMOMAXU_H_acqrel_rd_rs2_rs1_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_AMOMAXU_W_acqrel_rd_rs2_rs1_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_AMOMAXU_D_acqrel_rd_rs2_rs1_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000033:
    switch ((codeWord_0 >> 25) & 0x0000007f) {
    case 0x00000000:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_ADD_rd_rs1_rs2_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_SLL_rd_rs1_rs2_riscv;
      case 0x00000002:
        switch ((codeWord_0 >> 15) & 0x0000001f) {
        case 0x00000000:
          return Opcode_lvx_v1_SGTZ_rd_rs2_riscv;
        default:
          switch ((codeWord_0 >> 20) & 0x0000001f) {
          case 0x00000000:
            return Opcode_lvx_v1_SLTZ_rd_rs1_riscv;
          default:
            return Opcode_lvx_v1_SLT_rd_rs1_rs2_riscv;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 15) & 0x0000001f) {
        case 0x00000000:
          return Opcode_lvx_v1_SNEZ_rd_rs2_riscv;
        default:
          return Opcode_lvx_v1_SLTU_rd_rs1_rs2_riscv;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000004:
        return Opcode_lvx_v1_XOR_rd_rs1_rs2_riscv;
      case 0x00000005:
        return Opcode_lvx_v1_SRL_rd_rs1_rs2_riscv;
      case 0x00000006:
        return Opcode_lvx_v1_OR_rd_rs1_rs2_riscv;
      case 0x00000007:
        return Opcode_lvx_v1_AND_rd_rs1_rs2_riscv;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_MUL_rd_rs1_rs2_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_MULH_rd_rs1_rs2_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_MULHSU_rd_rs1_rs2_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_MULHU_rd_rs1_rs2_riscv;
      case 0x00000004:
        return Opcode_lvx_v1_DIV_rd_rs1_rs2_riscv;
      case 0x00000005:
        return Opcode_lvx_v1_DIVU_rd_rs1_rs2_riscv;
      case 0x00000006:
        return Opcode_lvx_v1_REM_rd_rs1_rs2_riscv;
      case 0x00000007:
        return Opcode_lvx_v1_REMU_rd_rs1_rs2_riscv;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000005:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000001:
        return Opcode_lvx_v1_CLMUL_rd_rs1_rs2_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_CLMULR_rd_rs1_rs2_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_CLMULH_rd_rs1_rs2_riscv;
      case 0x00000004:
        return Opcode_lvx_v1_MIN_rd_rs1_rs2_riscv;
      case 0x00000005:
        return Opcode_lvx_v1_MINU_rd_rs1_rs2_riscv;
      case 0x00000006:
        return Opcode_lvx_v1_MAX_rd_rs1_rs2_riscv;
      case 0x00000007:
        return Opcode_lvx_v1_MAXU_rd_rs1_rs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000007:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000005:
        return Opcode_lvx_v1_CZERO_EQZ_rd_rs1_rs2_riscv;
      case 0x00000007:
        return Opcode_lvx_v1_CZERO_NEZ_rd_rs1_rs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000010:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000002:
        return Opcode_lvx_v1_SH1ADD_rd_rs1_rs2_riscv;
      case 0x00000004:
        return Opcode_lvx_v1_SH2ADD_rd_rs1_rs2_riscv;
      case 0x00000006:
        return Opcode_lvx_v1_SH3ADD_rd_rs1_rs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000014:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000001:
        return Opcode_lvx_v1_BSET_rd_rs1_rs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000020:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        switch ((codeWord_0 >> 15) & 0x0000001f) {
        case 0x00000000:
          return Opcode_lvx_v1_NEG_rd_rs2_riscv;
        default:
          return Opcode_lvx_v1_SUB_rd_rs1_rs2_riscv;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000004:
        return Opcode_lvx_v1_XNOR_rd_rs1_rs2_riscv;
      case 0x00000005:
        return Opcode_lvx_v1_SRA_rd_rs1_rs2_riscv;
      case 0x00000006:
        return Opcode_lvx_v1_ORN_rd_rs1_rs2_riscv;
      case 0x00000007:
        return Opcode_lvx_v1_ANDN_rd_rs1_rs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000024:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000001:
        return Opcode_lvx_v1_BCLR_rd_rs1_rs2_riscv;
      case 0x00000005:
        return Opcode_lvx_v1_BEXT_rd_rs1_rs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000030:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000001:
        return Opcode_lvx_v1_ROL_rd_rs1_rs2_riscv;
      case 0x00000005:
        return Opcode_lvx_v1_ROR_rd_rs1_rs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000034:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000001:
        return Opcode_lvx_v1_BINV_rd_rs1_rs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000037:
    return Opcode_lvx_v1_LUI_rd_i_31_12_riscv;
  case 0x0000003b:
    switch ((codeWord_0 >> 25) & 0x0000007f) {
    case 0x00000000:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_ADDW_rd_rs1_rs2_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_SLLW_rd_rs1_rs2_riscv;
      case 0x00000005:
        return Opcode_lvx_v1_SRLW_rd_rs1_rs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_MULW_rd_rs1_rs2_riscv;
      case 0x00000004:
        return Opcode_lvx_v1_DIVW_rd_rs1_rs2_riscv;
      case 0x00000005:
        return Opcode_lvx_v1_DIVUW_rd_rs1_rs2_riscv;
      case 0x00000006:
        return Opcode_lvx_v1_REMW_rd_rs1_rs2_riscv;
      case 0x00000007:
        return Opcode_lvx_v1_REMUW_rd_rs1_rs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000004:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_ADD_UW_rd_rs1_rs2_riscv;
      case 0x00000004:
        switch ((codeWord_0 >> 20) & 0x0000001f) {
        case 0x00000000:
          return Opcode_lvx_v1_ZEXT_H_rd_rs1_riscv;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000010:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000002:
        return Opcode_lvx_v1_SH1ADD_UW_rd_rs1_rs2_riscv;
      case 0x00000004:
        return Opcode_lvx_v1_SH2ADD_UW_rd_rs1_rs2_riscv;
      case 0x00000006:
        return Opcode_lvx_v1_SH3ADD_UW_rd_rs1_rs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000020:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        switch ((codeWord_0 >> 15) & 0x0000001f) {
        case 0x00000000:
          return Opcode_lvx_v1_NEGW_rd_rs2_riscv;
        default:
          return Opcode_lvx_v1_SUBW_rd_rs1_rs2_riscv;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000005:
        return Opcode_lvx_v1_SRAW_rd_rs1_rs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000030:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000001:
        return Opcode_lvx_v1_ROLW_rd_rs1_rs2_riscv;
      case 0x00000005:
        return Opcode_lvx_v1_RORW_rd_rs1_rs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000043:
    switch ((codeWord_0 >> 25) & 0x00000003) {
    case 0x00000000:
      return Opcode_lvx_v1_FMADD_S_frd_frs1_frs2_frs3_frm_riscv;
    case 0x00000001:
      return Opcode_lvx_v1_FMADD_D_frd_frs1_frs2_frs3_frm_riscv;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000047:
    switch ((codeWord_0 >> 25) & 0x00000003) {
    case 0x00000000:
      return Opcode_lvx_v1_FMSUB_S_frd_frs1_frs2_frs3_frm_riscv;
    case 0x00000001:
      return Opcode_lvx_v1_FMSUB_D_frd_frs1_frs2_frs3_frm_riscv;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000004b:
    switch ((codeWord_0 >> 25) & 0x00000003) {
    case 0x00000000:
      return Opcode_lvx_v1_FNMSUB_S_frd_frs1_frs2_frs3_frm_riscv;
    case 0x00000001:
      return Opcode_lvx_v1_FNMSUB_D_frd_frs1_frs2_frs3_frm_riscv;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000004f:
    switch ((codeWord_0 >> 25) & 0x00000003) {
    case 0x00000000:
      return Opcode_lvx_v1_FNMADD_S_frd_frs1_frs2_frs3_frm_riscv;
    case 0x00000001:
      return Opcode_lvx_v1_FNMADD_D_frd_frs1_frs2_frs3_frm_riscv;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000053:
    switch ((codeWord_0 >> 25) & 0x0000007f) {
    case 0x00000000:
      return Opcode_lvx_v1_FADD_S_frd_frs1_frs2_frm_riscv;
    case 0x00000001:
      return Opcode_lvx_v1_FADD_D_frd_frs1_frs2_frm_riscv;
    case 0x00000004:
      return Opcode_lvx_v1_FSUB_S_frd_frs1_frs2_frm_riscv;
    case 0x00000005:
      return Opcode_lvx_v1_FSUB_D_frd_frs1_frs2_frm_riscv;
    case 0x00000008:
      return Opcode_lvx_v1_FMUL_S_frd_frs1_frs2_frm_riscv;
    case 0x00000009:
      return Opcode_lvx_v1_FMUL_D_frd_frs1_frs2_frm_riscv;
    case 0x0000000c:
      return Opcode_lvx_v1_FDIV_S_frd_frs1_frs2_frm_riscv;
    case 0x0000000d:
      return Opcode_lvx_v1_FDIV_D_frd_frs1_frs2_frm_riscv;
    case 0x00000010:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_FSGNJ_S_frd_frs1_frs2_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_FSGNJN_S_frd_frs1_frs2_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_FSGNJX_S_frd_frs1_frs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000011:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_FSGNJ_D_frd_frs1_frs2_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_FSGNJN_D_frd_frs1_frs2_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_FSGNJX_D_frd_frs1_frs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000014:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_FMIN_S_frd_frs1_frs2_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_FMAX_S_frd_frs1_frs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000015:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_FMIN_D_frd_frs1_frs2_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_FMAX_D_frd_frs1_frs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000020:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000001:
        return Opcode_lvx_v1_FCVT_S_D_frd_frs1_frm_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000021:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000000:
        return Opcode_lvx_v1_FCVT_D_S_frd_frs1_frm_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x0000002c:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000000:
        return Opcode_lvx_v1_FSQRT_S_frd_frs1_frm_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x0000002d:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000000:
        return Opcode_lvx_v1_FSQRT_D_frd_frs1_frm_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000050:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_FLE_S_rd_frs1_frs2_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_FLT_S_rd_frs1_frs2_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_FEQ_S_rd_frs1_frs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000051:
      switch ((codeWord_0 >> 12) & 0x00000007) {
      case 0x00000000:
        return Opcode_lvx_v1_FLE_D_rd_frs1_frs2_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_FLT_D_rd_frs1_frs2_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_FEQ_D_rd_frs1_frs2_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000060:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000000:
        return Opcode_lvx_v1_FCVT_W_S_rd_frs1_frm_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_FCVT_WU_S_rd_frs1_frm_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_FCVT_L_S_rd_frs1_frm_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_FCVT_LU_S_rd_frs1_frm_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000061:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000000:
        return Opcode_lvx_v1_FCVT_W_D_rd_frs1_frm_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_FCVT_WU_D_rd_frs1_frm_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_FCVT_L_D_rd_frs1_frm_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_FCVT_LU_D_rd_frs1_frm_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000068:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000000:
        return Opcode_lvx_v1_FCVT_S_W_frd_rs1_frm_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_FCVT_S_WU_frd_rs1_frm_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_FCVT_S_L_frd_rs1_frm_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_FCVT_S_LU_frd_rs1_frm_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000069:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000000:
        return Opcode_lvx_v1_FCVT_D_W_frd_rs1_frm_riscv;
      case 0x00000001:
        return Opcode_lvx_v1_FCVT_D_WU_frd_rs1_frm_riscv;
      case 0x00000002:
        return Opcode_lvx_v1_FCVT_D_L_frd_rs1_frm_riscv;
      case 0x00000003:
        return Opcode_lvx_v1_FCVT_D_LU_frd_rs1_frm_riscv;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000070:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000000:
        switch ((codeWord_0 >> 12) & 0x00000007) {
        case 0x00000000:
          return Opcode_lvx_v1_FMV_X_W_rd_frs1_riscv;
        case 0x00000001:
          return Opcode_lvx_v1_FCLASS_S_rd_frs1_riscv;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000071:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000000:
        switch ((codeWord_0 >> 12) & 0x00000007) {
        case 0x00000000:
          return Opcode_lvx_v1_FMV_X_D_rd_frs1_riscv;
        case 0x00000001:
          return Opcode_lvx_v1_FCLASS_D_rd_frs1_riscv;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000078:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000000:
        switch ((codeWord_0 >> 12) & 0x00000007) {
        case 0x00000000:
          return Opcode_lvx_v1_FMV_W_X_frd_rs1_riscv;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000079:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000000:
        switch ((codeWord_0 >> 12) & 0x00000007) {
        case 0x00000000:
          return Opcode_lvx_v1_FMV_D_X_frd_rs1_riscv;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000063:
    switch ((codeWord_0 >> 12) & 0x00000007) {
    case 0x00000000:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000000:
        return Opcode_lvx_v1_BEQZ_rs1_i_12_i_11b_i_10_5_i_4_1_riscv;
      default:
        return Opcode_lvx_v1_BEQ_rs1_rs2_i_12_i_11b_i_10_5_i_4_1_riscv;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 20) & 0x0000001f) {
      case 0x00000000:
        return Opcode_lvx_v1_BNEZ_rs1_i_12_i_11b_i_10_5_i_4_1_riscv;
      default:
        return Opcode_lvx_v1_BNE_rs1_rs2_i_12_i_11b_i_10_5_i_4_1_riscv;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000004:
      switch ((codeWord_0 >> 15) & 0x0000001f) {
      case 0x00000000:
        return Opcode_lvx_v1_BGTZ_rs2_i_12_i_11b_i_10_5_i_4_1_riscv;
      default:
        switch ((codeWord_0 >> 20) & 0x0000001f) {
        case 0x00000000:
          return Opcode_lvx_v1_BLTZ_rs1_i_12_i_11b_i_10_5_i_4_1_riscv;
        default:
          return Opcode_lvx_v1_BLT_rs1_rs2_i_12_i_11b_i_10_5_i_4_1_riscv;
          break;
        }
        return Opcode__UNDEF;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000005:
      switch ((codeWord_0 >> 15) & 0x0000001f) {
      case 0x00000000:
        return Opcode_lvx_v1_BLEZ_rs2_i_12_i_11b_i_10_5_i_4_1_riscv;
      default:
        switch ((codeWord_0 >> 20) & 0x0000001f) {
        case 0x00000000:
          return Opcode_lvx_v1_BGEZ_rs1_i_12_i_11b_i_10_5_i_4_1_riscv;
        default:
          return Opcode_lvx_v1_BGE_rs1_rs2_i_12_i_11b_i_10_5_i_4_1_riscv;
          break;
        }
        return Opcode__UNDEF;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000006:
      return Opcode_lvx_v1_BLTU_rs1_rs2_i_12_i_11b_i_10_5_i_4_1_riscv;
    case 0x00000007:
      return Opcode_lvx_v1_BGEU_rs1_rs2_i_12_i_11b_i_10_5_i_4_1_riscv;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000067:
    switch ((codeWord_0 >> 12) & 0x00000007) {
    case 0x00000000:
      switch ((codeWord_0 >> 20) & 0x00000fff) {
      case 0x00000000:
        switch ((codeWord_0 >> 7) & 0x0000001f) {
        case 0x00000000:
          return Opcode_lvx_v1_JR_rs1_riscv;
        default:
          return Opcode_lvx_v1_JALR_rd_rs1_i_11_0_riscv;
          break;
        }
        return Opcode__UNDEF;
      default:
        return Opcode_lvx_v1_JALR_rd_rs1_i_11_0_riscv;
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000006f:
    switch ((codeWord_0 >> 7) & 0x0000001f) {
    case 0x00000000:
      return Opcode_lvx_v1_J_i_20_i_19_12_i_11j_i_10_1_riscv;
    default:
      return Opcode_lvx_v1_JAL_rd_i_20_i_19_12_i_11j_i_10_1_riscv;
      break;
    }
    return Opcode__UNDEF;
  case 0x00000073:
    switch ((codeWord_0 >> 12) & 0x00000007) {
    case 0x00000000:
      switch ((codeWord_0 >> 15) & 0x0001ffff) {
      case 0x00000000:
        switch ((codeWord_0 >> 7) & 0x0000001f) {
        case 0x00000000:
          return Opcode_lvx_v1_ECALL_riscv;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000020:
        switch ((codeWord_0 >> 7) & 0x0000001f) {
        case 0x00000000:
          return Opcode_lvx_v1_EBREAK_riscv;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 7) & 0x0000001f) {
      case 0x00000000:
        return Opcode_lvx_v1_CSRW_csr_rs1_riscv;
      default:
        return Opcode_lvx_v1_CSRRW_rd_csr_rs1_riscv;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000002:
      switch ((codeWord_0 >> 15) & 0x0000001f) {
      case 0x00000000:
        return Opcode_lvx_v1_CSRR_rd_csr_riscv;
      default:
        return Opcode_lvx_v1_CSRRS_rd_csr_rs1_riscv;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000003:
      return Opcode_lvx_v1_CSRRC_rd_csr_rs1_riscv;
    case 0x00000005:
      return Opcode_lvx_v1_CSRRWI_rd_csr_uimm_riscv;
    case 0x00000006:
      return Opcode_lvx_v1_CSRRSI_rd_csr_uimm_riscv;
    case 0x00000007:
      return Opcode_lvx_v1_CSRRCI_rd_csr_uimm_riscv;
    default:
      break;
    }
    return Opcode__UNDEF;
  default:
    break;
  }
  return Opcode__UNDEF;
}
#endif//NDECODE

#ifdef $XCC__h
#ifndef NDECODE
extern Opcode
Decode_Decoding_lvx_v1_simple(const void *buffer);
#endif//NDECODE
#endif//$XCC__h

#ifndef NDECODE
Opcode
Decode_Decoding_lvx_v1_simple(const void *buffer)
{
  const uint32_t *codeWords = (const uint32_t *)buffer;
  uint32_t codeWord_0 = codeWords[0];
  switch ((codeWord_0 >> 28) & 0x00000007) {
  case 0x00000000:
    switch ((codeWord_0 >> 27) & 0x00000001) {
    case 0x00000000:
      switch ((codeWord_0 >> 0) & 0x07ffffff) {
      case 0x00000000:
        return Opcode_lvx_v1_ERROP_simple;
      default:
        return Opcode_lvx_v1_CCB_ccbcomp_registerZ_registerY_pcrel11s2_simple;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 23) & 0x0000000f) {
      case 0x0000000e:
        return Opcode_lvx_v1_LOOPDO_registerZ_pcrel17s2_simple;
      case 0x0000000f:
        switch ((codeWord_0 >> 18) & 0x0000001f) {
        case 0x00000000:
          return Opcode_lvx_v1_GUARD_execpred_registerZ_activate_simple;
        case 0x00000001:
          return Opcode_lvx_v1_BLEND_lanetodo_lanesize_registerZ_activate_simple;
        case 0x00000002:
          return Opcode_lvx_v1_TLBREAD_simple;
        case 0x00000003:
          return Opcode_lvx_v1_TLBPROBE_simple;
        case 0x00000004:
          return Opcode_lvx_v1_TLBWRITE_simple;
        case 0x00000006:
          return Opcode_lvx_v1_TLBDINVAL_simple;
        case 0x00000007:
          return Opcode_lvx_v1_TLBIINVAL_simple;
        case 0x00000008:
          return Opcode_lvx_v1_AWAIT_simple;
        case 0x00000009:
          return Opcode_lvx_v1_SLEEP_simple;
        case 0x0000000a:
          return Opcode_lvx_v1_STOP_simple;
        case 0x0000000b:
          return Opcode_lvx_v1_BARRIER_simple;
        case 0x0000000c:
          return Opcode_lvx_v1_WAITIT_registerZ_simple;
        case 0x0000000d:
          return Opcode_lvx_v1_SYNCGROUP_registerZ_simple;
        case 0x0000000e:
          return Opcode_lvx_v1_WFXL_systemT2_registerZ_simple;
        case 0x0000000f:
          return Opcode_lvx_v1_WFXM_systemT2_registerZ_simple;
        case 0x00000010:
          return Opcode_lvx_v1_SET_systemT3_registerZ_simple;
        case 0x00000011:
          return Opcode_lvx_v1_GET_registerZ_systemS2_simple;
        case 0x00000012:
          return Opcode_lvx_v1_RSWAP_registerZ_systemS4_simple;
        case 0x00000013:
          return Opcode_lvx_v1_IGET_registerZ_simple;
        case 0x00000014:
          return Opcode_lvx_v1_RET_simple;
        case 0x00000015:
          return Opcode_lvx_v1_RFE_simple;
        case 0x00000016:
          return Opcode_lvx_v1_IGOTO_registerZ_simple;
        case 0x00000017:
          return Opcode_lvx_v1_ICALL_registerZ_simple;
        case 0x00000018:
          return Opcode_lvx_v1_SCALL_sysnumber_simple;
        case 0x00000019:
          return Opcode_lvx_v1_SCALL_registerZ_simple;
        case 0x0000001a:
          return Opcode_lvx_v1_BREAK_brknumber_simple;
        default:
          return Opcode_lvx_v1_CB_bcucond_registerZ_pcrel17s2_simple;
          break;
        }
        return Opcode__UNDEF;
      default:
        return Opcode_lvx_v1_CB_bcucond_registerZ_pcrel17s2_simple;
        break;
      }
      return Opcode__UNDEF;
      break;
    }
    return Opcode__UNDEF;
  case 0x00000001:
    switch ((codeWord_0 >> 27) & 0x00000001) {
    case 0x00000000:
      return Opcode_lvx_v1_GOTO_pcrel27s2_simple;
    case 0x00000001:
      return Opcode_lvx_v1_CALL_pcrel27s2_simple;
      break;
    }
    return Opcode__UNDEF;
  case 0x00000002:
    switch ((codeWord_0 >> 16) & 0x00000003) {
    case 0x00000000:
      switch ((codeWord_0 >> 26) & 0x00000003) {
      case 0x00000000:
        return Opcode_lvx_v1_LBZ_variant_registerW_signed10_registerZ_simple;
      case 0x00000001:
        return Opcode_lvx_v1_LBS_variant_registerW_signed10_registerZ_simple;
      case 0x00000002:
        return Opcode_lvx_v1_LHZ_variant_registerW_signed10_registerZ_simple;
      case 0x00000003:
        return Opcode_lvx_v1_LHS_variant_registerW_signed10_registerZ_simple;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 26) & 0x00000003) {
      case 0x00000000:
        return Opcode_lvx_v1_XLO_variant_registerG_signed10_registerZ_simple;
      case 0x00000002:
        return Opcode_lvx_v1_XLO_variant_qindex_registerGq_signed10_registerZ_simple;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000002:
      switch ((codeWord_0 >> 13) & 0x00000007) {
      case 0x00000007:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LBZ_variant_registerW_registerY_registerZ_simple;
        case 0x00000001:
          return Opcode_lvx_v1_LBS_variant_registerW_registerY_registerZ_simple;
        case 0x00000002:
          return Opcode_lvx_v1_LHZ_variant_registerW_registerY_registerZ_simple;
        case 0x00000003:
          return Opcode_lvx_v1_LHS_variant_registerW_registerY_registerZ_simple;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000003:
      switch ((codeWord_0 >> 13) & 0x00000007) {
      case 0x00000000:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_XPLB_variant_registerGg_registerY_registerZ_simple;
          case 0x00000001:
            switch ((codeWord_0 >> 19) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLB_variant_registerGh_registerY_registerZ_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 20) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLB_variant_registerGi_registerY_registerZ_simple;
              case 0x00000001:
                switch ((codeWord_0 >> 21) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLB_variant_registerGj_registerY_registerZ_simple;
                case 0x00000001:
                  switch ((codeWord_0 >> 22) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLB_variant_registerGk_registerY_registerZ_simple;
                  case 0x00000001:
                    return Opcode_lvx_v1_XPLB_variant_registerGl_registerY_registerZ_simple;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_XPLH_variant_registerGg_registerY_registerZ_simple;
          case 0x00000001:
            switch ((codeWord_0 >> 19) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLH_variant_registerGh_registerY_registerZ_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 20) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLH_variant_registerGi_registerY_registerZ_simple;
              case 0x00000001:
                switch ((codeWord_0 >> 21) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLH_variant_registerGj_registerY_registerZ_simple;
                case 0x00000001:
                  switch ((codeWord_0 >> 22) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLH_variant_registerGk_registerY_registerZ_simple;
                  case 0x00000001:
                    return Opcode_lvx_v1_XPLH_variant_registerGl_registerY_registerZ_simple;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_XPLW_variant_registerGg_registerY_registerZ_simple;
          case 0x00000001:
            switch ((codeWord_0 >> 19) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLW_variant_registerGh_registerY_registerZ_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 20) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLW_variant_registerGi_registerY_registerZ_simple;
              case 0x00000001:
                switch ((codeWord_0 >> 21) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLW_variant_registerGj_registerY_registerZ_simple;
                case 0x00000001:
                  switch ((codeWord_0 >> 22) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLW_variant_registerGk_registerY_registerZ_simple;
                  case 0x00000001:
                    return Opcode_lvx_v1_XPLW_variant_registerGl_registerY_registerZ_simple;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_XPLD_variant_registerGg_registerY_registerZ_simple;
          case 0x00000001:
            switch ((codeWord_0 >> 19) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLD_variant_registerGh_registerY_registerZ_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 20) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLD_variant_registerGi_registerY_registerZ_simple;
              case 0x00000001:
                switch ((codeWord_0 >> 21) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLD_variant_registerGj_registerY_registerZ_simple;
                case 0x00000001:
                  switch ((codeWord_0 >> 22) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLD_variant_registerGk_registerY_registerZ_simple;
                  case 0x00000001:
                    return Opcode_lvx_v1_XPLD_variant_registerGl_registerY_registerZ_simple;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000004:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_XPLQ_variant_registerGg_registerY_registerZ_simple;
          case 0x00000001:
            switch ((codeWord_0 >> 19) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLQ_variant_registerGh_registerY_registerZ_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 20) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLQ_variant_registerGi_registerY_registerZ_simple;
              case 0x00000001:
                switch ((codeWord_0 >> 21) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLQ_variant_registerGj_registerY_registerZ_simple;
                case 0x00000001:
                  switch ((codeWord_0 >> 22) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLQ_variant_registerGk_registerY_registerZ_simple;
                  case 0x00000001:
                    return Opcode_lvx_v1_XPLQ_variant_registerGl_registerY_registerZ_simple;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000005:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_XPLO_variant_registerGg_registerY_registerZ_simple;
          case 0x00000001:
            switch ((codeWord_0 >> 19) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLO_variant_registerGh_registerY_registerZ_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 20) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLO_variant_registerGi_registerY_registerZ_simple;
              case 0x00000001:
                switch ((codeWord_0 >> 21) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLO_variant_registerGj_registerY_registerZ_simple;
                case 0x00000001:
                  switch ((codeWord_0 >> 22) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLO_variant_registerGk_registerY_registerZ_simple;
                  case 0x00000001:
                    return Opcode_lvx_v1_XPLO_variant_registerGl_registerY_registerZ_simple;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000007:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_XLO_variant_registerG_registerY_registerZ_simple;
        case 0x00000002:
          return Opcode_lvx_v1_XLO_variant_qindex_registerGq_registerY_registerZ_simple;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
      break;
    }
    return Opcode__UNDEF;
  case 0x00000003:
    switch ((codeWord_0 >> 16) & 0x00000003) {
    case 0x00000000:
      switch ((codeWord_0 >> 26) & 0x00000003) {
      case 0x00000000:
        return Opcode_lvx_v1_LWZ_variant_registerW_signed10_registerZ_simple;
      case 0x00000001:
        return Opcode_lvx_v1_LWS_variant_registerW_signed10_registerZ_simple;
      case 0x00000002:
        return Opcode_lvx_v1_LD_variant_registerW_signed10_registerZ_simple;
      case 0x00000003:
        switch ((codeWord_0 >> 18) & 0x00000001) {
        case 0x00000000:
          return Opcode_lvx_v1_LQ_variant_registerM_signed10_registerZ_simple;
        case 0x00000001:
          switch ((codeWord_0 >> 19) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_LO_variant_registerN_signed10_registerZ_simple;
          case 0x00000001:
            switch ((codeWord_0 >> 20) & 0x0000000f) {
            case 0x00000000:
              switch ((codeWord_0 >> 24) & 0x00000003) {
              case 0x00000000:
                return Opcode_lvx_v1_DTOUCHL_signed10_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 24) & 0x00000003) {
              case 0x00000000:
                return Opcode_lvx_v1_DINVALL_signed10_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000002:
              switch ((codeWord_0 >> 24) & 0x00000003) {
              case 0x00000000:
                return Opcode_lvx_v1_DPURGEL_signed10_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000003:
              switch ((codeWord_0 >> 24) & 0x00000003) {
              case 0x00000000:
                return Opcode_lvx_v1_DFLUSHL_signed10_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000005:
              switch ((codeWord_0 >> 24) & 0x00000003) {
              case 0x00000000:
                return Opcode_lvx_v1_I1INVALS_signed10_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000008:
              switch ((codeWord_0 >> 24) & 0x00000003) {
              case 0x00000000:
                return Opcode_lvx_v1_D1INVAL_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x0000000c:
              switch ((codeWord_0 >> 24) & 0x00000003) {
              case 0x00000000:
                return Opcode_lvx_v1_I1INVAL_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x0000000f:
              return Opcode_lvx_v1_FENCE_accesses_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 24) & 0x0000000f) {
      case 0x00000000:
        return Opcode_lvx_v1_SB_signed10_registerZ_registerT_simple;
      case 0x00000001:
        return Opcode_lvx_v1_SH_signed10_registerZ_registerT_simple;
      case 0x00000002:
        return Opcode_lvx_v1_SW_signed10_registerZ_registerT_simple;
      case 0x00000003:
        return Opcode_lvx_v1_SD_signed10_registerZ_registerT_simple;
      case 0x00000004:
        switch ((codeWord_0 >> 18) & 0x00000001) {
        case 0x00000000:
          return Opcode_lvx_v1_SQ_signed10_registerZ_registerU_simple;
        case 0x00000001:
          switch ((codeWord_0 >> 19) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_SO_signed10_registerZ_registerV_simple;
          case 0x00000001:
            return Opcode_lvx_v1_COPYO_registerN_registerR_simple;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000005:
        return Opcode_lvx_v1_XSO_signed10_registerZ_registerE_simple;
      case 0x00000007:
        return Opcode_lvx_v1_XSO_qindex_signed10_registerZ_registerEq_simple;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000002:
      switch ((codeWord_0 >> 13) & 0x00000007) {
      case 0x00000007:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LWZ_variant_registerW_registerY_registerZ_simple;
        case 0x00000001:
          return Opcode_lvx_v1_LWS_variant_registerW_registerY_registerZ_simple;
        case 0x00000002:
          return Opcode_lvx_v1_LD_variant_registerW_registerY_registerZ_simple;
        case 0x00000003:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_LQ_variant_registerM_registerY_registerZ_simple;
          case 0x00000001:
            switch ((codeWord_0 >> 19) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_LO_variant_registerN_registerY_registerZ_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 20) & 0x0000000f) {
              case 0x00000000:
                switch ((codeWord_0 >> 24) & 0x00000003) {
                case 0x00000000:
                  return Opcode_lvx_v1_DTOUCHL_registerY_registerZ_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000001:
                switch ((codeWord_0 >> 24) & 0x00000003) {
                case 0x00000000:
                  return Opcode_lvx_v1_DINVALL_registerY_registerZ_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000002:
                switch ((codeWord_0 >> 24) & 0x00000003) {
                case 0x00000000:
                  return Opcode_lvx_v1_DPURGEL_registerY_registerZ_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000003:
                switch ((codeWord_0 >> 24) & 0x00000003) {
                case 0x00000000:
                  return Opcode_lvx_v1_DFLUSHL_registerY_registerZ_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000005:
                switch ((codeWord_0 >> 24) & 0x00000003) {
                case 0x00000000:
                  return Opcode_lvx_v1_I1INVALS_registerY_registerZ_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000009:
                return Opcode_lvx_v1_DINVALSW_cachelev_registerY_registerZ_simple;
              case 0x0000000a:
                return Opcode_lvx_v1_DPURGESW_cachelev_registerY_registerZ_simple;
              case 0x0000000b:
                return Opcode_lvx_v1_DFLUSHSW_cachelev_registerY_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000003:
      switch ((codeWord_0 >> 13) & 0x00000007) {
      case 0x00000000:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_0 >> 6) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 7) & 0x0000001f) {
            case 0x00000000:
              return Opcode_lvx_v1_ALB_coherency_registerW_registerZ_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ALCLRB_coherency_registerW_registerZ_simple;
            case 0x00000002:
              return Opcode_lvx_v1_ASWAPB_coherency_registerZ_registerT_simple;
            case 0x00000004:
              return Opcode_lvx_v1_ALADDB_coherency_registerZ_registerT_simple;
            case 0x00000005:
              return Opcode_lvx_v1_ALANDB_coherency_registerZ_registerT_simple;
            case 0x00000006:
              return Opcode_lvx_v1_ALIORB_coherency_registerZ_registerT_simple;
            case 0x00000007:
              return Opcode_lvx_v1_ALEORB_coherency_registerZ_registerT_simple;
            case 0x00000008:
              return Opcode_lvx_v1_ALMINB_coherency_registerZ_registerT_simple;
            case 0x00000009:
              return Opcode_lvx_v1_ALMAXB_coherency_registerZ_registerT_simple;
            case 0x0000000a:
              return Opcode_lvx_v1_ALMINUB_coherency_registerZ_registerT_simple;
            case 0x0000000b:
              return Opcode_lvx_v1_ALMAXUB_coherency_registerZ_registerT_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_ALDUSB_coherency_registerZ_registerT_simple;
            case 0x00000010:
              return Opcode_lvx_v1_ASB_coherency_registerZ_registerT_simple;
            case 0x00000014:
              return Opcode_lvx_v1_ASADDB_coherency_registerZ_registerT_simple;
            case 0x00000015:
              return Opcode_lvx_v1_ASANDB_coherency_registerZ_registerT_simple;
            case 0x00000016:
              return Opcode_lvx_v1_ASIORB_coherency_registerZ_registerT_simple;
            case 0x00000017:
              return Opcode_lvx_v1_ASEORB_coherency_registerZ_registerT_simple;
            case 0x00000018:
              return Opcode_lvx_v1_ASMINB_coherency_registerZ_registerT_simple;
            case 0x00000019:
              return Opcode_lvx_v1_ASMAXB_coherency_registerZ_registerT_simple;
            case 0x0000001a:
              return Opcode_lvx_v1_ASMINUB_coherency_registerZ_registerT_simple;
            case 0x0000001b:
              return Opcode_lvx_v1_ASMAXUB_coherency_registerZ_registerT_simple;
            case 0x0000001e:
              return Opcode_lvx_v1_ASDUSB_coherency_registerZ_registerT_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            return Opcode_lvx_v1_ACSWAPB_boolcas_coherency_registerW_registerZ_registerO_simple;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_0 >> 6) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 7) & 0x0000001f) {
            case 0x00000000:
              return Opcode_lvx_v1_ALH_coherency_registerW_registerZ_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ALCLRH_coherency_registerW_registerZ_simple;
            case 0x00000002:
              return Opcode_lvx_v1_ASWAPH_coherency_registerZ_registerT_simple;
            case 0x00000004:
              return Opcode_lvx_v1_ALADDH_coherency_registerZ_registerT_simple;
            case 0x00000005:
              return Opcode_lvx_v1_ALANDH_coherency_registerZ_registerT_simple;
            case 0x00000006:
              return Opcode_lvx_v1_ALIORH_coherency_registerZ_registerT_simple;
            case 0x00000007:
              return Opcode_lvx_v1_ALEORH_coherency_registerZ_registerT_simple;
            case 0x00000008:
              return Opcode_lvx_v1_ALMINH_coherency_registerZ_registerT_simple;
            case 0x00000009:
              return Opcode_lvx_v1_ALMAXH_coherency_registerZ_registerT_simple;
            case 0x0000000a:
              return Opcode_lvx_v1_ALMINUH_coherency_registerZ_registerT_simple;
            case 0x0000000b:
              return Opcode_lvx_v1_ALMAXUH_coherency_registerZ_registerT_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_ALDUSH_coherency_registerZ_registerT_simple;
            case 0x00000010:
              return Opcode_lvx_v1_ASH_coherency_registerZ_registerT_simple;
            case 0x00000014:
              return Opcode_lvx_v1_ASADDH_coherency_registerZ_registerT_simple;
            case 0x00000015:
              return Opcode_lvx_v1_ASANDH_coherency_registerZ_registerT_simple;
            case 0x00000016:
              return Opcode_lvx_v1_ASIORH_coherency_registerZ_registerT_simple;
            case 0x00000017:
              return Opcode_lvx_v1_ASEORH_coherency_registerZ_registerT_simple;
            case 0x00000018:
              return Opcode_lvx_v1_ASMINH_coherency_registerZ_registerT_simple;
            case 0x00000019:
              return Opcode_lvx_v1_ASMAXH_coherency_registerZ_registerT_simple;
            case 0x0000001a:
              return Opcode_lvx_v1_ASMINUH_coherency_registerZ_registerT_simple;
            case 0x0000001b:
              return Opcode_lvx_v1_ASMAXUH_coherency_registerZ_registerT_simple;
            case 0x0000001e:
              return Opcode_lvx_v1_ASDUSH_coherency_registerZ_registerT_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            return Opcode_lvx_v1_ACSWAPH_boolcas_coherency_registerW_registerZ_registerO_simple;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_0 >> 6) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 7) & 0x0000001f) {
            case 0x00000000:
              return Opcode_lvx_v1_ALW_coherency_registerW_registerZ_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ALCLRW_coherency_registerW_registerZ_simple;
            case 0x00000002:
              return Opcode_lvx_v1_ASWAPW_coherency_registerZ_registerT_simple;
            case 0x00000004:
              return Opcode_lvx_v1_ALADDW_coherency_registerZ_registerT_simple;
            case 0x00000005:
              return Opcode_lvx_v1_ALANDW_coherency_registerZ_registerT_simple;
            case 0x00000006:
              return Opcode_lvx_v1_ALIORW_coherency_registerZ_registerT_simple;
            case 0x00000007:
              return Opcode_lvx_v1_ALEORW_coherency_registerZ_registerT_simple;
            case 0x00000008:
              return Opcode_lvx_v1_ALMINW_coherency_registerZ_registerT_simple;
            case 0x00000009:
              return Opcode_lvx_v1_ALMAXW_coherency_registerZ_registerT_simple;
            case 0x0000000a:
              return Opcode_lvx_v1_ALMINUW_coherency_registerZ_registerT_simple;
            case 0x0000000b:
              return Opcode_lvx_v1_ALMAXUW_coherency_registerZ_registerT_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_ALDUSW_coherency_registerZ_registerT_simple;
            case 0x00000010:
              return Opcode_lvx_v1_ASW_coherency_registerZ_registerT_simple;
            case 0x00000014:
              return Opcode_lvx_v1_ASADDW_coherency_registerZ_registerT_simple;
            case 0x00000015:
              return Opcode_lvx_v1_ASANDW_coherency_registerZ_registerT_simple;
            case 0x00000016:
              return Opcode_lvx_v1_ASIORW_coherency_registerZ_registerT_simple;
            case 0x00000017:
              return Opcode_lvx_v1_ASEORW_coherency_registerZ_registerT_simple;
            case 0x00000018:
              return Opcode_lvx_v1_ASMINW_coherency_registerZ_registerT_simple;
            case 0x00000019:
              return Opcode_lvx_v1_ASMAXW_coherency_registerZ_registerT_simple;
            case 0x0000001a:
              return Opcode_lvx_v1_ASMINUW_coherency_registerZ_registerT_simple;
            case 0x0000001b:
              return Opcode_lvx_v1_ASMAXUW_coherency_registerZ_registerT_simple;
            case 0x0000001e:
              return Opcode_lvx_v1_ASDUSW_coherency_registerZ_registerT_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            return Opcode_lvx_v1_ACSWAPW_boolcas_coherency_registerW_registerZ_registerO_simple;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_0 >> 6) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 7) & 0x0000001f) {
            case 0x00000000:
              return Opcode_lvx_v1_ALD_coherency_registerW_registerZ_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ALCLRD_coherency_registerW_registerZ_simple;
            case 0x00000002:
              return Opcode_lvx_v1_ASWAPD_coherency_registerZ_registerT_simple;
            case 0x00000004:
              return Opcode_lvx_v1_ALADDD_coherency_registerZ_registerT_simple;
            case 0x00000005:
              return Opcode_lvx_v1_ALANDD_coherency_registerZ_registerT_simple;
            case 0x00000006:
              return Opcode_lvx_v1_ALIORD_coherency_registerZ_registerT_simple;
            case 0x00000007:
              return Opcode_lvx_v1_ALEORD_coherency_registerZ_registerT_simple;
            case 0x00000008:
              return Opcode_lvx_v1_ALMIND_coherency_registerZ_registerT_simple;
            case 0x00000009:
              return Opcode_lvx_v1_ALMAXD_coherency_registerZ_registerT_simple;
            case 0x0000000a:
              return Opcode_lvx_v1_ALMINUD_coherency_registerZ_registerT_simple;
            case 0x0000000b:
              return Opcode_lvx_v1_ALMAXUD_coherency_registerZ_registerT_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_ALDUSD_coherency_registerZ_registerT_simple;
            case 0x00000010:
              return Opcode_lvx_v1_ASD_coherency_registerZ_registerT_simple;
            case 0x00000014:
              return Opcode_lvx_v1_ASADDD_coherency_registerZ_registerT_simple;
            case 0x00000015:
              return Opcode_lvx_v1_ASANDD_coherency_registerZ_registerT_simple;
            case 0x00000016:
              return Opcode_lvx_v1_ASIORD_coherency_registerZ_registerT_simple;
            case 0x00000017:
              return Opcode_lvx_v1_ASEORD_coherency_registerZ_registerT_simple;
            case 0x00000018:
              return Opcode_lvx_v1_ASMIND_coherency_registerZ_registerT_simple;
            case 0x00000019:
              return Opcode_lvx_v1_ASMAXD_coherency_registerZ_registerT_simple;
            case 0x0000001a:
              return Opcode_lvx_v1_ASMINUD_coherency_registerZ_registerT_simple;
            case 0x0000001b:
              return Opcode_lvx_v1_ASMAXUD_coherency_registerZ_registerT_simple;
            case 0x0000001e:
              return Opcode_lvx_v1_ASDUSD_coherency_registerZ_registerT_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            return Opcode_lvx_v1_ACSWAPD_boolcas_coherency_registerW_registerZ_registerO_simple;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000004:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000003:
          switch ((codeWord_0 >> 6) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ACSWAPQ_boolcas_coherency_registerM_registerZ_registerQ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000007:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          return Opcode_lvx_v1_SB_registerY_registerZ_registerT_simple;
        case 0x00000001:
          return Opcode_lvx_v1_SH_registerY_registerZ_registerT_simple;
        case 0x00000002:
          return Opcode_lvx_v1_SW_registerY_registerZ_registerT_simple;
        case 0x00000003:
          return Opcode_lvx_v1_SD_registerY_registerZ_registerT_simple;
        case 0x00000004:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_SQ_registerY_registerZ_registerU_simple;
          case 0x00000001:
            switch ((codeWord_0 >> 19) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SO_registerY_registerZ_registerV_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000005:
          return Opcode_lvx_v1_XSO_registerY_registerZ_registerE_simple;
        case 0x00000007:
          return Opcode_lvx_v1_XSO_qindex_registerY_registerZ_registerEq_simple;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
      break;
    }
    return Opcode__UNDEF;
  case 0x00000004:
    switch ((codeWord_0 >> 14) & 0x0000000f) {
    case 0x00000000:
      switch ((codeWord_0 >> 24) & 0x0000000f) {
      case 0x00000000:
        switch ((codeWord_0 >> 13) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000001:
            return Opcode_lvx_v1_XMOVEFQ_registerM_registerCb_hselectC_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_XCOPYO_registerA_registerC_simple;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000002:
      switch ((codeWord_0 >> 24) & 0x0000000f) {
      case 0x00000000:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000003) {
          case 0x00000001:
            return Opcode_lvx_v1_XMOVEFO_registerN_registerC_simple;
          case 0x00000003:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XACCESSO_registerN_registerCg_registerZ_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 7) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XACCESSO_registerN_registerCh_registerZ_simple;
              case 0x00000001:
                switch ((codeWord_0 >> 8) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XACCESSO_registerN_registerCi_registerZ_simple;
                case 0x00000001:
                  switch ((codeWord_0 >> 9) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XACCESSO_registerN_registerCj_registerZ_simple;
                  case 0x00000001:
                    switch ((codeWord_0 >> 10) & 0x00000001) {
                    case 0x00000000:
                      return Opcode_lvx_v1_XACCESSO_registerN_registerCk_registerZ_simple;
                    case 0x00000001:
                      return Opcode_lvx_v1_XACCESSO_registerN_registerCl_registerZ_simple;
                      break;
                    }
                    return Opcode__UNDEF;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 6) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_XALIGNO_registerA_registerCg_registerZ_simple;
          case 0x00000001:
            switch ((codeWord_0 >> 7) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XALIGNO_registerA_registerCh_registerZ_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 8) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XALIGNO_registerA_registerCi_registerZ_simple;
              case 0x00000001:
                switch ((codeWord_0 >> 9) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XALIGNO_registerA_registerCj_registerZ_simple;
                case 0x00000001:
                  switch ((codeWord_0 >> 10) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XALIGNO_registerA_registerCk_registerZ_simple;
                  case 0x00000001:
                    return Opcode_lvx_v1_XALIGNO_registerA_registerCl_registerZ_simple;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000003:
      switch ((codeWord_0 >> 24) & 0x0000000f) {
      case 0x00000000:
        return Opcode_lvx_v1_XMOVEFD_registerW_registerCc_qselectC_simple;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000006:
    switch ((codeWord_0 >> 16) & 0x00000003) {
    case 0x00000000:
      switch ((codeWord_0 >> 24) & 0x0000000f) {
      case 0x00000000:
        return Opcode_lvx_v1_MAKE_registerW_signed16_simple;
      case 0x00000001:
        return Opcode_lvx_v1_PCREL_registerW_signed16_simple;
      case 0x00000002:
        return Opcode_lvx_v1_ADDD_registerW_registerZ_signed10_simple;
      case 0x00000003:
        return Opcode_lvx_v1_SBFD_registerW_registerZ_signed10_simple;
      case 0x00000004:
        return Opcode_lvx_v1_MIND_registerW_registerZ_signed10_simple;
      case 0x00000005:
        return Opcode_lvx_v1_MAXD_registerW_registerZ_signed10_simple;
      case 0x00000006:
        return Opcode_lvx_v1_MINUD_registerW_registerZ_signed10_simple;
      case 0x00000007:
        return Opcode_lvx_v1_MAXUD_registerW_registerZ_signed10_simple;
      case 0x00000008:
        return Opcode_lvx_v1_ANDD_registerW_registerZ_signed10_simple;
      case 0x00000009:
        return Opcode_lvx_v1_NANDD_registerW_registerZ_signed10_simple;
      case 0x0000000a:
        switch ((codeWord_0 >> 6) & 0x000003ff) {
        case 0x00000000:
          return Opcode_lvx_v1_COPYD_registerW_registerZ_simple;
        default:
          return Opcode_lvx_v1_IORD_registerW_registerZ_signed10_simple;
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000b:
        return Opcode_lvx_v1_NIORD_registerW_registerZ_signed10_simple;
      case 0x0000000c:
        return Opcode_lvx_v1_EORD_registerW_registerZ_signed10_simple;
      case 0x0000000d:
        return Opcode_lvx_v1_NEORD_registerW_registerZ_signed10_simple;
      case 0x0000000e:
        return Opcode_lvx_v1_ANDND_registerW_registerZ_signed10_simple;
      case 0x0000000f:
        return Opcode_lvx_v1_IORND_registerW_registerZ_signed10_simple;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 26) & 0x00000003) {
      case 0x00000000:
        return Opcode_lvx_v1_INSF_registerW_registerZ_stopbit2_stopbit4_startbit_simple;
      case 0x00000001:
        switch ((codeWord_0 >> 6) & 0x000003ff) {
        case 0x000001c0:
          switch ((codeWord_0 >> 24) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ZXBD_registerW_registerZ_simple;
          default:
            return Opcode_lvx_v1_EXTFZ_registerW_registerZ_stopbit2_stopbit4_startbit_simple;
            break;
          }
          return Opcode__UNDEF;
        case 0x000003c0:
          switch ((codeWord_0 >> 24) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ZXHD_registerW_registerZ_simple;
          case 0x00000001:
            return Opcode_lvx_v1_ZXWD_registerW_registerZ_simple;
          default:
            return Opcode_lvx_v1_EXTFZ_registerW_registerZ_stopbit2_stopbit4_startbit_simple;
            break;
          }
          return Opcode__UNDEF;
        default:
          return Opcode_lvx_v1_EXTFZ_registerW_registerZ_stopbit2_stopbit4_startbit_simple;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_0 >> 6) & 0x000003ff) {
        case 0x000001c0:
          switch ((codeWord_0 >> 24) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_SXBD_registerW_registerZ_simple;
          default:
            return Opcode_lvx_v1_EXTFS_registerW_registerZ_stopbit2_stopbit4_startbit_simple;
            break;
          }
          return Opcode__UNDEF;
        case 0x000003c0:
          switch ((codeWord_0 >> 24) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_SXHD_registerW_registerZ_simple;
          case 0x00000001:
            return Opcode_lvx_v1_SXWD_registerW_registerZ_simple;
          default:
            return Opcode_lvx_v1_EXTFS_registerW_registerZ_stopbit2_stopbit4_startbit_simple;
            break;
          }
          return Opcode__UNDEF;
        default:
          return Opcode_lvx_v1_EXTFS_registerW_registerZ_stopbit2_stopbit4_startbit_simple;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 24) & 0x00000003) {
        case 0x00000002:
          return Opcode_lvx_v1_SBMM8D_registerW_registerZ_signed10_simple;
        case 0x00000003:
          return Opcode_lvx_v1_SBMMT8D_registerW_registerZ_signed10_simple;
        default:
          break;
        }
        return Opcode__UNDEF;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000002:
      switch ((codeWord_0 >> 12) & 0x0000000f) {
      case 0x00000000:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          return Opcode_lvx_v1_SIGND_registerW_registerZ_registerY_simple;
        case 0x00000001:
          return Opcode_lvx_v1_SIGNSD_registerW_registerZ_registerY_simple;
        case 0x00000002:
          return Opcode_lvx_v1_ADDD_registerW_registerZ_registerY_simple;
        case 0x00000003:
          return Opcode_lvx_v1_SBFD_registerW_registerZ_registerY_simple;
        case 0x00000004:
          return Opcode_lvx_v1_MIND_registerW_registerZ_registerY_simple;
        case 0x00000005:
          return Opcode_lvx_v1_MAXD_registerW_registerZ_registerY_simple;
        case 0x00000006:
          return Opcode_lvx_v1_MINUD_registerW_registerZ_registerY_simple;
        case 0x00000007:
          return Opcode_lvx_v1_MAXUD_registerW_registerZ_registerY_simple;
        case 0x00000008:
          return Opcode_lvx_v1_ANDD_registerW_registerZ_registerY_simple;
        case 0x00000009:
          return Opcode_lvx_v1_NANDD_registerW_registerZ_registerY_simple;
        case 0x0000000a:
          return Opcode_lvx_v1_IORD_registerW_registerZ_registerY_simple;
        case 0x0000000b:
          return Opcode_lvx_v1_NIORD_registerW_registerZ_registerY_simple;
        case 0x0000000c:
          return Opcode_lvx_v1_EORD_registerW_registerZ_registerY_simple;
        case 0x0000000d:
          return Opcode_lvx_v1_NEORD_registerW_registerZ_registerY_simple;
        case 0x0000000e:
          return Opcode_lvx_v1_ANDND_registerW_registerZ_registerY_simple;
        case 0x0000000f:
          return Opcode_lvx_v1_IORND_registerW_registerZ_registerY_simple;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000002:
          return Opcode_lvx_v1_ADDQ_registerM_registerP_registerO_simple;
        case 0x00000003:
          return Opcode_lvx_v1_SBFQ_registerM_registerP_registerO_simple;
        case 0x00000008:
          return Opcode_lvx_v1_ANDQ_registerM_registerP_registerO_simple;
        case 0x00000009:
          return Opcode_lvx_v1_NANDQ_registerM_registerP_registerO_simple;
        case 0x0000000a:
          return Opcode_lvx_v1_IORQ_registerM_registerP_registerO_simple;
        case 0x0000000b:
          return Opcode_lvx_v1_NIORQ_registerM_registerP_registerO_simple;
        case 0x0000000c:
          return Opcode_lvx_v1_EORQ_registerM_registerP_registerO_simple;
        case 0x0000000d:
          return Opcode_lvx_v1_NEORQ_registerM_registerP_registerO_simple;
        case 0x0000000e:
          return Opcode_lvx_v1_ANDNQ_registerM_registerP_registerO_simple;
        case 0x0000000f:
          return Opcode_lvx_v1_IORNQ_registerM_registerP_registerO_simple;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x0000000c:
          return Opcode_lvx_v1_SBMM8EORD_registerW_registerZ_registerY_simple;
        case 0x0000000d:
          return Opcode_lvx_v1_SBMMT8EORD_registerW_registerZ_registerY_simple;
        case 0x0000000e:
          return Opcode_lvx_v1_SBMM8D_registerW_registerZ_registerY_simple;
        case 0x0000000f:
          return Opcode_lvx_v1_SBMMT8D_registerW_registerZ_registerY_simple;
        default:
          return Opcode_lvx_v1_COMPD_intcomp_registerW_registerZ_registerY_simple;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        return Opcode_lvx_v1_COMPQ_intcomp_registerM_registerP_registerO_simple;
      case 0x00000004:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          return Opcode_lvx_v1_LANDD_registerW_registerZ_registerY_simple;
        case 0x00000001:
          return Opcode_lvx_v1_LNANDD_registerW_registerZ_registerY_simple;
        case 0x00000002:
          return Opcode_lvx_v1_LIORD_registerW_registerZ_registerY_simple;
        case 0x00000003:
          return Opcode_lvx_v1_LNIORD_registerW_registerZ_registerY_simple;
        case 0x0000000c:
          return Opcode_lvx_v1_ABDD_registerW_registerZ_registerY_simple;
        case 0x0000000d:
          return Opcode_lvx_v1_ABDUD_registerW_registerZ_registerY_simple;
        case 0x0000000e:
          return Opcode_lvx_v1_ABDSD_registerW_registerZ_registerY_simple;
        case 0x0000000f:
          return Opcode_lvx_v1_STSUD_registerW_registerZ_registerY_simple;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000005:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000008:
          return Opcode_lvx_v1_XMOVETD_registerAx_registerZ_simple;
        case 0x00000009:
          return Opcode_lvx_v1_XMOVETD_registerAy_registerZ_simple;
        case 0x0000000a:
          return Opcode_lvx_v1_XMOVETD_registerAz_registerZ_simple;
        case 0x0000000b:
          return Opcode_lvx_v1_XMOVETD_registerAt_registerZ_simple;
        case 0x0000000c:
          return Opcode_lvx_v1_XMOVETQ_registerAE_registerZ_registerY_simple;
        case 0x0000000d:
          return Opcode_lvx_v1_XMOVETQ_registerAO_registerZ_registerY_simple;
        case 0x0000000e:
          return Opcode_lvx_v1_XMOVETO_registerA_registerP_registerO_simple;
        case 0x0000000f:
          return Opcode_lvx_v1_CATDQ_registerM_registerZ_registerY_simple;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000006:
        return Opcode_lvx_v1_CMOVED_cmovecond_registerZ_registerW_registerY_simple;
      case 0x00000007:
        return Opcode_lvx_v1_CMOVEQ_cmovecond_registerZ_registerM_registerO_simple;
      case 0x00000008:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          return Opcode_lvx_v1_SRSD_registerW_registerZ_registerY_simple;
        case 0x00000001:
          return Opcode_lvx_v1_SLLD_registerW_registerZ_registerY_simple;
        case 0x00000002:
          return Opcode_lvx_v1_SRAD_registerW_registerZ_registerY_simple;
        case 0x00000003:
          return Opcode_lvx_v1_SRLD_registerW_registerZ_registerY_simple;
        case 0x00000004:
          return Opcode_lvx_v1_SLSD_registerW_registerZ_registerY_simple;
        case 0x00000005:
          return Opcode_lvx_v1_SLUSD_registerW_registerZ_registerY_simple;
        case 0x00000006:
          return Opcode_lvx_v1_ROLD_registerW_registerZ_registerY_simple;
        case 0x00000007:
          return Opcode_lvx_v1_RORD_registerW_registerZ_registerY_simple;
        case 0x00000008:
          return Opcode_lvx_v1_SRSD_registerW_registerZ_unsigned6_simple;
        case 0x00000009:
          return Opcode_lvx_v1_SLLD_registerW_registerZ_unsigned6_simple;
        case 0x0000000a:
          return Opcode_lvx_v1_SRAD_registerW_registerZ_unsigned6_simple;
        case 0x0000000b:
          return Opcode_lvx_v1_SRLD_registerW_registerZ_unsigned6_simple;
        case 0x0000000c:
          return Opcode_lvx_v1_SLSD_registerW_registerZ_unsigned6_simple;
        case 0x0000000d:
          return Opcode_lvx_v1_SLUSD_registerW_registerZ_unsigned6_simple;
        case 0x0000000e:
          return Opcode_lvx_v1_ROLD_registerW_registerZ_unsigned6_simple;
        case 0x0000000f:
          return Opcode_lvx_v1_RORD_registerW_registerZ_unsigned6_simple;
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000a:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          return Opcode_lvx_v1_ADDX2D_registerW_registerZ_registerY_simple;
        case 0x00000001:
          return Opcode_lvx_v1_ADDX4D_registerW_registerZ_registerY_simple;
        case 0x00000002:
          return Opcode_lvx_v1_ADDX8D_registerW_registerZ_registerY_simple;
        case 0x00000003:
          return Opcode_lvx_v1_ADDX16D_registerW_registerZ_registerY_simple;
        case 0x00000004:
          return Opcode_lvx_v1_ADDX32D_registerW_registerZ_registerY_simple;
        case 0x00000005:
          return Opcode_lvx_v1_ADDX64D_registerW_registerZ_registerY_simple;
        case 0x00000008:
          return Opcode_lvx_v1_ADDSD_registerW_registerZ_registerY_simple;
        case 0x00000009:
          return Opcode_lvx_v1_SBFSD_registerW_registerZ_registerY_simple;
        case 0x0000000a:
          return Opcode_lvx_v1_ADDUSD_registerW_registerZ_registerY_simple;
        case 0x0000000b:
          return Opcode_lvx_v1_SBFUSD_registerW_registerZ_registerY_simple;
        case 0x0000000c:
          return Opcode_lvx_v1_DIVMODD_registerM_registerZ_registerY_simple;
        case 0x0000000d:
          return Opcode_lvx_v1_DIVMODUD_registerM_registerZ_registerY_simple;
        case 0x0000000f:
          switch ((codeWord_0 >> 6) & 0x0000003f) {
          case 0x00000000:
            return Opcode_lvx_v1_NEGD_registerW_registerZ_simple;
          case 0x00000004:
            return Opcode_lvx_v1_ABSD_registerW_registerZ_simple;
          case 0x00000008:
            return Opcode_lvx_v1_NEGSD_registerW_registerZ_simple;
          case 0x0000000c:
            return Opcode_lvx_v1_ABSSD_registerW_registerZ_simple;
          case 0x00000010:
            return Opcode_lvx_v1_CLZD_registerW_registerZ_simple;
          case 0x00000014:
            return Opcode_lvx_v1_CLSD_registerW_registerZ_simple;
          case 0x00000018:
            return Opcode_lvx_v1_CBSD_registerW_registerZ_simple;
          case 0x0000001c:
            return Opcode_lvx_v1_CTZD_registerW_registerZ_simple;
          case 0x00000020:
            return Opcode_lvx_v1_NOTD_registerW_registerZ_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000b:
        switch ((codeWord_0 >> 6) & 0x0000003f) {
        case 0x00000000:
          switch ((codeWord_0 >> 24) & 0x0000000f) {
          case 0x0000000f:
            return Opcode_lvx_v1_NEGQ_registerM_registerP_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000020:
          switch ((codeWord_0 >> 24) & 0x0000000f) {
          case 0x0000000f:
            return Opcode_lvx_v1_NOTQ_registerM_registerP_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000c:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_MULD_highmult_registerW_registerZ_registerY_simple;
        case 0x00000001:
          return Opcode_lvx_v1_MULND_highmult_registerW_registerZ_registerY_simple;
        case 0x00000002:
          return Opcode_lvx_v1_MADDD_highmult_registerW_registerZ_registerY_simple;
        case 0x00000003:
          return Opcode_lvx_v1_MSBFD_highmult_registerW_registerZ_registerY_simple;
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000e:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 24) & 0x00000003) {
          case 0x00000001:
            return Opcode_lvx_v1_MULUWD_registerW_registerZ_registerY_simple;
          case 0x00000002:
            return Opcode_lvx_v1_MULSUWD_registerW_registerZ_registerY_simple;
          default:
            return Opcode_lvx_v1_MULWD_widemult_registerW_registerZ_registerY_simple;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          return Opcode_lvx_v1_MULNWD_widemult_registerW_registerZ_registerY_simple;
        case 0x00000002:
          switch ((codeWord_0 >> 24) & 0x00000003) {
          case 0x00000001:
            return Opcode_lvx_v1_MADDUWD_registerW_registerZ_registerY_simple;
          case 0x00000002:
            return Opcode_lvx_v1_MADDSUWD_registerW_registerZ_registerY_simple;
          default:
            return Opcode_lvx_v1_MADDWD_widemult_registerW_registerZ_registerY_simple;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 24) & 0x00000003) {
          case 0x00000001:
            return Opcode_lvx_v1_MSBFUWD_registerW_registerZ_registerY_simple;
          case 0x00000002:
            return Opcode_lvx_v1_MSBFSUWD_registerW_registerZ_registerY_simple;
          default:
            return Opcode_lvx_v1_MSBFWD_widemult_registerW_registerZ_registerY_simple;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000f:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 24) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MULDT_registerM_registerZ_registerY_simple;
          case 0x00000001:
            return Opcode_lvx_v1_MULUDT_registerM_registerZ_registerY_simple;
          case 0x00000002:
            return Opcode_lvx_v1_MULSUDT_registerM_registerZ_registerY_simple;
          default:
            return Opcode_lvx_v1_MULDQ_widemult_registerM_registerZ_registerY_simple;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          return Opcode_lvx_v1_MULNDQ_widemult_registerM_registerZ_registerY_simple;
        case 0x00000002:
          switch ((codeWord_0 >> 24) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MADDDT_registerM_registerZ_registerY_simple;
          case 0x00000001:
            return Opcode_lvx_v1_MADDUDT_registerM_registerZ_registerY_simple;
          case 0x00000002:
            return Opcode_lvx_v1_MADDSUDT_registerM_registerZ_registerY_simple;
          default:
            return Opcode_lvx_v1_MADDDQ_widemult_registerM_registerZ_registerY_simple;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 24) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MSBFDT_registerM_registerZ_registerY_simple;
          case 0x00000001:
            return Opcode_lvx_v1_MSBFUDT_registerM_registerZ_registerY_simple;
          case 0x00000002:
            return Opcode_lvx_v1_MSBFSUDT_registerM_registerZ_registerY_simple;
          default:
            return Opcode_lvx_v1_MSBFDQ_widemult_registerM_registerZ_registerY_simple;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000003:
      switch ((codeWord_0 >> 13) & 0x00000007) {
      case 0x00000000:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          return Opcode_lvx_v1_SIGNW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000001:
          return Opcode_lvx_v1_SIGNSW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000002:
          return Opcode_lvx_v1_ADDW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000003:
          return Opcode_lvx_v1_SBFW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000004:
          return Opcode_lvx_v1_MINW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000005:
          return Opcode_lvx_v1_MAXW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000006:
          return Opcode_lvx_v1_MINUW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000007:
          return Opcode_lvx_v1_MAXUW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000008:
          return Opcode_lvx_v1_ANDW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000009:
          return Opcode_lvx_v1_NANDW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000a:
          return Opcode_lvx_v1_IORW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000b:
          return Opcode_lvx_v1_NIORW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000c:
          return Opcode_lvx_v1_EORW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000d:
          return Opcode_lvx_v1_NEORW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000e:
          return Opcode_lvx_v1_ANDNW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000f:
          return Opcode_lvx_v1_IORNW_signextw_registerW_registerZ_registerY_simple;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x0000000c:
          return Opcode_lvx_v1_AVGW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000d:
          return Opcode_lvx_v1_AVGUW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000e:
          return Opcode_lvx_v1_AVGRW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000f:
          return Opcode_lvx_v1_AVGRUW_signextw_registerW_registerZ_registerY_simple;
        default:
          return Opcode_lvx_v1_COMPW_intcomp_signextw_registerW_registerZ_registerY_simple;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          switch ((codeWord_0 >> 12) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_LANDW_registerW_registerZ_registerY_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 12) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_LNANDW_registerW_registerZ_registerY_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 12) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_LIORW_registerW_registerZ_registerY_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 12) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_LNIORW_registerW_registerZ_registerY_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000004:
          switch ((codeWord_0 >> 12) & 0x00000001) {
          case 0x00000001:
            return Opcode_lvx_v1_CRCBELMW_registerW_registerZ_registerY_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000005:
          switch ((codeWord_0 >> 12) & 0x00000001) {
          case 0x00000001:
            return Opcode_lvx_v1_CRCBELLW_registerW_registerZ_registerY_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000006:
          switch ((codeWord_0 >> 12) & 0x00000001) {
          case 0x00000001:
            return Opcode_lvx_v1_CRCLELMW_registerW_registerZ_registerY_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000007:
          switch ((codeWord_0 >> 12) & 0x00000001) {
          case 0x00000001:
            return Opcode_lvx_v1_CRCLELLW_registerW_registerZ_registerY_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000c:
          return Opcode_lvx_v1_ABDW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000d:
          return Opcode_lvx_v1_ABDUW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000e:
          return Opcode_lvx_v1_ABDSW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000f:
          return Opcode_lvx_v1_STSUW_signextw_registerW_registerZ_registerY_simple;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000004:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          return Opcode_lvx_v1_SRSW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000001:
          return Opcode_lvx_v1_SLLW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000002:
          return Opcode_lvx_v1_SRAW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000003:
          return Opcode_lvx_v1_SRLW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000004:
          return Opcode_lvx_v1_SLSW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000005:
          return Opcode_lvx_v1_SLUSW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000006:
          return Opcode_lvx_v1_ROLW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000007:
          return Opcode_lvx_v1_RORW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000008:
          return Opcode_lvx_v1_SRSW_signextw_registerW_registerZ_unsigned6_simple;
        case 0x00000009:
          switch ((codeWord_0 >> 6) & 0x0000003f) {
          case 0x00000000:
            return Opcode_lvx_v1_COPYW_signextw_registerW_registerZ_simple;
          default:
            return Opcode_lvx_v1_SLLW_signextw_registerW_registerZ_unsigned6_simple;
            break;
          }
          return Opcode__UNDEF;
        case 0x0000000a:
          return Opcode_lvx_v1_SRAW_signextw_registerW_registerZ_unsigned6_simple;
        case 0x0000000b:
          return Opcode_lvx_v1_SRLW_signextw_registerW_registerZ_unsigned6_simple;
        case 0x0000000c:
          return Opcode_lvx_v1_SLSW_signextw_registerW_registerZ_unsigned6_simple;
        case 0x0000000d:
          return Opcode_lvx_v1_SLUSW_signextw_registerW_registerZ_unsigned6_simple;
        case 0x0000000e:
          return Opcode_lvx_v1_ROLW_signextw_registerW_registerZ_unsigned6_simple;
        case 0x0000000f:
          return Opcode_lvx_v1_RORW_signextw_registerW_registerZ_unsigned6_simple;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000005:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          return Opcode_lvx_v1_ADDX2W_signextw_registerW_registerZ_registerY_simple;
        case 0x00000001:
          return Opcode_lvx_v1_ADDX4W_signextw_registerW_registerZ_registerY_simple;
        case 0x00000002:
          return Opcode_lvx_v1_ADDX8W_signextw_registerW_registerZ_registerY_simple;
        case 0x00000003:
          return Opcode_lvx_v1_ADDX16W_signextw_registerW_registerZ_registerY_simple;
        case 0x00000004:
          return Opcode_lvx_v1_ADDX32W_signextw_registerW_registerZ_registerY_simple;
        case 0x00000005:
          return Opcode_lvx_v1_ADDX64W_signextw_registerW_registerZ_registerY_simple;
        case 0x00000008:
          return Opcode_lvx_v1_ADDSW_signextw_registerW_registerZ_registerY_simple;
        case 0x00000009:
          return Opcode_lvx_v1_SBFSW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000a:
          return Opcode_lvx_v1_ADDUSW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000b:
          return Opcode_lvx_v1_SBFUSW_signextw_registerW_registerZ_registerY_simple;
        case 0x0000000c:
          return Opcode_lvx_v1_DIVMODW_signextw_registerM_registerZ_registerY_simple;
        case 0x0000000d:
          return Opcode_lvx_v1_DIVMODUW_signextw_registerM_registerZ_registerY_simple;
        case 0x0000000f:
          switch ((codeWord_0 >> 6) & 0x0000003f) {
          case 0x00000000:
            return Opcode_lvx_v1_NEGW_registerW_registerZ_simple;
          case 0x00000004:
            return Opcode_lvx_v1_ABSW_registerW_registerZ_simple;
          case 0x00000008:
            return Opcode_lvx_v1_NEGSW_registerW_registerZ_simple;
          case 0x0000000c:
            return Opcode_lvx_v1_ABSSW_registerW_registerZ_simple;
          case 0x00000010:
            return Opcode_lvx_v1_CLZW_registerW_registerZ_simple;
          case 0x00000014:
            return Opcode_lvx_v1_CLSW_registerW_registerZ_simple;
          case 0x00000018:
            return Opcode_lvx_v1_CBSW_registerW_registerZ_simple;
          case 0x0000001c:
            return Opcode_lvx_v1_CTZW_registerW_registerZ_simple;
          case 0x00000020:
            return Opcode_lvx_v1_NOTW_registerW_registerZ_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000006:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_MULW_highmult_signextw_registerW_registerZ_registerY_simple;
        case 0x00000001:
          return Opcode_lvx_v1_MULNW_highmult_signextw_registerW_registerZ_registerY_simple;
        case 0x00000002:
          return Opcode_lvx_v1_MADDW_highmult_signextw_registerW_registerZ_registerY_simple;
        case 0x00000003:
          return Opcode_lvx_v1_MSBFW_highmult_signextw_registerW_registerZ_registerY_simple;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
      break;
    }
    return Opcode__UNDEF;
  case 0x00000007:
    switch ((codeWord_0 >> 14) & 0x0000000f) {
    case 0x00000000:
      switch ((codeWord_0 >> 12) & 0x00000001) {
      case 0x00000000:
        switch ((codeWord_0 >> 13) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 27) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_FADDD_floatmode_registerW_registerZ_registerY_simple;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x00000007) {
            case 0x00000000:
              return Opcode_lvx_v1_FMIND_registerW_registerZ_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_FMAXD_registerW_registerZ_registerY_simple;
            case 0x00000002:
              return Opcode_lvx_v1_FMINND_registerW_registerZ_registerY_simple;
            case 0x00000003:
              return Opcode_lvx_v1_FMAXND_registerW_registerZ_registerY_simple;
            case 0x00000004:
              return Opcode_lvx_v1_FSIGND_registerW_registerZ_registerY_simple;
            case 0x00000005:
              return Opcode_lvx_v1_FSIGNND_registerW_registerZ_registerY_simple;
            case 0x00000006:
              return Opcode_lvx_v1_FSIGNMD_registerW_registerZ_registerY_simple;
            case 0x00000007:
              switch ((codeWord_0 >> 8) & 0x0000000f) {
              case 0x00000002:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FNEGD_registerW_registerZ_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FNEGWP_registerW_registerZ_simple;
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000003:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FABSD_registerW_registerZ_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FABSWP_registerW_registerZ_simple;
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000004:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FSRECD_registerW_registerZ_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FSRECWP_registerW_registerZ_simple;
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000005:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FSRSRD_registerW_registerZ_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FSRSRWP_registerW_registerZ_simple;
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000006:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FCLASSD_registerW_registerZ_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FCLASSWP_registerW_registerZ_simple;
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000008:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FWIDENWD_mostsig_registerW_registerZ_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              default:
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 27) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_FSBFD_floatmode_registerW_registerZ_registerY_simple;
          case 0x00000001:
            switch ((codeWord_0 >> 8) & 0x0000000f) {
            case 0x00000000:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FLOATD_floatmode_registerW_registerZ_simple;
              case 0x00000001:
                return Opcode_lvx_v1_FLOATWP_floatmode_registerW_registerZ_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FLOATUD_floatmode_registerW_registerZ_simple;
              case 0x00000001:
                return Opcode_lvx_v1_FLOATUWP_floatmode_registerW_registerZ_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000002:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FLOATWD_floatmode_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000003:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FLOATUWD_floatmode_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000004:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FIXEDD_floatmode_registerW_registerZ_simple;
              case 0x00000001:
                return Opcode_lvx_v1_FIXEDWP_floatmode_registerW_registerZ_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000005:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FIXEDUD_floatmode_registerW_registerZ_simple;
              case 0x00000001:
                return Opcode_lvx_v1_FIXEDUWP_floatmode_registerW_registerZ_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000006:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FIXEDWD_floatmode_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000007:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FIXEDUWD_floatmode_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000008:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FSQRTD_floatmode_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000009:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FRINTD_floatmode_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        return Opcode_lvx_v1_FADDWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000001:
      switch ((codeWord_0 >> 12) & 0x00000001) {
      case 0x00000000:
        switch ((codeWord_0 >> 13) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 27) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_FCOMPD_floatcomp_registerW_registerZ_registerY_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        return Opcode_lvx_v1_FSBFWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000002:
      switch ((codeWord_0 >> 12) & 0x00000001) {
      case 0x00000000:
        switch ((codeWord_0 >> 13) & 0x00000001) {
        case 0x00000000:
          return Opcode_lvx_v1_FFMAD_fnegate_floatmode_registerW_registerZ_registerY_simple;
        case 0x00000001:
          return Opcode_lvx_v1_FFMSD_fnegate_floatmode_registerW_registerZ_registerY_simple;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        return Opcode_lvx_v1_FMULWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000003:
      switch ((codeWord_0 >> 12) & 0x00000001) {
      case 0x00000000:
        switch ((codeWord_0 >> 13) & 0x00000001) {
        case 0x00000000:
          return Opcode_lvx_v1_FMULD_fnegate_floatmode_registerW_registerZ_registerY_simple;
        case 0x00000001:
          return Opcode_lvx_v1_FDIVD_fnegate_floatmode_registerW_registerZ_registerY_simple;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        return Opcode_lvx_v1_FFMAWC_conjugate_imultiply_floatmode_registerW_registerZ_registerY_simple;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000004:
      switch ((codeWord_0 >> 12) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 27) & 0x00000001) {
        case 0x00000000:
          return Opcode_lvx_v1_FADDW_floatmode_registerW_registerZ_registerY_simple;
        case 0x00000001:
          switch ((codeWord_0 >> 24) & 0x00000007) {
          case 0x00000000:
            return Opcode_lvx_v1_FMINW_registerW_registerZ_registerY_simple;
          case 0x00000001:
            return Opcode_lvx_v1_FMAXW_registerW_registerZ_registerY_simple;
          case 0x00000002:
            return Opcode_lvx_v1_FMINNW_registerW_registerZ_registerY_simple;
          case 0x00000003:
            return Opcode_lvx_v1_FMAXNW_registerW_registerZ_registerY_simple;
          case 0x00000004:
            return Opcode_lvx_v1_FSIGNW_registerW_registerZ_registerY_simple;
          case 0x00000005:
            return Opcode_lvx_v1_FSIGNNW_registerW_registerZ_registerY_simple;
          case 0x00000006:
            return Opcode_lvx_v1_FSIGNMW_registerW_registerZ_registerY_simple;
          case 0x00000007:
            switch ((codeWord_0 >> 8) & 0x0000000f) {
            case 0x00000002:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FNEGW_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000003:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FABSW_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000004:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FSRECW_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000005:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FSRSRW_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000006:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FCLASSW_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000008:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FWIDENHW_mostsig_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 27) & 0x00000001) {
        case 0x00000000:
          return Opcode_lvx_v1_FADDH_floatmode_registerW_registerZ_registerY_simple;
        case 0x00000001:
          switch ((codeWord_0 >> 8) & 0x0000000f) {
          case 0x00000002:
            switch ((codeWord_0 >> 24) & 0x00000007) {
            case 0x00000007:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FNEGH_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000003:
            switch ((codeWord_0 >> 24) & 0x00000007) {
            case 0x00000007:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FABSH_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000006:
            switch ((codeWord_0 >> 24) & 0x00000007) {
            case 0x00000007:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FCLASSH_registerW_registerZ_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_0 >> 27) & 0x00000001) {
        case 0x00000000:
          return Opcode_lvx_v1_FSBFW_floatmode_registerW_registerZ_registerY_simple;
        case 0x00000001:
          switch ((codeWord_0 >> 8) & 0x0000000f) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FLOATW_floatmode_registerW_registerZ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FLOATUW_floatmode_registerW_registerZ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000002:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FLOATDW_floatmode_registerW_registerZ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000003:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FLOATUDW_floatmode_registerW_registerZ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000004:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FIXEDW_floatmode_registerW_registerZ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000005:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FIXEDUW_floatmode_registerW_registerZ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000006:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FIXEDDW_floatmode_registerW_registerZ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000007:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FIXEDUDW_floatmode_registerW_registerZ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000008:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FSQRTW_floatmode_registerW_registerZ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000009:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FRINTW_floatmode_registerW_registerZ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x0000000c:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FNARROWDW_floatmode_registerW_registerZ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 27) & 0x00000001) {
        case 0x00000000:
          return Opcode_lvx_v1_FSBFH_floatmode_registerW_registerZ_registerY_simple;
        case 0x00000001:
          switch ((codeWord_0 >> 8) & 0x0000000f) {
          case 0x00000008:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FSQRTH_floatmode_registerW_registerZ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000009:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FRINTH_floatmode_registerW_registerZ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x0000000c:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FNARROWWH_floatmode_registerW_registerZ_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000005:
      switch ((codeWord_0 >> 12) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 27) & 0x00000001) {
        case 0x00000000:
          return Opcode_lvx_v1_FCOMPW_floatcomp_registerW_registerZ_registerY_simple;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 27) & 0x00000001) {
        case 0x00000000:
          return Opcode_lvx_v1_FCOMPH_floatcomp_registerW_registerZ_registerY_simple;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000008:
          return Opcode_lvx_v1_FMINH_registerW_registerZ_registerY_simple;
        case 0x00000009:
          return Opcode_lvx_v1_FMAXH_registerW_registerZ_registerY_simple;
        case 0x0000000a:
          return Opcode_lvx_v1_FMINNH_registerW_registerZ_registerY_simple;
        case 0x0000000b:
          return Opcode_lvx_v1_FMAXNH_registerW_registerZ_registerY_simple;
        case 0x0000000c:
          return Opcode_lvx_v1_FSIGNH_registerW_registerZ_registerY_simple;
        case 0x0000000d:
          return Opcode_lvx_v1_FSIGNNH_registerW_registerZ_registerY_simple;
        case 0x0000000e:
          return Opcode_lvx_v1_FSIGNMH_registerW_registerZ_registerY_simple;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x00000006:
      switch ((codeWord_0 >> 12) & 0x00000003) {
      case 0x00000000:
        return Opcode_lvx_v1_FFMAW_fnegate_floatmode_registerW_registerZ_registerY_simple;
      case 0x00000001:
        return Opcode_lvx_v1_FFMAH_fnegate_floatmode_registerW_registerZ_registerY_simple;
      case 0x00000002:
        return Opcode_lvx_v1_FFMSW_fnegate_floatmode_registerW_registerZ_registerY_simple;
      case 0x00000003:
        return Opcode_lvx_v1_FFMSH_fnegate_floatmode_registerW_registerZ_registerY_simple;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000007:
      switch ((codeWord_0 >> 12) & 0x00000003) {
      case 0x00000000:
        return Opcode_lvx_v1_FMULW_fnegate_floatmode_registerW_registerZ_registerY_simple;
      case 0x00000001:
        return Opcode_lvx_v1_FMULH_fnegate_floatmode_registerW_registerZ_registerY_simple;
      case 0x00000002:
        return Opcode_lvx_v1_FDIVW_fnegate_floatmode_registerW_registerZ_registerY_simple;
      case 0x00000003:
        return Opcode_lvx_v1_FDIVH_fnegate_floatmode_registerW_registerZ_registerY_simple;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000008:
      switch ((codeWord_0 >> 12) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SIGNWP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SIGNWP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SIGNSWP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SIGNSWP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDWP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDWP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFWP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SBFWP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000004:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MINWP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_MINWP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000005:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MAXWP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_MAXWP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000006:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MINUWP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_MINUWP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000007:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MAXUWP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_MAXUWP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 24) & 0x0000000f) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SIGNHQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SIGNHQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SIGNBO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SIGNBO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SIGNSHQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SIGNSHQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SIGNSBO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SIGNSBO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDHQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDHQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDBO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDBO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFHQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SBFHQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFBO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SBFBO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000004:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MINHQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_MINHQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MINBO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_MINBO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000005:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MAXHQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_MAXHQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MAXBO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_MAXBO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000006:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MINUHQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_MINUHQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MINUBO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_MINUBO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000007:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MAXUHQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_MAXUHQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_MAXUBO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_MAXUBO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_AVGWP_registerWe_registerZe_registerYe_simple;
            case 0x0000000d:
              return Opcode_lvx_v1_AVGUWP_registerWe_registerZe_registerYe_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_AVGRWP_registerWe_registerZe_registerYe_simple;
            case 0x0000000f:
              return Opcode_lvx_v1_AVGRUWP_registerWe_registerZe_registerYe_simple;
            default:
              return Opcode_lvx_v1_COMPWP_intcomp_registerWe_registerZe_registerYe_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_AVGWP_registerWo_registerZo_registerYo_simple;
            case 0x0000000d:
              return Opcode_lvx_v1_AVGUWP_registerWo_registerZo_registerYo_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_AVGRWP_registerWo_registerZo_registerYo_simple;
            case 0x0000000f:
              return Opcode_lvx_v1_AVGRUWP_registerWo_registerZo_registerYo_simple;
            default:
              return Opcode_lvx_v1_COMPWP_intcomp_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_AVGHQ_registerWe_registerZe_registerYe_simple;
            case 0x0000000d:
              return Opcode_lvx_v1_AVGUHQ_registerWe_registerZe_registerYe_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_AVGRHQ_registerWe_registerZe_registerYe_simple;
            case 0x0000000f:
              return Opcode_lvx_v1_AVGRUHQ_registerWe_registerZe_registerYe_simple;
            default:
              return Opcode_lvx_v1_COMPHQ_intcomp_registerWe_registerZe_registerYe_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_AVGHQ_registerWo_registerZo_registerYo_simple;
            case 0x0000000d:
              return Opcode_lvx_v1_AVGUHQ_registerWo_registerZo_registerYo_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_AVGRHQ_registerWo_registerZo_registerYo_simple;
            case 0x0000000f:
              return Opcode_lvx_v1_AVGRUHQ_registerWo_registerZo_registerYo_simple;
            default:
              return Opcode_lvx_v1_COMPHQ_intcomp_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_AVGBO_registerWe_registerZe_registerYe_simple;
            case 0x0000000d:
              return Opcode_lvx_v1_AVGUBO_registerWe_registerZe_registerYe_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_AVGRBO_registerWe_registerZe_registerYe_simple;
            case 0x0000000f:
              return Opcode_lvx_v1_AVGRUBO_registerWe_registerZe_registerYe_simple;
            default:
              return Opcode_lvx_v1_COMPBO_intcomp_registerWe_registerZe_registerYe_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_AVGBO_registerWo_registerZo_registerYo_simple;
            case 0x0000000d:
              return Opcode_lvx_v1_AVGUBO_registerWo_registerZo_registerYo_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_AVGRBO_registerWo_registerZo_registerYo_simple;
            case 0x0000000f:
              return Opcode_lvx_v1_AVGRUBO_registerWo_registerZo_registerYo_simple;
            default:
              return Opcode_lvx_v1_COMPBO_intcomp_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
        break;
      }
      return Opcode__UNDEF;
    case 0x00000009:
      switch ((codeWord_0 >> 12) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_COMPND_intcomp_registerWe_registerZe_registerYe_simple;
          case 0x00000001:
            return Opcode_lvx_v1_COMPND_intcomp_registerWo_registerZo_registerYo_simple;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_ABDWP_registerWe_registerZe_registerYe_simple;
            case 0x0000000d:
              return Opcode_lvx_v1_ABDUWP_registerWe_registerZe_registerYe_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_ABDSWP_registerWe_registerZe_registerYe_simple;
            case 0x0000000f:
              return Opcode_lvx_v1_STSUWP_registerWe_registerZe_registerYe_simple;
            default:
              return Opcode_lvx_v1_COMPNWP_intcomp_registerWe_registerZe_registerYe_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_ABDWP_registerWo_registerZo_registerYo_simple;
            case 0x0000000d:
              return Opcode_lvx_v1_ABDUWP_registerWo_registerZo_registerYo_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_ABDSWP_registerWo_registerZo_registerYo_simple;
            case 0x0000000f:
              return Opcode_lvx_v1_STSUWP_registerWo_registerZo_registerYo_simple;
            default:
              return Opcode_lvx_v1_COMPNWP_intcomp_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_ABDHQ_registerWe_registerZe_registerYe_simple;
            case 0x0000000d:
              return Opcode_lvx_v1_ABDUHQ_registerWe_registerZe_registerYe_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_ABDSHQ_registerWe_registerZe_registerYe_simple;
            case 0x0000000f:
              return Opcode_lvx_v1_STSUHQ_registerWe_registerZe_registerYe_simple;
            default:
              return Opcode_lvx_v1_COMPNHQ_intcomp_registerWe_registerZe_registerYe_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_ABDHQ_registerWo_registerZo_registerYo_simple;
            case 0x0000000d:
              return Opcode_lvx_v1_ABDUHQ_registerWo_registerZo_registerYo_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_ABDSHQ_registerWo_registerZo_registerYo_simple;
            case 0x0000000f:
              return Opcode_lvx_v1_STSUHQ_registerWo_registerZo_registerYo_simple;
            default:
              return Opcode_lvx_v1_COMPNHQ_intcomp_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_ABDBO_registerWe_registerZe_registerYe_simple;
            case 0x0000000d:
              return Opcode_lvx_v1_ABDUBO_registerWe_registerZe_registerYe_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_ABDSBO_registerWe_registerZe_registerYe_simple;
            default:
              return Opcode_lvx_v1_COMPNBO_intcomp_registerWe_registerZe_registerYe_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x0000000f) {
            case 0x0000000c:
              return Opcode_lvx_v1_ABDBO_registerWo_registerZo_registerYo_simple;
            case 0x0000000d:
              return Opcode_lvx_v1_ABDUBO_registerWo_registerZo_registerYo_simple;
            case 0x0000000e:
              return Opcode_lvx_v1_ABDSBO_registerWo_registerZo_registerYo_simple;
            default:
              return Opcode_lvx_v1_COMPNBO_intcomp_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_CMOVEWP_lanecond_registerZe_registerWe_registerYe_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_CMOVEWP_lanecond_registerZo_registerWo_registerYo_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_CMOVEHQ_lanecond_registerZe_registerWe_registerYe_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_CMOVEHQ_lanecond_registerZo_registerWo_registerYo_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 24) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_CMOVEBO_lanecond_registerZe_registerWe_registerYe_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_CMOVEBO_lanecond_registerZo_registerWo_registerYo_simple;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
        break;
      }
      return Opcode__UNDEF;
    case 0x0000000a:
      switch ((codeWord_0 >> 24) & 0x0000000f) {
      case 0x00000000:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRSWP_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRSWP_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRSHQ_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRSHQ_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRSBO_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRSBO_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX2WP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX2WP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX2HQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX2HQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX2BO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX2BO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLLWP_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLLWP_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLLHQ_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLLHQ_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLLBO_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLLBO_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX4WP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX4WP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX4HQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX4HQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX4BO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX4BO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRAWP_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRAWP_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRAHQ_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRAHQ_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRABO_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRABO_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX8WP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX8WP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX8HQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX8HQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX8BO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX8BO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRLWP_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRLWP_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRLHQ_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRLHQ_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRLBO_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRLBO_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX16WP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX16WP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX16HQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX16HQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDX16BO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDX16BO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000004:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLSWP_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLSWP_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLSHQ_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLSHQ_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLSBO_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLSBO_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000005:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLUSWP_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLUSWP_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLUSHQ_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLUSHQ_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLUSBO_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLUSBO_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000006:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ROLWP_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ROLWP_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000007:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_RORWP_registerWe_registerZe_registerY_simple;
            case 0x00000001:
              return Opcode_lvx_v1_RORWP_registerWo_registerZo_registerY_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000008:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRSWP_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRSWP_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRSHQ_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRSHQ_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRSBO_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRSBO_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDSWP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDSWP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDSHQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDSHQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDSBO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDSBO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000009:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLLWP_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLLWP_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLLHQ_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLLHQ_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLLBO_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLLBO_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFSWP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SBFSWP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFSHQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SBFSHQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFSBO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SBFSBO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000a:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRAWP_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRAWP_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRAHQ_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRAHQ_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRABO_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRABO_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDUSWP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDUSWP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDUSHQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDUSHQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ADDUSBO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ADDUSBO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000b:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRLWP_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRLWP_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRLHQ_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRLHQ_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SRLBO_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SRLBO_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFUSWP_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SBFUSWP_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFUSHQ_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SBFUSHQ_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SBFUSBO_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SBFUSBO_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000c:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLSWP_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLSWP_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLSHQ_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLSHQ_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLSBO_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLSBO_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000d:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLUSWP_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLUSWP_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLUSHQ_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLUSHQ_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SLUSBO_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_SLUSBO_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000e:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_ROLWP_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_ROLWP_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x0000000f:
        switch ((codeWord_0 >> 12) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000001:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_RORWP_registerWe_registerZe_unsigned6_simple;
            case 0x00000001:
              return Opcode_lvx_v1_RORWP_registerWo_registerZo_unsigned6_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 8) & 0x0000000f) {
          case 0x00000000:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_NEGWP_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_NEGWP_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_ABSWP_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_ABSWP_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000002:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_NEGSWP_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_NEGSWP_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000003:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_ABSSWP_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_ABSSWP_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000004:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_CLZWP_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_CLZWP_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000005:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_CLSWP_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_CLSWP_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000006:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_CBSWP_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_CBSWP_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000007:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_CTZWP_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_CTZWP_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000008:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000001:
                return Opcode_lvx_v1_WIDENZWDP_mostsig_registerM_registerP_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_TRUNCDWP_registerW_registerP_simple;
              case 0x00000001:
                return Opcode_lvx_v1_WIDENZHWQ_mostsig_registerM_registerP_simple;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000009:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000001:
                return Opcode_lvx_v1_WIDENSWDP_mostsig_registerM_registerP_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FRACTDWP_registerW_registerP_simple;
              case 0x00000001:
                return Opcode_lvx_v1_WIDENSHWQ_mostsig_registerM_registerP_simple;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          case 0x0000000a:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000001:
                return Opcode_lvx_v1_WIDENQWDP_mostsig_registerM_registerP_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000001:
                return Opcode_lvx_v1_WIDENQHWQ_mostsig_registerM_registerP_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          case 0x0000000c:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_EXTLZWDP_oddlanes_registerM_registerP_simple;
            case 0x00000001:
              return Opcode_lvx_v1_EXTLZHWQ_oddlanes_registerM_registerP_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x0000000d:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_EXTLSWDP_oddlanes_registerM_registerP_simple;
            case 0x00000001:
              return Opcode_lvx_v1_EXTLSHWQ_oddlanes_registerM_registerP_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x0000000e:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_EXTLQWDP_oddlanes_registerM_registerP_simple;
            case 0x00000001:
              return Opcode_lvx_v1_EXTLQHWQ_oddlanes_registerM_registerP_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 8) & 0x0000000f) {
          case 0x00000000:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_NEGHQ_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_NEGHQ_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_NEGBO_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_NEGBO_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_ABSHQ_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_ABSHQ_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_ABSBO_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_ABSBO_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000002:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_NEGSHQ_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_NEGSHQ_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_NEGSBO_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_NEGSBO_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000003:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_ABSSHQ_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_ABSSHQ_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_ABSSBO_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_ABSSBO_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000004:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_CLZHQ_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_CLZHQ_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000005:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_CLSHQ_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_CLSHQ_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000006:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_CBSHQ_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_CBSHQ_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000007:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_CTZHQ_registerWe_registerZe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_CTZHQ_registerWo_registerZo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000008:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_TRUNCWHQ_ziplanes_registerW_registerP_simple;
              case 0x00000001:
                return Opcode_lvx_v1_WIDENZBHO_mostsig_registerM_registerP_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_TRUNCHBO_ziplanes_registerW_registerP_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000009:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FRACTWHQ_ziplanes_registerW_registerP_simple;
              case 0x00000001:
                return Opcode_lvx_v1_WIDENSBHO_mostsig_registerM_registerP_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FRACTHBO_ziplanes_registerW_registerP_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          case 0x0000000a:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000001:
                return Opcode_lvx_v1_WIDENQBHO_mostsig_registerM_registerP_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x0000000c:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_EXTLZBHO_oddlanes_registerM_registerP_simple;
            case 0x00000001:
              return Opcode_lvx_v1_EXTLZNBX_oddlanes_registerM_registerP_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x0000000d:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_EXTLSBHO_oddlanes_registerM_registerP_simple;
            case 0x00000001:
              return Opcode_lvx_v1_EXTLSNBX_oddlanes_registerM_registerP_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x0000000e:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_EXTLQBHO_oddlanes_registerM_registerP_simple;
            case 0x00000001:
              return Opcode_lvx_v1_EXTLQNBX_oddlanes_registerM_registerP_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
        break;
      }
      return Opcode__UNDEF;
    case 0x0000000b:
      switch ((codeWord_0 >> 12) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MULWDP_widemult_registerM_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MULWDP_widemult_registerM_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MULWP_highmult_registerWe_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MULWP_highmult_registerWo_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MULHWQ_widemult_registerM_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MULHWQ_widemult_registerM_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MULNWDP_widemult_registerM_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MULNWDP_widemult_registerM_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MULNWP_highmult_registerWe_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MULNWP_highmult_registerWo_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MULNHWQ_widemult_registerM_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MULNHWQ_widemult_registerM_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MADDWDP_widemult_registerM_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MADDWDP_widemult_registerM_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MADDWP_highmult_registerWe_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MADDWP_highmult_registerWo_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MADDHWQ_widemult_registerM_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MADDHWQ_widemult_registerM_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MSBFWDP_widemult_registerM_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MSBFWDP_widemult_registerM_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MSBFWP_highmult_registerWe_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MSBFWP_highmult_registerWo_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MSBFHWQ_widemult_registerM_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MSBFHWQ_widemult_registerM_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MULHQ_highmult_registerWe_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MULHQ_highmult_registerWo_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MULBHO_widemult_registerM_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MULBHO_widemult_registerM_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MULNHQ_highmult_registerWe_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MULNHQ_highmult_registerWo_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MULNBHO_widemult_registerM_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MULNBHO_widemult_registerM_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MADDHQ_highmult_registerWe_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MADDHQ_highmult_registerWo_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MADDBHO_widemult_registerM_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MADDBHO_widemult_registerM_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MSBFHQ_highmult_registerWe_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MSBFHQ_highmult_registerWo_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_MSBFBHO_widemult_registerM_registerZe_registerYe_simple;
              case 0x00000001:
                return Opcode_lvx_v1_MSBFBHO_widemult_registerM_registerZo_registerYo_simple;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000002:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_MULXWDP_oddlanes_widemult_registerM_registerP_registerO_simple;
          case 0x00000001:
            return Opcode_lvx_v1_MULXHWQ_oddlanes_widemult_registerM_registerP_registerO_simple;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_MULNXWDP_oddlanes_widemult_registerM_registerP_registerO_simple;
          case 0x00000001:
            return Opcode_lvx_v1_MULNXHWQ_oddlanes_widemult_registerM_registerP_registerO_simple;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_MADDXWDP_oddlanes_widemult_registerM_registerP_registerO_simple;
          case 0x00000001:
            return Opcode_lvx_v1_MADDXHWQ_oddlanes_widemult_registerM_registerP_registerO_simple;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_MSBFXWDP_oddlanes_widemult_registerM_registerP_registerO_simple;
          case 0x00000001:
            return Opcode_lvx_v1_MSBFXHWQ_oddlanes_widemult_registerM_registerP_registerO_simple;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 26) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_MULXBHO_oddlanes_widemult_registerM_registerP_registerO_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_MULNXBHO_oddlanes_widemult_registerM_registerP_registerO_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_MADDXBHO_oddlanes_widemult_registerM_registerP_registerO_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_0 >> 0) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_MSBFXBHO_oddlanes_widemult_registerM_registerP_registerO_simple;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
        break;
      }
      return Opcode__UNDEF;
    case 0x0000000c:
      switch ((codeWord_0 >> 12) & 0x00000003) {
      case 0x00000001:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 27) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FADDWP_floatmode_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_FADDWP_floatmode_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 24) & 0x00000007) {
            case 0x00000000:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                switch ((codeWord_0 >> 18) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FMINWP_registerWe_registerZe_registerYe_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FMINWP_registerWo_registerZo_registerYo_simple;
                  break;
                }
                return Opcode__UNDEF;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                switch ((codeWord_0 >> 18) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FMAXWP_registerWe_registerZe_registerYe_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FMAXWP_registerWo_registerZo_registerYo_simple;
                  break;
                }
                return Opcode__UNDEF;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000002:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                switch ((codeWord_0 >> 18) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FMINNWP_registerWe_registerZe_registerYe_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FMINNWP_registerWo_registerZo_registerYo_simple;
                  break;
                }
                return Opcode__UNDEF;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000003:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                switch ((codeWord_0 >> 18) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FMAXNWP_registerWe_registerZe_registerYe_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FMAXNWP_registerWo_registerZo_registerYo_simple;
                  break;
                }
                return Opcode__UNDEF;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000004:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                switch ((codeWord_0 >> 18) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FSIGNWP_registerWe_registerZe_registerYe_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FSIGNWP_registerWo_registerZo_registerYo_simple;
                  break;
                }
                return Opcode__UNDEF;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000005:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                switch ((codeWord_0 >> 18) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FSIGNNWP_registerWe_registerZe_registerYe_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FSIGNNWP_registerWo_registerZo_registerYo_simple;
                  break;
                }
                return Opcode__UNDEF;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000006:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                switch ((codeWord_0 >> 18) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FSIGNMWP_registerWe_registerZe_registerYe_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FSIGNMWP_registerWo_registerZo_registerYo_simple;
                  break;
                }
                return Opcode__UNDEF;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000007:
              switch ((codeWord_0 >> 8) & 0x0000000f) {
              case 0x00000008:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FWIDENHWQ_mostsig_registerM_registerP_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000009:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FEXTLHWQ_oddlanes_registerM_registerP_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              default:
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 27) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FADDHQ_floatmode_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 24) & 0x00000007) {
              case 0x00000000:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FMINHQ_registerWe_registerZe_registerYe_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000001:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FMAXHQ_registerWe_registerZe_registerYe_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000002:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FMINNHQ_registerWe_registerZe_registerYe_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000003:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FMAXNHQ_registerWe_registerZe_registerYe_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000004:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FSIGNHQ_registerWe_registerZe_registerYe_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000005:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FSIGNNHQ_registerWe_registerZe_registerYe_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000006:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FSIGNMHQ_registerWe_registerZe_registerYe_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000007:
                switch ((codeWord_0 >> 8) & 0x0000000f) {
                case 0x00000002:
                  switch ((codeWord_0 >> 6) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_FNEGHQ_registerWe_registerZe_simple;
                  default:
                    break;
                  }
                  return Opcode__UNDEF;
                case 0x00000003:
                  switch ((codeWord_0 >> 6) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_FABSHQ_registerWe_registerZe_simple;
                  default:
                    break;
                  }
                  return Opcode__UNDEF;
                case 0x00000006:
                  switch ((codeWord_0 >> 6) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_FCLASSHQ_registerWe_registerZe_simple;
                  default:
                    break;
                  }
                  return Opcode__UNDEF;
                default:
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 27) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FADDHQ_floatmode_registerWo_registerZo_registerYo_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 24) & 0x00000007) {
              case 0x00000000:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FMINHQ_registerWo_registerZo_registerYo_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000001:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FMAXHQ_registerWo_registerZo_registerYo_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000002:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FMINNHQ_registerWo_registerZo_registerYo_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000003:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FMAXNHQ_registerWo_registerZo_registerYo_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000004:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FSIGNHQ_registerWo_registerZo_registerYo_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000005:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FSIGNNHQ_registerWo_registerZo_registerYo_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000006:
                switch ((codeWord_0 >> 6) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FSIGNMHQ_registerWo_registerZo_registerYo_simple;
                default:
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000007:
                switch ((codeWord_0 >> 8) & 0x0000000f) {
                case 0x00000002:
                  switch ((codeWord_0 >> 6) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_FNEGHQ_registerWo_registerZo_simple;
                  default:
                    break;
                  }
                  return Opcode__UNDEF;
                case 0x00000003:
                  switch ((codeWord_0 >> 6) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_FABSHQ_registerWo_registerZo_simple;
                  default:
                    break;
                  }
                  return Opcode__UNDEF;
                case 0x00000006:
                  switch ((codeWord_0 >> 6) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_FCLASSHQ_registerWo_registerZo_simple;
                  default:
                    break;
                  }
                  return Opcode__UNDEF;
                default:
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 27) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FSBFWP_floatmode_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_FSBFWP_floatmode_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 8) & 0x0000000f) {
            case 0x0000000c:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FNARROWDWP_floatmode_registerW_registerP_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 27) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FSBFHQ_floatmode_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_FSBFHQ_floatmode_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 8) & 0x0000000f) {
            case 0x00000000:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                switch ((codeWord_0 >> 18) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FLOATHQ_floatmode_registerWe_registerZe_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FLOATHQ_floatmode_registerWo_registerZo_simple;
                  break;
                }
                return Opcode__UNDEF;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                switch ((codeWord_0 >> 18) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FLOATUHQ_floatmode_registerWe_registerZe_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FLOATUHQ_floatmode_registerWo_registerZo_simple;
                  break;
                }
                return Opcode__UNDEF;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000002:
              switch ((codeWord_0 >> 6) & 0x00000003) {
              case 0x00000000:
                switch ((codeWord_0 >> 18) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FIXEDHQ_floatmode_registerWe_registerZe_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FIXEDHQ_floatmode_registerWo_registerZo_simple;
                  break;
                }
                return Opcode__UNDEF;
              case 0x00000002:
                switch ((codeWord_0 >> 18) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_FIXEDUHQ_floatmode_registerWe_registerZe_simple;
                case 0x00000001:
                  return Opcode_lvx_v1_FIXEDUHQ_floatmode_registerWo_registerZo_simple;
                  break;
                }
                return Opcode__UNDEF;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x0000000c:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FNARROWWHQ_ziplanes_floatmode_registerW_registerP_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x0000000d:
      switch ((codeWord_0 >> 12) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000001:
          switch ((codeWord_0 >> 6) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 27) & 0x00000001) {
              case 0x00000001:
                return Opcode_lvx_v1_FCOMPND_floatcomp_registerWe_registerZe_registerYe_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              switch ((codeWord_0 >> 27) & 0x00000001) {
              case 0x00000001:
                return Opcode_lvx_v1_FCOMPND_floatcomp_registerWo_registerZo_registerYo_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 27) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FCOMPWP_floatcomp_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FCOMPNWP_floatcomp_registerWe_registerZe_registerYe_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 27) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FCOMPWP_floatcomp_registerWo_registerZo_registerYo_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FCOMPNWP_floatcomp_registerWo_registerZo_registerYo_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 27) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FCOMPHQ_floatcomp_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FCOMPNHQ_floatcomp_registerWe_registerZe_registerYe_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          case 0x00000001:
            switch ((codeWord_0 >> 27) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FCOMPHQ_floatcomp_registerWo_registerZo_registerYo_simple;
            case 0x00000001:
              switch ((codeWord_0 >> 6) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_FCOMPNHQ_floatcomp_registerWo_registerZo_registerYo_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x0000000e:
      switch ((codeWord_0 >> 12) & 0x00000003) {
      case 0x00000001:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 6) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FFMAWP_fnegate_floatmode_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_FFMAWP_fnegate_floatmode_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 6) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FFMAHQ_fnegate_floatmode_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_FFMAHQ_fnegate_floatmode_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 6) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FFMSWP_fnegate_floatmode_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_FFMSWP_fnegate_floatmode_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 6) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FFMSHQ_fnegate_floatmode_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_FFMSHQ_fnegate_floatmode_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    case 0x0000000f:
      switch ((codeWord_0 >> 12) & 0x00000003) {
      case 0x00000001:
        switch ((codeWord_0 >> 0) & 0x00000001) {
        case 0x00000000:
          switch ((codeWord_0 >> 6) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FMULWP_fnegate_floatmode_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_FMULWP_fnegate_floatmode_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_0 >> 6) & 0x00000001) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_FMULHQ_fnegate_floatmode_registerWe_registerZe_registerYe_simple;
            case 0x00000001:
              return Opcode_lvx_v1_FMULHQ_fnegate_floatmode_registerWo_registerZo_registerYo_simple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 6) & 0x0000003f) {
        case 0x0000003f:
          switch ((codeWord_0 >> 24) & 0x0000000f) {
          case 0x0000000f:
            switch ((codeWord_0 >> 0) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000001:
                return Opcode_lvx_v1_NOP_simple;
              default:
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
      break;
    }
    return Opcode__UNDEF;
  default:
    break;
  }
  return Opcode__UNDEF;
}
#endif//NDECODE

#ifdef $XCC__h
#ifndef NDECODE
extern Opcode
Decode_Decoding_lvx_v1_triple(const void *buffer);
#endif//NDECODE
#endif//$XCC__h

#ifndef NDECODE
Opcode
Decode_Decoding_lvx_v1_triple(const void *buffer)
{
  const uint32_t *codeWords = (const uint32_t *)buffer;
  uint32_t codeWord_0 = codeWords[0];
  uint32_t codeWord_1 = codeWords[1];
  uint32_t codeWord_2 = codeWords[2];
  switch ((codeWord_0 >> 26) & 0x0000003f) {
  case 0x00000028:
    switch ((codeWord_1 >> 29) & 0x00000007) {
    case 0x00000004:
      switch ((codeWord_0 >> 16) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_2 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LBZ_variant_registerW_extend27_upper27_lower10_registerZ_triple;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_2 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_XLO_variant_registerG_extend27_upper27_lower10_registerZ_triple;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000029:
    switch ((codeWord_1 >> 29) & 0x00000007) {
    case 0x00000004:
      switch ((codeWord_0 >> 16) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_2 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LBS_variant_registerW_extend27_upper27_lower10_registerZ_triple;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000002a:
    switch ((codeWord_1 >> 29) & 0x00000007) {
    case 0x00000004:
      switch ((codeWord_0 >> 16) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_2 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LHZ_variant_registerW_extend27_upper27_lower10_registerZ_triple;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_2 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_XLO_variant_qindex_registerGq_extend27_upper27_lower10_registerZ_triple;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000002b:
    switch ((codeWord_1 >> 29) & 0x00000007) {
    case 0x00000004:
      switch ((codeWord_0 >> 16) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_2 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LHS_variant_registerW_extend27_upper27_lower10_registerZ_triple;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 13) & 0x00000007) {
        case 0x00000000:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLB_variant_registerGg_registerY_extend27_offset27_registerZ_triple;
            case 0x00000001:
              switch ((codeWord_0 >> 19) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLB_variant_registerGh_registerY_extend27_offset27_registerZ_triple;
              case 0x00000001:
                switch ((codeWord_0 >> 20) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLB_variant_registerGi_registerY_extend27_offset27_registerZ_triple;
                case 0x00000001:
                  switch ((codeWord_0 >> 21) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLB_variant_registerGj_registerY_extend27_offset27_registerZ_triple;
                  case 0x00000001:
                    switch ((codeWord_0 >> 22) & 0x00000001) {
                    case 0x00000000:
                      return Opcode_lvx_v1_XPLB_variant_registerGk_registerY_extend27_offset27_registerZ_triple;
                    case 0x00000001:
                      return Opcode_lvx_v1_XPLB_variant_registerGl_registerY_extend27_offset27_registerZ_triple;
                      break;
                    }
                    return Opcode__UNDEF;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLH_variant_registerGg_registerY_extend27_offset27_registerZ_triple;
            case 0x00000001:
              switch ((codeWord_0 >> 19) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLH_variant_registerGh_registerY_extend27_offset27_registerZ_triple;
              case 0x00000001:
                switch ((codeWord_0 >> 20) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLH_variant_registerGi_registerY_extend27_offset27_registerZ_triple;
                case 0x00000001:
                  switch ((codeWord_0 >> 21) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLH_variant_registerGj_registerY_extend27_offset27_registerZ_triple;
                  case 0x00000001:
                    switch ((codeWord_0 >> 22) & 0x00000001) {
                    case 0x00000000:
                      return Opcode_lvx_v1_XPLH_variant_registerGk_registerY_extend27_offset27_registerZ_triple;
                    case 0x00000001:
                      return Opcode_lvx_v1_XPLH_variant_registerGl_registerY_extend27_offset27_registerZ_triple;
                      break;
                    }
                    return Opcode__UNDEF;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLW_variant_registerGg_registerY_extend27_offset27_registerZ_triple;
            case 0x00000001:
              switch ((codeWord_0 >> 19) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLW_variant_registerGh_registerY_extend27_offset27_registerZ_triple;
              case 0x00000001:
                switch ((codeWord_0 >> 20) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLW_variant_registerGi_registerY_extend27_offset27_registerZ_triple;
                case 0x00000001:
                  switch ((codeWord_0 >> 21) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLW_variant_registerGj_registerY_extend27_offset27_registerZ_triple;
                  case 0x00000001:
                    switch ((codeWord_0 >> 22) & 0x00000001) {
                    case 0x00000000:
                      return Opcode_lvx_v1_XPLW_variant_registerGk_registerY_extend27_offset27_registerZ_triple;
                    case 0x00000001:
                      return Opcode_lvx_v1_XPLW_variant_registerGl_registerY_extend27_offset27_registerZ_triple;
                      break;
                    }
                    return Opcode__UNDEF;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLD_variant_registerGg_registerY_extend27_offset27_registerZ_triple;
            case 0x00000001:
              switch ((codeWord_0 >> 19) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLD_variant_registerGh_registerY_extend27_offset27_registerZ_triple;
              case 0x00000001:
                switch ((codeWord_0 >> 20) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLD_variant_registerGi_registerY_extend27_offset27_registerZ_triple;
                case 0x00000001:
                  switch ((codeWord_0 >> 21) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLD_variant_registerGj_registerY_extend27_offset27_registerZ_triple;
                  case 0x00000001:
                    switch ((codeWord_0 >> 22) & 0x00000001) {
                    case 0x00000000:
                      return Opcode_lvx_v1_XPLD_variant_registerGk_registerY_extend27_offset27_registerZ_triple;
                    case 0x00000001:
                      return Opcode_lvx_v1_XPLD_variant_registerGl_registerY_extend27_offset27_registerZ_triple;
                      break;
                    }
                    return Opcode__UNDEF;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000004:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLQ_variant_registerGg_registerY_extend27_offset27_registerZ_triple;
            case 0x00000001:
              switch ((codeWord_0 >> 19) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLQ_variant_registerGh_registerY_extend27_offset27_registerZ_triple;
              case 0x00000001:
                switch ((codeWord_0 >> 20) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLQ_variant_registerGi_registerY_extend27_offset27_registerZ_triple;
                case 0x00000001:
                  switch ((codeWord_0 >> 21) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLQ_variant_registerGj_registerY_extend27_offset27_registerZ_triple;
                  case 0x00000001:
                    switch ((codeWord_0 >> 22) & 0x00000001) {
                    case 0x00000000:
                      return Opcode_lvx_v1_XPLQ_variant_registerGk_registerY_extend27_offset27_registerZ_triple;
                    case 0x00000001:
                      return Opcode_lvx_v1_XPLQ_variant_registerGl_registerY_extend27_offset27_registerZ_triple;
                      break;
                    }
                    return Opcode__UNDEF;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000005:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_XPLO_variant_registerGg_registerY_extend27_offset27_registerZ_triple;
            case 0x00000001:
              switch ((codeWord_0 >> 19) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_XPLO_variant_registerGh_registerY_extend27_offset27_registerZ_triple;
              case 0x00000001:
                switch ((codeWord_0 >> 20) & 0x00000001) {
                case 0x00000000:
                  return Opcode_lvx_v1_XPLO_variant_registerGi_registerY_extend27_offset27_registerZ_triple;
                case 0x00000001:
                  switch ((codeWord_0 >> 21) & 0x00000001) {
                  case 0x00000000:
                    return Opcode_lvx_v1_XPLO_variant_registerGj_registerY_extend27_offset27_registerZ_triple;
                  case 0x00000001:
                    switch ((codeWord_0 >> 22) & 0x00000001) {
                    case 0x00000000:
                      return Opcode_lvx_v1_XPLO_variant_registerGk_registerY_extend27_offset27_registerZ_triple;
                    case 0x00000001:
                      return Opcode_lvx_v1_XPLO_variant_registerGl_registerY_extend27_offset27_registerZ_triple;
                      break;
                    }
                    return Opcode__UNDEF;
                    break;
                  }
                  return Opcode__UNDEF;
                  break;
                }
                return Opcode__UNDEF;
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000002c:
    switch ((codeWord_1 >> 29) & 0x00000007) {
    case 0x00000004:
      switch ((codeWord_0 >> 16) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_2 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LWZ_variant_registerW_extend27_upper27_lower10_registerZ_triple;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 24) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_SB_extend27_upper27_lower10_registerZ_registerT_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_SH_extend27_upper27_lower10_registerZ_registerT_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_SW_extend27_upper27_lower10_registerZ_registerT_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_SD_extend27_upper27_lower10_registerZ_registerT_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000002d:
    switch ((codeWord_1 >> 29) & 0x00000007) {
    case 0x00000004:
      switch ((codeWord_0 >> 16) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_2 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LWS_variant_registerW_extend27_upper27_lower10_registerZ_triple;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 24) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 18) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_SQ_extend27_upper27_lower10_registerZ_registerU_triple;
            case 0x00000001:
              switch ((codeWord_0 >> 19) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_SO_extend27_upper27_lower10_registerZ_registerV_triple;
              default:
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_XSO_extend27_upper27_lower10_registerZ_registerE_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_XSO_qindex_extend27_upper27_lower10_registerZ_registerEq_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000002e:
    switch ((codeWord_1 >> 29) & 0x00000007) {
    case 0x00000004:
      switch ((codeWord_0 >> 16) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_2 >> 29) & 0x00000003) {
        case 0x00000000:
          return Opcode_lvx_v1_LD_variant_registerW_extend27_upper27_lower10_registerZ_triple;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000002f:
    switch ((codeWord_1 >> 29) & 0x00000007) {
    case 0x00000004:
      switch ((codeWord_0 >> 16) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_2 >> 29) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_0 >> 18) & 0x00000001) {
          case 0x00000000:
            return Opcode_lvx_v1_LQ_variant_registerM_extend27_upper27_lower10_registerZ_triple;
          case 0x00000001:
            switch ((codeWord_0 >> 19) & 0x00000001) {
            case 0x00000000:
              return Opcode_lvx_v1_LO_variant_registerN_extend27_upper27_lower10_registerZ_triple;
            case 0x00000001:
              switch ((codeWord_0 >> 20) & 0x0000003f) {
              case 0x00000000:
                return Opcode_lvx_v1_DTOUCHL_extend27_upper27_lower10_registerZ_triple;
              case 0x00000001:
                return Opcode_lvx_v1_DINVALL_extend27_upper27_lower10_registerZ_triple;
              case 0x00000002:
                return Opcode_lvx_v1_DPURGEL_extend27_upper27_lower10_registerZ_triple;
              case 0x00000003:
                return Opcode_lvx_v1_DFLUSHL_extend27_upper27_lower10_registerZ_triple;
              case 0x00000005:
                return Opcode_lvx_v1_I1INVALS_extend27_upper27_lower10_registerZ_triple;
              default:
                break;
              }
              return Opcode__UNDEF;
              break;
            }
            return Opcode__UNDEF;
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      case 0x00000003:
        switch ((codeWord_0 >> 13) & 0x00000007) {
        case 0x00000000:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 7) & 0x0000001f) {
              case 0x00000000:
                return Opcode_lvx_v1_ALB_coherency_registerW_extend27_offset27_registerZ_triple;
              case 0x00000001:
                return Opcode_lvx_v1_ALCLRB_coherency_registerW_extend27_offset27_registerZ_triple;
              case 0x00000002:
                return Opcode_lvx_v1_ASWAPB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000004:
                return Opcode_lvx_v1_ALADDB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000005:
                return Opcode_lvx_v1_ALANDB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000006:
                return Opcode_lvx_v1_ALIORB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000007:
                return Opcode_lvx_v1_ALEORB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000008:
                return Opcode_lvx_v1_ALMINB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000009:
                return Opcode_lvx_v1_ALMAXB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000000a:
                return Opcode_lvx_v1_ALMINUB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000000b:
                return Opcode_lvx_v1_ALMAXUB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000000e:
                return Opcode_lvx_v1_ALDUSB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000010:
                return Opcode_lvx_v1_ASB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000014:
                return Opcode_lvx_v1_ASADDB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000015:
                return Opcode_lvx_v1_ASANDB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000016:
                return Opcode_lvx_v1_ASIORB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000017:
                return Opcode_lvx_v1_ASEORB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000018:
                return Opcode_lvx_v1_ASMINB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000019:
                return Opcode_lvx_v1_ASMAXB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000001a:
                return Opcode_lvx_v1_ASMINUB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000001b:
                return Opcode_lvx_v1_ASMAXUB_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000001e:
                return Opcode_lvx_v1_ASDUSB_coherency_extend27_offset27_registerZ_registerT_triple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              return Opcode_lvx_v1_ACSWAPB_boolcas_coherency_registerW_extend27_offset27_registerZ_registerO_triple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 7) & 0x0000001f) {
              case 0x00000000:
                return Opcode_lvx_v1_ALH_coherency_registerW_extend27_offset27_registerZ_triple;
              case 0x00000001:
                return Opcode_lvx_v1_ALCLRH_coherency_registerW_extend27_offset27_registerZ_triple;
              case 0x00000002:
                return Opcode_lvx_v1_ASWAPH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000004:
                return Opcode_lvx_v1_ALADDH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000005:
                return Opcode_lvx_v1_ALANDH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000006:
                return Opcode_lvx_v1_ALIORH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000007:
                return Opcode_lvx_v1_ALEORH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000008:
                return Opcode_lvx_v1_ALMINH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000009:
                return Opcode_lvx_v1_ALMAXH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000000a:
                return Opcode_lvx_v1_ALMINUH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000000b:
                return Opcode_lvx_v1_ALMAXUH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000000e:
                return Opcode_lvx_v1_ALDUSH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000010:
                return Opcode_lvx_v1_ASH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000014:
                return Opcode_lvx_v1_ASADDH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000015:
                return Opcode_lvx_v1_ASANDH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000016:
                return Opcode_lvx_v1_ASIORH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000017:
                return Opcode_lvx_v1_ASEORH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000018:
                return Opcode_lvx_v1_ASMINH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000019:
                return Opcode_lvx_v1_ASMAXH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000001a:
                return Opcode_lvx_v1_ASMINUH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000001b:
                return Opcode_lvx_v1_ASMAXUH_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000001e:
                return Opcode_lvx_v1_ASDUSH_coherency_extend27_offset27_registerZ_registerT_triple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              return Opcode_lvx_v1_ACSWAPH_boolcas_coherency_registerW_extend27_offset27_registerZ_registerO_triple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 7) & 0x0000001f) {
              case 0x00000000:
                return Opcode_lvx_v1_ALW_coherency_registerW_extend27_offset27_registerZ_triple;
              case 0x00000001:
                return Opcode_lvx_v1_ALCLRW_coherency_registerW_extend27_offset27_registerZ_triple;
              case 0x00000002:
                return Opcode_lvx_v1_ASWAPW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000004:
                return Opcode_lvx_v1_ALADDW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000005:
                return Opcode_lvx_v1_ALANDW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000006:
                return Opcode_lvx_v1_ALIORW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000007:
                return Opcode_lvx_v1_ALEORW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000008:
                return Opcode_lvx_v1_ALMINW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000009:
                return Opcode_lvx_v1_ALMAXW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000000a:
                return Opcode_lvx_v1_ALMINUW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000000b:
                return Opcode_lvx_v1_ALMAXUW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000000e:
                return Opcode_lvx_v1_ALDUSW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000010:
                return Opcode_lvx_v1_ASW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000014:
                return Opcode_lvx_v1_ASADDW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000015:
                return Opcode_lvx_v1_ASANDW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000016:
                return Opcode_lvx_v1_ASIORW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000017:
                return Opcode_lvx_v1_ASEORW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000018:
                return Opcode_lvx_v1_ASMINW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000019:
                return Opcode_lvx_v1_ASMAXW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000001a:
                return Opcode_lvx_v1_ASMINUW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000001b:
                return Opcode_lvx_v1_ASMAXUW_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000001e:
                return Opcode_lvx_v1_ASDUSW_coherency_extend27_offset27_registerZ_registerT_triple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              return Opcode_lvx_v1_ACSWAPW_boolcas_coherency_registerW_extend27_offset27_registerZ_registerO_triple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000000:
              switch ((codeWord_0 >> 7) & 0x0000001f) {
              case 0x00000000:
                return Opcode_lvx_v1_ALD_coherency_registerW_extend27_offset27_registerZ_triple;
              case 0x00000001:
                return Opcode_lvx_v1_ALCLRD_coherency_registerW_extend27_offset27_registerZ_triple;
              case 0x00000002:
                return Opcode_lvx_v1_ASWAPD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000004:
                return Opcode_lvx_v1_ALADDD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000005:
                return Opcode_lvx_v1_ALANDD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000006:
                return Opcode_lvx_v1_ALIORD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000007:
                return Opcode_lvx_v1_ALEORD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000008:
                return Opcode_lvx_v1_ALMIND_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000009:
                return Opcode_lvx_v1_ALMAXD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000000a:
                return Opcode_lvx_v1_ALMINUD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000000b:
                return Opcode_lvx_v1_ALMAXUD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000000e:
                return Opcode_lvx_v1_ALDUSD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000010:
                return Opcode_lvx_v1_ASD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000014:
                return Opcode_lvx_v1_ASADDD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000015:
                return Opcode_lvx_v1_ASANDD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000016:
                return Opcode_lvx_v1_ASIORD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000017:
                return Opcode_lvx_v1_ASEORD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000018:
                return Opcode_lvx_v1_ASMIND_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x00000019:
                return Opcode_lvx_v1_ASMAXD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000001a:
                return Opcode_lvx_v1_ASMINUD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000001b:
                return Opcode_lvx_v1_ASMAXUD_coherency_extend27_offset27_registerZ_registerT_triple;
              case 0x0000001e:
                return Opcode_lvx_v1_ASDUSD_coherency_extend27_offset27_registerZ_registerT_triple;
              default:
                break;
              }
              return Opcode__UNDEF;
            case 0x00000001:
              return Opcode_lvx_v1_ACSWAPD_boolcas_coherency_registerW_extend27_offset27_registerZ_registerO_triple;
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000004:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            switch ((codeWord_0 >> 6) & 0x00000001) {
            case 0x00000001:
              switch ((codeWord_0 >> 18) & 0x00000001) {
              case 0x00000000:
                return Opcode_lvx_v1_ACSWAPQ_boolcas_coherency_registerM_extend27_offset27_registerZ_registerQ_triple;
              default:
                break;
              }
              return Opcode__UNDEF;
            default:
              break;
            }
            return Opcode__UNDEF;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000038:
    switch ((codeWord_1 >> 29) & 0x00000007) {
    case 0x00000004:
      switch ((codeWord_0 >> 16) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 24) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MAKE_registerW_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_PCREL_registerW_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ADDD_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_SBFD_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x00000039:
    switch ((codeWord_1 >> 29) & 0x00000007) {
    case 0x00000004:
      switch ((codeWord_0 >> 16) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 24) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MIND_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MAXD_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MINUD_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_MAXUD_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000003a:
    switch ((codeWord_1 >> 29) & 0x00000007) {
    case 0x00000004:
      switch ((codeWord_0 >> 16) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 24) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ANDD_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_NANDD_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_IORD_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_NIORD_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  case 0x0000003b:
    switch ((codeWord_1 >> 29) & 0x00000007) {
    case 0x00000004:
      switch ((codeWord_0 >> 16) & 0x00000003) {
      case 0x00000000:
        switch ((codeWord_0 >> 24) & 0x00000003) {
        case 0x00000000:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_EORD_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000001:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_NEORD_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000002:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_ANDND_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_IORND_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
          break;
        }
        return Opcode__UNDEF;
      case 0x00000001:
        switch ((codeWord_0 >> 24) & 0x00000003) {
        case 0x00000002:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_SBMM8D_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        case 0x00000003:
          switch ((codeWord_2 >> 29) & 0x00000003) {
          case 0x00000000:
            return Opcode_lvx_v1_SBMMT8D_registerW_registerZ_extend27_upper27_lower10_triple;
          default:
            break;
          }
          return Opcode__UNDEF;
        default:
          break;
        }
        return Opcode__UNDEF;
      default:
        break;
      }
      return Opcode__UNDEF;
    default:
      break;
    }
    return Opcode__UNDEF;
  default:
    break;
  }
  return Opcode__UNDEF;
}
#endif//NDECODE


#!/usr/bin/env ruby



module GDBTarget 

  # Defines a register file name order.
  def ordered_regfiles()
    # GPR is before PGR, etc...
    return [ "GPR", "PGR", "QGR", "SFR", "XCR", "XBR", "XVR", "XTR", "XMR", "X2R", "X4R", "X8R", "X16R", "X32R", "X64R", "RV_BIR", "RV_FPR" ]
  end

end

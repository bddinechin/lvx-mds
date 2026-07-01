#!/usr/bin/perl -w
# Machine Description System (MDS)
#

package Target;

my $Family = $ENV{FAMILY};
my $core = $ENV{CORE};
my $family = lc $Family;

use strict;
use Carp;

# Return a hash table with pseudo storage names and associated register list
# Used in Register.pl to list register fields.
sub extra_register_bitfields {
    my $es_stepi = {
"v1" => [ "ES_EC", "ES_OAPL", "ES_ORPL", "ES_PTAPL", "ES_PTRPL", "ES_DC", "ES_BN", "ES_WN", "ES_SFRI", "ES_GPRP", "ES_SFRP", "ES_DHT", "ES_RWX", "ES_NTA", "ES_UCA", "ES_AS", "ES_BS", "ES_DRI", "ES_PIC" ],
"v2" => [ "ES_EC", "ES_OAPL", "ES_ORPL", "ES_PTAPL", "ES_PTRPL", "ES_DCV2", "ES_WBN", "ES_SFRI", "ES_GPRP", "ES_SFRP", "ES_DHT", "ES_DRX", "ES_DAF", "ES_RWX", "ES_NTA", "ES_UCA", "ES_AS", "ES_BS", "ES_DRI", "ES_PIC" ],
      };

    return {
"ES-TRAP"      => [ "ES_EC", "ES_OAPL", "ES_ORPL", "ES_PTAPL", "ES_PTRPL", "ES_HTC", "ES_SFRT", "ES_SFRI", "ES_GPRP", "ES_SFRP", "ES_DHT", "ES_RWX", "ES_NTA", "ES_UCA", "ES_AS", "ES_BS", "ES_DRI", "ES_PIC" ],
"ES-INTERRUPT" => [ "ES_EC", "ES_OAPL", "ES_ORPL", "ES_PTAPL", "ES_PTRPL", "ES_ITN", "ES_ITL", "ES_ITI" ],
"ES-SYSCALL"   => [ "ES_EC", "ES_OAPL", "ES_ORPL", "ES_PTAPL", "ES_PTRPL", "ES_SN" ],
        "ES-STEPI"     => $$es_stepi{$core},
      }
}

1;
# vim: set ts=4 sw=4 et:


package GBU;

use strict;

use Carp;

our %order;

sub Init {
    # Create %order for BundlingIDs.
    my $nBundlings = 1;
    foreach my $bundling (@Bundling::table) {
        my $bundlingID = $bundling->attribute("ID");
        $order{$bundlingID} = $nBundlings++;
    }
}
sub getModifierCombinatory {
    my ($modifiers, $modifiers_proxies, $modifiers_key, $operand_names, $modifiers_names, $modifiers_bitstring, $proxies, $proxy_id , @name_ids) = @_;

    if($proxy_id == scalar(@$proxies)  ) {
        $$modifiers{$modifiers_key}{proxies} = join(' ',@$proxies);
        $$modifiers{$modifiers_key}{names} = lc($modifiers_names);
        $$modifiers{$modifiers_key}{opnd_names} = $operand_names;
        $$modifiers{$modifiers_key}{coding} = $modifiers_bitstring;
        return;
    }

    my $proxy = @$proxies[$proxy_id];
    my @names = split(' ',$$modifiers_proxies{$proxy}{names});
    my @values = split(' ',$$modifiers_proxies{$proxy}{values});
    my $value = $values[$name_ids[$proxy_id]];
    my $operand = $$modifiers_proxies{$proxy}{operand};
    my $operand_name = $operand->name();
    my $new_bitstring =     $modifiers_bitstring->clone();
    my @bitfields = $operand->access("fields");

    foreach my $field (sort { $a->attribute("offset") <=> $b->attribute("offset") } @bitfields) {
        $new_bitstring->insert($field,$value);
        $value = $value >> $field->attribute("width");
    }

    &getModifierCombinatory($modifiers, $modifiers_proxies, $modifiers_key."_$names[$name_ids[$proxy_id]]",
        $operand_names." $operand_name",$modifiers_names." $names[$name_ids[$proxy_id]]",
        $new_bitstring, $proxies, $proxy_id+1 , @name_ids);

    if($name_ids[$proxy_id] + 1 == scalar(@names)) {
        return;
    }

    $name_ids[$proxy_id]++;
    &getModifierCombinatory($modifiers, $modifiers_proxies, $modifiers_key, $operand_names, $modifiers_names,$modifiers_bitstring, $proxies, $proxy_id , @name_ids );

}

sub getModifiers {
    my ($coding_size,@operands) = @_;
    my %modifier_proxies;
    my %modifiers;
    my $opnd_id = 1;

    foreach my $operand (@operands) {
        if($operand->attribute("method") =~ /^Modifier/) {
            my $proxy = "%".$opnd_id;
            my $method = MDS::fetch($operand->attribute("method"));
            my @names = split ' ', $method->attribute("members");
            $modifier_proxies{$proxy}{names} = join ' ', @names;
            $modifier_proxies{$proxy}{values} = $method->attribute("values");
            $modifier_proxies{$proxy}{operand} = $operand;
        }
        $opnd_id++;
    }
    if(scalar keys %modifier_proxies) {
        my $encoded_dummy;
        map { $encoded_dummy .= "-"; } (0..$coding_size-1);
        my $bitstring = BitString->new(0, $encoded_dummy);
        my @name_ids;
        for(my $i=0; $i < scalar(keys %modifier_proxies); $i++) {
            $name_ids[$i] = 0;
        }

        &getModifierCombinatory(\%modifiers, \%modifier_proxies, "", "", "", $bitstring, [ sort keys %modifier_proxies ], 0 , @name_ids);
    }

    return \%modifiers;
}

1;
# vim: set ts=4 sw=4 et:

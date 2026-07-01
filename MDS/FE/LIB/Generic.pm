#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2005 STMicroelectronics
#
# Benoit Dupont de Dinechin (Benoit.Dupont-de-Dinechin@st.com).
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


use MDS;

sub makeGeneric_0_0 {
    my ($name, $attributes) = @_;
    MDS::make("Generic", {
            ID=>	&Generic::ID($name),
            mnemonic=>	$name,
            attributes=>	$attributes,
            syntax=>	"%0",
        })->emit();
}

sub makeGeneric_1_0 {
    my ($name, $attributes) = @_;
    MDS::make("Generic", {
            ID=>	&Generic::ID($name),
            mnemonic=>	$name,
            attributes=>	$attributes,
            syntax=>	"%0 %1",
        }, [
            MDS::make("Parameter", {
                    action=>	"Write",
                    method=>	&RegClass::ID(""),
                    proxy=>	"%1",
                }),
        ])->emit();
}

sub makeGeneric_1_1 {
    my ($name, $attributes) = @_;
    MDS::make("Generic", {
            ID=>	&Generic::ID($name),
            mnemonic=>	$name,
            attributes=>	$attributes,
            syntax=>	"%0 %1 = %2",
        }, [
            MDS::make("Parameter", {
                    action=>	"Write",
                    method=>	&RegClass::ID(""),
                    proxy=>	"%1",
                }),
            MDS::make("Parameter", {
                    action=>	"Read",
                    method=>	&RegClass::ID(""),
                    proxy=>	"%2",
                }),
        ])->emit();
}

sub makeGeneric_1_2 {
    my ($name, $attributes) = @_;
    MDS::make("Generic", {
            ID=>	&Generic::ID($name),
            attributes=>	$attributes,
            mnemonic=>	$name,
            syntax=>	"%0 %1 = %2, %3",
        }, [
            MDS::make("Parameter", {
                    action=>	"Write",
                    method=>	&RegClass::ID(""),
                    proxy=>	"%1",
                }),
            MDS::make("Parameter", {
                    action=>	"Read",
                    method=>	&RegClass::ID(""),
                    proxy=>	"%2",
                }),
            MDS::make("Parameter", {
                    action=>	"Read",
                    method=>	&RegClass::ID(""),
                    proxy=>	"%3",
                }),
        ])->emit();
}

sub makeGeneric_1_m {
    my ($name, $attributes) = @_;
    MDS::make("Generic", {
            ID=>	&Generic::ID($name),
            mnemonic=>	$name,
            attributes=>	$attributes,
            syntax=>	"%0",
        }, [
            MDS::make("Parameter", {
                    action=>	"Write",
                    method=>	&RegClass::ID(""),
                }),
            MDS::make("Parameter", {
                    action=>	"ReadList",
                    method=>	&RegClass::ID(""),
                }),
        ])->emit();
}

sub makeGeneric_n_0 {
    my ($name, $attributes) = @_;
    MDS::make("Generic", {
            ID=>	&Generic::ID($name),
            mnemonic=>	$name,
            attributes=>	$attributes,
            syntax=>	"%0",
        }, [
            MDS::make("Parameter", {
                    action=>	"WriteList",
                    method=>	&RegClass::ID(""),
                }),
        ])->emit();
}

sub makeGeneric_n_1 {
    my ($name, $attributes) = @_;
    MDS::make("Generic", {
            ID=>	&Generic::ID($name),
            mnemonic=>	$name,
            attributes=>	$attributes,
            syntax=>	"%0",
        }, [
            MDS::make("Parameter", {
                    action=>	"WriteList",
                    method=>	&RegClass::ID(""),
                }),
            MDS::make("Parameter", {
                    action=>	"Read",
                    method=>	&RegClass::ID(""),
                }),
        ])->emit();
}

sub makeGeneric_n_m {
    my ($name, $attributes) = @_;
    MDS::make("Generic", {
            ID=>	&Generic::ID($name),
            mnemonic=>	$name,
            attributes=>	$attributes,
            syntax=>	"%0",
        }, [
            MDS::make("Parameter", {
                    action=>	"WriteList",
                    method=>	&RegClass::ID(""),
                }),
            MDS::make("Parameter", {
                    action=>	"ReadList",
                    method=>	&RegClass::ID(""),
                }),
        ])->emit();
}

# Control-Flow Generic(s).

print MDS::make("Generic", {
        ID=>	&Generic::ID("ENTRY"),
        mnemonic=>	"ENTRY",
        attributes=>	"Pseudo",
        syntax=>	"%0 %1",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%1",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("LABEL"),
        mnemonic=>	"LABEL",
        attributes=>	"Pseudo",
        syntax=>	"%0 %1",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%1",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("FALLTO"),
        mnemonic=>	"FALLTO",
        attributes=>	"Pseudo Control",
        syntax=>	"%0 %1",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%1",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("LOOPTO"),
        mnemonic=>	"LOOPTO",
        attributes=>	"Pseudo Control",
        syntax=>	"%0 %1",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                usage=>	"Target",
                proxy=>	"%1",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("HWLOOP"),
        mnemonic=>	"HWLOOP",
        attributes=>	"Pseudo Control",
        syntax=>	"%0 %1",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                usage=>	"Target",
                proxy=>	"%1",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("HWLNEZ"),
        mnemonic=>	"HWLNEZ",
        attributes=>	"Pseudo Control Conditional",
        syntax=>	"%0 %1 %2",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%2",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("HWLGTZ"),
        mnemonic=>	"HWLGTZ",
        attributes=>	"Pseudo Control Conditional",
        syntax=>	"%0 %1 %2",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%2",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("GOTO"),
        mnemonic=>	"GOTO",
        attributes=>	"Control",
        syntax=>	"%0 %1",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%1",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("IFTRUE"),
        mnemonic=>	"IFTRUE",
        attributes=>	"Control Conditional",
        syntax=>	"%0 %1 %2",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%2",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("IFFALSE"),
        mnemonic=>	"IFFALSE",
        attributes=>	"Control Conditional",
        syntax=>	"%0 %1 %2",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%2",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("IFNEZ"),
        mnemonic=>	"IFNEZ",
        attributes=>	"Control Conditional",
        syntax=>	"%0 %1 %2",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%2",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("IFEQZ"),
        mnemonic=>	"IFEQZ",
        attributes=>	"Control Conditional",
        syntax=>	"%0 %1 %2",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%2",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("IFLTZ"),
        mnemonic=>	"IFLTZ",
        attributes=>	"Control Conditional",
        syntax=>	"%0 %1 %2",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%2",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("IFGEZ"),
        mnemonic=>	"IFGEZ",
        attributes=>	"Control Conditional",
        syntax=>	"%0 %1 %2",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%2",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("IFLEZ"),
        mnemonic=>	"IFLEZ",
        attributes=>	"Control Conditional",
        syntax=>	"%0 %1 %2",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%2",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("IFGTZ"),
        mnemonic=>	"IFGTZ",
        attributes=>	"Control Conditional",
        syntax=>	"%0 %1 %2",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%2",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("IFODD"),
        mnemonic=>	"IFODD",
        attributes=>	"Control Conditional",
        syntax=>	"%0 %1 %2",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%2",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("IFEVEN"),
        mnemonic=>	"IFEVEN",
        attributes=>	"Control Conditional",
        syntax=>	"%0 %1 %2",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%2",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("JUMP"),
        mnemonic=>	"JUMP",
        attributes=>	"Control",
        syntax=>	"%0 %1",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                usage=>	"Target",
                proxy=>	"%1",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("CALL"),
        mnemonic=>	"CALL",
        attributes=>	"Control",
        syntax=>	"%0 %1",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&Immediate::ID(""),
                usage=>	"Target",
                proxy=>	"%1",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("LINK"),
        mnemonic=>	"LINK",
        attributes=>	"Control",
        syntax=>	"%0 %1",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                usage=>	"Target",
                proxy=>	"%1",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("RETURN"),
        mnemonic=>	"RETURN",
        attributes=>	"Control",
        syntax=>	"%0",
    })->emit();

# SSA-Form Generic(s).

print &makeGeneric_1_m("PHI", "Pseudo");
print &makeGeneric_1_m("PSI", "Pseudo");
print &makeGeneric_n_1("SIGMA", "Pseudo");
print &makeGeneric_n_0("KILL", "Pseudo");
print &makeGeneric_n_m("PCOPY");
print &makeGeneric_n_m("ECOPY");
print &makeGeneric_n_m("LCOPY");
print &makeGeneric_1_1("COPY");

# Arithmetic Generic(s)

print &makeGeneric_0_0("SKIP");
print &makeGeneric_1_1("LNOT");
print &makeGeneric_1_1("BNOT");
print &makeGeneric_1_1("NEG");
print &makeGeneric_1_2("ADD");
print &makeGeneric_1_2("SUB");
print &makeGeneric_1_2("MUL");
print &makeGeneric_1_2("DIV");
print &makeGeneric_1_2("REM");
print &makeGeneric_1_2("SHL");
print &makeGeneric_1_2("ASHR");
print &makeGeneric_1_2("LSHR");
print &makeGeneric_1_2("LAND");
print &makeGeneric_1_2("LIOR");
print &makeGeneric_1_2("LXOR");
print &makeGeneric_1_2("BAND");
print &makeGeneric_1_2("BIOR");
print &makeGeneric_1_2("BXOR");
print &makeGeneric_1_2("MIN");
print &makeGeneric_1_2("MAX");
print &makeGeneric_1_2("SELECT");
print &makeGeneric_1_m("APPLY");
print &makeGeneric_1_m("TEST");

# Open64 Generic(s).

print MDS::make("Generic", {
        ID=>	&Generic::ID("FWDBAR"),
        mnemonic=>	"FWDBAR",
        attributes=>	"Pseudo",
        syntax=>	"%0",
    })->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("BWDBAR"),
        mnemonic=>	"BWDBAR",
        attributes=>	"Pseudo",
        syntax=>	"%0",
    })->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("IFIXUP"),
        mnemonic=>	"IFIXUP",
        attributes=>	"Pseudo",
        syntax=>	"%0 %1 =",
    }, [
        MDS::make("Parameter", {
                action=>	"Write",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("BEGIN_PREGTN"),
        attributes=>	"Pseudo",
        mnemonic=>	"BEGIN_PREGTN",
        syntax=>	"%0 %1",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
    ])->emit();

print MDS::make("Generic", {
        ID=>	&Generic::ID("END_PREGTN"),
        attributes=>	"Pseudo",
        mnemonic=>	"END_PREGTN",
        syntax=>	"%0 %1",
    }, [
        MDS::make("Parameter", {
                action=>	"Read",
                method=>	&RegClass::ID(""),
                proxy=>	"%1",
            }),
    ])->emit();

1;

# vim: set ts=4 sw=4 et:

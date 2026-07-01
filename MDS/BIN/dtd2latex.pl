#!/usr/bin/perl -w

local $/ = "";
while (<>) {
    print "\n";
    my $verbatim = 0;
    my @lines = split /\n/;
    foreach my $line (@lines) {
        $line =~ /^\<\!\-\-/ && next;
        $line =~ /^\-\-\>/ && next;
        $line =~ /^\</ && !$verbatim && do {
            print "\n\\begin{verbatim}\n$line\n";
            $verbatim = 1;
            next;
          };
        $line =~ /^\>/ && $verbatim && do {
            print "$line\n\\end{verbatim}\n\n";
            $verbatim = 0;
            next;
          };
        if ($verbatim) {
            # Expand tabs see Perl Cookbook 1.7.
            while ($line =~ s/\t+/' ' x (length($&)*8 - length($`)%8)/e) { }
        } else {
            $line =~ s/<section\s*title="(.*?)"\s*\/>/\\section{$1}\n\n/g;
            $line =~ s/<subsection\s*title="(.*?)"\s*\/>/\\subsection{$1}\n\n/g;
            $line =~ s/<dfn>(.*?)<\/dfn>/\\subsubsection{$1} \\label{sec:$1}\n\n/g;
            $line =~ s/<description>/\\noindent Description:\\begin{itemize}/g;
            $line =~ s/<\/description>/\\end{itemize}/g;
            $line =~ s/<term>/\\item[]\\emph{/g;
            $line =~ s/<\/term>/}/g;
            $line =~ s/<code>/\\texttt{/g;
            $line =~ s/<\/code>/}/g;
            $line =~ s/([_%<>])/\\$1/g;
        }
        print $line, "\n";
    }
}

# vim: set ts=4 sw=4 et:

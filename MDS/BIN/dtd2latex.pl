#!/usr/bin/perl -w

local $/ = "";
while (<>) {
    print "\n";
    my $verbatim = 0;
    my @lines = split /\n/;
    foreach my $line (@lines) {
        $line =~ /^\<\!\-\-/ && next;
        $line =~ /^\-\-\>/ && next;
        # A markup declaration (<!ELEMENT/<!ATTLIST/...) opens a verbatim block.
        # Match <! rather than a bare < so a documentation tag (<description>,
        # <term>, ...) that happens to sit in column 0 stays prose instead of
        # being swallowed as verbatim (which used to drop its \end{itemize}).
        $line =~ /^<!/ && !$verbatim && do {
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
            # Escape the LaTeX specials that survive into prose.  The tag
            # substitutions above only ever emit \ { } [ ] _ , so escaping these
            # here cannot corrupt them.  ( { } \ in prose are an inherent limit
            # of this regex approach and are left alone -- avoid them in comments.)
            $line =~ s/([&#\$_%<>])/\\$1/g;
            $line =~ s/~/\\textasciitilde{}/g;
            $line =~ s/\^/\\textasciicircum{}/g;
        }
        print $line, "\n";
    }
    # A declaration whose closing '>' is on the same line (e.g. <!ELEMENT X
    # EMPTY>) opens verbatim without a '>'-only line to close it; close any
    # dangling verbatim at the end of the paragraph so the LaTeX stays balanced.
    if ($verbatim) {
        print "\\end{verbatim}\n\n";
        $verbatim = 0;
    }
}

# vim: set ts=4 sw=4 et:

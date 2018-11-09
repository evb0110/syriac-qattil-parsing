my constant $syr_file = 'peshitta.txt';
my $btime = now;

my $qattil_file = 'qattiil_list.txt';
my @qattil_info = $qattil_file.IO.lines;

my %qattils; # hash with qattil => root

for @qattil_info -> $qattil_line {
  my ($root, $qattils) =
      $qattil_line.split('|')[0, 1]
      ;
  %qattils{$_} =   # qtyl as keys, qtl as values
      $root.trim
      for $qattils.words
      ;
}

my @qattils = %qattils.keys;

my $setqattils = @qattils.Set;
my Regex $belongs =
    rx/  . * <?{ ~$/ (elem) $setqattils }> /;
#`(
 /
)

my @qattils-y = @qattils.grep:
          {
      .substr(*-1) eq 'y' # ends in y
         and
      .chars == 3         # and has 3 letters
          };
my @qattils-s = keys @qattils (-) @qattils-y;
                           #sound qattils
my $qattils-s_set = @qattils-s.Set;
my $qattils-y_set = @qattils-y.Set;

my $endings-s = Q{
  # ending-s
            # qattil abs.
           ''    =>  "ms_abs"
           ʔ     =>  "fs_abs"
           yn    =>  "mpl_abs"
           n     =>  "fpl_abs"
            # qattil emph.
           ʔ     =>  "ms_emph"
           tʔ    =>  "fs_emph"
           ʔ     =>  "mpl_emph"
           tʔ    =>  "fpl_emph"
            # qattil cstr.
           ''    =>  "ms_cstr"
           t     =>  "fs_cstr"
           y     =>  "mpl_cstr"
           t     =>  "fpl_cstr"
            # qattil + encl.
           t     =>  "2ms+encl"
           nʔ    =>  "1ms+encl"
           ty    =>  "2fs+encl"
           nʔ    =>  "1fs+encl"
           ytwn  =>  "2mpl+encl"
           ynn   =>  "1mpl+encl"
           tyn   =>  "2fpl+encl"
           nn    =>  "1fpl+encl"
            # qattila + suff.
           y     =>  "qtylʔ+suff_1sg"
           k     =>  "qtylʔ+suff_2ms"
           ky    =>  "qtylʔ+suff_2fs"
           h     =>  "qtylʔ+suff_3ms"
           h     =>  "qtylʔ+suff_3fs"
           n     =>  "qtylʔ+suff_1pl"
           kwn   =>  "qtylʔ+suff_2mpl"
           kyn   =>  "qtylʔ+suff_2fpl"
           hwn   =>  "qtylʔ+suff_3mpl"
           hyn   =>  "qtylʔ+suff_3fpl"
            # qattilta/qattilata + suff.
           ty    =>  "qtyltʔ+suff_1sg"
           tk    =>  "qtyltʔ+suff_2ms"
           tky   =>  "qtyltʔ+suff_2fs"
           th    =>  "qtyltʔ+suff_3ms"
           th    =>  "qtyltʔ+suff_3fs"
           tn    =>  "qtyltʔ+suff_1pl"
           tkwn  =>  "qtyltʔ+suff_2mpl"
           tkyn  =>  "qtyltʔ+suff_2fpl"
           thwn  =>  "qtyltʔ+suff_3mpl"
           thyn  =>  "qtyltʔ+suff_3fpl"
            # qattile + suff.
            y    =>  "qtyleʔ+suff_1sg"
           yk    =>  "qtyleʔ+suff_2ms"
           yky   =>  "qtyleʔ+suff_2fs"
           why   =>  "qtyleʔ+suff_3ms"
           yh    =>  "qtyleʔ+suff_3fs"
           yn    =>  "qtyleʔ+suff_1pl"
           ykwn  =>  "qtyleʔ+suff_2mpl"
           ykyn  =>  "qtyleʔ+suff_2fpl"
           yhwn  =>  "qtyleʔ+suff_3mpl"
           yhyn  =>  "qtyleʔ+suff_3fpl"
}   ;

my $endings-y = Q{
   # ending-y
            # qattil abs.
           ''    =>  "ms_abs"
           ʔʔ    =>  "fs_abs"
           ʔyn   =>  "mpl_abs"
           ʔn    =>  "fpl_abs"
            # qattil emph.
           ʔʔ    =>  "ms_emph"
           ʔtʔ   =>  "fs_emph"
           ʔʔ    =>  "mpl_emph"
           ʔtʔ   =>  "fpl_emph"
             # qattil cstr.
           ''    =>  "ms_cstr"
           ʔt    =>  "fs_cstr"
           ʔy    =>  "mpl_cstr"
           ʔt    =>  "fpl_cstr"
            # qattil + encl.
           ʔt    =>  "2ms+encl"
           ʔnʔ   =>  "1ms+encl"
           ʔty   =>  "2fs+encl"
           ʔnʔ   =>  "1fs+encl"
           ʔytwn =>  "2mpl+encl"
           ʔynn  =>  "1mpl+encl"
           ʔtyn  =>  "2fpl+encl"
           ʔnn   =>  "1fpl+encl"
            # qattila + suff.
           ʔy    =>  "qtylʔ+suff_1sg"
           ʔk    =>  "qtylʔ+suff_2ms"
           ʔky   =>  "qtylʔ+suff_2fs"
           ʔh    =>  "qtylʔ+suff_3ms"
           ʔh    =>  "qtylʔ+suff_3fs"
           ʔn    =>  "qtylʔ+suff_1pl"
           ʔkwn  =>  "qtylʔ+suff_2mpl"
           ʔkyn  =>  "qtylʔ+suff_2fpl"
           ʔhwn  =>  "qtylʔ+suff_3mpl"
           ʔhyn  =>  "qtylʔ+suff_3fpl"
            # qattilta/qattilata + suff.
           ʔty   =>  "qtyltʔ+suff_1sg"
           ʔtk   =>  "qtyltʔ+suff_2ms"
           ʔtky  =>  "qtyltʔ+suff_2fs"
           ʔth   =>  "qtyltʔ+suff_3ms"
           ʔth   =>  "qtyltʔ+suff_3fs"
           ʔtn   =>  "qtyltʔ+suff_1pl"
           ʔtkwn =>  "qtyltʔ+suff_2mpl"
           ʔtkyn =>  "qtyltʔ+suff_2fpl"
           ʔthwn =>  "qtyltʔ+suff_3mpl"
           ʔthyn =>  "qtyltʔ+suff_3fpl"
            # qattile + suff.
           ʔy    =>  "qtyleʔ+suff_1sg"
           ʔyk   =>  "qtyleʔ+suff_2ms"
           ʔyky  =>  "qtyleʔ+suff_2fs"
           ʔwhy  =>  "qtyleʔ+suff_3ms"
           ʔyh   =>  "qtyleʔ+suff_3fs"
           ʔyn   =>  "qtyleʔ+suff_1pl"
           ʔykwn =>  "qtyleʔ+suff_2mpl"
           ʔykyn =>  "qtyleʔ+suff_2fpl"
           ʔyhwn =>  "qtyleʔ+suff_3mpl"
           ʔyhyn =>  "qtyltʔ+suff_3fpl"
}     ;

my @endings-s_lines = $endings-s.lines.grep:
          * ~~ / '=>' /;
my @endings-y_lines = $endings-y.lines.grep:
          * ~~ / '=>' /;

my %endings-s;
for @endings-s_lines {
  my Pair $pair = "$_".EVAL;
  %endings-s.push($pair);
}

my %endings-y;
for @endings-y_lines {
  my Pair $pair = "$_".EVAL;
  %endings-y.push($pair);
}

my Set $endings-s_set = %endings-s.Set;
my Set $endings-y_set = %endings-y.Set;



my grammar Qattil {   # BEGIN GRAMMAR
    my %match;
    my $tag;

    regex TOP {
        <before>
        <main>
        $
        {
        %match<word>      = ~$/;
        %match<before>    = ~$<before>;
        %match<inflected> = ~$<main>;
        %match<base>      = ~$<main><qattil>;
        %match<ending>    = ~$<main><ending>;
        %match<tag>       = $tag;
       take {%match}  # match info exported
        }
       <!>  # makes grammar fail and backtrack
    }

    regex before {
         [b|d|l|w] *
    }

    regex main {
         | <qattil=qattil-s>
           <ending=ending-s>

         | <qattil=qattil-y>
           <ending=ending-y>
    }


    regex qattil-s {
         . +
         <?{ ~$/ (elem) $qattils-s_set }>
    }
    regex qattil-y {
         . +
         <?{ ~$/ (elem) $qattils-y_set }>
    }

    regex ending-s {
         . +
         <?{ ~$/ (elem) $endings-s_set }>
         { $tag = %endings-s{$/} }
    }

    regex ending-y {
         . +
         <?{ ~$/ (elem) $endings-y_set }>
         { $tag = %endings-y{$/} }
    }


}   # END GRAMMAR


say 'Grammar evaluated ', now - $btime; #cc


# INPUT of the source text
my @syr_words = $syr_file.IO.words;
say 'Syriac file read ', now - $btime; #cc
@syr_words .= unique;
say 'Syriac words made unique ', now - $btime; #cc
# INPUT END

my $letters = "ʔbgdhwzḥṭyklmnsʕpṣqršt";
my Regex $prohib =     # any other symbol is prohibited
        "/<-[$letters]>/".EVAL
   ;
@syr_words .= map({ $_ ~~ s:g/$prohib//; $_ });
say 'Syriac words, removed prohibited symbols ', now - $btime; #cc
@syr_words .= grep: * ~~ $belongs;
say 'Syriac words left only candidates ', now - $btime; #cc




for @syr_words -> $string { # STRING LOOP

  my Hash @results;
  @results = gather Qattil.parse($string);
  next unless @results;

  my $format = "%-12s %-10s\n";

  for @results {   # OUTPUT
    printf $format, "-word:", $_<word>;
    printf $format, " before:", $_<before>;
    printf $format, " inflected:", $_<inflected>;
    printf $format, " base:", $_<base>;
    printf $format, " root:", %qattils{$_<base>};
    printf $format, " ending:", $_<ending>;
    say " tags: ", join ', ', $_<tag>.words;
    say '';
  }                # END OUTPUT

}  # END STRING LOOP

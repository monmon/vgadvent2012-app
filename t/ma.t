use strict;
use warnings;
use utf8;
use Test::More;
use FindBin;
use MyApp;
use MyApp::Ma;
use Data::Dumper;

subtest '_flatten' => sub {
    my @word_list = (
        {
            surface  => "dummy",
            baseform => "dummy",
            reading  => "dummy"
        },
        {
            surface  => "dummy",
            baseform => "dummy",
            reading  => "dummy"
        },
    );

    my $ma = MyApp::Ma->new({
        ma => {
            appid => 'dummy',
        },
    });

    my @flattened = $ma->_flatten(@word_list);
    is_deeply \@flattened, [qw(dummy)], 'uniq';
};

subtest 'to string' => sub {
    my $ma = MyApp::Ma->new({
        ma => {
            appid => 'dummy',
        },
    });
    my $str = $ma->_to_string(qw(
        a
        b
        '
        c
        "
        d
    ));

    is $str, 'a b c d', 'except sign';
};

subtest 'parse' => sub {
    my $sentence = 'Perl CPANモジュールガイド',
    my %expected = map { $_ => 1 } qw(Perl CPAN もじゅーる モジュール がいど ガイド);

    my $ma = MyApp::Ma->new(
        MyApp->new(appdir => "$FindBin::Bin/../")->setting,
    );

    my $words = $ma->parse($sentence);

    my %words_exists = map { $_ => 1 } split /\s/, $words;
    is_deeply \%words_exists, \%expected, 'parse';
};

done_testing;

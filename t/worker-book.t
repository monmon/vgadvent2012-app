use strict;
use warnings;
use utf8;
use Test::More;
use FindBin;
use MyApp;
use MyApp::Worker::Book;
use Data::Dumper;

subtest '_create_data' => sub {
    my $isbn = '9784862671080';
    my $expected = {
        isbn         => $isbn,
        asin         => '486267108X',
        title        => 'Perl CPANモジュールガイド',
        author       => '冨田尚樹',
        manufacturer => 'ワークスコーポレーション',
        words        => 'Perl CPAN もじゅーる モジュール ガイド がいど つみた 冨田 尚樹 なおき わーくす こーぽれーしょん ワークス コーポレーション',
    };

    my $worker = MyApp::Worker::Book->new(
        appdir => "$FindBin::Bin/../",
        setting => MyApp->new(appdir => "$FindBin::Bin/../")->setting,
    );

    my $data = $worker->_create_data($isbn);
    is_deeply $data, $expected, 'data';
};

done_testing;

use strict;
use warnings;
use utf8;
use Test::More;
use DBI;
use MyApp::Data::Book;
use Data::Dumper;

my $dbh = DBI->connect('dbi:SQLite:','','', {
    PrintError => 0,
    RaiseError => 1,
    ShowErrorStatement => 1,
    sqlite_unicode => 1,
    sqlite_use_immediate_transaction => 1,
});

{
    $dbh->do(q|
        CREATE VIRTUAL TABLE book USING fts4(
            isbn,
            asin,
            title,
            author,
            manufacturer,
            words
        )
    |);
}

subtest 'insert' => sub {
    my $isbn = '9784862671080';
    my $book = MyApp::Data::Book->new($dbh);
    my $is_saved = $book->insert(
        isbn         => $isbn,
        asin         => '486267108X',
        title        => 'Perl CPANモジュールガイド',
        author       => '冨田尚樹',
        manufacturer => 'ワークスコーポレーション',
        words        => 'Perl CPANモジュールガイド',
    );

    my $row_ref = $dbh->selectrow_hashref('SELECT * FROM book');
    ok $is_saved, 'return value';
    ok $row_ref, 'exists';
    is $row_ref->{isbn}, $isbn, 'check data';

    $dbh->do(q{ DELETE FROM book });
};

subtest 'find by isbn' => sub {
    my $isbn = '9784862671080';
    my $book = MyApp::Data::Book->new($dbh);
    $book->insert(
        isbn         => $isbn,
        asin         => '486267108X',
        title        => 'Perl CPANモジュールガイド',
        author       => '冨田尚樹',
        manufacturer => 'ワークスコーポレーション',
        words        => 'Perl CPANモジュールガイド',
    );

    my $row_ref = $book->find_by_isbn($isbn);
    ok $row_ref, 'exists';
    is $row_ref->{isbn}, $isbn, 'check data';

    $dbh->do(q{ DELETE FROM book });
};

subtest 'find using match' => sub {
    my $isbn = '9784862671080';
    my $word = 'perl',
    my $book = MyApp::Data::Book->new($dbh);
    $book->insert(
        isbn         => $isbn,
        asin         => '486267108X',
        title        => 'Perl CPANモジュールガイド',
        author       => '冨田尚樹',
        manufacturer => 'ワークスコーポレーション',
        words        => 'Perl CPANモジュールガイド',
    );

    my $rows_ref = $book->find_all_using_match($word);
    ok $rows_ref, 'exists';
    is $rows_ref->[0]->{isbn}, $isbn, 'check data';

    $dbh->do(q{ DELETE FROM book });
};

subtest 'duplicate' => sub {
    my $isbn = '9784862671080';
    my %data = (
        isbn         => $isbn,
        asin         => '486267108X',
        title        => 'Perl CPANモジュールガイド',
        author       => '冨田尚樹',
        manufacturer => 'ワークスコーポレーション',
        words        => 'Perl CPANモジュールガイド',
    );
    my $book = MyApp::Data::Book->new($dbh);
    $book->insert(%data);

    my $is_saved = $book->insert(%data); # one more

    ok !$is_saved, 'duplicate';

    $dbh->do(q{ DELETE FROM book });
};

done_testing;

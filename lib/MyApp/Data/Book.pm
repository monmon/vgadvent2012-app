package MyApp::Data::Book;
use strict;
use warnings;
use Carp qw(croak);
use utf8;
use DBI;

sub new {
    my $class = shift;
    my $db = shift;

    my $self = bless {}, $class;
    $self->{dbh} = (ref $db) ? $db : $self->dbh($db);

    $self;
}

sub dbh {
    my $self = shift;
    my $db = shift;

    $self->{dbh} ||= do {
        DBI->connect("dbi:SQLite:$db", '', '');
    };
}

sub insert {
    my $self = shift;
    my %args = @_;

    croak "isbn needed" unless $args{isbn};

    return if $self->find_by_isbn($args{isbn});

    my @column = qw(isbn asin title author manufacturer words);
    $self->dbh->do(qq|
        INSERT INTO book
            ( @{[ join ',', @column ]} )
        VALUES
            ( @{[ join ',', map {'?'} @column ]} )
    |, undef, @args{@column});
}

sub find_by_isbn {
    my $self = shift;
    my $isbn = shift;

    $self->dbh->selectrow_hashref(qq|
        SELECT * FROM book
            where isbn = ?
    |, undef, $isbn);
}

sub find_all_using_match {
    my $self = shift;
    my $word = shift;

    $self->dbh->selectall_arrayref(qq|
        SELECT * FROM book WHERE book MATCH ?
    |, {Slice => +{}}, $word);
}

1;

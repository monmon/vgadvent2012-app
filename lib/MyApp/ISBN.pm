package MyApp::ISBN;
use strict;
use warnings;
use utf8;
use Carp qw(croak);
use Moo;
use List::Util qw(first);
use URI::Amazon::APA;
use LWP::UserAgent;
use XML::Simple;

has key           => (is => 'ro');
has secret        => (is => 'ro');
has associate_tag => (is => 'ro');

our $ENDPOINT = 'http://ecs.amazonaws.jp/onca/xml';

sub BUILDARGS {
    my($class, $setting) = @_;

    my %setting = map {
        $_ => $setting->{isbn}->{$_};
    } keys %{ $setting->{isbn} };

    \%setting;
}

sub find {
    my $self = shift;
    my $isbn = shift;

    my $u = URI::Amazon::APA->new($ENDPOINT);
    $u->query_form(
        AssociateTag => $self->associate_tag,
        Service      => 'AWSECommerceService',
        Operation    => 'ItemLookup',
        IdType       => 'ISBN',
        SearchIndex  => 'Books',
        ItemId       => $isbn,
    );
    $u->sign(
        key    => $self->key,
        secret => $self->secret,
    );
    
    my $ua = LWP::UserAgent->new;
    my $r  = $ua->get($u);
    
    croak "$isbn: $r->status_line, $r->as_string" if !$r->is_success;

    my $res = XMLin($r->content);
    my $book = $self->_pick_up_book($res);
    croak "cannot find book: $isbn" unless $book;

    +{
        isbn => $isbn,
        %{$book},
    };
}

sub _pick_up_book {
    my $self = shift;
    my $data = shift;

    my $book = $data->{Items}->{Item};

    if (ref $book eq 'ARRAY') {
        $book = first {
            $_->{ItemAttributes}->{ProductGroup} eq 'Book';
        } @{$book};
        return +{} unless $book;
    }

    +{
        asin         => $book->{ASIN},
        title        => $book->{ItemAttributes}->{Title},
        author       => $book->{ItemAttributes}->{Author},
        manufacturer => $book->{ItemAttributes}->{Manufacturer},
    };
}

1;

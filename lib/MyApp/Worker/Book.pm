package MyApp::Worker::Book;
use strict;
use warnings;
use Moo;
use MyApp::ISBN;
use MyApp::Ma;
use MyApp::Data::Book;

has appdir => (is => 'ro');
has setting => (is => 'ro');

sub work {
    my($self, $job) = @_;

    $self
        ->_create_data($job->{arg})
        ->_save;
}

sub _create_data {
    my($self, $isbn) = @_;

    my $book = MyApp::ISBN->new($self->setting)->find($isbn);
    my $ma = MyApp::Ma->new($self->setting);
    my @parsed_list;
    for my $k (qw/title author manufacturer/) {
        push @parsed_list, $ma->parse($book->{$k});
    }
    my $words = join " ", @parsed_list;

    $self->{data} = {
        words => $words,
        %{$book},
    };

    $self;
}

sub _save {
    my $self = shift;

    my $dao = MyApp::Data::Book->new($self->setting->{data}->{db});
    $dao->insert(%{ $self->{data} });
}

1;

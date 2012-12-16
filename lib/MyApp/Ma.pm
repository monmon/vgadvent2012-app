package MyApp::Ma;
use strict;
use warnings;
use utf8;
use Carp qw(croak);
use Moo;
use WebService::YahooJapan::WebMA;

$WebService::YahooJapan::WebMA::APIBase = 'http://jlp.yahooapis.jp/MAService/V1/parse';

has appid => (is => 'ro');

sub BUILDARGS {
    my($class, $setting) = @_;

    +{
        appid => $setting->{ma}->{appid},
    };
}

sub parse {
    my $self = shift;
    my $sentence = shift;

    my $api = WebService::YahooJapan::WebMA->new(
        appid => $self->appid,
    );
     
    my $res = $api->parse(
        sentence => $sentence,
        ress  => 'ma',
        response => 'surface,reading,baseform',
    ) or croak $api->error;
    my @word_list = (ref $res->{ma_result}->{word_list} eq 'ARRAY')
        ? @{$res->{ma_result}->{word_list}}
        : ($res->{ma_result}->{word_list});
     
    $self->_to_string($self->_flatten(@word_list));
}

sub _flatten {
    my $self = shift;
    my @word_list = @_;

    my %h;
    for my $word (@word_list) {
        for my $key (qw/surface reading baseform/) {
            next if ref $word->{$key};
            $h{ $word->{$key} }++;
        }
    }
    
    keys \%h;
}

sub _to_string {
    my $self = shift;
    my @word_list = @_;

    my $words = join " ", @word_list;
    $words =~ s/[^\w\s]//g;
    $words =~ s/(\s)+/$1/g;
    $words;
}

1;

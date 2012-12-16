package MyApp;
use strict;
use warnings;
use Carp qw(croak);
use Moo;

use JSON::Any;

has appdir => (is => 'ro');

sub setting {
    my $self = shift;

    my $file = $self->appdir . 'config/setting.json';
    open my $rfh, '<', $file
        or croak "cannot open $file: $!";
    my $setting = do { local $/; <$rfh> };
    close $rfh;

    JSON::Any->new->decode($setting);
}

1;

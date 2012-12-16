use strict;
use warnings;
use utf8;
use Test::More;
use MyApp::ISBN;
use Data::Dumper;

subtest 'setting' => sub {
    my $setting = {
        isbn => {
            key           => 'dummy',
            secret        => 'dummy',
            associate_tag => 'dummy',
        },
    };

    my $isbn = MyApp::ISBN->new($setting);
    for my $p (qw/key secret associate_tag/) {
        is $isbn->$p, $setting->{isbn}->{$p}, 'check property'; 
    }
};

subtest 'case: contain eBook' => sub {
    my $data = {
        Items => {
            Item => [{
                ASIN => '4063878252',
                ItemAttributes => {
                    ProductGroup => 'Book',
                    Manufacturer => 'dummy',
                    Title => 'dummy',
                    Author => 'dummy',
                },
            }, {
                ASIN => 'B00A2MD8Z0',
                ItemAttributes => {
                    ProductGroup => 'eBooks',
                    Manufacturer => 'dummy',
                    Title => 'dummy',
                    Author => 'dummy',
                },
            }],
        },
    };

    my $isbn = MyApp::ISBN->new({
        isbn => {
            key           => 'dummy',
            secret        => 'dummy',
            associate_tag => 'dummy',
        },
    });

    my $book = $isbn->_pick_up_book($data);
    is $book->{asin}, $data->{Items}->{Item}->[0]->{ASIN}, 'except eBook';
};

done_testing;

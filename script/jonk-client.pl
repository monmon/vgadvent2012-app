#!perl
use strict;
use warnings;
use FindBin;
use DBI;
use Jonk::Client;

use lib "$FindBin::Bin/../lib";
use MyApp;

my $setting = MyApp->new(appdir => "$FindBin::Bin/../")->setting;

my $dbh = DBI->connect("dbi:SQLite:$setting->{jonk}->{db}",'','');
my $jonk = Jonk::Client->new($dbh);

while (1) {
    print 'input ISBN: ';
    next if <STDIN> !~ m/(\d+)/xms;

    my $isbn = $1;
    my $job_id = $jonk->enqueue('Book', $isbn);
    print "enqueued job_id: $job_id\n";
}

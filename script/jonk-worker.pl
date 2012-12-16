#!perl
use strict;
use warnings;
use FindBin;
use DBI;
use Jonk::Worker;

use lib "$FindBin::Bin/../lib";
use MyApp;
use MyApp::Worker::Book;

my $setting = MyApp->new(appdir => "$FindBin::Bin/../")->setting;

my $dbh = DBI->connect("dbi:SQLite:$setting->{jonk}->{db}",'','');
my $jonk = Jonk::Worker->new($dbh => {functions => [qw/Book/]});
my $worker = MyApp::Worker::Book->new(
    appdir => "$FindBin::Bin/../",
    setting => $setting,
);

while (1) {
    if (my $job = $jonk->dequeue) {
        warn "work job: $job->{arg}\n";
        $worker->work($job);
    } else {
        sleep(3); # wait for 3 sec.
    }
}

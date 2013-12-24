#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Spreadsheet::CSV();
use IO::File();

plan tests => 18;

foreach my $file_name (qw(missing_worksheet.xlsx missing_content.ods missing_mimetype.ods unknown_mimetype.ods bad_archive.xlsx bad_gzip.gnumeric)) {
	my $handle = IO::File->new('t/data/corrupt/' . $file_name) or die "Screaming:$!";
	binmode $handle;
	my $spreadsheet = Spreadsheet::CSV->new();
	my $result = $spreadsheet->getline($handle);
	ok(not(defined $result), "getline returned not defined on corrupt content");
	ok($spreadsheet->eof() eq '', "eof returned false");
	ok($spreadsheet->error_diag() =~ /^(XML|ZIP|GZIP)\ \-\ /, "Correctly detects corruption in spreadsheet '$file_name':" . $spreadsheet->error_diag());
}

1;

#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Spreadsheet::CSV();
use IO::File();

plan tests => 18;

foreach my $file_name (qw(shared_strings.xlsx workbook.xlsx worksheet.xlsx content.ods content.sxc sample.gnumeric)) {
	my $handle = IO::File->new('t/data/bombs/' . $file_name) or die "Screaming:$!";
	my $spreadsheet = Spreadsheet::CSV->new();
	my $result = $spreadsheet->getline($handle);
	ok(not(defined $result), "getline returned not defined on an XML bomb");
	ok($spreadsheet->eof() eq '', "eof returned false");
	ok($spreadsheet->error_diag() =~ /^XML - Invalid XML:XML Entities have been detected and rejected in the XML, due to security concerns/, "Correctly detects XML bomb in $file_name");
}

1;


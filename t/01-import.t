#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More;
use Spreadsheet::CSV();
use IO::File();

plan tests => 336;

my %expected_content_types = ( ods => 'application/vnd.oasis.opendocument.spreadsheet',
				sxc => 'application/vnd.sun.xml.calc',
				xls => 'application/vnd.ms-excel',
				gnumeric => 'application/x-gnumeric',
				xlsx => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
				csv => 'text/csv',
				ksp => 'application/x-kspread',
			);

foreach my $suffix (qw(ods sxc xls gnumeric xlsx csv ksp)) {
	my $handle = IO::File->new('t/data/sample.' . $suffix) or die "Screaming:$!";
	binmode $handle;
	my $spreadsheet = Spreadsheet::CSV->new();
	my $number_of_lines = 0;
	my $row = $spreadsheet->getline($handle);
	my $expected = [
          'Product Code',
          'Product Name',
          'List Price Type',
          'List Price',
          'List Price Currency',
          'List Price Unit',
          'Amount per List Price Unit',
          'Purchase Price Type',
          'Purchase Price',
          'Purchase Price Currency',
          'Purchase Price Unit',
          'Amount per Purchase Price Unit',
          'Batch Level Tracking',
          'Tax Category',
          'Status'
        ];
	my $index = 0;
	foreach my $expected (@{$expected}) {
		ok($expected eq $row->[$index], "Column $index of Row 1 matched correctly for $suffix.  Expected '$expected'.  Got '$row->[$index]'");
		$index += 1;
	}
	$row = $spreadsheet->getline($handle);
	$expected = [
          'WIDGET1',
          'Super Cool Widget!',
          'Exclusive',
          '20.54',
          'EUR',
          'EACH',
          '1',
          'Inclusive',
          '10.54',
          'AUD',
          'BOX10',
          '10',
          'No',
          'GST',
          'Active'
        ];
	if ($suffix eq 'xls') {
		if ($Config::Config{uselongdouble}) {
			$expected->[3] = 20.5399999999999991;
			$expected->[8] = 10.5399999999999991;
		}
	}
	$index = 0;
	foreach my $expected (@{$expected}) {
		ok($expected eq $row->[$index], "Column $index of Row 2 matched correctly for $suffix.  Expected '$expected'.  Got '$row->[$index]'");
		$index += 1;
	}
	$row = $spreadsheet->getline($handle);
	$expected = [
          'Amazing-PIPE!',
          'There is nothing this Pipe cannot do!',
          'Exclusive',
          '100000',
          'JPY',
          'cm',
          '10',
          'Inclusive',
          '2.23',
          'USD',
          'M',
          '1000',
          'No',
          'EXEMPT',
          'Active'
        ];
	if ($suffix eq 'xls') {
		if ($Config::Config{uselongdouble}) {
			$expected->[8] = 2.22999999999999998;
		}
	}
	$index = 0;
	foreach my $expected (@{$expected}) {
		ok($expected eq $row->[$index], "Column $index of Row 3 matched correctly for $suffix.  Expected '$expected'.  Got '$row->[$index]'");
		$index += 1;
	}
	ok(not(defined $spreadsheet->getline($handle)), "Only three rows in the $suffix spreadsheet");
	$spreadsheet->eof() or $spreadsheet->error_diag();
	ok($spreadsheet->suffix() eq $suffix, "suffix() should have returned '$suffix' and actually returned '" . $spreadsheet->suffix() . "'");
	ok($spreadsheet->content_type() eq $expected_content_types{$suffix}, "content_type() should have returned '$expected_content_types{$suffix}' and actually returned '" . $spreadsheet->content_type()  ."'");
}

1;


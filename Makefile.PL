use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Spreadsheet::CSV',
    AUTHOR           => q{David Dick <ddick@cpan.org>},
    VERSION_FROM     => 'lib/Spreadsheet/CSV.pm',
    ABSTRACT_FROM    => 'lib/Spreadsheet/CSV.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Fcntl' => 0,
        'Spreadsheet::ParseExcel' => 0,
        'Text::CSV_XS' => 0,
        'Archive::Zip' => 0,
        'XML::Parser' => 0,
        'English' => 0,
        'Compress::Zlib' => 0,
        'Carp' => 0,
        'IO::File' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Spreadsheet-CSV-*' },
);

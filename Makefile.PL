use 5.008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'FLDBM',
    'VERSION_FROM'	=> 'FLDBM.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'FLDBM.pm', # retrieve abstract from module
       AUTHOR     => 'Michael J. Flickinger <mjflick@cpan.org>') : ()),
);

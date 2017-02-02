use 5.024000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'KongApi',
    VERSION_FROM      => 'lib/KongApi.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => {Moo => 2}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/KongApi.pm', # retrieve abstract from module
    AUTHOR            => 'Alexander Beloglazov <abelogla@buffalo.edu>',
    LICENSE           => 'GPL3',
    #Value must be from legacy list of licenses here
    #http://search.cpan.org/perldoc?Module%3A%3ABuild%3A%3AAPI
);

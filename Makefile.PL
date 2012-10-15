use 5.014002;
use ExtUtils::MakeMaker;

unless(eval{require Parse::RecDescent}){
    print "Please install Parse::RecDescent first.\n";
    exit;
}

`perl -MParse::RecDescent - grammar/assembler.grammar Tower::Assembler::Parser; mv Parser.pm lib/Tower/Assembler/`;

exit unless -s 'lib/Tower/Assembler/Parser.pm';

WriteMakefile(
    NAME              => 'Tower',
    VERSION_FROM      => 'lib/Tower.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Tower.pm', # retrieve abstract from module
       AUTHOR         => 'terrencehan <hanliang1990@gmail.com>') : ()),
);


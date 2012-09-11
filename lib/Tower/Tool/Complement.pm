package Tower::Tool::Complement;

our @ISA = qw/Exporter/;

our @EXPORT = qw/to_decimal/;
#our @EXPORT_OK = qw/to_decimal/;

sub to_decimal{
    my $num = hex shift;
    my $result = 0;
    if($num & (1 << 31)){
        $result = - 2 ** 31;
    }
    for my $i (0 .. 30){
        if($num & (1 << $i)){
            $result += 2 ** $i;
        }
    }
    return $result;
}

1;

__END__

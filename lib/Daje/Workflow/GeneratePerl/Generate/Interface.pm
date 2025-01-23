package Daje::Workflow::GeneratePerl::Generate::Interface;
use Mojo::Base 'Daje::Workflow::GeneratePerl::Base::Common' ,-base, -signatures;

use String::CamelCase qw(camelize);


our $VERSION = '0.01';


has 'config' ;
has 'templates';
has 'table' ;

sub generate($self) {
    $self->table = camelize($table);

    return if $self->_interface_exists($table);

    my $tpl = $self->templates->get_data_section('interface');
    my $name_space = $config->{CLASS}->{name_space};
    my $interface = $config->{CLASS}->{name_interface};
    my $date = localtime();

    $tpl =~ s/<<date>>/$date/ig;
    $tpl =~ s/<<interface>>/$interface/ig;
    $tpl =~ s/<<classname>>/$table/ig;
    $tpl =~ s/<<name_space>>/$name_space/ig;

    my $output = Daje::Generate::Output::Perl::Class->new(
        config         => $config,
        table_name     => $table,
        perl           => $tpl,
        name_space_dir => "interface_space_dir",
    );
    $output->save_file();
}

sub _interface_exists(self->, $table){
    my $result = 0;

    my $interface_space_dir = $config->{PATH}->{interface_space_dir} . $table . ".pm";
    if ( -e $interface_space_dir) {
        $result = 1;
    }

    return $result;
}

1;
#################### pod generated by Pod::Autopod - keep this line to make pod updates possible ####################

=head1 NAME

lib::Daje::Generate::Perl::Generate::Interface - lib::Daje::Generate::Perl::Generate::Interface


=head1 REQUIRES

L<String::CamelCase> 

L<feature> 

L<v5.40> 


=head1 METHODS


=cut


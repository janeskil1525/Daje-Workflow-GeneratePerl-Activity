package Daje::Generate::Perl::PerlManager
use Mojo::Base 'Daje::Generate::Perl::Base::Common', -base, -signatures;

use Daje::Workflow::GeneratePerl::Generate::Fields;
use Daje::Workflow::GeneratePerl::Generate::Methods;
use Daje::Workflow::GeneratePerl::Generate::Class;
#use Daje::Workflow::Generate::Output::Perl::Class;
#use Daje::Workflow::Generate::Perl::Generate::BaseClass;
#use Daje::Workflow::Generate::Perl::Generate::Interface;

our $VERSION = '0.01';

has 'success' ;
has 'config' ;

sub generate_classes($self) {
    $self->_base_class();
    my $length = scalar @{$self->json->{tables}};
    for (my $i = 0; $i < $length; $i++) {
        $self->_generate_table_class(@{$self->json->{tables}}[$i]);
        $self->_generate_interface_class(@{$self->json->{tables}}[$i]->{table}->{table_name});
    }
    $length = scalar $self->json->{views};
    for (my $i = 0; $i < $length; $i++) {
        $self->_generate_view_class(@{$self->json->{views}}[$i]);
    }
    return 1;
}

sub _generate_interface_class($self, $table_name) {
    my $template = $self->template();
    Daje::Generate::Perl::Generate::Interface->new(
        template => $template,
        config   => $config,
        table    => $table_name,
    )->generate();
}

sub _base_class($self) {
    my $template = $self->template();
    Daje::Generate::Perl::Generate::BaseClass->new(
        template => $template,
        config   => $config,
    )->generate();

}

sub _generate_table_class($self, $table) {
    my $fields = $self->_get_fields($table);
    my $methods = $self->_methods($fields, $table);
    my $perl = $self->_class($methods, $table, $fields);
    $self->_save_class($perl, $table->{table});
}

sub _save_class($self, $perl, $table) {

    # my $output = Daje::Generate::Output::Perl::Class->new(
    #     config         => $config,
    #     table_name     => $table->{table_name},
    #     perl           => $perl,
    #     name_space_dir => "name_space_dir",
    # );
    # $output->save_file();
}

sub _class($self, $methods, $table, $fields) {
    my $template = $self->template();
    my $class = Daje::Workflow::GeneratePerl::Generate::Class->new(
        json     => $table->{table},
        methods  => $methods,
        template => $template,
        config   => $config,
        fields   => $fields,
    );
    my $perl = $class->generate();

    return $perl;
}

sub _methods($self, $fields, $table) {
    my $template = $self->template();
    my $methods = Daje::Generate::Perl::Generate::Methods->new(
        json     => $table->{table},
        fields   => $fields,
        template => $template
    );
    $methods->generate();

    return $methods;
}

sub _generate_view_class($self, $view) {
    $view = $view;
}

sub _get_fields($self, $json) {
    my $template = $self->template();
    my $fields = Daje::Workflow::GeneratePerl::Generate::Fields->new(
        json     => $json->{table},
        template => $template
    );
    $fields->generate();
    return $fields;
}

1;

#################### pod generated by Pod::Autopod - keep this line to make pod updates possible ####################

=head1 NAME

lib::Daje::Generate::Perl::PerlManager - lib::Daje::Generate::Perl::PerlManager


=head1 DESCRIPTION

pod generated by Pod::Autopod - keep this line to make pod updates possible ####################


=head1 REQUIRES

L<Daje::Generate::Perl::Generate::Interface> 

L<Daje::Generate::Perl::Generate::BaseClass> 

L<Daje::Generate::Output::Perl::Class> 

L<Daje::Generate::Perl::Generate::Class> 

L<Daje::Generate::Perl::Generate::Methods> 

L<Daje::Generate::Perl::Generate::Fields> 

L<feature> 

L<v5.40> 


=head1 METHODS


=cut


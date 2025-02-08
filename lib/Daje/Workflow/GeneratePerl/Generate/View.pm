package Daje::Workflow::GeneratePerl::Generate::View;
use Mojo::Base 'Daje::Workflow::GeneratePerl::Base::Common' ,-base, -signatures;


our $VERSION = '0.01';

has 'select' ;
has 'primary_keys' ;
has 'foreign_keys';

sub generate($self) {
    my $column_names = $self->json->{column_names};

}
1;
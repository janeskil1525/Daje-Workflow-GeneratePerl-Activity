package Daje::Workflow::GeneratePerl::Generate::Fields;
use Mojo::Base 'Daje::Workflow::GeneratePerl::Base::Common', -base, -signatures;

# NAME
# ====
#
# Daje::Workflow::GeneratePerl::Generate::Fields -
#
#
# REQUIRES
# ========
#
#    use Mojo::Base
#
#
# METHODS
# =======
#
#


our $VERSION = '0.01';


has 'select' ;
has 'primary_key' ;
has 'foreign_keys';

sub generate($self) {
    my $column_names = $self->json->{column_names};
    my $length = scalar @{$column_names};
    for (my $i = 0; $i < $length; $i++) {
        if (index(@{$column_names}[$i]->{column_name},'_pkey') > -1){
            $self->primary_key = @{$column_names}[$i]->{column_name};
        }
        if (index(@{$column_names}[$i]->{column_name},'_fkey') > -1){
            push (@{$self->foreign_keys}, @{$column_names}[$i]->{column_name});
        }
        if (length($self->select) > 0) {
            $self->select .= ", '" . @{$column_names}[$i]->{column_name} . "'";
        } else {
            $self->select = "'" . @{$column_names}[$i]->{column_name} . "'";
        }
    }
}

1;
#################### pod generated by Pod::Autopod - keep this line to make pod updates possible ####################




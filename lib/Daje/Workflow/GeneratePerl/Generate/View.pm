package Daje::Workflow::GeneratePerl::Generate::View;
use Mojo::Base 'Daje::Workflow::GeneratePerl::Base::Common' ,-base, -signatures;


our $VERSION = '0.01';

has 'select' ;
has 'primary_keys' ;
has 'foreign_keys';
has 'primary_keys_arr' ;
has 'foreign_keys_arr';
has 'methods';

sub generate($self) {

    my $tpl = $self->templates->get_data_section('view_list_class');
    my $table_name = $self->json->{view}->{table_name};
    my $name_space = $self->context->{context}->{perl}->{name_space};
    my $base_name_space = $self->context->{context}->{perl}->{base_name_space};
    my $class_name = camelize($table_name);
    my $base_class_name = "Base";

    my $date = localtime();

    $self->_get_fields();
    $self->_keys();
    $self->_methods();
    my $methods = $self->methods();

    my $select_fields = $self->select();

    my $pkey = $self->primary_keys();
    my $fkey = $self->foreign_keys();

    $tpl =~ s/<<date>>/$date/ig;
    $tpl =~ s/<<fields>>/$select_fields/ig;
    $tpl =~ s/<<name_space>>/$name_space/ig;
    $tpl =~ s/<<classname>>/$class_name/ig;
    $tpl =~ s/<<base_name_space>>/$base_name_space/ig;
    $tpl =~ s/<<base_class_name>>/$base_class_name/ig;
    $tpl =~ s/<<pkey>>/$pkey/ig;
    $tpl =~ s/<<fkey>>/$fkey/ig;
    $tpl =~ s/<<methods>>/$methods/ig;

    return $tpl;

}

sub _methods($self) {
    my $tpl = $self->templates->get_data_section('load_from_fkey');
    my $sql = "";

    my $length = @{$self->primary_keys_arr};
    for(my $i = 0; $i < $length; $i++) {
        my $template = $tpl;
        my $key = @{$self->primary_keys_arr}[$i];
        $template =~ s/<<foreign_key>>/$key/ig;
        $sql .= $template
    }

    $length = @{$self->foreign_keys_arr};
    for(my $i = 0; $i < $length; $i++) {
        my $template = $tpl;
        my $key = @{$self->foreign_keys_arr}[$i];
        $template =~ s/<<foreign_key>>/$key/ig;
        $sql .= $template
    }
    $self->methods($sql);
}

sub _keys($self) {

    my $p_keys = "";
    my $length = @{$self->primary_keys_arr};
    for(my $i = 0; $i < $length; $i++) {
        if (length($p_keys)) {
            $p_keys .= ',' . @{$self->primary_keys_arr}[$i];
        } else {
            $p_keys = @{$self->primary_keys_arr}[$i];
        }
    }
    $self->primary_keys($p_keys);

    $p_keys = "";
    $length = @{$self->foreign_keys_arr};
    for(my $i = 0; $i < $length; $i++) {
        if (length($p_keys)) {
            $p_keys .= ',' . @{$self->primary_keys_arr}[$i];
        } else {
            $p_keys = @{$self->primary_keys_arr}[$i];
        }
    }
    $self->foreign_keys($p_keys);
}

sub _get_fields($self) {
    my $column_names = $self->json->{view}->{column_names};
    my $length = scalar @{$column_names};
    my @keys;
    my @pkeys;
    for (my $i = 0; $i < $length; $i++) {
        if (index(@{$column_names}[$i]->{column_name},'_pkey') > -1){
            push(@pkeys, @{$column_names}[$i]->{column_name});
        }
        if (index(@{$column_names}[$i]->{column_name},'_fkey') > -1){
            push (@keys, @{$column_names}[$i]->{column_name});
        }
        if (defined($self->select) and length($self->select) > 0) {
            my $select = $self->select();
            $self->select($select .= ", '" . @{$column_names}[$i]->{column_name} . "'");
        } else {
            $self->select("'" . @{$column_names}[$i]->{column_name} . "'");
        }
    }
    $self->foreign_keys_arr(\@keys) if @keys and scalar(@keys) > 0;
    $self->primary_key_arr(\@pkeys) if @pkeys and scalar(@pkeys) > 0;
}
1;

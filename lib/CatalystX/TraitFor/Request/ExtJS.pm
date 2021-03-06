package CatalystX::TraitFor::Request::ExtJS;
# ABSTRACT: Sets the request method via a query parameter
use Moose::Role;

use namespace::autoclean;
use JSON::XS;

#has 'is_ext_upload' => ( isa => 'Bool', is => 'rw', lazy_build => 1 );

sub is_ext_upload {
    my ($self) = @_;
    return $self->header('Content-Type')
      && $self->header('Content-Type') =~ /^multipart\/form-data/
      && ( !$self->{content_type} || $self->{content_type} ne 'application/json');
}

around 'method' => sub {
    my ( $orig, $self, $method ) = @_;
    return $self->$orig($method) if($method);
    return $self->query_params->{'x-tunneled-method'} || $self->$orig();
    

};

1;

__END__

=head1 METHODS

=head2 is_extjs_upload

Returns true if the current request looks like a request from ExtJS and has
multipart form data, so usually an upload. 

package WWW::MailboxOrg::API::Passwordreset;

# ABSTRACT: Password reset API

use Moo;
use MooX::Singleton;
use Carp qw(croak);
use Params::ValidationCompiler qw(validation_for);
use Types::Standard qw(Str);

our $VERSION = '0.001';

has client => (
    is       => 'ro',
    required => 1,
    weak_ref => 1,
);

sub _rpc {
    my ($self, $method, @params) = @_;
    my $client = $self->client or croak "No client set";
    return $client->call($method, @params);
}

my %validators = (
    request => validation_for(
        params => {
            account => { type => Str, optional => 0 },
        },
    ),
    set => validation_for(
        params => {
            account    => { type => Str, optional => 0 },
            token     => { type => Str, optional => 0 },
            newpassword => { type => Str, optional => 0 },
        },
    ),
);

sub request {
    my ($self, %params) = @_;
    my $v = $validators{'request'};
    %params = $v->(%params) if $v;
    return $self->_rpc('passwordreset.request', \%params);
}

sub set {
    my ($self, %params) = @_;
    my $v = $validators{'set'};
    %params = $v->(%params) if $v;
    return $self->_rpc('passwordreset.set', \%params);
}

1;

__END__

=head1 NAME

WWW::MailboxOrg::API::Passwordreset - Password reset API

=cut
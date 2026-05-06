package WWW::MailboxOrg::API::Videochat;

# ABSTRACT: Video chat API

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
    status => validation_for(
        params => {
            account => { type => Str, optional => 0 },
        },
    ),
    create_room => validation_for(
        params => {
            account => { type => Str, optional => 0 },
            name    => { type => Str, optional => 0 },
        },
    ),
    list_rooms => validation_for(
        params => {
            account => { type => Str, optional => 0 },
        },
    ),
    delete_room => validation_for(
        params => {
            account => { type => Str, optional => 0 },
            name    => { type => Str, optional => 0 },
        },
    ),
);

sub status {
    my ($self, %params) = @_;
    my $v = $validators{'status'};
    %params = $v->(%params) if $v;
    return $self->_rpc('videochat.status', \%params);
}

sub create_room {
    my ($self, %params) = @_;
    my $v = $validators{'create_room'};
    %params = $v->(%params) if $v;
    return $self->_rpc('videochat.create_room', \%params);
}

sub list_rooms {
    my ($self, %params) = @_;
    my $v = $validators{'list_rooms'};
    %params = $v->(%params) if $v;
    return $self->_rpc('videochat.list_rooms', \%params);
}

sub delete_room {
    my ($self, %params) = @_;
    my $v = $validators{'delete_room'};
    %params = $v->(%params) if $v;
    return $self->_rpc('videochat.delete_room', \%params);
}

1;

__END__

=head1 NAME

WWW::MailboxOrg::API::Videochat - Video chat API

=cut
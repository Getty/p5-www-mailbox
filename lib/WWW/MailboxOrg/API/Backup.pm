package WWW::MailboxOrg::API::Backup;

# ABSTRACT: Backup API

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
    list => validation_for(
        params => {
            account => { type => Str, optional => 0 },
        },
    ),
    create => validation_for(
        params => {
            account => { type => Str, optional => 0 },
        },
    ),
    restore => validation_for(
        params => {
            account => { type => Str, optional => 0 },
            backup  => { type => Str, optional => 0 },
        },
    ),
    delete => validation_for(
        params => {
            account => { type => Str, optional => 0 },
            backup  => { type => Str, optional => 0 },
        },
    ),
);

sub list {
    my ($self, %params) = @_;
    my $v = $validators{'list'};
    %params = $v->(%params) if $v;
    return $self->_rpc('backup.list', \%params);
}

sub create {
    my ($self, %params) = @_;
    my $v = $validators{'create'};
    %params = $v->(%params) if $v;
    return $self->_rpc('backup.create', \%params);
}

sub restore {
    my ($self, %params) = @_;
    my $v = $validators{'restore'};
    %params = $v->(%params) if $v;
    return $self->_rpc('backup.restore', \%params);
}

sub delete {
    my ($self, %params) = @_;
    my $v = $validators{'delete'};
    %params = $v->(%params) if $v;
    return $self->_rpc('backup.delete', \%params);
}

1;

__END__

=head1 NAME

WWW::MailboxOrg::API::Backup - Backup API

=cut
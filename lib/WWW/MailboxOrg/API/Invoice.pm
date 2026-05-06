package WWW::MailboxOrg::API::Invoice;

# ABSTRACT: Invoice API

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
            account => { type => Str, optional => 1 },
        },
    ),
    get => validation_for(
        params => {
            account => { type => Str, optional => 0 },
            invoice => { type => Str, optional => 0 },
        },
    ),
    download => validation_for(
        params => {
            account => { type => Str, optional => 0 },
            invoice => { type => Str, optional => 0 },
        },
    ),
);

sub list {
    my ($self, %params) = @_;
    my $v = $validators{'list'};
    %params = $v->(%params) if $v;
    return $self->_rpc('invoice.list', \%params);
}

sub get {
    my ($self, %params) = @_;
    my $v = $validators{'get'};
    %params = $v->(%params) if $v;
    return $self->_rpc('invoice.get', \%params);
}

sub download {
    my ($self, %params) = @_;
    my $v = $validators{'download'};
    %params = $v->(%params) if $v;
    return $self->_rpc('invoice.download', \%params);
}

1;

__END__

=head1 NAME

WWW::MailboxOrg::API::Invoice - Invoice API

=cut
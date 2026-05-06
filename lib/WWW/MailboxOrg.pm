package WWW::MailboxOrg;

# ABSTRACT: Perl client for Mailbox.org API

use Moo;
use Carp qw(croak);
use WWW::MailboxOrg::API::Base;
use WWW::MailboxOrg::API::Account;
use WWW::MailboxOrg::API::Domain;
use WWW::MailboxOrg::API::Mail;
use WWW::MailboxOrg::API::System;
use namespace::clean;

our $VERSION = '0.001';

=head1 SYNOPSIS

    use WWW::MailboxOrg;

    my $api = WWW::MailboxOrg->new(
        user     => 'test@example.tld',
        password => 'secret123',
    );

    # Authenticate and get session
    $api->login;

    # List accounts
    my $accounts = $api->account->list;

    # Get domain info
    my $domain = $api->domain->get(domain => 'example.com');

=head1 DESCRIPTION

WWW::MailboxOrg provides a Perl interface to the Mailbox.org API.
Uses JSON-RPC 2.0 over HTTPS with session-based authentication.

=cut

has user => (
    is       => 'ro',
    required => 1,
);

=attr user

Mailbox.org username or email address.

=cut

has password => (
    is       => 'ro',
    required => 1,
);

=attr password

Mailbox.org password.

=cut

has token => (
    is      => 'rwp',
    clearer => 1,
);

=attr token

Session token (HPLS-AUTH). Set after successful login.

=cut

has base_url => (
    is      => 'ro',
    default => 'https://api.mailbox.org/v1',
);

=attr base_url

Base URL for the API. Defaults to C<https://api.mailbox.org/v1>.

=cut

with 'WWW::MailboxOrg::Role::HTTP';

sub _set_auth_header {
    my ($self, $headers) = @_;
    $headers->{'HPLS-AUTH'} = $self->token if $self->token;
}

=method login

    $api->login;

Authenticate with username/password and store session token.

=cut

sub login {
    my ($self) = @_;

    my $result = $self->call('auth', {
        user => $self->user,
        pass => $self->password,
    });

    if (ref $result && $result->{session}) {
        $self->_set_token($result->{session});
        return $result;
    }

    croak "Login failed: " . ($result // 'no session returned');
}

=method logout

    $api->logout;

End the current session.

=cut

sub logout {
    my ($self) = @_;

    $self->call('deauth') if $self->token;
    $self->_clear_token;
}

sub DEMOLISH {
    my ($self) = @_;
    $self->logout if $self->token;
}

# Resource accessors
has base => (
    is      => 'lazy',
    builder => sub { WWW::MailboxOrg::API::Base->new(client => shift) },
);

=attr base

Returns L<WWW::MailboxOrg::API::Base> for auth and search.

=cut

has account => (
    is      => 'lazy',
    builder => sub { WWW::MailboxOrg::API::Account->new(client => shift) },
);

=attr account

Returns L<WWW::MailboxOrg::API::Account> for account management.

=cut

has domain => (
    is      => 'lazy',
    builder => sub { WWW::MailboxOrg::API::Domain->new(client => shift) },
);

=attr domain

Returns L<WWW::MailboxOrg::API::Domain> for domain management.

=cut

has mail => (
    is      => 'lazy',
    builder => sub { WWW::MailboxOrg::API::Mail->new(client => shift) },
);

=attr mail

Returns L<WWW::MailboxOrg::API::Mail> for email operations.

=cut

has system => (
    is      => 'lazy',
    builder => sub { WWW::MailboxOrg::API::System->new(client => shift) },
);

=attr system

Returns L<WWW::MailboxOrg::API::System> for system info (hello, test).

=cut

1;

__END__

=head1 SEE ALSO

L<https://api.mailbox.org/v1/doc/methods/index.html> - Mailbox.org API docs

=cut
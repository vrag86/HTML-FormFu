package HTML::FormFu::Constraint::AllOrNone;

use strict;
use warnings;
use base 'HTML::FormFu::Constraint';

use Storable qw/ dclone /;

__PACKAGE__->mk_accessors(qw/ others /);

sub process {
    my ( $self, $form_result, $params ) = @_;

    my $others = $self->others;
    return if !defined $others;

    my @names = ( $self->name );
    push @names, ref $others ? @{$others} : $others;
    my @errors;

    for my $name (@names) {
        my $seen;
        my $value = $params->{$name};
        if ( ref $value ) {
            eval { my @x = @$value };
            croak $@ if $@;

            $seen = 1 if grep {$_} $self->validate_values($value);
        }
        else {
            $seen = 1 if $self->validate_value($value);
        }

        push @errors, $self->error( { name => $name } )
            if !$seen;
    }

    return ( !@errors || scalar @errors == scalar @names )
        ? []
        : \@errors;
}

sub validate_value {
    my ( $self, $value ) = @_;

    return 0 if !defined $value || $value eq '';

    return 1;
}

sub clone {
    my $self = shift;
    
    my $clone = $self->SUPER::clone(@_);
    
    $clone->{others} = dclone $self->others if ref $self->others;
    
    return $clone;
}

1;

__END__

=head1 NAME

HTML::FormFu::Constraint::AllOrNone - AllOrNone constraint

=head1 SYNOPSIS

    $form->constraint( AllOrNone => 'foo' )->others( 'bar', 'baz' );

=head1 DESCRIPTION

Ensure that either all or none of the named fields are present.

This constraint doesn't honour the C<not()> value, as it wouldn't make much 
sense.

Is a sub-class of, and inherits methods from L<HTML::FormFu::Constraint>

L<HTML::FormFu::FormFu>

=head1 AUTHOR

Carl Franks C<cfranks@cpan.org>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.
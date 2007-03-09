package HTML::FormFu::Constraint::Word;

use strict;
use warnings;
use base 'HTML::FormFu::Constraint::Regex';

sub regex {
    return qr/^\w*\z/;
}

1;

__END__

=head1 NAME

HTML::FormFu::Constraint::Word - Single word constraint

=head1 SYNOPSIS

    $form->constraint( Word => 'foo' );

=head1 DESCRIPTION

Word constraint.

=head1 SEE ALSO

Is a sub-class of, and inherits methods from L<HTML::FormFu::Constraint::Regex>,
L<HTML::FormFu::Constraint>

L<HTML::FormFu::FormFu>

=head1 AUTHOR

Carl Franks C<cfranks@cpan.org>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.
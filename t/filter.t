use strict;
use warnings;

use Test::More tests => 6;

use HTML::FormFu;
use lib 't/lib';
use HTMLFormFu::TestLib;

my $form = HTML::FormFu->new;

$form->element('text')->name('foo');
$form->element('text')->name('bar');
$form->element('text')->name('bif')->constraint('Number');

$form->filter({
    type => 'HTMLEscape',
    names => [qw/ bar bif /],
    });

# bif is invalid, so the filter shouldn't get called
$form->filter({
    type => '+HTMLFormFu::MyTestFilterThatDies',
    name => 'bif',
    });

my $original_foo = qq{escape "this"};

my $original_bar = qq{escape "that"};
my $escaped_bar  = qq{escape &quot;that&quot;};

$form->process( {
        foo => $original_foo,
        bar => $original_bar,
        bif => "not a number",
    } );

# foo isn't quoted
is( $form->param('foo'), $original_foo );
is( $form->params->{foo}, $original_foo );

# bar
is( $form->param('bar'), $escaped_bar );
is( $form->params->{bar}, $escaped_bar );

# bif
ok( !defined( $form->param('bif') ) );
ok( !defined( $form->params->{bif} ) );
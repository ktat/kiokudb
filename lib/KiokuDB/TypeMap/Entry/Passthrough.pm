#!/usr/bin/perl

package KiokuDB::TypeMap::Entry::Passthrough;
use Moose;

use namespace::clean -except => 'meta';

with qw(KiokuDB::TypeMap::Entry);

has intrinsic => (
    isa => "Bool",
    is  => "ro",
    default => 0,
);

sub compile {
    my ( $self, @args ) = @_;

    if ( $self->intrinsic ) {
        return (
            sub {
                my ( $collapser, $obj ) = @_;
                return $obj;
            },
            sub {
                my ( $linker, $obj ) = @_;
                return $obj;
            },
        );
    } else {
        return (
            sub {
                my ( $collapser, @args ) = @_;

                $collapser->collapse_first_class(
                    sub {
                        my ( $collapser, %args ) = @_;
                        return $args{object};
                    },
                    @args,
                );
            },
            sub {
                my ( $linker, $entry ) = @_;
                return $entry->data;
            },
        );
    }
}

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__

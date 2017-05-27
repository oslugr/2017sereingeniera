#!/usr/bin/env perl

use strict;
use warnings;

use v5.20;

use Mojo::DOM qw(tree);
use LWP::Simple qw(get);
use File::Slurp::Tiny qw(read_lines);

my $file_name = shift || "list.txt";
my @list = read_lines($file_name );


my %number_of_followers;
for my $t (@list)  {
  chop($t);
  next if !$t;
  next if $t =~ /^[Nn]o/;
  if ( $t =~ m{witter.com/(\S+)} ) {
    $t = $1;
  }
  if ( $t =~ m{\@(\S+)}  ) {
    $t = $1 ;
  }
  my $page = get("https://twitter.com/$t");
  if ( !$page ) {
    say "Error con $t";
    next;
  }
  my $dom = Mojo::DOM->new( $page );
  my $followers = $dom->find("span.ProfileNav-value")->map( attr => 'data-count' );
  $number_of_followers{$t} = $followers->[2]; # Contiene el número de seguidores
}


for my $id ( sort { $number_of_followers{$b} <=> $number_of_followers{$a} } keys %number_of_followers ) {
  say "$id → $number_of_followers{$id}";
}

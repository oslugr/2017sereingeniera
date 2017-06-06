#!/usr/bin/env perl

use strict;
use warnings;

use v5.20;

use Mojo::DOM qw(tree);
use LWP::Simple qw(get);
use File::Slurp::Tiny qw(read_lines);

my $file_name = shift || "insta.txt";
my @list = read_lines($file_name );


my %number_of_followers;
for my $t (@list)  {
  chop($t);
  next if !$t or ( $t =~ /^[Nn]o/ ) or ( $t =~ /^[Ss]i$/ );
  if ( $t =~ m{agram.com/(\S+)} ) {
    $t = $1;
  }
  if ( $t =~ m{\@(\S+)}  ) {
    $t = $1 ;
  }
  my $page = get("https://instagram.com/$t");
  if ( !$page ) {
    say "Error con $t";
    next;
  }
  my ($followers ) = ($page =~ /"followed_by": {"count": (\d+)}/);
  $number_of_followers{$t} = $followers; # Contiene el número de seguidores
}


for my $id ( sort { $number_of_followers{$b} <=> $number_of_followers{$a} } keys %number_of_followers ) {
  say "$id → $number_of_followers{$id}";
}

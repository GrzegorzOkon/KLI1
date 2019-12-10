#################################################################
# Autor: Grzegorz Okoñ - g³ówny programista
#
# Sprawdzanie temperatur w serwerowniach. 
# Do dzia³ania niezbêdne jest u¿ycie modu³u Net::SNMP.
#################################################################

use strict;
use warnings;
use Net::SNMP;

my $console = $ARGV[0];
my @addresses=('x.x.x.x', 'y.y.y.y', 'z.z.z.z');
my %names=('x.x.x.x', "CA", 'y.y.y.y', "Celina", 'z.z.z.z', "TSM");
my $OID_temperature = '1.3.6.1.4.1.22925.489.3.1.4.1.1';
my $address = 0;
my $result = 0;

open (ETYKIETA_TEMPERATURY, ">KLI1.txt") || die "nie moge utworzyc pliku";
open (ETYKIETA_TEMPERATURY, ">>KLI1.txt") || die "nie moge zapisac do pliku";
print_header();

if (defined $console) {
   open (ETYKIETA_TEMPERATURY, ">&STDOUT") || die "nie moge utworzyc polaczenia do konsoli";
   print_header();
}

foreach $address (@addresses) {
   my ($session, $error) = Net::SNMP->session(
      -hostname  => $address,
      -timeout => 2,
   );

   if (!defined $session) {
      exit 1;
   }

   $result = $session->get_request(-varbindlist => [ $OID_temperature ],);

   if (!defined $result) {
      $session->close();
      exit 1;
   }

   open (ETYKIETA_TEMPERATURY, ">>KLI1.txt") || die "nie moge zapisac do pliku";
   write (ETYKIETA_TEMPERATURY);

   if (defined $console) {
      open (ETYKIETA_TEMPERATURY, ">&STDOUT") || die "nie moge utworzyc polaczenia do konsoli";
      write (ETYKIETA_TEMPERATURY);
   }

   $session->close();
}

sub print_header {
   print ETYKIETA_TEMPERATURY "serwerownia    temperatura\n-----------    -----------\n";
   return;
}

format ETYKIETA_TEMPERATURY =
@<<<<<<<       @<<<<   
$names{$address}, $result->{$OID_temperature} 
.
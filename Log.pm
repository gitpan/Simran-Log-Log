##################################################################################################################
# 
# Source  : $Source: /home/simran/cvs/cpan/Simran/Log/Log.pm,v $
# Revision: $Revision: 1.2 $ 
# Date    : $Date: 2000/04/26 04:28:08 $
# Author  : $Author: simran $
#
##################################################################################################################

package Simran::Log::Log;

use Simran::Error::Error;
use strict;
use Carp;
use FileHandle;

($Simran::Log::Log::VERSION = '$Revision: 1.2 $') =~ s/[^\d\.]//g;
my $error = new Simran::Error::Error({CARP => 1});

1;

##################################################################################################################

sub new {
  my $proto = shift;
  my $logfile = shift;
  my $class = ref($proto) || $proto;
  my $self  = {};
  
  $error->clear();

  $self->{LOGFILE}     = $logfile;
  $self->{FILE_HANDLE} = new FileHandle;

  bless ($self, $class);

  if (! $self->open()) {
    $error->set("Could not open logfile ".$self->{"LOGFILE"}." for writing : $!");
  }
  
  return $self;	
}

##################################################################################################################

sub open {
  my $self = shift;
  
  $error->clear();

  if (! open($self->{FILE_HANDLE}, ">>".$self->{LOGFILE})) {
    $error->set("Could not open ".$self->{LOGFILE}." for writing : $!");
    return 0;
  }
  $self->{FILE_HANDLE}->autoflush(1);
  return 1;
}


##################################################################################################################


sub write {
  my $self = shift;
  my ($text) = shift;
  my $fh = *{$self->{FILE_HANDLE}};
  my ($format);
  
  $error->clear();

  $format = "$0 : [".scalar (localtime)."]"." $text";

  if (! (print $fh "$format\n")) {
    $error->set("Could not write to logfile ".$self->{LOGFILE}." for writing : $!"); 
    return 0;
  }
  
  return 1;
}

##################################################################################################################

sub error {
  my $self = shift;
  return $error->msg();
}

##################################################################################################################


__END__

=pod

##################################################################################################################

=head1 NAME 

Log.pm - Log Module

##################################################################################################################

=head1 DESCRIPTION 

Gives an interface for logging messages to a file

##################################################################################################################

=head1 SYNOPSIS

Please see DESCRIPTION.

##################################################################################################################

=head1 REVISION

$Revision: 1.2 $

$Date: 2000/04/26 04:28:08 $

##################################################################################################################

=head1 AUTHOR

Simran I<simran@unsw.edu.au>

##################################################################################################################

=head1 BUGS

No known bugs. 

##################################################################################################################

=head1 PROPERTIES

LOGFILE:     the log file name

FILE_HANDLE: the FileHandle for the file we are logging to

##################################################################################################################

=head1 METHODS

##################################################################################################################

=head2 new

=over

=item Description

This is the create method for the Log class. The new method can be
called with a reference to a hash, if it is, the reference is used to set
all properties contained in the hash. 

        $log = Log->new("/tmp/program.log");

=item Input

        $logfile = the logfile for writing to

=item Output

        New Log object created.

=item Return Value

        New Log object.

=back


##################################################################################################################

=head2 open

=over

=item Description

This method is used internally from within the new method to open the file ready for writing to. 

=item Input

        none - uses properties

=item Output

        none

=item Return Value

        none

=back


##################################################################################################################

=head2 write

=over

=item Description

Writes a message to the logfile

eg. $log->write("Got data from remote host");

=item Input

        $string - the log message

=item Output

        none

=item Return Value

        none

=back


##################################################################################################################

=head2 error

=over

=item Description

If called in an array context, returns the complete history of error messages
thus far. Else, returns the latest error message if set. 

        $errmsg = $session->error();

        or

        foreach $_ ($session->error()) { 
	  print "Error: $_\n";
        }


=item Input

        none

=item Output

       In array context, returns an array containing all error message set thus far.
       Else, returns the latest error message if set. 

=item Return Value

       same as output

=back


=cut




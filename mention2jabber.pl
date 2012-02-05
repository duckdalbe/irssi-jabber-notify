use strict;
use vars qw($VERSION %IRSSI $jid $subject);

# Based on fnotify <http://www.leemhuis.info/files/fnotify/>.
# Usage:
#  0. Adapt $jid and $subject
#  1. Create ~/.sendxmpprc (see sendxmpp(1))
#  2. Copy or link script to ~/.irssi/scripts
#  3. /script load mention2jabber
#  4. Enjoy!

# Configuration
$jid = 'foo@example.bar';
$subject = 'mention';

# Logic

use Irssi;
$VERSION = '0.0.1';
%IRSSI = (
	  authors     => 'Fup Duck',
	  contact     => 'mention2jabber@duckdalbe.org',
	  name        => 'mention2jabber',
	  description => 'Send a notification to a JID whenever somebody mentions your nick.',
	  license     => 'GNU General Public License',
);

#--------------------------------------------------------------------
# Private message parsing
#--------------------------------------------------------------------

sub priv_msg {
	  my ($server,$msg,$nick,$address,$target) = @_;
	  filewrite($nick." " .$msg );
}

#--------------------------------------------------------------------
# Printing hilight's
#--------------------------------------------------------------------

sub hilight {
    my ($dest, $text, $stripped) = @_;
    if ($dest->{level} & MSGLEVEL_HILIGHT) {
	      filewrite($dest->{target}. " " .$stripped );
    }
}

#--------------------------------------------------------------------
# The actual printing
#--------------------------------------------------------------------

sub filewrite {
	  my ($text) = @_;
    open(JABNOTIFY, "| sendxmpp -t --message-type=headline -s '$subject' $jid");
	  print JABNOTIFY $text . "\n";
    close (JABNOTIFY);
}

#--------------------------------------------------------------------
# Irssi::signal_add_last / Irssi::command_bind
#--------------------------------------------------------------------

Irssi::signal_add_last("message private", "priv_msg");
Irssi::signal_add_last("print text", "hilight");

#- end

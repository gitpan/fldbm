package FLDBM;

use 5.008;
use strict;
use warnings;

our $VERSION = '0.01';
our @ISA = qw();

sub GetRecord {
	my ($file,$record) = @_;
        open(FILE, "$file");
        my @DATA = <FILE>;
        close(FILE);
	my $count = 0;
	my $line = "ERROR";
	foreach (@DATA) {
		$_=~s/\n//g;
		my @SPLIT = split(/#%%#!#%%#/, $_);
		if ($SPLIT[0] eq $record) { 
			$line = $count;			
		}
		$count++;
	};	
	if ($line eq "ERROR") { return "Error: No such record.\n" };
	my @SPLIT = split(/#%%#!#%%#/, $DATA[$line]);
	$SPLIT[1]=~s/#%%#NL#%%#/\n/g;
	return $SPLIT[1];
};



sub GetRecords {
        my ($file) = @_;
        open(FILE, "$file");
        my @DATA = <FILE>;
        close(FILE);
        my $count = 0;
        my @records = ();
        foreach (@DATA) {
                $_=~s/\n//g;
                my @SPLIT = split(/#%%#!#%%#/, $_);
                $records[$count] = $SPLIT[0];
                $count++;
        };
        return @records;
};



sub ChangeEntry {
	my ($file,$record,$blob) = @_;
	RecordExist($file,$record,2);
        open(FILE, "$file");
        my @DATA = <FILE>;
        close(FILE);
        my $count = 0;
        my $line = "ERROR";
        foreach (@DATA) {
                my @SPLIT = split(/#%%#!#%%#/, $_);
                if ($SPLIT[0] eq $record) {
                        $line = $count;
                }
                $count++;
        };
        if ($line eq "ERROR") { print "Error: No such record.\n"; die };
        my @SPLIT = split(/#%%#!#%%#/, $DATA[$line]);
        $blob=~s/\n/#%%#NL#%%#/g;
        $blob=~s/#%%#!#%%#//g;
	$DATA[$line] = "\n$record#%%#!#%%#$blob\n";
	open(FILE, ">$file");
	print FILE @DATA;
	close(FILE);
	CleanDB($file);
	return 1;
};



sub DeleteEntry {
        my ($file,$record,$blob) = @_;
        RecordExist($file,$record,2);
        open(FILE, "$file");
        my @DATA = <FILE>;
        close(FILE);
        my $count = 0;
        my $line = "ERROR";
        foreach (@DATA) {
                my @SPLIT = split(/#%%#!#%%#/, $_);
                if ($SPLIT[0] eq $record) {
                        $line = $count;
                }
                $count++;
        };
        if ($line eq "ERROR") { print "Error: No such record.\n"; die };
        my @SPLIT = split(/#%%#!#%%#/, $DATA[$line]);
        $DATA[$line] = "";
        open(FILE, ">$file");
        print FILE @DATA;
        close(FILE);
        CleanDB($file);
        return 1;
};




sub AddEntry {
        my ($file,$record,$blob) = @_;
	system("touch", $file);
	$record=~s/\n/#%%#NL#%%#/g;
	$blob=~s/\n/#%%#NL#%%#/g;
        $record=~s/#%%#!#%%#//g;
        $blob=~s/#%%#!#%%#//g;
	RecordExist($file,$record,1);
	open(FILE, ">>$file");
        print FILE "\n$record#%%#!#%%#$blob";
	close(FILE);
	CleanDB($file);
        return 1;
};



sub RecordExist {
	my ($file,$record,$check) = @_;
        open(FILE, "$file");
        my @DATA = <FILE>;
        close(FILE);
	if ($check eq 1) {
        	foreach (@DATA) {
			my @SPLIT = split(/#%%#!#%%#/, $_);
			if ($SPLIT[0] eq $record) { print "Error: Record already exists.\n"; die };
		};
	}
	if ($check eq 2) {
		my $checkvar = 0;
		foreach (@DATA) {
	                my @SPLIT = split(/#%%#!#%%#/, $_);
	                if ($SPLIT[0] eq $record) { $checkvar = 1 };
		}
		if ($checkvar eq 0) { print "Error: Record does not exists.\n"; die };
	}
	return 1;
};




sub CleanDB {
	my ($file) = @_;
        open(FILE, "$file");
        my @DATA = <FILE>;
        close(FILE);
	my $count = 0;
	foreach (@DATA) {
		my $look = $_;
		$look=~s/ //g;
		if ($look eq "\n") { $DATA[$count] = "" }; 		
		$count++;
	}
	open(FILE, ">$file");

        print FILE @DATA;
        close(FILE);
	return 1;
};


1;


__END__

=head1 NAME

FLDBM

=head1 SYNOPSIS

  use FLDBM;

  FLDBM::GetRecord(file,record);          Returns information from a record.
  FLDBM::GetRecords(file);                Returns list of records from file.
  FLDBM::ChangeEntry(file,record,blob)    Changes a record.
  FLDBM::DeleteEntry(file,record)         Deletes a record.
  FLDBM::AddEntry(file,record,blob)       Adds a record.
  

=head1 DESCRIPTION

FLDBM is a textfile database storage system.  It allows for a feild name and value to be stored in a textfile and later recalled.

=head2 EXPORT

None.

=head1 SEE ALSO

=head1 AUTHOR

Michael J. Flickinger, E<lt>mjflick@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Michael J. Flickinger

=cut

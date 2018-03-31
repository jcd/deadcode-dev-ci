my @PACKS = ();
$X=0; 

print `sudo apt-get install libwww-perl`;

while (1) {
	$M=`find . -not -regex .*\.dub/dub.json -a -name dub.json | while read F; do cat \$F | perl -ne 'print if s/.*\\"(deadcode-.*)\\"\\s*?:.*/\\1/' ; done | sort | uniq | tee deps.txt | wc -l`;
	# print "$X $M\n"; 
	print "Dependencies:\n";
	print `cat deps.txt` . "\n";
	last if ($X == scalar($M)); 
	$X=scalar($M);

	open my $fh, '<', "deps.txt" or die "Cannot open deps.txt: $!";
	
	while ( my $line = <$fh> ) {
		chomp $line;

		if (grep( /^$line$/, @PACKS ))
		{
			next;
		}

		push @PACKS, $line;

		print "git clone https://github.com/jcd/${line}.git ${line}\n";
		print `git clone https://github.com/jcd/${line}.git ${line}` . "\n";
		print "dub add-local ${line}\n";
		print `dub add-local ${line}` . "\n";
	}

	close($fh);
}

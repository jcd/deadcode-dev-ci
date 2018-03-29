$X=0; 
while (1) {
	$M=`find . -not -regex .*\.dub/dub.json -a -name dub.json | while read F; do cat \$F | perl -ne 'print if s/.*\\"(deadcode-.*)\\"\\s*?:.*/\\1/' ; done | sort | uniq | tee deps.txt | wc -l`;
	print "$X $M\n"; 
	$DEPS=`cat deps.txt`;
	print "$DEPS\n";
	last if ($X == scalar($M)); 
	$X=scalar($M);
	$HH=`cat deps.txt | while read I; do if [ ! -e \$I ] ; then git clone https://github.com/jcd/\$I.git \$I ; dub add-local \$I ; fi; done;`;
}

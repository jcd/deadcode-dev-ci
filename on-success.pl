use LWP::UserAgent;

my $token = $ENV{'TRAVISTOKEN'};

foreach my $arg (@ARGV) {

    print "Triggering build of deadcode-${arg}\n";

	my $ua = LWP::UserAgent->new;
	 
	my $server_endpoint = "https://api.travis-ci.org/repo/jcd%2Fdeadcode-${arg}/requests";
	 
	# set custom HTTP request header fields
	my $req = HTTP::Request->new(POST => $server_endpoint);
	$req->header('Content-Type' => 'application/json');
	$req->header('Accept' => 'application/json');
	$req->header('Travis-API-Version' => '3');
	$req->header('Authorization' => "token $token");
	 
	# add POST data to HTTP request body
	my $post_data = '{ "request": { "branch": "master" } }';
	$req->content($post_data);
	 
	my $resp = $ua->request($req);
	if ($resp->is_success) {
	    my $message = $resp->decoded_content;
	    print "Received reply: $message\n";
	}
	else {
	    print "HTTP POST error code: ", $resp->code, "\n";
	    print "HTTP POST error message: ", $resp->message, "\n";
	}

}


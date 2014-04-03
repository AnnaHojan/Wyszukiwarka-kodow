#!/usr/bin/perl

use strict;
use warnings;

use JSON qw( decode_json );


sub null_to_empty_string($) {
	my ($str) = @_;
	return defined $str ? $str : '';
}


die "Podaj dane do logowania na Githubie, id repozytorium na ktorym zakonczono ostatnio oraz ostatnie id ktore chcesz pobrac" unless $#ARGV == 3;
my ($user, $password, $last_id, $end_id) = @ARGV;


open (INFO, '>>repos_info.txt');
open (DOWNLOAD, '>>to_download.txt');

while ($last_id < $end_id) {

	print "\n\nAktualne id repozytorium: $last_id\n\n"; 
	
	my $repositories_url = "https://api.github.com/repositories?since=$last_id";
	my $curl_res = `curler.bat "$repositories_url" $user $password`;
	die "Nie znaleziono pliku curler.bat" if $? > 0;
	
	my $input_file = "curler_output.txt";
	open( my $input_fh, "<", $input_file ) || die "Can't open $input_file: $!";
	my $json = join('', <$input_fh>);
	die "Niepowodzenie autoryzacji lub pobierania" if $json eq '';
	
	my $decoded_json = [];
	eval {
		$decoded_json = decode_json( $json );
	};
	if ($@)
	{
		print "Blad wczytywania jsona z pliku. Powod:\n$@\n";
	}

	for my $one_repo_info (@$decoded_json) {
		my $repo_url = $one_repo_info->{url};
		my $curl_res = `curler.bat "$repo_url" $user $password`;
		die "Nie znaleziono pliku curler.bat" if $? > 0;
		my $input_repo_file = "curler_output.txt";
		open( my $input_repo_fh, "<", $input_repo_file ) || die "Can't open $input_repo_file: $!";
		my $repo_json = join('', <$input_repo_fh>);
		die "Niepowodzenie autoryzacji lub pobierania" if $repo_json eq '';
		
		my $decoded_repo_json = {};
		eval {
			$decoded_repo_json = decode_json( $repo_json );
		};
		if ($@)
		{
			print "Blad wczytywania jsona z pliku. Powod:\n$@\n";
			
		}

		my $has_downloads = $decoded_repo_json->{has_downloads};
		next unless ($has_downloads);

		my $id = null_to_empty_string($one_repo_info->{id});
		my $name = null_to_empty_string($one_repo_info->{name});
		my $description = null_to_empty_string($one_repo_info->{description});
		my $owner = null_to_empty_string($one_repo_info->{owner}->{login});
		my $language = null_to_empty_string($decoded_repo_json->{language});

		my $size = null_to_empty_string($decoded_repo_json->{size});
		my $stargazers_count = null_to_empty_string($decoded_repo_json->{stargazers_count});
		my $watchers_count = null_to_empty_string($decoded_repo_json->{watchers_count});
		my $forks_count = null_to_empty_string($decoded_repo_json->{forks_count});
		my $subscribers_count = null_to_empty_string($decoded_repo_json->{subscribers_count});

		my $created_at = null_to_empty_string($decoded_repo_json->{created_at});
		my $updated_at = null_to_empty_string($decoded_repo_json->{updated_at});
		my $pushed_at = null_to_empty_string($decoded_repo_json->{pushed_at});

		print INFO "$id\n";
		print INFO "$name\n";
		print INFO "$description\n";
		print INFO "$owner\n";
		print INFO "$language\n";
		print INFO "$size\n";
		print INFO "$stargazers_count\n";
		print INFO "$watchers_count\n";
		print INFO "$forks_count\n";
		print INFO "$subscribers_count\n";
		print INFO "$created_at\n";
		print INFO "$updated_at\n";
		print INFO "$pushed_at\n";
		print INFO "\n";

		print DOWNLOAD "$repo_url\n";

		$last_id = $one_repo_info->{id};
	}
}

close (INFO);
close (DOWNLOAD);

#!/usr/bin/perl

use strict;
use warnings;

use JSON qw( decode_json );


sub null_to_empty_string($) {
	my ($str) = @_;
	return defined $str ? $str : '';
}

sub fix_xml($) {
	my ($str) = @_;
	$str =~ s/[<>]+//g;
	return $str;
}


die "Podaj dane do logowania na Githubie, id repozytorium na ktorym zakonczono ostatnio oraz ostatnie id ktore chcesz pobrac" unless $#ARGV == 3;
my ($user, $password, $last_id, $end_id) = @ARGV;


open (INFO, '>>repos_info.xml');
open (DOWNLOAD, '>>urls_git_clone.txt');
open (REPO, '>>urls_repo.txt');

while ($last_id < $end_id) {

	print "\n\nAktualne id repozytorium: $last_id\n\n"; 
	my $repositories_url = "https://api.github.com/repositories?since=$last_id";
	my $curl_res = `curler.bat "$repositories_url" $user $password 25`;
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
	while (my $one_repo_info = shift @$decoded_json) {
		my $repo_url = $one_repo_info->{url};
		my $curl_res = `curler.bat "$repo_url" $user $password 25`;
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
		my $is_fork = $decoded_repo_json->{fork};
		next if $is_fork;
		my $size = null_to_empty_string($decoded_repo_json->{size});
		next if $size > 20480;
		#my $watchers_count = null_to_empty_string($decoded_repo_json->{watchers_count});
		#next if $watchers_count < 5;
		#my $subscribers_count = null_to_empty_string($decoded_repo_json->{subscribers_count});
		#next if $subscribers_count < 3;
		#my $forks_count = null_to_empty_string($decoded_repo_json->{forks_count});
		#next if $forks_count < 5;
		#my $stargazers_count = null_to_empty_string($decoded_repo_json->{stargazers_count});
		#next if $stargazers_count < 5;
		

		my $id = $one_repo_info->{id};
		my $name = fix_xml(null_to_empty_string($one_repo_info->{name}));
		my $description = fix_xml(null_to_empty_string($one_repo_info->{description}));
		my $owner = fix_xml(null_to_empty_string($one_repo_info->{owner}->{login}));
		my $language = fix_xml(null_to_empty_string($decoded_repo_json->{language}));
		my $created_at = fix_xml(null_to_empty_string($decoded_repo_json->{created_at}));
		my $updated_at = fix_xml(null_to_empty_string($decoded_repo_json->{updated_at}));
		
		my $clone_url = $decoded_repo_json->{clone_url};	
		print INFO "<repo>\n";
		print INFO "\t<id>$id</id>\n";
		print INFO "\t<name>$name</name>\n";
		print INFO "\t<description>$description\</description>n";
		print INFO "\t<owner>$owner</owner>\n";
		print INFO "\t<main_language>$language</main_language>\n";
		print INFO "\t<created_at>$created_at</created_at>\n";
		print INFO "\t<updated_at>$updated_at</updated_at>\n";
		print INFO "\t<clone_url>$clone_url</clone_url>\n";


		print DOWNLOAD "$clone_url\n";
		print REPO "$repo_url\n";
		
		
		$curl_res = `curler.bat "$repo_url/languages" $user $password 25`;
		die "Nie znaleziono pliku curler.bat" if $? > 0;
		my $input_languages_file = "curler_output.txt";
		open( my $input_languages_fh, "<", $input_languages_file ) || die "Can't open $input_languages_file: $!";
		my $languages_json = join('', <$input_languages_fh>);
		die "Niepowodzenie autoryzacji lub pobierania" if $languages_json eq '';
		
		my $decoded_languages_json = {};
		eval {
			$decoded_languages_json = decode_json( $languages_json );
		};
		if ($@)
		{
			print "Blad wczytywania jsona z pliku. Powod:\n$@\n";
			
		}
		
		print INFO "\t<languages>\n";
		for my $language (keys %$decoded_languages_json) {
			$language = fix_xml($language);
			print INFO "\t\t<language>$language</language>\n";
		}
		print INFO "\t</languages>\n";
		
		
		
		
		$curl_res = `curler.bat "$repo_url/branches" $user $password 25`;
		die "Nie znaleziono pliku curler.bat" if $? > 0;
		my $input_branches_file = "curler_output.txt";
		open( my $input_branches_fh, "<", $input_branches_file ) || die "Can't open $input_branches_file: $!";
		my $branches_json = join('', <$input_branches_fh>);
		die "Niepowodzenie autoryzacji lub pobierania" if $branches_json eq '';
		
		my $decoded_branches_json = {};
		eval {
			$decoded_branches_json = decode_json( $branches_json );
		};
		if ($@)
		{
			print "Blad wczytywania jsona z pliku. Powod:\n$@\n";
			
		}
		print INFO "\t<branches>\n";
		for my $branches_info (@$decoded_branches_json) {
			my $branch_name = fix_xml($branches_info->{name});
			print INFO "\t\t<branch>$branch_name</branch>\n";
		}
		print INFO "\t</branches>\n";
		
		
		
		$curl_res = `curler.bat "$repo_url/contributors" $user $password 26`;
		die "Nie znaleziono pliku curler.bat" if $? > 0;
		my $input_contributors_file = "curler_output.txt";
		open( my $input_contributors_fh, "<", $input_contributors_file ) || die "Can't open $input_contributors_file: $!";
		my $contributors_json = join('', <$input_contributors_fh>);
		die "Niepowodzenie autoryzacji lub pobierania" if $contributors_json eq '';
		
		my $decoded_contributors_json = {};
		eval {
			$decoded_contributors_json = decode_json( $contributors_json );
		};
		if ($@)
		{
			print "Blad wczytywania jsona z pliku. Powod:\n$@\n";
			
		}
		print INFO "\t<contributors>\n";
		for my $contributors_info (@$decoded_contributors_json) {
			my $contrib_login = fix_xml($contributors_info->{login});
			print INFO "\t\t<contributor>$contrib_login</contributor>\n";
		}
		print INFO "\t</contributors>\n";
		
		
		
		$curl_res = `curler.bat "$repo_url/commits" $user $password 26`;
		die "Nie znaleziono pliku curler.bat" if $? > 0;
		my $input_commits_file = "curler_output.txt";
		open( my $input_commits_fh, "<", $input_commits_file ) || die "Can't open $input_commits_file: $!";
		my $commits_json = join('', <$input_commits_fh>);
		die "Niepowodzenie autoryzacji lub pobierania" if $commits_json eq '';
		
		my $decoded_commits_json = {};
		eval {
			$decoded_commits_json = decode_json( $commits_json );
		};
		if ($@)
		{
			print "Blad wczytywania jsona z pliku. Powod:\n$@\n";
			
		}
		print INFO "\t<commits>\n";
		for my $commits_info (@$decoded_commits_json) {
			my $commit_sha = $commits_info->{sha};
			my $commit_sha_print = fix_xml($commit_sha);
			my $commit_message = fix_xml(null_to_empty_string($commits_info->{commit}->{message}));
			my $commit_author_name = fix_xml(null_to_empty_string($commits_info->{commit}->{author}->{name}));
			my $commit_author_date = fix_xml(null_to_empty_string($commits_info->{commit}->{author}->{date}));
			my $commit_author_email = fix_xml(null_to_empty_string($commits_info->{commit}->{author}->{email}));
			my $commit_committer_name = fix_xml(null_to_empty_string($commits_info->{commit}->{committer}->{name}));
			my $commit_committer_date = fix_xml(null_to_empty_string($commits_info->{commit}->{committer}->{date}));
			my $commit_committer_email = fix_xml(null_to_empty_string($commits_info->{commit}->{committer}->{email}));
			
			print INFO "\t\t<commit>\n";
			print INFO "\t\t\t<sha>$commit_sha_print</sha>\n";
			print INFO "\t\t\t<message>$commit_message</message>\n";
			print INFO "\t\t\t<author_name>$commit_author_name</author_name>\n";
			print INFO "\t\t\t<author_date>$commit_author_date</author_date>\n";
			print INFO "\t\t\t<author_email>$commit_author_email</author_email>\n";
			print INFO "\t\t\t<committer_name>$commit_committer_name</committer_name>\n";
			print INFO "\t\t\t<committer_date>$commit_committer_date</committer_date>\n";
			print INFO "\t\t\t<committer_email>$commit_committer_email</committer_email>\n";
			
			
			
			$curl_res = `curler.bat "$repo_url/commits/$commit_sha" $user $password 25`;
			die "Nie znaleziono pliku curler.bat" if $? > 0;
			my $input_commit_file = "curler_output.txt";
			open( my $input_commit_fh, "<", $input_commit_file ) || die "Can't open $input_commit_file: $!";
			my $commit_json = join('', <$input_commit_fh>);
			die "Niepowodzenie autoryzacji lub pobierania" if $commit_json eq '';
			
			my $decoded_commit_json = {};
			eval {
				$decoded_commit_json = decode_json( $commit_json );
			};
			if ($@)
			{
				print "Blad wczytywania jsona z pliku. Powod:\n$@\n";
				
			}
			print INFO "\t\t\t<files>\n";
			for my $file_info (@{$decoded_commit_json->{files}}) {
				my $file_name = fix_xml(null_to_empty_string($file_info->{filename}));
				my $diff = fix_xml(null_to_empty_string($file_info->{patch}));
				print INFO "\t\t\t\t<file>\n";
				print INFO "\t\t\t\t\t<file_name>$file_name</file_name>\n";
				print INFO "\t\t\t\t\t<diff>$diff</diff>\n";
				print INFO "\t\t\t\t</file>\n";
				
			}
			print INFO "\t\t\t</files>\n";
			print INFO "\t\t</commit>\n";
			
		}
		print INFO "\t</commits>\n";
		print INFO "</repo>\n";
		$last_id = $one_repo_info->{id};
	}
}

close (INFO);
close (DOWNLOAD);
close (REPO);

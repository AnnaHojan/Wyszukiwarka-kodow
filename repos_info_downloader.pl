#!/usr/bin/perl

use File::Path qw( rmtree );

use strict;
use warnings;

use JSON qw( decode_json );
use FileHandle;
use File::Find::Rule;
use File::Basename;
use LWP;
use HTML::TreeBuilder::XPath;


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
print INFO "<add>\n";

while ($last_id < $end_id) {

	print "\n\nAktualne id repozytorium: $last_id\n\n"; 
	my $repositories_url = "https://api.github.com/repositories?since=$last_id";
	my $curl_res = `curl --insecure -i "$repositories_url" -u $user:$password > temp.txt`;
	$curl_res = `more +25 temp.txt > curler_output.txt`;
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
		my $curl_res = `curl --insecure -i "$repo_url" -u $user:$password > temp.txt`;
		$curl_res = `more +25 temp.txt > curler_output.txt`;
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
		my $watchers_count = null_to_empty_string($decoded_repo_json->{watchers_count});
		next if $watchers_count < 5;
		my $subscribers_count = null_to_empty_string($decoded_repo_json->{subscribers_count});
		next if $subscribers_count < 3;
		my $forks_count = null_to_empty_string($decoded_repo_json->{forks_count});
		next if $forks_count < 5;
		my $stargazers_count = null_to_empty_string($decoded_repo_json->{stargazers_count});
		next if $stargazers_count < 5;
		

		my $id = $one_repo_info->{id};
		my $name = fix_xml(null_to_empty_string($one_repo_info->{name}));
		my $description = fix_xml(null_to_empty_string($one_repo_info->{description}));
		my $owner = fix_xml(null_to_empty_string($one_repo_info->{owner}->{login}));
		my $language = fix_xml(null_to_empty_string($decoded_repo_json->{language}));
		my $created_at = fix_xml(null_to_empty_string($decoded_repo_json->{created_at}));
		my $updated_at = fix_xml(null_to_empty_string($decoded_repo_json->{updated_at}));
		
		my $clone_url = $decoded_repo_json->{clone_url};	
		print INFO "<doc>\n";
		print INFO "\t<field name=\"id\">$id</field>\n";
		print INFO "\t<field name=\"name\">$name</field>\n";
		print INFO "\t<field name=\"description\">$description</field>\n";
		print INFO "\t<field name=\"owner\">$owner</field>\n";
		print INFO "\t<field name=\"main_language\">$language</field>\n";
		print INFO "\t<field name=\"created_at\">$created_at</field>\n";
		print INFO "\t<field name=\"updated_at\">$updated_at</field>\n";
		print INFO "\t<field name=\"url\">$repo_url</field>\n";

		
		$curl_res = `curl --insecure -i "$repo_url/languages" -u $user:$password > temp.txt`;
		$curl_res = `more +25 temp.txt > curler_output.txt`;
		
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
		
		for my $language (keys %$decoded_languages_json) {
			$language = fix_xml($language);
			print INFO "\t<field name=\"language\">$language</field>\n";
		}
		
		
		$curl_res = `curl --insecure -i "$repo_url/branches" -u $user:$password > temp.txt`;
		$curl_res = `more +25 temp.txt > curler_output.txt`;
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
		for my $branches_info (@$decoded_branches_json) {
			my $branch_name = fix_xml($branches_info->{name});
			print INFO "\t<field name=\"branch\">$branch_name</field>\n";
		}
		
		
		$curl_res = `curl --insecure -i "$repo_url/contributors" -u $user:$password > temp.txt`;
		$curl_res = `more +26 temp.txt > curler_output.txt`;

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
		for my $contributors_info (@$decoded_contributors_json) {
			my $contrib_login = fix_xml($contributors_info->{login});
			print INFO "\t<field name=\"contributor\">$contrib_login</field>\n";
		}
		
		
		$curl_res = `curl --insecure -i "$repo_url/commits" -u $user:$password > temp.txt`;
		$curl_res = `more +26 temp.txt > curler_output.txt`;
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


			print INFO "\t<field name=\"commit_sha\">$commit_sha_print</field>\n";
			print INFO "\t<field name=\"commit_message\">$commit_message</field>\n";
			print INFO "\t<field name=\"commit_author_name\">$commit_author_name</field>\n";
			print INFO "\t<field name=\"commit_author_date\">$commit_author_date</field>\n";
			print INFO "\t<field name=\"commit_author_email\">$commit_author_email</field>\n";
			print INFO "\t<field name=\"commit_committer_name\">$commit_committer_name</field>\n";
			print INFO "\t<field name=\"commit_committer_date\">$commit_committer_date</field>\n";
			print INFO "\t<field name=\"commit_committer_email\">$commit_committer_email</field>\n";
			
			
			$curl_res = `curl --insecure -i "$repo_url/commits/$commit_sha" -u $user:$password > temp.txt`;
			$curl_res = `more +25 temp.txt > curler_output.txt`;
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
			for my $file_info (@{$decoded_commit_json->{files}}) {
				my $file_name = basename(fix_xml(null_to_empty_string($file_info->{filename})));
				my $diff = fix_xml(null_to_empty_string($file_info->{patch}));
				print INFO "\t<field name=\"commit_file_name\">$file_name</field>\n";
				print INFO "\t<field name=\"commit_diff\">$diff</field>\n";
			}
			
		}
		
		$clone_url = join("//$user:$password@", split('//', $clone_url));
		my $clone_res = `git clone $clone_url`;
		rmtree(".\\$name\\.git");
		
		
		my $finder = File::Find::Rule->new()->start(".\\$name");
		while( my $file = $finder->match() ){
		    my $basename = basename($file);
		    
		    print INFO "\t<field name=\"filename\">$basename</field>\n";
		    print INFO "\t<field name=\"filename_full\">$file</field>\n";
		    if (-T $file) { #nie bierz binarnych
			unless ($file =~ /^.*\.(pdf)$/i) {
				my $content = do {
				    local $/ = undef;
				    open my $fh, "<", $file
					or die "could not open $file: $!";
				    <$fh>;
				};
				$content = fix_xml(null_to_empty_string($content));
				
				#wyciaganie komentarzy
				my $pygments_lang = `pygmentize -N "$file"`;
				chomp($pygments_lang);
				if ($pygments_lang ne 'text') {
					$pygments_lang = fix_xml(null_to_empty_string($pygments_lang));
					print INFO "\t<field name=\"language\">$pygments_lang</field>\n";
					my $pygments_html = `pygmentize -f html "$file"`;
					my $tree = HTML::TreeBuilder->new_from_content($pygments_html);
					my $i = 1;
					my @items = ();
					while ($i <= 2) {
					    my @new = $tree->findnodes_as_strings('//span[@class="c'.$i.'"]');
					    last if scalar @new == 0;
					    push @items, @new;
					    $i++;
					}
					$tree->delete;
					for my $comm (@items) {
						$comm = fix_xml(null_to_empty_string($comm));
						print INFO "\t<field name=\"comment\">$comm</field>\n";
					}
				}
			}
		    }
		}
		rmtree(".\\$name");

		print INFO "</doc>\n";
		$last_id = $one_repo_info->{id};
	}
}

print INFO "</add>\n";
close (INFO);

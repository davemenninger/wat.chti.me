package Watchtime::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

use Mojo::UserAgent;
use Data::Dumper;

# This action will render a template
sub welcome {
  my $self = shift;

  my $list = '<ul>';

  my $trakt_api_key = $ENV{'TRAKT_API_KEY'} // 'nope';
  my $ua   = Mojo::UserAgent->new;
  my $json = $ua->get(
      'https://api-v2launch.trakt.tv/users/sean/watchlist/shows' => {
          'Content-Type'      => 'application/json',
          'trakt-api-version' => '2',
          'trakt-api-key'     => $trakt_api_key,
      }
  )->res->json;

  for my $show ( @{$json} )
  {
    say "a show:";
    say $show->{'show'}->{'title'};
    $list .= '<li>'.$show->{'show'}->{'title'}.'</li>';
    say Dumper( $show );
  }

  $list .= '</ul>';

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!', list => $list);
}

1;

module Meta
  def stub_meta
    body = JSON.load(fixture_data("meta"))

    stub_request(:get, "https://api.github.com/meta").
      with(:headers => {'Accept'=>'application/vnd.github.beta+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token <unknown>', 'User-Agent'=>'Octokit Ruby Gem 2.5.1'}).
      to_return(:status => 200, :body => double("hooks" => body["hooks"]))
  end

  ::RSpec.configure do |config|
    config.include self
  end
end

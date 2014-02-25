HeavenNotifier::Application.routes.draw do
  get  "/" => redirect("https://github.com")

  github_authenticate(:team => :employees) do
    mount Resque::Server.new, :at => "/resque"
  end

  post "/events" => "callbacks#create"
end

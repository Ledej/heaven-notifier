require 'spec_helper'

describe "receiving GitHub hooks" do
  it "ignore unwanted events" do
    post "/events", fixture_data("deployment"), default_headers("deployment")

    expect(response).to be_not_found
  end
  
  it "ignore unwanted incoming ips" do
    post "/events", fixture_data("deployment"), default_headers("deployment", "127.0.0.1")

    expect(response).to be_not_found
  end

  it "handles ping events" do
    post "/events", fixture_data("ping"), default_headers("ping")

    expect(response).to be_success
    expect(response.status).to eql(201)
  end

  it "handles deployment status events" do
    pending "gotta actually write the code for this"
    post "/events", fixture_data("deployment_status"), default_headers("deployment_status")

    expect(response).to be_success
    expect(response.status).to eql(201)
  end
end

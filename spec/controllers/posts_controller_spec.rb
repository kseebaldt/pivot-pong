require 'spec_helper'

describe PostsController do
  describe "GET #show" do
    it "should load the page" do
      get :index
      expect(assigns[:posts]).to_not be_nil
      expect(response).to be_success
    end
  end
end

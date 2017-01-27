require 'spec_helper'

describe Admin::PostsController do
  describe "#index" do
    before { get :index }
    it 'shows all posts' do
      expect(response).to be_success
      expect(assigns(:posts)).to eq Post.all
    end
  end

  describe "#new" do
    before { get :new }
    it 'assigns a post for the form' do
      expect(response).to be_success
      expect(assigns(:post)).to_not be_nil
    end
  end

  describe "#create" do
    it "should create a new post" do
      expect { get :create, post: {title: "foo", body: "bar"} }.to change(Post, :count).by(1)
      expect(response).to redirect_to admin_posts_path
    end
  end

  describe "#destroy" do
    it "should delete a post" do
      post = Post.create title: "foo", body: "bar"
      expect { get :destroy, id: post.id }.to change(Post, :count).by(-1)
      expect(response).to redirect_to admin_posts_path
    end
  end

  describe "#edit" do
    it "should delete a post" do
      post = Post.create title: "foo", body: "bar"
      get :edit, id: post.id
      expect(assigns[:post]).to eq post
    end
  end

  describe "#update" do
    it "should update a post" do
      post = Post.create title: "foo", body: "bar"
      get :update, id: post.id, post: {title: 'booyah!'}
      expect(post.reload.title).to eq "booyah!"
    end
  end
end

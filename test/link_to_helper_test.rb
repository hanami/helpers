require 'test_helper'

describe Lotus::Helpers::LinkToHelper do
  before do
    @view = LinkTo.new
  end

  it 'returns a link to posts' do
    @view.link_to_posts.must_equal %(<a href="/posts">Posts</a>)
  end

  it 'returns a link to a post' do
    @view.link_to_post.must_equal %(<a href="/post/1">Post</a>)
  end

  it 'returns a link with a class' do
    @view.link_to_with_class.must_equal %(<a class="first" href="/posts">Post</a>)
  end

  it 'returns a link with id' do
    @view.link_to_with_id.must_equal %(<a id="posts_link" href="/posts">Post</a>)
  end
end

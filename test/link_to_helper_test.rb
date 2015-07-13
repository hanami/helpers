require 'test_helper'

describe Lotus::Helpers::LinkToHelper do
  before do
    @view = LinkTo.new
  end

  it 'returns a link to posts' do
    @view.link_to_posts.must_equal %(<a href="/posts/">Posts</a>)
  end

  it 'returns a link to a post' do
    @view.link_to_post.must_equal %(<a href="/post/1">Post</a>)
  end

  it 'returns a link with a class' do
    @view.link_to_with_class.must_equal %(<a class="first" href="/posts/">Post</a>)
  end

  it 'returns a link with id' do
    @view.link_to_with_id.must_equal %(<a id="posts__link" href="/posts/">Post</a>)
  end

  it 'returns a link relative link' do
    @view.link_to_relative_posts.must_equal %(<a href="posts">Posts</a>)
  end

  it 'returns a link with html content' do
    @view.link_to_with_html_content.must_equal %(<a href="/posts/">\n<strong>Post</strong>\n</a>)
  end

  it 'returns a link with html content, id and class' do
    @view.link_to_with_html_content_id_and_class.must_equal %(<a id="posts__link" class="first" href="/posts/">\n<strong>Post</strong>\n</a>)
  end

  it 'raises an exception link with content and html content' do
    -> { @view.link_to_with_content_and_html_content }.must_raise ArgumentError, 'Only an url is expected as an argument when a block is given'
  end

  it 'raises an exception when link with content, html content, id and class' do
    -> { @view.link_to_with_content_html_content_id_and_class }.must_raise ArgumentError, 'Only an url is expected as an argument when a block is given'
  end

  it 'raises an exception when have not arguments' do
    -> { @view.link_to_without_args }.must_raise ArgumentError, 'Both content and url are expected as arguments'
  end

  it 'raises an exception when have only content' do
    -> { @view.link_to_with_only_content }.must_raise ArgumentError, 'Both content and url are expected as arguments'
  end
end

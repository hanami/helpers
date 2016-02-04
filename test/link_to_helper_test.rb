require 'test_helper'

describe Hanami::Helpers::LinkToHelper do
  before do
    @view = LinkTo.new
  end

  it 'returns a link to posts' do
    @view.link_to_posts.to_s.must_equal %(<a href="/posts/">Posts</a>)
  end

  it 'returns a link to a post' do
    @view.link_to_post.to_s.must_equal %(<a href="/post/1">Post</a>)
  end

  it 'returns a link with a class' do
    @view.link_to_with_class.to_s.must_equal %(<a class="first" href="/posts/">Post</a>)
  end

  it 'returns a link with id' do
    @view.link_to_with_id.to_s.must_equal %(<a id="posts__link" href="/posts/">Post</a>)
  end

  it 'returns a link relative link' do
    @view.link_to_relative_posts.to_s.must_equal %(<a href="posts">Posts</a>)
  end

  it 'returns a link with html content' do
    @view.link_to_with_html_content.to_s.must_equal %(<a href="/posts/">\n<strong>Post</strong>\n</a>)
  end

  it 'returns a link with html content, id and class' do
    @view.link_to_with_html_content_id_and_class.to_s.must_equal %(<a id="posts__link" class="first" href="/posts/">\n<strong>Post</strong>\n</a>)
  end

  it 'raises an exception link with content and html content' do
    -> { @view.link_to_with_content_and_html_content }.must_raise ArgumentError
  end

  it 'raises an exception when link with content, html content, id and class' do
    -> { @view.link_to_with_content_html_content_id_and_class }.must_raise ArgumentError
  end

  it 'raises an exception when have not arguments' do
    -> { @view.link_to_without_args }.must_raise ArgumentError
  end

  it 'raises an exception when have not arguments and empty block' do
    -> { @view.link_to_without_args_and_empty_block }.must_raise ArgumentError
  end

  it 'raises an exception when have only content' do
    -> { @view.link_to_with_only_content }.must_raise ArgumentError
  end
end

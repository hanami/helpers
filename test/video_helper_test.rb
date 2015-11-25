require 'test_helper'

describe Lotus::Helpers::VideoHelper do
  let(:view)   { VideoHelperView.new(params) }
  let(:params) { Hash[] }

  describe '#video' do
    it 'renders' do
      actual = view.video('movie.mp4')
      actual.must_equal %(<video src="/assets/movie.mp4"></video>)
    end

    it 'renders with html attributes' do
      actual = view.video('movie.mp4', autoplay: true, controls: true)
      actual.must_equal %(<video src="/assets/movie.mp4" autoplay="autoplay" controls="controls"></video>)
    end

    it 'renders with fallback content' do
      actual = view.video('movie.mp4') do
        "Your browser does not support the video tag"
      end
      actual.must_equal %(<video src="/assets/movie.mp4">\nYour browser does not support the video tag\n</video>)
    end

    it 'renders with tracks' do
      actual = view.video('movie.mp4') do
        track kind: 'captions', src: view.asset_path('movie.en.vtt'), srclang: 'en', label: 'English'
      end
      actual.must_equal %(<video src="/assets/movie.mp4">\n<track kind="captions" src="/assets/movie.en.vtt" srclang="en" label="English">\n</video>)
    end

    it 'renders with sources' do
      actual = view.video do
        text "Your browser does not support the video tag"
        source src: view.asset_path('movie.mp4'), type: 'video/mp4'
        source src: view.asset_path('movie.ogg'), type: 'video/ogg'
      end
      actual.must_equal %(<video>\nYour browser does not support the video tag\n<source src="/assets/movie.mp4" type="video/mp4">\n<source src="/assets/movie.ogg" type="video/ogg">\n</video>)
    end

    it 'raises an exception when no arguments' do
      -> {view.video()}.must_raise ArgumentError
    end

    it 'raises an exception when no src and no block' do
      -> {view.video(content: true)}.must_raise ArgumentError
    end
  end
end

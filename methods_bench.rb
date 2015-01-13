#!/usr/bin/env ruby
$:.unshift 'lib'
require 'benchmark/ips'
require 'lotus/helpers/html_helper/html_builder'

builder    = Lotus::Helpers::HtmlHelper::HtmlBuilder.new
content    = 'hello'
attributes = { title: 'greeting' }

Benchmark.ips do |x|
  x.report('concrete') { builder.a(content, attributes) }
  x.report('meta')     { builder.abbr(content, attributes) }
  x.report('define')   { builder.p(content, attributes) }
end

__END__
Ruby:

    ruby 2.2.0p0 (2014-12-25 revision 49005) [x86_64-darwin13]

Hardware:

    Hardware Overview:

      Model Name: MacBook Air
      Model Identifier: MacBookAir5,2
      Processor Name: Intel Core i7
      Processor Speed: 2 GHz
      Number of Processors: 1
      Total Number of Cores: 2
      L2 Cache (per Core): 256 KB
      L3 Cache: 4 MB
      Memory: 8 GB
      Boot ROM Version: MBA51.00EF.B02
      SMC Version (system): 2.5f9

Software:

    System Software Overview:

      System Version: OS X 10.9.5 (13F34)
      Kernel Version: Darwin 13.4.0
      Time since boot: 29 days 1:58


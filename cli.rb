#!/usr/bin/env ruby

require 'optparse'
require_relative 'cleaner'

options = {}
options[:dry_run] = true

OptionParser.new do |opts|
  opts.banner = 'Usage: cli.rb [options]'

  opts.on('--ratio N', Float, 'Ratio filter') do |ratio|
    options[:ratio] = ratio
  end

  opts.on('--tracker-host host', String, 'Tracker host filter') do |tracker|
    options[:tracker] = tracker
  end

  opts.on('--[no-]dry-run', 'Dry run') do |dr|
    options[:dry_run] = dr
  end

  opts.on('--rtorrent-url URL', 'RTorrent URL') do |url|
    options[:rtorrent_url] = url
  end
end.parse!

Retort::Service.configure do |config|
  config.url = options[:rtorrent_url]
end

Cleaner.new(**options.slice(:tracker, :ratio, :dry_run)).run

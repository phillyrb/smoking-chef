#!/usr/bin/env ruby

ENV["HOME"] = "/root"

require 'fileutils'

machines = Dir["/storage/machines/*"].select { |x| File.directory?(x) }.map { |x| File.basename(x) }

pwd=FileUtils.pwd

case ARGV[0]
when "start"
  machines.each do |machine|
    FileUtils.chdir("/storage/machines/#{machine}")
    system("/usr/local/rvm/bin/rvm-shell", "1.9.2", "-c", "vagrant up")
  end
when "stop"
  machines.each do |machine|
    FileUtils.chdir("/storage/machines/#{machine}")
    system("/usr/local/rvm/bin/rvm-shell", "1.9.2", "-c", "vagrant halt")
  end
when "restart"
  system($0, "stop")
  system($0, "start")
end

FileUtils.chdir(pwd)

# vim: ft=ruby

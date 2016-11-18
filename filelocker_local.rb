require 'rubygems'
require 'daemons'

pwd = Dir.pwd

Daemons.run_proc('filelocker.rb', :dir_mode => :normal, :dir => pwd) do
  Dir.chdir(pwd)
  exec 'ruby lib/filelocker.rb'
end

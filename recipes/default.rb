#
# Cookbook Name:: brightbox
# Recipe:: default
#
# Copyright 2013, Bubble
# Based on https://github.com/filtersquad/chef-brightbox
#
# The MIT License (MIT) 

apt_repository "brightbox-ruby-ng-#{node['lsb']['codename']}" do
  uri          "http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu"
  distribution node['lsb']['codename']
  components   %w(main)
  keyserver    "keyserver.ubuntu.com"
  key          "C3173AA6"
  action       :add
  notifies     :run, "execute[apt-get update]", :immediately
end

%w(build-essential ruby1.9.1-full ruby-switch).each do |name|
  apt_package name do
    action :install
  end
end

execute "ruby-switch --set ruby1.9.1" do
  action :run
  not_if "ruby-switch --check | grep -q 'ruby1.9.1'"
end

cookbook_file "/etc/gemrc" do
  action :create_if_missing
  source "gemrc"
  mode   "0644"
end

%w(bundler rake rubygems-bundler).each do |gem|
  gem_package gem do
    action :install
  end
end

execute "gem regenerate_binstubs" do
  action :nothing
  subscribes :run, resources('gem_package[rubygems-bundler]')
end

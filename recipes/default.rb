#
# Cookbook Name:: brightbox
# Recipe:: default
#
# Copyright 2013, Bubble
# Based on https://github.com/filtersquad/chef-brightbox
#
# The MIT License (MIT)
include_recipe "apt"
include_recipe "build-essential"

apt_repository "brightbox-ruby-ng-#{node['lsb']['codename']}" do
  uri          "http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu"
  distribution node['lsb']['codename']
  components   %w(main)
  keyserver    "keyserver.ubuntu.com"
  key          "C3173AA6"
  action       :add
  notifies     :run, "execute[apt-get update]", :immediately
end

cookbook_file "/etc/gemrc" do
  action :create_if_missing
  source "gemrc"
  mode   "0644"
end

package node["brightbox"]["version"]
package "#{node["brightbox"]["version"]}-dev"

gem_package "bundler"

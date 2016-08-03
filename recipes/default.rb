#
# Cookbook Name:: hadoop-node-manager
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'hadoop::hadoop_yarn_nodemanager'

ruby_block  "set-env-java-home" do
  block do
    ENV["JAVA_HOME"] = node['hadoop-node-manager']['Java_Home']
  end
end

bash 'set-env-bashrc' do
  code <<-EOH
    echo -e "export JAVA_HOME=$JAVA_HOME" >> ~/.bash_profile
    echo -e "export PATH=$PATH" >> ~/.bash_profile
    source ~/.bash_profile
  EOH
end

ruby_block 'hadoop-yarn-nodemanager-enable-start' do
  block do
    %w(enable start).each do |action|
      resources('service[hadoop-yarn-nodemanager]').run_action(action.to_sym)
    end
  end
end

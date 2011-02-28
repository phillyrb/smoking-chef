groups = Hash.new { |h,k| h[k] = [] }

node[:users].each do |username, data|
  home_dir = "/home/#{username}"

  user username do
    uid data['uid']
    gid data['gid']
    shell data['shell']
    comment data['comment']
    supports :manage_home => true
    home home_dir
  end

  directory "#{home_dir}/.ssh" do
    owner username
    group data['gid'] || username
    mode "0700"
  end

  template "#{home_dir}/.ssh/authorized_keys" do
    source "authorized_keys.erb"
    owner username
    group data['gid'] || username
    mode "0600"
    variables :ssh_keys => data['ssh_keys']
  end

  data['groups'].each do |g|
    groups[g] << username
  end
end

groups.each do |k,v|
  v.uniq!

  group k do
    members v
    action [:create, :modify]
    append true
  end
end

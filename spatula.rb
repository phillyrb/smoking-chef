class SpatulaProvisioner < Vagrant::Provisioners::Base

  class Config < Vagrant::Config::Base
    attr_accessor :node
  end

  def provision!
    @spatula_path = ENV["PATH"].
      split(File::PATH_SEPARATOR).
      map { |x| File.join(x, "spatula") }.
      select { |x| File.executable?(x) }

    @spatula_path = @spatula_path[0] rescue nil

    raise "Cannot find spatula: gem install spatula" unless @spatula_path

    extra_args = %W[--port #{vm.ssh.port} --identity #{config.top.ssh.private_key_path}]

    args = [@spatula_path] + %w[prepare vagrant@localhost] + extra_args
    system(*args)

    args = [@spatula_path] + %W[cook vagrant@localhost #{config.node}] + extra_args
    system(*args)
  end
end

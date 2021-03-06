require File.dirname(__FILE__) + '/../helper.rb'

class TestOptions < Test::Unit::TestCase

  def setup
    @defaults = {
      :database => :sqlite,
      :template => :stable,
      :profile  => :complete,
    }
    @databases = [ :postgresql, :mysql, :sqlite ]
    @templates = [ :stable, :edge ]
    @profiles  = [ :complete, :minimal ]
  end
  
  def test_should_set_the_default_options
    opts = Options.new(%w[ appname ])
    @defaults.each { |k,v| assert_equal v, opts[k] }
  end

  def test_should_be_able_to_set_options
    opts = Options.new(%w[ --mysql --edge --minimal myapp ])
    assert_equal :mysql,   opts[:database]
    assert_equal :edge,    opts[:template]
    assert_equal :minimal, opts[:profile]
    assert_equal "myapp",  opts[:app_name]
  end

  def test_should_merge_options
    opts = Options.new(%w[ --mysql myapp ])
    env_opts = Options.new(%w[ --edge ])
    options = opts.merge(env_opts)
    assert_equal :mysql,    options[:database]
    assert_equal :edge,     options[:template]
    assert_equal :complete, options[:profile]
    assert_equal "myapp",   options[:app_name]
  end

  def test_should_detect_invalid_arguments
    opts = Options.new(%w[ --wrong ])
    assert_equal "invalid option: --wrong", opts[:invalid_argument]
  end

  def test_should_have_a_version
    opts = Options.new(%w[ --version myapp])
    version_file = File.dirname(__FILE__) + "/../../VERSION"
    version = File.read(version_file).strip
    assert_equal version, opts[:version]
  end

  def test_should_be_able_to_set_default_locale
    opts = Options.new(%w[ --ca myaapp ])
    assert_equal :ca, opts[:locale]
  end

  def test_should_be_able_to_set_exception_notification_options
    opts = Options.new(%w[ --recipient r@r.com --sender s@s.com myapp])
    assert_equal "r@r.com", opts[:exception_recipient]
    assert_equal "s@s.com", opts[:sender_address]
  end
  
  def test_should_be_able_to_add_custom_plugins
    opts = Options.new(%w[ --custom ubiquo_media myapp ])
    assert_equal :custom, opts[:profile]
    assert_equal ["ubiquo_media"].inspect, opts[:plugins].inspect
  end
  
end

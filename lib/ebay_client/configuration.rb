class EbayClient::Configuration
  class ApiKey
    attr_accessor :sandbox_appid, :sandbox_devid, :sandbox_certid, :live_appid, :live_devid, :live_certid

    def initialize key_values
      key_values.each do |key, val|
        instance_variable_set "@#{key}", val
      end
    end
  end

  attr_accessor :version, :siteid, :routing, :use_sandbox, :live_url, :sandbox_url, :api_keys, :warning_level, :error_language, :current_key, :savon_log_level, :token

  def initialize presets
    presets.each do |key, val|
      instance_variable_set "@#{key}", val
    end

    @api_keys = @api_keys.map do |key_values|
      ApiKey.new key_values
    end.shuffle
    @current_key = @api_keys.first
  end

  def override options
    options.each do |key, val|
      instance_variable_set "@#{key}", val
    end
  end

  def next_key!
    i = @api_keys.index(@current_key) + 1
    i = 0 if i >= @api_keys.count
    @current_key = @api_keys[i]
  end

  def appid
    use_sandbox ? @current_key.sandbox_appid : @current_key.live_appid
  end

  def devid
    use_sandbox ? @current_key.sandbox_devid : @current_key.live_appid
  end

  def certid
    use_sandbox ? @current_key.sandbox_certid : @current_key.live_appid
  end

  def url
    use_sandbox ? sandbox_url : live_url
  end

  def wsdl_file
    @wsdl_file ||= File.expand_path "../../../vendor/ebay/#{version}.wsdl", __FILE__
  end

  def preload?
    !!@preload
  end

  class << self
    def load file
      defaults = load_defaults
      configs = YAML.load_file file

      configs.each_pair do |env, presets|
        env_defaults = defaults[env] || {}
        presets = presets || {}

        configs[env] = new env_defaults.merge(presets)
      end

      configs
    end

    protected
    def load_defaults
      YAML.load_file defaults_file
    end

    def defaults_file
      File.expand_path '../../../config/defaults.yml', __FILE__
    end
  end
end

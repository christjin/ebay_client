class EbayClient::Request
  attr_reader :xml

  def initialize api, name, body
    @api = api
    @name = name
    @body = body || {}
    @xml = nil
  end

  def normalized_name
    @normalized_name ||= @name.to_s.camelcase.gsub(/ebay/i, 'eBay').gsub(/!/, '')
  end

  def normalized_body
    @normalized_body ||= @body.to_hash.merge body_defaults
  end

  def execute
    read_response execute_request
  end

  protected
  def body_defaults
    {
        :Version => @api.configuration.version,
        :WarningLevel => @api.configuration.warning_level,
        :ErrorLanguage => @api.configuration.error_language
    }
  end

  def execute_request
    @api.client.request(@api.namespace, normalized_name + 'Request') do |soap|
      soap.endpoint = @api.endpoint.url_for normalized_name
      soap.header = @api.header.to_hash
      soap.body = normalized_body
      @xml = soap.to_xml
    end
  end

  def read_response response
    EbayClient::Response.new response
  end
end

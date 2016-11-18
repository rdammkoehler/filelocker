require_relative 'token_authenticator'

module FileLockerExample
  class SecurityHelper
    def initialize config
      self.config = config
    end

    def authorized? request
      auth = FileLockerExample::TokenAuthenticator.new(JWT, config['oauth']['public_key'], config['oauth']['audience'])
      auth.validate(extract_token(request))
    end

    private

    attr_accessor :config

    def extract_token request
      raise FileLockerExample::AuthError, 'No Authentication provided' unless request.env['HTTP_AUTHORIZATION']
      request.env['HTTP_AUTHORIZATION'].split(' ')[1]
    end
  end
end

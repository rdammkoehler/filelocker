require 'jwt'

module FileLockerExample
  class FileLockerExample::AuthError < RuntimeError
  end

  class TokenAuthenticator
    def initialize jwt, public_cert, app_name
      self.jwt = jwt
      self.public_key = OpenSSL::PKey::RSA.new Base64.decode64 public_cert
      self.app_name = app_name
    end

    def validate token
      aud = audience token
      raise AuthError, "#{aud} not authorized to access this resource." unless aud == app_name
      true
    end

    private

    attr_accessor :jwt, :public_key, :app_name

    def audience token
      decoded = jwt.decode token, public_key, true, :algorithm => 'RS256'
      decoded[0]['aud']
    rescue JWT::ExpiredSignature
      raise AuthError, 'Supplied token is expired.'
    rescue JWT::DecodeError
      raise AuthError, 'Supplied token is invalid.'
    end
  end
end

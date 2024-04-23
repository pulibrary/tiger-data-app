# frozen_string_literal: true
module Mediaflux
  module Http
    class LogonRequest < Request
      # Specifies the logon service within the Mediaflux API
      # @return [String]
      def self.service
        "system.logon"
      end

      # Specifies the user domain for the Mediaflux API authentication
      # @return [String]
      def self.mediaflux_domain
        mediaflux["api_domain"]
      end

      # Specifies the user for the Mediaflux API authentication
      # @return [String]
      def self.mediaflux_user
        mediaflux["api_user"]
      end

      # Specifies the password for the Mediaflux API authentication
      # @return [String]
      def self.mediaflux_password
        mediaflux["api_password"]
      end

      def initialize(domain: self.class.mediaflux_domain, user: self.class.mediaflux_user, password: self.class.mediaflux_password, identity_token: nil)
        @domain = domain
        @user = user
        @password = password
        @identity_token = identity_token
        super()
      end

      # Authenticates the Mediaflux API using the credentials set within the Rails configuration,
      # and set the token for the API session
      # @return [Net::HTTPResponse] The response from the Mediaflux API
      def resolve
        @session_token = nil
        super
        @session_token = response_session_token

        @http_response
      end

      private

        def response_session_element
          response_xml.xpath("response/reply/result/session")
        end

        def response_session_token
          value = response_session_element.text
          value.strip
        end

        def build_http_request_body(name:)
          super do |xml|
            xml.args do
              if @identity_token.nil?
                xml.domain @domain
                xml.user @user
                xml.password @password
              else
                xml.token @identity_token
              end
            end
          end
        end
    end
  end
end

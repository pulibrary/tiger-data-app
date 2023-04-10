# frozen_string_literal: true
module Mediaflux
  module Http
    class VersionRequest < Request
      # Constructor
      # @param session_token [String] the API token for the authenticated session
      def initialize(session_token:)
        super(session_token: session_token)
      end

      # Specifies the Mediaflux service to use when querying the version
      # @return [String]
      def self.service
        "server.version"
      end

      def version
        xml = response_xml
        {
          vendor: xml.xpath("/response/reply/result/vendor").text,
          version: xml.xpath("/response/reply/result/version").text
        }
      end
    end
  end
end

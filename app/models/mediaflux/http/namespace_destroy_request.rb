# frozen_string_literal: true
module Mediaflux
  module Http
    # Destroy a MediaFlux namespace and everything in it
    # @example
    #   Mediaflux::Http::NamespaceDestroyRequest.new(session_token: session_id, namespace: "/td-test-001/tigerdataNS/Banana1NS").destroy
    #   => true
    class NamespaceDestroyRequest < Request
      attr_reader :description, :namespace, :store

      # Constructor
      # @param session_token [String] the API token for the authenticated session
      # @param namespace [String] name of namespace to be destroyed
      def initialize(session_token:, namespace:)
        super(session_token: session_token)
        @namespace = namespace
      end

      def destroy
        self.resolve
        if error?
          self.response_error
        end
      end

      # Specifies the Mediaflux service to use when destroying namespaces
      # @return [String]
      def self.service
        "asset.namespace.hard.destroy"
      end

      private

        def build_http_request_body(name:)
          super do |xml|
            xml.args do
              xml.namespace @namespace
              xml.atomic true
            end
          end
        end
    end
  end
end

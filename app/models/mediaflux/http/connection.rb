# frozen_string_literal: true
module Mediaflux
  module Http
    class Connection
      # The host nome for the Mediaflux server
      # @return [String]
      def self.host
        if Flipflop.alternate_mediaflux?
          Rails.configuration.mediaflux["api_alternate_host"]
        else
          Rails.configuration.mediaflux["api_host"]
        end
      end

      # The host port for the Mediaflux server
      # @return [Integer]
      def self.port
        if Flipflop.alternate_mediaflux?
          Rails.configuration.mediaflux["api_alternate_port"].to_i
        else
          Rails.configuration.mediaflux["api_port"].to_i
        end
      end

      # The host transport for the Mediaflux server
      # @return [String]
      def self.transport
        if Flipflop.alternate_mediaflux?
          Rails.configuration.mediaflux["api_alternate_transport"]
        else
          Rails.configuration.mediaflux["api_transport"]
        end
      end
    end
  end
end

# frozen_string_literal: true
module Mediaflux
  class Asset
    attr_accessor :id, :name, :path, :collection, :tz, :size

    def initialize(id:, name:, path: nil, collection:, last_modified_mf: nil, tz: nil, size: 0)
      @id = id
      @name = name
      @path = path
      @collection = collection
      @size = size
      @last_modified_mf = last_modified_mf
      @tz = tz
    end

    # Returns the path to the asset but without the root namespace as part of it.
    #
    # Example:
    #   path        -> "/tigerdata/projectg/folder1/file-abc.txt"
    #   path_short  -> "/projectg/folder1/file-abc.txt"
    def path_short
      if path.starts_with?(Rails.configuration.mediaflux["api_root_ns"])
        path[Rails.configuration.mediaflux["api_root_ns"].length..-1]
      else
        path
      end
    end

    # Returns the last modified data but using the standard ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601)
    def last_modified
      # https://nandovieira.com/working-with-dates-on-ruby-on-rails
      # https://api.rubyonrails.org/classes/ActiveSupport/TimeWithZone.html
      # https://apidock.com/ruby/DateTime/strftime
      # Mediaflux dates are in UTC and look like this "07-Feb-2024 21:48:01"
      Time.zone.parse(@last_modified_mf).in_time_zone("EST").strftime("%Y-%m-%dT%H:%M:%S%:z")
    end

    # Returns the path for the asset
    # For a collection returns the path_short, but for a file is the dirname of the path_short
    #
    # Example for a file:
    #   path        -> "/tigerdata/projectg/folder1/file-abc.txt"
    #   path_short  -> "/projectg/folder1/file-abc.txt"
    #   path_only  -> "/projectg/folder1"
    # Example for a collection:
    #   path        -> "/tigerdata/projectg/folder1"
    #   path_short  -> "/projectg/folder1"
    #   path_only  -> "/projectg/folder1"
    def path_only
      if collection
        path_short
      else
        p = Pathname.new(path_short)
        p.dirname.to_s
      end
    end
  end
end
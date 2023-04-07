# frozen_string_literal: true
require "net/http"
require "nokogiri"

# A very simple client to interface with a MediaFlux server.
# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
class MediaFluxClient
  def initialize(host, domain, user, password, transport)
    @host = host
    @domain = domain
    @user = user
    @password = password
    @base_url = transport == "https" ? "https://#{host}:443/__mflux_svc__/" : "http://#{host}:80/__mflux_svc__/"
    @xml_declaration = '<?xml version="1.0" encoding="UTF-8"?>'
    connect
  end

  # Fetches MediaFlux's server version information (in XML)
  def version
    version_request = Mediaflux::Http::VersionRequest.new(session_token: @session_id)
    version_request.version
  end

  # Terminates the current session
  def logout
    logout_request = Mediaflux::Http.logoutRequest.new(session_token: @session_id)
    logout_request.response_body
  end

  # Queries for assets on the given namespace
  def query(aql_where, idx: 1, size: 10)
    query_request = Mediaflux::Http::QueryRequest.new(session_token: @session_id, aql_query: aql_where, size: size, idx: idx)
    query_request.result
  end

  def query_collection(collection_id, idx: 1, size: 10)
    query_request = Mediaflux::Http::QueryRequest.new(session_token: @session_id, collection: collection_id, size: size, idx: idx)
    query_request.result
  end

  # Fetches metadata for the given asset it
  def get_metadata(id)
    get_request = Mediaflux::Http::GetMetadataRequest.new(session_token: @session_id, id: id)
    get_request.metadata
  end

  def get_content(id)
    xml_request = <<-XML_BODY
      <request>
        <service name="asset.get" session="#{@session_id}" data-out-min="1" data-out-max="1">
          <args>
            <id>#{id}</id>
          </args>
        </service>
      </request>
    XML_BODY
    response_body = http_post(xml_request, true)
    response_body
  end

  def set_note(id, mf_note)
    set_request = Mediaflux::Http::SetNoteRequest.new(session_token: @session_id, id: id, note: mf_note)
    set_request.response_body
  end

  # Creates an empty file (no content) with the name provided
  def create(namespace, _filename)
    create_request = Mediaflux::Http::CreateAssetRequest.new(session_token: @session_id, namespace: namespace, name: nam, collection: false)
    create_request.response_body
  end

  # Creates a collection asset inside a namespace
  def create_collection_asset(namespace, name)
    create_request = Mediaflux::Http::CreateAssetRequest.new(session_token: @session_id, namespace: namespace, name: name)
    create_request.response_body
  end

  # Creates an empty file (no content) with the name provided in the collection indicated
  def create_in_collection(collection, filename)
    create_request = Mediaflux::Http::CreateAssetRequest.new(session_token: @session_id, parent_id: collection, name: filename, collection: false)
    create_request.response_body
  end

  # Uploads a file to the given namespace
  def upload(namespace, filename_fullpath)
    filename = File.basename(filename_fullpath)
    xml_request = <<-XML_BODY
    <request>
      <service name="asset.create" session="#{@session_id}">
        <args>
          <namespace create="True">#{namespace}</namespace>
          <name>#{filename}</name>
          <meta><mf-name><name>#{filename}</name></mf-name></meta>
        </args>
        <attachment></attachment>
      </service>
    </request>
    XML_BODY
    file_content = File.read(filename_fullpath)
    response_body = http_post(xml_request, true, file_content)
    response_body
  end

  private

    # rubocop:disable Metrics/AbcSize
    def http_post(payload, mflux = false, file_content = nil)
      url = @base_url
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      if url.start_with?("https://")
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Post.new(url)

      xml = @xml_declaration + payload
      if mflux == false
        request["Content-Type"] = "text/xml"
        request.body = xml
      else
        # Here be dragons
        # Requests are built different for this content-type
        request["Content-Type"] = "application/mflux"
        mflux_request = if file_content.nil?
                          xml_separator(xml) + xml
                        else
                          xml_separator(xml) + xml + content_separator(file_content) + file_content
                        end
        request.body = mflux_request
      end

      response = http.request(request)
      if response.content_type == "application/mflux"
        metadata_only_header = "\u0001\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000y\u0000\u0000\u0000\u0000\u0000\btext/xml"
        if response.body[0..23] == metadata_only_header
          # Response includes only metadata
          response.body[24..]
        else
          # Here be more dragons.
          # Response include metadata + content.
          # Horrible hack to extract the content
          header = response.body[0..23]
          metadata_size = length_from_header(header)
          start_at = metadata_size + 24 + 24 + 2 # metadata_size + header + header + 2
          response.body[start_at..]
        end
      else
        response.body
      end
    end
    # rubocop:enable Metrics/AbcSize

    def xml_separator(xml)
      # 01 00 xx xx xx xx xx xx xx xx 00 00 00 01 yy yy
      file_format = "text/xml"
      part1 = 1.chr + 0.chr + hex_bytes(xml.length)
      part2 = 0.chr + 0.chr + 0.chr + 1.chr + 0.chr + file_format.length.chr
      part1 + part2 + file_format
    end

    def content_separator(content)
      # 01 00 xx xx xx xx xx xx xx xx 00 00 00 01 00 00
      part1 = 1.chr + 0.chr + hex_bytes(content.length)
      part2 = 0.chr + 0.chr + 0.chr + 1.chr + 0.chr + 0.chr
      part1 + part2
    end

    def hex_bytes(number)
      hex_bytes = []
      # Force the string to be 16 characters long so we can guarantee 8 pairs.
      number_hex = number.to_s(16).rjust(16, "0")
      8.times do |i|
        n = i * 2
        hex = number_hex[n..n + 1]
        hex_bytes << hex.to_i(16).chr
      end
      hex_bytes.join
    end

    # header: "\x01\x00\x00\x00\x00\x00\x00\x00\a\xF7\x00\x00\x00\x01\x00\btext/xml"
    # length: 7F7 hex => 2039 dec
    def length_from_header(header)
      hex_str = ""
      data = header[2..9]
      data.each_char do |c|
        hex_str += c.ord.to_s(16).rjust(2, "0")
      end
      hex_str.to_i(16)
    end

    def connect
      session = Mediaflux::Session.new(use_ssl: true)
      @session_id = session.logon
    end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/ClassLength

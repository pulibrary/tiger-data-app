# frozen_string_literal: true
require "nokogiri"
require "xml_utilities"

describe "xml_utilities" do
  it "translates xml to hash" do
    expect(xml_doc_to_hash(Nokogiri("<a></a>"))).to eq({ name: "a" })
  end

  it "translates xml to hash" do
    expect(xml_doc_to_html(Nokogiri("<a></a>"))).to eq("<pre>:name: a\n</pre>")
  end

  it "translates asset type definition to hash" do
    expect(xml_doc_to_html(Nokogiri('<definition><element name="my_string" type="string" /></definition>'))).to eq(
"<pre>:name: definition
:subelements:
- :name: element
  :attributes:
  - :name: name
    :text: my_string
  - :name: type
    :text: string
</pre>"
)
  end

  # If we want more tests or longer tests, they should be checked in as fixtures.
end

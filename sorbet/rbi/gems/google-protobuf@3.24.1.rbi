# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `google-protobuf` gem.
# Please instead update this file by running `bin/tapioca gem google-protobuf`.


# We define these before requiring the platform-specific modules.
# That way the module init can grab references to these.
#
# source://google-protobuf//lib/google/protobuf/message_exts.rb#31
module Google; end

# source://google-protobuf//lib/google/protobuf/message_exts.rb#32
module Google::Protobuf
  class << self
    # source://google-protobuf//lib/google/protobuf.rb#71
    def decode(klass, proto, options = T.unsafe(nil)); end

    # source://google-protobuf//lib/google/protobuf.rb#75
    def decode_json(klass, json, options = T.unsafe(nil)); end

    def deep_copy(_arg0); end
    def discard_unknown(_arg0); end

    # source://google-protobuf//lib/google/protobuf.rb#63
    def encode(msg, options = T.unsafe(nil)); end

    # source://google-protobuf//lib/google/protobuf.rb#67
    def encode_json(msg, options = T.unsafe(nil)); end
  end
end

# source://google-protobuf//lib/google/protobuf/message_exts.rb#52
class Google::Protobuf::AbstractMessage
  include ::Google::Protobuf::MessageExts
  extend ::Google::Protobuf::MessageExts::ClassMethods

  def initialize(*_arg0); end

  def ==(_arg0); end
  def [](_arg0); end
  def []=(_arg0, _arg1); end
  def clone; end
  def dup; end
  def eql?(_arg0); end
  def freeze; end
  def hash; end
  def inspect; end
  def method_missing(*_arg0); end
  def to_h; end
  def to_s; end

  private

  def respond_to_missing?(*_arg0); end

  class << self
    def decode(*_arg0); end
    def decode_json(*_arg0); end
    def descriptor; end
    def encode(*_arg0); end
    def encode_json(*_arg0); end
  end
end

class Google::Protobuf::Descriptor
  include ::Enumerable

  def initialize(_arg0, _arg1, _arg2); end

  def each; end
  def each_oneof; end
  def file_descriptor; end
  def lookup(_arg0); end
  def lookup_oneof(_arg0); end
  def msgclass; end
  def name; end
end

# Re-open the class (the rest of the class is implemented in C)
#
# source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#457
class Google::Protobuf::DescriptorPool
  def add_serialized_file(_arg0); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#458
  def build(&block); end

  def lookup(_arg0); end

  class << self
    def generated_pool; end
  end
end

class Google::Protobuf::DescriptorProto < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::DescriptorProto::ExtensionRange < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::DescriptorProto::ReservedRange < ::Google::Protobuf::AbstractMessage; end

class Google::Protobuf::EnumDescriptor
  include ::Enumerable

  def initialize(_arg0, _arg1, _arg2); end

  def each; end
  def enummodule; end
  def file_descriptor; end
  def lookup_name(_arg0); end
  def lookup_value(_arg0); end
  def name; end
end

class Google::Protobuf::EnumDescriptorProto < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::EnumDescriptorProto::EnumReservedRange < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::EnumOptions < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::EnumValueDescriptorProto < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::EnumValueOptions < ::Google::Protobuf::AbstractMessage; end

# source://google-protobuf//lib/google/protobuf.rb#39
class Google::Protobuf::Error < ::StandardError; end

class Google::Protobuf::ExtensionRangeOptions < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::ExtensionRangeOptions::Declaration < ::Google::Protobuf::AbstractMessage; end

module Google::Protobuf::ExtensionRangeOptions::VerificationState
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#43
Google::Protobuf::ExtensionRangeOptions::VerificationState::DECLARATION = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#43
Google::Protobuf::ExtensionRangeOptions::VerificationState::UNVERIFIED = T.let(T.unsafe(nil), Integer)

class Google::Protobuf::FeatureSet < ::Google::Protobuf::AbstractMessage; end

module Google::Protobuf::FeatureSet::EnumType
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#72
Google::Protobuf::FeatureSet::EnumType::CLOSED = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#72
Google::Protobuf::FeatureSet::EnumType::ENUM_TYPE_UNKNOWN = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#72
Google::Protobuf::FeatureSet::EnumType::OPEN = T.let(T.unsafe(nil), Integer)

module Google::Protobuf::FeatureSet::FieldPresence
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#71
Google::Protobuf::FeatureSet::FieldPresence::EXPLICIT = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#71
Google::Protobuf::FeatureSet::FieldPresence::FIELD_PRESENCE_UNKNOWN = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#71
Google::Protobuf::FeatureSet::FieldPresence::IMPLICIT = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#71
Google::Protobuf::FeatureSet::FieldPresence::LEGACY_REQUIRED = T.let(T.unsafe(nil), Integer)

module Google::Protobuf::FeatureSet::JsonFormat
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#76
Google::Protobuf::FeatureSet::JsonFormat::ALLOW = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#76
Google::Protobuf::FeatureSet::JsonFormat::JSON_FORMAT_UNKNOWN = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#76
Google::Protobuf::FeatureSet::JsonFormat::LEGACY_BEST_EFFORT = T.let(T.unsafe(nil), Integer)

module Google::Protobuf::FeatureSet::MessageEncoding
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#75
Google::Protobuf::FeatureSet::MessageEncoding::DELIMITED = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#75
Google::Protobuf::FeatureSet::MessageEncoding::LENGTH_PREFIXED = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#75
Google::Protobuf::FeatureSet::MessageEncoding::MESSAGE_ENCODING_UNKNOWN = T.let(T.unsafe(nil), Integer)

module Google::Protobuf::FeatureSet::RepeatedFieldEncoding
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#73
Google::Protobuf::FeatureSet::RepeatedFieldEncoding::EXPANDED = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#73
Google::Protobuf::FeatureSet::RepeatedFieldEncoding::PACKED = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#73
Google::Protobuf::FeatureSet::RepeatedFieldEncoding::REPEATED_FIELD_ENCODING_UNKNOWN = T.let(T.unsafe(nil), Integer)

module Google::Protobuf::FeatureSet::StringFieldValidation
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#74
Google::Protobuf::FeatureSet::StringFieldValidation::HINT = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#74
Google::Protobuf::FeatureSet::StringFieldValidation::MANDATORY = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#74
Google::Protobuf::FeatureSet::StringFieldValidation::NONE = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#74
Google::Protobuf::FeatureSet::StringFieldValidation::STRING_FIELD_VALIDATION_UNKNOWN = T.let(T.unsafe(nil), Integer)

class Google::Protobuf::FieldDescriptor
  def initialize(_arg0, _arg1, _arg2); end

  def clear(_arg0); end
  def default; end
  def get(_arg0); end
  def has?(_arg0); end
  def json_name; end
  def label; end
  def name; end
  def number; end
  def set(_arg0, _arg1); end
  def submsg_name; end
  def subtype; end
  def type; end
end

class Google::Protobuf::FieldDescriptorProto < ::Google::Protobuf::AbstractMessage; end

module Google::Protobuf::FieldDescriptorProto::Label
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#46
Google::Protobuf::FieldDescriptorProto::Label::LABEL_OPTIONAL = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#46
Google::Protobuf::FieldDescriptorProto::Label::LABEL_REPEATED = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#46
Google::Protobuf::FieldDescriptorProto::Label::LABEL_REQUIRED = T.let(T.unsafe(nil), Integer)

module Google::Protobuf::FieldDescriptorProto::Type
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_BOOL = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_BYTES = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_DOUBLE = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_ENUM = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_FIXED32 = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_FIXED64 = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_FLOAT = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_GROUP = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_INT32 = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_INT64 = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_MESSAGE = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_SFIXED32 = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_SFIXED64 = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_SINT32 = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_SINT64 = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_STRING = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_UINT32 = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#45
Google::Protobuf::FieldDescriptorProto::Type::TYPE_UINT64 = T.let(T.unsafe(nil), Integer)

class Google::Protobuf::FieldOptions < ::Google::Protobuf::AbstractMessage; end

module Google::Protobuf::FieldOptions::CType
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#58
Google::Protobuf::FieldOptions::CType::CORD = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#58
Google::Protobuf::FieldOptions::CType::STRING = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#58
Google::Protobuf::FieldOptions::CType::STRING_PIECE = T.let(T.unsafe(nil), Integer)

class Google::Protobuf::FieldOptions::EditionDefault < ::Google::Protobuf::AbstractMessage; end

module Google::Protobuf::FieldOptions::JSType
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#59
Google::Protobuf::FieldOptions::JSType::JS_NORMAL = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#59
Google::Protobuf::FieldOptions::JSType::JS_NUMBER = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#59
Google::Protobuf::FieldOptions::JSType::JS_STRING = T.let(T.unsafe(nil), Integer)

module Google::Protobuf::FieldOptions::OptionRetention
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#60
Google::Protobuf::FieldOptions::OptionRetention::RETENTION_RUNTIME = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#60
Google::Protobuf::FieldOptions::OptionRetention::RETENTION_SOURCE = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#60
Google::Protobuf::FieldOptions::OptionRetention::RETENTION_UNKNOWN = T.let(T.unsafe(nil), Integer)

module Google::Protobuf::FieldOptions::OptionTargetType
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#61
Google::Protobuf::FieldOptions::OptionTargetType::TARGET_TYPE_ENUM = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#61
Google::Protobuf::FieldOptions::OptionTargetType::TARGET_TYPE_ENUM_ENTRY = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#61
Google::Protobuf::FieldOptions::OptionTargetType::TARGET_TYPE_EXTENSION_RANGE = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#61
Google::Protobuf::FieldOptions::OptionTargetType::TARGET_TYPE_FIELD = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#61
Google::Protobuf::FieldOptions::OptionTargetType::TARGET_TYPE_FILE = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#61
Google::Protobuf::FieldOptions::OptionTargetType::TARGET_TYPE_MESSAGE = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#61
Google::Protobuf::FieldOptions::OptionTargetType::TARGET_TYPE_METHOD = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#61
Google::Protobuf::FieldOptions::OptionTargetType::TARGET_TYPE_ONEOF = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#61
Google::Protobuf::FieldOptions::OptionTargetType::TARGET_TYPE_SERVICE = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#61
Google::Protobuf::FieldOptions::OptionTargetType::TARGET_TYPE_UNKNOWN = T.let(T.unsafe(nil), Integer)

class Google::Protobuf::FileDescriptor
  def initialize(_arg0, _arg1, _arg2); end

  def name; end
  def syntax; end
end

class Google::Protobuf::FileDescriptorProto < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::FileDescriptorSet < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::FileOptions < ::Google::Protobuf::AbstractMessage; end

module Google::Protobuf::FileOptions::OptimizeMode
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#54
Google::Protobuf::FileOptions::OptimizeMode::CODE_SIZE = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#54
Google::Protobuf::FileOptions::OptimizeMode::LITE_RUNTIME = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#54
Google::Protobuf::FileOptions::OptimizeMode::SPEED = T.let(T.unsafe(nil), Integer)

class Google::Protobuf::GeneratedCodeInfo < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::GeneratedCodeInfo::Annotation < ::Google::Protobuf::AbstractMessage; end

module Google::Protobuf::GeneratedCodeInfo::Annotation::Semantic
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#81
Google::Protobuf::GeneratedCodeInfo::Annotation::Semantic::ALIAS = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#81
Google::Protobuf::GeneratedCodeInfo::Annotation::Semantic::NONE = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#81
Google::Protobuf::GeneratedCodeInfo::Annotation::Semantic::SET = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#16
module Google::Protobuf::Internal; end

class Google::Protobuf::Internal::Arena; end

# source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#17
class Google::Protobuf::Internal::AtomicCounter
  # @return [AtomicCounter] a new instance of AtomicCounter
  #
  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#18
  def initialize; end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#23
  def get_and_increment; end
end

# source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#32
class Google::Protobuf::Internal::Builder
  # @return [Builder] a new instance of Builder
  #
  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#35
  def initialize(pool); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#50
  def add_enum(name, &block); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#40
  def add_file(name, options = T.unsafe(nil), &block); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#46
  def add_message(name, &block); end

  # ---- Internal methods, not part of the DSL ----
  #
  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#56
  def build; end

  private

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#62
  def internal_add_file(file_builder); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#68
  def internal_default_file; end
end

# source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#437
class Google::Protobuf::Internal::EnumBuilder
  # @return [EnumBuilder] a new instance of EnumBuilder
  #
  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#438
  def initialize(name, file_proto); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#445
  def value(name, number); end
end

# source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#75
class Google::Protobuf::Internal::FileBuilder
  # @return [FileBuilder] a new instance of FileBuilder
  #
  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#76
  def initialize(pool, name, options = T.unsafe(nil)); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#90
  def add_enum(name, &block); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#84
  def add_message(name, &block); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#282
  def build; end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#240
  def fix_nesting; end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#232
  def get_parent_msg(msgs_by_name, name, parent_name); end

  # The DSL can omit a package name; here we infer what the package is if
  # was not specified.
  #
  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#101
  def infer_package(names); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#278
  def internal_file_proto; end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#118
  def rewrite_enum_default(field); end

  # Historically we allowed enum defaults to be specified as a number.
  # In retrospect this was a mistake as descriptors require defaults to
  # be specified as a label. This can make a difference if multiple
  # labels have the same number.
  #
  # Here we do a pass over all enum defaults and rewrite numeric defaults
  # by looking up their labels.  This is complicated by the fact that the
  # enum definition can live in either the symtab or the file_proto.
  #
  # We take advantage of the fact that this is called *before* enums or
  # messages are nested in other messages, so we only have to iterate
  # one level deep.
  #
  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#175
  def rewrite_enum_defaults; end

  # We have to do some relatively complicated logic here for backward
  # compatibility.
  #
  # In descriptor.proto, messages are nested inside other messages if that is
  # what the original .proto file looks like.  For example, suppose we have this
  # foo.proto:
  #
  # package foo;
  # message Bar {
  #   message Baz {}
  # }
  #
  # The descriptor for this must look like this:
  #
  # file {
  #   name: "test.proto"
  #   package: "foo"
  #   message_type {
  #     name: "Bar"
  #     nested_type {
  #       name: "Baz"
  #     }
  #   }
  # }
  #
  # However, the Ruby generated code has always generated messages in a flat,
  # non-nested way:
  #
  # Google::Protobuf::DescriptorPool.generated_pool.build do
  #   add_message "foo.Bar" do
  #   end
  #   add_message "foo.Bar.Baz" do
  #   end
  # end
  #
  # Here we need to do a translation where we turn this generated code into the
  # above descriptor.  We need to infer that "foo" is the package name, and not
  # a message itself. */
  #
  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#222
  def split_parent_name(msg_or_enum); end
end

# source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#289
class Google::Protobuf::Internal::MessageBuilder
  # @return [MessageBuilder] a new instance of MessageBuilder
  #
  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#290
  def initialize(name, file_builder, file_proto); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#366
  def internal_add_field(label, name, type, number, type_class, options, oneof_index: T.unsafe(nil), proto3_optional: T.unsafe(nil)); end

  # ---- Internal methods, not part of the DSL ----
  #
  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#343
  def internal_add_synthetic_oneofs; end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#414
  def internal_msg_proto; end

  # Defines a new map field on this message type with the given key and
  # value types, tag number, and type class (for message and enum value
  # types). The key type must be :int32/:uint32/:int64/:uint64, :bool, or
  # :string. The value type type must be a Ruby symbol (as accepted by
  # FieldDescriptor#type=) and the type_class must be a string, if
  # present (as accepted by FieldDescriptor#submsg_name=).
  #
  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#325
  def map(name, key_type, value_type, number, value_type_class = T.unsafe(nil)); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#315
  def oneof(name, &block); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#298
  def optional(name, type, number, type_class = T.unsafe(nil), options = T.unsafe(nil)); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#302
  def proto3_optional(name, type, number, type_class = T.unsafe(nil), options = T.unsafe(nil)); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#311
  def repeated(name, type, number, type_class = T.unsafe(nil), options = T.unsafe(nil)); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#307
  def required(name, type, number, type_class = T.unsafe(nil), options = T.unsafe(nil)); end
end

# source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#419
class Google::Protobuf::Internal::OneofBuilder
  # @return [OneofBuilder] a new instance of OneofBuilder
  #
  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#420
  def initialize(name, msg_builder); end

  # source://google-protobuf//lib/google/protobuf/descriptor_dsl.rb#430
  def optional(name, type, number, type_class = T.unsafe(nil), options = T.unsafe(nil)); end
end

# source://google-protobuf//lib/google/protobuf/object_cache.rb#64
class Google::Protobuf::LegacyObjectCache
  # @return [LegacyObjectCache] a new instance of LegacyObjectCache
  #
  # source://google-protobuf//lib/google/protobuf/object_cache.rb#65
  def initialize; end

  # source://google-protobuf//lib/google/protobuf/object_cache.rb#71
  def get(key); end

  # source://google-protobuf//lib/google/protobuf/object_cache.rb#93
  def try_add(key, value); end

  private

  # source://google-protobuf//lib/google/protobuf/object_cache.rb#108
  def purge; end
end

class Google::Protobuf::Map
  include ::Enumerable

  def initialize(*_arg0); end

  def ==(_arg0); end
  def [](_arg0); end
  def []=(_arg0, _arg1); end
  def clear; end
  def clone; end
  def delete(_arg0); end
  def dup; end
  def each; end
  def freeze; end
  def has_key?(_arg0); end
  def hash; end
  def inspect; end
  def keys; end
  def length; end
  def merge(_arg0); end
  def size; end
  def to_h; end
  def values; end
end

# source://google-protobuf//lib/google/protobuf/message_exts.rb#33
module Google::Protobuf::MessageExts
  mixes_in_class_methods ::Google::Protobuf::MessageExts::ClassMethods

  # source://google-protobuf//lib/google/protobuf/message_exts.rb#43
  def to_json(options = T.unsafe(nil)); end

  # source://google-protobuf//lib/google/protobuf/message_exts.rb#47
  def to_proto(options = T.unsafe(nil)); end

  class << self
    # this is only called in jruby; mri loades the ClassMethods differently
    #
    # source://google-protobuf//lib/google/protobuf/message_exts.rb#36
    def included(klass); end
  end
end

# source://google-protobuf//lib/google/protobuf/message_exts.rb#40
module Google::Protobuf::MessageExts::ClassMethods; end

class Google::Protobuf::MessageOptions < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::MethodDescriptorProto < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::MethodOptions < ::Google::Protobuf::AbstractMessage; end

module Google::Protobuf::MethodOptions::IdempotencyLevel
  class << self
    def descriptor; end
    def lookup(_arg0); end
    def resolve(_arg0); end
  end
end

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#67
Google::Protobuf::MethodOptions::IdempotencyLevel::IDEMPOTENCY_UNKNOWN = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#67
Google::Protobuf::MethodOptions::IdempotencyLevel::IDEMPOTENT = T.let(T.unsafe(nil), Integer)

# source://google-protobuf//lib/google/protobuf/descriptor_pb.rb#67
Google::Protobuf::MethodOptions::IdempotencyLevel::NO_SIDE_EFFECTS = T.let(T.unsafe(nil), Integer)

Google::Protobuf::OBJECT_CACHE = T.let(T.unsafe(nil), Google::Protobuf::ObjectCache)

# A pointer -> Ruby Object cache that keeps references to Ruby wrapper
# objects.  This allows us to look up any Ruby wrapper object by the address
# of the object it is wrapping. That way we can avoid ever creating two
# different wrapper objects for the same C object, which saves memory and
# preserves object identity.
#
# We use WeakMap for the cache. If sizeof(long) > sizeof(VALUE), we also
# need a secondary Hash to store WeakMap keys, because our pointer keys may
# need to be stored as Bignum instead of Fixnum.  Since WeakMap is weak for
# both keys and values, a Bignum key will cause the WeakMap entry to be
# collected immediately unless there is another reference to the Bignum.
# This happens on 64-bit Windows, on which pointers are 64 bits but longs
# are 32 bits. In this case, we enable the secondary Hash to hold the keys
# and prevent them from being collected.
#
# source://google-protobuf//lib/google/protobuf/object_cache.rb#47
class Google::Protobuf::ObjectCache
  # @return [ObjectCache] a new instance of ObjectCache
  #
  # source://google-protobuf//lib/google/protobuf/object_cache.rb#48
  def initialize; end

  # source://google-protobuf//lib/google/protobuf/object_cache.rb#53
  def get(key); end

  # source://google-protobuf//lib/google/protobuf/object_cache.rb#57
  def try_add(key, value); end
end

class Google::Protobuf::OneofDescriptor
  include ::Enumerable

  def initialize(_arg0, _arg1, _arg2); end

  def each; end
  def name; end
end

class Google::Protobuf::OneofDescriptorProto < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::OneofOptions < ::Google::Protobuf::AbstractMessage; end

# source://google-protobuf//lib/google/protobuf.rb#40
class Google::Protobuf::ParseError < ::Google::Protobuf::Error; end

# source://google-protobuf//lib/google/protobuf/repeated_field.rb#50
class Google::Protobuf::RepeatedField
  include ::Enumerable
  extend ::Forwardable

  def initialize(*_arg0); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def &(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def *(*args, **_arg1, &block); end

  def +(_arg0); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def -(*args, **_arg1, &block); end

  def <<(_arg0); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def <=>(*args, **_arg1, &block); end

  def ==(_arg0); end
  def [](*_arg0); end
  def []=(_arg0, _arg1); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def assoc(*args, **_arg1, &block); end

  def at(*_arg0); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def bsearch(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def bsearch_index(*args, **_arg1, &block); end

  def clear; end
  def clone; end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def collect!(*args, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def combination(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def compact(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def compact!(*args, &block); end

  def concat(_arg0); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def count(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def cycle(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#128
  def delete(*args, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#128
  def delete_at(*args, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def delete_if(*args, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def dig(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def drop(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def drop_while(*args, **_arg1, &block); end

  def dup; end
  def each; end

  # array aliases into enumerable
  def each_index(*_arg0); end

  # @return [Boolean]
  #
  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#115
  def empty?; end

  # source://forwardable/1.3.3/forwardable.rb#231
  def eql?(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def fetch(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def fill(*args, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def find_index(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#81
  def first(n = T.unsafe(nil)); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def flatten(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def flatten!(*args, &block); end

  def freeze; end
  def hash; end

  # source://forwardable/1.3.3/forwardable.rb#231
  def include?(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def index(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def insert(*args, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def inspect(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def join(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def keep_if(*args, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#92
  def last(n = T.unsafe(nil)); end

  def length; end
  def map; end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def map!(*args, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def pack(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def permutation(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#104
  def pop(n = T.unsafe(nil)); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def pretty_print(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def pretty_print_cycle(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def product(*args, **_arg1, &block); end

  def push(*_arg0); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def rassoc(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def reject!(*args, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def repeated_combination(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def repeated_permutation(*args, **_arg1, &block); end

  def replace(_arg0); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def reverse(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def reverse!(*args, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def rindex(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def rotate(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def rotate!(*args, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def sample(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def select!(*args, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def shelljoin(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#128
  def shift(*args, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def shuffle(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def shuffle!(*args, &block); end

  def size; end
  def slice(*_arg0); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#128
  def slice!(*args, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def sort!(*args, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def sort_by!(*args, &block); end

  def to_ary; end

  # source://forwardable/1.3.3/forwardable.rb#231
  def to_s(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def transpose(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def uniq(*args, **_arg1, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#140
  def uniq!(*args, &block); end

  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#128
  def unshift(*args, &block); end

  def values_at; end

  # source://forwardable/1.3.3/forwardable.rb#231
  def |(*args, **_arg1, &block); end

  private

  def pop_one; end

  class << self
    private

    # source://google-protobuf//lib/google/protobuf/repeated_field.rb#127
    def define_array_wrapper_method(method_name); end

    # source://google-protobuf//lib/google/protobuf/repeated_field.rb#139
    def define_array_wrapper_with_result_method(method_name); end
  end
end

# propagates changes made by user of enumerator back to the original repeated field.
# This only applies in cases where the calling function which created the enumerator,
# such as #sort!, modifies itself rather than a new array, such as #sort
#
# source://google-protobuf//lib/google/protobuf/repeated_field.rb#183
class Google::Protobuf::RepeatedField::ProxyingEnumerator < ::Struct
  # source://google-protobuf//lib/google/protobuf/repeated_field.rb#184
  def each(*args, &block); end
end

Google::Protobuf::SIZEOF_LONG = T.let(T.unsafe(nil), Integer)
Google::Protobuf::SIZEOF_VALUE = T.let(T.unsafe(nil), Integer)
class Google::Protobuf::ServiceDescriptorProto < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::ServiceOptions < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::SourceCodeInfo < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::SourceCodeInfo::Location < ::Google::Protobuf::AbstractMessage; end

# source://google-protobuf//lib/google/protobuf.rb#41
class Google::Protobuf::TypeError < ::TypeError; end

class Google::Protobuf::UninterpretedOption < ::Google::Protobuf::AbstractMessage; end
class Google::Protobuf::UninterpretedOption::NamePart < ::Google::Protobuf::AbstractMessage; end

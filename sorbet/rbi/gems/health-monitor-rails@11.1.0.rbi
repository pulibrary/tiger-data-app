# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `health-monitor-rails` gem.
# Please instead update this file by running `bin/tapioca gem health-monitor-rails`.


# source://health-monitor-rails//lib/health_monitor/engine.rb#3
module HealthMonitor
  extend ::HealthMonitor

  # source://health-monitor-rails//lib/health_monitor/monitor.rb#21
  def check(request: T.unsafe(nil), params: T.unsafe(nil)); end

  # Returns the value of attribute configuration.
  #
  # source://health-monitor-rails//lib/health_monitor/monitor.rb#13
  def configuration; end

  # Sets the attribute configuration
  #
  # @param value the value to set the attribute configuration to.
  #
  # source://health-monitor-rails//lib/health_monitor/monitor.rb#13
  def configuration=(_arg0); end

  # @yield [configuration]
  #
  # source://health-monitor-rails//lib/health_monitor/monitor.rb#15
  def configure; end

  private

  # source://health-monitor-rails//lib/health_monitor/monitor.rb#38
  def provider_result(provider, request); end

  class << self
    # source://railties/7.0.7/lib/rails/engine.rb#405
    def railtie_helpers_paths; end

    # source://railties/7.0.7/lib/rails/engine.rb#394
    def railtie_namespace; end

    # source://railties/7.0.7/lib/rails/engine.rb#409
    def railtie_routes_url_helpers(include_path_helpers = T.unsafe(nil)); end

    # source://railties/7.0.7/lib/rails/engine.rb#397
    def table_name_prefix; end

    # source://railties/7.0.7/lib/rails/engine.rb#401
    def use_relative_model_naming?; end
  end
end

# source://health-monitor-rails//lib/health_monitor/configuration.rb#4
class HealthMonitor::Configuration
  # @return [Configuration] a new instance of Configuration
  #
  # source://health-monitor-rails//lib/health_monitor/configuration.rb#14
  def initialize; end

  # source://health-monitor-rails//lib/health_monitor/configuration.rb#33
  def add_custom_provider(custom_provider_class); end

  # Returns the value of attribute basic_auth_credentials.
  #
  # source://health-monitor-rails//lib/health_monitor/configuration.rb#7
  def basic_auth_credentials; end

  # Sets the attribute basic_auth_credentials
  #
  # @param value the value to set the attribute basic_auth_credentials to.
  #
  # source://health-monitor-rails//lib/health_monitor/configuration.rb#7
  def basic_auth_credentials=(_arg0); end

  # source://health-monitor-rails//lib/health_monitor/configuration.rb#23
  def cache(&_block); end

  # source://health-monitor-rails//lib/health_monitor/configuration.rb#23
  def database(&_block); end

  # source://health-monitor-rails//lib/health_monitor/configuration.rb#23
  def delayed_job(&_block); end

  # Returns the value of attribute environment_variables.
  #
  # source://health-monitor-rails//lib/health_monitor/configuration.rb#7
  def environment_variables; end

  # Sets the attribute environment_variables
  #
  # @param value the value to set the attribute environment_variables to.
  #
  # source://health-monitor-rails//lib/health_monitor/configuration.rb#7
  def environment_variables=(_arg0); end

  # Returns the value of attribute error_callback.
  #
  # source://health-monitor-rails//lib/health_monitor/configuration.rb#7
  def error_callback; end

  # Sets the attribute error_callback
  #
  # @param value the value to set the attribute error_callback to.
  #
  # source://health-monitor-rails//lib/health_monitor/configuration.rb#7
  def error_callback=(_arg0); end

  # Returns the value of attribute hide_footer.
  #
  # source://health-monitor-rails//lib/health_monitor/configuration.rb#7
  def hide_footer; end

  # Sets the attribute hide_footer
  #
  # @param value the value to set the attribute hide_footer to.
  #
  # source://health-monitor-rails//lib/health_monitor/configuration.rb#7
  def hide_footer=(_arg0); end

  # source://health-monitor-rails//lib/health_monitor/configuration.rb#18
  def no_database; end

  # Returns the value of attribute path.
  #
  # source://health-monitor-rails//lib/health_monitor/configuration.rb#7
  def path; end

  # Sets the attribute path
  #
  # @param value the value to set the attribute path to.
  #
  # source://health-monitor-rails//lib/health_monitor/configuration.rb#7
  def path=(_arg0); end

  # Returns the value of attribute providers.
  #
  # source://health-monitor-rails//lib/health_monitor/configuration.rb#12
  def providers; end

  # source://health-monitor-rails//lib/health_monitor/configuration.rb#23
  def redis(&_block); end

  # source://health-monitor-rails//lib/health_monitor/configuration.rb#23
  def resque(&_block); end

  # source://health-monitor-rails//lib/health_monitor/configuration.rb#23
  def sidekiq(&_block); end

  private

  # source://health-monitor-rails//lib/health_monitor/configuration.rb#43
  def add_provider(provider); end
end

# source://health-monitor-rails//lib/health_monitor/configuration.rb#5
HealthMonitor::Configuration::PROVIDERS = T.let(T.unsafe(nil), Array)

# source://health-monitor-rails//lib/health_monitor/engine.rb#4
class HealthMonitor::Engine < ::Rails::Engine
  class << self
    # source://activesupport/7.0.7/lib/active_support/callbacks.rb#68
    def __callbacks; end
  end
end

# source://health-monitor-rails//lib/health_monitor/providers/base.rb#6
module HealthMonitor::Providers; end

# source://health-monitor-rails//lib/health_monitor/providers/base.rb#7
class HealthMonitor::Providers::Base
  extend ::Forwardable

  # @return [Base] a new instance of Base
  #
  # source://health-monitor-rails//lib/health_monitor/providers/base.rb#24
  def initialize; end

  # @abstract
  # @raise [NotImplementedError]
  #
  # source://health-monitor-rails//lib/health_monitor/providers/base.rb#33
  def check!; end

  # Returns the value of attribute configuration.
  #
  # source://health-monitor-rails//lib/health_monitor/providers/base.rb#20
  def configuration; end

  # @yield [@configuration]
  #
  # source://health-monitor-rails//lib/health_monitor/providers/base.rb#28
  def configure; end

  # source://forwardable/1.3.3/forwardable.rb#231
  def critical(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def name(*args, **_arg1, &block); end

  # Returns the value of attribute request.
  #
  # source://health-monitor-rails//lib/health_monitor/providers/base.rb#19
  def request; end

  # Sets the attribute request
  #
  # @param value the value to set the attribute request to.
  #
  # source://health-monitor-rails//lib/health_monitor/providers/base.rb#19
  def request=(_arg0); end

  private

  # source://health-monitor-rails//lib/health_monitor/providers/base.rb#39
  def configuration_class; end
end

# source://health-monitor-rails//lib/health_monitor/providers/base.rb#10
class HealthMonitor::Providers::Base::Configuration
  # @return [Configuration] a new instance of Configuration
  #
  # source://health-monitor-rails//lib/health_monitor/providers/base.rb#13
  def initialize(provider); end

  # Returns the value of attribute critical.
  #
  # source://health-monitor-rails//lib/health_monitor/providers/base.rb#11
  def critical; end

  # Sets the attribute critical
  #
  # @param value the value to set the attribute critical to.
  #
  # source://health-monitor-rails//lib/health_monitor/providers/base.rb#11
  def critical=(_arg0); end

  # Returns the value of attribute name.
  #
  # source://health-monitor-rails//lib/health_monitor/providers/base.rb#11
  def name; end

  # Sets the attribute name
  #
  # @param value the value to set the attribute name to.
  #
  # source://health-monitor-rails//lib/health_monitor/providers/base.rb#11
  def name=(_arg0); end
end

# source://health-monitor-rails//lib/health_monitor/providers/database.rb#9
class HealthMonitor::Providers::Database < ::HealthMonitor::Providers::Base
  # source://health-monitor-rails//lib/health_monitor/providers/database.rb#10
  def check!; end
end

# source://health-monitor-rails//lib/health_monitor/providers/database.rb#7
class HealthMonitor::Providers::DatabaseException < ::StandardError; end

# source://health-monitor-rails//lib/health_monitor/monitor.rb#6
HealthMonitor::STATUSES = T.let(T.unsafe(nil), Hash)

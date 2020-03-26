require 'yaml'

module OnRamp

  extend self

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield(configuration)
  end

  def ab_experiments
    configuration.ab_experiments
  end

  class Configuration
    attr_reader :ab_experiments, :ab_variant_callback_function

    def ab_experiments=(path)
      @ab_experiments = YAML.safe_load(File.open(path).read)
    end
  end

end
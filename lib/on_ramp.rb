# frozen_string_literal: true

require 'on_ramp/bucket'
require 'on_ramp/configuration'
require 'on_ramp/ramp'

module OnRamp
  module_function

  def ramped?(experiment_name:, unique_id:)
    validate_experiment_name(experiment_name)
    OnRamp::Ramp.ramped?(experiment_name.to_s, unique_id)
  end

  def ab_variant(experiment_name:, unique_id:)
    validate_experiment_name(experiment_name)
    variant = if !ramped?(
      experiment_name: experiment_name,
      unique_id: unique_id
    )
                nil
              else
                OnRamp::Bucket.get_variant(
                  experiment_name: experiment_name.to_s,
                  unique_id: unique_id
                )
              end

    OnRamp.configuration.ab_variant_callback_function&.call(
      experiment_name,
      variant,
      unique_id
    )

    variant
  end

  class InvalidExperimentName < StandardError; end

  def validate_experiment_name(experiment_name)
    return if OnRamp.ab_experiments[experiment_name.to_s]

    raise InvalidExperimentName,
          "The key does not exist: #{experiment_name}"
  end
end

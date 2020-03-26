require 'yaml'

module OnRamp
  module Ramp

    extend self

    def ramped?(experiment_name, unique_id)
      ramp_threshold = OnRamp.ab_experiments[experiment_name.to_s]\
        ['ramp'] / 100.0
      weight = OnRamp::Bucket.get_weight(
        unique_id: unique_id,
        experiment_name: experiment_name,
        version: 'ramp'
      )

      ramp_threshold > weight
    end
  end
end

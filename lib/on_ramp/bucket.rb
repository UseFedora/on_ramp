require 'digest'
require 'yaml'

module OnRamp
  module Bucket

    extend self

    def get_variant(experiment_name:, unique_id:)
      weight = get_weight(
        unique_id: unique_id, experiment_name: experiment_name
      )

      running_total = 0.0
      cfg = OnRamp.ab_experiments[experiment_name]['variants']

      normalize_variants(cfg).each_pair do |variant_name, percentage|
        running_total += percentage
        return variant_name if weight <= running_total
      end
    end

    def get_weight(unique_id:, experiment_name:, version: nil)
      md5 = ::Digest::MD5.hexdigest("#{unique_id}-#{experiment_name}-#{version}")
      md5[0...8].to_i(16).to_f / 0xFFFFFFFF
    end

    def normalize_variants(variants_cfg)
      variants_cfg.map { |k, v| [k, v / 100.0] }.to_h
    end

  end
end

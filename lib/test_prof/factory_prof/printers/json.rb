# frozen_string_literal: true

require "test_prof/ext/float_duration"

module TestProf::FactoryProf
  module Printers
    module Json  # :nodoc: all
      class << self
        using TestProf::FloatDuration
        include TestProf::Logging

        def dump(result, start_time:)
          return log(:info, "No factories detected") if result.raw_stats == {}

          outpath = TestProf.artifact_path("test-prof.result.json")

          total_run_time = TestProf.now - start_time
          total_count = result.stats.sum { |stat| stat[:total_count] }
          total_top_level_count = result.stats.sum { |stat| stat[:top_level_count] }
          total_time = result.stats.sum { |stat| stat[:top_level_time] }
          total_uniq_factories = result.stats.map { |stat| stat[:name] }.uniq.count

          stats = {
            total_count: total_count,
            total_top_level_count: total_top_level_count,
            total_time: total_time.duration,
            total_run_time: total_run_time.duration,
            total_uniq_factories: total_uniq_factories,

            stats: result.stats
          }

          File.write(outpath, stats.to_json)

          log :info, "Profile json generated: #{outpath}"
        end
      end
    end
  end
end

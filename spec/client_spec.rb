RSpec.describe OnRamp do

  context '#in_experiment?' do
    it 'should split traffic according to ramp up specifications' do
      running_tallies = { true: 0, false: 0 }
      10_000.times do |user_id|
        key = OnRamp.ramped?(
          experiment_name: :experiment2,
          unique_id: user_id
        )

        running_tallies[key.to_s.to_sym] += 1
      end

      expect(running_tallies[:true]).to be_between(6900, 7100)
      expect(running_tallies[:false]).to be_between(2900, 3100)
    end

    it 'should raise if on_ramp is not ramped' do
      expect do
        OnRamp.ramped?(
          experiment_name: :fake_experiment,
          unique_id: 1
        )
      end.to raise_error(OnRamp::InvalidExperimentName)
    end
  end

  context '#get_variant' do
    it 'should consistently hash users' do
      100.times do |user_id|
        curr = OnRamp.ab_variant(
          experiment_name: 'experiment1',
          unique_id: user_id
        )

        failed_segments = []

        100.times do
          last = curr
          curr = OnRamp.ab_variant(
            experiment_name: 'experiment1',
            unique_id: user_id
          )
          failed_segments << curr if last != curr
        end

        expect(failed_segments.any?).to eq(false)
      end
    end

    it 'should consistently segment users within variant groups' do
      totals = {
        'control' => 0,
        'variant1' => 0,
        'variant2' => 0,
      }

      100_000.times do |user_id|
        key = OnRamp.ab_variant(
          experiment_name: 'experiment3',
          unique_id: user_id
        )
        totals[key] += 1
      end

      expect(totals['control']).to be_between(24_700, 25_300)
      expect(totals['variant1']).to be_between(24_700, 25_300)
      expect(totals['variant2']).to be_between(49_700, 50_300)
      expect(totals.values.sum).to eq(100_000)
    end

    it 'returns nil for unramped users' do
      totals = {
        'control' => 0,
        'variant1' => 0,
        nil => 0
      }

      100_000.times do |user_id|
        key = OnRamp.ab_variant(
          experiment_name: :experiment5,
          unique_id: user_id
        )
        totals[key] += 1
      end

      expect(totals[nil]).to be_between(49_700, 50_300)
      expect(totals['variant1']).to be_between(24_700, 25_300)
      expect(totals['control']).to be_between(24_700, 25_300)
    end
  end

end

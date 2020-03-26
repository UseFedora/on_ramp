# OnRamp

This gem provides two related but distinct pieces of functionality:

1. Percentage ramp ups of experiments that are intended to test load or the like
2. Segmenting users into a/b variants for experimentation purposes

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'on_ramp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install on_ramp

## Usage

Configure the gem in an initializer using the configure method

```
# /initializers/experiment.rb
OnRamp.configure do |config|
    config.ab_experiments = "/initializers/experiments.yaml"
end
```

Your yaml file will look similar to the below:
```
experiment_name:
 ramp: 20
 variants:
   control: 50
   variant_a: 50
```

See below for example code.

Simple use case ramping only
---
If you want to slowly ramp out a change to a subset of users, the following code is the simplest way to do so. This is not the recommended way to run an experiment. For running an experiment see below `OnRamp.ab_variant`
```
# school.rb

def cool_name
  if OnRamp.ramped?(:experiment_name, owner.id)
    "COOOL" + name
  else
    name
  end
end
```
As you can see here, the `#ramped?` method will return true if the user is in the ramped up group and false if they aren't. As you adjust the ramping, more users will experience the ramped up code path.

Simple use case experiment
--
The `ab_variant` method does not necessarily return a value. It will return `nil` if the unique_id you've passed is not yet ramped up. If you have configured your experiment with 100% ramp, then `#ab_variant` will always return a value.
```
def cool_name_experiment
 case OnRamp.ab_variant(:cool_name, owner.id)
 when "variant_a"
   "COOOL" + name
 when "variant_b"
   "C000L" + name
 when "control"
   control_group_name
 else
   name
 end
end
```
It may be common to have control and non-ramped experiences be the same, it's very easy with the case `else` clause.
```
def cool_name_final
 case Experiment::ab_variant(:cool_name, owner.id)
 when "variant_a"
   "COOOL" + name
 when "variant_b"
   "C000L" + name
 else
   name
 end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec spec/` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

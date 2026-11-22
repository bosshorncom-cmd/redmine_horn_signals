require File.expand_path('lib/redmine_horn_signals/pattern', __dir__)
require File.expand_path('lib/redmine_horn_signals/macros', __dir__)
require File.expand_path('lib/redmine_horn_signals/hooks', __dir__)

Redmine::Plugin.register :redmine_horn_signals do
  name 'Horn Signals wiki macros'
  author 'Train Horns Lab'
  description 'Wiki macros that draw horn and whistle sound signals (railway GCOR, COLREGS) to scale and compute crossing horn timing and sound level at distance.'
  version '0.1.0'
  url 'https://hornguns.com/'
  author_url 'https://github.com/bosshorncom-cmd/redmine_horn_signals'
  requires_redmine version_or_higher: '5.0.0'
end

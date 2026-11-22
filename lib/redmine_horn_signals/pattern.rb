module RedmineHornSignals
  # Pure-Ruby helpers, independent of Redmine (unit tested in test/unit).
  module Pattern
    CATALOG = {
      'crossing'    => ['- - o -', 'Approaching a public grade crossing (GCOR 5.8.2, 49 CFR 222.21)'],
      'proceed'     => ['- -', 'Release brakes, proceed (GCOR 5.8.2)'],
      'acknowledge' => ['o o', 'Acknowledge a signal not otherwise provided for (GCOR 5.8.2)'],
      'back-up'     => ['o o o', 'When stopped: back up (GCOR 5.8.2)'],
      'request'     => ['o o o o', 'Request a signal to be given or repeated (GCOR 5.8.2)'],
      'starboard'   => ['o', 'Altering course to starboard (COLREGS 34(a))'],
      'port'        => ['o o', 'Altering course to port (COLREGS 34(a))'],
      'astern'      => ['o o o', 'Operating astern propulsion (COLREGS 34(a))'],
      'danger'      => ['o o o o o', 'Doubt or danger (COLREGS 34(d))'],
      'fog'         => ['-', 'Power-driven vessel making way in restricted visibility (COLREGS 35(a))']
    }.freeze

    LONG = %w[- L l].freeze
    SHORT = %w[o O S s].freeze

    module_function

    # Returns an array of :long / :short symbols or raises ArgumentError.
    def parse(text)
      text = CATALOG[text.to_s.strip][0] if CATALOG.key?(text.to_s.strip)
      toks = text.to_s.split
      raise ArgumentError, 'empty pattern' if toks.empty?
      raise ArgumentError, 'pattern too long (max 40 sounds)' if toks.size > 40
      toks.map do |t|
        if LONG.include?(t) then :long
        elsif SHORT.include?(t) then :short
        else raise ArgumentError, "unknown token #{t.inspect} (use - or o)"
        end
      end
    end

    def meaning(text)
      entry = CATALOG[text.to_s.strip]
      entry && entry[1]
    end

    # [[on?, ms], ...] alternating sound and silence, no trailing silence.
    def intervals(sounds, short_ms: 1000, long_ms: 3000, gap_ms: 1000)
      out = []
      sounds.each_with_index do |s, i|
        out << [true, s == :long ? long_ms : short_ms]
        out << [false, gap_ms] if i < sounds.size - 1
      end
      out
    end

    # 49 CFR 222.21(b): returns [earliest_ft, latest_ft, capped]
    def onset_window(mph)
      mph = Float(mph)
      raise ArgumentError, 'speed must be positive' unless mph.positive?
      v = mph * 5280.0 / 3600.0
      return [1320.0, 1320.0, true] if mph > 60
      [20 * v, 15 * v, false]
    end

    # Free-field inverse-square estimate from a level at ref_ft.
    def level_at(ref_dba, distance_ft, ref_ft = 100.0)
      d = Float(distance_ft)
      raise ArgumentError, 'distance must be positive' unless d.positive?
      Float(ref_dba) - 20 * Math.log10(d / ref_ft)
    end
  end
end

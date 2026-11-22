module RedmineHornSignals
  module Macros
    Redmine::WikiFormatting::Macros.register do
      desc <<~TXT
        Draws a horn or whistle signal to scale.
        {{horn_signal(- - o -)}}            pattern with - for long and o for short sounds
        {{horn_signal(crossing)}}           catalog name: crossing, proceed, acknowledge, back-up, request, starboard, port, astern, danger, fog
        {{horn_signal(o o o o o, long=5000)}} optional short=, long=, gap= in milliseconds
      TXT
      macro :horn_signal do |_obj, args|
        opts = {}
        words = []
        args.each do |a|
          if a =~ /\A\s*(short|long|gap)\s*=\s*(\d{2,5})\s*\z/
            opts[:"#{$1}_ms"] = $2.to_i
          else
            words << a
          end
        end
        spec = words.join(',').strip
        begin
          sounds = RedmineHornSignals::Pattern.parse(spec)
        rescue ArgumentError => e
          next content_tag(:span, "horn_signal: #{e.message}", class: 'flash error')
        end
        steps = RedmineHornSignals::Pattern.intervals(sounds, **opts)
        total = steps.sum { |s| s[1] }.to_f
        bars = steps.map do |on, ms|
          content_tag(:span, '', class: on ? 'horn-signal-on' : 'horn-signal-off',
                                 style: "width:#{(100 * ms / total).round(3)}%")
        end
        label = sounds.map { |s| s == :long ? '-' : 'o' }.join(' ')
        caption = [label, "#{(total / 1000).round(1)} s", RedmineHornSignals::Pattern.meaning(spec)].compact.join(' · ')
        content_tag(:span, class: 'horn-signal', title: caption) do
          safe_join([content_tag(:span, safe_join(bars), class: 'horn-signal-bars'),
                     content_tag(:span, caption, class: 'horn-signal-caption')])
        end
      end

      desc "Horn onset window before a public grade crossing (49 CFR 222.21).\n{{horn_onset(45)}} for 45 mph"
      macro :horn_onset do |_obj, args|
        begin
          e, l, capped = RedmineHornSignals::Pattern.onset_window(args.first)
        rescue ArgumentError, TypeError => ex
          next content_tag(:span, "horn_onset: #{ex.message}", class: 'flash error')
        end
        text = if capped
                 "start at about #{l.round} ft (quarter-mile cap above 60 mph)"
               else
                 "start between #{e.round} ft and #{l.round} ft before the crossing"
               end
        content_tag(:span, "#{args.first.to_s.strip} mph: #{text}", class: 'horn-onset')
      end

      desc "Free-field sound level estimate.\n{{horn_level(110, 1000)}} = level at 1000 ft from 110 dB(A) at 100 ft"
      macro :horn_level do |_obj, args|
        begin
          ref, dist = args[0], args[1]
          l = RedmineHornSignals::Pattern.level_at(ref, dist)
        rescue ArgumentError, TypeError => ex
          next content_tag(:span, "horn_level: #{ex.message}", class: 'flash error')
        end
        content_tag(:span, format('%.1f dB(A) at %s ft (from %s dB(A) at 100 ft, free-field estimate)', l, dist.to_s.strip, ref.to_s.strip),
                    class: 'horn-level')
      end
    end
  end
end

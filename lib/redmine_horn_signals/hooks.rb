module RedmineHornSignals
  class Hooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(_context = {})
      stylesheet_link_tag('horn_signals', plugin: 'redmine_horn_signals')
    end
  end
end

require 'liquid'

module Locomotive
  module Services
    class LiquidRenderer
      def self.call(rendereable, context, options = {})
        parse(rendereable, {error_mode: :strict, count_lines: true}.merge!(options)).render(context)
      end

      protected
      def self.parse(rendereable, context)
        begin
          ::Liquid::Template.parse(rendereable.source, context)
        rescue ::Liquid::SyntaxError
          # FIXME: avoid intermediate call to template()
          ::Liquid::Template.parse(rendereable.template.raw_source, context)
        end
      end
    end
  end
end
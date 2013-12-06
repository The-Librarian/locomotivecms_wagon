require_relative '../../../lib/locomotive/services/liquid_renderer'

describe Locomotive::Services::LiquidRenderer do
  let(:rendereable)      { double("rendereable", source: "rendereable source", template: double(raw_source: "raw source")) }
  let(:template)         { double("Template") }
  let(:expected_options) { {error_mode: :strict, count_lines: true, extra_param: true} }
  let(:context)          { double("Liquid context") }

  subject { Locomotive::Services::LiquidRenderer.call(rendereable, context, extra_param: true)  }

  before do
    template.stub(:render).with(context) { "Expected result" }
  end

  it "Renders liquid entities" do
    ::Liquid::Template.stub(:parse).with("rendereable source", expected_options) { template }
    subject.should == "Expected result"
  end

  it "falls back to the raw source on parse errors" do
    ::Liquid::Template.stub(:parse).with("rendereable source", expected_options).and_raise(Liquid::SyntaxError)
    ::Liquid::Template.stub(:parse).with("raw source", expected_options) { template }
    subject.should == "Expected result"
  end
end
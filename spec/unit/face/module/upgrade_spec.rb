require 'spec_helper'
require 'puppet/face'
require 'puppet/module_tool'

describe "puppet module upgrade" do
  subject { Puppet::Face[:module, :current] }

  let(:options) do
    {}
  end

  describe "inline documentation" do
    subject { Puppet::Face[:module, :current].get_action :upgrade }

    it(:summary)     { should =~ /upgrade.*module/im }
    it(:description) { should =~ /upgrade.*module/im }
    it(:returns)     { should =~ /hash/i }
    it(:examples)    { should_not be_empty }

    %w{ license copyright summary description returns examples }.each do |doc|
      context "of the" do
        it(doc.to_sym) { should_not =~ /(FIXME|REVISIT|TODO)/ }
      end
    end
  end
end

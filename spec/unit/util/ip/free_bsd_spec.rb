# encoding: UTF-8

require 'spec_helper'
require 'facter/util/ip/free_bsd'

describe Facter::Util::IP::FreeBSD do
  describe ".to_s" do
    let :to_s do
      described_class.to_s
    end

    it "should be 'FreeBSD'" do
      to_s.should eq 'FreeBSD'
    end
  end

  describe ".convert_netmask_from_hex?" do
    let :convert_netmask_from_hex? do
      described_class.convert_netmask_from_hex?
    end

    it "should be true" do
      convert_netmask_from_hex?.should be true
    end
  end

  describe ".bonding_master" do
    let :bonding_master do
      described_class.bonding_master('eth0')
    end

    it { bonding_master.should be_nil }
  end

  describe ".value_for_interface_and_label(interface, label)" do
    let :value_for_interface_and_label do
      described_class.value_for_interface_and_label interface, label
    end

    let(:interface) { 'fxp0' }
    let(:ifconfig_output) { my_fixture_read "6.0-STABLE_ifconfig_with_single_interface" }
    let(:ifconfig_path) { "/usr/bin/ifconfig" }
    let(:exec_cmd) { "#{ifconfig_path} #{interface} 2> /dev/null" }

    before :each do
      described_class.expects(:ifconfig_path).returns(ifconfig_path)
      described_class.expects(:exec).with(exec_cmd).returns(ifconfig_output)
    end

    describe "macaddress" do
      let(:label) { 'macaddress' }

      it { value_for_interface_and_label.should eq '00:0e:0c:68:67:7c' }
    end
  end
end

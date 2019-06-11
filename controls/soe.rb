# encoding: utf-8
# copyright: 2018, The Authors
win_update = windows_update

title 'SOE Profile (Windows)'

control 'soe-app-01' do
  impact 1.0
  title 'Adobe Reader Installed'
  desc 'Check for Adobe Reader 19.012.20034'
  describe package('Adobe Acrobat Reader DC') do
    it { should be_installed }
    its ( 'version' ) { should cmp '19.012.20034' }
  end
end

control 'soe-app-02' do
  impact 1.0
  title 'Cisco VPN Client Installed'
  desc 'Check for Cisco VPN Client 4.3.02039'
  describe package('Cisco AnyConnect Secure Mobility Client') do
    it { should be_installed }
    its ( 'version' ) { should cmp '4.3.02039' }
  end
end

control 'soe-app-03' do
  impact 1.0
  title 'Visual Studio Code Installed'
  desc 'Check for Visual Studio Code 1.35.0'
  describe package('Microsoft Visual Studio Code') do
    it { should be_installed }
    its ( 'version' ) { should cmp '1.35.0' }
  end
end

control 'soe-reg-01' do
  impact 1.0
  title 'Check SOE Build Version'
  desc 'Checks for a valid SOE build version'
  describe registry_key 'HKEY_LOCAL_MACHINE\SOFTWARE\SOE_Build' do
    it {should exist}
    its('soe') { should cmp '1.0.4' }
  end
end

control 'verify-kb' do
  impact 0.3
  title 'All updates should be installed'
  describe win_update.all.length do
    it { should eq 0 }
  end
end

control 'important-count' do
  impact 1.0
  title 'No important updates should be available'
  describe win_update.important.length do
    it { should eq 0 }
  end
end

control 'important-patches' do
  impact 1.0
  title 'All important updates are installed'
  win_update.important.each { |update|
    describe update do
      it { should be_installed }
    end
  }
end

control "disable cortana" do
  title "(L1) Ensure 'Allow Cortana' is set to 'Disabled'"
  desc  "
    This policy setting specifies whether Cortana is allowed on the device.
    The recommended state for this setting is: Disabled.
    Rationale: If Cortana is enabled, sensitive information could be contained in search history and sent out to Microsoft.
  "
  impact 1.0
  describe registry_key("HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Search") do
    it { should have_property "AllowCortana" }
  end
  describe registry_key("HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Search") do
    its("AllowCortana") { should cmp == 0 }
  end
end

control 'Ensure_Disallow_Autoplay_for_non-volume_devices_is_set_to_Enabled' do
  title "(L1) Ensure 'Disallow Autoplay for non-volume devices' is set to 'Enabled'"
  desc  "
    This policy setting disallows AutoPlay for MTP devices like cameras or phones.
    The recommended state for this setting is: Enabled.
    Rationale: An attacker could use this feature to launch a program to damage a client computer or data on the computer.
  "
  impact 1.0
  describe registry_key("HKEY_LOCAL_MACHINE\\Software\\Policies\\Microsoft\\Windows\\Explorer") do
    it { should have_property "NoAutoplayfornonVolume" }
  end
  describe registry_key("HKEY_LOCAL_MACHINE\\Software\\Policies\\Microsoft\\Windows\\Explorer") do
    its("NoAutoplayfornonVolume") { should cmp == 1 }
  end
end

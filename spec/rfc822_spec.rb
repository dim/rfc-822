require File.dirname(__FILE__) + '/helper'

describe RFC822 do

  after do
    RFC822.host_command = '/usr/bin/env host'
  end

  describe 'email pattern' do

    it 'should match RFC822 compliant addresses' do
      expect("user@x").to match(RFC822::EMAIL)
      expect("user@home").to match(RFC822::EMAIL)
      expect("user@home.com").to match(RFC822::EMAIL)
      expect("user@dashed-home.info").to match(RFC822::EMAIL)
      expect("user@separated.home.info").to match(RFC822::EMAIL)
      expect("dashed-user@home.com").to match(RFC822::EMAIL)
      expect("underscored_user@home.com").to match(RFC822::EMAIL)
      expect("separated.user@home.com").to match(RFC822::EMAIL)
      expect("slashed/user@home.com").to match(RFC822::EMAIL)
      expect("plussed+user@home.com").to match(RFC822::EMAIL)
      expect("{wrapped}user@home.com").to match(RFC822::EMAIL)
      expect("end-dashed-@home.com").to match(RFC822::EMAIL)
    end

    it 'should not match non-RFC822 compliant addresses' do
      expect("user-home").not_to match(RFC822::EMAIL)
      expect("@home.com").not_to match(RFC822::EMAIL)
      expect("user@").not_to match(RFC822::EMAIL)
      expect("user@trailing.period.").not_to match(RFC822::EMAIL)
      expect("user@underscored_home.org").not_to match(RFC822::EMAIL)
      expect("user@just,wrong.org").not_to match(RFC822::EMAIL)
      expect("user@just/wrong.org").not_to match(RFC822::EMAIL)
      expect("user@just wrong.org").not_to match(RFC822::EMAIL)
      expect("wrong,user@home.com").not_to match(RFC822::EMAIL)
      expect("wrong-user.@home.com").not_to match(RFC822::EMAIL)
      expect("wrong@user@home.com").not_to match(RFC822::EMAIL)
      expect("wrong user@home.com").not_to match(RFC822::EMAIL)
      expect("wrong(user)@home.com").not_to match(RFC822::EMAIL)
    end

  end

  it 'should allow to change the host command' do
    expect(RFC822.host_command).to eq('/usr/bin/env host')
    RFC822.host_command = '/opt/bin host'
    expect(RFC822.host_command).to eq('/opt/bin host')
  end

  describe 'MX record check' do

    before do
      allow(RFC822).to receive(:host_mx).and_return(%Q(
hotmail.com mail is handled by 5 mx3.hotmail.com.
hotmail.com mail is handled by 5 mx4.hotmail.com.
hotmail.com mail is handled by 5 mx1.hotmail.com.
hotmail.com mail is handled by 5 mx2.hotmail.com.
))
    end

    it 'should return raw MX records fo a domain' do
      expect(RFC822.raw_mx_records('hotmail.com')).to eq([
        ["5", "mx3.hotmail.com"],
        ["5", "mx4.hotmail.com"],
        ["5", "mx1.hotmail.com"],
        ["5", "mx2.hotmail.com"],
      ])
    end

    it 'should return prioritised MX records of an address' do
      expect(RFC822.mx_records('user@hotmail.com').size).to eq(4)
      record = RFC822.mx_records('user@hotmail.com').first
      expect(record.priority).to eq(5)
      expect(record.host).to eq("mx3.hotmail.com")
    end

    it 'should return an empty result if address is invalid' do
      expect(RFC822.mx_records('user@hotmail@com')).to eq([])
    end

  end
end

require File.dirname(__FILE__) + '/helper'

describe RFC822 do

  after do
    RFC822.host_command = '/usr/bin/env host'    
  end
  
  describe 'email pattern' do
    
    it 'should match RFC822 compliant addresses' do
      "user@home".should match(RFC822::EMAIL)
      "user@home.com".should match(RFC822::EMAIL)
      "user@dashed-home.info".should match(RFC822::EMAIL)
      "user@separated.home.info".should match(RFC822::EMAIL)
      "dashed-user@home.com".should match(RFC822::EMAIL)            
      "underscored_user@home.com".should match(RFC822::EMAIL)            
      "separated.user@home.com".should match(RFC822::EMAIL)            
      "slashed/user@home.com".should match(RFC822::EMAIL)            
      "plussed+user@home.com".should match(RFC822::EMAIL)            
      "{wrapped}user@home.com".should match(RFC822::EMAIL)            
      "end-dashed-@home.com".should match(RFC822::EMAIL)            
    end

    it 'should not match non-RFC822 compliant addresses' do
      "user-home".should_not match(RFC822::EMAIL)
      "@home.com".should_not match(RFC822::EMAIL)
      "user@".should_not match(RFC822::EMAIL)
      "user@underscored_home.org".should_not match(RFC822::EMAIL)
      "user@just,wrong.org".should_not match(RFC822::EMAIL)
      "user@just/wrong.org".should_not match(RFC822::EMAIL)
      "user@just wrong.org".should_not match(RFC822::EMAIL)
      "wrong,user@home.com".should_not match(RFC822::EMAIL)            
      "wrong-user.@home.com".should_not match(RFC822::EMAIL)            
      "wrong@user@home.com".should_not match(RFC822::EMAIL)            
      "wrong user@home.com".should_not match(RFC822::EMAIL)            
      "wrong(user)@home.com".should_not match(RFC822::EMAIL)            
    end    
    
  end
  
  it 'should allow to change the host command' do
    RFC822.host_command.should == '/usr/bin/env host'
    RFC822.host_command = '/opt/bin host'
    RFC822.host_command.should == '/opt/bin host'     
  end
  
  describe 'MX record check' do

    before do
      RFC822.stub!(:host_mx).and_return(%Q(
hotmail.com mail is handled by 5 mx3.hotmail.com.
hotmail.com mail is handled by 5 mx4.hotmail.com.
hotmail.com mail is handled by 5 mx1.hotmail.com.
hotmail.com mail is handled by 5 mx2.hotmail.com.
))
    end

    it 'should return raw MX records fo a domain' do
      RFC822.raw_mx_records('hotmail.com').should == [
        ["5", "mx3.hotmail.com"], 
        ["5", "mx4.hotmail.com"], 
        ["5", "mx1.hotmail.com"], 
        ["5", "mx2.hotmail.com"]
      ]
    end

    it 'should return prioritised MX records of an address' do
      RFC822.mx_records('user@hotmail.com').should have(4).items
      record = RFC822.mx_records('user@hotmail.com').first
      record.priority.should == 5
      record.host.should == "mx3.hotmail.com"
    end

    it 'should return an empty result if address is invalid' do
      RFC822.mx_records('user@hotmail@com').should == []
    end
   
  end
end

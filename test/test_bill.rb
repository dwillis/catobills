require 'rubygems'
require 'catobills'
require 'oj'
require 'ox'
require 'net/http'
require 'minitest/autorun'
require 'webmock/minitest'

class TestBill < MiniTest::Test
  
  def setup
    stub_request(:get, "http://deepbills.cato.org/api/1/bill?billnumber=1328&billtype=s&billversion=is&congress=113").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => File.open('test/s1328_113_is.json'), :headers => {})
    @response = Net::HTTP.get('deepbills.cato.org', '/api/1/bill?congress=113&billnumber=1328&billtype=s&billversion=is')
    bill = Oj.load(@response)
    bill_body = Ox.load(bill['billbody'])
    @bill = Catobills::Bill.new(:bill_number => bill['billnumber'],
      :bill_body => bill_body,
      :version => bill['billversion'],
      :congress => bill['congress'],
      :bill_type => bill['billtype'],
      :federal_bodies => Catobills::Bill.populate_federal_bodies(bill_body),
      :acts => Catobills::Bill.populate_acts(bill_body))
  end
  
  def test_that_the_correct_bill_was_loaded
    assert_equal "1328", @bill.bill_number
  end
  
  def test_that_federal_bodies_were_created
    assert_equal ["Secretary of the Interior", "National Park System", "National Park Service"], @bill.federal_bodies
  end
  
  def test_that_acts_were_created
    assert_equal ["paragraph (3)", "subsection (a)"], @bill.acts
  end
  
  
end
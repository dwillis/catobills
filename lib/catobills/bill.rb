module Catobills
  class Bill
    
    attr_reader :bill_number, :bill_body, :version, :congress, :bill_type, :federal_bodies, :acts

    def initialize(params={})
      params.each_pair do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end
    
    def self.find_by_slug(congress, bill_slug)
      m = /([a-z]*)([0-9]*)/.match(bill_slug)
      version = m[1][0] == 'h' ? 'ih' : 'is'
      find(congress, m[2], m[1], version)
    end
    
    def self.find(congress, bill_number, bill_type, version)
      url = "http://deepbills.cato.org/api/1/bill?congress=#{congress}&billnumber=#{bill_number}&billtype=#{bill_type}&billversion=#{version}"
      response = HTTParty.get(url)
      bill = Oj.load(response.body)
      bill_body = Ox.load(bill['billbody'])
      self.new(:bill_number => bill['billnumber'],
      :bill_body => bill_body,
      :version => bill['billversion'],
      :congress => bill['congress'],
      :bill_type => bill['billtype'],
      :federal_bodies => self.populate_federal_bodies(bill_body),
      :acts => self.populate_acts(bill_body))
    end
    
    def self.populate_acts(bill_body)
      results = bill_body.locate('legis-body/*/cato:entity-ref').select{|ref| ref['entity-type'] == 'act'}
      array_count(results.map{|ref| ref.text.gsub(/\s+/, " ").strip}.compact.reject{|ref| ref[0] != ref[0].upcase}).reject{|ref| ref[0] == '('}.reject{|ref| ['Section', 'section', 'chapter', 'subsection'].any? {|s| ref.include?(s)}}
    end
    
    # collects mentions of federal bodies, removing 'Congress', leadership offices, 'Commission', 'Board' and offices within agencies.
    def self.populate_federal_bodies(bill_body)
      results = bill_body.locate('legis-body/*/cato:entity-ref').select{|ref| ref['entity-type'] == 'federal-body'}
      array_count(results.flatten.reject{|ref| ref['entity-id'] == "0001"}.reject{|ref| ref['entity-parent-id'] == '0050'}.reject{|ref| ref['entity-parent-id'] == '0010'}.map{|ref| ref.text.gsub(/\s+/, " ").strip}.compact.reject{|x| ['Commission', 'Board', 'Secretary', 'Department', 'Administrator', 'Administration', 'House', 'Senate', 'Director', 'Advisory Committee', 'Task Force'].include?(x)})
    end
    
    def self.array_count(array)
      h = Hash.new(0)
      array.each do |v|
        h[v] += 1
      end
      h
    end
  end
end

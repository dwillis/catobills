module Catobills
  class FederalBody

    attr_reader :id, :name, :abbrev

    def initialize(params={})
      params.each_pair do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end

    def self.load
      url = "http://dwillis.github.io/catobills/federal-bodies.json"
      response = HTTParty.get(url)
      bodies = Oj.load(response.body)
      bodies.map{|b| self.new( id: b['id'], name: b['name'], abbrev: b['abbrev'])}
    end

  end
end

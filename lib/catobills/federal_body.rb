module Catobills
  class FederalBody

    attr_reader :id, :name, :abbrev

    def initialize(params={})
      params.each_pair do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end

    def self.load
      f = File.open('federal-bodies.json', 'w')
      results = []
      bodies = Ox.load(open("federal-bodies.xml").read)
      bodies.locate('entity').each do |entity|
        abbrev = entity.nodes.detect{|n| n.value == 'abbr'} ? entity.nodes.detect{|n| n.value == 'abbr'}.text : nil
        results << {:id => entity.id, :name => entity.nodes[0].nodes[0], :abbrev => abbrev}
      end
      f.write(pp results.to_json)
    end

  end
end

module Catobills
  class FederalBody

    attr_reader :id, :name, :abbrev

    def initialize(params={})
      params.each_pair do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end

    def self.load
      bodies = Ox.load(open("federal-bodies.xml").read)
      bodies.locate('entity').each do |entity|
        abbrev = entity.nodes.detect{|n| n.value == 'abbr'} ? entity.nodes.detect{|n| n.value == 'abbr'}.text : nil
        self.new(
          id:     entity.id, 
          name:   entity.nodes[0].nodes[0], 
          abbrev: abbrev
        )
      end
    end

  end
end

# Catobills

Catobills is a Ruby library for working with congressional legislation served by the [Cato Institute's Deepbills Project](http://www.cato.org/resources/data), which adds [semantic information](http://namespaces.cato.org/catoxml/) to legislative XML. Catobills is an interface to the Deepbills API ([example response](http://deepbills.cato.org/api/1/bill?congress=113&billnumber=499&billtype=s&billversion=is)), which returns JSON that contains embedded XML.

The initial release of Catobills returns the contents of an API response but also two additional arrays. The first, `federal_bodies`, is a hash of federal agencies and organization (other than Congress itself and its leadership offices) that a bill mentions, and the number of times each is referenced. The second, `acts`, is a hash of references to enacted legislation contained in the bill - Catobills returns only full titles, not internal references - and the number of times each is referenced. These can be used to help determine the scope and impact of the legislation.

## Installation

Add this line to your application's Gemfile:

    gem 'catobills'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install catobills

## Usage

You'll need to supply several parameters to a `Catobills::Bill` object to retrieve results. There are two ways to do this:

#### Using Deepbills parameters

Cato's API requires a congress (currently only the 113th Congress is available), the bill number, the bill type and bill version, which defaults to the introduced (first) version of the legislation. This would retrieve details for S1328:

```ruby
bill = Catobills::Bill.find(113, 362, 's', 'is')
bill.federal_bodies
 => {"Department of Energy"=>2, "Secretary of the Interior"=>1, "Secretary of Energy"=>2, "Office of Energy Efficiency and Renewable Energy"=>2, "Assistant Secretary for Energy Efficiency and Renewable Energy"=>1}
bill.acts
 => {"Title VI of the Energy Independence and Security Act of 2007"=>1, "Mineral Leasing Act"=>1, "Mineral Leasing Act for Acquired Lands"=>1}
```

#### Using Congress and Bill Slug

For example, from a NYT Inside Congress [bill url](http://politics.nytimes.com/congress/bills/113/hr391):

```ruby
bill = Catobills::Bill.find_by_slug(113,'hr541')
bill.federal_bodies
=> {"Secretary of Health and Human Services"=>3, "Director of the Centers for Disease Control and Prevention"=>2, "Advisory Committee on Infant Mortality"=>1, "Department of Health and Human Services"=>4}
bill.acts
 => {"PREEMIE Reauthorization Act"=>1}
```

## Tests

To run the tests, it's `rake test`. Catobills uses MiniTest.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

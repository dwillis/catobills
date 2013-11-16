# Catobills

Catobills is a Ruby library for working with congressional legislation served by the [Cato Institute's Deepbills Project](http://www.cato.org/resources/data), which adds [semantic information](http://namespaces.cato.org/catoxml/) to legislative XML. Catobills is an interface to the Deepbills API ([example response](http://deepbills.cato.org/api/1/bill?congress=113&billnumber=499&billtype=s&billversion=is)), which returns JSON that contains embedded XML.

The initial release of Catobills returns the contents of an API response but also two additional arrays. The first, `federal_bodies`, is a list of federal agencies and organization (other than Congress itself and its leadership offices) that a bill mentions. The second, `acts`, is a list of references to enacted legislation contained in the bill. These can be used to help determine the scope and impact of the legislation.

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
bill = Catobills::Bill.find(113, 1134, 's', 'is')
bill.federal_bodies
 => ["Internal Revenue Service"]
bill.acts
 => ["subsection (a)", "of the Internal Revenue Code of 1986", "chapter 77 of such Code"]
```

#### Using Congress and Bill Slug

For example, from a NYT Inside Congress [bill url](http://politics.nytimes.com/congress/bills/113/hr391):

```ruby
bill = Catobills::Bill.find_by_slug(113,'hr2846')
bill.federal_bodies
=> ["Department of State", "Secretary of State"]
bill.acts
 => ["Jerusalem Embassy Relocation Act", "subsection (b) of this section", "section 7 of the Jerusalem Embassy Act of 1995", "subsection (a)"]
```

## Tests

To run the tests, it's `rake test`. Catobills uses MiniTest.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

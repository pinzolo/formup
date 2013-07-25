# Formup

[![Build Status](https://secure.travis-ci.org/pinzolo/formup.png)](http://travis-ci.org/pinzolo/formup)

Formup is rubygem for creating data model based form class.

## Installation

Add this line to your application's Gemfile:

    gem 'formup'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install formup

## Usage

### Include Formup to your class.

```ruby
class SalesForm
  include Formup

  # define attributes (sales_id, sales_price, sales_tax)
  source :sales, :attributes => [:id, :price, :tax]
  # define attributes (customer_id, customer_name, contact)
  source :customer, :attributes => [:id, :name], :aliases => { :email => :contact }

  attr_accessor :items

  # Handle hash parameters that were not processed in initialize method.
  def handle_extra_params(params)
    self.items = {}
    params.each do |k, v|
      self.items[v] = params[k.to_s.gsub(/^code/, "count")] if k.to_s.match(/^code/)
    end
  end
end
```

### Initialize with hash parameters.(like ActiveRecord)

```ruby
# params => { :sales_id => 1, :sales_price => 1000, ... }
form = SalesForm.new(params)
```

### Load from hash and data model that have some accessor methods.

```ruby
form = SalesForm.new
sales = Sales.find(1)
form.load(:sales => sales, :customer => { :id => 1, :name => "John Doe", :email => "john@example.com"})
```

### Get parameters for data model by `params_for` method.

```ruby
form = SalesForm.new(params)
sales = Sales.new(form.params_for(:sales))
sales.save
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

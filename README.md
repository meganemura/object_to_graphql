# ObjectToGraphql

```ruby
gem 'object_to_graphql'
```

## Usage

```ruby
object = {
  user: {
    name: "Alice",
    email_address: "alice@example.com",
    accounts: [
      { name: "alice1" },
    ],
  }
}
ObjectToGraphql.generate(object)
# => {
#      user {
#        name
#        emailAddress
#        accounts {
#          name
#        }
#      }
#    }
```

### It works with arguments

```ruby
object = {
  user: {
    name: "Alice",
    email_address: "alice@example.com",
    accounts: [
      { name: "alice1" },
    ],
  }
}

arguments = [
  [[:user], {name: "ID", value: "id-1"}]
]

ObjectToGraphql.generate(object, arguments)
# => {
#      user(ID: "id-1") {
#        name
#        emailAddress
#        accounts {
#          name
#        }
#      }
#    }
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/meganemura/object_to_graphql. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/object_to_graphql/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ObjectToGraphql project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/object_to_graphql/blob/main/CODE_OF_CONDUCT.md).

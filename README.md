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
  # [[:path, :to, :the_field, :to_be_injected_argument], {name: argument_name, value: argument_value}]
  [[:user], {name: "ID", value: "id-1"}]
  [[:user, :name], {name: "separator", value: ","}],
  [[:user, :accounts], {name: "order", value: "desc"}]
]

ObjectToGraphql.generate(object, arguments)
# => {
#      user(ID: "id-1") {
#        name(separator: ",")
#        emailAddress
#        accounts(order: "desc") {
#          name
#        }
#      }
#    }
```

### It works with variables

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
  [[:user], {name: "id", value: "$user_id"}],
]
variables = [
  {name: "$user_id", type: "ID!"}
]

ObjectToGraphql.generate(object, arguments, variables)
# => query($user_id: ID!) {
#      user(id: $user_id) {
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

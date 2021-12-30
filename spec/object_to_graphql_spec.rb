# frozen_string_literal: true

RSpec.describe ObjectToGraphql do
  it "generates a GraphQL query" do
    object = {
      user: {
        name: "Alice",
        email_address: "alice@example.com",
        accounts: [
          {name: "alice1"}
        ]
      }
    }

    query = ObjectToGraphql.generate(object)

    expect(query).to eq(<<~GRAPHQL.chomp)
      {
        user {
          name
          emailAddress
          accounts {
            name
          }
        }
      }
    GRAPHQL
  end

  it "generates a GraphQL query with arguments" do
    object = {
      user: {
        name: "Alice",
        email_address: "alice@example.com",
        accounts: [
          {name: "alice1"}
        ]
      }
    }

    arguments = [
      [[:user], {name: "ID", value: "id-1"}]
    ]

    query = ObjectToGraphql.generate(object, arguments)

    expect(query).to eq(<<~GRAPHQL.chomp)
      {
        user(ID: "id-1") {
          name
          emailAddress
          accounts {
            name
          }
        }
      }
    GRAPHQL
  end

  it "generates a GraphQL query with arguments for nested field" do
    object = {
      user: {
        name: "Alice",
        email_address: "alice@example.com",
        accounts: [
          {name: "alice1"}
        ]
      }
    }

    arguments = [
      [[:user], {name: "ID", value: "id-1"}],
      [[:user, :name], {name: "separator", value: ","}],
      [[:user, :accounts], {name: "order", value: "desc"}]
    ]

    query = ObjectToGraphql.generate(object, arguments)

    expect(query).to eq(<<~GRAPHQL.chomp)
      {
        user(ID: "id-1") {
          name(separator: ",")
          emailAddress
          accounts(order: "desc") {
            name
          }
        }
      }
    GRAPHQL
  end
end

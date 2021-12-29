# frozen_string_literal: true

RSpec.describe ObjectToGraphql do
  it "generates a GraphQL query" do
    object = {
      user: {
        name: "Alice",
        email_address: "alice@example.com",
        accounts: [
          { name: "alice1" },
        ],
      }
    }
    query = ObjectToGraphql.generate(object)

    expect(query).to eq(<<~GRAPHQL)
      {
        user: {
          name
          emailAddress
          accounts: {
            name
          }
        }
      }
    GRAPHQL
  end
end

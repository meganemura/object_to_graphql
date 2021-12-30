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
    parsed = ObjectToGraphql::ObjectParser.parse(object)
    # query = ObjectToGraphql::QueryBuilder.build(object)
    query = parsed.to_query_string.lstrip

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
end

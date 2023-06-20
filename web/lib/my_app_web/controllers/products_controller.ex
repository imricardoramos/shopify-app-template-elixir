defmodule MyAppWeb.ProductsController do
  use MyAppWeb, :controller

  def count(conn, _params) do
    current_shop = Shopifex.Plug.current_shop(conn)
    {:ok, response} = products(current_shop)
    json(conn, %{count: Enum.count(response.body["data"]["products"]["nodes"])})
  end

  def create(conn, _params) do
    current_shop = Shopifex.Plug.current_shop(conn)

    Enum.map(1..5, fn _ ->
      Task.async(fn -> create_random_product(current_shop) end)
    end)
    |> Task.await_many()

    send_resp(conn, 200, "")
  end

  defp products(shop) do
    Neuron.query(
      """
      {
        products(first: 100) {
          nodes {
            title
          }
        }
      }
      """,
      %{},
      shop_gql_opts(shop)
    )
  end

  def create_random_product(shop) do
    Neuron.query(
      """
      mutation productCreate($input: ProductInput!) {
        productCreate(input: $input) {
          userErrors {
            field
            message
          }
        }
      }
      """,
      %{
        input: %{
          title: random_title(),
          variants: [%{price: random_price()}]
        }
      },
      shop_gql_opts(shop)
    )
  end

  defp shop_gql_opts(shop) do
    [
      url: "https://#{shop.url}/admin/api/2023-04/graphql.json",
      headers: ["X-Shopify-Access-Token": shop.access_token]
    ]
  end

  defp random_price do
    (100.0 + Enum.random(1..1000)) / 100
  end

  defp random_title do
    adjectives = [
      "autumn",
      "hidden",
      "bitter",
      "misty",
      "silent",
      "empty",
      "dry",
      "dark",
      "summer",
      "icy",
      "delicate",
      "quiet",
      "white",
      "cool",
      "spring",
      "winter",
      "patient",
      "twilight",
      "dawn",
      "crimson",
      "wispy",
      "weathered",
      "blue",
      "billowing",
      "broken",
      "cold",
      "damp",
      "falling",
      "frosty",
      "green",
      "long"
    ]

    nouns = [
      "waterfall",
      "river",
      "breeze",
      "moon",
      "rain",
      "wind",
      "sea",
      "morning",
      "snow",
      "lake",
      "sunset",
      "pine",
      "shadow",
      "leaf",
      "dawn",
      "glitter",
      "forest",
      "hill",
      "cloud",
      "meadow",
      "sun",
      "glade",
      "bird",
      "brook",
      "butterfly",
      "bush",
      "dew",
      "dust",
      "field",
      "fire",
      "flower"
    ]

    adjective = Enum.random(adjectives)
    noun = Enum.random(nouns)

    "#{adjective} #{noun}"
  end
end

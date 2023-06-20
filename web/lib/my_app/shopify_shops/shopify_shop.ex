defmodule MyApp.ShopifyShops.ShopifyShop do
  @moduledoc "A schema representing a shopify shop/client/user"
  use Ecto.Schema
  import Ecto.Changeset

  schema "shopify_shops" do
    field :url, :string
    field :access_token, :string
    field :scope, :string
    has_many :grants, MyApp.ShopifyShops.ShopifyGrant, foreign_key: :shop_id

    timestamps()
  end

  @doc false
  def changeset(shopify_shop, attrs) do
    shopify_shop
    |> cast(attrs, [:url, :access_token, :scope])
    |> validate_required([:url, :access_token, :scope])
  end
end

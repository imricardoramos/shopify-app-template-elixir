defmodule MyApp.ShopifyShops.ShopifyGrant do
  @moduledoc "A schema representing a shopify grant"
  use Ecto.Schema
  import Ecto.Changeset

  schema "shopify_grants" do
    field :total_usages, :integer, default: 0

    belongs_to :shop, MyApp.ShopifyShops.ShopifyShop, foreign_key: :shop_id

    timestamps()
  end

  @doc false
  def changeset(shopify_grant, attrs) do
    shopify_grant
    |> cast(attrs, [:charge_id, :grants, :remaining_usages, :total_usages, :shop_id])
    |> validate_required([:charge_id, :grants, :remaining_usages, :total_usages, :shop_id])
  end
end

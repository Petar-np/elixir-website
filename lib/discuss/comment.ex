defmodule Discuss.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:content]}

  schema "comments" do
    field :content, :string
    field :user_id, :id
    field :topic_id, :id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end

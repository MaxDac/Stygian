defmodule Stygian.Transactions.AdminListFilters do
  @moduledoc """
  Embedded schema for the transaction filter form. 
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Stygian.Transactions.AdminListFilters

  @type t() :: %__MODULE__{
          date_from: NaiveDateTime.t(),
          date_to: NaiveDateTime.t(),
          character_id: non_neg_integer()
        }

  embedded_schema do
    field :date_from, :naive_datetime
    field :date_to, :naive_datetime
    field :character_id, :integer
  end

  @doc false
  def changeset(%AdminListFilters{} = admin_list_filters, attrs \\ %{}) do
    admin_list_filters
    |> cast(attrs, [:character_id, :date_from, :date_to])
    |> validate_date_range([:date_from, :date_to])
  end

  defp validate_date_range(changeset, [field_from, field_to]) do
    case {get_field(changeset, field_from), get_field(changeset, field_to)} do
      {nil, nil} ->
        changeset

      {nil, _} ->
        add_error(changeset, field_from, "can't be blank")

      {_, nil} ->
        add_error(changeset, field_to, "can't be blank")

      {%NaiveDateTime{} = from, %NaiveDateTime{} = to} ->
        if NaiveDateTime.compare(from, to) == :gt do
          add_error(changeset, field_from, "can't be greater than #{field_to}")
        else
          changeset
        end

      _ ->
        changeset
        |> add_error(field_from, "invalid data type")
        |> add_error(field_to, "invalid data type")
    end
  end
end

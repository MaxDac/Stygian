defmodule Stygian.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :cigs, :integer
      add :sender_id, references(:characters, on_delete: :nothing)
      add :receiver_id, references(:characters, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:sender_id])
    create index(:transactions, [:receiver_id])
  end
end

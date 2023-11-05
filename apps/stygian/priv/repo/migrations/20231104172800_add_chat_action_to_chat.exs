defmodule Stygian.Repo.Migrations.AddChatActionToChat do
  use Ecto.Migration

  def change do
    alter table(:chats) do
      add :chat_action_id, references(:chat_actions, on_delete: :delete_all), null: true
    end
  end
end

defmodule Stygian.OrganisationsTest do
  use Stygian.DataCase

  alias Stygian.Organisations

  describe "organisations" do
    alias Stygian.Organisations.Organisation

    import Stygian.OrganisationsFixtures

    @invalid_attrs %{name: nil, description: nil, image: nil, base_salary: nil}

    test "list_organisations/0 returns all organisations" do
      organisation = organisation_fixture()
      assert Organisations.list_organisations() == [organisation]
    end

    test "get_organisation!/1 returns the organisation with given id" do
      organisation = organisation_fixture()
      assert Organisations.get_organisation!(organisation.id) == organisation
    end

    test "get_organisation_by_name/1 correctly returns the organisation with that name" do
      %{name: organisation_name} = organisation_fixture()

      assert organisation = Organisations.get_organisation_by_name(organisation_name)
      
      refute is_nil(organisation)
      assert organisation_name = organisation.name
    end

    test "get_organisation_by_name/1 returns nil if there are no organisation with the specified name" do
      %{name: organisation_name} = organisation_fixture()
      inexistent_organisation_name = "#{organisation_name}inexistent"

      assert is_nil(Organisations.get_organisation_by_name(inexistent_organisation_name))
    end

    test "create_organisation/1 with valid data creates a organisation" do
      valid_attrs = %{
        name: "some name",
        description: "some description",
        image: "some image",
        base_salary: 42
      }

      assert {:ok, %Organisation{} = organisation} =
               Organisations.create_organisation(valid_attrs)

      assert organisation.name == "some name"
      assert organisation.description == "some description"
      assert organisation.image == "some image"
      assert organisation.base_salary == 42
    end

    test "create_organisation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organisations.create_organisation(@invalid_attrs)
    end

    test "update_organisation/2 with valid data updates the organisation" do
      organisation = organisation_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        image: "some updated image",
        base_salary: 43
      }

      assert {:ok, %Organisation{} = organisation} =
               Organisations.update_organisation(organisation, update_attrs)

      assert organisation.name == "some updated name"
      assert organisation.description == "some updated description"
      assert organisation.image == "some updated image"
      assert organisation.base_salary == 43
    end

    test "update_organisation/2 with invalid data returns error changeset" do
      organisation = organisation_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Organisations.update_organisation(organisation, @invalid_attrs)

      assert organisation == Organisations.get_organisation!(organisation.id)
    end

    test "delete_organisation/1 deletes the organisation" do
      organisation = organisation_fixture()
      assert {:ok, %Organisation{}} = Organisations.delete_organisation(organisation)
      assert_raise Ecto.NoResultsError, fn -> Organisations.get_organisation!(organisation.id) end
    end

    test "change_organisation/1 returns a organisation changeset" do
      organisation = organisation_fixture()
      assert %Ecto.Changeset{} = Organisations.change_organisation(organisation)
    end
  end

  describe "characters_rel_organisations" do
    alias Stygian.Organisations.CharactersOrganisations

    import Stygian.OrganisationsFixtures
    import Stygian.CharactersFixtures

    @invalid_attrs %{last_salary_withdraw: nil}

    test "list_characters_rel_organisations/0 returns all characters_rel_organisations" do
      characters_organisations = characters_organisations_fixture()
      assert Organisations.list_characters_rel_organisations() == [characters_organisations]
    end

    test "get_characters_organisations!/1 returns the characters_organisations with given id" do
      characters_organisations = characters_organisations_fixture()

      assert Organisations.get_characters_organisations!(characters_organisations.id) ==
               characters_organisations
    end

    test "get_character_organisation/2 returns the character job with the right organisation" do
      %{
        character_id: character_id,
        organisation_id: organisation_id,
        last_salary_withdraw: last_salary_withdraw
      } = characters_organisations_fixture()

      characters_organisations = Organisations.get_character_organisation(character_id)

      assert characters_organisations.character_id == character_id
      assert characters_organisations.organisation_id == organisation_id
      assert characters_organisations.last_salary_withdraw == last_salary_withdraw
    end

    test "get_character_organisation/2 returns nil when the character does not have a job" do
      %{id: character_id} = character_fixture()
      %{id: organisation_id} = organisation_fixture()

      assert is_nil Organisations.get_character_organisation(character_id)
    end

    test "has_character_organisation?/1 returns true when the character has an organisation job." do
      %{
        character_id: character_id,
      } = characters_organisations_fixture()

      assert Organisations.has_character_organisation?(character_id)
    end

    test "has_character_organisation?/1 returns false when the character does not have an organisation job." do
      %{id: character_id} = character_fixture()
      organisation_fixture()

      refute Organisations.has_character_organisation?(character_id)
    end

    test "has_character_organisation?/1 returns true when the character previously revoked the organisation job." do
      %{
        character_id: character_id,
      } = characters_organisations_fixture(%{end_date: NaiveDateTime.utc_now()})

      refute Organisations.has_character_organisation?(character_id)
    end

    test "create_characters_organisations/1 with valid data creates a characters_organisations" do
      %{id: character_id} = character_fixture()
      %{id: organisation_id} = organisation_fixture()

      valid_attrs = %{
        character_id: character_id,
        organisation_id: organisation_id,
        last_salary_withdraw: ~N[2023-10-04 20:46:00]
      }

      assert {:ok, %CharactersOrganisations{} = characters_organisations} =
               Organisations.create_characters_organisations(valid_attrs)

      assert characters_organisations.last_salary_withdraw == ~N[2023-10-04 20:46:00]
    end

    test "create_characters_organisations/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Organisations.create_characters_organisations(@invalid_attrs)
    end

    test "update_characters_organisations/2 with valid data updates the characters_organisations" do
      characters_organisations = characters_organisations_fixture()
      update_attrs = %{last_salary_withdraw: ~N[2023-10-05 20:46:00]}

      assert {:ok, %CharactersOrganisations{} = characters_organisations} =
               Organisations.update_characters_organisations(characters_organisations, update_attrs)

      assert characters_organisations.last_salary_withdraw == ~N[2023-10-05 20:46:00]
    end

    test "assign_character_organisation/2 correctly assigns the organisation to the given character" do
      %{id: character_id} = character_fixture() 
      %{id: organisation_id} = organisation_fixture()

      assert {:ok, %CharactersOrganisations{id: id} = characters_organisations} =
               Organisations.assign_character_organisation(character_id, organisation_id)

      characters_organisations = Organisations.get_characters_organisations!(id)

      assert characters_organisations.character_id == character_id
      assert characters_organisations.organisation_id == organisation_id
      refute nil = characters_organisations.end_date
      refute nil = characters_organisations.last_salary_withdraw
    end

    test "assign_character_organisation/2 does not assign the organisation to a character that is already associated with another" do
      %{id: character_id} = character_fixture() 
      %{id: organisation_id_1} = organisation_fixture(%{name: "some name"})
      %{id: organisation_id_2} = organisation_fixture(%{name: "some other name"})

      Organisations.assign_character_organisation(character_id, organisation_id_1)

      assert {:error, "Il personaggio appartiene già ad un'organizzazione."} =
        Organisations.assign_character_organisation(character_id, organisation_id_2)
    end

    test "assign_character_organisation/2 does not assign a non-existent organisation to a character" do
      %{id: character_id} = character_fixture() 

      assert {:error, "Personaggio o organizzazione inesistenti."} =
        Organisations.assign_character_organisation(character_id, 42)
    end

    test "assign_character_organisation/2 does not assign the organisation to a non-existent character" do
      %{id: organisation_id} = organisation_fixture()

      assert {:error, "Personaggio o organizzazione inesistenti."} =
        Organisations.assign_character_organisation(42, organisation_id)
    end

    test "revoke_character_organisation/1 correctly revokes the organisation link" do
      %{id: character_id} = character_fixture() 
      %{id: organisation_id} = organisation_fixture()

      assert {:ok, _} =
               Organisations.assign_character_organisation(character_id, organisation_id)

      assert {:ok, _} = Organisations.revoke_character_organisation(character_id)

      refute Organisations.has_character_organisation?(character_id)
    end

    test "revoke_character_organisation/1 does not revoke the link because there are none active" do
      %{character_id: character_id, organisation_id: organisation_id} = 
        characters_organisations_fixture(%{end_date: NaiveDateTime.utc_now()})

      assert {:error, "Il personaggio non appartiene a nessuna organizzazione."} = 
        Organisations.revoke_character_organisation(character_id)
    end

    test "delete_characters_organisations/1 deletes the characters_organisations" do
      characters_organisations = characters_organisations_fixture()

      assert {:ok, %CharactersOrganisations{}} =
               Organisations.delete_characters_organisations(characters_organisations)

      assert_raise Ecto.NoResultsError, fn ->
        Organisations.get_characters_organisations!(characters_organisations.id)
      end
    end

    test "change_characters_organisations/1 returns a characters_organisations changeset" do
      characters_organisations = characters_organisations_fixture()

      assert %Ecto.Changeset{} =
               Organisations.change_characters_organisations(characters_organisations)
    end
  end

  describe "Character withdrawalrs" do
    alias Stygian.Characters
    alias Stygian.Organisations.CharactersOrganisations

    import Stygian.OrganisationsFixtures
    import Stygian.CharactersFixtures

    test "can_withdraw_salary?/1 returns true when the character can withdraw the daily salary" do
      last_withdraw = NaiveDateTime.add(NaiveDateTime.utc_now(), -25 * 60 * 60, :second)
      %{character_id: character_id} = characters_organisations_fixture(%{last_salary_withdraw: last_withdraw})
      
      assert Organisations.can_withdraw_salary?(character_id)
    end

    test "can_withdraw_salary?/1 returns false when the character cannot withdraw the daily salary" do
      last_withdraw = NaiveDateTime.add(NaiveDateTime.utc_now(), -23 * 60 * 60, :second)
      %{character_id: character_id} = characters_organisations_fixture(%{last_salary_withdraw: last_withdraw})
      
      refute Organisations.can_withdraw_salary?(character_id)
    end

    test "withdraw_salary/1 correctly updates the character cigs with the salary when the withdraw was performed more than 1 day ago" do
      %{id: character_id} = character_fixture_complete(%{cigs: 21})
      %{id: organisation_id} = organisation_fixture(%{base_salary: 21})
      
      characters_organisations_fixture(%{
        character_id: character_id, 
        organisation_id: organisation_id, 
        last_salary_withdraw: NaiveDateTime.add(NaiveDateTime.utc_now(), -25 * 60 * 60, :second)
      })

      assert {:ok, _} = Organisations.withdraw_salary(character_id)

      character = Characters.get_character!(character_id)
      character_organisation = Organisations.get_character_organisation(character_id)

      assert 42 = character.cigs

      # Setting the limit time to 1 hour ago, so the test can prove that the 
      # last date has been updated at least one hour ago.
      inferior_limit = NaiveDateTime.add(NaiveDateTime.utc_now(), -1 * 60 * 60, :second)
      assert character_organisation.last_salary_withdraw > inferior_limit
    end

    test "withdraw_salary/1 does not update the character cigs when the withdraw was performed less than 1 day ago" do
      %{id: character_id} = character_fixture_complete(%{cigs: 21})
      %{id: organisation_id} = organisation_fixture(%{base_salary: 21})
      
      %{last_salary_withdraw: last_withdraw} = characters_organisations_fixture(%{
        character_id: character_id, 
        organisation_id: organisation_id, 
        last_salary_withdraw: NaiveDateTime.add(NaiveDateTime.utc_now(), -23 * 60 * 60, :second)
      })

      assert {:error, "Non puoi ancora ritirare lo stipendio, devi aspettare un giorno."} = 
        Organisations.withdraw_salary(character_id)

      character = Characters.get_character!(character_id)
      character_organisation = Organisations.get_character_organisation(character_id)

      assert 21 = character.cigs

      assert character_organisation.last_salary_withdraw == last_withdraw
    end
  end
end

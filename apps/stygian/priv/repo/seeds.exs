# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Stygian.Repo.insert!(%Stygian.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Stygian.Accounts
alias Stygian.Characters
alias Stygian.Combat
alias Stygian.Maps
alias Stygian.Objects
alias Stygian.Organisations
alias Stygian.Rest
alias Stygian.Skills
alias Stygian.Weapons

alias Stygian.Characters.CharacterSkill

defmodule AccountsHelpers do
  def create_user?(%{username: username} = attrs) do
    {:ok, user} =
      case Accounts.get_user_by_username(username) do
        nil ->
          case Accounts.register_user(attrs) do
            {:ok, user} ->
              Accounts.update_user(user, attrs)

            # User changed name 
            {:error, %{errors: [email: {"has already been taken", _}]}} ->
              update_user_name(attrs)

            error ->
              error
          end

        user ->
          Accounts.update_user(user, attrs)
      end

    user
    |> Accounts.confirm_user_test()
  end

  defp update_user_name(attrs = %{username: username, email: email}) do
    with user <- Accounts.get_user_by_email(email),
         {:ok, user} <- Accounts.update_user_name(user, username) do
      Accounts.update_user(user, attrs)
    end
  end

  defp update_user_name(_), do: {:error, "Email or username emtpy"}
end

defmodule SkillHelpers do
  def create_type?(attrs = %{name: skill_type_name}) do
    case Skills.get_skill_type_by_name(skill_type_name) do
      nil -> Skills.create_skill_type(attrs)
      skill -> {:ok, skill}
    end
  end

  def create_skill?(attrs = %{name: skill_name}) do
    case Skills.get_skill_by_name(skill_name) do
      nil -> Skills.create_skill(attrs)
      skill -> {:ok, skill}
    end
  end

  def add_skill_type_to_skill(skill, skill_type) do
    case not Skills.skill_has_type?(skill, skill_type) &&
           Skills.add_skill_type_to_skill(skill, skill_type) do
      {:ok, _} -> true
      false -> false
    end
  end
end

defmodule MapHelpers do
  def add_map(map = %{name: name}) do
    case Maps.get_map_by_name(name) do
      nil -> Maps.create_map(map)
      existing_map -> Maps.update_map(existing_map, map)
    end
  end
end

defmodule CharacterHelpers do
  def create_character?(%{name: name} = attrs) do
    case Characters.get_character_by_name(name) do
      nil ->
        with {:ok, character} <- Characters.create_character(attrs) do
          Characters.update_character(character, attrs)
        end

      character ->
        Characters.update_character(character, attrs)
    end
  end

  @doc """
  This function will delete and recreate again the skills of the character.
  Make sure that with every update the character skills are up to date, otherwise they'll be rewritten.
  """
  def associate_skills_to_character(character, skills) do
    Characters.create_character_skills_internal(skills, character.id)
  end

  def create_npc?(%{name: name} = params, skills) do
    attrs = Map.new(params, fn {key, value} -> {Atom.to_string(key), value} end)

    case Characters.get_character_by_name(name) do
      nil ->
        with {:ok, character} <- Characters.create_npc(attrs, skills) do
          Characters.update_character(character, attrs)
        end

      character ->
        Characters.update_character(character, attrs)
    end
  end
end

defmodule OrganisationsHelpers do
  def create_organisation(%{name: name} = attrs) do
    case Organisations.get_organisation_by_name(name) do
      nil ->
        with {:ok, organisation} <- Organisations.create_organisation(attrs) do
          Organisations.update_organisation(organisation, attrs)
        end

      organisation ->
        Organisations.update_organisation(organisation, attrs)
    end
  end
end

defmodule ObjectsHelpers do
  def create_object(%{name: name} = attrs) do
    case Objects.get_object_by_name(name) do
      nil ->
        with {:ok, object} <- Objects.create_object(attrs) do
          Objects.update_object(object, attrs)
        end

      object ->
        Objects.update_object(object, attrs)
    end
  end

  def create_effect(%{object_id: object_id, skill_id: skill_id} = attrs) do
    case Objects.get_effect(object_id, skill_id) do
      nil ->
        with {:ok, effect} <- Objects.create_effect(attrs) do
          Objects.update_effect(effect, attrs)
        end

      effect ->
        Objects.update_effect(effect, attrs)
    end
  end
end

defmodule RestActionsHelpers do
  def create_rest_action(%{name: name} = attrs) do
    case Rest.get_rest_action_by_name(name) do
      nil ->
        with {:ok, rest_action} <- Rest.create_rest_action(attrs) do
          Rest.update_rest_action(rest_action, attrs)
        end

      rest_action ->
        Rest.update_rest_action(rest_action, attrs)
    end
  end
end

defmodule WeaponsHelpers do
  def create_weapon_type(%{name: name} = attrs) do
    case Weapons.get_weapon_type_by_name(name) do
      nil ->
        with {:ok, weapon_type} <- Weapons.create_weapon_type(attrs) do
          Weapons.update_weapon_type(weapon_type, attrs)
        end

      weapon_type ->
        Weapons.update_weapon_type(weapon_type, attrs)
    end
  end

  def create_weapon(%{name: name} = attrs) do
    case Weapons.get_weapon_by_name(name) do
      nil ->
        with {:ok, weapon} <- Weapons.create_weapon(attrs) do
          Weapons.update_weapon(weapon, attrs)
        end

      weapon ->
        Weapons.update_weapon(weapon, attrs)
    end
  end
end

defmodule CombatActionsHelpers do
  def create_combat_action(%{name: name} = attrs) do
    case Combat.get_action_by_name(name) do
      nil ->
        with {:ok, combat_action} <- Combat.create_action(attrs) do
          Combat.update_action(combat_action, attrs)
        end

      combat_action ->
        Combat.update_action(combat_action, attrs)
    end
  end
end

# Creating admin users
{:ok, _admin_user} =
  AccountsHelpers.create_user?(%{
    email: "postmaster@stygian-gdr.it",
    username: "Narratore",
    password: "password1234",
    admin: true
  })

AccountsHelpers.create_user?(%{
  email: "gabriele.dacunzo@outlook.com",
  username: "Gahadiel",
  password: "password1234",
  admin: true
})

# Creating test user
AccountsHelpers.create_user?(%{
  email: "massimiliano.dacunzo@hotmail.com",
  username: "Maz",
  password: "password1234",
  admin: false
})

# Creating user that could be used to demo the land
{:ok, test_user} =
  AccountsHelpers.create_user?(%{
    email: "user@stygian-gdr.it",
    username: "User",
    password: "somepassword4321",
    admin: false
  })

#
# Creating skill types
#

{:ok, %{id: attribute_skill_id}} =
  SkillHelpers.create_type?(%{
    name: "Attribute",
    description: "Attribute, can be trained and has to be included in creation"
  })

{:ok, %{id: knowledge_skill_id}} =
  SkillHelpers.create_type?(%{
    name: "Knowledge",
    description: "Knowledge skills can't be used if not trained"
  })

{:ok, %{id: occult_skill_id}} =
  SkillHelpers.create_type?(%{
    name: "Occult",
    description: "Prohibited skill, its knowledge affects the sanity"
  })

{:ok, %{id: _non_creational_skill_id}} =
  SkillHelpers.create_type?(%{
    name: "Non creational",
    description: "Can't be used in creation"
  })

#
# Creating skills
#

#
# Attributes
#

{:ok, %{id: fisico_id}} =
  SkillHelpers.create_skill?(%{
    name: "Fisico",
    description:
      "Rappresenta la prestanza fisica, la resistenza e la forza. Incide direttamente nel computo della salute e dei danni inflitti con armi bianche."
  })

{:ok, %{id: agilita_id}} =
  SkillHelpers.create_skill?(%{
    name: "Agilità",
    description:
      "Rappresenta la destrezza e la capacità di movimento. Incide direttamente nel computo della difesa e dei danni inflitti con armi da lancio."
  })

{:ok, %{id: volonta_id}} =
  SkillHelpers.create_skill?(%{
    name: "Volontà",
    description:
      "Rappresenta la forza di volontà e la capacità di resistere agli attacchi psichici. Incide direttamente nel computo della resistenza psichica e della salute mentale."
  })

{:ok, %{id: carisma_id}} =
  SkillHelpers.create_skill?(%{
    name: "Carisma",
    description:
      "Rappresenta la capacità di interagire con gli altri e di influenzarli. Incide direttamente nel computo della persuasione e della resistenza psichica."
  })

{:ok, %{id: mente_id}} =
  SkillHelpers.create_skill?(%{
    name: "Mente",
    description:
      "Rappresenta la capacità di ragionamento e di apprendimento. Incide direttamente nel computo della conoscenza e della capacità di ricerca."
  })

{:ok, %{id: sensi_id}} =
  SkillHelpers.create_skill?(%{
    name: "Sensi",
    description:
      "Rappresenta la capacità di percepire il mondo circostante. Incide direttamente nel computo della percezione e dei danni inflitti con armi da fuoco."
  })

#
# Skills
#

{:ok, %{id: firearms_id}} =
  SkillHelpers.create_skill?(%{
    name: "Armi da fuoco",
    description:
      "L'addestramento in armi da fuoco aiuterà il personaggio a colpire il bersaglio con precisione e a infliggere danni maggiori."
  })

{:ok, %{id: melee_id}} =
  SkillHelpers.create_skill?(%{
    name: "Armi bianche",
    description:
      "L'addestramento nelle armi bianche consentirà al personaggio di infliggere la maggior quantità di danni con armi bianche, quali coltelli o bastoni."
  })

{:ok, %{id: brawl_id}} =
  SkillHelpers.create_skill?(%{
    name: "Arti marziali",
    description:
      "Le arti marziali riguardano tutto ciò che è combattimento corpo a corpo, come pugni, calci, prese e proiezioni."
  })

{:ok, %{id: athletic_id}} =
  SkillHelpers.create_skill?(%{
    name: "Atletica",
    description:
      "Rappresenta la tecnica nel compiere azioni prettamente fisiche, come correre, saltare, arrampicarsi, nuotare o lanciare oggetti."
  })

{:ok, %{id: dialettica_id}} =
  SkillHelpers.create_skill?(%{
    name: "Dialettica",
    description:
      "La dialettica riguarda la capacità di parlare e di convincere gli altri. Questa conoscenza può anche aiutare a comprendere quando qualcuno sta mentendo."
  })

{:ok, %{id: furtivita_id}} =
  SkillHelpers.create_skill?(%{
    name: "Furtività",
    description:
      "Rappresenta la capacità di muoversi in silenzio e di nascondersi, ma aiuta anche a capire dove qualcun altro si possa nascondere."
  })

{:ok, %{id: investigazione_id}} =
  SkillHelpers.create_skill?(%{
    name: "Investigazione",
    description:
      "Rappresenta la capacità di indagare su un caso, di trovare indizi e di analizzarli, ricostruendo una vicenda, o un delitto."
  })

{:ok, %{id: occult_id}} =
  SkillHelpers.create_skill?(%{
    name: "Occulto",
    description:
      "La conoscenza occulta riguarda tutto ciò che è magia, demonologia, esoterismo e soprannaturale. Aiuterà il personaggio a comprendere fenomeni inspiegabili, ma potrebbe influire negativamente sulla sanità mentale."
  })

{:ok, %{id: psichology_id}} =
  SkillHelpers.create_skill?(%{
    name: "Psicologia",
    description:
      "La psicologia riguarda lo studio della mente umana e dei suoi meccanismi. Aiuterà il personaggio a comprendere i comportamenti altrui e a manipolarli, oltre che comprendere e guarire alienazioni mentali, sia proprie sia altrui."
  })

{:ok, %{id: science_id}} =
  SkillHelpers.create_skill?(%{
    name: "Scienza",
    description:
      "La scienza riguarda lo studio della natura e dei suoi meccanismi. Aiuterà il personaggio a comprendere fenomeni naturali, e influirà sulla capacità di ricerca scientifica."
  })

{:ok, %{id: subterfuge_id}} =
  SkillHelpers.create_skill?(%{
    name: "Sotterfugio",
    description:
      "Il sotterfugio è l'arte dei ladri e dei truffatori. Aiuterà il personaggio a rubare, a scassinare, a distrarre l'attenzione o giocare sporco."
  })

{:ok, %{id: survival_id}} =
  SkillHelpers.create_skill?(%{
    name: "Sopravvivenza",
    description:
      "Rappresenta la capacità di sopravvivere in ambienti ostili, riciclando materiali di scarto, costruire rifugi di fortuna o anche preparare cibo scaduto o in cattivo stato."
  })

#
# Creating relationships
#

SkillHelpers.add_skill_type_to_skill(%{id: fisico_id}, %{id: attribute_skill_id})
SkillHelpers.add_skill_type_to_skill(%{id: agilita_id}, %{id: attribute_skill_id})
SkillHelpers.add_skill_type_to_skill(%{id: carisma_id}, %{id: attribute_skill_id})
SkillHelpers.add_skill_type_to_skill(%{id: volonta_id}, %{id: attribute_skill_id})
SkillHelpers.add_skill_type_to_skill(%{id: mente_id}, %{id: attribute_skill_id})
SkillHelpers.add_skill_type_to_skill(%{id: sensi_id}, %{id: attribute_skill_id})

SkillHelpers.add_skill_type_to_skill(%{id: investigazione_id}, %{id: knowledge_skill_id})
SkillHelpers.add_skill_type_to_skill(%{id: occult_id}, %{id: knowledge_skill_id})
SkillHelpers.add_skill_type_to_skill(%{id: psichology_id}, %{id: knowledge_skill_id})
SkillHelpers.add_skill_type_to_skill(%{id: science_id}, %{id: knowledge_skill_id})
SkillHelpers.add_skill_type_to_skill(%{id: subterfuge_id}, %{id: knowledge_skill_id})
SkillHelpers.add_skill_type_to_skill(%{id: survival_id}, %{id: knowledge_skill_id})

SkillHelpers.add_skill_type_to_skill(%{id: occult_id}, %{id: occult_skill_id})

#
# Creating default characters
#

# John Doe, test character
{:ok, test_character} =
  CharacterHelpers.create_character?(%{
    name: "John Doe",
    admin_notes: "Some admin_notes",
    avatar: "/images/avatars/TestUser.webp",
    chat_avatar: "/images/avatars/TestUserSmall.webp",
    biography: "Some biography",
    cigs: 200,
    description: "Some description",
    experience: 0,
    health: 100,
    age: :adult,
    sin: "Some sins",
    lost_health: 1,
    lost_sanity: 1,
    npc: false,
    notes: "Some notes",
    sanity: 42,
    step: 2,
    user_id: test_user.id
  })

CharacterHelpers.associate_skills_to_character(test_character, [
  %CharacterSkill{character_id: test_character.id, skill_id: fisico_id, value: 6},
  %CharacterSkill{character_id: test_character.id, skill_id: agilita_id, value: 5},
  %CharacterSkill{character_id: test_character.id, skill_id: volonta_id, value: 7},
  %CharacterSkill{character_id: test_character.id, skill_id: carisma_id, value: 6},
  %CharacterSkill{character_id: test_character.id, skill_id: mente_id, value: 6},
  %CharacterSkill{character_id: test_character.id, skill_id: sensi_id, value: 5},
  %CharacterSkill{character_id: test_character.id, skill_id: firearms_id, value: 1},
  %CharacterSkill{character_id: test_character.id, skill_id: melee_id, value: 2},
  %CharacterSkill{character_id: test_character.id, skill_id: brawl_id, value: 0},
  %CharacterSkill{character_id: test_character.id, skill_id: athletic_id, value: 0},
  %CharacterSkill{character_id: test_character.id, skill_id: dialettica_id, value: 3},
  %CharacterSkill{character_id: test_character.id, skill_id: furtivita_id, value: 0},
  %CharacterSkill{character_id: test_character.id, skill_id: investigazione_id, value: 2},
  %CharacterSkill{character_id: test_character.id, skill_id: occult_id, value: 0},
  %CharacterSkill{character_id: test_character.id, skill_id: psichology_id, value: 0},
  %CharacterSkill{character_id: test_character.id, skill_id: science_id, value: 1},
  %CharacterSkill{character_id: test_character.id, skill_id: subterfuge_id, value: 2},
  %CharacterSkill{character_id: test_character.id, skill_id: survival_id, value: 1}
])

# Moshe

moshe_skill_set = [
  %CharacterSkill{skill_id: fisico_id, value: 4},
  %CharacterSkill{skill_id: agilita_id, value: 6},
  %CharacterSkill{skill_id: volonta_id, value: 7},
  %CharacterSkill{skill_id: carisma_id, value: 5},
  %CharacterSkill{skill_id: mente_id, value: 6},
  %CharacterSkill{skill_id: sensi_id, value: 6},
  %CharacterSkill{skill_id: firearms_id, value: 1},
  %CharacterSkill{skill_id: melee_id, value: 0},
  %CharacterSkill{skill_id: brawl_id, value: 0},
  %CharacterSkill{skill_id: athletic_id, value: 0},
  %CharacterSkill{skill_id: dialettica_id, value: 2},
  %CharacterSkill{skill_id: furtivita_id, value: 1},
  %CharacterSkill{skill_id: investigazione_id, value: 2},
  %CharacterSkill{skill_id: occult_id, value: 4},
  %CharacterSkill{skill_id: psichology_id, value: 2},
  %CharacterSkill{skill_id: science_id, value: 1},
  %CharacterSkill{skill_id: subterfuge_id, value: 1},
  %CharacterSkill{skill_id: survival_id, value: 0}
]

{:ok, _moshe} =
  CharacterHelpers.create_npc?(
    %{
      name: "Moshe Rothstein",
      admin_notes: "Some admin_notes",
      avatar: "/images/avatars/moshe-rothstein.webp",
      chat_avatar: "/images/avatars/moshe-rothstein.webp",
      biography: "Some biography",
      cigs: 1500,
      description: """
      Un uomo di mezza età, con un fisico snello, leggermente incurvato. Porta una kippah blu scura in testa, che copre
      i capelli ormai quasi completamente canuti. Indossa sempre abiti molto umili, camicie bianche con gilet di lana
      fina. L'espressione è sempre severa, attenta, i suoi occhi sempre in movimento.
      """,
      experience: 0,
      health: 55,
      age: :adult,
      sin: "Non è riuscito a salvare la figlia dal Cataclisma",
      lost_health: 0,
      lost_sanity: 0,
      npc: true,
      notes: "Some notes",
      sanity: 60,
      step: 2
    },
    moshe_skill_set
  )

# Jack Morgan

morgan_skill_set = [
  %CharacterSkill{skill_id: fisico_id, value: 7},
  %CharacterSkill{skill_id: agilita_id, value: 5},
  %CharacterSkill{skill_id: volonta_id, value: 7},
  %CharacterSkill{skill_id: carisma_id, value: 7},
  %CharacterSkill{skill_id: mente_id, value: 4},
  %CharacterSkill{skill_id: sensi_id, value: 5},
  %CharacterSkill{skill_id: firearms_id, value: 4},
  %CharacterSkill{skill_id: melee_id, value: 3},
  %CharacterSkill{skill_id: brawl_id, value: 4},
  %CharacterSkill{skill_id: athletic_id, value: 1},
  %CharacterSkill{skill_id: dialettica_id, value: 1},
  %CharacterSkill{skill_id: furtivita_id, value: 0},
  %CharacterSkill{skill_id: investigazione_id, value: 2},
  %CharacterSkill{skill_id: occult_id, value: 0},
  %CharacterSkill{skill_id: psichology_id, value: 0},
  %CharacterSkill{skill_id: science_id, value: 0},
  %CharacterSkill{skill_id: subterfuge_id, value: 1},
  %CharacterSkill{skill_id: survival_id, value: 3}
]

{:ok, _morgan} =
  CharacterHelpers.create_npc?(
    %{
      name: "Jack Morgan",
      admin_notes: "Some admin_notes",
      avatar: "/images/avatars/jack-morgan.webp",
      chat_avatar: "/images/avatars/jack-morgan.webp",
      biography: "Some biography",
      cigs: 500,
      description: """
      Un burbero ufficiale di polizia sorprendentemente alto, poco meno di un metro e ottanta, estremamente robusto, 
      con un collo taurino e tratti del viso e del naso tipici da pugile. Gli stretti occhi chiari riescono comunque
      a trasmettere un preciso senso di inquietudine, se non proprio di tensione, di aggressività. 
      """,
      experience: 0,
      health: 100,
      age: :adult,
      sin: "Ha ucciso diversi suoi colleghi durante il Cataclisma",
      lost_health: 0,
      lost_sanity: 0,
      npc: true,
      notes: "Some notes",
      sanity: 70,
      step: 2
    },
    morgan_skill_set
  )

# Frankie Masiello

frankie_skill_set = [
  %CharacterSkill{skill_id: fisico_id, value: 6},
  %CharacterSkill{skill_id: agilita_id, value: 6},
  %CharacterSkill{skill_id: volonta_id, value: 4},
  %CharacterSkill{skill_id: carisma_id, value: 5},
  %CharacterSkill{skill_id: mente_id, value: 4},
  %CharacterSkill{skill_id: sensi_id, value: 7},
  %CharacterSkill{skill_id: firearms_id, value: 2},
  %CharacterSkill{skill_id: melee_id, value: 1},
  %CharacterSkill{skill_id: brawl_id, value: 2},
  %CharacterSkill{skill_id: athletic_id, value: 1},
  %CharacterSkill{skill_id: dialettica_id, value: 2},
  %CharacterSkill{skill_id: furtivita_id, value: 2},
  %CharacterSkill{skill_id: investigazione_id, value: 0},
  %CharacterSkill{skill_id: occult_id, value: 1},
  %CharacterSkill{skill_id: psichology_id, value: 1},
  %CharacterSkill{skill_id: science_id, value: 0},
  %CharacterSkill{skill_id: subterfuge_id, value: 4},
  %CharacterSkill{skill_id: survival_id, value: 3}
]

{:ok, _frankie} =
  CharacterHelpers.create_npc?(
    %{
      name: "Frankie Masiello",
      admin_notes: "Some admin_notes",
      avatar: "/images/avatars/frankie-masiello.webp",
      chat_avatar: "/images/avatars/frankie-masiello.webp",
      biography: "Some biography",
      cigs: 500,
      description: """
      Un guitto sufficientemente alto da mostrare tutto il busto oltre il bancone, secco ma all'apparenza comunque in 
      forma. Coltiva un aspetto molto curato, i lunghi baffi sono evidentemente tagliati con cura, la barba
      quotidianamente rasata. Indossa sempre l'uniforme da lavoro, inamidata alla bell'e meglio. Con gli occhi segue 
      sempre tutti i clienti, più che per controllarli, pare, per approfittare del momento propizio per derubarli.
      """,
      experience: 0,
      health: 60,
      age: :adult,
      sin: "Ha ucciso lasciato morire diverse durante il Cataclisma preda dei mostri",
      lost_health: 0,
      lost_sanity: 0,
      npc: true,
      notes: "Some notes",
      sanity: 40,
      step: 2
    },
    frankie_skill_set
  )

# The Nameless

nameless_skill_set = [
  %CharacterSkill{skill_id: fisico_id, value: 5},
  %CharacterSkill{skill_id: agilita_id, value: 7},
  %CharacterSkill{skill_id: volonta_id, value: 7},
  %CharacterSkill{skill_id: carisma_id, value: 3},
  %CharacterSkill{skill_id: mente_id, value: 7},
  %CharacterSkill{skill_id: sensi_id, value: 5},
  %CharacterSkill{skill_id: firearms_id, value: 0},
  %CharacterSkill{skill_id: melee_id, value: 1},
  %CharacterSkill{skill_id: brawl_id, value: 3},
  %CharacterSkill{skill_id: athletic_id, value: 0},
  %CharacterSkill{skill_id: dialettica_id, value: 1},
  %CharacterSkill{skill_id: furtivita_id, value: 3},
  %CharacterSkill{skill_id: investigazione_id, value: 1},
  %CharacterSkill{skill_id: occult_id, value: 5},
  %CharacterSkill{skill_id: psichology_id, value: 1},
  %CharacterSkill{skill_id: science_id, value: 0},
  %CharacterSkill{skill_id: subterfuge_id, value: 0},
  %CharacterSkill{skill_id: survival_id, value: 1}
]

{:ok, _nameless} =
  CharacterHelpers.create_npc?(
    %{
      name: "The Nameless",
      admin_notes: "Some admin_notes",
      avatar: "/images/avatars/the-nameless.webp",
      chat_avatar: "/images/avatars/the-nameless.webp",
      biography: "Some biography",
      cigs: 200,
      description: """
      Un essere ripugnante: allampanato e contorto, piegato su se stesso da quelli che sembrano anni di studi forsennato,
      il volto è completamente coperto da una lerci bendaggi macchiati di sangue rappreso, i pochi capelli che ne 
      fuoriescono sono simili a setole di animale troppo cresciute, più che a capelli umani. Indossa una camicia a sbuffo
      ingiallita, di un'altra epoca distante, un lungo cappotto violaceo impolverato e scarpe che sarebbero state fuori
      moda anche un secolo prima. 
      """,
      experience: 0,
      health: 40,
      age: :adult,
      sin: "Ha ucciso lasciato morire diverse durante il Cataclisma preda dei mostri",
      lost_health: 0,
      lost_sanity: 0,
      npc: true,
      notes: "Some notes",
      sanity: 100,
      step: 2
    },
    nameless_skill_set
  )

# The Nameless

moreau_skill_set = [
  %CharacterSkill{skill_id: fisico_id, value: 6},
  %CharacterSkill{skill_id: agilita_id, value: 7},
  %CharacterSkill{skill_id: volonta_id, value: 7},
  %CharacterSkill{skill_id: carisma_id, value: 7},
  %CharacterSkill{skill_id: mente_id, value: 7},
  %CharacterSkill{skill_id: sensi_id, value: 6},
  %CharacterSkill{skill_id: firearms_id, value: 0},
  %CharacterSkill{skill_id: melee_id, value: 4},
  %CharacterSkill{skill_id: brawl_id, value: 2},
  %CharacterSkill{skill_id: athletic_id, value: 1},
  %CharacterSkill{skill_id: dialettica_id, value: 3},
  %CharacterSkill{skill_id: furtivita_id, value: 3},
  %CharacterSkill{skill_id: investigazione_id, value: 1},
  %CharacterSkill{skill_id: occult_id, value: 4},
  %CharacterSkill{skill_id: psichology_id, value: 3},
  %CharacterSkill{skill_id: science_id, value: 1},
  %CharacterSkill{skill_id: subterfuge_id, value: 1},
  %CharacterSkill{skill_id: survival_id, value: 2}
]

{:ok, _moreau} =
  CharacterHelpers.create_npc?(
    %{
      name: "Anthony Moreau",
      admin_notes: "Some admin_notes",
      avatar: "/images/avatars/anthony-moreau.webp",
      chat_avatar: "/images/avatars/anthony-moreau.webp",
      biography: "Some biography",
      cigs: 500,
      description: """
      Un signore sulla quarantina dai modi estremamente ricercati, veste sempre con completi più unici che rari dopo il 
      Cataclisma. La pelle è insolitamente pallida, i capelli ben pettinati erano neri, ora quasi completamente 
      imbiancati. Nonostante l'età, il fisico è ancora asciutto e atletico, e il viso è privo di rughe. 
      """,
      experience: 0,
      health: 80,
      age: :adult,
      sin: "Ha provocato il Cataclisma",
      lost_health: 0,
      lost_sanity: 0,
      npc: true,
      notes: "Some notes",
      sanity: 800,
      step: 2
    },
    moreau_skill_set
  )

#
# Creating maps
#

{:ok, %{id: wastes_id}} =
  MapHelpers.add_map(%{
    name: "Wastes",
    description: "",
    image_name: "wastes",
    coords_type: "circle",
    coords: "150,361,22"
  })

{:ok, %{id: fields_id}} =
  MapHelpers.add_map(%{
    name: "Fields",
    description: "",
    image_name: "fields",
    coords_type: "circle",
    coords: "582,161,23"
  })

{:ok, %{id: old_eel_id}} =
  MapHelpers.add_map(%{
    name: "Old Eel",
    description: "",
    image_name: "old_eel",
    coords_type: "circle",
    coords: "305,170,15"
  })

{:ok, %{id: university_id}} =
  MapHelpers.add_map(%{
    name: "Università",
    description: "",
    image_name: "university",
    coords_type: "poly",
    coords: "193,89,190,101,186,108,180,116,185,129,199,127,208,120,208,111,211,102,205,93"
  })

{:ok, %{id: french_hill_id}} =
  MapHelpers.add_map(%{
    name: "French Hill",
    description: "",
    image_name: "french_hill",
    coords_type: "poly",
    coords:
      "225,225,219,235,220,248,217,254,223,264,234,266,245,259,247,250,239,243,237,235,234,229"
  })

{:ok, %{id: east_end_id}} =
  MapHelpers.add_map(%{
    name: "East End",
    description: "",
    image_name: "east_end",
    coords_type: "poly",
    coords:
      "417,235,406,242,409,249,412,256,407,260,415,268,427,271,435,265,438,256,430,248,426,241,424,235"
  })

MapHelpers.add_map(%{
  parent_id: east_end_id,
  name: "Auld Chapel",
  coords_type: "poly",
  coords: "375,264,426,228,478,217,510,218,584,262,562,314,479,353,435,307"
})

MapHelpers.add_map(%{
  parent_id: east_end_id,
  name: "Abandoned Hotel",
  coords_type: "poly",
  coords: "131,365,176,327,220,318,289,321,363,327,343,369,290,410,184,409,178,410,147,385"
})

MapHelpers.add_map(%{
  parent_id: fields_id,
  name: "Outer Fields",
  coords_type: "poly",
  coords: "237,221,315,198,344,198,334,236,328,253,312,259,221,260"
})

MapHelpers.add_map(%{
  parent_id: fields_id,
  name: "Refuge",
  coords_type: "poly",
  coords: "434,328,529,295,571,332,575,348,560,359,499,406,435,411,424,360"
})

MapHelpers.add_map(%{
  parent_id: french_hill_id,
  name: "City Market",
  coords_type: "poly",
  coords:
    "156,330,203,335,222,345,243,351,258,371,263,386,259,404,92,416,95,407,117,372,140,343,146,335"
})

MapHelpers.add_map(%{
  parent_id: french_hill_id,
  name: "Georgian Apartments",
  coords_type: "poly",
  coords:
    "362,203,464,207,505,216,516,227,582,241,596,252,592,272,397,327,375,284,339,265,336,234,338,217,346,209"
})

MapHelpers.add_map(%{
  parent_id: old_eel_id,
  name: "Old Eel Hotel",
  coords_type: "poly",
  coords:
    "357,190,382,190,457,194,444,234,422,269,404,282,305,278,278,233,280,218,288,208,301,203"
})

MapHelpers.add_map(%{
  parent_id: old_eel_id,
  name: "Overran Apartments",
  coords_type: "poly",
  coords:
    "521,478,532,482,592,507,605,519,596,539,417,571,398,530,378,489,380,474,387,464,395,459,409,455"
})

MapHelpers.add_map(%{
  parent_id: university_id,
  name: "Miskatonic University",
  coords_type: "poly",
  coords: "328,302,431,289,509,308,522,317,527,328,560,358,527,411,511,407,373,377,298,345"
})

MapHelpers.add_map(%{
  parent_id: wastes_id,
  name: "Port",
  coords_type: "poly",
  coords: "444,248,471,249,524,260,525,275,519,287,506,292,433,288,438,269"
})

MapHelpers.add_map(%{
  parent_id: wastes_id,
  name: "Paper Factory",
  coords_type: "poly",
  coords: "113,129,143,130,178,145,215,155,299,199,256,255,241,251,125,213,104,165"
})

MapHelpers.add_map(%{
  name: "Stanza Privata 1",
  private: true
})

MapHelpers.add_map(%{
  name: "Stanza Privata 2",
  private: true
})

MapHelpers.add_map(%{
  name: "Stanza Privata 3",
  private: true
})

OrganisationsHelpers.create_organisation(%{
  name: "St. Andrew Hostpital",
  description: """
  Ciò che rimane dell'Ospedale di Saint Andrew, alla periferia della French Hill, richiede a tutti i cittadini 
  e ai forestieri che sono capitati a Rochester in questo duro momento di crisi di unirsi e dare il proprio apporto
  per accudire i malati e dare dignità ai deceduti.
  Personale con conoscenze in medicina sono desiderabili, ma tutti i cittadini di buona volontà possono partecipare
  allo sforzo, e ricevere gratuitamente un addestramento base in medicina.
  """,
  image: "/images/organisations/st_andrew_hospital.webp",
  base_salary: 12,
  work_fatigue: 30
})

OrganisationsHelpers.create_organisation(%{
  name: "Rochester Police Department",
  description: """
  La Rochester che conoscevamo, la tranquilla cittadina sull'Atlantico, ospitale nei confronti dei turisti e solidale
  nei confronti dei suoi abitanti, non c'è più. La città sopravvissuta al cataclisma è un luogo desolato, pieno di 
  pericoli, ma la legge non può abdicare, ed a maggior ragione in questo momento di crisi, l'RPD chiama a raccolta 
  tutte le persone di buona volontà per aiutare la popolazione e mantenere l'ordine.
  Tutti i cittadini sono i benvenuti, e per coloro che non sono esperti nell'utilizzo di armi da fuoco o da mischia,
  sarà offerto un lavoro in logistica, o un addestramento gratuito al poligono di tiro.
  """,
  image: "/images/organisations/rochester_police_department.webp",
  base_salary: 15,
  work_fatigue: 40
})

OrganisationsHelpers.create_organisation(%{
  name: "Rochester Town Hall",
  description: """
  Quello che rimane del municipio di Rochester è il Town Hall, un austero palazzo in stile neo gotico che ospita ciò
  che rimane dell'amministrazione cittadina. Molte delle cariche pubbliche hanno perso la vita durante il Cataclisma
  o nelle immediate conseguenze, ma gli uffici sono riusciti a mantenersi organizzati e funzionanti. I lavori
  disponibili alla cittadinanza sono molteplici, di archivio, o direttamente relazionati con l'amministrazione dei 
  lavori nelle altre organizzazioni.
  """,
  image: "/images/organisations/rochester_town_hall.webp",
  base_salary: 10,
  work_fatigue: 25
})

{:ok, %{id: moonshine_id}} =
  ObjectsHelpers.create_object(%{
    name: "Moonshine",
    description: """
    Una bottiglia di Moonshine, un distillato artigianale di dubbia provenienza, realizzato dai bootleggers 
    come alternativa ad alcolici più costosi e di qualità. Ripristina un po' di sanità mentale, ed aiuta
    a perdere inibizioni, ma rende molto difficile concentrarsi. Il rischio di sviluppare una dipendenza
    da questa sostanza è moderato.
    """,
    image_url: "/images/objects/moonshine.webp",
    usages: 10,
    sanity: 10,
    health: -5
  })

ObjectsHelpers.create_effect(%{object_id: moonshine_id, skill_id: carisma_id, value: 1})
ObjectsHelpers.create_effect(%{object_id: moonshine_id, skill_id: mente_id, value: -1})

{:ok, %{id: morphine_id}} =
  ObjectsHelpers.create_object(%{
    name: "Morfina",
    description: """
    Una siringa di oppiaceo, morfina o un altro derivato. Estremamente rara, poiché la maggior parte delle 
    scorte sono state saccheggiate dalla criminalità organizzata. Nonostante sia conosciuto come un potente antidolorifico,
    il suo principale utilizzo è quello di alleviare la sofferenza mentale. Il rischio di svluppare una dipendenza
    dalla sostanza è molto alto.
    """,
    image_url: "/images/objects/morphine.webp",
    usages: 1,
    sanity: 20,
    health: 0
  })

ObjectsHelpers.create_effect(%{object_id: morphine_id, skill_id: mente_id, value: 1})
ObjectsHelpers.create_effect(%{object_id: morphine_id, skill_id: sensi_id, value: -1})

{:ok, %{id: whiskey_id}} =
  ObjectsHelpers.create_object(%{
    name: "Whiskey",
    description: """
    Una bottiglia di whiskey, un distillato decisamente di maggiore qualità rispetto al Moonshine distillato dai 
    bootleggers. Ripristina un po' di sanità mentale, ed aiuta a perdere inibizioni, ma rende molto difficile concentrarsi. 
    Il rischio di sviluppare una dipendenza da questa sostanza è moderato.
    """,
    image_url: "/images/objects/whiskey.webp",
    usages: 10,
    sanity: 10,
    health: 0
  })

ObjectsHelpers.create_effect(%{object_id: whiskey_id, skill_id: carisma_id, value: 1})
ObjectsHelpers.create_effect(%{object_id: whiskey_id, skill_id: mente_id, value: -1})

{:ok, %{id: _cigars_id}} =
  ObjectsHelpers.create_object(%{
    name: "Sigari",
    description: """
    Un pacchetto di sigari. Aiutano a recuperare un po' di sanità mentale, ma non sono particolarmente efficaci.
    """,
    image_url: "/images/objects/cigars.webp",
    usages: 10,
    sanity: 5,
    health: 0
  })

{:ok, %{id: _first_aid_id}} =
  ObjectsHelpers.create_object(%{
    name: "Kit di Pronto Soccorso",
    description: """
    Un kit di pronto soccorso, equipaggiato per tamponare e medicare ferite di varia natura.
    """,
    image_url: "/images/objects/first-aid-kit.webp",
    usages: 2,
    sanity: 0,
    health: 50
  })

RestActionsHelpers.create_rest_action(%{
  name: "Lettura di un libro",
  description: """
  Il personaggio si siede e legge un libro, recuperando un po' di sanità mentale.
  """,
  sanity: 10,
  health: 0,
  research_points: 0,
  slots: 2
})

RestActionsHelpers.create_rest_action(%{
  name: "Cura",
  description: """
  Il personaggio riesce a pulire le proprie ferite, se ne ha.
  """,
  sanity: 0,
  health: 10,
  research_points: 0,
  slots: 2
})

RestActionsHelpers.create_rest_action(%{
  name: "Studio",
  description: """
  Il personaggio impiega parte del suo tempo studiando. Lo studio può riguardare la fisica e le sue applicazioni,
  oppure elementi di occulto.
  """,
  sanity: 0,
  health: 0,
  research_points: 3,
  slots: 3
})

{:ok, %{id: brawl_type_id}} =
  WeaponsHelpers.create_weapon_type(%{
    name: "Mani nude",
    description: """
    Rappresenta l'abilità del corpo a corpo, della lotta e delle arti marziali.
    """
  })

{:ok, %{id: melee_type_id}} =
  WeaponsHelpers.create_weapon_type(%{
    name: "Arma bianche",
    description: """
    Rappresenta tutte le armi bianche, dalle lame elaborate ai più semplici bastoni o coltelli.
    """
  })

{:ok, %{id: firearms_type_id}} =
  WeaponsHelpers.create_weapon_type(%{
    name: "Armi da fuoco",
    description: """
    Rappresenta le armi da fuoco, dal fucile alla semplice pistola.
    """
  })

{:ok, %{id: throw_type_id}} =
  WeaponsHelpers.create_weapon_type(%{
    name: "Armi da lancio",
    description: """
    Rappresenta le armi da lancio, dai sassi alle granate.
    """
  })

CombatActionsHelpers.create_combat_action(%{
  name: "Presa",
  description: """
  Una presa, blocca l'avverario ma non produce danni alla salute.
  """,
  minimum_skill_value: 1,
  does_damage: false,
  weapon_type_id: brawl_type_id,
  attack_attribute_id: fisico_id,
  attack_skill_id: brawl_id,
  defence_attribute_id: fisico_id,
  defence_skill_id: brawl_id
})

WeaponsHelpers.create_weapon(%{
  name: "Revolver",
  description: """
  Un semplice revolver a sei colpi.
  """,
  image_url: "/images/weapons/revolver.webp",
  cost: 100,
  damage_bonus: 2,
  required_skill_min_value: 1,
  required_skill_id: firearms_id
})

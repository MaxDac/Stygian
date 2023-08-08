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
alias Stygian.Skills
alias Stygian.Maps

defmodule AccountsHelpers do
  def create_user?(attrs = %{username: username}) do
    case Accounts.get_user_by_username(username) do
      nil ->
        with {:ok, user} <- Accounts.register_user(attrs) do
          Accounts.update_user(user, attrs)
        end

      user ->
        Accounts.update_user(user, attrs)
    end
  end
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
      {:ok, skill} -> true
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

# Creating admin users
AccountsHelpers.create_user?(%{
  email: "postmaster@stygian.eu",
  username: "ghostLayer",
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
AccountsHelpers.create_user?(%{
  email: "user@stygian.eu",
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

{:ok, %{id: non_creational_skill_id}} =
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

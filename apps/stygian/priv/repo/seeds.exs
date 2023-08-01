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

# Creating admin users
Accounts.register_user(%{
  email: "massimiliano.dacunzo@hotmail.com",
  username: "ghostLayer",
  password: "password1234"
})

Accounts.register_user(%{
  email: "gabriele.dacunzo@outlook.com",
  username: "Gahadiel",
  password: "password1234"
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

defmodule StygianWeb.GuideLive.GuideGameplayLive do
  @moduledoc """
  The gameplay guide for the land.
  """

  use StygianWeb, :html

  def gameplay(assigns) do
    ~H"""
    <.guide_p>
      L'ultima sezione della guida è anche quella più importante per strutturare il personaggio. Qui i giocatori potranno capire quali sono le direttive di gioco principali, quali sono le possibilità di gioco, quali le possibilità offerte dall'ambientazione.
    </.guide_p>

    <.guide_h1>Obiettivi</.guide_h1>

    <.guide_p>
      La prima cosa da tenere a mente nella creazione e strutturazione del personaggio è che, dopo il <b>Cataclisma</b>, il primo obiettivo di qualsiasi personaggio non è quello di sopravvivere, ma di avere una motivazione per farlo. Bisogna considerare che molti hanno voluto intraprendere la via più rapida per uscire da Rochester, tramite il suicidio, dopo aver capito che non c'era una facile via d'uscita fuori dall'incubo di follia in cui tutti erano precipitati. La prima domanda che un giocatore si dovrà porre quindi è cosa lo fa tirare avanti: scoprire una via d'uscita dalla cittadina per poter tornare alla propria vita? Approfittare dell'assenza di una struttura di potere statale superiore per accumulare potere in questo contesto ridotto? Oppure il motivo per cui il personaggio vuole sopravvivere a tutti i costi è l'investigazione dei fenomeni paranormali che accadono normalmente nel perimetro della cittadina, e fuori?
    </.guide_p>

    <.guide_p>
      I motivi per sopravvivere possono ovviamente cambiare nel tempo, ma è utile avere chiaro fin dal principio l'obiettivo del personaggio. Ciò non toglie che il personaggio non possa costantemente confrontarsi con la volontà di porre fine alla propria vita, ma questo fa parte della psicologia del personaggio, non dei suoi obiettivi. Alcuni degli obiettivi possono mettervi in diretta concorrenza con altri personaggi, o con personaggi non giocanti. Pensate ad esempio ad un personaggio con l'ambizione di scalare la struttura di potere di una delle organizzazioni criminali nella cittadina, questo potrebbe metterlo in diretta concorrenza con un altro personaggio con la stessa ambizione, o con un altro il cui proposito è quello di conservare il seppur volatile ordine costituito, oltre ovviamente ai vari personaggi non giocanti attualmente in quelle posizioni di potere: questo non solo è perfettamente lecito, ma addirittura incoraggiato.
    </.guide_p>

    <.guide_h1>Presenza del narratore</.guide_h1>

    <.guide_p>
      Per quanto alcune giocate, o responsi, debbano essere necessariamente gestiti da un Narratore, ciò non toglie che altri scambi possano essere gestiti direttamente in giocate tra personaggi. Scambi di valuta (<i>Cigs</i>), di oggetti, o anche di conoscenza, sottoforma di addestramento in Abilità non di creazione o schemi di implementazione di oggetti, possono essere scambiati liberamente tra personaggi (Todo - scambi di valuta, oggetti o
      <i>blueprints</i>
      saranno implementati prossimamente).
    </.guide_p>

    <.guide_h1>Zone franche</.guide_h1>

    <.guide_p>
      Personaggi interessati nell'indagine dei fenomeni paranormali identificati in alcune delle zone della mappa, poi, potranno mettersi d'accordo direttamente nelle locazioni della mappa considerate "<b>neutrali</b>": l'<b>Old Eel Hotel</b> e il <b>Negozio di Moshe</b>, quest'ultimo situato nei
      <b>Georgian Apartments</b>
      in <b>French Hill</b>. Queste due locazioni sono da considerarsi, come detto, <b>neutrali</b>, ovvero in queste locazioni le organizzazioni criminali osservano una tregua armata: in queste locazioni, i nuovi personaggi, o anche personaggi che vogliono incontrarsi per poter dialogare senza il pericolo di subire violenze, possono giocare liberamente. I giocatori potranno anche utilizzare le locazioni private, che saranno a meno che il Narratore non decida diversamente da intendersi come tavoli riservati o stanze nell'<b>Old Eel Hotel</b>, per poter scambiare informazioni segrete. Le stanze private sono raggiungibili a partire dalla mappa principale nella locazione
      <b>The Unknown</b>
    </.guide_p>

    <.guide_h1>Spazio di gioco</.guide_h1>

    <.guide_p>
      Lo spazio di gioco attualmente a disposizione è la cittadina di Rochester, una cittadina che, prima del <b>Cataclisma</b>, arrivava a contare al massimo su cinquantamila cittadini, principalmente a causa del vicino parco nazionale e del polo universitario. Considerate quindi che il tempo di percorrenza tra una regione della mappa e l'altra è al massimo di mezz'ora. Le regioni al di fuori delle mura cittadine sono da considerarsi estremamente pericolose, adatte solo all'esplorazione organizzata con apparecchiatura adeguata. Questo non vuol dire che le locazioni all'interno delle mura siano da considerarsi sicure, alcune di queste sono anzi non bonificate, e pericolose quasi quanto le zone esterne (Todo - la pericolosità di ogni zona sarà chiaramente indicata nella sua descrizione).
    </.guide_p>

    <.guide_h1>Ordine costituito</.guide_h1>

    <.guide_p>
      Una delle cose da tenere a mente in Stygian è che l'ordine costituito non è permanente, e che i personaggi che gestiscono il poco potere disponibile all'interno dei confini della città sono esseri umani, con le loro capacità, risorse e personale fedele, ma pur sempre umani. Possono essere colti di sorpresa, uccisi, ingannati e sfruttati dai personaggi, e questo tipo di azioni sono da considerarsi non solo permesse, ma <b>incentivate</b>. Tutto è possibile nelle relazioni tra personaggi, siano essi giocanti o non giocanti, l'unica cosa che non è permessa a Rochester è uscire.
    </.guide_p>
    """
  end
end

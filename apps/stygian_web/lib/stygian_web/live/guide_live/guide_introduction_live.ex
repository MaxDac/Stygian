defmodule StygianWeb.GuideLive.GuideIntroductionLive do
  @moduledoc false

  use StygianWeb, :html

  @doc false
  def introduction(assigns) do
    ~H"""
    <.guide_p class="font-typewriter text-sm">
      Ricordi poco della vita precedente. Non riesci nemmeno a ricordare bene da quanto tempo sei in questa prigione di oscurit&agrave;, questa dannata citt&agrave; dimenticata da tutto e da tutti, isolata dal resto dell'universo. A volte ti sembra troppo, altre volte, ebbro dell'alcolico di bassa qualit&agrave; che sei costretto ad ingurgitare, riesci quasi ad alleviare il peso della tua esistenza pensando che, forse, si tratta solo di un brutto sogno, che tornerai a casa...
    </.guide_p>

    <.guide_p class="font-typewriter text-sm">
      Poi per&ograve; l'effetto dell'alcol svanisce, e tutte le conseguenze del <i>moonshine</i> scampato al proibizionismo in qualche alcova o tunnel sotterraneo dell'<i>Old Eel</i> riaffiorano. Il sapore di vomito che la mente evoca automaticamente ti fa venire voglia di farla finita, di barattare qualcuna delle tue sigarette per una pallottola, premere il grilletto; lo scoppio ispirato dal grilletto che inonda la stanza, riesci quasi ad immaginarlo, e riesce a regalarti una forma distorta di sollievo...
    </.guide_p>

    <.guide_p class="font-typewriter text-sm">
      Poi per&ograve; decidi di alzarti. Come ogni giorno, una spinta invisibile ti sottrae ai tuoi pensieri nichilisti, e ti fa risorgere dal loculo oscuro maledetto da un costante tanfo di piscio. Sei ancora nella soffitta dell'Old Eel, un antico hotel, prima del giorno in cui tutto &egrave; cambiato.
    </.guide_p>

    <.guide_p class="font-typewriter text-sm">
      Quel giorno... Ti sembra di ricordare che fu un cataclisma, una giostra di follia, panico e terrore che, nel giro di un'ora, cambi&ograve; la tua esistenza e quella delle povere anime con cui sei tuo malgrado costretto a condividere questa citt&agrave;, ma pi&ugrave; passa il tempo, pi&ugrave; i contorni di quella tragedia si fanno confusi, distorti, a volte ti sembra quasi che il cambiamento sia stato cos&igrave; discreto che non te ne sei nemmeno reso conto. Sai che c'&egrave; stato un prima e un dopo, ma sembra quasi, a volte, che le due esistenze siano convissute parallelamente per tutta la tua vita...
    </.guide_p>

    <.guide_p class="font-typewriter text-sm">
      Il voc&iacute;o delle persone che percepisci man mano che scendi i ripidi scalini di legno dell'hotel ti strappano dalla confusione e dall'oblio. Un altro giorno. Un altro giorno per capire cosa sia successo...
    </.guide_p>

    <hr class="brand" />

    <.guide_p>
      Stygian &egrave; un gioco di ruolo via chat liberamente ispirato al videogioco di ruolo "Stygian: Reign of the Old Ones" ambientato nella cittadina statunitense di Arkham, nello stato del Maine, molto vicino al confine col Canada, affacciata sull'Oceano Atlantico, durante il proibizionismo, attorno al 1930. In realt&agrave; l'anno esatto &egrave; impossibile da determinare, poich&eacute; la citt&agrave;, da un anno circa secondo alcuni, almeno due per altri, &egrave; stata sottratta dal normale scorrere del tempo, dello spazio, del meteo, inghiottita da una notte eterna, afflitta da un orribile tanfo di urina, marcio, cosparsa di sangue e ruggine.
    </.guide_p>

    <.guide_p>
      &Egrave; qui che il tuo personaggio si muover&agrave; ed interagir&agrave; con altri personaggi, capitati qui per caso, magari attirati dal vicino parco nazionale, o dal viale sul mare, una volta famoso per le sue case colorate e il buon cibo; alcuni giurano di essere stati richiamati addirittura dall'altra parte degli Stati Uniti, dal vicino Canada o dal Messico, o addirittura dal Vecchio Continente, da una forza oscura, da sogni, o sussurri da una regione nascosta e recondita della loro mente. Ad ogni modo, ora tutti sono intrappolati nella citt&agrave;, ogni tentativo di sfuggire attraverso strade o boschi &egrave; inevitabilmente destinata al fallimento... o peggio. La forza soprannaturale che tiene prigionieri i nuovi abitanti della cittadina, comunque, non impedisce l'arrivo di altri sfortunati, che, percorrendo la strada principale, sprofondano loro malgrado nell'incubo, confrontati con l'impossibilit&agrave; di andarsene.
    </.guide_p>

    <.guide_p>
      Come se la notte eterna che avvolge la citt&agrave; o la scarsit&agrave; di provviste non fosse abbastanza, altri pericoli minacciano la vita dei cittadini di Arkham: da una parte, avvistamenti di umanoidi contorti, orribilmente glabri e mutati, che si nutrono di qualsiasi cosa gli capiti a tiro, umani compresi, dall'altra la follia e la brutalit&agrave; umana che hanno preso il sopravvento approfittando dell'assenza della legge.
    </.guide_p>

    <.guide_p>
      La vita della cittadina, stretta all'interno delle vecchie mura coloniali costruite dai francesi rafforzate con costruzioni di fortuna, &egrave; gestita dalla <i>Mob</i>, la mafia statunitense, che si &egrave; liberata dalla presenza della scarsa e gi&agrave; corrotta forza di polizia quasi subito dopo il <b>Cataclisma</b>, il giorno in cui tutto &egrave; cambiato, ed ha di fatto assunto il controllo. L'unica cosa che impedisce uno stato di costante minaccia e sopruso alle persone comuni &egrave; la presenza di due organizzazioni criminali differenti: una, composta da elementi di origine italiana, e l'altra, composta per la maggior parte di immigrati di origine irlandese; la precaria situazione creatasi, da "guerra fredda" tra le due organizzazioni, fa s&igrave; che entrambe tendano a non rovinare i rapporti con le persone, cercando di garantirsene l'alleanza, o l'obbedienza.
    </.guide_p>

    <.guide_p>
      L'economia basata sul dollaro &egrave; completamente stata sostituita dall'unica valuta replicabile e veramente di valore in una situazione di costante pericolo ed isolamento dal resto del mondo: le <i>cigs</i>, le sigarette. Le sigarette regolano gli scambi commerciali, per le sigarette si arriva ad uccidere. Le sigarette sono anche la forma di pagamento delle organizzazioni che sono sorte dopo il <b>Cataclisma</b>.
    </.guide_p>

    <.guide_p>
      &Egrave; in questa situazione che il tuo personaggio deve muoversi. Dovr&agrave; ottenere una posizione all'interno della cittadina per sopravvivere, potr&agrave; studiare nuove tecnologie, nuove forme di occulto, o sviluppare nuove sostanze per guarire, stimolare o avvelenare altri personaggi, o cercare una strada che conduca fuori dalla citt&agrave; che non si affacci sul fondo della canna di una pistola.
    </.guide_p>
    """
  end
end

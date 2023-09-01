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
      Stygian &egrave; un gioco di ruolo via chat, ambientato nella cittadina statunitense (to be continued)
    </.guide_p>
    """
  end
end

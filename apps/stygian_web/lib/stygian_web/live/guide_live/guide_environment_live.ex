defmodule StygianWeb.GuideLive.GuideEnvironmentLive do
  @moduledoc false

  use StygianWeb, :html

  def environment(assigns) do
    ~H"""
    <.guide_p>
      Come anticipato nell'<.link patch={~p"/guide/introduction"} class="font-bold underline underline-offset-8">introduzione</.link>, il gioco è ambientato nella cittadina di Arkham, una cittadina del Maine al confine con il Canada, che si affaccia sull'Oceano Atlantico, a cavallo tra il 1920 e il 1930. Un fenomeno del tutto soprannaturale e misterioso si è abbattuto sulla cittadina in un periodo imprecisato, uno o due anni prima. Il fenomeno viene chiamato dagli abitanti superstiti il <b>Cataclisma</b>.
    </.guide_p>

    <.guide_p>
      I racconti sono confusi e frammentati, anche da chi ha abitato nella cittadina per tutta la sua vita, ed anche oggi, a distanza di così tanto tempo dall'avvenimento, nessuno è riuscito a mettere ordine tra le varie versioni, o semplicemente nessuno ne ha avuto il tempo, o la voglia. È opinione comune che, in un giorno perfettamente normale, coperto dalla nebbia mattutina caratteristica del luogo, un terremoto ha sconvolto la città, un tremore così forte che ha creato una voragine, inghiottendo la parte occidentale della città. Curiosamente, pochi dei palazzi nella parte orientale sono stati danneggiati, ed anche quelli più interessati non è apparsa più di qualche crepa nei loro muri. Gli abitanti della città, che nei giorni precedenti giurano di aver notato un insolito afflusso di turisti nella zona in quella che era considerata bassa stagione per visitare il vicino parco nazionale, e i turisti non hanno avuto nemmeno il tempo di riprendersi dallo shock, che la leggera nebbiolina che aveva dato fino a poco prima alla cittadina una suggestiva aura di mistero, onirica, si addensò sempre di più, così tanto da coprire completamente la luce del sole. Dopo appena una decina di minuti, la nebbia si diradò, lasciando però la città avvolta in una sconfortante notte senza stelle.
    </.guide_p>

    <.guide_p>
      Se fin qui i racconti coincidono per lo più, dal Cataclisma in avanti nessuno è in grado di fornire precisione nei suoi resoconti. La diffidenza diffusa nel prossimo sembra essere stato uno dei prodotti della notte senza fine, e falsificano la maggior parte dei racconti, ma è chiaro che il soprannaturale non si è limitato ai fenomeni metereologici: alcuni sono sicuri di aver visto bestie glabre e giallastre simili agli uomini solo lontanamente cibarsi di vittime umane ancora vive, altri giurano di aver visto cani scarnificati accompagnare strane personalità coperte da drappi e cappucci rituali, altri ancora affermano balbettando di aver percepito figure gigantesche levarsi all'orizzonte, appena distinguibili dall'oscurità opprimente.
    </.guide_p>

    <.guide_p>
      Nel giro di pochi giorni, ogni parvenza di governo centrale è caduta vittima dei gruppi criminali che agivano nell'ombra prima del <b>Cataclisma</b>: i pochi poliziotti che non erano nel libro paga della <i>Mob</i> sono stati sbrigativamente uccisi, gli altri sono direttamente entrati a far parte delle organizzazioni criminali che commerciavano in alcolici al confine. Dopo un periodo di violenza senza controllo, la situazione si è normalizzata: una volta capito che la fine del mondo sarebbe durata più di qualche giorno, una strana forma di ragione di stato ha fatto in modo che le due organizzazioni criminali nella città, una composta da elementi prevalentemente di origine italiana capeggiata da <b>Johnny Fontana</b>, l'altra di stampo irlandese guidata da <b>Eogham O'Flaherty</b>, raggiungessero un accordo di non belligeranza.
    </.guide_p>

    <.guide_p>
      L'instabile tregua è l'unico argine alla completa autodistruzione: i due gruppi hanno concesso la creazione di altre organizzazioni "disarmate", ed hanno di comune accordo deciso di usare le sigarette, le <i>Cigs</i>, come valuta per regolare le transazioni. Le armi sarebbero state permesse solo da componenti dei gruppi malavitosi, le altre organizzazioni avrebbero dovuto gestire lavori più servili, come la costruzione di mura, o la gestione dei rifugi e dei negozi per il riciclaggio delle scorte disponibili.
    </.guide_p>

    <.h1>Organizzazioni</.h1>

    <.guide_p>
      Un personaggio potrà far parte di una delle seguenti organizzazioni. Far parte di una organizzazione garantirà un ingresso di <i>Cigs</i> giornaliero.
    </.guide_p>

    <.guide_p>
      (Todo)
    </.guide_p>
    """
  end
end

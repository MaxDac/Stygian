defmodule StygianWeb.GuideLive.GuideEnvironmentLive do
  @moduledoc false

  use StygianWeb, :html

  def environment(assigns) do
    ~H"""
    <.guide_p>
      Come anticipato nell'<.link
        patch={~p"/guide/introduction"}
        class="font-bold underline underline-offset-8"
      >introduzione</.link>, il gioco è ambientato nella cittadina di Rochester, una cittadina del Maine al confine con il Canada, che si affaccia sull'Oceano Atlantico, a cavallo tra il 1920 e il 1930. Un fenomeno del tutto soprannaturale e misterioso si è abbattuto sulla cittadina in un periodo imprecisato, uno o due anni prima. Il fenomeno viene chiamato dagli abitanti superstiti il <b>Cataclisma</b>.
    </.guide_p>

    <.guide_p>
      I racconti sono confusi e frammentati, anche da chi ha abitato nella cittadina per tutta la sua vita, ed anche oggi, a distanza di così tanto tempo dall'avvenimento, nessuno è riuscito a mettere ordine tra le varie versioni, o semplicemente nessuno ne ha avuto il tempo, o la voglia. È opinione comune che, in un giorno perfettamente normale, coperto dalla nebbia mattutina caratteristica del luogo, un terremoto ha sconvolto la città, un tremore così forte che ha creato una voragine, inghiottendone la parte occidentale. Curiosamente, pochi dei palazzi nella parte orientale sono stati danneggiati, ed anche quelli più interessati non è apparsa più di qualche crepa nei muri. Gli abitanti, che nei giorni precedenti giurano di aver notato un insolito afflusso di turisti nella zona in quella che era considerata bassa stagione per visitare il vicino parco nazionale, e i turisti non hanno avuto nemmeno il tempo di riprendersi dallo shock, che la leggera nebbiolina che aveva dato fino a poco prima alla cittadina una suggestiva aura di mistero, onirica, si addensò sempre di più, così tanto da coprire completamente la luce del sole. Dopo appena una decina di minuti, la nebbia si diradò, lasciando però la città avvolta in una sconfortante notte senza stelle.
    </.guide_p>

    <.guide_p>
      Se fin qui i racconti coincidono per lo più, dal Cataclisma in avanti nessuno è in grado di fornire precisione nei suoi resoconti. La diffidenza diffusa nel prossimo sembra essere stato uno dei prodotti della notte senza fine, e falsificano la maggior parte dei racconti, ma è chiaro che il soprannaturale non si è limitato ai fenomeni metereologici: alcuni sono sicuri di aver visto bestie glabre e giallastre simili solo lontanamente a uomini cibarsi di vittime umane ancora vive, altri giurano di aver visto cani scarnificati accompagnare strane personalità coperte da drappi e cappucci rituali, altri ancora affermano balbettando di aver percepito figure gigantesche levarsi all'orizzonte, appena distinguibili dall'oscurità opprimente.
    </.guide_p>

    <.guide_p>
      I giorni immediatamente successivi al fenomeno hanno visto un altissimo numero di omicidi, furti e saccheggi, approfittando del momentaneo stato di confusione e disorganizzazione delle forze dell'ordine. Anche quando, dopo due settimane, il <b>Rochester Police Department</b> riuscì a riprendere il controllo della situazione all'interno della città, circoscrivendo una zona di controllo dove garantire una relativa sicurezza, molti abitanti si suicidarono, non vedendo nessuna speranza nella notte eterna in cui Rochester era piombata.
    </.guide_p>

    <.guide_p>
      Messa in sicurezza la zona della cittadina, la polizia è stata l'unica forza in grado di garantire un minimo di ordine: ha consentito l'organizzazione del <b>Saint Andrew Hospital</b>, ed ha conentito anche la rimessa in funzione del <b>Town Hall</b> bonificando l'edificio da entità aliene. Questi successi non sarebbero stati possibili senza la gestione capace, carismatica ed autoritaria di <b>Jack Morgan</b>, un ex investigatore che è riuscito a serrare i ranghi dei suoi colleghi, un burbero e sbrigativo figlio di emigrati irlandesi; la relativa sicurezza e ordine è però pagata dai residenti loro malgrado di Rochester con una sostanziale dittatura poliziesca: i poliziotti, molto spesso, si arrogano diritti ben oltre ciò che la loro posizione normalmente gli garantirebbe, includendo molestie di vario genere, altrettanto spesso coperte dai colleghi. 
    </.guide_p>

    <.guide_h1>Organizzazioni</.guide_h1>

    <.guide_p>
      Un personaggio potrà far parte di una delle seguenti organizzazioni. Far parte di una organizzazione garantirà un ingresso di
      <i>Cigs</i>
      giornaliero.
    </.guide_p>

    <.guide_h2>Rochester Police Department</.guide_h2>

    <.guide_p>
      La Rochester che conoscevamo, la tranquilla cittadina sull'Atlantico, ospitale nei confronti dei turisti e solidale nei confronti dei suoi abitanti, non c'è più. La città sopravvissuta al cataclisma è un luogo desolato, pieno di pericoli, ma la legge non può abdicare, ed a maggior ragione in questo momento di crisi, l'RPD chiama a raccolta tutte le persone di buona volontà per aiutare la popolazione e mantenere l'ordine. Tutti i cittadini sono i benvenuti, e per coloro che non sono esperti nell'utilizzo di armi da fuoco o da mischia, sarà offerto un lavoro in logistica, o un addestramento gratuito al poligono di tiro.
    </.guide_p>

    <.guide_h2>St. Andrew's Hospital</.guide_h2>

    <.guide_p>
      Ciò che rimane dell'Ospedale di Saint Andrew, alla periferia della French Hill, richiede a tutti i cittadini e ai forestieri che sono capitati a Rochester in questo duro momento di crisi di unirsi e dare il proprio apporto per accudire i malati e dare dignità ai deceduti. Personale con conoscenze in medicina sono desiderabili, ma tutti i cittadini di buona volontà possono partecipare allo sforzo, e ricevere gratuitamente un addestramento base in medicina.
    </.guide_p>

    <.guide_h2>Rochester Town Hall</.guide_h2>

    <.guide_p>
      Quello che rimane del municipio di Rochester è il Town Hall, un austero palazzo in stile neo gotico che ospita ciò che rimane dell'amministrazione cittadina. Molte delle cariche pubbliche hanno perso la vita durante il Cataclisma o nelle immediate conseguenze, ma gli uffici sono riusciti a mantenersi organizzati e funzionanti. I lavori disponibili alla cittadinanza sono molteplici, di archivio, o direttamente relazionati con l'amministrazione dei lavori nelle altre organizzazioni.
    </.guide_p>

    <.guide_h1>Luoghi di ritrovo</.guide_h1>

    <.guide_p>
      La parte orientale superstite della cittadina di Rochester può nascondere pericoli in qualsiasi vicolo oscuro in cui ci si imbatte, o in qualsiasi casa abbandonata a cui si accede alla ricerca di provviste. Nella Notte Eterna, pochi sono i luoghi in cui ci si può sentire veramente al sicuro. Di seguito, vengono proposti alcuni dei luoghi di ritrovo, in cui i personaggi possono interagire liberamente tra di loro, scambiare opinioni, commerciare o anche sfidarsi.
      <ul>
        <li class="font-normal text-md">
          <b>Old Eel Hotel</b>: l'Old Eel Hotel è uno dei luoghi franchi a Rochester per tutte le organizzazioni. Nell'hotel, che prima del Cataclisma era una delle poche strutture ad offrire servizi ai forestieri, seppur non di troppa qualità, tutti i personaggi possono riunirsi nella grande hall e affittare delle camere per poter riposare con una certa sicurezza. Il barista è un immigrato di seconda generazione italiano, <b>Frankie Masiello</b>, dall'umorismo caustico e dal carattere non troppo accomodante. I nuovi personaggi possono considerare di avere conoscenza del luogo, e di sapere che al suo interno possono sentirsi al sicuro. Le stanze segrete che si possono prenotare sono proprio nell'Old Eel Hotel.
        </li>

        <li class="font-normal text-md">
          <b>Moshe's shop</b>: Moshe è un ebreo Ashkenazi di origine polacca, che prima del Cataclisma gestiva un negozio di antiquariato. Dopo il Cataclisma, Moshe ha deciso di aprire un negozio, acquistando oggetti antichi in cambio di provviste o di utensili. Moshe non è un personaggio molto amichevole, a meno che non abbiate a disposizione delle chiavi di natura ignota, per le quali sembra nutrire un desiderio morboso. Il negozio di Moshe può essere considerato un luogo di ritrovo per tutti i personaggi, e gode di una relativa indipendenza dal ferreo controllo del <b>RPD</b>, che temono più che altro il malocchio che ha più volte minacciato di poter lanciare; per qualche ragione, nessuno dei fenomeni paranormali che tutti notano nella cittadina ha mai avuto luogo nel negozio di Moshe, il che ha dato corpo alle credenze degli abitanti sulle conoscenze soprannaturali del mercante. Il negozio di Moshe si trova nella <i>French Hill</i>, nei <i>Georgian Apartments</i>.
        </li>

        <li class="font-normal text-md">
          <b>Stanze private</b>: le stanze private possono essere considerate come stanze private all'Old Eel Hotel. Usufruirne non costa nulla, ma non possono essere usate per riposare, solo per tenere delle riunioni a porte chiuse. Sono accessibili dalla mappa centrale nella locazione "The Unknown".
        </li>
      </ul>
    </.guide_p>
    """
  end
end

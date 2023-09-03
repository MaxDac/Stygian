defmodule StygianWeb.GuideLive.GuideCreationLive do
  @moduledoc false

  use StygianWeb, :html

  def creation(assigns) do
    ~H"""
    <.guide_p>
      Per poter partecipare al gioco, si dovrà registrare un utente. La registrazione comporta l’immediato accesso alla parte interna del sito, e si potrà visionare il gioco nelle chat pubbliche, ma per poter partecipare attivamente, si dovrà creare un personaggio. La creazione del personaggio è subordinata alla verifica dell’utente, che avverrà una volta attivato il link ricevuto per posta elettronica: se non riceverete la mail in fase di registrazione, controllate la cartella di posta indesiderata, altrimenti contattate un gestore su <.link
        href="https://discord.gg/HYuZ3rKdsn"
        class="font-bold underline underline-offset-8"
      >Discord</.link>.
    </.guide_p>

    <.guide_p>
      La fase successiva è la creazione del personaggio: alla creazione si accede attraverso il menu laterale sinistro. La prima fase richiede di specificare il nome del personaggio, il link all’immagine dell’avatar, l’età del personaggio e il suo “peccato”, o segreto.
    </.guide_p>

    <.guide_p>
      L’età del personaggio non ha solo un significato interpretativo, ma determina anche la distribuzione delle caratteristiche del personaggio nella fase di creazione successiva. Si hanno a disposizione tre opzioni:
      <ul>
        <li class="font-normal text-md">
          <b>Giovane</b>: il personaggio ha meno di 35 anni, ma più di 18. Ha la possibilità di assegnare un punto supplementare agli attributi, ma potrà assegnare 4 punti di abilità in meno rispetto al normale.
        </li>

        <li class="font-normal text-md">
          <b>Adulto</b>: il personaggio ha meno di 50 anni. La distribuzione dei punti da assegnare agli attributi ed alle abilità in questo caso è normale.
        </li>

        <li class="font-normal text-md">
          <b>Anziano</b>: il personaggio ha più di 50 anni. Si avrà diritto a quattro punti in più da distribuire sulle abilità del personaggio, ma avrà un punto in meno da assegnare agli attributi. Un Anziano avrà una maggiore resistenza alla perdita di Sanità mentale.
        </li>
      </ul>
    </.guide_p>

    <.guide_p>
      Il peccato, o segreto, del personaggio, è invece un accadimento di cui il personaggio è stato protagonista, e che vuole tenere nascosto a qualsiasi costo. Il peccato è necessariamente qualcosa che il personaggio ha fatto, o non ha fatto, e potrebbe essere stato qualcosa di così traumatico che il personaggio potrebbe averlo rimosso, non ricordandosene. Tutti i personaggi dovranno avere un peccato, o segreto, e per disegno della chat non apparirà in nessuna pagina del sito, nemmeno nella scheda del personaggio.
    </.guide_p>

    <.guide_p>
      La seconda parte della creazione è del tutto automatica, e riguarda la distribuzione dei punti Attributo ed Abilità. La prima colonna è quella degli Attributi, mentre la seconda è quella delle Abilità: i primi sono caratteristiche intrinseche del personaggio, capacità mentali o fisiche che costituiscono la potenzialità e la propensione naturale del personaggio all’esecuzione di un’azione, mentre le Abilità riguardano l’addestramento del personaggio, la tecnica che ha imparato, o le conoscenze che ha acquisito.
    </.guide_p>

    <.guide_p>
      Gli Attributi si dividono in:
      <ul>
        <li class="font-normal text-md">
          <b>Fisico</b>: rappresenta le capacità fisiche del personaggio, la sua forza, resistenza.
        </li>
        <li class="font-normal text-md">
          <b>Agilità</b>: rappresenta la destrezza del personaggio, la sua padronanza dei movimenti, e la grazia che riesce ad impartire ad essi.
        </li>
        <li class="font-normal text-md">
          <b>Volontà</b>: è la forza mentale del personaggio, la sua capacità di affrontare decisioni, sforzi o di resistere alle dipendenze o alle apparizioni soprannaturali. Ha a che fare direttamente con la capacità di resistere alla perdita di Sanità mentale.
        </li>
        <li class="font-normal text-md">
          <b>Carisma</b>: il carisma rappresenta lo charme naturale del personaggio, la sua capacità di ammaliare o convincere gli altri, e la capacità di ispirare autorità.
        </li>
        <li class="font-normal text-md">
          <b>Mente</b>: è l’intelligenza e la saggezza del personaggio, la sua capacità di studio, di ragionamento e di interpretazione del mondo e dei fenomeni soprannaturali comuni a Rochester.
        </li>
        <li class="font-normal text-md">
          <b>Sensi</b>: questo attributo rappresenta la potenza e la chiarezza dei sensi di un personaggio. Un basso valore di questo Attributo potrebbe obbligare il personaggio all’utilizzo di oggetti per ovviare alla sua deficienza sensoriale, e la perdita di questi potrebbe comportare malus al tiro dei dadi.
        </li>
      </ul>
    </.guide_p>

    <.guide_p>
      Di seguito, una lista delle Abilità:
      <ul>
        <li class="font-normal text-md">
          <b>Armi da fuoco</b>: rappresenta la capacità del personaggio di utilizzare armi da fuoco, e di mantenere la calma durante un conflitto a fuoco.
        </li>
        <li class="font-normal text-md">
          <b>Armi bianche</b>: rappresenta la capacità del personaggio di utilizzare armi da mischia, e di mantenere la calma durante un conflitto corpo a corpo.
        </li>
        <li class="font-normal text-md">
          <b>Arti marziali</b>: rappresenta l'addestramento del personaggio nelle arti marziali, e di mantenere la calma durante un conflitto corpo a corpo.
        </li>
        <li class="font-normal text-md">
          <b>Atletica</b>: rappresenta la capacità del personaggio di compiere sforzi fisici, come saltare, arrampicarsi, nuotare, o correre.
        </li>
        <li class="font-normal text-md">
          <b>Dialettica</b>: rappresenta la capacità del personaggio di parlare in pubblico, convincere gli altri, e di mantenere la calma durante un conflitto verbale.
        </li>
        <li class="font-normal text-md">
          <b>Furtività</b>: rappresenta la capacità del personaggio di muoversi in silenzio, di nascondersi, e anche di passare inosservato anche in piena vista.
        </li>
        <li class="font-normal text-md">
          <b>Investigazione</b>: rappresenta la capacità del personaggio di percepire i dettagli di una situazione, di trovare indizi, e di interpretarli.
        </li>
        <li class="font-normal text-md">
          <b>Occulto</b>: rappresenta la conoscenza del personaggio del mondo soprannaturale, e delle sue leggi. È generalmente sconsigliato assegnare punti a questa Abilità in fase di creazione: un personaggio con questa Abilità in creazione dovrà motivarne l'acquisto nella biografia. I gestori potranno pretendere la redistribuzione dei punti investiti in questa Abilità se la spiegazione non risulterà convincente.
        </li>
        <li class="font-normal text-md">
          <b>Psicologia</b>: rappresenta la capacità del personaggio di comprendere le motivazioni e le intenzioni degli altri, e di interpretarne il comportamento.
        </li>
        <li class="font-normal text-md">
          <b>Scienza</b>: rappresenta la conoscenza del personaggio delle scienze naturali, come la biologia, la chimica, la fisica, e la medicina. Questa abilità aiuterà il personaggio a sviluppare e disegnare nuove tecnologie e dispositivi, che potranno essere creati per facilitargli la vita a Rochester.
        </li>
        <li class="font-normal text-md">
          <b>Sotterfugio</b>: rappresenta la capacità del personaggio di scassinare serrature, di agire di nascosto, o borseggiare. Può anche essere utilizzata per rendere credibile una menzogna, o per truffare altri personaggi.
        </li>
        <li class="font-normal text-md">
          <b>Sopravvivenza</b>: contempla l'addestramento del personaggio nel sopravvivere in ambienti ostili, e la sua capacità di sfruttare l'ambiente circostante a suo vantaggio e il riciclo di oggetti che per altri possono essere considerati come irrecuperabili.
        </li>
      </ul>
    </.guide_p>

    <.guide_p>
      Gli Attributi partono da un punteggio minimo di 4, mentre le Abilità partiranno da 0. È possibile scendere fino al punteggio di 3 per un Attributo, ma questo risulterà in una forte deficienza del personaggio in quell'Attributo, ed a discrezione del narratore, alcuni tiri di dado potranno subire dei malus aggiuntivi. Il punteggio massimo degli Attributi in creazione è 8, mentre il punteggio massimo per le Abilità dipenderà dall'età del personaggio: un giovane avrà un massimale di 3, un adulto di 4, mentre un personaggio anziano potrà arrivare a 5.
    </.guide_p>

    <.guide_h1>Completare la scheda</.guide_h1>

    <.guide_p>
      La creazione non costituisce la fase finale della creazione del personaggio, ma consente ai giocatori di definirne le caratteristiche necessarie ed automatiche; nella scheda del personaggio appena creato si potranno modificare la biografia, la descrizione, le note, e si potrà anche modificare la scheda personalizzata, accessibile dal tasto oscuro nella parte finale della pagina della scheda. La biografia è forse la parte più importante del personaggio: la possibilità di modificarla è stata posta dopo la creazione per dare la possibilità di modificarla e definirla con più calma; la biografia dovrà essere scritta avendo bene in mente l'ambientazione, il giocatore dovrà considerare che il suo personaggio dovrà essere credibile nel New England del 1930: a tal proposito, potrebbe essere di ispirazione la lettura delle novelle di H. P. Lovecraft (da dove abbastanza chiaramente questa ambientazione, e il gioco a cui si ispira, hanno tratto ispirazione). Consigliamo, inoltre, di leggere la sezione del <.link navigate={~p"/guide/gameplay"} class="font-bold underline underline-offset-8">gameplay</.link>.
    </.guide_p>

    <.guide_h1>Consigli per la scrittura della biografia</.guide_h1>

    <.guide_p>
      Come detto, nella scrittura della biografia del personaggio, bisogna immaginarne uno che abbia senso negli anni '20/'30 del secolo scorso. Inoltre, è importante considerare il fatto che <b>il personaggio non può essere autoctono della cittadina di Rochester</b>. Dovrete immaginare che, prima o dopo del Cataclisma, il personaggio ha percepito un richiamo, un impulso inconscio a recarsi a Rochester, a volte senza nemmeno sapere esattamente dove si stava recando. La mente, durante il richiamo, avrebbe trovato tutti i modi, senza uno sforzo cosciente, per giustificare l'improvviso impulso a recarsi in una località forse prima d'allora sconosciuta: che sia una improvvisa e morbosa curiosità per il parco nazionale, o la volontà di scaricare un po' di stress in una tranquilla località sull'oceano; O ancora, il personaggio può aver provato un forte impulso a consumare alcol, e per qualche motivo era sicuro di poterne trovare al confine con il Canada, proprio a Rochester. Qualsiasi sia la motivazione, non c'è nessuna restrizione sul tipo di personaggio che può arrivare, l'unica condizione è che abbia serbato un segreto, un peccato o comunque un'azione passata per cui prova profonda vergogna.
    </.guide_p>

    <.guide_p>
      Ogni giocatore può decidere che il proprio personaggio sia arrivato poco prima del Cataclisma, o dopo. Per qualche strana ragione, anche se ha assistito al Cataclisma in prima persona, i suoi ricordi di quei giorni sono obnubilati, sfocati, confusi. Potrebbe anche accadere che un giorno il personaggio abbia un ricordo, e il giorno dopo il ricordo può arrivare a giurare che il ricordo sia differente. I ricordi di ogni personaggio cominciano ad assumere nitidezza solo a partire da qualche giorno dopo il Cataclisma.
    </.guide_p>
    """
  end
end

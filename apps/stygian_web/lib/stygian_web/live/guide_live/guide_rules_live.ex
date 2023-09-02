defmodule StygianWeb.GuideLive.GuideRulesLive do
  @moduledoc false

  use StygianWeb, :html

  def rules(assigns) do
    ~H"""
    <.guide_p>
      <b>Stygian</b>
      è un gioco di ruolo a turni, strettamente via chat. Ogni giocatore avrà la possibilità di creare e gestire un solo personaggio alla volta, e potrà decidere di abbandonarlo, perdendo tutti i punti esperienza accumulati, oppure crearne uno nuovo quando il precedente personaggio morirà o scomparirà in azione - in questo conservando la totalità dei suoi punti esperienza.
    </.guide_p>

    <.guide_p>
      Un utente potrà iscriversi ed osservare il gioco in chat prima di creare il suo personaggio, ma la creazione del personaggio è subordinata alla conferma dell'utente. Una volta confermata la mail data in fase di creazione, si potrà procedere alla creazione del personaggio, il cui regolamento è espresso nella sezione relativa alla <.link
        patch={~p"/guide/creation"}
        class="font-bold underline underline-offset-8"
      >Creazione</.link>.
    </.guide_p>

    <.h1>Gioco in chat</.h1>

    <.guide_p>
      Il gioco avverrà principalmente in chat, e sarà diviso in turni. Ogni personaggio che vorrà prendere parte ad una giocata dovrà aspettare il proprio turno per scrivere la sua azione. L'interpretazione dell'azione
      <b>non dovrà lasciare spazio ai pensieri del personaggio</b>
      si dovrà cioè limitare solamente a ciò che del personaggio è visibile: ad esempio, non si potrà dire in un'azione: <i>Il personaggio pensa a quanto il suo interlocutore sia del tutto orripilante</i>, ma si potrà dire <i>Il personaggio non riesce a celare una espressione di profondo sdegno e orrore mentre discute col suo interlocutore</i>. Il giocatore, poi, avrà a disposizione per ogni azione del personaggio un numero massimo di <span class="font-bold underline">1200 caratteri</span>, ed un minimo di 200 caratteri.
    </.guide_p>

    <.guide_p>
      Si potranno usare i caratteri `**` per circondare una frase in grassetto. Ad esempio, "**circondando il parlato con due asterischi**" lo renderà grassetto. Anteponendo poi un `+` alla frase, si potrà scrivere un intervento off. Sconsigliamo l'utilizzo di tali commenti, ma può essere un ottimo modo per mettersi d'accordo all'inizio della giocata. Un altro tipo di intervento è il tiro dei dadi: ogni personaggio potrà aprire una finestra modale in cui potrà tirare i dadi, associando un Attributo e un'Abilità, con un Malus, specificando la difficoltà del tiro.
    </.guide_p>

    <.guide_p>
      Pur comprendendo che il gioco ha delle tinte <i>forti</i>, e che i temi affrontati potrebbero essere sgradevoli, si richiama all'esigenza di mantenere tutto <span class="font-bold underline">all'interno del gioco</span>, ed anzi di sincerarsi sempre che gli argomenti trattati non mettano a disagio qualcuno dei giocatori. Sentitevi liberi di comunicare il vostro stato d'animo se una giocata non vi piace, o se affronta temi per voi sgradevoli e difficili, il narratore in quel caso avrà l'obbligo di estromettere il vostro personaggio dalla giocata, sospendendola o prendendo il controllo del vostro personaggio. Sappiate, però, che in una ambientazione come questa l'orrore e argomenti sgradevoli sono parte integrante della trama, anche se mai fini a sé stessi; quindi, consigliamo di non considerare questo gioco se la vostra sensibilità non lo consente.
    </.guide_p>

    <.guide_p>
      Il gioco potrà contenere linguaggio violento, e trattare temi estremi a sfondo sessuale, dipendenze, violenza, morte e soprannaturale. È <span class="font-bold underline">assolutamente vietato l'ingresso ai minori di 18 anni</span>, e si consiglia agli utenti di leggere attentamente il disclaimer in fase di registrazione. Detto questo, la lista di seguito contiene tutto ciò che è assolutamente vietato, anche nell'interpretazione di un personaggio, pena il ban definitivo dell'utente:
      <ul>
        <li>Bestemmie.</li>
        <li>Accurate descrizioni che sfocerebbero nello splatter fine a sé stesso.</li>
        <li>Descrizioni riguardante qualsiasi tipo di violenza di natura sessuale.</li>
        <li><i>To be completed</i>.</li>
      </ul>
    </.guide_p>

    <.h1>Ricerca</.h1>

    <.guide_p>
      La ricerca costituisce una parte fondamentale del gioco di <b>Stygian</b>. La fase di ricerca è un modo che il giocatore ha per determinare il funzionamento e le caratteristiche di un oggetto, sia esso soprannaturale o meno, o di sviluppare il disegno e il funzionamento di nuovi oggetti, dispositivi, o sostanze che potranno aiutarlo a sopravvivere, o che potrà commerciare con altri personaggi. La fase di ricerca consisterà nella scrittura di almeno dieci azioni solitarie del personaggio in qualsiasi locazione pubblica, in cui il personaggio potrà interpretare lo svolgimento della sperimentazione che ha in mente: in queste azioni, il giocatore se lo riterrà opportuno potrà andare in deroga alla regola di non manifestare i pensieri del suo personaggio, ma questo potrà influire a discrezione del narratore nel computo dei punti esperienza assegnati, quindi andranno ben ponderati. Alla fine delle dieci azioni, il personaggio potrà avvisare un narratore della sua giocata, allegando l'orario; il narratore, poi, chiederà di effettuare un tiro per determinare la riuscita dello studio: il tiro potrà essere effettuato in chat in qualsiasi orario, ma dovrà essere comunicato al Narratore. Il Narratore, a seconda della riuscita del tiro e dell'interpretazione, potrà assegnare un numero di punti esperienza variabili, ed alcuni oggetti al personaggio. Se un altro personaggio vorrà giocare approfittando della vostra presenza, la ricerca sarà interrotta, ma potrete "riutilizzare" il numero di turni in solitaria già interpretati in un'altra giocata: se quindi ad esempio avrete già interpretato in solitaria cinque azioni di ricerca, e decidete di cominciare una giocata (cosa estremamente consigliata), potrete ricominciare la ricerca in un secondo momento, ed a quel punto basteranno cinque azioni per terminare la sessione di studio.
    </.guide_p>
    """
  end
end

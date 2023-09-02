defmodule StygianWeb.UserRegistrationDisclaimer do
  @moduledoc """
  User registration disclaimer function components.
  """

  use StygianWeb, :html

  def disclaimer(assigns) do
    ~H"""
    <h1 class="text-brand">Disclaimer</h1>

    <p class="text-brand text-sm">
      Registrazione (ai sensi e per gli effetti della legge 196/03) L'utente, registrandosi, presta il consenso ed autorizza l'inserimento dei suoi dati personali nella banca dati del gioco con il fine di inserirli nell'elenco dei suoi utenti. Gli stessi dati NON saranno ceduti e utilizzati ad alcun soggetto estraneo a chi, attualmente o in futuro, gestisce il presente gioco. I dati saranno trattati elettronicamente e serviranno esclusivamente per partecipare al gioco e per ricevere eventuali ed indispensabili comunicazioni tecniche via e-mail. I dati inseriti e le comunicazioni fra utenti all'interno del gioco, anche qualora siano indicati come anonimi, privati, non strettamente pertinenti al gioco stesso e/o vengano inviati tra singoli utenti, saranno comunque sempre accessibili ed utilizzabili dai gestori a fini di gioco. L'interessato potrà in ogni momento e gratuitamente esercitare i diritti di cui all'art. 13 L.196/03, quali: la possibilità di accedere ai registri del Garante, ottenere informazioni in relazione ai dati che lo riguardano, ottenere la cancellazione o il blocco, ovvero l'aggiornamento, la rettifica o l'integrazione, così come previsto dall'articolo 13 L.196/03 inviando una e-mail all'indirizzo postmaster@stygian.eu. Il responsabile tecnico che amministra il database contenente i dati degli utenti coincide con l'intestatario del dominio www.stygian.eu e puo' essere contattato all'indirizzo e-mail postmaster@stygian.eu. L'accesso al gioco è vincolato per via dei contenuti spesso violenti, il turpiloquio e possibili scene di sesso. Pertanto, proseguendo, dichiaro di avere più di 18 anni. Lo staff si riserva il diritto di limitare, sospendere o cancellare senza preavviso qualunque account senza l'obbligo di giustificazione. Iscrivendosi, l'utente dichiara di aver letto e di accettare queste condizioni.
    </p>
    """
  end
end

import { useState } from 'react';
import { traly_backend } from 'declarations/traly_backend';

function App() {
  const [mails, setMails] = useState(null);

  function handleSubmit(event) {
    event.preventDefault();
    const name = event.target.elements.name.value;
    traly_backend.fetchAllEmails().then((mail) => {
      console.log("mail", mail);
      setMails(mail);
    });
    console.log("Clicked", mails);
    return false;
  }

  return (
    <main>
      <img src="/logo2.svg" alt="DFINITY logo" />
      <br />
      <br />
      <form action="#" onSubmit={handleSubmit}>
        <label htmlFor="name">Enter your name: &nbsp;</label>
        <input id="name" alt="Name" type="text" />
        <button type="submit">Click Me!</button>
      </form>
      <section id="mails">
        {mails && mails.map(mail => {
          return (
            <div key={mail.id}>{mail.subject}</div>
          )
        })}
      </section>
    </main>
  );
}

export default App;

# RealDealApi

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## ERD

```mermaid
erDiagram

    User {
        uuid id
        uuid account_id
        string full_name
        string gender
        text biography
        datetime inserted_at
        datetime updated_at
    }

    Account {
        uuid id
        string email
        string user
        string hashed_password
        datetime inserted_at
        datetime updated_at
    }

    Account ||--|| User : has_one


```

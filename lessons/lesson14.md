# Elixir course lesson №14

# Ecto


няколко са ключоветие компоненти в екто

```
Repo - repositories that are wrappers around a datastor, using it gives us the ability to insert,create, delete and query.
Schema - schemas map any data source into an elixir
Changeset - Changesets provide a way for developers to filter and cast external parameters, as well as a mechanism to track and validate changes before they are applied to data.
Query - Provides a DSL-like SQL query for retrieving information from a repository. Queries in Ecto are secure, avoiding common problems like SQL Injection, while still being composable, allowing developers to build queries piece by piece instead of all at once.
```

# Schema 

пример за схема:
```
defmodule User do
  use Ecto.Schema

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :age, :integer
     many_to_many(:energy_meters, EnergyMeter,
      join_through: "user_energy_meters",
      on_replace: :delete
    )
     ## defyning many to many rfelation between phonen umber and userss
    many_to_many(:numbers, PhoneNumber, join_through: "user_numbers", on_replace: :delete)
    ### напиши един belongs_to
  end
end
```

как се изразява в миграцишятя:
```
defmodule SpmWeb.Repo.Migrations.CreateUserMeters do
  use Ecto.Migration

  def change do
    create table(:user_energy_meters, primary_key: false) do
      add(:energy_meter_id, references(:energy_meters, on_delete: :delete_all), primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all), primary_key: true)
    end
  end
end
```




има няколок вида асоциация в екто

```
belongs to - казва се какво ще му е "многото"
has many - казва се кое ще му емногото
has one - най-много един може и да е нула
many_to_many - за връзка много към много, после в миграциите се прави junction table
във миграциите ги пишем references

```

# Changeset

A changeset is a type of elixir struct that contains information pertaining to how a database should be modified.

By convention, we add methods for creating changesets to the schema using Ecto.Changeset.cast\3 to cast items from a map.

```
defmodule Myapp.Schema.User do
  use Ecto.Schema
  import Ecto
  import Ecto.Changeset
  import Ecto.Query

  # ...

  def changeset(struct, params \\ %{})) do
    struct
      |> cast(params, [:email, :password_hash])
  end

end
```


# Query


Queries are used to retrieve and manipulate data from a repository (see Ecto.Repo). Ecto queries come in two flavors: keyword-based and macro-based. Most examples will use the keyword-based syntax, the macro one will be explored in later sections.

```
# Imports only from/2 of Ecto.Query
import Ecto.Query, only: [from: 2]

# Create a query
query = from u in "users",
          where: u.age > 18,
          select: u.name

# Send the query to the repository
Repo.all(query)
```


малко теорзя дза екто
примери
задача имплементираща круд операциите

накрая сажи за курсовата


задачата да се пусне постгрес сървър да се направи една таблица, втори модул в който да се имплементират круд и листване и пример за всяка една асоцияция
начертай и схема на базата
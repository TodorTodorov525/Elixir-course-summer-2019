# Elixir course lesson №14

# Ecto

https://hexdocs.pm/ecto/Ecto.html

Ecto is the most used middleware for DB operations. It is somewhat close to the ORM in the object-oriented languages. Is consist of four key components.

```
Repo - repositories that are wrappers around a datastore, using it gives us the ability to insert,create, delete and query

Schema - schemas map any data source into an elixir struct

Changeset - provides a way for developers to filter and cast external parameters, as well as a mechanism to track and validate changes before they are applied to data

Query - provides a SQL query for retrieving information from a repository. Queries in Ecto are secure, avoiding common problems like SQL Injection, while still being composable, allowing developers to build queries piece by piece instead of all at once
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
    has_many :phone_numbers, PhoneNumber
    many_to_many(:energy_meters, EnergyMeter,
    join_through: "user_energy_meters",
    on_replace: :delete
  )
  end
end
```

In order to reate a table in the DB, a migration must be created. Which can be done with the command `mix ecto.gen.migration create_users`

Example:
```
defmodule EctoTest.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:first_name, :string)
      add(:last_name, :string)
      add(:age, :integer)
    end
  end
end
```

Ecto implements a couple of associations:

```
belongs to - it is being put in the scheme that is the 'many' in a one-to-many relationship
has many - it is being put in the scheme that is the 'one' in a one-to-many relationship
has one - it is being used for one-to-one relationships
many_to_many - for implementing a many-to-many relationship, it needs a junction table in the migrations 

the foreign ke
във миграциите ги пишем references

```

The foreign key implementation is being done in the migration.

Example:
```
  create table(:phone_number) do
    add(:number, :string)
    add(:user_id, references(:users))
  end
```

# Changeset

A changeset is a type of elixir struct that contains information pertaining to how a database should be modified.

By convention, we add methods for creating changesets to the schema using Ecto.Changeset.cast\3 to cast items from a map.

```
defmodule EctoTest.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias EctoTest.{PhoneNumber, EnergyMeter, User, Repo}

  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:age, :integer)
    has_many(:phone_numbers, PhoneNumber)

    many_to_many(:energy_meters, EnergyMeter,
      join_through: "user_energy_meters",
      on_replace: :delete
    )
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [
      :first_name,
      :last_name,
      :age
    ])
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
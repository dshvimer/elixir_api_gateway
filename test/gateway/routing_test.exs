defmodule Gateway.RoutingTest do
  use Gateway.DataCase
  alias Gateway.Routing

  describe "match" do
    test "simple mapping" do
      table = %{
        "/" => %{
          "users" => "/u",
          "books" => "/b"
        }
      }

      assert {:ok, "/u"} = Routing.match(table, "/users")
      assert {:ok, "/b"} = Routing.match(table, "/books")
      assert {:error, :no_match} = Routing.match(table, "/something")
    end

    test "nested mapping" do
      table = %{
        "/" => %{
          "api" => %{
            "users" => "/u",
            "books" => "/b"
          }
        }
      }

      assert {:ok, "/u"} = Routing.match(table, "/api/users")
      assert {:ok, "/b"} = Routing.match(table, "/api/books")
      assert {:error, :no_match} = Routing.match(table, "/something")
    end

    test "leftover parts get appended" do
      table = %{
        "/" => %{
          "api" => %{
            "users" => "/u",
            "books" => "/b"
          }
        }
      }

      assert {:ok, "/u/1"} = Routing.match(table, "/api/users/1")
      assert {:ok, "/b/1/operation"} = Routing.match(table, "/api/books/1/operation")
      assert {:error, :no_match} = Routing.match(table, "/something/1")
    end
  end

  describe "build_table" do
    test "simple" do
      endpoints = [
        {"/users", "/u"},
        {"/books", "/b"}
      ]

      expected = %{
        "/" => %{
          "users" => "/u",
          "books" => "/b"
        }
      }

      assert Routing.build_table(endpoints) == expected
    end

    test "nested" do
      endpoints = [
        {"/api/users", "/u"},
        {"/api/books", "/b"}
      ]

      expected = %{
        "/" => %{
          "api" => %{
            "users" => "/u",
            "books" => "/b"
          }
        }
      }

      assert Routing.build_table(endpoints) == expected
    end
  end
end

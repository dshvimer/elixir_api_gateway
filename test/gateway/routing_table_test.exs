defmodule Gateway.RoutingTableTest do
  use Gateway.DataCase
  alias Gateway.RoutingTable

  describe "match" do
    test "simple mapping" do
      table = %{
        "/" => %{
          "users" => "/u",
          "books" => "/b"
        }
      }

      assert {:ok, "/u"} = RoutingTable.match(table, "/users")
      assert {:ok, "/b"} = RoutingTable.match(table, "/books")
      assert {:error, :no_match} = RoutingTable.match(table, "/something")
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

      assert {:ok, "/u"} = RoutingTable.match(table, "/api/users")
      assert {:ok, "/b"} = RoutingTable.match(table, "/api/books")
      assert {:error, :no_match} = RoutingTable.match(table, "/something")
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

      assert {:ok, "/u/1"} = RoutingTable.match(table, "/api/users/1")
      assert {:ok, "/b/1/operation"} = RoutingTable.match(table, "/api/books/1/operation")
      assert {:error, :no_match} = RoutingTable.match(table, "/something/1")
    end
  end

  describe "build_table" do
    test "simple" do
      endpoints = [
        {"/users", "/u"},
        {"/books", "/b"}
      ]

      assert %{
               "/" => %{
                 "users" => "/u",
                 "books" => "/b"
               }
             } == RoutingTable.build_table(endpoints)
    end

    test "nested" do
      endpoints = [
        {"/api/users", "/u"},
        {"/api/books", "/b"}
      ]

      assert %{
               "/" => %{
                 "api" => %{
                   "users" => "/u",
                   "books" => "/b"
                 }
               }
             } == RoutingTable.build_table(endpoints)
    end
  end
end

defmodule CambiatusWeb.ManifestControllerTest do
  use Cambiatus.DataCase
  use CambiatusWeb.ConnCase

  alias Cambiatus.Repo

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Manifest" do
    setup :valid_community_and_user

    test "get manifest from existing community",
         %{conn: conn, community: community} do
      # Generate community, save name and subdomain name
      # insert subdomain name into conn

      # community =
      #   community
      #   |> Repo.preload(:subdomain)

      IO.inspect(community)

      %{name: name, subdomain: %{name: subdomain}} =
        community
        |> Repo.preload(:subdomain)

      IO.puts(name)
      IO.puts(subdomain)

      # subdomain = community.subdomain.name
      # name = community.name

      conn =
        %{conn | host: subdomain}
        |> get("/api/manifest")

      %{"short_name" => short_name} = json_response(conn, 200)

      # Check http code 200 and if the community name served is the same generated
      assert conn.status == 200
      assert short_name == name
    end

    test "get manifest from non existing community" do
      # Send conn without subdomain and check for http code 301 and redirect
      conn =
        build_conn()
        |> get("/api/manifest")

      [location] =
        conn
        |> get_resp_header("location")

      assert conn.status == 301
      assert location == "/manifest.json"
    end
  end
end

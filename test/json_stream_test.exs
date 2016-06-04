defmodule JSONStreamTest do
  use ExUnit.Case

  test "stream array elems" do
    {stream,acc} = File.stream!("test/json/example.json",[],100)
      |> JSONStream.stream(["data",1,"actions"])
    assert Enum.to_list(stream) == [
      %{"link" => "http://www.facebook.com/X998/posts/Y998", "name" => "Comment"},
      %{"link" => "http://www.facebook.com/X998/posts/Y998", "name" => "Like"}]
    assert acc.() == 
      %{"data" => [%{"actions" => [%{"link" => "http://www.facebook.com/X999/posts/Y999", "name" => "Comment"},
                                   %{"link" => "http://www.facebook.com/X999/posts/Y999", "name" => "Like"}],
        "created_time" => "2010-08-02T21:27:44+0000",
        "from" => %{"id" => "X12", "name" => "Tom Brady"}, "id" => "X999_Y999",
        "message" => "Looking forward to 2010!", "type" => "status",
        "updated_time" => "2010-08-02T21:27:44+0000"},
      %{"actions" => [], "created_time" => "2010-08-02T21:27:44+0000",
        "from" => %{"id" => "X18", "name" => "Peyton Manning"},
        "id" => "X998_Y998", "message" => "Where's my contract?",
        "type" => "status", "updated_time" => "2010-08-02T21:27:44+0000"}]}
  end

  test "stream map key vals" do
    {stream,acc} = File.stream!("test/json/example.json",[],100)
      |> JSONStream.stream(["data",0,"actions",0])
    assert Enum.to_list(stream) == [{"name","Comment"},{"link","http://www.facebook.com/X999/posts/Y999"}]

    assert acc.() == 
      %{"data" => [%{"actions" => [%{},%{"link" => "http://www.facebook.com/X999/posts/Y999", "name" => "Like"}],
        "created_time" => "2010-08-02T21:27:44+0000",
        "from" => %{"id" => "X12", "name" => "Tom Brady"}, "id" => "X999_Y999",
        "message" => "Looking forward to 2010!", "type" => "status",
        "updated_time" => "2010-08-02T21:27:44+0000"},
      %{"actions" => [%{"link" => "http://www.facebook.com/X998/posts/Y998", "name" => "Comment"},
                      %{"link" => "http://www.facebook.com/X998/posts/Y998", "name" => "Like"}], 
        "created_time" => "2010-08-02T21:27:44+0000",
        "from" => %{"id" => "X18", "name" => "Peyton Manning"},
        "id" => "X998_Y998", "message" => "Where's my contract?",
        "type" => "status", "updated_time" => "2010-08-02T21:27:44+0000"}]}
  end
end

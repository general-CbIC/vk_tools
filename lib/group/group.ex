defmodule VkTools.Group do
  defstruct id: "", token: ""

  alias __MODULE__
  alias VkTools.Request

  def get_users(%Group{id: id, token: token}) do
    request = %Request{path: "groups.getMembers", access_token: token}
    answer = Request.post(request, %{group_id: id})

    answer["response"]["items"]
  end

  def send_message_to_users(%Group{token: token} = group, message) do
    request = %Request{path: "messages.send", access_token: token}

    user_ids =
      group
      |> get_users()
      |> Enum.join(",")

    Request.post(request, %{
      user_ids: user_ids,
      message: message,
      random_id: :rand.uniform(9_000_000_000_000_000_000)
    })
  end
end

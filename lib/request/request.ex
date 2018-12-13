defmodule VkTools.Request do
  defstruct path: "", access_token: ""

  alias __MODULE__

  @base_url "https://api.vk.com/method/"
  @api_v "5.92"

  def post(%Request{} = request, params \\ %{}) do
    HTTPoison.start()

    request
    |> url()
    |> HTTPoison.post!(prepare_params(params))
    |> IO.inspect()
    |> parse_answer()
  end

  ###############
  ### PRIVATE ###
  ###############
  defp prepare_params(params) do
    params
    |> Enum.map(fn {k, v} -> "#{k}=#{v}" end)
    |> Enum.join(";")
  end

  defp url(%Request{access_token: access_token, path: path}) do
    "#{@base_url}#{path}?access_token=#{access_token}&v=#{@api_v}"
  end

  defp parse_answer(%HTTPoison.Response{body: body}) do
    body
    |> Jason.decode!()
  rescue
    _e -> IO.inspect(body)
  end
end

defmodule DatabaseUtil.AIAgent do
  alias LangChain.ChatModels.ChatGoogleAI
  alias LangChain.Chains.LLMChain
  alias LangChain.Message
  alias DatabaseUtil.Tools.Calc
  alias DatabaseUtil.Tools.Task_Tools

  def run(messages \\ []) do
    message = IO.gets("You: ") |> String.trim()
    updated_messages = messages ++ [Message.new_user!(message)]

    chain =
      %{
        llm:
          ChatGoogleAI.new!(%{
            model: "gemini-2.5-flash",
            api_key: Application.get_env(:langchain, :google_api_key)
          })
      }
      |> LLMChain.new!()
      |> LLMChain.add_messages(updated_messages)
      |> LLMChain.add_tools([
        Calc.add_tool(),
        Task_Tools.get_all_tasks_tool(),
        Task_Tools.create_tasks_tool()
        ])

    {:ok, completed_chain} = LLMChain.run(chain, mode: :while_needs_response)
    # IO.inspect(completed_chain.last_message, label: "LAST MESSAGE")
    # IO.inspect(completed_chain.last_message.content, label: "CONTENT")

    response_text =
      completed_chain.last_message.content
      |> Enum.map(& &1.content)
      |> Enum.join("")

    IO.puts("\nGemini: #{response_text}\n")

    run(updated_messages ++ [Message.new_assistant!(response_text)])
  end
end

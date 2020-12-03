defmodule CargueroTaskBunny.InitializerTest do
  use ExUnit.Case, async: false
  import CargueroTaskBunny.QueueTestHelper
  alias CargueroTaskBunny.{Config, Initializer, Queue}

  @queue "carguero_task_bunny.initializer_test"

  defp queues do
    [
      [name: @queue, host: :default]
    ]
  end

  setup do
    clean(Queue.queue_with_subqueues(@queue))
    :meck.new(Config, [:passthrough])
    :meck.expect(Config, :queues, fn -> queues() end)

    on_exit(fn -> :meck.unload() end)

    :ok
  end

  describe "declare_queues_from_config" do
    test "loads list of queues from config and declares them" do
      Initializer.declare_queues_from_config()

      assert Queue.state(@queue) == %{
               consumer_count: 0,
               message_count: 0,
               queue: @queue
             }
    end
  end
end

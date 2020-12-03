defmodule CargueroTaskBunny.StatusTest do
  use ExUnit.Case, async: false

  import CargueroTaskBunny.QueueTestHelper
  alias CargueroTaskBunny.{Config, Queue, JobTestHelper}

  @host :status_test
  @queue "carguero_task_bunny.status_test"

  @supervisor :status_test_supervisor
  @worker_supervisor :status_test_worker_supervisor
  @publisher :status_test_publisher

  defp mock_config do
    worker = [host: @host, queue: @queue, concurrency: 1]

    :meck.new(Config, [:passthrough])
    :meck.expect(Config, :hosts, fn -> [@host] end)
    :meck.expect(Config, :connect_options, fn @host -> "amqp://localhost" end)
    :meck.expect(Config, :workers, fn -> [worker] end)
  end

  setup do
    clean(Queue.queue_with_subqueues(@queue))
    Queue.declare_with_subqueues(:default, @queue)

    mock_config()
    JobTestHelper.setup()
    CargueroTaskBunny.Supervisor.start_link(@supervisor, @worker_supervisor, @publisher)

    on_exit(fn ->
      :meck.unload()
    end)

    :ok
  end

  describe "status" do
    test "overview system up" do
      %{up: up} = CargueroTaskBunny.Status.overview(@supervisor)

      assert up
    end

    test "overview system down" do
      %{up: up} = CargueroTaskBunny.Status.overview(:fake_supervisor)

      refute up
    end

    test "overview workers" do
      %{workers: workers} = CargueroTaskBunny.Status.overview(@supervisor)

      assert length(workers) == 1
    end
  end
end

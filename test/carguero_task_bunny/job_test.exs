defmodule CargueroTaskBunny.JobTest do
  use ExUnit.Case
  import CargueroTaskBunny.QueueTestHelper
  alias CargueroTaskBunny.{Job, Queue, Message, QueueTestHelper}

  @queue "carguero_task_bunny.job_test"

  defmodule TestJob do
    use Job
    def perform(_payload), do: :ok
  end

  setup do
    clean(Queue.queue_with_subqueues(@queue))
    Queue.declare_with_subqueues(:default, @queue)

    :ok
  end

  describe "enqueue" do
    test "enqueues job" do
      payload = %{"foo" => "bar"}
      :ok = TestJob.enqueue(payload, queue: @queue)

      {received, _} = QueueTestHelper.pop(@queue)
      {:ok, %{"payload" => received_payload}} = Message.decode(received)
      assert received_payload == payload
    end

    test "returns an error for wrong option" do
      payload = %{"foo" => "bar"}

      assert {:error, _} =
               TestJob.enqueue(
                 payload,
                 queue: @queue,
                 host: :invalid_host
               )
    end
  end

  describe "enqueue!" do
    test "raises an exception for a wrong host" do
      payload = %{"foo" => "bar"}

      assert_raise CargueroTaskBunny.Publisher.PublishError, fn ->
        TestJob.enqueue!(payload, queue: @queue, host: :invalid_host)
      end
    end
  end
end

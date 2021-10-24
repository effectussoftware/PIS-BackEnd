module ApplicationCable
  class ConnectionTest < ActionCable::Connection::TestCase
    def test_connects_with_cookies
      client = request.params[:client]
      uid = request.params[:uid]
      token = request.params[:token]

      # Simulate a connection
      connect

      # Asserts that the connection identifier is correct
      assert_equal uid, connection.user.name
    end

    def test_does_not_connect
      assert_reject_connection do
        connect
      end
    end
  end
end
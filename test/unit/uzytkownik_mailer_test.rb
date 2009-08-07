require 'test_helper'

class UzytkownikMailerTest < ActionMailer::TestCase
  test "activate" do
    @expected.subject = 'UzytkownikMailer#activate'
    @expected.body    = read_fixture('activate')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UzytkownikMailer.create_activate(@expected.date).encoded
  end

  test "forgot_password" do
    @expected.subject = 'UzytkownikMailer#forgot_password'
    @expected.body    = read_fixture('forgot_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UzytkownikMailer.create_forgot_password(@expected.date).encoded
  end

end

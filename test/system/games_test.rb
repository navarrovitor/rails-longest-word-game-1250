# test/system/games_test.rb
require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit root_url
    assert test: "New game"
    assert_selector "li", count: 10
  end

  test 'word is not in grid' do
    visit root_url
    fill_in 'guess', with: 'ZZZZZZZZZZZZZZZZZZZ'
    click_on 'Submit!'

    assert_text "Sorry but ZZZZZZZZZZZZZZZZZZZ can't be built out of"
  end

  test 'not an english word' do
    visit root_url
    fill_in 'guess', with: ''
    click_on 'Submit!'

    assert_text "Sorry but does not seem to be a valid English word..."
  end
end
When(/^I select "(.*?)" from the select list$/) do |item|
  @page.select_list_id = item
end

Then(/^the current item should be "(.*?)"$/) do |expected_item|
  expect(@page.select_list_id).to eql expected_item
end

When(/^I locate the select list by "(.*?)"$/) do |how|
  @how = how
end

Then(/^I should be able to select "(.*?)"$/) do |item|
  @page.send "select_list_#{@how}=".to_sym, item
end

Then(/^the value for the selected item should be "(.*?)"$/) do |expected_item|
  expect(@page.send "select_list_#{@how}".to_sym).to eql expected_item
end

When(/^I retrieve a select list$/) do
  @element = @page.select_list_id_select_list
end

When(/^I search for the select list by "(.*?)"$/) do |how|
  @how = how
end

Then(/^option "(.*?)" should contain "(.*?)"$/) do |opt_num, text|
  @element = @page.send "select_list_#{@how}_select_list".to_sym
  expect(@element[opt_num.to_i - 1].text).to eql text
end

Then(/^each option should contain "(.*?)"$/) do |text|
  @element.options.each do |option|
    expect(option.text).to include text
  end
end

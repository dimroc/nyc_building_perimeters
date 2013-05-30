require 'spec_helper'

feature "JasmineSpecs" do
  def wait_until
    finished = false
    iterations = 0
    while(!finished && iterations < 5)
      finished = yield
      sleep(1)
      iterations += 1
    end
  end

  scenario "should all pass", js: true do
    visit "/jasmine"

    wait_until { page.evaluate_script("jsApiReporter.finished") }

    jasmine_results =
      page.evaluate_script(<<-TRUTH_JS)
      _.all(jsApiReporter.results(), function(r) { return r.result == "passed"} )
      TRUTH_JS
    jasmine_results.should be_true
  end
end

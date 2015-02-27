FIXTURE_DIR = CoverMyEpa.root.join 'fixtures'

def result_json(filename)
  text = FIXTURE_DIR.join('results', "#{filename}.json").read
end

def instruction_json(filename)
  text = FIXTURE_DIR.join('instructions', "#{filename}.json").read
end

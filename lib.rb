def iterate(state)
  newfish = state.shift
  state.push(newfish)
  state[6] += newfish
  state
end

def count_by_age(input)
  fish = [0, 0, 0, 0, 0, 0, 0, 0, 0]
  input.each do |age|
    fish[age] += 1
  end
  fish
end

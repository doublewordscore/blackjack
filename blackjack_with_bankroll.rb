
@cards = [2,3,4,5,6,7,8,9,10,"J","Q","K","A"]

def value(x)
  if x == "A"
    return x = 11 # Adjusting for 1 or 11 in count-scoring method
  elsif x == "J" || x == "Q" || x == "K"
    return x = 10
  else
    return x
  end
end

# method to count score with aces last to determine if the ace(s) are worth 1 or 11
def count_score(array)
  total = 0
  sorted_hand = array.sort_by { |x| value(x) }
  sorted_hand.each do |x|
    if value(x) == 11 && total >= 11
      total += 1
    else
      total += value(x)
    end
  end
  total
end

def start_game
  puts "Welcome to Blackjack."
  puts "Please enter your name."
  @name = gets.chomp
  puts "What is your starting bankroll?"
  @bankroll = gets.chomp.to_i
  puts "Great! Let's play blackjack!"
end

# sets the users bankroll and bet amount
def wager_hand
  1.times do
    puts "How much do you want to wager?"
    @bet_amount = gets.chomp.to_i
      if @bet_amount <= @bankroll
        puts "OK! Let's play"
      else
        puts "You don't have enough money!"
        puts "Please wager a valid amount."
        redo
      end
    end
end

def deal_hand
  $player_hand = []
  $dealer_hand = []
  $player_hand.push(@cards.sample)
  $player_hand.push(@cards.sample)
  $dealer_hand.push(@cards.sample)
  puts @name + " has #{$player_hand}"
  puts count_score($player_hand)
  puts "Dealer has #{$dealer_hand}"
  puts count_score($dealer_hand)
end

def player_decision
  1.times do
    puts "Type 'hit' or 'stay' for your next move."
    decision = gets.chomp
      if decision == "hit"
        hit($player_hand)
      elsif decision == "stay"
        stay($dealer_hand)
      else
        puts "Invalid response, Try again."
        redo
      end
  end
end

def hit(array)
  array.push(@cards.sample)
  puts @name + " has #{array}"
  new_score = count_score(array)
  if new_score < 22
    puts new_score
    player_decision
  else
    bust
  end
end

def stay(array)
  until count_score(array) >= 17
    array.push(@cards.sample)
    puts "Dealer has #{array}"
  end
  puts count_score(array)  
  determine_winner
end

# checks hand for blackjack and pays out 3:2 ratio 
def check_blackjack
  if count_score($player_hand) == 21 && $player_hand.length == 2
    puts "Blackjack! You win!"
    @bankroll += @bet_amount*1.5
    puts "Your new bankroll is " + @bankroll.to_s
    play_again
  end
end

def bust
  puts "Bust! You lost this round!"
  @bankroll -= @bet_amount
  puts "Your new bankroll is " + @bankroll.to_s
  play_again
end

def determine_winner
  if count_score($dealer_hand) > 21
    puts "Dealer busts! You win!"
    @bankroll += @bet_amount
    puts "Your new bankroll is " + @bankroll.to_s
  elsif count_score($player_hand) == count_score($dealer_hand)
    puts "Push!"
    puts "Your bankroll remains " + @bankroll.to_s
  elsif count_score($player_hand) > count_score($dealer_hand)
    puts "You win!"
    @bankroll += @bet_amount
    puts "Your new bankroll is " + @bankroll.to_s
  else
    puts "Dealer wins!"
    @bankroll -= @bet_amount
    puts "Your new bankroll is " + @bankroll.to_s
  end
  play_again
end

def play_again
  puts " - - - - - - - - - - - - - "
  puts "Do you want to play again?"
  puts "Type 'yes' or 'no' please."
  puts " - - - - - - - - - - - - - "
  response = gets.chomp
    if response == "yes"
      entire_round
    else response == "no"
      puts "Thanks for playing. Your ending bankroll is " + @bankroll.to_s
    end
end


def entire_round
  wager_hand
  deal_hand
  check_blackjack
  player_decision
end
  
start_game
entire_round

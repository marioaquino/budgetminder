require 'budget_minder'

minder = BudgetMinder.new

def hash_arg(arg) 
  Hash[*(arg.split('='))]
end

action = ARGV[0]
if 'expense' == action
  minder.add_expense(ARGV[1]) if ARGV[1]	
elsif 'update' == action
  args = hash_arg(ARGV[1]).merge(hash_arg(ARGV[2]))
  puts args.to_yaml
  minder.cycle_end_date = args['cycleDate']
  minder.budget = args['budget']
  minder.save
elsif 'reset' == action
  minder.clear
end

#Amount spent
puts "Spent=#{minder.current_value}"
#Monthly budget
puts "Budget=#{minder.budget}"
#Remaining in budget for this period
puts "Remaining=#{minder.remaining}"
#Cycle end date
puts "EndDate=#{minder.cycle_end_date}"
#Num Days until end date
puts "DaysUntilEnd=#{minder.days_until_end_of_cycle}"
#Percentage of total budget used in this period
puts "PercentageUsed=#{minder.percent_used}"

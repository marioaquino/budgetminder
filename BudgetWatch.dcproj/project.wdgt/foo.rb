require 'budget_minder'

minder = BudgetMinder.new

minder.add_expense(ARGV[0]) if ARGV[0]

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

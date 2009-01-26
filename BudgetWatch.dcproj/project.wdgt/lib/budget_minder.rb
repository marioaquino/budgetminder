require "rubygems"
require "date"
require "parsedate"
require "google_spreadsheet"

class BudgetMinder
  
  def initialize
    session = GoogleSpreadsheet.login(*user_and_pass)
    spreadsheet = session.spreadsheets("title" => "BudgetMinder").first
    @ws = spreadsheet.worksheets[0]
  end

  def add_expense(value)
    next_row = ws.num_rows + 1
    ws[next_row, 2] = Date.today.to_s
    ws[next_row, 3] = value
    ws.synchronize
  end

  def current_value
    ws[2, 1]
  end
  
  def clear
    2.upto(ws.num_rows) do |row| 
      ws[row, 2] = ''
      ws[row, 3] = ''
    end
    ws.synchronize
  end
  
  def budget
    ws[2, 4]
  end
  
  def budget=(value)
    ws[2, 4] = value
    ws.synchronize
  end
  
  def remaining
    ws[2, 5]
  end
  
  def cycle_end_date
    ws[2, 6]
  end
  
  def cycle_end_date=(value)
    ws[2, 6] = value
  end
  
  def save
    ws.synchronize
  end
  
  def days_until_end_of_cycle
    # Date.parse introduced in Ruby 1.8.7 and later :(
    #(Date.parse(cycle_end_date) - Date.today).to_i
    (Date.new(*(ParseDate.parsedate(cycle_end_date).compact)) - Date.today).to_i
  end
  
  def percent_used
    ws[2, 7]
  end
  
  private
  attr_reader :ws
  
  def parse(lookup, pattern)
    $1 if lookup.find { |s| s =~ pattern }
  end

  def user_and_pass
    # Redirect stderr (where password is written to), to stdout
    lookup = `security 2>&1 find-generic-password -gs BudgetMinder`

    username_pattern = /^[\s]+"acct"<blob>="(.*)"$/
    password_pattern = /^password: "(.*)"$/

    username = parse lookup, username_pattern
    password = parse lookup, password_pattern
    [username, password]
  end
end

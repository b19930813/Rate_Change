require "./exchange_rate/version"
require "nokogiri"
require 'open-uri'
require "json"

# module ExchangeRate
#   class Error < StandardError; end
#   # Your code goes here...
# end

#bank class start
class Bank 
  def get_JP
    puts "取得日幣匯率"
  end

  def get_US
  end

  #為了避免頻繁爬蟲，所輸入的時間應該小於一分鐘
  def Start_Record_Rate(minite)
  end

  def Exchange_TW_TO_JP(money)
    
  end

  def Exchange_TW_TO_US(money)
  end

  def Exchange_JP_TO_TW(money)
  end

  def Exchange_US_TO_TW(money)
  end

   private 
  def number_check(number)
     if number.is_a? Numeric
      if number >= 0 
        return true 
      else 
        raise "請輸入數字或是大於0的數字"
      end
     end
  end
end
#bank class end

class TaiwanBank < Bank 
  #取得日幣，cash_buy_rate,cash_sell_rate,buying_rate,selling_rate
  
  def get_JP
    rates = refresh_bank_rate_json
    bank_result = {
      cash_buy_rate:rates['results']['JPY']['cash_buy_rate'],
      cash_sell_rate:rates['results']['JPY']['cash_sell_rate'],
      buying_rate:rates['results']['JPY']['buying_rate'],
      selling_rate:rates['results']['JPY']['selling_rate']
    }
    bank_result
  end

  def get_US
     rates = refresh_bank_rate_json
     bank_result = {
      cash_buy_rate:rates['results']['USD']['cash_buy_rate'],
      cash_sell_rate:rates['results']['USD']['cash_sell_rate'],
      buying_rate:rates['results']['USD']['buying_rate'],
      selling_rate:rates['results']['USD']['selling_rate']
    }
    bank_result
  end

  private
  def parseNode(node)
    name = node.css("div.print_show").text 
    symbol = name.match(/[A-Z]+/).to_s 
    rates = {
    cash_buy_rate: node.css("td[data-table=本行現金買入]")[0].text,
    cash_sell_rate: node.css("td[data-table=本行現金賣出]")[0].text,
    buying_rate: node.css("td[data-table=本行即期買入]")[0].text,
    selling_rate: node.css("td[data-table=本行即期賣出]")[0].text,
    name: name.strip
  }
  data = { symbol.to_sym => rates }
  end

  def refresh_bank_rate_json
    url = "https://rate.bot.com.tw/xrt?Lang=zh-TW"
    html = Nokogiri::HTML(open(url)) 
    datetime = html.css("span.time").text 
    tableRows = html.css("table > tbody > tr") 
    rates = {
       update: datetime,  #自定義一個變數名稱為update抓取上面所設定的datetime
       results: tableRows.reduce({}) { |accumulator, node| accumulator.merge parseNode(node) }
    }

    rates= rates.to_json
    return json = JSON.parse(rates)
  end
end

class ESun < Bank 
end

tb = TaiwanBank.new 
puts tb.get_US

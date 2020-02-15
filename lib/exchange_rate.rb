#require "./exchange_rate/version"
require "nokogiri"
require 'open-uri'
require "json"

#回傳目前最便宜的匯率
class ExchangeRate 
  #根據現金匯率取得最划算的銀行資訊
  def self.get_JP
    puts "取得日幣匯率"
  end

  def self.get_US
  end

  def self.get_CN
  end

  def self.Exchange_TW_TO_JP(money)
  end

  def self.Exchange_TW_TO_US(money)
  end

  def self.Exchange_JP_TO_TW(money)
  end

  def self.Exchange_US_TO_TW(money)
  end

  def self.Exchange_TW_TO_CN(money)
  end

  def self.Exchange_CN_TO_TW(money)
  end

  #暫定功能,預計下次更新
  def sub_get_JP
  end

  def sub_get_US
  end

  def sub_get_CN
  end


   private 
  def self.number_check(number)
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

class TaiwanBank < ExchangeRate 
  #取得日幣，cash_buy_rate,cash_sell_rate,buying_rate,selling_rate
   #取得日幣
  def self.get_JP
    rates = refresh_bank_rate_json
    bank_result = {
      cash_buy_rate:rates['results']['JPY']['cash_buy_rate'].to_f,
      cash_sell_rate:rates['results']['JPY']['cash_sell_rate'].to_f,
      buying_rate:rates['results']['JPY']['buying_rate'].to_f,
      selling_rate:rates['results']['JPY']['selling_rate'].to_f
    }
    bank_result
  end
   
  #取得美金
  def self.get_US
     rates = refresh_bank_rate_json
     bank_result = {
      cash_buy_rate:rates['results']['USD']['cash_buy_rate'].to_f,
      cash_sell_rate:rates['results']['USD']['cash_sell_rate'].to_f,
      buying_rate:rates['results']['USD']['buying_rate'].to_f,
      selling_rate:rates['results']['USD']['selling_rate'].to_f
    }
    bank_result
  end
 
  #取得人民幣
  def self.get_CN
    rates = refresh_bank_rate_json
    bank_result = {
     cash_buy_rate:rates['results']['CNY']['cash_buy_rate'].to_f,
     cash_sell_rate:rates['results']['CNY']['cash_sell_rate'].to_f,
     buying_rate:rates['results']['CNY']['buying_rate'].to_f,
     selling_rate:rates['results']['CNY']['selling_rate'].to_f
   }
   bank_result
  end
  
  #日幣換算
  def self.Exchange_TW_TO_JP(money,isCash = true)
     if money.is_a? Numeric
      isCash ? money / get_JP[:selling_rate] :  money / get_JP[:cash_sell_rate]
     else
      raise "請輸入數字"
     end
  end

  def self.Exchange_JP_TO_TW(money,isCash = true)
    if money.is_a? Numeric
      isCash ? money * get_JP[:buying_rate] :  money * get_JP[:cash_buy_rate]
     else
      raise "請輸入數字"
     end
  end

  #美金換算
  def self.Exchange_TW_TO_US(money, isCash = true)
    if money.is_a? Numeric 
      isCash ? money / get_US[:selling_rate] : money / get_US[:cash_sell_rate]
    else
      raise "請輸入數字"
    end
  end

  def self.Exchange_US_TO_TW(money, isCash = true)
    if money.is_a? Numeric
      isCash ? money * get_US[:buying_rate] : money * get_US[:cash_buy_rate]
    else
      raise "請輸入數字"
    end
  end

  #人民幣換算
  def self.Exchange_TW_TO_CN(money, isCash = true)
    if money.is_a? Numeric 
      isCash ? money / get_CN[:selling_rate] : money / get_CN[:cash_sell_rate]
    else
      raise "請輸入數字"
    end
  end

  def self.Exchange_CN_TO_TW(money, isCash = true)
    if money.is_a? Numeric 
      isCash ? money * get_CN[:buying_rate] : money * get_CN[:cash_buy_rate]
    else
      raise "請輸入數字"
    end
  end


  private
  def self.parseNode(node)
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

  def self.refresh_bank_rate_json
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


#玉山銀行的匯率
class ESun < ExchangeRate 
  def self.get_JP
    rates = refresh_bank_rate_json
    bank_result = {
      cash_buy_rate:rates['result']['cash_buy_rate'].to_f,
      cash_sell_rate:rates['result']['cash_sell_rate'].to_f,
      buying_rate:rates['result']['buying_rate'].to_f,
      selling_rate:rates['result']['selling_rate'].to_f
    }
    bank_result
  end

  def self.get_US
     
  end

  def self.get_CN
  end

  private
  def self.parseNode(node)
    name = node.css("td[data-name=外幣類型]")[3].text
  symbol = name.match(/[A-Z]+/).to_s
  temp_str = "網路銀行/App優惠匯率買入匯率"
  rates = {
    cash_buy_rate:node.css("td[data-name=即期買入匯率]")[3].text,
    cash_sell_rate: node.css("td[data-name=即期賣出匯率]")[3].text,
    buying_rate: node.css("td[data-name=現金買入匯率]")[3].text,
    selling_rate: node.css("td[data-name=現金賣出匯率]")[3].text,
    buying_best_rate: node.css("td[data-name]")[24].text,
    selling_best_rate: node.css("td[data-name]")[25].text,
    name: name.strip
  }
   rates
  end

  def self.refresh_bank_rate_json
    url = "https://www.esunbank.com.tw/bank/personal/deposit/rate/forex/foreign-exchange-rates"
    html = Nokogiri::HTML(open(url)) 
    datetime = html.css("span[@id = LbQuoteTime]").text
    tableRows = html.css("table > tr > td") 
    rates = {
      update: datetime,  #自定義一個變數名稱為update抓取上面所設定的datetime
      result:  parseNode(tableRows)
    }
    rates= rates.to_json
    return json = JSON.parse(rates)
  end
end

puts ESun.get_JP



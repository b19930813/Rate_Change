#require "./exchange_rate/version"
require "nokogiri"
require 'open-uri'
require "json"
require 'async'
require 'thread'

#回傳目前最便宜的匯率
class ExchangeRate 
  #根據現金匯率取得最划算的銀行資訊
  def self.get_JP
    taiwan_bank = TaiwanBank.get_JP
    esun_bank = ESun.get_JP
    taiwan_bank[:cash_sell_rate] < esun_bank[:cash_sell_rate] ? taiwan_bank : esun_bank
  end

  def self.get_US
    taiwan_bank = TaiwanBank.get_US
    esun_bank = ESun.get_US
    taiwan_bank[:cash_sell_rate] < esun_bank[:cash_sell_rate] ? taiwan_bank : esun_bank
  end

  def self.get_CN
    taiwan_bank = TaiwanBank.get_CN
    esun_bank = ESun.get_CN
    taiwan_bank[:cash_sell_rate] < esun_bank[:cash_sell_rate] ? taiwan_bank : esun_bank
  end

  #不計算玉山自己的特殊匯率
  def self.Exchange_TW_TO_JP(money, isCash = true)
     taiwan_bank = TaiwanBank.get_JP
     esun_bank = ESun.get_JP
     if  taiwan_bank[:cash_sell_rate] < esun_bank[:cash_sell_rate]
      isCash ? money / taiwan_bank[:cash_sell_rate] :  money / taiwan_bank[:cash_sell_rate]
     else
      isCash ? money / esun_bank[:selling_rate] :  money / esun_bank[:selling_rate]
     end
  end

  def self.Exchange_JP_TO_TW(money, isCash = true)
    taiwan_bank = TaiwanBank.get_JP
    esun_bank = ESun.get_JP
    if  taiwan_bank[:cash_buy_rate] > esun_bank[:cash_buy_rate]
     isCash ? money / taiwan_bank[:cash_buy_rate] :  money / taiwan_bank[:cash_buy_rate]
    else
     isCash ? money / esun_bank[:buying_rate] :  money / esun_bank[:buying_rate]
    end
  end


  def self.Exchange_TW_TO_US(money, isCash = true)
     taiwan_bank = TaiwanBank.get_US
     esun_bank = ESun.get_US
     if  taiwan_bank[:cash_sell_rate] < esun_bank[:cash_sell_rate]
      isCash ? money / taiwan_bank[:cash_sell_rate] :  money / taiwan_bank[:cash_sell_rate]
     else
      isCash ? money / esun_bank[:selling_rate] :  money / esun_bank[:selling_rate]
     end
  end



  def self.Exchange_US_TO_TW(money, isCash = true)
    taiwan_bank = TaiwanBank.get_US
    esun_bank = ESun.get_US
    if  taiwan_bank[:cash_buy_rate] > esun_bank[:cash_buy_rate]
     isCash ? money / taiwan_bank[:cash_buy_rate] :  money / taiwan_bank[:cash_buy_rate]
    else
     isCash ? money / esun_bank[:buying_rate] :  money / esun_bank[:buying_rate]
    end
  end

  def self.Exchange_TW_TO_CN(money, isCash = true)
    taiwan_bank = TaiwanBank.get_CN
    esun_bank = ESun.get_CN
    if  taiwan_bank[:cash_sell_rate] < esun_bank[:cash_sell_rate]
     isCash ? money / taiwan_bank[:cash_sell_rate] :  money / taiwan_bank[:cash_sell_rate]
    else
     isCash ? money / esun_bank[:selling_rate] :  money / esun_bank[:selling_rate]
    end
  end

  def self.Exchange_CN_TO_TW(money, isCash = true)
    taiwan_bank = TaiwanBank.get_CN
    esun_bank = ESun.get_CN
    if  taiwan_bank[:cash_buy_rate] > esun_bank[:cash_buy_rate]
     isCash ? money / taiwan_bank[:cash_buy_rate] :  money / taiwan_bank[:cash_buy_rate]
    else
     isCash ? money / esun_bank[:buying_rate] :  money / esun_bank[:buying_rate]
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
      selling_rate:rates['results']['JPY']['selling_rate'].to_f,
      bank_name:"Taiwan Bank JP"
    }
    bank_result
  end
  #using Async 取得日幣
  def self.async_get_JP 
    Async do 
      @jp = get_JP
    end
    @jp
  end
   
  #取得美金
  def self.get_US
     rates = refresh_bank_rate_json
     bank_result = {
      cash_buy_rate:rates['results']['USD']['cash_buy_rate'].to_f,
      cash_sell_rate:rates['results']['USD']['cash_sell_rate'].to_f,
      buying_rate:rates['results']['USD']['buying_rate'].to_f,
      selling_rate:rates['results']['USD']['selling_rate'].to_f,
      bank_name:"Taiwan Bank US"
    }
    bank_result
  end

  def self.async_get_US
    Async do 
      @us = get_US
    end
    @us
  end
 
  #取得人民幣
  def self.get_CN
    rates = refresh_bank_rate_json
    bank_result = {
     cash_buy_rate:rates['results']['CNY']['cash_buy_rate'].to_f,
     cash_sell_rate:rates['results']['CNY']['cash_sell_rate'].to_f,
     buying_rate:rates['results']['CNY']['buying_rate'].to_f,
     selling_rate:rates['results']['CNY']['selling_rate'].to_f,
     bank_name:"Taiwan Bank CN"
   }
   bank_result
  end

  def self.async_get_CN
    Async do 
      @cn = get_CN
    end
    @cn
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
    rates = refresh_bank_rate_json(3)
    bank_result = {
      cash_buy_rate:rates['result']['cash_buy_rate'].to_f,
      cash_sell_rate:rates['result']['cash_sell_rate'].to_f,
      buying_rate:rates['result']['buying_rate'].to_f,
      selling_rate:rates['result']['selling_rate'].to_f,
      buying_best_rate:rates['result']['buying_best_rate'].to_f,
      selling_best_rate:rates['result']['selling_best_rate'].to_f,
      bank_name:"ESun Bank JP"
    }
    bank_result
  end

  def self.get_US
    rates = refresh_bank_rate_json(0)
    bank_result = {
      cash_buy_rate:rates['result']['cash_buy_rate'].to_f,
      cash_sell_rate:rates['result']['cash_sell_rate'].to_f,
      buying_rate:rates['result']['buying_rate'].to_f,
      selling_rate:rates['result']['selling_rate'].to_f,
      buying_best_rate:rates['result']['buying_best_rate'].to_f,
      selling_best_rate:rates['result']['selling_best_rate'].to_f,
      bank_name:"ESun Bank US"
    }
    bank_result
  end

  def self.get_CN
    rates = refresh_bank_rate_json(1)
    bank_result = {
      cash_buy_rate:rates['result']['cash_buy_rate'].to_f,
      cash_sell_rate:rates['result']['cash_sell_rate'].to_f,
      buying_rate:rates['result']['buying_rate'].to_f,
      selling_rate:rates['result']['selling_rate'].to_f,
      buying_best_rate:rates['result']['buying_best_rate'].to_f,
      selling_best_rate:rates['result']['selling_best_rate'].to_f,
      bank_name:"ESun Bank CN"
    }
    bank_result
  end
  
  #台幣換成日幣，change_type = 0:即期 1:現金 2:優惠匯率
  def self.Exchange_TW_TO_JP(money,change_type = 0)
    if money.is_a? Numeric
      case change_type
      when 0
        money / get_JP[:selling_rate]
      when 1
        money / get_JP[:cash_sell_rate]
      else
        money / get_JP[:selling_best_rate]
      end
      
    else
     raise "請輸入數字"
    end
 end

 def self.Exchange_JP_TO_TW(money,change_type = 0)
   if money.is_a? Numeric
    case change_type
    when 0
      money * get_JP[:buying_rate]
    when 1
      money * get_JP[:cash_buy_rate]
    else
      money * get_JP[:buying_best_rate]
    end
    
  else
     raise "請輸入數字"
    end
 end

 #美金換算
 def self.Exchange_TW_TO_US(money, change_type = 0)
   if money.is_a? Numeric 
    case change_type
    when 0
      money / get_US[:selling_rate]
    when 1
      money / get_US[:cash_sell_rate]
    else
      money / get_US[:selling_best_rate]
    end
     
   else
     raise "請輸入數字"
   end
 end

 def self.Exchange_US_TO_TW(money, change_type = 0)
   if money.is_a? Numeric
    case change_type
    when 0
      money * get_US[:buying_rate]
    when 1
      money * get_US[:cash_buy_rate]
    else
      money * get_US[:buying_best_rate]
    end
   else
     raise "請輸入數字"
   end
 end

 #人民幣換算
 def self.Exchange_TW_TO_CN(money, change_type = 0)
   if money.is_a? Numeric 
    case change_type
    when 0
      money / get_CN[:selling_rate]
    when 1
      money / get_CN[:cash_sell_rate]
    else
      money / get_CN[:selling_best_rate]
    end
   else
     raise "請輸入數字"
   end
 end

 def self.Exchange_CN_TO_TW(money, change_type = 0)
   if money.is_a? Numeric 
    case change_type
    when 0
      money *  get_CN[:buying_rate] 
    when 1
      money * get_CN[:cash_buy_rate]
    else
      money * get_CN[:buying_best_rate]
    end
   else
     raise "請輸入數字"
   end
 end

  # code +7 
  private
  def self.parseNode(node,country_code)

  rates = {
    cash_buy_rate:node.css("td[data-name=即期買入匯率]")[country_code].text,
    cash_sell_rate: node.css("td[data-name=即期賣出匯率]")[country_code].text,
    buying_rate: node.css("td[data-name=現金買入匯率]")[country_code].text,
    selling_rate: node.css("td[data-name=現金賣出匯率]")[country_code].text,
    buying_best_rate: node.css("td[data-name]")[3 + country_code*7].text,
    selling_best_rate: node.css("td[data-name]")[4 + country_code*7].text,
    name: name.strip
  }
   rates
  end

  def self.refresh_bank_rate_json(country_code)
    url = "https://www.esunbank.com.tw/bank/personal/deposit/rate/forex/foreign-exchange-rates"
    html = Nokogiri::HTML(open(url)) 
    datetime = html.css("span[@id = LbQuoteTime]").text
    tableRows = html.css("table > tr > td") 
    rates = {
      update: datetime,  
      result:  parseNode(tableRows,country_code)
    }
    rates= rates.to_json
    return json = JSON.parse(rates)
  end
end


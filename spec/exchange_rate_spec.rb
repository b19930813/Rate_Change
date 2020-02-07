require "../lib/exchange_rate"
RSpec.describe ExchangeRate do
  describe "建立一個爬蟲class，爬取各大銀行的匯率" do 
    it "建立台銀class，爬取日幣匯率"
    it "建立玉山class，爬取美金匯率"
  end

  describe "匯率換算功能，將台幣換算成你想要的幣值匯率，或是將想要的幣值匯率，換算成台幣" do
    it "建立台銀class，將匯率從台幣換成日幣"
    it "建立台銀class，將匯率從日幣換成台幣"
    it "建立玉山class，將匯率從台幣換成美金"
    it "建立玉山class，將匯率從美金換成台幣"
  end

  describe "各家銀行貨幣比較" do
    it "比對台銀、玉山貨幣，找出目前匯率最低的日幣，顯示銀行名稱+當前匯率"
    it "比對台銀、玉山貨幣，找出目前匯率最高的美金，顯示銀行名稱+當前匯率"
  end

  describe "貨幣紀錄" do 
    it "以每30分鐘的頻率紀錄匯率"
  end
end

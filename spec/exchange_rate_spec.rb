require "../lib/exchange_rate"
RSpec.describe ExchangeRate do
  describe "從class TaiwanBank進行爬蟲" do 
    now_rate = TaiwanBank.get_JP
    it "確認資料型態是否正確" do 
      expect(now_rate[:cash_buy_rate].is_a? Numeric).to be true
      expect(now_rate[:cash_sell_rate].is_a? Numeric).to be true
      expect(now_rate[:buying_rate].is_a? Numeric).to be true
      expect(now_rate[:selling_rate].is_a? Numeric).to be true
    end

    it "確認資料是否跟目前台銀的售價一樣" do 
      expect(now_rate[:cash_buy_rate]).to be 0.2641
      expect(now_rate[:cash_sell_rate]).to be 0.2769
      expect(now_rate[:buying_rate]).to be 0.2714
      expect(now_rate[:selling_rate]).to be 0.2754
    end

    it "確認換算後的價格是否跟預期一樣" do 
      expect(TaiwanBank.Exchange_TW_TO_JP(100)).to be 363.1082062454612
      expect(TaiwanBank.Exchange_JP_TO_TW(10000)).to be 2713.9999999999995
    end
  end

  # describe "匯率換算功能，將台幣換算成你想要的幣值匯率，或是將想要的幣值匯率，換算成台幣" do
  #   it "建立台銀class，將匯率從台幣換成日幣"
  #   it "建立台銀class，將匯率從日幣換成台幣"
  #   it "建立玉山class，將匯率從台幣換成美金"
  #   it "建立玉山class，將匯率從美金換成台幣"
  # end

  # describe "各家銀行貨幣比較" do
  #   it "比對台銀、玉山貨幣，找出目前匯率最低的日幣，顯示銀行名稱+當前匯率"
  #   it "比對台銀、玉山貨幣，找出目前匯率最高的美金，顯示銀行名稱+當前匯率"
  # end

  # describe "貨幣紀錄" do 
  #   it "以每30分鐘的頻率紀錄匯率"
  # end
end

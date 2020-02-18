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
      expect(TaiwanBank.Exchange_TW_TO_US(100)).to be 3.3255736614566014
      expect(TaiwanBank.Exchange_US_TO_TW(100)).to be 2997.0
    end
  end

  describe "從class ESun進行爬蟲" do 
    now_rate = ESun.get_JP
    it "確認資料型態是否正確" do 
      expect(now_rate[:cash_buy_rate].is_a? Numeric).to be true
      expect(now_rate[:cash_sell_rate].is_a? Numeric).to be true
      expect(now_rate[:buying_rate].is_a? Numeric).to be true
      expect(now_rate[:selling_rate].is_a? Numeric).to be true
      expect(now_rate[:buying_best_rate].is_a? Numeric).to be true
      expect(now_rate[:selling_best_rate].is_a? Numeric).to be true
    end

    it "確認資料是否跟目前玉山的售價一樣" do 
      expect(now_rate[:cash_buy_rate]).to be 0.2717
      expect(now_rate[:cash_sell_rate]).to be 0.2757
      expect(now_rate[:buying_rate]).to be 0.2707
      expect(now_rate[:selling_rate]).to be 0.2777
      expect(now_rate[:buying_best_rate]).to be 0.273
      expect(now_rate[:selling_best_rate]).to be 0.2744
    end

    it "確認換算後的價格是否跟預期一樣" do 
      expect(ESun.Exchange_TW_TO_JP(100)).to be 359.8416696653473
      expect(ESun.Exchange_JP_TO_TW(100)).to be 27.089999999999996
      expect(ESun.Exchange_TW_TO_US(100)).to be 3.301419610432486
      expect(ESun.Exchange_US_TO_TW(100)).to be 2979.0
      expect(ESun.Exchange_JP_TO_TW(100,2)).to be 27.32
      expect(ESun.Exchange_US_TO_TW(100,2)).to be 3002.5
    end
  end

  describe "class ExchangeRate 抓取最優惠匯率" do
    it "驗證當前最優惠的匯率是否為台灣銀行" do
      expect(ExchangeRate.get_JP[:bank_name]).to be "ESun Bank JP"
    end
  end
  
end

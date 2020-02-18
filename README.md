# ExchangeRate

A simple get exchange rate  for Ruby, used to calculate and obtain exchange rates from bank in Taiwan. 



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exchange_rate_TW'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install exchange_rate_TW

## Usage

Basic usage:
```ruby
require 'exchange_rate'

TaiwanBank.get_JP 

TaiwanBank.Exchange_TW_TO_JP(money)

ESun.get_JP

ESun.Exchange_TW_TO_JP(money)
```

More detailed examples:
```ruby
require 'exchange_rate'

>> TaiwanBank.get_JP
=> {:cash_buy_rate=>0.2649, :cash_sell_rate=>0.2777, :buying_rate=>0.2722, :selling_rate=>0.2762, :bank_name=>"Taiwan Bank JP"}
>> TaiwanBank.Exchange_TW_TO_JP(2000)
=> 7235.890014471781
>> ExchangeRate.get_JP[:bank_name]
=>"ESun Bank JP"

```
## Available methods - get Exchange rate
* ``` TaiwanBank.get_JP ``` - Get Hash for Japanese yen from Taiwan bank.
* ``` TaiwanBank.get_US ``` - Get Hash for USD yen from Taiwan bank.
* ``` TaiwanBank.get_CN ``` - Get Hash for RMB yen from Taiwan bank.
* ``` TaiwanBank.Exchange_TW_TO_JP(number Money, bool IsCash) ``` - Calculate Taiwan Dollar to Japanese Yen , IsCash is using cash to calculate or not, default is true.
* ``` TaiwanBank.Exchange_JP_TO_TW(number Money, bool IsCash) ``` - Calculate Japanese Yen to Taiwan Dollar , IsCash is using cash to calculate or not, default is true.
* ``` TaiwanBank.Exchange_TW_TO_US(number Money, bool IsCash) ``` - Calculate Taiwan Dollar to USD , IsCash is using cash to calculate or not, default is true.
* ``` TaiwanBank.Exchange_US_TO_TW(number Money, bool IsCash) ``` - Calculate USD to Taiwan Dollar , IsCash is using cash to calculate or not, default is true.
* ``` TaiwanBank.Exchange_TW_TO_CN(number Money, bool IsCash) ``` - Calculate Taiwan Dollar to RMB , IsCash is using cash to calculate or not, default is true.
* ``` TaiwanBank.Exchange_CN_TO_TW(number Money, bool IsCash) ``` - Calculate RMB to Taiwan Dollar , IsCash is using cash to calculate or not, default is true.
* ``` ESun.Exchange_TW_TO_JP(number Money, number type) ``` - Calculate Taiwan Dollar to Japanese Yen.   
type:0 Spot exchange rate  
type:1 Cash  
type:2 Internet banking 

TaiwanBank can be changed to ESun or ExchangeRate , but method - Exchange is different TaiwanBank with ESun. 
TaiwanBank : https://rate.bot.com.tw/xrt?Lang=zh-TW  
ESun: https://www.esunbank.com.tw/bank/personal/deposit/rate/forex/foreign-exchange-rates  
ExchangeRate: return back of the lowest cash_sell_rate


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/b19930813/exchange_rate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/b19930813/exchange_rate/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ExchangeRate project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/b19930813/exchange_rate/blob/master/CODE_OF_CONDUCT.md).

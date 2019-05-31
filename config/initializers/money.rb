require 'money'

Money.default_currency = Money::Currency.new('USD')
Money.disallow_currency_conversion!
Money.locale_backend = :i18n

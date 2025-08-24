# Acme Widget Co

A clean Ruby implementation of a shopping basket for **Acme Widget Co**.
It models products, delivery rules, and promotional offers with a focus on separation of concerns, extensibility, and correctness in money handling.


## Features

* **Products**

  * `R01` Red Widget – \$32.95
  * `G01` Green Widget – \$24.95
  * `B01` Blue Widget – \$7.95
* **Delivery rules**

  * Subtotal < \$50 → \$4.95
  * \$50 ≤ Subtotal < \$90 → \$2.95
  * Subtotal ≥ \$90 → Free delivery
  * Delivery is always free if the payable subtotal is zero (empty basket or full discount).
* **Offer rules**

  * Buy one Red Widget (`R01`), get the second half price.
    Applied per pair. Odd item remains full price.
* **Safe money handling** using `BigDecimal` with two-decimal retail rounding.
* **Extensible design**

  * New offers = new strategy classes under `pricing/offers/`.
  * Delivery policies are data-driven via tiers.

## Installation

1. Clone or download the repo.
2. Install Ruby (3.1+ recommended).
3. Install dependencies:

   ```bash
   bundle install
   ```

## Usage

### Demo script

Run the demo interactively:

```bash
bin/demo
```

Or pass product codes directly:

```bash
bin/demo R01 R01 G01
bin/demo "B01,G01"
```

### Expected outputs

```text
$ bin/demo R01 R01
Basket items: R01, R01
Total: $54.37
```

## Running tests

RSpec is included:

```bash
bundle exec rspec
```

All provided scenarios and edge cases are covered.

## Project structure

```
lib/
  acme.rb                # public entrypoint
  acme/
    basket.rb            # orchestrates subtotal, discounts, delivery
    version.rb
    support/             # helpers and errors
      money.rb
      errors.rb
    domain/              # product model and catalogue
      product.rb
      catalogue.rb
    pricing/             # pricing policies
      delivery_rules.rb
      offers/
        offer.rb
        buy_one_get_second_half.rb
bin/
  demo                   # CLI demo
spec/
  spec_helper.rb
  basket_spec.rb         # RSpec tests
```

# SGMailer

SG Mailer is a mailing framework with similar to Action Mailer interface for SendGrid
transactional emails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sg_mailer'
```

## Usage

To start using the framework, you need to configure it first. It requires a
SendGrid API KEY, which you can setup like this:

```ruby
SGMailer.configure(api_key: ENV['SENDGRID_API_KEY')
```

Once setup, you can use SG Mailer alongside or as a replacement to Action
Mailer. Creating a base mailer (a class like `ApplicationMailer`) is a good
starting point.

```ruby
# app/mailers/sendgrid_mailer.rb

class SendGridMailer < SGMailer::Base
  # you may wanna include helper modules here, as they are not automgically
  # included like in action mailer.
end
```

Having the base mailer around, you may start introducing specific ones.

```ruby
class SubscriptionMailer < ApplicationMailer
  def successful_subscription_mail(parent, kid)
    template_id = 'd6c0eb74-b280-4d25-a835-479818a450e8'

    substitutions = {
      'KIDNAME' => kid.name
      'PARENTTYPE' => parent.gender
    }

    mail from: 'charlie@bp.com', to: parent.email,
         template_id: template_id, substitutions : substitutions
  end
end
```

Working with transaction emails, you are quite likely to use templates for
them. Since this is so common, there is nice interface for annotating the
emails with the template id.

```ruby
class SubscriptionMailer < ApplicationMailer
  template_id 'd6c0eb74-b280-4d25-a835-479818a450e8'
  def successful_subscription_mail(parent, kid)
    substitutions = {
      'KIDNAME' => kid.name
      'PARENTTYPE' => parent.gender
    }

    mail from: 'charlie@bp.com', to: parent.email,
         substitutions : substitutions
  end
end
```

You can also extract the common sender into a default value like so:

```ruby
class SubscriptionMailer < ApplicationMailer
  default from: { name: 'Charlie Brown', email: 'charlie@bp.com' }

  template_id 'd6c0eb74-b280-4d25-a835-479818a450e8'
  def successful_subscription_mail(parent, kid)
    substitutions = {
      'KIDNAME' => kid.name
      'PARENTTYPE' => parent.gender
    }

    mail to: parent.email, substitutions : substitutions
  end
end
```

In fact the base mailer (`SendGridMailer`) is a good place to define such
defaults.

```ruby
# app/mailers/sendgrid_mailer.rb

class SendGridMailer < SGMailer::Base
  default from: { name: 'Charlie Brown', email: 'charlie@bp.com' }
end
```

We were able to clean a lot of cruft from the mailers above, however, can we do
something about the substitutions. They do seem to have noisy API. Let's think
about Ruby instance variables. The Rails controller to view integration uses
them as an API and it works pretty well.


```ruby
# app/mailers/sendgrid_mailer.rb

class SendGridMailer < SGMailer::Base
  default from: { name: 'Charlie Brown', email: 'charlie@bp.com' }

  private

  # This is the hook that processes the options given to `SGMailer::Base#mail`.
  # Don't forget to call super and return a Hash in here.
  def normalize_options(options)
    automatic_substitutions = instance_values.transform_keys do |key|
      "#{key.to_s.remove('_').upcase}"
    end

    super.deep_merge(substitutions: automatic_substitutions)
  end
end
```

With the code above the mails can look pretty tidy.

```ruby
class SubscriptionMailer < ApplicationMailer
  template_id 'd6c0eb74-b280-4d25-a835-479818a450e8'
  def successful_subscription_mail(parent, kid)
    @kid_name = kid.name
    @parent_type = parent.gender

    mail to: parent.email
  end
end
```

We don't conventionalize the substitutions, because their format varies from
team to team. When you settle on one, you can easily turn your instance
variables into proper substitutions, should you want to. And you know you want
to!

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).

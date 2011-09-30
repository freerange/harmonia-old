Harmonia
========

At Free Range everyone is responsible for everything, but who is responsible for delegating work so everything gets done? CHAOS.

Background
----------

One of the things that separates us from typical companies is that we don't operate within a hierarchy, or with a fixed set of roles.

We don't divide the business responsibilities in arbitrary ways; none of us want to be an accountant or an office manager. We're not a big enough company to require any dedicated staff to grease the wheels of our organisation. That's by design.

But **shit still needs to get done**, so rather than waste energy discussing or rota planning each chore, we use this software to automatically delegate those chores within the team.


### Can't people just remember, or decide between themselves on an ad-hoc basis?

Not really, no. We've learned that by sacrificing a bit of individual freedom, you actually liberate much more of your energy and focus for the important (and more enjoyable) aspects of your business.

Instead of wasting any time trying to remember who did what last week and then assign duties for this week, we don't even think about it until Harmonia sends us our assignments.

This is really the key insight: when dealing with the boring responsibilities or chores in life, **automate as much as possible**, then work hard to **eliminate thought and decision making** surrounding the rest.


### Why not a rota?

A rota may be functionally equivalent, but rotas need to be maintained and updated. Chaos is an eternal fountain. More seriously, we value the ability to run without maintenance over absolute fairness.

There's also something to be said for more aggressive repetition than a rota would provide; if I end up having to run the invoices three times in a row, I'm going to be in a better position to spot further automation opportunities than if it was a task I only did every other month. And then everyone wins.


### What kind of tasks are suitable?

Anything that can be reduced to a clear set of instructions with minimal amount of decision making. Processing bank information, sending invoices, and assigning temporary responsibilities (like weeknotes) are ideal.


Under the hood
-----

Harmonia uses cron and emails, via the `whenever` and `mail` gems. Mail templates are stored as `.erb` files. Currently assignments are made at noon on Monday each week, as dictated by `config/schedule.rb`.


Deployment Notes
-----

At the moment this is clearly tailored towards our company, and this may always be the case.

Some configuration should be provided via environment variables. These can be set via the `env` recipes that `recap` provides:

- HARMONIA_PEOPLE - A comma-separated list of people to assign to, e.g. "Tom, James A, James M, Chris, Jase"
- SMTP_PASSWORD - the password for the email account used to dispatch emails
- FREEAGENT_DOMAIN - the subdomain of FreeAgent
- FREEAGENT_EMAIL - the email address to log in to FreeAgent with
- FREEAGENT_PASSWORD - the password for the FreeAgent account
Fortunately anyone can be told what the matrix really is.

Installing
===
download && install ruby
download && install rubygems
download && install mongodb

$ gem install bundler
$ bundle install

Configure
===

Get an API token for the CCO API (talk to HQ).
Copy the file `config/cco.yml.dist` to `config/cco.yml` and update the infomration in there.

Seeding
===
bundle exec rake db:drop RAILS_ENV=production
bundle exec rake crewsleep:seed_places[2015_winter] RAILS_ENV=production
bundle exec rake crewsleep:sort_places RAILS_ENV=production

Running
===
For devs
---
$ rails server

Prod
---
$ ./start



BUGS
====
Tar fel user ibland. T.ex Fritz blir Fritz_Sprangballe

TODO
====
* En klocka på bordet
* Varning vid dubbelbokning
* Meddelande till användare som visas när de loggar in med optional blocking option som vi måste cleara (för att tvinga dem prata med oss)
* Kryssruta när man bokar plats att man är svårväckt, alt. ett fritextmeddelande
* Någon typ av larm varje halvtimme det är något att väcka. (hårdvarubaserad blink/signal, eller kanske flasha väckskärmen)
* Se lediga platser
* Se dubbelbokade platser
* Varna för dubbelbokning när man bokar
* Färgkoder för typer av alarm (viktig för nästa punkt)
* Sortera in pokes bland väckningarna
* Statistik
* Facebookintegration
* Inverterade färger "så man slipper ha en ficklampa i ansiktet"

<p align="center">
  <img src="https://github.com/thehammer/sleepwatching/blob/master/web/static/assets/images/header.png?raw=true" alt="SleepWatching"/>
</p>

This app is a work in progress!

SleepWatching will turn off your television when you fall asleep. Currently this requires you to be using a modern Sony TV
and a SleepNumber bed. It uses SSDP to discover the TV and IRCC to turn it off. The bed is monitored via SleepIQ. Development
is ongoing, and currently the application stops just short of utilizing sleep data, in advance of detecting when you fall
asleep.

<p align="center">
  <img src="https://github.com/thehammer/sleepwatching/blob/master/web/static/assets/images/screenshot1.png?raw=true" alt="SSDP"/>
</p>

<p align="center">
  <img src="https://github.com/thehammer/sleepwatching/blob/master/web/static/assets/images/screenshot2.png?raw=true" alt="IRCC"/>
</p>

<p align="center">
  <img src="https://github.com/thehammer/sleepwatching/blob/master/web/static/assets/images/screenshot3.png?raw=true" alt="SleepIQ"/>
</p>

# Running the app

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

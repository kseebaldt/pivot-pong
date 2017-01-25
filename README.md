[![Build Status](https://travis-ci.org/slackersoft/pivot-pong.svg?branch=master)](https://travis-ci.org/slackersoft/pivot-pong)

Welcome to the World of Office Gaming
========

Originally forked from [Sean Moon](https://github.com/seanmoon/pivot-pong), this app was created to provide a ladder ranking for internal ping pong matches. However, this can be repurposed for any kind of competitive play, and you are encouraged to fork your own version customary to your gameplay. See the live demo [HERE](http://pong-tester.herokuapp.com/). Play around with that as much as you like!

Creation of Players
-------
As you start entering the names for the winner/loser on /matches, it will auto complete if the player already exists. If not, they will be created. Each player also has their own profile page in which they can see their current win/loss record, match history, current achievements, rank history, and probability of beating another player. In order to support profile image uploading, you need to set the environment vars that carrierwave expects: ENV['AWS_KEY'], ENV['AWS_SECRET'] and ENV['AWS_BUCKET']

Ladder Ranking
-------
Rank is calculated after each match is entered. The way that you move up is by beating somebody who has a higher rank than you, and the amount of spots you move is half the distance between ranks. If you are immediately below the person that you are playing, you will switch spots if you win. This means that only second place can dethrone first place.

Achievements
-------
Achievement checking is trigger based. Most of the time the achievements will revolve around the outcome of a match, but there are others that can be obtained outside of entering a match. For example, tweeting a victory or uploading a profile picture. The achievements model is mixed into [font awesome](http://fortawesome.github.com/Font-Awesome/) so your badge list can be extended to any of those as you can see through implementing any of the subclasses. Current list of achievement at the time of writing this are:

- *Twilight Saga* - Log a match after 6pm PST
- *Overly Attached* - Last 6 matches were with the same person
- *The Grind* - Play 5 consecutive matches without changing rank
- *Number Juan* - Dos no es un ganador y tres nadie recuerda
- *Bragging Rights* - Tweet Your Victory
- *Laying Out the Welcome Mat* - Play someone not on the ladder
- *Hulk Smash* - Overall win record vs. someone spreads 10 or more
- *Where'd You Go?* - Gone inactive after 30 days of not playing
- *I Heart You* - Last 3 logged matches were with the same person
- *Morning Madness* - Log a match before 9am PST
- *You're on a Streak!* - Win 5 matches in a row
- *Long Jump* - Advances more than 3 spots in rank from a single match
- *Little Ben!* - Played more than 50 matches
- *When Life Gives You Lemons...* - Lose 5 matches in a row
- *Big Ben!* - Played more than 100 matches
- *Working Hard or Hardly Working?* - Log more than 5 matches in a single day
- *Picture Perfect* - Upload an avatar in your user profile
- *Beginner* - Welcome to the wonderful game of pong
- *Same Sh*t, Different Day* - Stay the same rank 7 matches in a row

Totem Pole
-------
On every player's show page there exists a totem pole. You are able to 'capture' another players totem by having your last recorded match resulting in a win. (may be changed later to reflect overall record between specific player in order to capture their totem)

Analytics
-------
At the end of every match, a match log is also created and bound to each of the players. This records the match as well as what the players current rank was at the time of play. You can also see overall win percentage globally at /stats. Played around a little using the [raphael.js](http://raphaeljs.com/) library.

Authentication
-------
This was purposely made to have very light security that can be toggled on the public side.

PUBLIC

If you set *ENV['username']* and *ENV['password']*, this enables http auth. Other people are free to check out read only pages without access to any pages where you can post, unless you authenticate. Public pages include the list of achievements, what's new, and global stats.

ADMIN

The admin pages also have http auth which can be set by **ENV['admin_username']** and **ENV['admin_password']**. They default to admin/pingpong respectively and is always enabled. This is accessible from '/admin'

Admin
=======

Posts
-------
Want to let others know what kind of updates are going with your app? New achievements? New features? Upcoming releases? 'admin/posts'

Players
-------
Manage your players 'admin/players'

Players
-------
Manage your matches 'admin/matches'

Site Settings
-------
Ability to set custom colors for links, background, and borders in admin/site_settings

Configuration
-------
There are a number of configurations that can be set in order to customize your app to your specific company or whatever:

- *ENV['logo_url']* - can dump a url in here or will just default to logo.png (currently my company logo)
- *ENV['username']* - username for http auth on access to post pages/actions
- *ENV['password']* - password for http auth on access to post pages/actions
- *ENV['admin_username']* - username for http auth on access to /admin
- *ENV['admin_password']* - password for http auth on access to /admin
- *ENV['pong_location']* - This appears in the header title and will default to SF. Geared more towards offices with multiple locations

Welcome all comments and feedback (Twitter): [@barretto_chris](http://twitter.com/barretto_chris)

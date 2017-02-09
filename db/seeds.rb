# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#
# <Match id: 1, winner: "Adam", loser: "Bob", created_at: "2011-07-08 00:21:06", updated_at: "2011-07-08 00:21:06", occurred_at: "2011-07-07 20:20:59">
#
alpha = Player.create(name: "Alpha Chen")
greg = Player.create(name: "Greg Chattin-McNichols")
gregg = Player.create(name: "Gregg Van Hove")
noah = Player.create(name: "Noah Denton")
Match.create(winner: alpha, loser: greg, occurred_at: "2016-01-21")
Match.create(winner: greg, loser: gregg, occurred_at: "2016-01-21")
Match.create(winner: gregg, loser: noah, occurred_at: "2016-01-21")
Match.create(winner: noah, loser: alpha, occurred_at: "2016-01-21")
Match.create(winner: greg, loser: alpha, occurred_at: 1.days.ago)
Match.create(winner: greg, loser: gregg, occurred_at: 1.days.ago)
jackpot = Match.create(winner: greg, loser: noah, occurred_at: 1.days.ago)

Beginner.create(player: greg, match: jackpot)
BigBen.create(player: greg, match: jackpot)
BraggingRights.create(player: greg, match: jackpot)
Grind.create(player: greg, match: jackpot)
HeadHunter.create(player: greg, match: jackpot)
HeartYou.create(player: greg, match: jackpot)
HulkSmash.create(player: greg, match: jackpot)
Inactive.create(player: greg, match: jackpot)
Lemons.create(player: greg, match: jackpot)
LittleBen.create(player: greg, match: jackpot)
LongJump.create(player: greg, match: jackpot)
MorningMadness.create(player: greg, match: jackpot)
NumberJuan.create(player: greg, match: jackpot)
OverlyAttached.create(player: greg, match: jackpot)
PicturePerfect.create(player: greg, match: jackpot)
SameShtDifferentDay.create(player: greg, match: jackpot)
Streak.create(player: greg, match: jackpot)
TwilightSaga.create(player: greg, match: jackpot)
WelcomeMat.create(player: greg, match: jackpot)
WorkingHard.create(player: greg, match: jackpot)

from monopoly_classes import Interface, Game, Player, Start, Prison, Chart, Go_to_prison, Power_plant, Space, City, Airport, Tax_space, NameTooLongError, WrongSpacesNumberError, NoPrisonSpaceError, NoStartSpaceError, TooManyPrisonSpacesError, TooManyStartSpacesError
import pytest

greece_fees = {
    "0": 10,
    "1": 40,
    "2": 120,
    "3": 360,
    "4": 640,
    "hotel": 900
}

normal_italy_fees = {
    "0": 15,
    "1": 60,
    "2": 180,
    "3": 540,
    "4": 800,
    "hotel": 1100
}

capital_italy_fees = {
    "0": 20,
    "1": 80,
    "2": 200,
    "3": 600,
    "4": 900,
    "hotel": 1200

}
normal_spain_fees = {
    "0": 20,
    "1": 100,
    "2": 300,
    "3": 900,
    "4": 1250,
    "hotel": 1500
}
capital_spain_fees = {
    "0": 25,
    "1": 120,
    "2": 360,
    "3": 1000,
    "4": 1400,
    "hotel": 1800
}
normal_england_fees = {
    "0": 30,
    "1": 140,
    "2": 400,
    "3": 1100,
    "4": 1500,
    "hotel": 1900
}
capital_england_fees = {
    "0": 35,
    "1": 160,
    "2": 440,
    "3": 1200,
    "4": 1600,
    "hotel": 2000
}
normal_netherlands_fees = {
    "0": 35,
    "1": 180,
    "2": 500,
    "3": 1400,
    "4": 1750,
    "hotel": 2100
}
capital_netherlands_fees = {
    "0": 40,
    "1": 200,
    "2": 600,
    "3": 1500,
    "4": 1850,
    "hotel": 2200
}
normal_sweden_fees = {
    "0": 45,
    "1": 220,
    "2": 660,
    "3": 1600,
    "4": 1950,
    "hotel": 2300
}
capital_sweden_fees = {
    "0": 50,
    "1": 240,
    "2": 720,
    "3": 1700,
    "4": 2050,
    "hotel": 2400
}
normal_germany_fees = {
    "0": 55,
    "1": 260,
    "2": 780,
    "3": 1900,
    "4": 2200,
    "hotel": 2550
}
capital_germany_fees = {
    "0": 60,
    "1": 300,
    "2": 900,
    "3": 2000,
    "4": 2400,
    "hotel": 2800
}
insbruck_fees = {
    "0": 70,
    "1": 350,
    "2": 1000,
    "3": 2200,
    "4": 2600,
    "hotel": 3000
}
vien_fees = {
    "0": 100,
    "1": 400,
    "2": 1200,
    "3": 2800,
    "4": 3400,
    "hotel": 4000
}

start = Start("Start")
thessaloniki = City("Thessaloniki", 120, "Greece", greece_fees, 1)
athenes = City("Athenes", 120, "Greece", greece_fees, 1)
guarded_parking = Tax_space("Guarded parking", 400)
southern_airport = Airport("Southern Airport", 400)
neapol = City("Neapol", 200, "Italy", normal_italy_fees, 1)
mediolan = City("Mediolan", 200, "Italy", normal_italy_fees, 1)
rome = City("Rome", 240, "Italy", capital_italy_fees, 1)
prison = Prison("Prison")
barcelona = City("Barcelona", 280, "Spain", normal_spain_fees, 2)
nuclear_power_plant = Power_plant("Nuclear power plant", 300)
sewilla = City("Sewilla", 280, "Spain", normal_spain_fees, 2)
madrid = City("Madrid", 320, "Spain", capital_spain_fees, 2)
western_airport = Airport("Western Airport", 400)
liverpool = City("Liverpool", 360, "England", normal_england_fees, 2)
glasgow = City("Glasgow", 360, "England", normal_england_fees, 2)
london = City("London", 400, "England", capital_england_fees, 2)
free_parking = Space("Free parking")
rotterdam = City("Rotterdam", 440, "Netherlands", normal_netherlands_fees, 3)
haga = City("Haga", 440, "Netherlands", normal_netherlands_fees, 3)
amsterdam = City("Amsterdam", 480, "Netherlands", capital_netherlands_fees, 3)
northern_airport = Airport("Northern Airport", 400)
malmo = City("Malmo", 520, "Sweden", normal_sweden_fees, 3)
goteborg = City("Goteborg", 520, "Sweden", normal_sweden_fees, 3)
stockholm = City("Stockholm", 560, "Sweden", capital_sweden_fees, 3)
go_to_prison = Go_to_prison("Go-to-prison space")
water_power_plant = Power_plant("Water power plant", 300)
frankfurt = City("Frankfurt", 600, "Germany", normal_germany_fees, 4)
colony = City("Colony", 600, "Germany", normal_germany_fees, 4)
berlin = City("Berlin", 640, "Germany", capital_germany_fees, 4)
eastern_airport = Airport("Eastern Airport", 400)
insbruck = City("Insbruck", 700, "Austria", insbruck_fees, 4)
tax = Tax_space("Tax space", 200)
vien = City("Vien", 800, "Austria", vien_fees, 4)
spaces = [start, thessaloniki, athenes, guarded_parking, southern_airport, neapol, mediolan, rome, prison, barcelona, nuclear_power_plant, sewilla, madrid, western_airport, liverpool, glasgow, london, free_parking, rotterdam, haga, amsterdam, northern_airport, malmo, goteborg, stockholm, go_to_prison, water_power_plant, frankfurt, colony, berlin, eastern_airport, insbruck, tax, vien]
chart = Chart(spaces)


def generate_players_and_game():
    for space in chart.spaces:
        if type(space) == Start:
            start_index = chart.spaces.index(space)
    simon = Player("Simon", "*", start_index)
    ann = Player("Ann", "&", start_index)
    robert = Player("Robert", "§", start_index)
    susan = Player("Susan", "@", start_index)
    game = Game([simon, ann, robert, susan], chart)
    return simon, ann, robert, susan, game


def test_init_Player():
    simon = generate_players_and_game()[0]
    assert simon.name == "Simon"
    assert simon.pawn == "*"
    assert simon.money == 3000
    assert simon.cities == []
    assert simon.power_plants == []
    assert simon.airports == []
    assert not simon.in_prison
    assert simon.space_index == 0
    assert simon.rounds_in_prison == 0
    assert not simon.is_lost


def test_imprisonate_and_set_free():
    simon = generate_players_and_game()[0]
    game = generate_players_and_game()[4]
    simon.imprisonate(game)
    assert simon.in_prison
    assert simon.space_index == 8
    assert simon.rounds_in_prison == 0
    simon.set_free()
    assert not simon.in_prison
    assert simon.space_index == 8
    assert simon.rounds_in_prison == 0


def test_roll_dices():
    ann = Player("Ann", "&", 0)
    assert ann.roll_dices()[0] in [1, 2, 3, 4, 5, 6]
    assert ann.roll_dices()[1] in [1, 2, 3, 4, 5, 6]


def test_check_prison():
    simon = generate_players_and_game()[0]
    game = generate_players_and_game()[4]
    assert not simon.check_prison()
    simon.imprisonate(game)
    simon.rounds_in_prison = 2
    assert simon.check_prison() == "You are in prison, so you cannot do any actions. This is round 3 spent in prison."
    simon.rounds_in_prison = 3
    assert simon.check_prison() == "Third round in prison has passed. You are now free."
    assert not simon.in_prison
    assert simon.rounds_in_prison == 0


def test_player_looses():
    ann = generate_players_and_game()[1]
    northern_airport.is_bought = True
    western_airport.is_bought = True
    water_power_plant.is_bought = True
    thessaloniki.is_bought = True
    athenes.is_bought = True
    western_airport.is_mortgaged = True
    vien.is_bought = True
    insbruck.is_bought = True
    athenes.houses == 3
    thessaloniki.houses == 3
    vien.hotel = 1
    insbruck.hotel = 1
    ann.airports = [northern_airport, western_airport]
    ann.power_plants = [water_power_plant]
    ann.cities = [thessaloniki, athenes, vien, insbruck]
    ann.player_looses()
    assert ann.airports == []
    assert ann.power_plants == []
    assert ann.cities == []
    assert not thessaloniki.is_bought
    assert not athenes.is_bought
    assert not western_airport.is_bought
    assert not northern_airport.is_bought
    assert not water_power_plant.is_bought
    assert not western_airport.is_mortgaged
    assert not vien.is_bought
    assert not insbruck.is_bought
    assert athenes.houses == 0
    assert thessaloniki.houses == 0
    assert vien.hotel == 0
    assert insbruck.hotel == 0
    assert ann.is_lost


def test_init_space():
    assert free_parking.name == "Free parking"
    assert type(free_parking) == Space


def test_space_name_20():
    with pytest.raises(NameTooLongError) as error:
        spc = Space("gggggggggggggggggggg")
    assert error.value.message == "Name of the space cannot be longer than 19."


def test_space_event():
    assert free_parking.event() == "You are on Free parking. No need to pay."


def test_init_Start():
    assert start.name == "Start"
    assert type(start) == Start


def test_start_event():
    assert start.event() == "You are on Start. No need to pay."


def test_init_Prison():
    assert prison.name == "Prison"
    assert type(prison) == Prison


def test_prison_event():
    assert prison.event() == "You are on Prison. No need to pay."


def test_go_to_prison_init():
    assert go_to_prison.name == "Go-to-prison space"
    assert type(go_to_prison) == Go_to_prison


def test_go_to_prison_event():
    simon = generate_players_and_game()[0]
    game = generate_players_and_game()[4]
    assert go_to_prison.event(simon, game) == "Now you are in prison for 3 rounds."
    assert simon.in_prison
    assert simon.space_index == 8
    assert simon.rounds_in_prison == 0


def test_tax_init():
    assert guarded_parking.name == "Guarded parking"
    assert guarded_parking.fee == 400
    assert type(guarded_parking) == Tax_space


def test_tax_event():
    ann = generate_players_and_game()[1]
    assert tax.event(ann) == (ann, None, 200)


def test_init_city():
    assert type(liverpool) == City
    assert liverpool.name == "Liverpool"
    assert liverpool.price == 360
    assert liverpool.country == "England"
    assert liverpool.fees == normal_england_fees
    assert liverpool.area == 2
    assert liverpool.hotel == 0
    assert liverpool.houses == 0
    assert liverpool.mortgage == 180
    assert not liverpool.is_mortgaged
    assert not liverpool.is_bought


def test_city_calculate_fee():
    vien.houses = 1
    thessaloniki.hotel = 1
    assert vien.calculate_fee() == 400
    assert thessaloniki.calculate_fee() == 900
    vien.houses = 0
    thessaloniki.hotel = 0


def test_calculate_house_price():
    assert vien.calculate_house_price() == 400


def test_city_event_unbought_yes(monkeypatch):
    def yes(sf, sd, fds):
        return True
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = generate_players_and_game()[4]
    interface = Interface(game)
    monkeypatch.setattr('monopoly_classes.Interface.buy_yes_or_no', yes)
    assert thessaloniki.event(robert, game, interface) == "You have bought Thessaloniki."
    assert robert.money == 2880
    assert thessaloniki.is_bought
    assert robert.cities == [thessaloniki]
    susan.money = 15
    assert haga.event(susan, game, interface) == "It is unbought and costs 440$. You have 15$. You do not have enough money to buy it."
    assert susan.money == 15
    assert not haga.is_bought
    assert susan.cities == []
    thessaloniki.is_bought = False


def test_city_event_unbought_no(monkeypatch):
    def no(sg, sjnsj, aj):
        return False
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = generate_players_and_game()[4]
    interface = Interface(game)
    monkeypatch.setattr('monopoly_classes.Interface.buy_yes_or_no', no)
    assert thessaloniki.event(robert, game, interface) == "You have not bought Thessaloniki."
    assert robert.money == 3000
    assert not thessaloniki.is_bought
    assert robert.cities == []
    susan.money = 15
    assert haga.event(susan, game, interface) == "It is unbought and costs 440$. You have 15$. You do not have enough money to buy it."
    assert susan.money == 15
    assert not haga.is_bought
    assert susan.cities == []


def test_city_event_bought():
    simon = generate_players_and_game()[0]
    ann = generate_players_and_game()[1]
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = Game([simon, ann, robert, susan], chart)
    interface = Interface(game)
    robert.cities = [goteborg, rome]
    goteborg.is_bought = True
    assert goteborg.event(robert, game, interface) == "It is yours."
    assert goteborg.event(susan, game, interface) == (susan, robert, 45)
    goteborg.is_mortgaged = True
    assert goteborg.event(robert, game, interface) == "It is yours."
    assert goteborg.event(susan, game, interface) == "It is mortgaged, so you do not have to pay the fee."
    goteborg.is_bought = False
    goteborg.is_mortgaged = False


def test_city_sell():
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    robert.cities = [rome]
    rome.is_bought = True
    rome.houses = 2
    assert rome.sell(robert) == "You cannot sell a city with buildings."
    rome.houses = 0
    assert rome.sell(robert) == 'Rome has been sold. Your balance is 3240$.'
    assert robert.cities == []
    assert not rome.is_bought
    assert rome.sell(susan) == "No such city in your inventory."


def test_init_airport():
    assert type(northern_airport) == Airport
    assert northern_airport.name == "Northern Airport"
    assert not northern_airport.is_bought
    assert not northern_airport.is_mortgaged
    assert northern_airport.price == 400
    assert northern_airport.mortgage == 200


def test_airport_calculate_fee():
    robert = generate_players_and_game()[2]
    ann = generate_players_and_game()[1]
    robert.airports = [northern_airport]
    ann.airports = [southern_airport, western_airport, eastern_airport]
    assert northern_airport.calculate_fee(robert) == 50
    assert southern_airport.calculate_fee(ann) == 200


def test_airport_event_unbought_yes(monkeypatch):
    def yes(sf, sd, fds):
        return True
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = generate_players_and_game()[4]
    interface = Interface(game)
    monkeypatch.setattr('monopoly_classes.Interface.buy_yes_or_no', yes)
    assert southern_airport.event(robert, game, interface) == "You have bought Southern Airport."
    assert robert.money == 2600
    assert southern_airport.is_bought
    assert robert.airports == [southern_airport]
    susan.money = 15
    assert eastern_airport.event(susan, game, interface) == "It is unbought and costs 400$. You have 15$. You do not have enough money to buy it."
    assert susan.money == 15
    assert not eastern_airport.is_bought
    assert susan.airports == []
    southern_airport.is_bought = False


def test_airport_event_unbought_no(monkeypatch):
    def no(sg, sjnsj, aj):
        return False
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = generate_players_and_game()[4]
    interface = Interface(game)
    monkeypatch.setattr('monopoly_classes.Interface.buy_yes_or_no', no)
    assert southern_airport.event(robert, game, interface) == "You have not bought Southern Airport."
    assert robert.money == 3000
    assert not southern_airport.is_bought
    assert robert.airports == []
    susan.money = 15
    assert eastern_airport.event(susan, game, interface) == "It is unbought and costs 400$. You have 15$. You do not have enough money to buy it."
    assert susan.money == 15
    assert not eastern_airport.is_bought
    assert susan.airports == []


def test_airport_event_bought():
    simon = generate_players_and_game()[0]
    ann = generate_players_and_game()[1]
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = Game([simon, ann, robert, susan], chart)
    interface = Interface(game)
    robert.airports = [eastern_airport]
    eastern_airport.is_bought = True
    assert eastern_airport.event(robert, game, interface) == "It is yours."
    assert eastern_airport.event(susan, game, interface) == (susan, robert, 50)
    eastern_airport.is_mortgaged = True
    assert eastern_airport.event(robert, game, interface) == "It is yours."
    assert eastern_airport.event(susan, game, interface) == "It is mortgaged, so you do not have to pay the fee."
    eastern_airport.is_bought = False
    eastern_airport.is_mortgaged = False


def test_airport_sell():
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    robert.airports = [western_airport]
    western_airport.is_bought = True
    assert western_airport.sell(robert) == 'Western Airport has been sold. Your balance is 3400$.'
    assert robert.airports == []
    assert not western_airport.is_bought
    assert western_airport.sell(susan) == "No such airport in your inventory."


def test_init_power_plant():
    assert type(water_power_plant) == Power_plant
    assert water_power_plant.name == "Water power plant"
    assert not water_power_plant.is_bought
    assert not water_power_plant.is_mortgaged
    assert water_power_plant.price == 300
    assert water_power_plant.mortgage == 150


def test_power_plant_calculate_fee():
    robert = generate_players_and_game()[2]
    robert.power_plants = [nuclear_power_plant, water_power_plant]
    assert nuclear_power_plant.calculate_fee(robert, 10) == 200


def test_power_plant_event_unbought_yes(monkeypatch):
    def yes(sf, sd, fds):
        return True
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = generate_players_and_game()[4]
    interface = Interface(game)
    monkeypatch.setattr('monopoly_classes.Interface.buy_yes_or_no', yes)
    assert water_power_plant.event(robert, game, interface) == "You have bought Water power plant."
    assert robert.money == 2700
    assert water_power_plant.is_bought
    assert robert.power_plants == [water_power_plant]
    susan.money = 15
    assert nuclear_power_plant.event(susan, game, interface) == "It is unbought and costs 300$. You have 15$. You do not have enough money to buy it."
    assert susan.money == 15
    assert not nuclear_power_plant.is_bought
    assert susan.power_plants == []
    water_power_plant.is_bought = False


def test_power_plant_event_unbought_no(monkeypatch):
    def no(sg, sjnsj, aj):
        return False
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = generate_players_and_game()[4]
    interface = Interface(game)
    monkeypatch.setattr('monopoly_classes.Interface.buy_yes_or_no', no)
    assert water_power_plant.event(robert, game, interface, 10) == "You have not bought Water power plant."
    assert robert.money == 3000
    assert not water_power_plant.is_bought
    assert robert.power_plants == []
    susan.money = 15
    assert water_power_plant.event(susan, game, interface, 10) == "It is unbought and costs 300$. You have 15$. You do not have enough money to buy it."
    assert susan.money == 15
    assert not water_power_plant.is_bought
    assert susan.power_plants == []


def test_power_plant_event_bought():
    simon = generate_players_and_game()[0]
    ann = generate_players_and_game()[1]
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = Game([simon, ann, robert, susan], chart)
    interface = Interface(game)
    robert.power_plants = [nuclear_power_plant]
    nuclear_power_plant.is_bought = True
    assert nuclear_power_plant.event(robert, game, interface, 10) == "It is yours."
    assert nuclear_power_plant.event(susan, game, interface, 10) == (susan, robert, 100)
    nuclear_power_plant.is_mortgaged = True
    assert nuclear_power_plant.event(robert, game, interface, 10) == "It is yours."
    assert nuclear_power_plant.event(susan, game, interface, 10) == "It is mortgaged, so you do not have to pay the fee."
    nuclear_power_plant.is_bought = False
    nuclear_power_plant.is_mortgaged = False


def test_power_plant_sell():
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    robert.power_plants = [nuclear_power_plant]
    nuclear_power_plant.is_bought = True
    assert nuclear_power_plant.sell(robert) == 'Nuclear power plant has been sold. Your balance is 3300$.'
    assert robert.power_plants == []
    assert not nuclear_power_plant.is_bought
    assert water_power_plant.sell(susan) == "No such power plant in your inventory."


def test_chart_init():
    assert chart.spaces == [start, thessaloniki, athenes, guarded_parking, southern_airport, neapol, mediolan, rome, prison, barcelona, nuclear_power_plant, sewilla, madrid, western_airport, liverpool, glasgow, london, free_parking, rotterdam, haga, amsterdam, northern_airport, malmo, goteborg, stockholm, go_to_prison, water_power_plant, frankfurt, colony, berlin, eastern_airport, insbruck, tax, vien]


def test_chart_too_short():
    with pytest.raises(WrongSpacesNumberError):
        chrt = Chart([rome, start, prison, water_power_plant])


def test_chart_too_long():
    spc = Space("Additional space")
    new_spaces = spaces
    new_spaces.append(spc)
    with pytest.raises(WrongSpacesNumberError):
        chrt = Chart(new_spaces)


def test_chart_no_start():
    spc = Space("Replacement space")
    new_spaces = [spc, thessaloniki, athenes, guarded_parking, southern_airport, neapol, mediolan, rome, prison, barcelona, nuclear_power_plant, sewilla, madrid, western_airport, liverpool, glasgow, london, free_parking, rotterdam, haga, amsterdam, northern_airport, malmo, goteborg, stockholm, go_to_prison, water_power_plant, frankfurt, colony, berlin, eastern_airport, insbruck, tax, vien]
    with pytest.raises(NoStartSpaceError):
        chrt = Chart(new_spaces)


def test_chart_no_prison():
    spc = Space("Replacement space")
    new_spaces = [spc, thessaloniki, athenes, guarded_parking, southern_airport, neapol, mediolan, rome, start, barcelona, nuclear_power_plant, sewilla, madrid, western_airport, liverpool, glasgow, london, free_parking, rotterdam, haga, amsterdam, northern_airport, malmo, goteborg, stockholm, go_to_prison, water_power_plant, frankfurt, colony, berlin, eastern_airport, insbruck, tax, vien]
    with pytest.raises(NoPrisonSpaceError):
        chrt = Chart(new_spaces)


def test_chart_more_starts():
    strt = Start("Second start")
    new_spaces = [start, thessaloniki, athenes, strt, southern_airport, neapol, mediolan, rome, prison, barcelona, nuclear_power_plant, sewilla, madrid, western_airport, liverpool, glasgow, london, free_parking, rotterdam, haga, amsterdam, northern_airport, malmo, goteborg, stockholm, go_to_prison, water_power_plant, frankfurt, colony, berlin, eastern_airport, insbruck, tax, vien]
    with pytest.raises(TooManyStartSpacesError):
        chrt = Chart(new_spaces)


def test_chart_more_prisons():
    prsn = Prison("Second prison")
    new_spaces = [start, thessaloniki, athenes, prsn, southern_airport, neapol, mediolan, rome, prison, barcelona, nuclear_power_plant, sewilla, madrid, western_airport, liverpool, glasgow, london, free_parking, rotterdam, haga, amsterdam, northern_airport, malmo, goteborg, stockholm, go_to_prison, water_power_plant, frankfurt, colony, berlin, eastern_airport, insbruck, tax, vien]
    with pytest.raises(TooManyPrisonSpacesError):
        chrt = Chart(new_spaces)
    chart.spaces = [start, thessaloniki, athenes, guarded_parking, southern_airport, neapol, mediolan, rome, prison, barcelona, nuclear_power_plant, sewilla, madrid, western_airport, liverpool, glasgow, london, free_parking, rotterdam, haga, amsterdam, northern_airport, malmo, goteborg, stockholm, go_to_prison, water_power_plant, frankfurt, colony, berlin, eastern_airport, insbruck, tax, vien]


def test_game_init():
    simon = generate_players_and_game()[0]
    ann = generate_players_and_game()[1]
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = Game([simon, ann, robert, susan], chart)
    assert game.players == [simon, ann, robert, susan]
    assert game.chart == chart


def test_game_move_pawn():
    simon = generate_players_and_game()[0]
    ann = generate_players_and_game()[1]
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = Game([simon, ann, robert, susan], chart)
    simon.space_index = 30
    assert game.move_pawn(simon, 5) == (thessaloniki, "You crossed Start space. You receive 400$.")
    assert game.move_pawn(simon, 3) == southern_airport


def test_game_make_move_two_doublets(monkeypatch):
    def doublet(dcdcasx):
        return [2, 2]
    monkeypatch.setattr("monopoly_classes.Player.roll_dices", doublet)
    simon = generate_players_and_game()[0]
    ann = generate_players_and_game()[1]
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = Game([simon, ann, robert, susan], chart)
    assert game.make_a_move(ann) == ("Dices rolled. Your numbers are 2 and 2.", "Dices rolled. Your numbers are 2 and 2.", None)


def test_game_make_move_normal_throw(monkeypatch):
    def normal(shd):
        return [3, 5]
    monkeypatch.setattr("monopoly_classes.Player.roll_dices", normal)
    simon = generate_players_and_game()[0]
    ann = generate_players_and_game()[1]
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = Game([simon, ann, robert, susan], chart)
    assert game.make_a_move(ann) == ("Dices rolled. Your numbers are 3 and 5. You move 8 spaces.", 8)


def test_game_make_move_doublet_normal(monkeypatch):
    def n_d(snjnsj, ssn):
        dices = [2, 2]  # first line changed
        if dices[0] == dices[1]:
            second_throw = [2, 3]  # second line changed
            if second_throw[0] == second_throw[1]:
                return f"Dices rolled. Your numbers are {dices[0]} and {dices[1]}.", f"Dices rolled. Your numbers are {second_throw[0]} and {second_throw[1]}.", None
            else:
                move_spaces = sum(second_throw) + sum(dices)
                return f"Dices rolled. Your numbers are {dices[0]} and {dices[1]}.", f"Dices rolled. Your numbers are {second_throw[0]} and {second_throw[1]}. You move {move_spaces} spaces.", move_spaces
        else:
            move_spaces = sum(dices)
        return f"Dices rolled. Your numbers are {dices[0]} and {dices[1]}. You move {move_spaces} spaces.", move_spaces
    monkeypatch.setattr("monopoly_classes.Game.make_a_move", n_d)
    simon = generate_players_and_game()[0]
    ann = generate_players_and_game()[1]
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = Game([simon, ann, robert, susan], chart)
    assert game.make_a_move(ann) == ("Dices rolled. Your numbers are 2 and 2.", "Dices rolled. Your numbers are 2 and 3. You move 9 spaces.", 9)


def test_game_check_players_belongings():
    simon = generate_players_and_game()[0]
    ann = generate_players_and_game()[1]
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = Game([simon, ann, robert, susan], chart)
    simon.power_plants = [water_power_plant]
    ann.airports = [southern_airport]
    robert.cities = [sewilla]
    assert game.check_players_belongings(simon) == "There are things to sell."
    assert game.check_players_belongings(ann) == "There are things to sell."
    assert game.check_players_belongings(robert) == "There are things to sell."
    assert game.check_players_belongings(susan) == "There are not things to sell."
    southern_airport.is_mortgaged = True
    water_power_plant.is_mortgaged = True
    sewilla.is_mortgaged = True
    assert game.check_players_belongings(simon) == "There are not things to sell."
    assert game.check_players_belongings(ann) == "There are not things to sell."
    assert game.check_players_belongings(robert) == "There are not things to sell."
    southern_airport.is_mortgaged = False
    water_power_plant.is_mortgaged = False
    sewilla.is_mortgaged = False


def test_game_build_house_():
    simon = generate_players_and_game()[0]
    ann = generate_players_and_game()[1]
    robert = generate_players_and_game()[2]
    susan = generate_players_and_game()[3]
    game = Game([simon, ann, robert, susan], chart)
    simon.cities = [sewilla, haga, madrid]
    ann.cities = [thessaloniki, athenes]
    assert game.build_house(simon, "Spain") == "You do not have all cities in this country."
    assert sewilla.houses == 0
    assert madrid.houses == 0
    assert sewilla.hotel == 0
    assert madrid.hotel == 0
    assert simon.money == 3000
    assert game.build_house(ann, "Greece") == 'The building has been bought in all cities of Greece. Now each of them has 1 houses and 0 hotels.'
    assert thessaloniki.houses == 1
    assert athenes.houses == 1
    assert thessaloniki.hotel == 0
    assert athenes.hotel == 0
    assert ann.money == 2800
    thessaloniki.houses = 4
    athenes.houses = 4
    assert game.build_house(ann, "Greece") == 'The building has been bought in all cities of Greece. Now each of them has 0 houses and 1 hotels.'
    assert thessaloniki.houses == 0
    assert athenes.houses == 0
    assert thessaloniki.hotel == 1
    assert athenes.hotel == 1
    assert ann.money == 2600
    assert game.build_house(ann, "Greece") == "This country has 1 hotel. You cannot build more."
    assert thessaloniki.houses == 0
    assert athenes.houses == 0
    assert thessaloniki.hotel == 1
    assert athenes.hotel == 1
    assert ann.money == 2600
    robert.money = 20
    robert.cities = [vien, insbruck]
    assert game.build_house(robert, "Austria") == "You do not have enough money to buy buildings here."
    assert vien.houses == 0
    assert insbruck.houses == 0
    assert vien.hotel == 0
    assert insbruck.hotel == 0
    assert robert.money == 20
    thessaloniki.hotel = 0
    athenes.hotel = 0


def test_game_sell_house():
    data = generate_players_and_game()
    ann = data[1]
    game = data[4]
    ann.cities = [vien, insbruck]
    vien.houses = 1
    insbruck.houses = 1
    assert game.sell_house(ann, "Austria", "house") == 'Buildings in Austria have been sold. Now each city here has 0 houses and 0 hotels. \n Your balance is 3200$.'
    assert game.sell_house(ann, "Austria", "house") == "This country has not got any houses."
    assert vien.houses == 0
    assert insbruck.houses == 0
    assert ann.money == 3200
    vien.hotel = 1
    insbruck.hotel = 1
    ann.money = 3000
    assert game.sell_house(ann, "Austria", "hotel") == 'Buildings in Austria have been sold. Now each city here has 0 houses and 0 hotels. \n Your balance is 4000$.'
    assert vien.hotel == 0
    assert insbruck.hotel == 0
    assert ann.money == 4000
    assert game.sell_house(ann, "Austria", "hotel") == "This country has not got any hotels."


def test_game_trade_city():
    data = generate_players_and_game()
    ann = data[1]
    robert = data[2]
    game = data[4]
    robert.cities = [barcelona]
    barcelona.is_mortgaged = True
    assert game.trade(robert, ann, barcelona) == "You cannot trade a mortgaged property."
    barcelona.is_mortgaged = False
    barcelona.houses = 1
    assert game.trade(robert, ann, barcelona) == "You cannot sell this city, because it has buildings."
    barcelona.houses = 0
    assert robert.cities == [barcelona]
    assert robert.airports == []
    assert robert.power_plants == []
    assert robert.money == 3000
    assert ann.money == 3000
    assert ann.cities == []
    assert ann.airports == []
    assert ann.power_plants == []
    assert game.trade(robert, ann, barcelona) == "Barcelona has been sold. Ann is the new owner."
    assert ann.cities == [barcelona]
    assert ann.airports == []
    assert ann.power_plants == []
    assert robert.cities == []
    assert robert.airports == []
    assert robert.power_plants == []
    assert robert.money == 3280
    assert ann.money == 2720


def test_game_trade_airport():
    data = generate_players_and_game()
    simon = data[0]
    susan = data[3]
    game = data[4]
    simon.airports = [southern_airport]
    southern_airport.is_mortgaged = True
    assert game.trade(simon, susan, southern_airport) == "You cannot trade a mortgaged property."
    assert simon.cities == []
    assert simon.airports == [southern_airport]
    assert simon.power_plants == []
    assert simon.money == 3000
    assert susan.money == 3000
    assert susan.cities == []
    assert susan.airports == []
    assert susan.power_plants == []
    southern_airport.is_mortgaged = False
    assert game.trade(simon, susan, southern_airport) == "Southern Airport has been sold. Susan is the new owner."
    assert simon.cities == []
    assert simon.airports == []
    assert simon.power_plants == []
    assert simon.money == 3400
    assert susan.money == 2600
    assert susan.cities == []
    assert susan.airports == [southern_airport]
    assert susan.power_plants == []


def test_game_trade_power_plant():
    data = generate_players_and_game()
    simon = data[0]
    susan = data[3]
    game = data[4]
    simon.power_plants = [nuclear_power_plant]
    nuclear_power_plant.is_mortgaged = True
    assert game.trade(simon, susan, nuclear_power_plant) == "You cannot trade a mortgaged property."
    assert simon.cities == []
    assert simon.airports == []
    assert simon.power_plants == [nuclear_power_plant]
    assert simon.money == 3000
    assert susan.money == 3000
    assert susan.cities == []
    assert susan.airports == []
    assert susan.power_plants == []
    nuclear_power_plant.is_mortgaged = False
    assert game.trade(simon, susan, nuclear_power_plant) == "Nuclear power plant has been sold. Susan is the new owner."
    assert simon.cities == []
    assert simon.airports == []
    assert simon.power_plants == []
    assert simon.money == 3300
    assert susan.money == 2700
    assert susan.cities == []
    assert susan.airports == []
    assert susan.power_plants == [nuclear_power_plant]


def test_game_is_in_inventory():
    data = generate_players_and_game()
    simon = data[0]
    susan = data[3]
    game = data[4]
    simon.cities = [rome, barcelona]
    simon.airports = [northern_airport, eastern_airport]
    simon.power_plants = [nuclear_power_plant]
    assert game.is_in_inventory("Rome", simon) == rome
    assert game.is_in_inventory("Northern Airport", simon) == northern_airport
    assert game.is_in_inventory("Nuclear power plant", simon) == nuclear_power_plant
    assert not game.is_in_inventory("Rome", susan)
    assert not game.is_in_inventory("Sewilla", susan)
    assert not game.is_in_inventory("Northern Airport", susan)
    assert not game.is_in_inventory("Southern Airport", susan)
    assert not game.is_in_inventory("Nuclear power plant", susan)
    assert not game.is_in_inventory("Water power plant", susan)


def test_player_in_game():
    data = generate_players_and_game()
    simon = data[0]
    susan = data[3]
    game = data[4]
    simon.is_lost = True
    assert not game.player_in_game("Simon")
    assert game.player_in_game("Susan")


def test_calculate_winner_only_player():
    data = generate_players_and_game()
    simon = data[0]
    ann = data[1]
    robert = data[2]
    susan = data[3]
    game = data[4]
    simon.is_lost = True
    ann.is_lost = True
    robert.is_lost = True
    assert game.calculate_winner() == susan


def test_calculate_winner_most_money():
    data = generate_players_and_game()
    susan = data[3]
    game = data[4]
    susan.money = 3333
    assert game.calculate_winner() == susan


def test_calculate_winner_two_players_most_money():
    data = generate_players_and_game()
    robert = data[2]
    susan = data[3]
    game = data[4]
    susan.money = 3333
    robert.money = 3333
    assert not game.calculate_winner()


def test_buyable_spaces():
    game = generate_players_and_game()[4]
    assert game.buyable_spaces_names() == ["Start", "Thessaloniki", "Athenes", "Guarded parking", "Southern Airport", "Neapol", "Mediolan", "Rome", "Prison", "Barcelona", "Nuclear power plant", "Sewilla", "Madrid", "Western Airport", "Liverpool", "Glasgow", "London", "Free parking", "Rotterdam", "Haga", "Amsterdam", "Northern Airport", "Malmo", "Goteborg", "Stockholm", "Go-to-prison space", "Water power plant", "Frankfurt", "Colony", "Berlin", "Eastern Airport", "Insbruck", "Tax space", "Vien"]


def test_countries():
    game = generate_players_and_game()[4]
    assert game.countries() == ["Greece", "Italy", "Spain", "England", "Netherlands", "Sweden", "Germany", "Austria"]


def test_main_menu(monkeypatch):
    def make_a_move(dsnjxnds):
        return "Make a move"
    game = generate_players_and_game()[4]
    interface = Interface(game)
    monkeypatch.setattr("monopoly_classes.input1", make_a_move)
    assert interface.main_menu() == "Make a move"


def test_waiting_for_payment_affordable():
    data = generate_players_and_game()
    robert = data[2]
    susan = data[3]
    game = data[4]
    interface = Interface(game)
    assert interface.waiting_for_payment(robert, susan, 15) == "The 15$ has been payed."
    assert robert.money == 2985
    assert susan.money == 3015
    assert interface.waiting_for_payment(robert, None, 15) == "The 15$ has been payed."
    assert robert.money == 2970


def test_waiting_for_payment_loose():
    data = generate_players_and_game()
    robert = data[2]
    susan = data[3]
    game = data[4]
    interface = Interface(game)
    robert.money = 0
    assert interface.waiting_for_payment(robert, susan, 15) == "Robert, you are not able to pay your fees. You loose."
    assert robert.is_lost
    assert not susan.is_lost
    assert susan.money == 3000


def test_waiting_for_payment_sell(monkeypatch):
    data = generate_players_and_game()
    robert = data[2]
    susan = data[3]
    game = data[4]
    interface = Interface(game)

    def sell_barcelona(dewccfa, sjnxjnxjn):
        robert.cities.remove(barcelona)
        robert.money += barcelona.price
        barcelona.is_bought = False

    def sell_word(dsnn, njsnd, dshhjsdjh):
        return "sell"
    monkeypatch.setattr("monopoly_classes.Interface.selling", sell_barcelona)
    monkeypatch.setattr("monopoly_classes.Interface.sell_or_mortgage", sell_word)
    barcelona.is_bought = True
    robert.cities = [barcelona]
    robert.money = 0
    assert interface.waiting_for_payment(robert, susan, 15) == "The 15$ has been payed."
    assert robert.cities == []
    assert robert.money == 265
    assert susan.money == 3015
    assert not barcelona.is_bought


def test_waiting_for_payment_mortgage(monkeypatch):
    data = generate_players_and_game()
    robert = data[2]
    susan = data[3]
    game = data[4]
    interface = Interface(game)

    def mortgage_barcelona(dewccfa, sjnxjnxjn):
        robert.money += barcelona.mortgage
        barcelona.is_mortgaged = True

    def mortgage_word(nxwnx, dsnn, njsnd):
        return "mortgage"
    monkeypatch.setattr("monopoly_classes.Interface.mortgaging", mortgage_barcelona)
    monkeypatch.setattr("monopoly_classes.Interface.sell_or_mortgage", mortgage_word)
    robert.cities = [barcelona]
    robert.money = 0
    assert interface.waiting_for_payment(robert, susan, 15) == "The 15$ has been payed."
    assert robert.cities == [barcelona]
    assert robert.money == 125
    assert susan.money == 3015
    assert barcelona.is_mortgaged
    barcelona.is_mortgaged = False


def test_buy_yes_or_no(monkeypatch):
    def yes(wcdcw):
        return "Yes"

    def no(fcec):
        return "No"
    data = generate_players_and_game()
    robert = data[2]
    game = data[4]
    spc = game.chart.spaces[24]
    interface = Interface(game)
    monkeypatch.setattr("monopoly_classes.input1", yes)
    assert interface.buy_yes_or_no(spc, robert)
    monkeypatch.setattr("monopoly_classes.input1", no)
    assert not interface.buy_yes_or_no(spc, robert)


def test_selling(monkeypatch):
    def liverpool_f(cwec):
        return "Liverpool"

    def building(dxwc):
        return "building"

    def country(wcdc):
        return "Netherlands"
    data = generate_players_and_game()
    robert = data[2]
    susan = data[3]
    game = data[4]
    interface = Interface(game)
    monkeypatch.setattr("monopoly_classes.input1", liverpool_f)
    assert interface.selling(robert) == "You have nothing to sell."
    robert.cities = [liverpool]
    assert interface.selling(robert) == 'Liverpool has been sold. Your balance is 3360$.'
    monkeypatch.setattr("monopoly_classes.input1", building)
    monkeypatch.setattr("monopoly_classes.input2", country)
    susan.cities = [haga, amsterdam, rotterdam]
    haga.houses = 1
    amsterdam.houses = 1
    rotterdam.houses = 1
    assert interface.selling(susan) == 'Buildings in Netherlands have been sold. Now each city here has 0 houses and 0 hotels. \n Your balance is 3150$.'


def test_sell_or_mortgage(monkeypatch):
    def sell_word(erfcdw):
        return "sell"
    susan = generate_players_and_game()[3]
    game = generate_players_and_game()[4]
    interface = Interface(game)
    monkeypatch.setattr("monopoly_classes.input4", sell_word)
    assert interface.sell_or_mortgage(susan, 12) == "sell"


def test_mortgaging(monkeypatch):
    def sa(dssdbh):
        return "Southern Airport"
    data = generate_players_and_game()
    robert = data[2]
    susan = data[3]
    game = data[4]
    interface = Interface(game)
    assert interface.mortgaging(susan) == "You have nothing to mortgage."
    susan.airports = [southern_airport]
    robert.airports = [eastern_airport]
    monkeypatch.setattr("monopoly_classes.input1", sa)
    assert interface.mortgaging(robert) == "You do not have it in your inventory."
    assert interface.mortgaging(susan) == "Southern Airport is now mortgaged. You cannot collect fees from this space."
    assert southern_airport.is_mortgaged
    assert susan.money == 3200
    assert interface.mortgaging(susan) == "This thing is already mortgaged."


def test_unmortgaging(monkeypatch):
    def sa(dssdbh):
        return "Southern Airport"

    def ea(dssdbh):
        return "Eastern Airport"
    data = generate_players_and_game()
    robert = data[2]
    susan = data[3]
    game = data[4]
    interface = Interface(game)
    assert interface.unmortgaging(susan) == "You have nothing to unmortgage."
    susan.airports = [southern_airport]
    robert.airports = [eastern_airport]
    monkeypatch.setattr("monopoly_classes.input1", sa)
    assert interface.unmortgaging(robert) == "You do not have it in your inventory."
    assert interface.unmortgaging(susan) == "Southern Airport is now unmortgaged. You can collect fees from this space."
    assert not southern_airport.is_mortgaged
    assert susan.money == 2800
    assert interface.unmortgaging(susan) == "This thing is not mortgaged."
    robert.money = 0
    monkeypatch.setattr("monopoly_classes.input1", ea)
    eastern_airport.is_mortgaged = True
    assert interface.unmortgaging(robert) == "You do not have enough money to unmortgage this."
    assert eastern_airport.is_mortgaged
    assert robert.money == 0
    eastern_airport.is_mortgaged = False


def test_building_house(monkeypatch):
    def england(dssdbh):
        return "England"

    def germany(dssdbh):
        return "Germany"

    def poland(shbabxjsh):
        return "Poland"
    data = generate_players_and_game()
    susan = data[3]
    game = data[4]
    interface = Interface(game)
    susan.cities = [liverpool, london, glasgow]
    monkeypatch.setattr("monopoly_classes.input1", england)
    assert interface.building_house(susan) == (susan, "England")
    monkeypatch.setattr("monopoly_classes.input1", germany)
    assert interface.building_house(susan) == "You do not have any cities in this country."
    monkeypatch.setattr("monopoly_classes.input1", poland)
    assert interface.building_house(susan) == 'This country does not exist in the game.'


def test_player_trading(monkeypatch):
    def rob(dssdbh):
        return "Robert"

    def buy(snxhjdsj):
        return "buy"

    def wrong(jdsnjkskn):
        return "NNNNN"

    def thes(nxhdsbnxj):
        return "Thessaloniki"

    def yes(kdmk):
        return "Yes"
    data = generate_players_and_game()
    robert = data[2]
    susan = data[3]
    game = data[4]
    interface = Interface(game)
    monkeypatch.setattr("monopoly_classes.input1", rob)
    monkeypatch.setattr("monopoly_classes.input2", wrong)
    monkeypatch.setattr("monopoly_classes.input3", thes)
    monkeypatch.setattr("monopoly_classes.input4", wrong)
    robert.is_lost = True
    assert interface.player_trading(susan) == "There is no such player active."
    robert.is_lost = False
    assert interface.player_trading(susan) == "Wrong command."
    monkeypatch.setattr("monopoly_classes.input2", buy)
    assert interface.player_trading(susan) == "The seller does not have anything to sell."
    robert.cities = [thessaloniki]
    susan.money = 0
    assert interface.player_trading(susan) == "Susan does not have enough money to buy Thessaloniki from Robert."
    assert susan.money == 0
    assert susan.cities == []
    assert robert.money == 3000
    assert robert.cities == [thessaloniki]
    susan.money = 3000
    assert interface.player_trading(susan) == "Transaction not confirmed."
    assert susan.money == 3000
    assert susan.cities == []
    assert robert.money == 3000
    assert robert.cities == [thessaloniki]
    monkeypatch.setattr("monopoly_classes.input4", yes)
    assert interface.player_trading(susan) == "Thessaloniki has been sold. Susan is the new owner."
    assert susan.money == 2880
    assert susan.cities == [thessaloniki]
    assert robert.money == 3120
    assert robert.cities == []

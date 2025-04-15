from monopoly_classes import Start, Prison, Chart, Go_to_prison, Power_plant, Space, City, Airport, Tax_space

# słowniki opłat
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

# pola na planszy 34 sztuk
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

# plansza
spaces = [start, thessaloniki, athenes, guarded_parking, southern_airport, neapol, mediolan, rome, prison, barcelona, nuclear_power_plant, sewilla, madrid, western_airport, liverpool, glasgow, london, free_parking, rotterdam, haga, amsterdam, northern_airport, malmo, goteborg, stockholm, go_to_prison, water_power_plant, frankfurt, colony, berlin, eastern_airport, insbruck, tax, vien]
chart = Chart(spaces)

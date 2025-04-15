import random


def message(string):
    """Mockable print function."""
    print(string)


def input1(string):
    """Mockable input function."""
    thing = input(string)
    return thing


def input2(string):
    """Mockable input function."""
    thing = input(string)
    return thing


def input3(string):
    """Mockable input function."""
    thing = input(string)
    return thing


def input4(string):
    """Mockable input function."""
    thing = input(string)
    return thing

# WYJATKI


class NameTooLongError(Exception):
    """Makes sure, that all space names aren't wider than 19 letters."""
    def __init__(self, message="Name of the space cannot be longer than 19."):
        self.message = message
        super().__init__(self.message)


class WrongSpacesNumberError(Exception):
    """Makes sure, that the chart has constant number of spaces."""
    def __init__(self, message="Chart must have exactly 34 spaces."):
        self.message = message
        super().__init__(self.message)


class NoStartSpaceError(Exception):
    """Makes sure, that the chart has a start."""
    def __init__(self, message="The chart has to contain a start space."):
        self.message = message
        super().__init__(self.message)


class TooManyStartSpacesError(Exception):
    """Limits the number of starts to 1."""
    def __init__(self, message="The chart cannot have more than one start space."):
        self.message = message
        super().__init__(self.message)


class NoPrisonSpaceError(Exception):
    """Makes sure, that there is a prison in game."""
    def __init__(self, message="The chart has to contain a prison space."):
        self.message = message
        super().__init__(self.message)


class TooManyPrisonSpacesError(Exception):
    """Limits the number of prisons to 1."""
    def __init__(self, message="The chart cannot have more than one prison space."):
        self.message = message
        super().__init__(self.message)

# KLASA GRACZ


class Player():
    """
    class Player. Contains attributes:
    : param name : player's name
    : type name : str

    : param pawn : unique symbol visible on a chart
    : type pawn : str

    : param money : player's money
    : type money : int

    : param cities : cities (City objects) owned by this player
    : type cities : list

    : param airports : Airport objects owned by this player
    : type airports : list

    : param power_plants : Power_plant objects owned by this player
    : type power_plants : list

    : param in_prison : True if player is imprisonated
    : type in_prison : bool

    : param space_index : index of the space, on which the player is standing
    : type space_index : int

    : param rounds_in_prison : rounds spent being imprisonated
    : type rounds_in_prison : int

    : param is_lost : True if the player has lost or left and is no longer playing
    : type is_lost : bool

    """
    def __init__(self, name, pawn, start_index):
        """
        Creates the player with 3000$, no belongings and puts them on a Start space.
        """
        self.name = name
        self.pawn = pawn
        self.money = 3000
        self.cities = []
        self.airports = []
        self.power_plants = []
        self.in_prison = False
        self.space_index = start_index
        self.rounds_in_prison = 0
        self.is_lost = False

    def imprisonate(self, game):
        """
        Moves player to prison and imprisonates them.
        """
        self.in_prison = True
        for possible_prison in game.chart.spaces:
            if type(possible_prison) == Prison:
                prison_index = game.chart.spaces.index(possible_prison)
                break
        self.space_index = prison_index

    def set_free(self):
        """
        Frees the player and resets their rounds in prison to 0.
        """
        self.in_prison = False
        self.rounds_in_prison = 0

    def roll_dices(self):
        """
        Returns a list with two random numbers from 1 to 6.
        """
        dices = []
        for roll in range(2):
            number = random.randint(1, 6)
            dices.append(number)
        return dices

    def check_prison(self):
        """
        Returns information, whether the player has finished 3 rounds in prison or not.
        If they are not imprisonated, returns False.
        """
        if self.in_prison:
            if self.rounds_in_prison == 3:
                self.set_free()
                return "Third round in prison has passed. You are now free."
            else:
                self.rounds_in_prison += 1
                return f"You are in prison, so you cannot do any actions. This is round {self.rounds_in_prison} spent in prison."
        return False

    def player_looses(self):
        """
        Changes player status to lost and unbuys all belongings, so they can be bought again.
        """
        self.is_lost = True
        for city in self.cities:
            city.is_mortgaged = False
            city.is_bought = False
            city.houses = 0
            city.hotel = 0
        for airport in self.airports:
            airport.is_mortgaged = False
            airport.is_bought = False
        for power_plant in self.power_plants:
            power_plant.is_mortgaged = False
            power_plant.is_bought = False
        self.cities = []
        self.airports = []
        self.power_plants = []


# KLASA POLE i rodzaje pól


class Space():
    """
    class Space. Contains attributes:
    : param name : space's name
    : type name : str

    """
    def __init__(self, name):
        """
        Before creating, checks, if the name is longer than 19 letters.
        If it is true, raises NameTooLongError.
        """
        if len(name) > 19:
            raise NameTooLongError
        self.name = name

    def event(self, *args, **kwargs):
        """
        Returns info about its name and no need to pay.
        """
        return f"You are on {self.name}. No need to pay."


class Start(Space):
    """
    class Start. Contains attributes:
    : param name : space's name
    : type name : str
    """
    def __init__(self, name):
        """Creates a Start."""
        super().__init__(name)


class Prison(Space):
    """
    class Prison. Contains attributes:
    : param name : space's name
    : type name : str
    """
    def __init__(self, name):
        """Creates a prison."""
        super().__init__(name)


class Go_to_prison(Space):
    """
    class Go_to_prison. Contains attributes:
    : param name : space's name
    : type name : str
    """
    def __init__(self, name):
        """Creates an imprisonating space."""
        super().__init__(name)

    def event(self, player, game, *args, **kwargs):
        """
        Imprisonates player and returns information about
        3 rounds left in prison.
        """
        player.imprisonate(game)
        return "Now you are in prison for 3 rounds."


class Tax_space(Space):
    """
    class Tax_space. Contains attributes:
    : param name : space's name
    : type name : str

    : param fee : constant fee collected
    : type fee : int
    """
    def __init__(self, name, fee):
        """Creates a space, which collects fees, but has no owner."""
        super().__init__(name)
        self.fee = fee

    def event(self, player, *args, **kwargs):
        """Returns a tuple with paying player, None for no owner and required fee."""
        required_payment = self.fee
        return player, None, required_payment


class Boughtable(Space):
    """class Boughtable. Contains attributes:
    : param name : space's name
    : type name : str

    : param price : buying/selling price
    : type price : int

    : param mortgage : half of its price payed to the owner when mortgaged
    : type mortgage : int

    : param is_bought : True if bought
    : type is_bought : bool

    : param is_mortgaged : True if mortgaged
    : type is_mortgaged : bool
    """
    def __init__(self, name, price, *args, **kwargs):
        """Creates a space, which a player can buy."""
        super().__init__(name)
        self.price = price
        self.is_bought = False
        self.is_mortgaged = False
        self.mortgage = int(price / 2)

    def is_affordable_for_player(self, player):
        """Returns True if the player can afford the space."""
        return player.money >= self.price

    def event(self, *args, **kwargs):
        """Returned event depends on whether space is bought."""
        if self.is_bought:
            return self.event_bought(*args, **kwargs)
        else:
            return self.event_unbought(*args, **kwargs)

    def event_unbought(self, player, game, interface, *args, **kwargs):
        """Returns player's decision about buing the space or an information
        that the player can't afford it, if this is the case."""
        if self.is_affordable_for_player(player):
            decision = interface.buy_yes_or_no(self, player)
            if decision:
                return "Decided"
            else:
                return "Undecided"
        else:
            return f"It is unbought and costs {self.price}$. You have {int(player.money)}$. You do not have enough money to buy it."

    def event_bought(self, player, *args, **kwargs):
        """Placeholder for event, when space is bought."""
        pass

    def sell(self, player, *args, **kwargs):
        """If mortgaged, returns an information, that space can't be sold."""
        if self.is_mortgaged:
            return "You cannot sell a mortgaged property."


class City(Boughtable):
    """
    class City. Contains attributes:
    : param name : space's name
    : type name : str

    : param price : buying/selling price
    : type price : int

    : param mortgage : half of its price payed to the owner when mortgaged
    : type mortgage : int

    : param country : country, to which it belongs
    : type country : str

    : param fees : dictionary of fees
    : type fees : dict

    : param houses : number of houses built
    : type houses : int

    : param hotel : number of hotels built
    : type hotel : int

    : param area : area number
    : type area : int

    : param is_bought : True if bought
    : type is_bought : bool

    : param is_mortgaged : True if mortgaged
    : type is_mortgaged : bool
    """
    def __init__(self, name, price, country, fees, area):
        """Generates a space, on which buildings can be built."""
        super().__init__(name, price)
        self.country = country
        self.fees = fees
        self.houses = 0
        self.hotel = 0
        self.area = area

    def calculate_fee(self):
        """Returns a proper fee checked in the dictionary."""
        if self.houses > 0:
            return self.fees[str(self.houses)]
        elif self.hotel == 1:
            return self.fees["hotel"]
        else:
            return self.fees["0"]

    def calculate_house_price(self):
        """Returns house's price. It equals to 100$ multiplied by area number."""
        return 100 * self.area

    def event_unbought(self, player, game, interface, *args, **kwargs):
        """If the player wants to buy the city, it makes a transaction.
        Returns a message about, what has happened."""
        decision = super().event_unbought(player, game, interface)
        if decision == "Decided":
            player.money -= self.price
            self.is_bought = True
            player.cities.append(self)
            return f"You have bought {self.name}."
        elif decision == "Undecided":
            return f"You have not bought {self.name}."
        else:
            return decision

    def event_bought(self, player, game, *args, **kwargs):
        """Returns a message, if there is no payment needed.
        If it is, returns a tuple with payer, owner and fee."""
        if self in player.cities:
            return "It is yours."
        elif self.is_mortgaged:
            return "It is mortgaged, so you do not have to pay the fee."
        for possible_owner in game.players:
            city_list = possible_owner.cities
            if self in city_list:
                return player, possible_owner, self.calculate_fee()

    def sell(self, player, *args, **kwargs):
        """Sells the space if unmortgaged, has no buildings and is among player's cities.
        Returns a message about what has happened. """
        super().sell(player)
        if self not in player.cities:
            return "No such city in your inventory."
        elif self.houses > 0 or self.hotel > 0:
            return "You cannot sell a city with buildings."
        else:
            self.is_bought = False
            player.cities.remove(self)
            player.money += self.price
        return f'{self.name} has been sold. Your balance is {player.money}$.'


class Airport(Boughtable):
    """
    class Airport. Contains attributes:
    : param name : space's name
    : type name : str

    : param price : buying/selling price
    : type price : int

    : param mortgage : half of its price payed to the owner when mortgaged
    : type mortgage : int

    : param is_bought : True if bought
    : type is_bought : bool

    : param is_mortgaged : True if mortgaged
    : type is_mortgaged : bool
    """
    def __init__(self, name, price):
        """Creates a boughtable airport."""
        super().__init__(name, price)

    def calculate_fee(self, owner):
        """The more airports player has, the higher is the fee.
        50$ multiplied by amount of airports the player has."""
        fee = 50 * pow(2, len(owner.airports) - 1)
        return fee

    def event_unbought(self, player, game, interface, *args, **kwargs):
        """If the player wants to buy the airport, it makes a transaction.
        Returns a message about, what has happened."""
        decision = super().event_unbought(player, game, interface)
        if decision == "Decided":
            player.money -= self.price
            self.is_bought = True
            player.airports.append(self)
            return f"You have bought {self.name}."
        elif decision == "Undecided":
            return f"You have not bought {self.name}."
        else:
            return decision

    def event_bought(self, player, game, *args, **kwargs):
        """Returns a message, if there is no payment needed.
        If it is, returns a tuple with payer, owner and fee."""
        if self in player.airports:
            return "It is yours."
        elif self.is_mortgaged:
            return "It is mortgaged, so you do not have to pay the fee."
        else:
            for possible_owner in game.players:
                if self in possible_owner.airports and possible_owner != player:
                    return player, possible_owner, self.calculate_fee(possible_owner)

    def sell(self, player, *args, **kwargs):
        """Sells the space if unmortgaged, has no buildings and is among player's cities.
        Returns a message about what has happened. """
        super().sell(player)
        if self not in player.airports:
            return "No such airport in your inventory."
        else:
            self.is_bought = False
            player.airports.remove(self)
            player.money += self.price
        return f'{self.name} has been sold. Your balance is {player.money}$.'


class Power_plant(Boughtable):
    """
    class Power_plant. Contains attributes:
    : param name : space's name
    : type name : str

    : param price : buying/selling price
    : type price : int

    : param mortgage : half of its price payed to the owner when mortgaged
    : type mortgage : int

    : param is_bought : True if bought
    : type is_bought : bool

    : param is_mortgaged : True if mortgaged
    : type is_mortgaged : bool
    """
    def __init__(self, name, price):
        """Generates a boughtable power plant."""
        super().__init__(name, price)

    def calculate_fee(self, owner, moved_spaces):
        """The more payer has moved and the more power plants owner owns, the higher the fee.
        10$ multiplied by spaces and amount of power_plants."""
        return moved_spaces * 10 * len(owner.power_plants)

    def event_unbought(self, player, game, interface, *args, **kwargs):
        """If the player wants to buy the city, it makes a transaction.
        Returns a message about, what has happened."""
        decision = super().event_unbought(player, game, interface)
        if decision == "Decided":
            player.money -= self.price
            self.is_bought = True
            player.power_plants.append(self)
            return f"You have bought {self.name}."
        elif decision == "Undecided":
            return f"You have not bought {self.name}."
        else:
            return decision

    def event_bought(self, player, game, interface, moved_spaces, *args, **kwargs):
        """Returns a message, if there is no payment needed.
        If it is, returns a tuple with payer, owner and fee."""
        if self in player.power_plants:
            return "It is yours."
        elif self.is_mortgaged:
            return "It is mortgaged, so you do not have to pay the fee."
        else:
            for possible_owner in game.players:
                if self in possible_owner.power_plants and possible_owner != player:
                    return player, possible_owner, self.calculate_fee(possible_owner, moved_spaces)

    def sell(self, player, *args, **kwargs):
        """Sells the space if unmortgaged, has no buildings and is among player's cities.
        Returns a message about what has happened. """
        super().sell(player)
        if self not in player.power_plants:
            return "No such power plant in your inventory."
        else:
            self.is_bought = False
            player.power_plants.remove(self)
            player.money += self.price
        return f'{self.name} has been sold. Your balance is {player.money}$.'

# KLASA PLANSZA


class Chart():
    """
    class Chart. Contains attributes:
    : param spaces : all spaces on the chart
    : type spaces : list
    """
    def __init__(self, spaces):
        """Will create only a chart with 34 spaces, among them 1 start and 1 prison.
        Raises proper errors if these needs aren't fulfilled."""
        if len(spaces) != 34:
            raise WrongSpacesNumberError
        starts = 0
        prisons = 0
        for space in spaces:
            if type(space) == Start:
                starts += 1
            if type(space) == Prison:
                prisons += 1
        if starts == 0:
            raise NoStartSpaceError
        if starts > 1:
            raise TooManyStartSpacesError
        if prisons == 0:
            raise NoPrisonSpaceError
        if prisons > 1:
            raise TooManyPrisonSpacesError
        self.spaces = spaces

# KLASA GRA


class Game():
    """
    class Game. Contains attributes:
    : param players : list of players
    : type players : list

    : param chart : a chart with spaces
    : type chart : Chart
    """
    def __init__(self, players, chart):
        """Creates a game object."""
        self.players = players
        self.chart = chart

    def move_pawn(self, player, spaces_number):
        """Moves the player from space to space.
        Returns reached space.
        If the start has been crossed, includes this information
        to the returned data by making a tuple."""
        take_from = self.chart.spaces[player.space_index]
        player.space_index += spaces_number
        while player.space_index > 33:
            player.space_index -= 34
        put_on = self.chart.spaces[player.space_index]
        if self.crossed_start(put_on, take_from):
            player.money += 400
            return put_on, "You crossed Start space. You receive 400$."
        return put_on

    def crossed_start(self, put, take):
        """Checks if start has been crossed.
        If yes, returns True.
        If no, returns False."""
        order = []
        for space in self.chart.spaces:
            if type(space) == Start or space == put or space == take:
                order.append(space)
        if len(order) == 2 and put not in order:
            return True
        elif order.index(take) == 0 and order.index(put) == 2:
            return True
        elif order.index(put) == 1 and order.index(take) == 2:
            return True
        elif order.index(put) == 0 and order.index(take) == 1:
            return True
        else:
            return False

    def make_a_move(self, player):
        """Rolls dices.
        Returns tuples with information about numbers on dices.
        If doublet has been rolled two times in a row, returns information about going to prison, as well.
        The last element in the tuple is number of spaces to move (or None if two doublets)."""
        dices = player.roll_dices()
        if dices[0] == dices[1]:
            second_throw = player.roll_dices()
            if second_throw[0] == second_throw[1]:
                return f"Dices rolled. Your numbers are {dices[0]} and {dices[1]}.", f"Dices rolled. Your numbers are {second_throw[0]} and {second_throw[1]}.", None
            else:
                move_spaces = sum(second_throw) + sum(dices)
                return f"Dices rolled. Your numbers are {dices[0]} and {dices[1]}.", f"Dices rolled. Your numbers are {second_throw[0]} and {second_throw[1]}. You move {move_spaces} spaces.", move_spaces
        else:
            move_spaces = sum(dices)
        return f"Dices rolled. Your numbers are {dices[0]} and {dices[1]}. You move {move_spaces} spaces.", move_spaces

    def check_players_belongings(self, player):
        """Checks if player has something to sell."""
        for power_plant in player.power_plants:
            if not power_plant.is_mortgaged:
                return "There are things to sell."
        for airport in player.airports:
            if not airport.is_mortgaged:
                return "There are things to sell."
        for city in player.cities:
            if not city.is_mortgaged:
                return "There are things to sell."
        return "There are not things to sell."

    def build_house(self, player, country):
        """Builds 1 house in each city of the given country, if possible.
        Returns information anbout an unfulfilled condition or confirmation of purchase."""
        cities_bought = []
        for city in player.cities:
            if city.country == country:
                cities_bought.append(city)
        all_spaces_in_country = 0
        for space in self.chart.spaces:
            if type(space) == City:
                if space.country == country:
                    all_spaces_in_country += 1
        if len(cities_bought) == all_spaces_in_country:
            payment = all_spaces_in_country * cities_bought[0].calculate_house_price()
        else:
            return "You do not have all cities in this country."
        if cities_bought[0].hotel == 1:
            return "This country has 1 hotel. You cannot build more."
        if player.money < payment:
            return "You do not have enough money to buy buildings here."
        else:
            player.money -= payment
            for city in cities_bought:
                if city.houses != 4:
                    city.houses += 1
                else:
                    city.houses = 0
                    city.hotel += 1
        return f'The building has been bought in all cities of {country}. Now each of them has {cities_bought[0].houses} houses and {cities_bought[0].hotel} hotels.'

    def sell_house(self, player, country, hotel_or_house):
        """Sells 1 house in each city of the given country if possible.
        Returns an information about unfulfilled conditions or transaction confirmation."""
        cities_bought = []
        for city in player.cities:
            if city.country == country:
                cities_bought.append(city)
        if hotel_or_house == "hotel":
            if cities_bought[0].hotel == 0:
                return "This country has not got any hotels."
            else:
                payment = 5 * int(cities_bought[0].calculate_house_price() / 2)
                for city in cities_bought:
                    city.hotel -= 1
        else:
            if cities_bought[0].houses == 0:
                return "This country has not got any houses."
            else:
                payment = int((cities_bought[0].calculate_house_price()) / 2)
                for city in cities_bought:
                    city.houses -= 1
        player.money += payment
        return f'Buildings in {country} have been sold. Now each city here has {city.houses} houses and {city.hotel} hotels. \n Your balance is {player.money}$.'

    def trade(self, seller, buyer, sold_object):
        """Moves an object and money between players if possible.
        Returns information about unfullfilled conditions or transaction confirmation."""
        if sold_object.is_mortgaged:
            return "You cannot trade a mortgaged property."
        if type(sold_object) == Power_plant:
            seller.power_plants.remove(sold_object)
            buyer.power_plants.append(sold_object)
        elif type(sold_object) == Airport:
            seller.airports.remove(sold_object)
            buyer.airports.append(sold_object)
        else:
            if sold_object.houses > 0 or sold_object.hotel > 0:
                return "You cannot sell this city, because it has buildings."
            else:
                seller.cities.remove(sold_object)
                buyer.cities.append(sold_object)
        seller.money += sold_object.price
        buyer.money -= sold_object.price
        return f"{sold_object.name} has been sold. {buyer.name} is the new owner."

    def is_in_inventory(self, thing, player):
        """Returns an object if it is among player's belongings.
        If not, returns None."""
        for city in player.cities:
            if city.name == thing:
                return city
        for airport in player.airports:
            if airport.name == thing:
                return airport
        for power_plant in player.power_plants:
            if power_plant.name == thing:
                return power_plant
        return None

    def player_in_game(self, player_name):
        """Returns a player if they are active."""
        for player in self.players:
            if player.name == player_name and not player.is_lost:
                return player
        return None

    def calculate_winner(self):
        """Returns a player, who wins."""
        active_players = 0
        for player in self.players:
            if not player.is_lost:
                active_players += 1
                possible_last_player = player
        if active_players == 1:
            return possible_last_player
        else:
            max_money = 0
            for player in self.players:
                if player.money > max_money:
                    max_money = player.money
                    winner = player
            winners = 0
            for player in self.players:
                if player.money == max_money:
                    winners += 1
            if winners > 1:
                winner = None
            return winner

    def buyable_spaces_names(self):
        """Returns a list of existing spaces' names."""
        result = []
        for space in self.chart.spaces:
            result.append(space.name)
        return result

    def countries(self):
        """Returns a list of existing countries."""
        list_countries = []
        for space in self.chart.spaces:
            if type(space) == City:
                if space.country not in list_countries:
                    list_countries.append(space.country)
        return list_countries


class Interface():
    """class Interface. Contains attributes:
    : param game : game to which this interface is attached
    : type game : Game """
    def __init__(self, game):
        """Creates an object that can communicate with players."""
        self.game = game

    def main_menu(self):
        """Returns action of choice."""
        message("Possible actions: ")
        message("Make a move (finishes your turn)")
        message("Sell space or house")
        message("Mortgage space")
        message("Unmortgage space")
        message("Build house")
        message("Trade (with other player)")
        message("Show chart")
        message("Show my belongings")
        message("Show my money")
        message("Show my pawn")
        message("Leave game")
        message("Quit game (quits game for all)")
        action = input1("What do you want to do? >> ")
        return action

    def waiting_for_payment(self, buyer, seller, required_payment):
        """Makes sure, that the payment is payed."""
        message(f"You have to pay {required_payment}$.")
        while True:
            if buyer.money >= required_payment:
                buyer.money -= required_payment
                if seller:
                    seller.money += required_payment
                return f"The {required_payment}$ has been payed."
            else:
                if self.game.check_players_belongings(buyer) == "There are not things to sell.":
                    buyer.player_looses()
                    return f"{buyer.name}, you are not able to pay your fees. You loose."
                else:
                    choice = self.sell_or_mortgage(buyer, required_payment)
                    if choice == "mortgage":
                        m = self.mortgaging(buyer)
                        message(m)
                    else:
                        m = self.selling(buyer)
                        message(m)

    def buy_yes_or_no(self, space, player):
        """Returns player's decision, whether to buy a space or not."""
        while True:
            decision = input1(f"It is unbought and costs {space.price}$. You have {player.money}$. Do you want to buy this space? Type Yes or No: ")
            if decision == "No":
                return False
            elif decision == "Yes":
                return True
            else:
                message("Wrong command. Please try again.")

    def selling(self, player):
        """Player can sell their belongings here."""
        if player.cities == [] and player.power_plants == [] and player.airports == []:
            return "You have nothing to sell."
        while True:
            message("What do you want to sell? These are your belongings:")
            self.print_belongings(player)
            thing = input1("Write a name of the chosen thing, or 'building', to sell a building: ")
            if thing in self.game.buyable_spaces_names() or thing == "building":
                object_to_sell = self.game.is_in_inventory(thing, player)
                if object_to_sell:
                    return object_to_sell.sell(player)
                elif thing == "building":
                    country = input2("Decide in which country you want to sell a building: ")
                    for city in player.cities:
                        if city.country == country:
                            if city.hotel == 1:
                                return self.game.sell_house(player, city.country, "hotel")
                            else:
                                return self.game.sell_house(player, city.country, "house")
                else:
                    message("You do not have it in your inventory.")
            else:
                message("Wrong command.")

    def sell_or_mortgage(self, player, required_payment):
        """Asks to choose between mortgaging and selling to afford the fee.
        Returns choice."""
        message(f"You need to pay {required_payment}$, but you only have {player.money}$.")
        while True:
            decision = input4("Do you want to sell or mortgage something? Write 'sell' or 'mortgage': ")
            if decision in ["sell", "mortgage"]:
                return decision
            else:
                message("Wrong command.")

    def mortgaging(self, player):
        """Player can mortgage their belongings here."""
        if player.cities == [] and player.power_plants == [] and player.airports == []:
            return "You have nothing to mortgage."
        while True:
            message("What do you want to mortgage? These are your belongings:")
            self.print_belongings(player)
            thing = input1("Write a name of the chosen thing: ")
            if thing in self.game.buyable_spaces_names():
                object_to_mortgage = self.game.is_in_inventory(thing, player)
                if object_to_mortgage:
                    if object_to_mortgage.is_mortgaged:
                        return "This thing is already mortgaged."
                    else:
                        object_to_mortgage.is_mortgaged = True
                        player.money += object_to_mortgage.mortgage
                        return f'{object_to_mortgage.name} is now mortgaged. You cannot collect fees from this space.'
                else:
                    return "You do not have it in your inventory."
            else:
                message("Wrong command.")

    def unmortgaging(self, player):
        """Player can unmortgage their belongings here."""
        if player.cities == [] and player.power_plants == [] and player.airports == []:
            return "You have nothing to unmortgage."
        while True:
            message("What do you want to unmortgage? These are your belongings:")
            self.print_belongings(player)
            thing = input1("Write a name of the chosen thing: ")
            if thing in self.game.buyable_spaces_names():
                object_to_unmortgage = self.game.is_in_inventory(thing, player)
                if object_to_unmortgage:
                    if not object_to_unmortgage.is_mortgaged:
                        return "This thing is not mortgaged."
                    elif player.money < object_to_unmortgage.mortgage:
                        return "You do not have enough money to unmortgage this."
                    else:
                        object_to_unmortgage.is_mortgaged = False
                        player.money -= object_to_unmortgage.mortgage
                        return f'{object_to_unmortgage.name} is now unmortgaged. You can collect fees from this space.'
                else:
                    return "You do not have it in your inventory."
            else:
                message("Wrong command.")

    def building_house(self, player):
        """Player can build houses and hotels here."""
        country = input1("In which country would you like to place a buliding? >> ")
        if country in self.game.countries():
            has_a_country = False
            for city in player.cities:
                if city.country == country:
                    has_a_country = True
                    break
            if has_a_country:
                return player, country
            else:
                return "You do not have any cities in this country."
        else:
            return 'This country does not exist in the game.'

    def player_trading(self, first_player):
        """Player can trade with someone else here."""
        second_player_name = input1("With whom would you like to trade? : ")
        second_player = self.game.player_in_game(second_player_name)
        if not second_player:
            return "There is no such player active."
        buy_or_sell = input2("Do you want to buy from this player or sell something to them? Write 'buy' or 'sell': ")
        if buy_or_sell == "buy":
            buyer = first_player
            seller = second_player
        elif buy_or_sell == "sell":
            seller = first_player
            buyer = second_player
        else:
            return "Wrong command."
        if seller.cities == [] and seller.airports == [] and seller.power_plants == []:
            return "The seller does not have anything to sell."
        message("These are seller's belongings: ")
        self.print_belongings(seller)
        things_name = input3("Write a name of the thing, which will be sold: ")
        thing = self.game.is_in_inventory(things_name, seller)
        if not thing:
            return "There is no such thing in seller's inventory."
        else:
            message(f'It costs {thing.price}$. The buyer has {buyer.money}$.')
            if not thing.is_affordable_for_player(buyer):
                return f"{buyer.name} does not have enough money to buy {thing.name} from {seller.name}."
            confirm = input4('Write "Yes" to confirm the transaction: ')
            if confirm == "Yes":
                return self.game.trade(seller, buyer, thing)
            else:
                return "Transaction not confirmed."

    def print_belongings(self, player):
        """Shows airports, cities and power plants of the given player."""
        print("Airports: ")
        for airport in player.airports:
            print(f'{airport.name}  {"MORTGAGED" if airport.is_mortgaged else ""}')
        print("Power plants: ")
        for power_plant in player.power_plants:
            print(f'{power_plant.name} {"MORTGAGED" if power_plant.is_mortgaged else ""}')
        print("Cities:")
        for city in player.cities:
            print(f'{city.name}, {city.houses} houses, {city.hotel} hotels.  {"MORTGAGED" if city.is_mortgaged else ""}')

    def print_show_money(self, player):
        """Says, how much money the player has."""
        print(f"You have {player.money}$.")

    def print_pawn(self, player):
        """Reminds, which pawn the player has."""
        print(f"Your pawn is {player.pawn}")

# CHART printing
    def houses_string(self, space):
        """Generates a string with buildings on the given space."""
        if type(space) != City:
            return 19 * " "
        if space.hotel == 1:
            return "      H            "
        elif space.houses == 0:
            return "                   "
        else:
            result = "     " + (space.houses * "h")
            while len(result) < 19:
                result += " "
            return result

    def players_string(self, space):
        """Generates a string with players standing on the given space."""
        result = "     "
        space_index = self.game.chart.spaces.index(space)
        for player in self.game.players:
            if player.space_index == space_index and not player.is_lost:
                result += player.pawn
        while len(result) < 19:
            result += " "
        return result

    def house_box(self, number):
        """Returns an empty space if the space is not a city.
        If it is, a string with houses is generated."""
        space = self.game.chart.spaces[number]
        if type(space) == City:
            return self.houses_string(space)
        return 19 * " "

    def border(self, number):
        """Line drawn below the buildings. Empty, if the space is not a city."""
        space = self.game.chart.spaces[number]
        if type(space) == City:
            return 19 * "-"
        return 19 * " "

    def print_chart(self):
        """Prints a full chart."""
        message("|-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------|")
        message(f'|{self.hshort(8)}|{self.hshort(9)}|{self.hshort(10)}|{self.hshort(11)}|{self.hshort(12)}|{self.hshort(13)}|{self.hshort(14)}|{self.hshort(15)}|{self.hshort(16)}|{self.hshort(17)}|')
        message(f'|{self.border(8)}|{self.border(9)}|{self.border(10)}|{self.border(11)}|{self.border(12)}|{self.border(13)}|{self.border(14)}|{self.border(15)}|{self.border(16)}|{self.border(17)}|')
        message(f'|{self.nshort(8)}|{self.nshort(9)}|{self.nshort(10)}|{self.nshort(11)}|{self.nshort(12)}|{self.nshort(13)}|{self.nshort(14)}|{self.nshort(15)}|{self.nshort(16)}|{self.nshort(17)}|')
        message("|                   |                   |                   |                   |                   |                   |                   |                   |                   |                   |")
        message(f'|{self.pshort(8)}|{self.pshort(9)}|{self.pshort(10)}|{self.pshort(11)}|{self.pshort(12)}|{self.pshort(13)}|{self.pshort(14)}|{self.pshort(15)}|{self.pshort(16)}|{self.pshort(17)}|')
        message("|                   |                   |                   |                   |                   |                   |                   |                   |                   |                   |")
        message("|-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------|")
        message(f"|{self.hshort(7)}|                                                                                                                                                               |{self.hshort(18)}|")
        message(f"|{self.border(7)}|                                                                                                                                                               |{self.border(18)}|")
        message(f"|{self.nshort(7)}|                                                                                                                                                               |{self.nshort(18)}|")
        message("|                   |                                                                                                                                                               |                   |")
        message(f"|{self.pshort(7)}|                                                                                                                                                               |{self.pshort(18)}|")
        message("|                   |                                                                                                                                                               |                   |")
        message("|-------------------|                                                                                                                                                               |-------------------|")
        message(f"|{self.hshort(6)}|                                                                                                                                                               |{self.hshort(19)}|")
        message(f"|{self.border(6)}|                                                                                                                                                               |{self.border(19)}|")
        message(f"|{self.nshort(6)}|                                                                                                                                                               |{self.nshort(19)}|")
        message("|                   |                                                                                                                                                               |                   |")
        message(f"|{self.pshort(6)}|                                                                                                                                                               |{self.pshort(19)}|")
        message("|                   |                                                                                                                                                               |                   |")
        message("|-------------------|                                                                                                                                                               |-------------------|")
        message(f"|{self.hshort(5)}|                                                                                                                                                               |{self.hshort(20)}|")
        message(f"|{self.border(5)}|                                                                                                                                                               |{self.border(20)}|")
        message(f"|{self.nshort(5)}|                                                                                                                                                               |{self.nshort(20)}|")
        message("|                   |                                                                                                                                                               |                   |")
        message(f"|{self.pshort(5)}|                                                                                                                                                               |{self.pshort(20)}|")
        message("|                   |                                                                                                                                                               |                   |")
        message("|-------------------|                                                                                                                                                               |-------------------|")
        message(f"|{self.hshort(4)}|                                                                                                                                                               |{self.hshort(21)}|")
        message(f"|{self.border(4)}|                                                                                                                                                               |{self.border(21)}|")
        message(f"|{self.nshort(4)}|                                                                                                                                                               |{self.nshort(21)}|")
        message("|                   |                                                                                                                                                               |                   |")
        message(f"|{self.pshort(4)}|                                                                                                                                                               |{self.pshort(21)}|")
        message("|                   |                                                                                                                                                               |                   |")
        message("|-------------------|                                                                                                                                                               |-------------------|")
        message(f"|{self.hshort(3)}|                                                                                                                                                               |{self.hshort(22)}|")
        message(f"|{self.border(4)}|                                                                                                                                                               |{self.border(22)}|")
        message(f"|{self.nshort(3)}|                                                                                                                                                               |{self.nshort(22)}|")
        message("|                   |                                                                                                                                                               |                   |")
        message(f"|{self.pshort(3)}|                                                                                                                                                               |{self.pshort(22)}|")
        message("|                   |                                                                                                                                                               |                   |")
        message("|-------------------|                                                                                                                                                               |-------------------|")
        message(f"|{self.hshort(2)}|                                                                                                                                                               |{self.hshort(23)}|")
        message(f"|{self.border(2)}|                                                                                                                                                               |{self.border(23)}|")
        message(f"|{self.nshort(2)}|                                                                                                                                                               |{self.nshort(23)}|")
        message("|                   |                                                                                                                                                               |                   |")
        message(f"|{self.pshort(2)}|                                                                                                                                                               |{self.pshort(23)}|")
        message("|                   |                                                                                                                                                               |                   |")
        message("|-------------------|                                                                                                                                                               |-------------------|")
        message(f"|{self.hshort(1)}|                                                                                                                                                               |{self.hshort(24)}|")
        message(f"|{self.border(1)}|                                                                                                                                                               |{self.border(24)}|")
        message(f"|{self.nshort(1)}|                                                                                                                                                               |{self.nshort(24)}|")
        message("|                   |                                                                                                                                                               |                   |")
        message(f"|{self.pshort(1)}|                                                                                                                                                               |{self.pshort(24)}|")
        message("|                   |                                                                                                                                                               |                   |")
        message("|-------------------|                                                                                                                                                               |-------------------|")
        message("|-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------|")
        message(f'|{self.hshort(0)}|{self.hshort(33)}|{self.hshort(32)}|{self.hshort(31)}|{self.hshort(30)}|{self.hshort(29)}|{self.hshort(28)}|{self.hshort(27)}|{self.hshort(26)}|{self.hshort(25)}|')
        message(f'|{self.border(0)}|{self.border(33)}|{self.border(32)}|{self.border(31)}|{self.border(30)}|{self.border(29)}|{self.border(28)}|{self.border(27)}|{self.border(26)}|{self.border(25)}|')
        message(f'|{self.nshort(0)}|{self.nshort(33)}|{self.nshort(32)}|{self.nshort(31)}|{self.nshort(30)}|{self.nshort(29)}|{self.nshort(28)}|{self.nshort(27)}|{self.nshort(26)}|{self.nshort(25)}|')
        message("|                   |                   |                   |                   |                   |                   |                   |                   |                   |                   |")
        message(f'|{self.pshort(0)}|{self.pshort(33)}|{self.pshort(32)}|{self.pshort(31)}|{self.pshort(30)}|{self.pshort(29)}|{self.pshort(28)}|{self.pshort(27)}|{self.pshort(26)}|{self.pshort(25)}|')
        message("|                   |                   |                   |                   |                   |                   |                   |                   |                   |                   |")
        message("|-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------.-------------------|")

# SHORTCUTS to string generators
    def hshort(self, number):
        """Shorter form of house string function."""
        return self.house_box(number)

    def nshort(self, number):
        """Returns a string with space's name."""
        result = self.game.chart.spaces[number].name
        while len(result) < 19:
            result += " "
        return result

    def pshort(self, number):
        """Shorter form of standing players function."""
        return self.players_string(self.game.chart.spaces[number])

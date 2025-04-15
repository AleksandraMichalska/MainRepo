import monopoly_classes as c
import monopoly_all_parts_declaration as d


def people_remaining(game):
    """Checks the number of active players."""
    counter = 0
    for player in game.players:
        if not player.is_lost:
            counter += 1
    return counter


def message(string):
    """Mockable print function."""
    print(string)


def declaration_of_players(start_index):
    """Players give their data here. Player objects are created."""
    list_of_players = []
    message("Welcome to Monopoly.")
    while True:
        players_number = input("Write the amount of players, from 2 to 4: ")
        if players_number not in ["2", "3", "4"]:
            message("Wrong number.")
        else:
            break
    players_number = int(players_number)
    pawns = ["&", "*", "@", "§"]
    for declaration in range(players_number):
        while True:
            name = input(f"Player number {declaration+1}, what is your name? >> ")
            in_use = False
            for p in list_of_players:
                if p.name == name:
                    message("This name is already in use. Try something different.")
                    in_use = True
            if not in_use:
                confirmation = input("Write 'Yes' if you confirm your choice: ")
                if confirmation == "Yes":
                    message("Name confirmed.")
                    break
                else:
                    message("Name not confirmed.")
        while True:
            message("These are the available pawns: ")
            message(pawns)
            pawn = input("Choose your pawn: ")
            if pawn in pawns:
                pawns.remove(pawn)
                break
            else:
                message("The pawn like this is not available.")
        finished_player = c.Player(name, pawn, start_index)
        list_of_players.append(finished_player)
    message("Thank you. The list of players is complete.")
    return list_of_players


def variables_preparation():
    """Players are put on the start.
    Game and interface are created."""
    for space in d.chart.spaces:
        if type(space) == c.Start:
            start_index = d.chart.spaces.index(space)
            break
    players = declaration_of_players(start_index)
    game = c.Game(players, d.chart)
    interface = c.Interface(game)
    message("The game begins!")
    return game, interface


def application():
    """Working game."""
    data = variables_preparation()
    game = data[0]
    interface = data[1]
    while True:
        for player in game.players:
            if not player.is_lost:
                message(f"{player.name}'s turn.")
                while True:
                    prison_check = player.check_prison()
                    if prison_check:
                        message(prison_check)
                        if player.in_prison:
                            break
                    menu_result = interface.main_menu()
                    if type(menu_result) == tuple:
                        action = menu_result[0]
                        set_free_message = menu_result[1]
                        message(set_free_message)
                    else:
                        action = menu_result
                    if action == "Make a move":
                        make_a_move_result = game.make_a_move(player)
                        if len(make_a_move_result) == 3:
                            if not make_a_move_result[2]:  # doublet rolled two times, imprisonate
                                message(make_a_move_result[0])
                                message(make_a_move_result[1])
                                message("You received identical dices two times in a row. You go to prison for 3 rounds.")
                                player.imprisonate(game)
                                break
                            else:  # the first roll is a doublet, the second is normal, continue
                                message(make_a_move_result[0])
                                message(make_a_move_result[1])
                                move_spaces = make_a_move_result[2]
                        else:
                            move_spaces = make_a_move_result[1]
                            message(make_a_move_result[0])
                        move_pawn_result = game.move_pawn(player, move_spaces)
                        if type(move_pawn_result) == tuple:  # start crossed, continue
                            space = move_pawn_result[0]
                            start_crossed = move_pawn_result[1]
                            message(start_crossed)
                        else:
                            space = move_pawn_result
                        message(f"You have arrived to {space.name}.")
                        event_result = space.event(player=player, game=game, interface=interface, moved_spaces=move_spaces)
                        if type(event_result) == tuple:  # event returns a message or a tuple with payment data
                            payer = event_result[0]
                            seller = event_result[1]
                            required_payment = event_result[2]
                            payment_result = interface.waiting_for_payment(payer, seller, required_payment)
                            message(payment_result)
                            if payment_result == f"The {required_payment}$ has been payed.":
                                break
                        else:
                            message(event_result)
                        break
                    elif action == "Sell space or house":
                        phrase = interface.selling(player)
                        message(phrase)
                    elif action == "Mortgage space":
                        interface.mortgaging(player)
                    elif action == "Unmortgage space":
                        interface.unmortgaging(player)
                    elif action == "Build house":
                        data = interface.building_house(player)
                        if type(data) == tuple:  # country found in players belongings
                            phrase = game.build_house(data[0], data[1])
                            message(phrase)
                        else:
                            message(data)
                    elif action == "Trade":
                        phrase = interface.player_trading(player)
                        message(phrase)
                    elif action == "Show chart":
                        interface.print_chart()
                    elif action == "Show my belongings":
                        interface.print_belongings(player)
                    elif action == "Show my money":
                        interface.print_show_money(player)
                    elif action == "Show my pawn":
                        interface.print_pawn(player)
                    elif action == "Leave game":
                        confirm_leave = input("Write 'Yes' to confirm your exit: ")
                        if confirm_leave == "Yes":
                            player.player_looses()
                            message(f"{player.name} has left the game.")
                            break
                        message("You are still in the game.")
                    elif action == "Quit game":
                        confirm_quit = input("Write 'Yes' to confirm quitting: ")
                        if confirm_quit == "Yes":
                            winner = game.calculate_winner()
                            if not winner:
                                message("There are more than one player with the most money, so there are no winners. Thank you all for playing!")
                            else:
                                message(f"The winner is {winner.name}. Thank you all for playing!")
                            for p in game.players:
                                p.player_looses()
                            break
                        else:
                            message("The game continues.")
                    else:
                        message('Wrong command.')
            if people_remaining(game) == 1:
                winner = game.calculate_winner()
                message(f"{winner.name} wins as the last person remaining. Thank you for playing!")
                exit()
            if people_remaining(game) == 0:
                exit()

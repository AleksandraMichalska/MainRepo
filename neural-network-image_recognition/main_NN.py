import numpy as np
import matplotlib.pyplot as plt
from utilis_NN import *


def two_layer_model(X, Y, layers_dims, learning_rate=0.001, num_iterations=500, print_cost=True):
    """
    Implementacja dwuwarstwej siecu neuronoweh:
    
    Argumenty:
    X -- dane wejściowe, kształt 
    Y -- wektor prawdziwych etykiet ( 1 - 'kot', 0 - 'nie-kot'),
    layers_dims -- wymiary warstw
    num_iterations -- liczba iteracji 
    learning_rate -- współczynnik uczenia się 
    
    Zwraca:
    parameters -- słownik zawierający W1, W2, b1, b2
    """
    
    np.random.seed(1)
    grads = {}
    costs = []  # do śledzenia kosztu
    m = X.shape[1]  # liczba przykładów0075

    # Inicjalizacja słownika parametrów
    parameters = initialize_parameters(layers_dims[0], layers_dims[1], layers_dims[2])  #  kod inicjalizacji parametrów
    
    # Pętla (gradient prosty)
    for i in range(num_iterations):

        # Propagacja wprzód:
        A1, cache1 = linear_activation_forward(X, parameters["W1"], parameters["b1"], "relu")  #  kod propagacji wprzód dla pierwszej warstwy
        A2, cache2 = linear_activation_forward(A1, parameters["W2"], parameters["b2"], "sigmoid")  #  kod propagacji wprzód dla drugiej warstwy
        
        # Obliczanie kosztu
        cost = compute_cost(A2, Y)  #  kod obliczania kosztu
        
        # Inicjalizacja propagacji wstecznej
        dA2 = - (np.divide(Y, A2) - np.divide(1 - Y, 1 - A2))
        
        # Propagacja wsteczna
        dA1, dW2, db2 = linear_activation_backward(dA2, cache2, "sigmoid")  #  kod propagacji wstecznej dla drugiej warstwy
        dA0, dW1, db1 = linear_activation_backward(dA1, cache1, "relu")  #  kod propagacji wstecznej dla pierwszej warstwy
        
        # Aktualizacja parametrów
        parameters = update_parameters(parameters, {"dW1": dW1, "dW2": dW2, "db1": db1, "db2": db2}, learning_rate)  #  kod aktualizacji parametrów
        
        # Wyświetlanie kosztów co 10 iteracji
        if print_cost and i % 10 == 0:
            print(f"Koszt po iteracji {i}: {np.squeeze(cost)}")
        if print_cost and i % 10 == 0:
            costs.append(cost)

    return parameters


if __name__ == "__main__":
    train_set_x_orig, train_set_y_orig, test_set_x_orig, test_set_y_orig, classes = load_data()

    parameters = two_layer_model(train_set_x_orig, train_set_y_orig, (64*64*3, 10000, 1), 0.05, 500, True)

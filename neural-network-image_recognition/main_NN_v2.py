import numpy as np
import matplotlib.pyplot as plt
from utilis_NN import *

output_file = open("output.txt", "w")

def two_layer_model(X, Y, layers_dims, learning_rate=0.001, num_iterations=500, print_cost=True, test_pictures=[], class_labels=[]):
    """
    Implementacja dwuwarstwej siecu neuronowej:
    
    Argumenty:
    X -- dane wejściowe, kształt 
    Y -- wektor prawdziwych etykiet ( 1 - 'kot', 0 - 'nie-kot'),
    layers_dims -- wymiary warstw
    num_iterations -- liczba iteracji 
    learning_rate -- współczynnik uczenia się 
    
    Zwraca:
    parameters -- słownik zawierający W1, W2, b1, b2
    """
    if print_cost:
        output_file = open(f'output_{layers_dims[1]}_{learning_rate}.txt', "w")

    np.random.seed(1)
    grads = {}
    costs = []  # do śledzenia kosztu
    m = X.shape[1]  # liczba przykładów0075
    (n_x, n_h, n_y) = layers_dims
    
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
        dA1, dW2, db2 = linear_activation_backward(dA2, cache2, "sigmoid")  #  kod propagacji wstecznej dla drugiej warstwy #tutaj nie jestem pewien, czy cahe1, czy 2
        dA0, dW1, db1 = linear_activation_backward(dA1, cache1, "relu")  #  kod propagacji wstecznej dla pierwszej warstwy
        
        # Aktualizacja parametrów
        parameters = update_parameters(parameters, {"dW1": dW1, "dW2": dW2, "db1": db1, "db2": db2}, learning_rate)  #  kod aktualizacji parametrów
        
        # Zapis kosztów do pliku
        if print_cost:
            output_file.write(f"{i};{np.squeeze(cost)}\n")
            print(f"Numer iteracji {i}: {np.squeeze(cost)}")
    
    if print_cost:
        output_file.close()

    #testowanie 
    if len(test_pictures) != 0 and len(class_labels) != 0:
        print("testowanie...")
        predicted_classes = []
        comparisons = []
        A1, cache1 = linear_activation_forward(test_pictures, parameters["W1"], parameters["b1"], "relu")  #  kod propagacji wprzód dla pierwszej warstwy
        A2, cache2 = linear_activation_forward(A1, parameters["W2"], parameters["b2"], "sigmoid")  #  kod propagacji wprzód dla drugiej warstwy
        for probability in A2[0]:
            predicted_class = round(probability)
            predicted_classes.append(predicted_class)
        for i in range(len(class_labels)):
            if class_labels[i] == predicted_classes[i]:
                comparisons.append("correct")
            else:
                comparisons.append("incorrect")
        accuracy = comparisons.count("correct")/len(comparisons)
        print(f'Skuteczność {accuracy}')
    return parameters

if __name__ == "__main__":
    train_set_x_orig, train_set_y_orig, test_set_x_orig, test_set_y_orig, classes = load_data()
    parameters = two_layer_model(train_set_x_orig, train_set_y_orig, (64*64*3, 6000, 1), 0.05, 10, True, test_set_x_orig, test_set_y_orig)

  

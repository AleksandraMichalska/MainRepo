import numpy as np
from utilis_NN import *
import argparse


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
    output_file = open(f'output_{layers_dims[1]}_{learning_rate}.txt', "w")
    output_test_file = open(f'output_test_{layers_dims[1]}_{learning_rate}.txt', "w")
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
        total_cost = compute_cost(A2, Y)  #  kod obliczania kosztu
        cost = total_cost/len(A2[0]) # koszt na obraz
        
        # Inicjalizacja propagacji wstecznej
        dA2 = - (np.divide(Y, A2) - np.divide(1 - Y, 1 - A2))
        
        # Propagacja wsteczna
        dA1, dW2, db2 = linear_activation_backward(dA2, cache2, "sigmoid")  #  kod propagacji wstecznej dla drugiej warstwy
        dA0, dW1, db1 = linear_activation_backward(dA1, cache1, "relu")  #  kod propagacji wstecznej dla pierwszej warstwy
        
        # Aktualizacja parametrów
        parameters = update_parameters(parameters, {"dW1": dW1, "dW2": dW2, "db1": db1, "db2": db2}, learning_rate)  #  kod aktualizacji parametrów
        
        # Zapis kosztów do pliku
        if i % 10 == 0:
            output_file.write(f"{i};{np.squeeze(cost)}\n")
            if print_cost:
                print(f"Numer iteracji {i}: {np.squeeze(cost)}")
            test(test_pictures, class_labels, i, parameters, output_test_file)
    
    output_file.close()
    output_test_file.close()

    
    return parameters

def test(test_pictures, class_labels, iteration, parameters, output_test_file):
    print("testowanie...")
    predicted_classes = []
    comparisons = []
    A1, cache1 = linear_activation_forward(test_pictures, parameters["W1"], parameters["b1"], "relu")  #  kod propagacji wprzód dla pierwszej warstwy
    A2, cache2 = linear_activation_forward(A1, parameters["W2"], parameters["b2"], "sigmoid")  #  kod propagacji wprzód dla drugiej warstwy
    total_cost = compute_cost(A2, class_labels)
    cost_per_image = total_cost/len(A2[0])
    print(f'Koszt dla obrazu testowego: {cost_per_image}')
    output_test_file.write(f'{iteration};{cost_per_image}\n')
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


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("hidden_neurons_number")
    parser.add_argument("iterations_number")
    parser.add_argument("learning_rate")
    args = parser.parse_args()
    args.hidden_neurons_number = int(args.hidden_neurons_number)
    args.iterations_number = int(args.iterations_number)
    args.learning_rate = float(args.learning_rate)
    train_set_x_orig, train_set_y_orig, test_set_x_orig, test_set_y_orig, classes = load_data()
    parameters = two_layer_model(train_set_x_orig, train_set_y_orig, (64*64*3, args.hidden_neurons_number, 1), args.learning_rate, args.iterations_number, True, test_set_x_orig, test_set_y_orig)

  

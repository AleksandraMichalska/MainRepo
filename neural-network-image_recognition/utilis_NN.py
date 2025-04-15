import numpy as np
import h5py

def sigmoid(Z):
    """
    Argumenty:
    Z -- tablica numpy o dowolnym kształcie

    Zwraca:
    A -- wynik funkcji sigmoid(z), taki sam kształt jak Z
    cache -- zwraca również Z, przydatne podczas propagacji wstecznej
    """
    A = 1 / (1 + np.exp(-Z))
    cache = Z

    return A, cache


def relu(Z):
    """
    Argumenty:
    Z -- Wynik warstwy liniowej, dowolny kształt

    Zwraca:
    A -- Parametr po aktywacji, ten sam kształt co Z
    cache -- słownik pythona zawierający "A"; przechowywany do efektywnego obliczania propagacji wstecznej
    """
    A = np.maximum(0, Z)
    cache = Z

    return A, cache


def relu_backward(dA, cache):
    """
    Argumenty:
    dA -- gradient po aktywacji, dowolny kształt
    cache -- 'Z', przechowywane dla efektywnego obliczania propagacji wstecznej

    Zwraca:
    dZ -- Gradient kosztu względem Z
    """
    Z = cache
    dZ = np.array(dA, copy=True)
    dZ[Z <= 0] = 0
    
    return dZ

def sigmoid_backward(dA, cache):
    """
    Argumenty:
    dA -- gradient po aktywacji, dowolny kształt
    cache -- 'Z', przechowywane dla efektywnego obliczania propagacji wstecznej

    Zwraca:
    dZ -- Gradient kosztu względem Z
    """

    Z = cache
    sigmoid = 1 / (1 + np.exp(-Z))
    dZ = dA * sigmoid * (1 - sigmoid)

    return dZ


def balance_dataset(annotation, images):
    indexes_class_0 = np.where(annotation == 0)[0]
    indexes_class_1 = np.where(annotation == 1)[0]

    # Liczba obiektów w każdej klasie
    count_class_0 = len(indexes_class_0)
    count_class_1 = len(indexes_class_1)

    # Różnica w liczbie obiektów między klasami
    difference = count_class_0 - count_class_1

    # Jeśli klasa 1 ma mniej obiektów niż klasa 0, dodajemy powtórzenia obiektów klasy 1
    if difference > 0:
        repeated_indexes_class_1 = np.random.choice(indexes_class_1, size=difference, replace=True)
        images = np.concatenate((images, images[repeated_indexes_class_1]))
        annotation = np.concatenate((annotation, np.ones(difference, dtype=int)))

    # Jeśli klasa 0 ma mniej obiektów niż klasa 1, dodajemy powtórzenia obiektów klasy 0
    if difference < 0:
        repeated_indexes_class_0 = np.random.choice(indexes_class_0, size=difference, replace=True)
        images = np.concatenate((images, images[repeated_indexes_class_0]))
        annotation = np.concatenate((annotation, np.ones(difference, dtype=int)))
    # Teraz liczba obiektów klas 0 i 1 w zbiorze jest taka sama

    # Wymieszaj zbiór
    permutation = np.random.permutation(len(images))
    images = images[permutation]
    annotation = annotation[permutation]

    return annotation, images


def load_data():
    """
    Zwraca:
    train_set_x_orig -- tablica numpy z cechami zestawu treningowego
    train_set_y_orig -- tablica numpy z etykietami zestawu treningowego
    test_set_x_orig -- tablica numpy z cechami zestawu testowego
    test_set_y_orig -- tablica numpy z etykietami zestawu testowego
    classes -- tablica numpy z listą klas
    """

    train_dataset = h5py.File('train_catvnoncat.h5', "r")
    train_set_x_orig = np.array(train_dataset["train_set_x"][:]) / 255.0 
    train_set_y_orig = np.array(train_dataset["train_set_y"][:])

    test_dataset = h5py.File('test_catvnoncat.h5', "r")
    test_set_x_orig = np.array(test_dataset["test_set_x"][:]) / 255.0
    test_set_y_orig = np.array(test_dataset["test_set_y"][:])

    classes = np.array(test_dataset["list_classes"][:])

    train_set_y_orig, train_set_x_orig = balance_dataset(train_set_y_orig, train_set_x_orig)
    test_set_y_orig, test_set_x_orig = balance_dataset(test_set_y_orig, test_set_x_orig)

    train_set_x_orig = train_set_x_orig.reshape(train_set_x_orig.shape[0], -1).T
    test_set_x_orig = test_set_x_orig.reshape(test_set_x_orig.shape[0], -1).T

    return train_set_x_orig, train_set_y_orig, test_set_x_orig, test_set_y_orig, classes


def initialize_parameters(n_x, n_h, n_y):
    """
    Argumenty:
    n_x -- rozmiar warstwy wejściowej
    n_h -- rozmiar warstwy ukrytej
    n_y -- rozmiar warstwy wyjściowej

    Zwraca:
    parameters -- słownik Pythona zawierający parametry:
                  W1 -- macierz wag o kształcie (n_h, n_x)
                  b1 -- wektor bias o kształcie (n_h, 1)
                  W2 -- macierz wag o kształcie (n_y, n_h)
                  b2 -- wektor bias o kształcie (n_y, 1)
    """

    w1 = 1 / (n_x ** 0.5)
    parameters = {"W1": np.random.uniform(-w1, w1, size=(n_h, n_x)), "W2": np.random.uniform(0, 0, size=(n_y, n_h)), "b1": np.random.uniform(-w1, w1, size=(n_h, 1)), "b2": np.random.uniform(0, 0, size=(n_y, 1))}


    return parameters


def linear_forward(A, W, b):
    """
    Argumenty:
    A -- aktywacje z poprzedniej warstwy (lub dane wejściowe): (rozmiar poprzedniej warstwy, liczba przykładów)
    W -- macierz wag: tablica numpy o kształcie (rozmiar bieżącej warstwy, rozmiar poprzedniej warstwy)
    b -- wektor bias, tablica numpy o kształcie (rozmiar bieżącej warstwy, 1)

    Zwraca:
    Z -- wejście funkcji aktywacji, nazywane również parametrem przed aktywacją
    cache -- słownik python zawierający "A", "W" i "b"; przechowywany do efektywnego obliczania propagacji wstecznej
    """
    Z = np.dot(W, A) + b
    cache = (A, W, b)

    return Z, cache


def linear_activation_forward(A_prev, W, b, activation):
    """
    Argumenty:
    A_prev -- aktywacje z poprzedniej warstwy (lub dane wejściowe): (rozmiar poprzedniej warstwy, liczba przykładów)
    W -- macierz wag: tablica numpy o kształcie (rozmiar bieżącej warstwy, rozmiar poprzedniej warstwy)
    b -- wektor bias, tablica numpy o kształcie (rozmiar bieżącej warstwy, 1)
    activation -- funkcja aktywacji używana w tej warstwie, przechowywana jako tekst: "sigmoid" lub "relu"

    Zwraca:
    A -- wynik funkcji aktywacji, nazywany również wartością po aktywacji
    cache -- słownik python zawierający "linear_cache" i "activation_cache";
             przechowywany do efektywnego obliczania propagacji wstecznej
    """

    Z, linear_cache = linear_forward(A_prev, W, b)
    
    if activation == "sigmoid":
        A, activation_cache = sigmoid(Z)
    elif activation == "relu":
        A, activation_cache = relu(Z)
    
    cache = (linear_cache, activation_cache)

    return A, cache


def compute_cost(AL, Y):
    """
    Argumenty:
    AL -- wektor prawdopodobieństwa odpowiadający twoim przewidywaniom etykiet, kształt (1, liczba przykładów)
    Y -- prawdziwy wektor etykiet (na przykład zawierający 0, jeśli nie-kot, 1, jeśli kot), kształt (1, liczba przykładów)

    Zwraca:
    cost -- koszt entropii krzyżowej
    """
    dif = AL.flatten() - Y
    cost = np.dot(dif, dif)
    return cost

def linear_backward(dZ, cache):
    """
    Argumenty:
    dZ -- Gradient kosztu względem liniowego wyjścia (bieżącej warstwy l)
    cache -- krotka wartości (A_prev, W, b) pochodząca z propagacji wprzód w bieżącej warstwie

    Zwraca:
    dA_prev -- Gradient kosztu względem aktywacji (poprzedniej warstwy l-1), taki sam kształt jak A_prev
    dW -- Gradient kosztu względem W (bieżącej warstwy l), taki sam kształt jak W
    db -- Gradient kosztu względem b (bieżącej warstwy l), taki sam kształt jak b
    """
    A_prev, W, b = cache
    m = A_prev.shape[1]
    dW = 1/m * np.dot(dZ, A_prev.T)
    db = 1/m * np.sum(dZ, axis=1, keepdims=True)
    dA_prev = np.dot(W.T, dZ)

    return dA_prev, dW, db

def linear_activation_backward(dA, cache, activation):
    """
    Argumenty:
    dA -- gradient po aktywacji dla bieżącej warstwy l
    cache -- krotka wartości (linear_cache, activation_cache) przechowywana dla efektywnego obliczania propagacji wstecznej
    activation -- funkcja aktywacji używana w tej warstwie, "sigmoid" lub "relu"

    Zwraca:
    dA_prev -- Gradient kosztu względem aktywacji (poprzedniej warstwy l-1), taki sam kształt jak A_prev
    dW -- Gradient kosztu względem W (bieżącej warstwy l), taki sam kształt jak W
    db -- Gradient kosztu względem b (bieżącej warstwy l), taki sam kształt jak b
    """
    linear_cache, activation_cache = cache

    if activation == "relu":
        dZ = relu_backward(dA, activation_cache)
    elif activation == "sigmoid":
        dZ = sigmoid_backward(dA, activation_cache)
    
    dA_prev, dW, db = linear_backward(dZ, linear_cache)

    return dA_prev, dW, db

def update_parameters(parameters, grads, learning_rate):
    """
    Argumenty:
    parameters -- słownik Pythona zawierający twoje parametry
    grads -- słownik Pythona zawierający twoje gradienty, wynik L_model_backward
    learning_rate -- współczynnik uczenia się

    Zwraca:
    parameters -- słownik Pythona zawierający zaktualizowane parametry
                  parameters["W" + str(l)] = ...
                  parameters["b" + str(l)] = ...
    """

    parameters["W1"] = parameters["W1"] - learning_rate * grads["dW1"]
    parameters["b1"] = parameters["b1"] - learning_rate* grads["db1"]    
    parameters["W2"] = parameters["W2"] - learning_rate* grads["dW2"]  
    parameters["b2"] = parameters["b2"] - learning_rate * grads["db2"]  

    return parameters

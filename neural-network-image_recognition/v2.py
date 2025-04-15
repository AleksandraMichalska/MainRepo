import h5py
from matplotlib import pyplot as plt
import numpy as np
import random
import argparse

class Neuron:
    sum = 0
    last_error = 0
    is_finishing = False
    activation_value = 0
    last_input = None

    def __init__(self, weights_nr, is_finishing):
        self.is_finishing = is_finishing
        limit = 1 / (weights_nr ** 0.5)
        self.weights = np.random.uniform(-limit, limit, size=weights_nr)

    def calculate_activation(self, input_data):
        self.last_input = input_data
        input_data = np.concatenate((input_data, [1.0]))
        if np.shape(input_data)[0] != np.shape(self.weights)[0]:
            raise ValueError("Number of inputs is not compatible with the amount of weights.")
        self.sum = input_data.dot(self.weights)
        if not self.is_finishing:
            return self.ReLU()
        else:
            return self.sigmoid()

    def ReLU(self):
        self.activation_value = np.maximum(self.sum, 0)
        return self.activation_value

    def ReLU_derivative(self):
        if self.sum > 0:
            return 1
        else:
            return 0

    def sigmoid(self):
        self.activation_value = 1.0 / (1.0 + np.exp(-self.sum))
        return self.activation_value


class Network:
    hidden_layer = []


    def __init__(self, hidden_neurons_nr):
        # nie tworzymy warstwy neuronów wejściowych, bo te nie dokonują żadnych obliczeń. Jedynie podają dalej wejście sieci
        self.hidden_layer = [Neuron(64*64*3 + 1, False) for _ in range(hidden_neurons_nr)] #liczba połączeń: liczba całych pikseli*3 składowe + bias
        self.output_neuron = Neuron(hidden_neurons_nr+1, True)

    def forward_propagation(self, input_data): # przepuszczenie przez sieć liczb wejściowych i zwrócenie pobudzenia ostatnich neuronów
        layer_outputs = []
        for neuron in self.hidden_layer:
            neuron.calculate_activation(input_data)
            layer_outputs.append(neuron.activation_value)
        self.output_neuron.calculate_activation(np.array(layer_outputs))
        return self.output_neuron.activation_value

    def backward_propagation(self, expected_output): # obliczamy błędy dla wszystkich neuronów
        self.output_neuron.last_error = self.cost_calculation_finishing_neuron(expected_output)
        for n, neuron in enumerate(self.hidden_layer):
            neuron.last_error = self.cost_calculation_hidden_neuron(neuron, n)

    def cost_calculation_finishing_neuron(self, expected_output):
        print((self.output_neuron.sigmoid() - expected_output) ** 2)
        return (self.output_neuron.sigmoid() - expected_output) ** 2 # dla neuronu kończącego jest to różnica faktycznego wyniku i oczekiwanego

    def cost_calculation_hidden_neuron(self, hidden_neuron, hidden_neuron_index_in_layer):
        return self.output_neuron.last_error*self.output_neuron.weights[hidden_neuron_index_in_layer]*hidden_neuron.ReLU_derivative()

    def gradient(self, previous_neuron_activation_value, this_neuron):
        return previous_neuron_activation_value * this_neuron.last_error

    def parameters_update(self, learning_rate):
        # najpierw aktualizujemy wagi, które łączą neurony wejściowe z ukrytymi
        for n, neuron in enumerate(self.hidden_layer):
            #aktualizacja wag dla wejść
            for i, input in enumerate(neuron.last_input):
                neuron.weights[i] = neuron.weights[i] - learning_rate*self.gradient(input, neuron)
            #aktualizacja wagi bias
            neuron.weights[-1] = neuron.weights[-1] - learning_rate*self.gradient(1, neuron)
        # teraz aktualizujemy wagi, które łączą neurony ukryte z neuronem wejściowym
        for i, input in enumerate(self.output_neuron.last_input):
            self.output_neuron.weights[i] = self.output_neuron.weights[i] - learning_rate*self.gradient(input, self.output_neuron)
        #aktualizacja wagi bias
        self.output_neuron.weights[-1] = self.output_neuron.weights[-1] - learning_rate*self.gradient(1, self.output_neuron)

    def prediction(self, input_data):
        return self.forward_propagation(input_data)

    def training(self, pictures_list, class_labels, iterations, learning_rate):
        for iteration in range(iterations):
            chosen_picture_index = iteration%len(pictures_list) # jeśli skończą się obrazy na liście, zaczynamy od początku
            picture = pictures_list[chosen_picture_index]
            picture = picture.flatten()
            self.prediction(picture)
            self.backward_propagation(class_labels[chosen_picture_index])
            self.parameters_update(learning_rate)

    def testing(self, test_pictures, class_labels):
        results = []
        outputs = []
        for p, test_picture in enumerate(test_pictures):
            test_picture = test_picture.flatten()
            output = self.prediction(test_picture)
            outputs.append(output)
            actual_output = round(output)
            if actual_output == class_labels[p]:
                results.append("correct")
            else:
                results.append("incorrect")
        accuracy = results.count("correct")/len(results)
        return results, accuracy

def load_dataset():
    train_dataset = h5py.File('train_catvnoncat.h5', "r")
    train_images = np.array(
        train_dataset["train_set_x"][:]) / 255.0  # lista obrazów, które posłużą do uczenia modelu.
    train_class_affiliation = np.array(train_dataset["train_set_y"][
                                       :])  # lista wartości 1 lub 0 oznaczających bycie kotem lub nie dla obrazów treningowych

    # analogiczny zestaw danych, który posłuży do testowania modelu
    test_dataset = h5py.File('test_catvnoncat.h5', "r")
    test_images = np.array(test_dataset["test_set_x"][:]) / 255.0
    test_class_affiliation = np.array(test_dataset["test_set_y"][:])

    list_of_classes = np.array(test_dataset["list_classes"][:])

    train_class_affiliation, train_images = balance_dataset(train_class_affiliation, train_images)

    return train_images, train_class_affiliation, test_images, test_class_affiliation, list_of_classes

def balance_dataset(train_class_affiliation, train_images):
    indexes_class_0 = np.where(train_class_affiliation == 0)[0]
    indexes_class_1 = np.where(train_class_affiliation == 1)[0]

    # Liczba obiektów w każdej klasie
    count_class_0 = len(indexes_class_0)
    count_class_1 = len(indexes_class_1)

    # Różnica w liczbie obiektów między klasami
    difference = count_class_0 - count_class_1

    # Jeśli klasa 1 ma mniej obiektów niż klasa 0, dodajemy powtórzenia obiektów klasy 1
    if difference > 0:
        # Powtórz obiekty klasy 1, aby zrównoważyć zbiór
        repeated_indexes_class_1 = np.random.choice(indexes_class_1, size=difference, replace=True)
        train_images = np.concatenate((train_images, train_images[repeated_indexes_class_1]))
        train_class_affiliation = np.concatenate((train_class_affiliation, np.ones(difference, dtype=int)))

    # Teraz liczba obiektów klas 0 i 1 w zbiorze uczącym jest taka sama

    # Wymieszaj zbiór uczący
    permutation = np.random.permutation(len(train_images))
    train_images = train_images[permutation]
    train_class_affiliation = train_class_affiliation[permutation]

    return train_class_affiliation, train_images

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("hidden_neurons_number")
    parser.add_argument("iterations_number")
    parser.add_argument("learning_rate")
    #args = parser.parse_args()
    print("Ładowanie datasetu...")
    train_images, train_class_affiliation, test_images, test_class_affiliation, list_of_classes = load_dataset()
    neural_network = Network(int(100))
    print("Trenowanie sieci...")
    neural_network.training(train_images, train_class_affiliation, 500, 0.00001) #208
    print("Testowanie sieci...")
    test_results, accuracy = neural_network.testing(test_images, test_class_affiliation)
    print("Skuteczność modelu: " + str(accuracy))
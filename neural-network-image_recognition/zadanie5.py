import h5py
from matplotlib import pyplot as plt
import numpy as np
import random
import argparse


# budowa listy obrazów (czyli co jest na kolejnych zagnieżdżonych w sobie listach): 1.obraz 2.rząd 3.piksel 4.wartość składowej r, g lub b w pikselu.
# jest 209 obrazów treningowych i 50 obrazów testowych. Każdy ma 64 rzędy po 64 piksele. Piksel ma 3 składowe.
# propozycja liczby neuronów na każdej warstwie:
# wejściowa: 64*64*3 = 12288. Tyle atomowych liczb otrzymamy dla jednego obrazu.
# ukryta: liczba, przez którą jest podzielne 4096 pikseli. Niech każdy neuron zajmie się jednakową liczbą pikseli. Będzie mieć wag: 3*liczba_pikseli_na_neuron + 1 dodatkowa waga.
# wyjściowa: 1. Dostanie wszystkie wyjścia warstwy poprzedniej. Wartość pobudzenia tego neuronu to prawdopodobieństwo, że na obrazie jest kot
# neurony z ostatniej warstwy korzystają z sigmoid jako funkcji aktywacji, a neurony z ukrytych warstw - z ReLU
class Neuron:
    # weights
    last_sum = 0  # tutaj zapamiętujemy ostatnio obliczoną sumę danych wejściowych pomnożonych przez ich wagi
    last_error = 0  # tutaj zapamiętujemy ostatnio obliczone odstępstwo od oczekiwanego wyniku, aby móc przekazać je poprzednim neuronom do obliczenia ich odstępstwa
    is_finishing = False  # czy neuron znajduje się w ostatniej warstwie
    last_input = []
    last_activation_value = 0

    def __init__(self, weights_nr, is_finishing):
        self.is_finishing = is_finishing
        self.weights = [random.uniform(0, 1) for _ in
                        range(weights_nr)]  # dla każdego wejścia, jakie będzie (plus jeden) losujemy wagę początkową.
        # ostatnia waga nie odpowiada żadnemu wejściu! Jest to bias.

    def calculate_activation(self, input_data):
        self.last_input = input_data
        if (len(input_data) + 1) != len(self.weights):
            raise ValueError("Number of inputs is not compatible with the amount of weights.")
        sum = 0
        sum += self.weights[-1]  # dodajemy ostatnią wagę, która nie jest przyporządkowana wejściu
        for i in range(len(input_data)):
            sum += input_data[i] * self.weights[i]
        self.last_sum = sum
        if not self.is_finishing:
            return self.ReLU()
        else:
            return self.sigmoid()

    def ReLU(self):
        self.last_activation_value = np.maximum(self.last_sum, 0)
        return self.last_activation_value

    def ReLU_derivative(self):
        if self.last_sum > 0:
            return 1
        else:
            return 0

    def sigmoid(self):
        self.last_activation_value = 1 / (1 + np.exp(-self.last_sum))
        return self.last_activation_value


class Network:
    hidden_layer = []
    last_input = []
    last_output = []

    # output_neuron też będzie

    def __init__(self, hidden_neurons_nr):
        if 4096 % hidden_neurons_nr != 0:
            raise ValueError("Pixels should be equally distributed between neurons.")
        # nie tworzymy warstwy neuronów wejściowych, bo te nie dokonują żadnych obliczeń. Jedynie podają dalej wejście sieci
        self.hidden_layer = [Neuron(int(4096 / hidden_neurons_nr) * 3 + 1, False) for _ in
                             range(hidden_neurons_nr)]  # liczba połączeń: liczba całych pikseli*3 składowe + bias
        self.output_neuron = Neuron(hidden_neurons_nr + 1, True)

    def forward_propagation(self,
                            input_data):  # przepuszczenie przez sieć liczb wejściowych i zwrócenie pobudzenia ostatnich neuronów
        self.last_input = input_data
        layer_outputs = []
        numbers_amount_per_hidden_neuron = int(12288 / len(self.hidden_layer))
        fragment_start = 0
        for neuron in self.hidden_layer:
            input_data_fragment = input_data[fragment_start:(fragment_start + numbers_amount_per_hidden_neuron)]
            neuron.calculate_activation(input_data_fragment)
            layer_outputs.append(neuron.last_activation_value)
            fragment_start += numbers_amount_per_hidden_neuron
        self.output_neuron.calculate_activation(layer_outputs)
        return self.output_neuron.last_activation_value

    def backward_propagation(self, expected_output):  # obliczamy błędy dla wszystkich neuronów
        self.output_neuron.last_error = self.cost_calculation_finishing_neuron(expected_output)
        for n, neuron in enumerate(self.hidden_layer):
            neuron.last_error = self.cost_calculation_hidden_neuron(neuron, n)

    def cost_calculation_finishing_neuron(self, expected_output):
        return self.output_neuron.sigmoid() - expected_output  # dla neuronu kończącego jest to różnica faktycznego wyniku i oczekiwanego

    def cost_calculation_hidden_neuron(self, hidden_neuron, hidden_neuron_index_in_layer):
        return self.output_neuron.last_error * self.output_neuron.weights[
            hidden_neuron_index_in_layer] * hidden_neuron.ReLU_derivative()

    def gradient(self, previous_neuron_activation_value, this_neuron):
        return previous_neuron_activation_value * this_neuron.last_error

    def parameters_update(self, learning_rate):
        # najpierw aktualizujemy wagi, które łączą neurony wejściowe z ukrytymi
        for n, neuron in enumerate(self.hidden_layer):
            # aktualizacja wag dla wejść
            for i, input in enumerate(neuron.last_input):
                neuron.weights[i] = neuron.weights[i] - learning_rate * self.gradient(input, neuron)
            # aktualizacja wagi bias
            neuron.weights[-1] = neuron.weights[-1] - learning_rate * self.gradient(1, neuron)
            # teraz aktualizujemy wagi, które łączą neurony ukryte z neuronem wejściowym
        for i, input in enumerate(self.output_neuron.last_input):
            self.output_neuron.weights[i] = self.output_neuron.weights[i] - learning_rate * self.gradient(input,
                                                                                                          self.output_neuron)
        # aktualizacja wagi bias
        self.output_neuron.weights[-1] = self.output_neuron.weights[-1] - learning_rate * self.gradient(1,
                                                                                                        self.output_neuron)

    def prediction(self, input_data):
        result = self.forward_propagation(input_data)
        if result >= 0.5:  # zaokrąglamy prawdopodobieństwo do 1 lub 0, aby otrzymać etykietę klasy
            result = 1
        else:
            result = 0
        return result

    def training(self, pictures_list, class_labels, iterations, learning_rate):
        for iteration in range(iterations):
            chosen_picture_index = iteration % len(
                pictures_list)  # jeśli skończą się obrazy na liście, zaczynamy od początku
            picture = pictures_list[chosen_picture_index]
            picture = continuous_list(picture)
            self.last_output = self.prediction(picture)
            self.backward_propagation(class_labels[chosen_picture_index])
            self.parameters_update(learning_rate)

    def testing(self, test_pictures, class_labels):
        results = []
        for p, test_picture in enumerate(test_pictures):
            test_picture = continuous_list(test_picture)
            actual_output = self.prediction(test_picture)
            if actual_output == class_labels[p]:
                results.append("correct")
            else:
                results.append("incorrect")
        accuracy = results.count("correct") / len(results)
        return results, accuracy


def load_dataset():
    train_dataset = h5py.File('train_catvnoncat.h5', "r")
    train_images = np.array(train_dataset["train_set_x"][:])  # lista obrazów, które posłużą do uczenia modelu.
    train_class_affiliation = np.array(train_dataset["train_set_y"][
                                       :])  # lista wartości 1 lub 0 oznaczających bycie kotem lub nie dla obrazów treningowych

    # analogiczny zestaw danych, który posłuży do testowania modelu
    test_dataset = h5py.File('test_catvnoncat.h5', "r")
    test_images = np.array(test_dataset["test_set_x"][:])
    test_class_affiliation = np.array(test_dataset["test_set_y"][:])

    list_of_classes = np.array(test_dataset["list_classes"][:])

    return train_images, train_class_affiliation, test_images, test_class_affiliation, list_of_classes


def continuous_list(picture):
    result = []
    # tworzymy ciągłą listę składowych koloru
    for row in picture:
        for pixel in row:
            for color in pixel:
                result.append(color)
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("hidden_neurons_number")
    parser.add_argument("iterations_number")
    parser.add_argument("learning_rate")
    # args = parser.parse_args()
    print("Ładowanie datasetu...")
    train_images, train_class_affiliation, test_images, test_class_affiliation, list_of_classes = load_dataset()
    neural_network = Network(4096)
    print("Trenowanie sieci...")
    neural_network.training(train_images, train_class_affiliation, 208, 0.1)
    print("Testowanie sieci...")
    test_results, accuracy = neural_network.testing(test_images, test_class_affiliation)
    print("Skuteczność modelu: " + str(accuracy))

from matplotlib import pyplot as plt
import argparse

def round_2_digits(number):
    number = float(number)
    number *= 100
    number = round(number)
    number /= 100
    return number


train_points_x = []
train_points_y = []
test_points_x = []
test_points_y = []

parser = argparse.ArgumentParser()
parser.add_argument("hidden_neurons_number")
parser.add_argument("learning_rate")
args = parser.parse_args()
neurons = int(args.hidden_neurons_number)
rate = float(args.learning_rate)

train_file = open(f'output_{neurons}_{rate}.txt')
test_file = open(f'output_test_{neurons}_{rate}.txt')
train_lines = train_file.readlines()
test_lines = test_file.readlines()
for l in range(len(train_lines)):
    #treningowy
    line = train_lines[l].rstrip()
    line = line.split(";")
    train_points_x.append(line[0])
    train_points_y.append(round_2_digits(line[1]))
    #testowy
    line = test_lines[l].rstrip()
    line = line.split(";")
    test_points_x.append(line[0])
    test_points_y.append(round_2_digits(line[1]))
plt.plot(train_points_x, train_points_y, label="zbiór treningowy")
plt.plot(test_points_x, test_points_y, label="zbiór testowy")
plt.title(label=(f'{neurons} neuronów w warstwie ukrytej. Learning rate = {rate}'), loc='center')
plt.xlabel("Numer iteracji")
plt.ylabel("Koszt na obraz")
ticks = []
for number in train_points_x:
    if int(number) % 25 == 0:
        ticks.append(number)
plt.xticks(ticks)
plt.legend()
plt.savefig(f'wykres_{neurons}_{rate}.png')
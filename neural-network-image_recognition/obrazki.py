from PIL import Image
import numpy as np
import h5py

def load_dataset():
    train_dataset = h5py.File('train_catvnoncat.h5', "r")
    train_images = np.array(train_dataset["train_set_x"][:]) # lista obrazów, które posłużą do uczenia modelu. 
    train_class_affiliation = np.array(train_dataset["train_set_y"][:]) # lista wartości 1 lub 0 oznaczających bycie kotem lub nie dla obrazów treningowych

    # analogiczny zestaw danych, który posłuży do testowania modelu
    test_dataset = h5py.File('test_catvnoncat.h5', "r")
    test_images = np.array(test_dataset["test_set_x"][:])
    test_class_affiliation = np.array(test_dataset["test_set_y"][:])

    list_of_classes = np.array(test_dataset["list_classes"][:])
    
    return train_images, train_class_affiliation, test_images, test_class_affiliation, list_of_classes

train_images, train_class_affiliation, test_images, test_class_affiliation, list_of_classes = load_dataset()
print(test_class_affiliation)
rgb_array = np.array(test_images[18].flatten(), dtype=np.uint8)

# Utwórz obraz PIL na podstawie tablicy numpy
image = Image.fromarray(rgb_array.reshape((64, 64, 3)))

# Wyświetl obraz
image.show()

# Zapisz obraz do pliku
image.save("18obraz.png")
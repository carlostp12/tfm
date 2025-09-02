import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import make_blobs


def main():
    np.random.seed(0)

    cluster_1, _ = make_blobs(n_samples=100, centers=[[4, 4]], cluster_std=0.1) # high dense

    cluster_2, _ = make_blobs(n_samples=300, centers=[[10, 10]], cluster_std=2.5) # less dense

    X = np.vstack((cluster_1, cluster_2))

    plt.figure(figsize=(8, 6))
    plt.scatter(X[:, 0], X[:, 1], s=50, alpha=0.6)
    plt.title("Synthetic Data with Varying Density")
    plt.xlabel("Feature 1")
    plt.ylabel("Feature 2")
    plt.grid(True)
    plt.show()


if __name__ == '__main__':
    main()

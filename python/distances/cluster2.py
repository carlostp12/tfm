from sklearn.cluster import OPTICS
import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import make_blobs


def main():
    np.random.seed(0)

    cluster_1, _ = make_blobs(n_samples=100, centers=[[4, 4]], cluster_std=0.1)  # high dense

    cluster_2, _ = make_blobs(n_samples=300, centers=[[10, 10]], cluster_std=2.5)  # less dense

    X = np.vstack((cluster_1, cluster_2))

    optics = OPTICS(min_samples=3, max_eps=0.1)
    optics_labels = optics.fit_predict(X)

    plt.figure(figsize=(8, 6))
    scatter = plt.scatter(X[:, 0], X[:, 1], c=optics_labels, s=50, alpha=0.6, cmap='viridis')
    legend1 = plt.legend(*scatter.legend_elements(), title="Clusters")
    plt.gca().add_artist(legend1)
    plt.title('OPTICS Clustering')
    plt.xlabel('Feature 1')
    plt.ylabel('Feature 2')
    plt.grid(True)
    plt.show()


if __name__ == '__main__':
    main()
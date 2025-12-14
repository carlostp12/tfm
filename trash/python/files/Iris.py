import random

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import csv
from scipy.spatial.distance import pdist, squareform
from collections import OrderedDict
from itertools import combinations, product
from sklearn.cluster import SpectralClustering
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.semi_supervised import LabelPropagation
from sklearn import metrics
from sklearn import datasets
from sklearn.metrics import mean_squared_error, accuracy_score, mean_absolute_error, f1_score


def getDistCut(distList, distPercent):
    return max(distList) * distPercent / 100


def getRho(n, distMatrix, distCut):
    rho = np.zeros(n, dtype=float)
    for i in range(n - 1):
        for j in range(i + 1, n):
            rho[i] = rho[i] + np.exp(-(distMatrix[i, j] / distCut) ** 2)
            rho[j] = rho[j] + np.exp(-(distMatrix[i, j] / distCut) ** 2)
    return rho


def DPCA(n, distMatrix, rho, blockNum):
    rhoOrdIndex = np.flipud(np.argsort(rho))
    delta = np.zeros(n, dtype=float)
    leader = np.ones(n, dtype=int) * int(-1)
    maxdist = 0
    for ele in range(n):
        if distMatrix[rhoOrdIndex[0], ele] > maxdist:
            maxdist = distMatrix[rhoOrdIndex[0], ele]
    delta[rhoOrdIndex[0]] = maxdist
    for i in range(1, n):
        mindist = np.inf
        minindex = -1
        for j in range(i):
            if distMatrix[rhoOrdIndex[i], rhoOrdIndex[j]] < mindist:
                mindist = distMatrix[rhoOrdIndex[i], rhoOrdIndex[j]]
                minindex = rhoOrdIndex[j]
        delta[rhoOrdIndex[i]] = mindist
        leader[rhoOrdIndex[i]] = minindex
    gamma = delta * rho
    gammaOrdIdx = np.flipud(np.argsort(gamma))
    clusterIdx = np.ones(n, dtype=int) * (-1)
    for k in range(blockNum):
        clusterIdx[gammaOrdIdx[k]] = k
    for i in range(n):
        if clusterIdx[rhoOrdIndex[i]] == -1:
            clusterIdx[rhoOrdIndex[i]] = clusterIdx[leader[rhoOrdIndex[i]]]
    clusterSet = OrderedDict()
    for k in range(blockNum):
        clusterSet[k] = []
    for i in range(n):
        clusterSet[clusterIdx[i]].append(i)
    return clusterSet


def getDistanceMatrix(datas):
    N, D = np.shape(datas)
    dists = np.zeros([N, N])

    for i in range(N):
        for j in range(N):
            vi = datas[i, :]
            vj = datas[j, :]
            dists[i, j] = np.sqrt(np.dot((vi - vj), (vi - vj)))
    return dists


def select_dc(dists):
    N = np.shape(dists)[0]
    tt = np.reshape(dists, N * N)
    percent = 2.0
    position = int(N * (N - 1) * percent / 100)
    dc = np.sort(tt)[position + N]

    return dc


def get_density(dists, dc, method=None):
    N = np.shape(dists)[0]
    rho = np.zeros(N)

    for i in range(N):
        if method == None:
            rho[i] = np.where(dists[i, :] < dc)[0].shape[0] - 1
        else:
            rho[i] = np.sum(np.exp(-(dists[i, :] / dc) ** 2)) - 1
    return rho


def get_deltas(dists, rho):
    N = np.shape(dists)[0]
    deltas = np.zeros(N)
    nearest_neiber = np.zeros(N)

    index_rho = np.argsort(-rho)
    for i, index in enumerate(index_rho):

        if i == 0:
            continue

        index_higher_rho = index_rho[:i]

        deltas[index] = np.min(dists[index, index_higher_rho])

        index_nn = np.argmin(dists[index, index_higher_rho])
        nearest_neiber[index] = index_higher_rho[index_nn].astype(int)

    deltas[index_rho[0]] = np.max(deltas)
    return deltas, nearest_neiber


def find_centers_auto(rho, deltas):
    rho_threshold = (np.min(rho) + np.max(rho)) / 2
    delta_threshold = (np.min(deltas) + np.max(deltas)) / 2
    N = np.shape(rho)[0]

    centers = []
    for i in range(N):
        if rho[i] >= rho_threshold and deltas[i] > delta_threshold:
            centers.append(i)
    return np.array(centers)


def find_centers_K(rho, deltas, K):
    rho_delta = rho * deltas
    centers = np.argsort(-rho_delta)
    return centers[:K]


def cluster_PD(rho, centers, nearest_neiber):
    K = np.shape(centers)[0]
    if K == 0:
        print("can not find centers")
        return

    N = np.shape(rho)[0]
    labs = -1 * np.ones(N).astype(int)

    for i, center in enumerate(centers):
        labs[center] = i

    index_rho = np.argsort(-rho)
    for i, index in enumerate(index_rho):

        if labs[index] == -1:
            labs[index] = labs[int(nearest_neiber[index])]
    return labs


def draw_decision(rho, deltas, name="1.jpg"):
    plt.cla()
    for i in range(np.shape(datas)[0]):
        plt.scatter(rho[i], deltas[i], s=16., color=(0, 0, 0))
        plt.annotate(str(i), xy=(rho[i], deltas[i]), xytext=(rho[i], deltas[i]))
        plt.xlabel("rho")
        plt.ylabel("deltas")
    plt.savefig(name)
    plt.show()


def draw_cluster(datas, labs, centers, dic_colors, name="1.jpg"):
    plt.cla()
    K = np.shape(centers)[0]

    for k in range(K):
        sub_index = np.where(labs == k)
        sub_datas = datas[sub_index]
        plt.scatter(sub_datas[:, 0], sub_datas[:, 1], s=16., color=dic_colors[k])
        plt.scatter(datas[centers[k], 0], datas[centers[k], 1], color="k", marker="+", s=200.)
    plt.savefig(name)
    plt.show()


def generate_random_color():
    min = 0
    # The maximum intensity of the color space
    max = 255
    # Calculating 3 random values for each channel between min & max
    red = random.randint(min, max)/255
    green = random.randint(min, max)/255
    blue = random.randint(min, max)/255
    return (red, green, blue)


if __name__ == "__main__":


    l1 = range(87)
    dic_colors = dict()
    for i in l1:
        dic_colors[i] = generate_random_color()
    file_name = "DPCA"
    data_dir = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/'
    filename = data_dir + 'x_test.csv'

    #with open(r'../data/iris4.csv', 'r') as fc:
    with open(filename, 'r') as fc:
        reader = csv.reader(fc)
        lines1 = []
        for line in reader:
            lines1.append(line)
            print(line)
    lines = lines1[1:]
    datas = np.array(lines).astype(np.float32)
    dists = getDistanceMatrix(datas)
    dc = select_dc(dists)
    print("number", dc)
    rho = get_density(dists, dc, method="Gaussion")  # we can use other distance such as 'manhattan_distance'
    print("rho {} ".format(rho))
    deltas, nearest_neiber = get_deltas(dists, rho)
    print("deltas {} ".format(deltas))
    draw_decision(rho, deltas, name=file_name + "_decision.jpg")
    centers = find_centers_K(rho, deltas, 87)
    print("cluster-centers", centers)
    labs = cluster_PD(rho, centers, nearest_neiber)
    draw_cluster(datas, labs, centers, dic_colors, name=file_name + "_cluster-result.jpg")
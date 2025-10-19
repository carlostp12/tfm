import math

import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
import seaborn as sns
import sklearn
from sklearn.cluster import OPTICS, cluster_optics_dbscan
from scipy.integrate import quad
import matplotlib.gridspec as gridspec
import matplotlib.cm as cm

def integrate(redshift):
    i = quad(integrand, 0, redshift, args=())
    return i

def integrand(x):
    OMr = 0.0001
    OMm = 0.3
    OMv = 0.7
    return 1/(math.sqrt(OMr * (1+x)**4 + OMm * (1+x)**3 + OMv))

def main():
    print(integrate(0.0925))
    print('hi')

    filename = 'C:/desarrollo/astro/tfm/data/2dfgrs-title-dist.csv'
    dt = pd.read_csv(filename, encoding="ISO-8859-1")

    print(dt.head())
    dt_sample3 = dt[(dt['RAh'] <= 1) & (dt['RAh'] >= 0) & (dt['Ded'] >= -29) & (dt['Ded'] <= -27)]
    dt_sample3 = dt_sample3[dt_sample3['Z'] < 0.3]
    dt_sample3 = dt_sample3.rename(columns={'Z': 'redshift', 'SEQNUM': 'ID_2DF'})

    dt_sample3 = dt_sample3[['ID_2DF', 'x', 'y', 'z', 'redshift', "dist"]]

    dt_groups = pd.read_csv('C:/desarrollo/astro/tfm/data/group_members.csv')
    print(dt_sample3.head())
    print(dt_groups.head())
    sns.violinplot(y=dt_sample3["redshift"])

    plt.show()
    # dt_sample3 <-c & dt$RAh>=0 & dt$Ded>=-29 & dt$Ded<=-27,]

    result = pd.merge(dt_sample3, dt_groups, how="inner", on=[ "ID_2DF"])
    print(result.head())
    X = dt_sample3[[ 'x', 'y', 'z']]

    clust = OPTICS(min_samples=5, xi=0.05, min_cluster_size=5)
    clust.fit(X)

    labels1 = cluster_optics_dbscan(reachability = clust.reachability_,
                                    core_distances = clust.core_distances_,
                                    ordering = clust.ordering_, eps =0.001)

    print(labels1)

    n_clusters_ = len(set(labels1)) - (1 if -1 in labels1 else 0)
    n_noise_ = list(labels1).count(-1)

    print("Estimated number of clusters: %d" % n_clusters_)
    print("Estimated number of noise points: %d" % n_noise_)

    dt_sample3['cluster_id'] =  labels1
    #ddd = dt_sample3[dt_sample3['cluster_id'] == 220]

    #noise
    #len(dt_sample3[dt_sample3['cluster_id'] == -1])


###########################################################
    space = np.arange(len(X))
    reachability = clust.reachability_[clust.ordering_]
    labels = clust.labels_[clust.ordering_]

    plt.figure(figsize=(10, 7))
    G = gridspec.GridSpec(2, 3)
    ax1 = plt.subplot(G[0, :])
    colors = ["g.", "r.", "b.", "y.", "c."]
    colors = cm.rainbow(np.linspace(0, 1, len(labels)))
    for klass, color in enumerate(colors):
        Xk = space[labels == klass]
        Rk = reachability[labels == klass]
        ax1.plot(Xk, Rk, color, alpha=0.3)

    ax1.plot(space[labels == -1], reachability[labels == -1], "k.", alpha=0.3)
    ax1.plot(space, np.full_like(space, 0.001, dtype=float), "k-", alpha=0.5)
    ax1.plot(space, np.full_like(space, 0.0013, dtype=float), "k-.", alpha=0.5)
    ax1.set_ylabel("Reachability (epsilon distance)")
    ax1.set_title("Reachability Plot")

    # colors = ["g.", "r.", "b.", "y.", "c."]
    # OPTICS
    # for klass, color in enumerate(colors):
    #    Xk = X[clust.labels_ == klass]
    #    ax2.plot(Xk[:, 0], Xk[:, 1], color, alpha=0.3)

    # ax2.plot(X[clust.labels_ == -1, 0], X[clust.labels_ == -1, 1], "k+", alpha=0.1)
    # ax2.set_title("Automatic Clustering\nOPTICS")

    plt.tight_layout()
    plt.show()

    X = dt_sample3[[ 'x', 'y', 'z']]
    x = X['x']
    y = X['y']
    z = X['z']
    c_list = []
    plt.figure(figsize=(40, 40))
    ax = plt.axes(projection='3d')
    ax.scatter(x, y, z, c=labels1, cmap='viridis', linewidth=0.5)

    plt.show()
    print("ENDDD")




if __name__ == '__main__':
    main()

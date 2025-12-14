import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from dadapy import Data
from dadapy.plot import plot_SLAn, plot_MDS, plot_matrix, get_dendrogram, plot_DecGraph

#%load_ext autoreload
#%autoreload 2
#%matplotlib notebook
#%matplotlib inline


def save_data(X):
    data_dir = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/'
    filename = data_dir + 'x_test.csv'

    X.to_csv(filename)
    print("data saved")

def load_data_test():
    data_dir = 'C:/desarrollo/git/uoc/tfm/python/data/'
    filename = data_dir + 'x_test.csv'
    dt = pd.read_csv(filename, encoding="ISO-8859-1")
    return dt

def load_data():
    data_dir = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/'
    filename = data_dir + '2dfgrs-title-dist.csv'
    dt = pd.read_csv(filename, encoding="ISO-8859-1")

    dt_sample3 = dt[(dt['RAh'] <= 1) & (dt['RAh'] >= 0) &
                    (dt['Ded'] >= -29) & (dt['Ded'] <= -27)]
    dt_sample3 = dt_sample3[dt_sample3['Z'] < 0.3]
    dt_sample3 = dt_sample3.rename(columns={'Z': 'redshift', 'SEQNUM': 'ID_2DF'})
    dt_sample3 = dt_sample3[['ID_2DF', 'x', 'y', 'z', 'redshift', "dist"]]
    dt_groups = pd.read_csv(data_dir + 'groups/group_members.csv')
    result = pd.merge(dt_sample3, dt_groups, how="inner", on=["ID_2DF"])
    X = dt_sample3[['x', 'y', 'z']]
    print(X.head())
    print('OK')
    return X


def plot_data(X):
   f, ax = plt.subplots(1, 1, figsize=(7, 7), gridspec_kw={"hspace": 0.05, "wspace": 0})
   ax.yaxis.set_major_locator(plt.NullLocator())
   ax.xaxis.set_major_locator(plt.NullLocator())
   ax.set_title("2D scatter of the data")
   ax = plt.axes(projection='3d')
   ax.scatter(X['x'], X['y'], X['z'], c="black", cmap='viridis', linewidth=0.5)
   #ax.scatter(X['x'], X['y'], X['z'], s=15.0, alpha=1.0, c="black", linewidths=0.0)
   plt.show()

def compute_distances(X):
    print('OK')
    data = Data(X, verbose=True)
    data.compute_distances(maxk=100)
    data.compute_id_2NN()
    data.compute_density_kstarNN()

    #plot results:
    f, ax1 = plt.subplots(1, 1, figsize=(7, 7), gridspec_kw={"hspace": 0.05, "wspace": 0})
    ax1.set_title("Estimated log densities")
    ax1 = plt.axes(projection='3d')
    ax1.scatter(X[:,0], X[:,1], X[:,2], s=15.0, alpha=0.9, cc=data.log_den, cmap='viridis', linewidth=0.0)

    #plt.colorbar(fig2)
    plt.show()
def main():
    print('OK')



if __name__ == '__main__':
    x = load_data_test()
    print(x.to_numpy())
    #plot_data(x)
    compute_distances(x.to_numpy())
    #save_data(x)

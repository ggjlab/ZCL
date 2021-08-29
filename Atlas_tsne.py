import numpy as np
import scanpy as sc
import pandas as pd
import os
import pandas as pd
import gc
import dask.dataframe

sc.settings.verbosity = 3
sc.logging.print_header()
sc.settings.set_figure_params(dpi=300,dpi_save=600, facecolor='white')

adata=sc.read("raw.h5ad")
sc.pp.normalize_total(adata, target_sum=1e4)
sc.pp.log1p(adata)
sc.pp.highly_variable_genes(adata, min_mean=0.0125, max_mean=3, min_disp=0.5)
sc.pl.highly_variable_genes(adata)
adata.raw = adata
adata = adata[:, adata.var.highly_variable]
sc.pp.scale(adata, max_value=10)
sc.tl.pca(adata, svd_solver='arpack',n_comps=100)
sc.pp.neighbors(adata, n_neighbors=10, n_pcs=50)
sc.tl.leiden(adata, resolution=2)
sc.pl.tsne(adata, color=['leiden'],save='leiden_raw.pdf',legend_fontsize=5)
sc.tl.rank_genes_groups(adata, 'leiden', method='t-test',use)
result = adata.uns['rank_genes_groups']
groups = result['names'].dtype.names
pd.DataFrame(
    {group + '_' + key[:1]: result[key][group]
    for group in groups for key in ['names', 'logfoldchanges','scores', 'pvals_adj']}).to_csv("marker.csv")

adata.write('atlas.h5ad',compression=True)
import pandas as pd
import rasterio
import numpy as np
import os

from tqdm import tqdm

pnt_df = pd.read_excel(".xls')

mean_pre_list = []
cnt_list = []
for idx, row in tqdm(pnt_df.iterrows()):
    
    
    x, y, year = row['X'], row['Y'], row['die_time']
    year = int(year)
    val_list = []

    rt = int(row['RT']) + 1
    thre = row['Threshold']
    for next_year in range(year+1, year+rt):
        
        next_path = ' .tif'.format(next_year)
        
        if os.path.exists(next_path):
            
            with rasterio.open(next_path) as dst:
                
                row, col = rasterio.transform.rowcol(dst.transform, x, y)
                val = dst.read(1)[row, col]
                val_list.append(val)
    
    val_list = np.array(val_list)

    cnt = np.count_nonzero(val_list < thre)
    cnt_list.append(cnt)
    
    mean_val = np.nanmean(val_list)
    mean_pre_list.append(mean_val)

pnt_df['mean_pre'] = mean_pre_list
pnt_df['cnt'] = cnt_list

pnt_df.to_csv(' .csv')

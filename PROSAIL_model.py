# Planophile
import csv
import prosail
import numpy as np

# CSV文件名
csv_file = './Planophile.csv'

# 打开CSV文件准备写入
with open(csv_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    
    # 写入数据头部
    writer.writerow(['lai', 'ndvi', 'ndii'])

    # 循环遍历不同的 lai 值
    for lai_value in np.arange(0.01, 10.01, 0.01):
        # 运行 prosail 并获取 rho_canopy 结果
        rho_canopy = prosail.run_prosail(n=1.4, cab=40, car=8, cbrown=0, cw=0.02, cm=0.01, lai=lai_value, lidfa=1, hspot=0.15, tts=30, tto=45, psi=90, \
                        ant=0.0, alpha=40.0, prospect_version='5', typelidf=1, lidfb=0, \
                        factor='SDR', rsoil0=0.2, rsoil=None, psoil=None, \
                        soil_spectrum1=None, soil_spectrum2=None)
        
        # 将结果写入 CSV 文件
        
        
        
#         writer.writerow([round(lai_value, 1)]+ list(rho_canopy))
        
        mean_770_900 = np.mean(rho_canopy[770-400:900+1-400])
        mean_630_690 = np.mean(rho_canopy[630-400:690+1-400])
        mean_1550_1750 = np.mean(rho_canopy[1550-400:1750+1-400])
        ndvi = (mean_770_900 - mean_630_690) / (mean_770_900 + mean_630_690)
        ndii = (mean_770_900 - mean_1550_1750) / (mean_770_900 + mean_1550_1750)
        
        writer.writerow([round(lai_value, 2), ndvi, ndii])

        # 输出每隔0.1对应的结果
        print(f"lai={round(lai_value, 1)}: {rho_canopy}")

print("数据已保存到 CSV 文件，并输出每隔0.1对应的结果。")
